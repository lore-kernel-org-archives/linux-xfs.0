Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nATNQrPb113027 for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 17:26:53 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40EA318F55C1
	for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 15:27:20 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	Xeuf6CACb5NhXQwg for <xfs@oss.sgi.com>;
	Sun, 29 Nov 2009 15:27:20 -0800 (PST)
Date: Mon, 30 Nov 2009 10:27:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS & LVM: unexpected cp when issuing mv
Message-ID: <20091129232716.GC30608@discord.disaster>
References: <200911291452.20646@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200911291452.20646@zmi.at>
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

On Sun, Nov 29, 2009 at 02:52:16PM +0100, Michael Monnerie wrote:
> I have an unexpected behaviour and I hope someone can explain me the 
> reasons:
> 
> This is an openSUSE 11.2 virtual machine within XENserver. XENserver can 
> only create 2TB disks, but I needed more. So I create 2x 2TB disks for 
> that VM. These disks have no partitions, but are straight LVM:
> # pvscan
>   PV /dev/xvdb   VG sharestore   lvm2 [1,95 TB / 0    free]
>   PV /dev/xvdc   VG sharestore   lvm2 [1,95 TB / 0    free]
>   Total: 2 [3,91 TB] / in use: 2 [3,91 TB] / in no VG: 0 [0   ]
> 
> I created one VG, and then one LV:
> # vgscan
>   Reading all physical volumes.  This may take a while...
>   Found volume group "sharestore" using metadata type lvm2
> # lvscan
>   ACTIVE            '/dev/sharestore/public' [3,91 TB] inherit
> 
> On that LV, I created an XFS filesystem, mounted from /etc/fstab:
> /dev/sharestore/public /disks/sharestore  xfs        
> noatime,nodiratime,logbufs=8,logbsize=256k,attr2,nobarrier,largeio,swalloc,inode64,prjquota

You are using project quotas.

> Now when I move from one dir to another, example
> mv /disks/sharestore/upload/* /disks/sharestore/download/
> 
> within some dirs it's a simple mv where only metadata is moved, but with 
> some dirs it's a physical cp+rm of the files. You can easily see that by 
> the speed of the mv, plus with iostat:
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-
> sz avgqu-sz   await  svctm  %util
> xvdb              0,00     0,00    0,00  647,31     0,00 28424,75    
> 87,82    18,46   29,71   0,24  15,65
> xvdc              0,00     0,40  631,14    2,40 26928,54    76,65    
> 85,25     5,56    8,69   1,56  98,84
> 
> Until now I believed that a mv within one filesystem is always just a 
> metadata mv. But it seems I found a case now where even within the same 
> filesystem a physical cp+rm is done. Can someone explain me
> 
> 1) why this happens

It happens if you move from one project directory heirarchy to
another - rename is not allowed across project quota boundaries as
the moved data has to be correctly attributed to the new project.
Hence it causes a mv to do a copy/unlink by returning a EXDEV error
to the rename.

> 2) how I can prevent this?

You can't if you are moving from one project to another. If you
move within the project heirarchy, then it will be a rename as per
normal.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
