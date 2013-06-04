Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 955817F4E
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 23:48:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 612358F8039
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 21:48:22 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id ECYvLAh2L2QJHyNE for
	<xfs@oss.sgi.com>; Mon, 03 Jun 2013 21:48:21 -0700 (PDT)
Date: Tue, 4 Jun 2013 00:48:18 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <78208280.11075201.1370321298481.JavaMail.root@redhat.com>
In-Reply-To: <20130604043610.GH29466@dastard>
References: <1871204531.7584919.1367826613792.JavaMail.root@redhat.com>
	<5187BEA5.4040107@sandeen.net>
	<647316680.8155487.1367913231441.JavaMail.root@redhat.com>
	<51895115.90108@sandeen.net>
	<131268379.10596360.1370246946902.JavaMail.root@redhat.com>
	<20130604043610.GH29466@dastard>
Subject: Re: 3.9.0: XFS rootfs corruption
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Eric Sandeen" <sandeen@sandeen.net>, xfs@oss.sgi.com
> Sent: Tuesday, June 4, 2013 12:36:10 PM
> Subject: Re: 3.9.0: XFS rootfs corruption
> 
> On Mon, Jun 03, 2013 at 04:09:06AM -0400, CAI Qian wrote:
> [snip]
> 
> > :/# xfs_repair -L  /dev/mapper/rhel_ibm--p720--01--lp4-root
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> ....
> 
> Now that you've repaired the filesystem, can you reproduce the
> problem?
> 
> It looks somewhat like the same bug we fixed in 3.8-rc4 that Dave
> Jones hit (37f1356 xfs: recalculate leaf entry pointer after
> compacting a dir2 block), but if you've never repaired the damage on
> disk that this problem caused then you'll just keep tripping over
> it.
> 
> So, can you reproduce the problem now on this machine/filesystem?
After repaired, the system can be booted up successfully. If I want
to corrupt it again, I suppose I'll need to re-run the workload, i.e.,
1) trinity
2) xfstests
3) kdump reboot.
CAI Qian
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
