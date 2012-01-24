Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O4pOC6191050 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 22:51:24 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id xBZUL6CbgdT6Kw7B for <xfs@oss.sgi.com>;
	Mon, 23 Jan 2012 20:51:22 -0800 (PST)
Message-ID: <4F1E38C9.3070000@sandeen.net>
Date: Mon, 23 Jan 2012 22:51:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to fix bad superblock or xfs_repair: error - read only 0
	of 512 bytes
References: <A7348842-BA7C-474A-B2E1-04345761AB25@unixhosts.org>
In-Reply-To: <A7348842-BA7C-474A-B2E1-04345761AB25@unixhosts.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christian Kildau <lists@unixhosts.org>
Cc: xfs@oss.sgi.com

On 1/21/12 4:03 AM, Christian Kildau wrote:
> Hello,
> =

> I'm having some very serious issues with XFS after upgrading from a
> Linux Distro running Ubuntu 2.6.32 to 3.2.
> =

> It seems like my filesystems are damaged after attaching them to a
> Linux 3.2 server. I am also no longer able to mount the hdd on the
> old server that is still running 2.6.32!

did you do anything else at all besides simply boot a 3.2 kernel?

Or was this a whole distro upgrade?  And who knows what the installer
did...?

> 'test disk' does find the filesystem as XFS 4 and i created a 1.5TB
> dump of it to another hdd.
> =

> (I created the xfs filesystem on the entire hdd, not on a partition,
> so /dev/sdd is not a typo)

is sdd a single disk or something like lvm/md?

what does grep sdd /proc/partitions say?

And

# xfs_db -c "sb 0" -c "p" /dev/sdd

> =

> $ sudo mount -t xfs /dev/sdd /media/
> mount: /dev/sdd: can't read superblock
> (dmesg)
> [236659.912663] attempt to access beyond end of device
> [236659.912667] sdd: rw=3D32, want=3D2930277168, limit=3D2930275055
> [236659.912670] XFS (sdd): last sector read failed
> =

> $ sudo xfs_check /dev/sdd
> xfs_check: error - read only 0 of 512 bytes
> =

> $ sudo xfs_repair /dev/sdd
> Phase 1 - find and verify superblock...
> xfs_repair: error - read only 0 of 512 bytes

stracing those to see where it is failing to read might be useful.

It seems that your device has somehow shrunk out from under your fs.

-Eric

> =

> 'testdisk' does find the filesystem as XFS 4 and i created a 1.5TB dump o=
f it to another hdd.
> =

> Is there any way I can fix this? - Except restroring from backup? Because=
 this IS my backup!
> see ubuntuforums.org/showthread.php?t=3D1910962 for more details=85
> =

> =

> Any help is appreciated!
> =

> Thanks in advance
> Chris
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
