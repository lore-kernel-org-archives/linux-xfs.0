Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0ANJPUo013236 for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 17:19:25 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5BCF79825
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 15:19:24 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Gy8ZDWj8wpvBExPm for
	<xfs@oss.sgi.com>; Sat, 10 Jan 2009 15:19:24 -0800 (PST)
Message-ID: <49690F73.1070908@sandeen.net>
Date: Sat, 10 Jan 2009 15:13:23 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs with a 9TB realtime volume hangs
References: <alpine.DEB.2.00.0811141231390.23165@kurp.hut.fi>
In-Reply-To: <alpine.DEB.2.00.0811141231390.23165@kurp.hut.fi>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Jan Wagner <jwagner@kurp.hut.fi>
Cc: xfs@oss.sgi.com

Jan Wagner wrote:
> Hi,
> 
> I have a RAID0 with 11x750GB+1x1TB components in the following 
> partitionable-md test setup
> 
> root@abidal:~# cat /proc/partitions | grep md
>   254     0 9035047936 md_d0
>   254     1     124983 md_d0p1
>   254     2    1828125 md_d0p2
>   254     3    1953125 md_d0p3
>   254     4 9031141669 md_d0p4
> 
> Essentially, four partitions: 128MB, ~1.9GB, 2GB, 9TB. I'd like to use the 
> 1.9GB partition for xfs and put a realtime subvolume onto the same raid0 
> onto the 9TB partition. The partition tables are GDT instead of MBR to be 
> able to have >=2TB partitions.

Sorry for the slow/no reply.  It seems to be doing many calculations in
rtinit, haven't sorted out what yet, but it's not likely hung, it's
workin hard.  :)

If you give it a larger extsize it should go faster (if the larger
extsize is acceptable for your use...)

I tried a 4t realtime volume:

mkfs.xfs -dfile,name=fsfile,size=1g -rfile,name=rtfile,size=4t,extsize=$SIZE

for a few different extent sizes, and got

extsize	  time
-------	  ----
512k	  0.3s
256k	  0.7s
128k	  1.9s
 64k	  8.4s
 32k	 25.4s
 16k	129.4s

With the default 4k extent size this takes forever (the man page claims
default is 64k, maybe this got broken at some point).

Somebody will need to find time to look into what's going on.

I think it's doing lots of work in rtinit, something like

#0  xfs_rtfind_back (mp=0x7fffa69e2f30, tp=0x3afc8b0, start=115245056,
limit=0, rtblock=0x7fffa69e28b8) at xfs_rtalloc.c:83
#1  0x000000000041433c in xfs_rtfree_range (mp=0x7fffa69e2f30,
tp=0x3afc8b0, start=115245056, len=32768, rbpp=0x7fffa69e2908,
rsb=0x7fffa69e2910)
    at xfs_rtalloc.c:448
#2  0x00000000004144e4 in libxfs_rtfree_extent (tp=0x3afc8b0,
bno=115245056, len=32768) at xfs_rtalloc.c:756
#3  0x0000000000403a6b in parseproto (mp=0x7fffa69e2f30, pip=<value
optimized out>, fsxp=0x7fffa69e3240, pp=0x7fffa69e2ef0, name=<value
optimized out>)
    at proto.c:752
...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
