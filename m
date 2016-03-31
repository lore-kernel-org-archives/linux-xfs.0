Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 488627CA0
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 14:49:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1AE75304032
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 12:48:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id IEsfELjAbzYx7tD5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2016 12:48:54 -0700 (PDT)
Date: Thu, 31 Mar 2016 12:52:12 -0700
From: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: fallocate mode flag for "unshare blocks"?
Message-ID: <20160331195212.GB1415@localhost.localdomain>
References: <20160302155007.GB7125@infradead.org>
	<20160330182755.GC2236@birch.djwong.org>
	<20160331003242.GA5813@localhost.localdomain>
	<56FD079F.3060606@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56FD079F.3060606@gmail.com>
Reply-To: bo.li.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Thu, Mar 31, 2016 at 07:18:55AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-03-30 20:32, Liu Bo wrote:
> >On Wed, Mar 30, 2016 at 11:27:55AM -0700, Darrick J. Wong wrote:
> >>Hi all,
> >>
> >>Christoph and I have been working on adding reflink and CoW support to
> >>XFS recently.  Since the purpose of (mode 0) fallocate is to make sure
> >>that future file writes cannot ENOSPC, I extended the XFS fallocate
> >>handler to unshare any shared blocks via the copy on write mechanism I
> >>built for it.  However, Christoph shared the following concerns with
> >>me about that interpretation:
> >>
> >>>I know that I suggested unsharing blocks on fallocate, but it turns out
> >>>this is causing problems.  Applications expect falloc to be a fast
> >>>metadata operation, and copying a potentially large number of blocks
> >>>is against that expextation.  This is especially bad for the NFS
> >>>server, which should not be blocked for a long time in a synchronous
> >>>operation.
> >>>
> >>>I think we'll have to remove the unshare and just fail the fallocate
> >>>for a reflinked region for now.  I still think it makes sense to expose
> >>>an unshare operation, and we probably should make that another
> >>>fallocate mode.
> >
> >I'm expecting fallocate to be fast, too.
> >
> >Well, btrfs fallocate doesn't allocate space if it's a shared one
> >because it thinks the space is already allocated.  So a later overwrite
> >over this shared extent may hit enospc errors.
> And this _really_ should get fixed, otherwise glibc will add a check for
> running posix_fallocate against BTRFS and force emulation, and people _will_
> complain about performance.

Even if glibc adds a check like that and emulates fallocate by writing
zero to real blocks, btrfs still does cow and requests to allocate space
for new writes, so it's not only performance, but also getting ENOSPC in
extremely case though.

Thanks,

-liubo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
