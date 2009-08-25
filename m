Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7PFqUSN211723 for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 10:52:41 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7978C152E7F6
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 08:52:58 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id l47JOrqv2Lz9Ab92 for
	<xfs@oss.sgi.com>; Tue, 25 Aug 2009 08:52:58 -0700 (PDT)
Message-ID: <4A9408C4.3050507@sandeen.net>
Date: Tue, 25 Aug 2009 08:52:36 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs logbufs default, (also noatime,
	lazy-count(of partition formatter)...32767b v. 32768b...
References: <4A92E922.2030404@tlinx.org>
In-Reply-To: <4A92E922.2030404@tlinx.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Linda A. Walsh wrote:
> Is there a reason why logbufs=8 should't become the default?
> Isn't it the best choice for most users given today's memory
> constraints (or lack thereof?)

It is the default:

#define XLOG_MAX_ICLOGS		8

         if (mp->m_logbufs <= 0)
                 log->l_iclog_bufs = XLOG_MAX_ICLOGS;


> I saw a message about xfs parameter tuning and still see the mention to:
> 'logbufs=8,noatime' having to be specified on every mount.

you can't believe everything you read on the internets ;)

> If the desire is to provide default optimal tuning, maybe a default of 
> logbufs to 8 would be a good idea, and maybe a
> mkfs flag to default to 'noatime' and a 64MB internal log
> size would be good ideas for *most* users?

noatime is something a user should choose based on their needs, not a 
default.  Some things depend on atime, and noatime isn't really 
posix-compliant...

Log size depends on the fs size...

> How much of problem is defaulting to a 64MB internal log
> size when file partitions are measured in the 100GB range?

                 /*
                  * With a 2GB max log size, default to maximum size
                  * at 4TB. This keeps the same ratio from the older
                  * max log size of 128M at 256GB fs size. IOWs,
                  * the ratio of fs size to log size is 2048:1.
                  */

100*1024/2048
50

so it currently scales to 50M for 100G.

> I'm not sure how much use it is to even remember typing lazy-count=1
> on the size partition each time.

lazy-count will/should be the default soon; someone (me) just needs to 
make xfstests cope with the change first.

> One more 'nit', while I think of it...for a 64MB log buffer size,
> one should be able to specify 32768b, but last I tried, that gave
> a 'too large' error...isn't 32768*4=64MB, not 32767b?

seems fine?

$ /sbin/mkfs.xfs -dfile,name=fsfile,size=100g -lsize=32768b
meta-data=fsfile                isize=256    agcount=4, agsize=6553600 blks
          =                      sectsz=512   attr=2
data     =                      bsize=4096   blocks=26214400, imaxpct=25
          =                      sunit=0      swidth=0 blks
naming   =version 2             bsize=4096   ascii-ci=0
log      =internal log          bsize=4096   blocks=32768, version=2
          =                      sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                  extsz=4096   blocks=0, rtextents=0

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
