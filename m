Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6640A111E
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 03:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KwTgf6ra"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6cebcf8a48aso171073b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 19:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702610106; x=1703214906; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3XSr0DsbceYdFnNAdf0a1lLPpDFEtWjXHycTkIhOzfk=;
        b=KwTgf6raZCX33zuAXiRfuds2trjtjJ3ZEX3lZXwh6907RL/N8PoeZJON5SNg+6N9Ef
         UoVYZkarv+8WMfO+A769OpyfjEdwsQfsvCdVSRUJsiSLr4swyJb3RE+kcjxXlFMKe+yT
         vHKqnDc52nPXsM0ZlLvTGsnwcF9RExc/SyjY+qYXpsk844TCEfFein4RLgkkWbJjKrCM
         Bw2jH3wTyBRWQlm6n+Cpk81o86Gdf5ilva3g94r125rvDng86MA+j61d9LUk2VxkfBhU
         m0etCqFEImcIC5DIFw5dUw+gOblnZ5fbVJI3GVOlE3EgqfA+XqiewhvXwJcxyV7EvomA
         bFow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702610106; x=1703214906;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3XSr0DsbceYdFnNAdf0a1lLPpDFEtWjXHycTkIhOzfk=;
        b=im30OqwoavsL8WfnHCUEcBiHqeiIS5qk6ePn/YdUw5iNJaB4bv8X/Xq8Z9z/OLWOh4
         QV6+YjOIOHIpPJ31eFW70aiY20iDG8sOWjnFeWjJBHriTedDp7VjwoWbb7pLzlGbm2K5
         Z3mVdbcBCU3dFwZJlN0CtOAqBoDRlcG2POj/p0CZ0M08JMMbqziWZgB7IDziLz7ZG3Oo
         Xmf3/AZ03vn5h0Gjz1Jhryd4sRJEPZs/Bgbsg+E2wxBBb32Duj8enJD7xzDAWslIw32k
         LZHdwj9RKodzYXBUDX4AdXZRqA4Vflx4MAAkAi137Bkn2C1KZbGtBx7Xh84jE6UUq1uT
         gwhw==
X-Gm-Message-State: AOJu0Yy6T/XExA/k0Lp3AiVFiPaovM7jF2GUi7yKk/I4zBxYwDRky3Va
	ZXSHbFa/+XOMX9V76JLL74v4sDqYEoBRYQSMz6g=
X-Google-Smtp-Source: AGHT+IEShA0lKUvgJrBGYnvAE5gb3wrTkJhllQzpYeonmkAU/tb3M38rIYVk52f3QOrkGH2WWReU7g==
X-Received: by 2002:a05:6a00:194d:b0:6ce:4927:2811 with SMTP id s13-20020a056a00194d00b006ce49272811mr12866594pfk.22.1702610106230;
        Thu, 14 Dec 2023 19:15:06 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id z17-20020aa78891000000b006cdcfe985f2sm12818461pfe.145.2023.12.14.19.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 19:15:05 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rDyfG-008TH3-1y;
	Fri, 15 Dec 2023 14:15:02 +1100
Date: Fri, 15 Dec 2023 14:15:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Wengang Wang <wen.gang.wang@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/9] xfs file non-exclusive online defragment
Message-ID: <ZXvEtvRm1rkT03Sb@dread.disaster.area>
References: <20231214170530.8664-1-wen.gang.wang@oracle.com>
 <20231214213502.GI361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231214213502.GI361584@frogsfrogsfrogs>

On Thu, Dec 14, 2023 at 01:35:02PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 14, 2023 at 09:05:21AM -0800, Wengang Wang wrote:
> > Background:
> > We have the existing xfs_fsr tool which do defragment for files. It has the
> > following features:
> > 1. Defragment is implemented by file copying.
> > 2. The copy (to a temporary file) is exclusive. The source file is locked
> >    during the copy (to a temporary file) and all IO requests are blocked
> >    before the copy is done.
> > 3. The copy could take long time for huge files with IO blocked.
> > 4. The copy requires as many free blocks as the source file has.
> >    If the source is huge, say it’s 1TiB,  it’s hard to require the file
> >    system to have another 1TiB free.
> > 
> > The use case in concern is that the XFS files are used as images files for
> > Virtual Machines.
> > 1. The image files are huge, they can reach hundreds of GiB and even to TiB.
> > 2. Backups are made via reflink copies, and CoW makes the files badly fragmented.
> > 3. fragmentation make reflink copies super slow.
> > 4. during the reflink copy, all IO requests to the file are blocked for super
> >    long time. That makes timeout in VM and the timeout lead to disaster.
> > 
> > This feature aims to:
> > 1. reduce the file fragmentation making future reflink (much) faster and
> > 2. at the same time,  defragmentation works in non-exclusive manner, it doesn’t
> >    block file IOs long.
> > 
> > Non-exclusive defragment
> > Here we are introducing the non-exclusive manner to defragment a file,
> > especially for huge files, without blocking IO to it long. Non-exclusive
> > defragmentation divides the whole file into small pieces. For each piece,
> > we lock the file, defragment the piece and unlock the file. Defragmenting
> > the small piece doesn’t take long. File IO requests can get served between
> > pieces before blocked long.  Also we put (user adjustable) idle time between
> > defragmenting two consecutive pieces to balance the defragmentation and file IOs.
> > So though the defragmentation could take longer than xfs_fsr,  it balances
> > defragmentation and file IOs.
> 
> I'm kinda surprised you don't just turn on alwayscow mode, use an
> iomap_funshare-like function to read in and dirty pagecache (which will
> hopefully create a new large cow fork mapping) and then flush it all
> back out with writeback.  Then you don't need all this state tracking,
> kthreads management, and copying file data through the buffer cache.
> Wouldn't that be a lot simpler?

Hmmm. I don't think it needs any kernel code to be written at all.
I think we can do atomic section-by-section, crash-safe active file
defrag from userspace like this:

	scratch_fd = open(O_TMPFILE);
	defrag_fd = open("file-to-be-dfragged");

	while (offset < target_size) {

		/*
		 * share a range of the file to be defragged into
		 * the scratch file.
		 */
		args.src_fd = defrag_fd;
		args.src_offset = offset;
		args.src_len = length;
		args.dst_offset = offset;
		ioctl(scratch_fd, FICLONERANGE, args);

		/*
		 * For the shared range to be unshared via a
		 * copy-on-write operation in the file to be
		 * defragged. This causes the file needing to be
		 * defragged to have new extents allocated and the
		 * data to be copied over and written out.
		 */
		fallocate(defrag_fd, FALLOC_FL_UNSHARE_RANGE, offset, length);
		fdatasync(defrag_fd);

		/*
		 * Punch out the original extents we shared to the
		 * scratch file so they are returned to free space.
		 */
		fallocate(scratch_fd, FALLOC_FL_PUNCH, offset, length);

		/* move onto next region */
		offset += length;
	};

As long as the length is large enough for the unshare to create a
large contiguous delalloc region for the COW, I think this would
likely acheive the desired "non-exclusive" defrag requirement.

If we were to implement this as, say, and xfs_spaceman operation
then all the user controlled policy bits (like inter chunk delays,
chunk sizes, etc) then just becomes command line parameters for the
defrag command...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
