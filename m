Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1EICXaW115147 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 12:12:33 -0600
Received: from smtprelay03.ispgateway.de (smtprelay03.ispgateway.de
	[80.67.29.7]) by cuda.sgi.com with ESMTP id 96jH8WvlINK1AAWb
	for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 10:12:31 -0800 (PST)
Message-ID: <4F3AA40D.50302@cape-horn-eng.com>
Date: Tue, 14 Feb 2012 19:12:29 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <4F3A5B49.6020803@cape-horn-eng.com> <4F3AA191.9030606@mnsu.edu>
In-Reply-To: <4F3AA191.9030606@mnsu.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
Cc: xfs@oss.sgi.com

Hi Jeffrey,


On 02/14/2012 07:01 PM, Jeffrey Hundstad wrote:
> Richard,
> =

> Someone asked if you used inode64.  I didn't see a response that you
> did.  Inode64 is a mount option.  I bet this will help with your
> problem.  It appears that all the inodes will be (by default, without
> the inode64 option) in the first 1TB of disk.  This could cause a LOT of
> seeks.  BTW: the option by itself will not help.  You'll need to
> save/restore to have this help.  However, I suspect over time it will
> help if files old files are replaced by new ones.
> =

> For example:
> mount -o inode64 /dev/sda1 /home/
> =

> Here's some documentation:
> =

> mount(8):  inode64
> Indicates that XFS is allowed to create inodes at any location in the
> filesystem, including those which will result in inode numbers occupying
> more than 32 bits of significance.  This is provided for backwards
> compatibility, but causes problems for backup applications that cannot
> handle large inode numbers.
> =

> http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_inode64_mount_option_for.=
3F
> Q: What is the inode64 mount option for?
> =

> By default, with 32bit inodes, XFS places inodes only in the first 1TB
> of a disk. If you have a disk with 100TB, all inodes will be stuck in
> the first TB. This can lead to strange things like "disk full" when you
> still have plenty space free, but there's no more place in the first TB
> to create a new inode. Also, performance sucks.
> =

> To come around this, use the inode64 mount options for filesystems >1TB.
> Inodes will then be placed in the location where their data is,
> minimizing disk seeks.

What about that programs using only 32-bit stat() ?

> =

> Beware that some old programs might have problems reading 64bit inodes,
> especially over NFS. Your editor used inode64 for over a year with
> recent (openSUSE 11.1 and higher) distributions using NFS and Samba
> without any corruptions, so that might be a recent enough distro.
> =


yes, I replied to Christoph's question stating that I am not using
inode64. My reply was:

"
No, I did not use it, but I was thinking about and ran the script from
http://sandeen.net/misc/summarise_stat.pl and got as an example on /bin:

# /net/c3m/usr/local/software/XFS/summarise_stat.pl /bin/
      9  6.2% are scripts (shell, perl, whatever)
     65 44.8% don't use any stat() family calls at all
     61 42.1% use 32-bit stat() family interfaces only
      9  6.2% use 64-bit stat64() family interfaces only
      1  0.7% use both 32-bit and 64-bit stat() family interfaces

So I was not sure if I should use inode64 or not.
"

Thanks, Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
