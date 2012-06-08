Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58DuKCD217110 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 08:56:21 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id tnmbxCH3FHEU0sWK for <xfs@oss.sgi.com>;
	Fri, 08 Jun 2012 06:56:19 -0700 (PDT)
Message-ID: <4FD20483.2080105@sandeen.net>
Date: Fri, 08 Jun 2012 08:56:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Repeated XFS corruption on RAID-10 on Adaptec 51245
References: <4FD1C9B8.70907@internet-sicherheit.de>
In-Reply-To: <4FD1C9B8.70907@internet-sicherheit.de>
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
To: "Christian J. Dietrich" <dietrich@internet-sicherheit.de>
Cc: xfs@oss.sgi.com

On 6/8/12 4:45 AM, Christian J. Dietrich wrote:
> 
> Hey all,
> 
> I have problems with an XFS volume. Upon discovering the message
> "kernel: XFS (sda3): corrupt inode 3714097 (bad size 16437 for local
> fork, size = 60)."
> I ran xfs_repair /dev/sda3 (/dev/sda3 was unmounted). It reported to
> have fixed some errors.
> However, after a while in normal operation, another XFS corruption
> occurred on /dev/sda3. I noticed that repeatedly calling xfs_repair will
> always report and fix new errors, even if the volume is not mounted in
> between, e.g., "rebuilding directory inode XXX" with different (new)
> values of XXX.
> 
> /dev/sda is a 12 TB RAID-10 volume on an Adaptec 51245 controller. All
> disks are online and none is reported faulty.
> 
> Naive, I would assume that running xfs_repair once would fix all errors.
> My guess is that the underlying RAID volume (Adaptec 51245 RAID 10) is
> somehow invalid (although I can not find any indicators confirming
> this). Any suggestions?

If you suspect a problem with repair, you can try:

# umount /dev/sda
# xfs_metadump -o /dev/sda - | xfs_mdrestore - filesystem.img
# xfs_repair filesystem.img
# xfs_repair filesystem.img

The image shouldn't take too much space, but 12T might take a little while
to dump.

If repair doesn't fix everything the first time please let us know.

> I am running CentOS 6.2 (=RHEL 6.2) with kernel
> 2.6.32-220.17.1.el6.x86_64 (most recent) and all OS updates installed.

please make sure that you aren't running the old kmod-xfs (or was it
xfs-kmod?) rpm.

-Eric

> Controller Firmware is the most recent (18948), driver version is 1.1-5.
> HDDs are 2x WD2001FASS, 10x WD2002FAEX.
> 
> Thanks in advance,
> Chris
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
