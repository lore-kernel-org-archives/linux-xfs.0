Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04FEA7F55
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:02:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E70938F8035
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 05:02:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wzFuyrSAdJah751a (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 05:02:49 -0800 (PST)
Date: Tue, 3 Nov 2015 08:02:46 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Is it possible to change sunit of log section post-mkfs
Message-ID: <20151103130246.GA24445@bfoster.bfoster>
References: <5638A62D.1020802@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5638A62D.1020802@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 03, 2015 at 01:18:53PM +0100, Michael Weissenbacher wrote:
> Hi!
> I have a XFS file system which lies on a 10-disk RAID-6 device that was
> created with Chunk Size = 1MiB.
> On mkfs.xfs time this was - as far as i know - specified with "-d
> su=1m,sw=8".
> 
> xfs_info shows the following:
> meta-data=/dev/sdb1              isize=256    agcount=15,
> agsize=268435200 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=3905945088, imaxpct=5
>          =                       sunit=256    swidth=2048 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Interestingly, the sunit value of the log seems to be incorrect - as it
> should be 256 too, like the sunit value of the data. I am pretty sure
> the reason is that the log sunit cannot be 256 blks (=1024KiB) and
> because of this mkfs.xfs did fall back to the default of 8 blks
> (=32KiB). I found evidence of this in the following thread:
> http://oss.sgi.com/archives/xfs/2012-06/msg00431.html
> 
> What i want to achieve is to set the log sunit to the maximum possible
> of 64 blks (=256KiB).
> 
> - Is that even possible without doing mkfs.xfs (and losing all data)?
> - Would it be an improvement performance-wise?
> - Would changing to an external log help?
> 

I don't believe there's any supported way to do this. Out of curiosity,
I just tried an experiment to modify the superblock logsunit via xfs_db
and run repair to zero the log. That seemed to work in terms of taking
effect on the subsequent mount, but that's certainly not something I
would suggest to do in production. Note that mkfs aligns the physical
log based on the stripe unit as well, so it wouldn't really have the
same effect anyways.

Brian

> tia,
> Michael
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
