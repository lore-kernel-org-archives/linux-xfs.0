Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VMXveS086706 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:33:57 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DB9C4096F
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 15:34:35 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id xZVkaIkgXEz4zvjC for
	<xfs@oss.sgi.com>; Tue, 31 Aug 2010 15:34:35 -0700 (PDT)
Date: Wed, 1 Sep 2010 08:34:28 +1000 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <1177874643.527261283294068615.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <201009010007.23899@zmi.at>
Subject: Re: 4K drives, sectsz=512, bsize=4096
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com


----- "Michael Monnerie" <michael.monnerie@is.it-management.at> wrote:

> On Dienstag, 31. August 2010 Eric Sandeen wrote:
> > If you do it right (and especially vs. if you do it wrong) it
> > should be a bit faster if all IOs are 4k aligned on the disk.
>  
> And that's what's interesting me: why? Won't XFS do all I/Os at
> minimum 
> for a given block size? Or is it possible XFS does write only a single
> sector? I'd expect the smallest I/O size to be the block size, but it
> seems I'm wrong?

Log I/O and direct writes are sector sized & aligned.

> I guess there's no way to "convert" an existing XFS with 
> sectsz=512,bsize=4096 to sectsz=4096,bsize=4096? Maybe that's only a 
> flag that can be changed?

There's no way (other than dump, mkfs & restore), the filesystem is laid
out differently (most data structures, like superblocks and other metadata
become 4K aligned).

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
