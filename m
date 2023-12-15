Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD704185F
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f62h06SV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672E7C433C7;
	Fri, 15 Dec 2023 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702661420;
	bh=x1uAUiqC6zSOitHtEFPlffYivgTBoBPWyGjAAdZD4uo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f62h06SVNPJIjpX53wx4CfvJm/2TL44nZy39wZIsFxLf2MJAXgHTd11LuiH7M6fCE
	 HfQz7u1thvGtb71rGDjj8YKxjhTjc1/rpM1SUpX4bsLzV4FLjbVlZObQGhPql58kM3
	 VKoymoeSQJL5aUz6NHmYvEme+SS0fI9GaTms8n+7F4OCmdVX0yMrPRbfcWp0ckpbyF
	 gVjku7FywCMO53JzU+iEwGHT1m/E8NY6OCFrdQcqINMKsWDOPcOtxO8WaiH9zgKiiV
	 6OR4eFX2el2IaeJEdnkzbPwwsewAzK/IaBoQQzNDP6DFlh18k6SUnBHwnP+GaI7wiA
	 c5lCELn+G/FTg==
Date: Fri, 15 Dec 2023 09:30:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/9] xfs file non-exclusive online defragment
Message-ID: <20231215173019.GO361584@frogsfrogsfrogs>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
 <20231214213502.GI361584@frogsfrogsfrogs>
 <ZXvEtvRm1rkT03Sb@dread.disaster.area>
 <97269730-511F-438B-9840-59CAF7997FC2@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97269730-511F-438B-9840-59CAF7997FC2@oracle.com>

On Fri, Dec 15, 2023 at 05:07:36PM +0000, Wengang Wang wrote:
> 
> 
> > On Dec 14, 2023, at 7:15 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Thu, Dec 14, 2023 at 01:35:02PM -0800, Darrick J. Wong wrote:
> >> On Thu, Dec 14, 2023 at 09:05:21AM -0800, Wengang Wang wrote:
> >>> Background:
> >>> We have the existing xfs_fsr tool which do defragment for files. It has the
> >>> following features:
> >>> 1. Defragment is implemented by file copying.
> >>> 2. The copy (to a temporary file) is exclusive. The source file is locked
> >>>   during the copy (to a temporary file) and all IO requests are blocked
> >>>   before the copy is done.
> >>> 3. The copy could take long time for huge files with IO blocked.
> >>> 4. The copy requires as many free blocks as the source file has.
> >>>   If the source is huge, say it’s 1TiB,  it’s hard to require the file
> >>>   system to have another 1TiB free.
> >>> 
> >>> The use case in concern is that the XFS files are used as images files for
> >>> Virtual Machines.
> >>> 1. The image files are huge, they can reach hundreds of GiB and even to TiB.
> >>> 2. Backups are made via reflink copies, and CoW makes the files badly fragmented.
> >>> 3. fragmentation make reflink copies super slow.
> >>> 4. during the reflink copy, all IO requests to the file are blocked for super
> >>>   long time. That makes timeout in VM and the timeout lead to disaster.
> >>> 
> >>> This feature aims to:
> >>> 1. reduce the file fragmentation making future reflink (much) faster and
> >>> 2. at the same time,  defragmentation works in non-exclusive manner, it doesn’t
> >>>   block file IOs long.
> >>> 
> >>> Non-exclusive defragment
> >>> Here we are introducing the non-exclusive manner to defragment a file,
> >>> especially for huge files, without blocking IO to it long. Non-exclusive
> >>> defragmentation divides the whole file into small pieces. For each piece,
> >>> we lock the file, defragment the piece and unlock the file. Defragmenting
> >>> the small piece doesn’t take long. File IO requests can get served between
> >>> pieces before blocked long.  Also we put (user adjustable) idle time between
> >>> defragmenting two consecutive pieces to balance the defragmentation and file IOs.
> >>> So though the defragmentation could take longer than xfs_fsr,  it balances
> >>> defragmentation and file IOs.
> >> 
> >> I'm kinda surprised you don't just turn on alwayscow mode, use an
> >> iomap_funshare-like function to read in and dirty pagecache (which will
> >> hopefully create a new large cow fork mapping) and then flush it all
> >> back out with writeback.  Then you don't need all this state tracking,
> >> kthreads management, and copying file data through the buffer cache.
> >> Wouldn't that be a lot simpler?
> > 
> > Hmmm. I don't think it needs any kernel code to be written at all.
> > I think we can do atomic section-by-section, crash-safe active file
> > defrag from userspace like this:
> > 
> > scratch_fd = open(O_TMPFILE);
> > defrag_fd = open("file-to-be-dfragged");
> > 
> > while (offset < target_size) {
> > 
> > /*
> >  * share a range of the file to be defragged into
> >  * the scratch file.
> >  */
> > args.src_fd = defrag_fd;
> > args.src_offset = offset;
> > args.src_len = length;
> > args.dst_offset = offset;
> > ioctl(scratch_fd, FICLONERANGE, args);
> > 
> > /*
> >  * For the shared range to be unshared via a
> >  * copy-on-write operation in the file to be
> >  * defragged. This causes the file needing to be
> >  * defragged to have new extents allocated and the
> >  * data to be copied over and written out.
> >  */
> > fallocate(defrag_fd, FALLOC_FL_UNSHARE_RANGE, offset, length);
> > fdatasync(defrag_fd);
> > 
> > /*
> >  * Punch out the original extents we shared to the
> >  * scratch file so they are returned to free space.
> >  */
> > fallocate(scratch_fd, FALLOC_FL_PUNCH, offset, length);

You could even set args.dst_offset = 0 and ftruncate here.

But yes, this is a better suggestion than adding more kernel code.

> > /* move onto next region */
> > offset += length;
> > };
> > 
> > As long as the length is large enough for the unshare to create a
> > large contiguous delalloc region for the COW, I think this would
> > likely acheive the desired "non-exclusive" defrag requirement.
> > 
> > If we were to implement this as, say, and xfs_spaceman operation
> > then all the user controlled policy bits (like inter chunk delays,
> > chunk sizes, etc) then just becomes command line parameters for the
> > defrag command...
> 
> 
> Ha, the idea from user space is very interesting!
> So far I have the following thoughts:
> 1). If the FICLONERANGE/FALLOC_FL_UNSHARE_RANGE/FALLOC_FL_PUNCH works
> on a FS without reflink enabled.

It does not.

That said, for your usecase (reflinked vm disk images that fragment over
time) that won't be an issue.  For non-reflink filesystems, there's
fewer chances for extreme fragmentation due to the lack of COW.

> 2). What if there is a big hole in the file to be defragmented? Will
> it cause block allocation and writing blocks with zeroes.

FUNSHARE ignores holes.

> 3). In case a big range of the file is good (not much fragmented), the
> ‘defrag’ on that range is not necessary.

Yep, so you'd have to check the bmap/fiemap output first to identify
areas that are more fragmented than you'd like.

> 4). The use space defrag can’t use a try-lock mode to make IO requests
> have priorities. I am not sure if this is very important.
> 
> Maybe we can work with xfs_bmap to get extents info and skip good
> extents and holes to help case 2) and 3).

Yeah, that sounds necessary.

--D

> I will figure above out.
> Again, the idea is so amazing, I didn’t reallize it.
> 
> Thanks,
> Wengang
> 
