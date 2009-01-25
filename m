Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0PCAVZR122274 for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 06:10:31 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC16FB5DAF
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 04:09:47 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id GMj9wV3r5YeHy2qp for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 04:09:47 -0800 (PST)
Date: Sun, 25 Jan 2009 07:09:15 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
In-Reply-To: <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0901250705300.6888@p34.internal.lan>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan>
	<20090125110742.4ba54c0b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
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
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Sun, 25 Jan 2009, Alan Cox wrote:

> Easiest is to use labels. Old ide will keep hda,b,c,d constant
> providing you have interfaces using the legacy IDE port mappings (0x1f0
> and 0x170). Libata doesn't do that as pretty much every distribution had
> already switched to volume labels, and the user space can do the job far
> better than the kernel - especially as the newer devices with modern
> interfaces don't have the old BIOS/DOS legacy ideas any more.
>
> Mount by label also means you can flip back and forth between the
> different drivers and kernel revisions.
>
> Alan
>

That works well with ext* filesystems as one can set it anytime with 
e2label if I recall; however, how can one do this with XFS, is it 
possible without booting off a boot-cd etc?

Here is the filesystem information:
p254:~# xfs_info /dev/sdd2
meta-data=/dev/root              isize=256    agcount=16, agsize=1186676 blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=18986816, imaxpct=25
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096 
log      =internal               bsize=4096   blocks=9270, version=1
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0

When I try to label it:
p254:~# xfs_admin -L "root" /dev/sdd2
xfs_admin: /dev/sdd2 contains a mounted filesystem

fatal error -- couldn't initialize XFS library

The label is currently not set:
p254:~# xfs_admin -l  /dev/sdd2
label = ""
p254:~#

I guess my next step is to try UUID?

        Instead of giving the device explicitly, one may indicate the (ext2  or
        xfs)  filesystem that is to be mounted by its UUID or volume label (cf.
        e2label(8) or  xfs_admin(8)),  writing  LABEL=<label>  or  UUID=<uuid>,
        e.g.,   `LABEL=Boot'   or  `UUID=3e6be9de-8139-11d1-9106-a43f08d823a6'.
        This will make the system more robust: adding or removing a  SCSI  disk
        changes the disk device name but not the filesystem volume label.

p254:~# xfs_admin -U generate /dev/sdd2
xfs_admin: /dev/sdd2 contains a mounted filesystem

fatal error -- couldn't initialize XFS library
p254:~#

Hmm, am I out of luck?

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
