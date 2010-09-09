Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o89ImSvg113234 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 13:48:29 -0500
Received: from mail-iw0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B93F12DC5AC
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 12:00:33 -0700 (PDT)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	pul3i5EJi9OdtXk0 for <xfs@oss.sgi.com>;
	Thu, 09 Sep 2010 12:00:33 -0700 (PDT)
Received: by iwn39 with SMTP id 39so1352665iwn.26
	for <xfs@oss.sgi.com>; Thu, 09 Sep 2010 11:49:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C892A32.1000404@googlemail.com>
References: <4C892A32.1000404@googlemail.com>
Date: Thu, 9 Sep 2010 11:49:12 -0700
Message-ID: <AANLkTikZLHXXLsjBhJHtGN3vAW4fMtMCNTaNG5ju_Wxi@mail.gmail.com>
Subject: Re: logerrors on armv5te hardware rendering xfs-partition unmountable
From: Richard Sharpe <realrichardsharpe@gmail.com>
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
To: Marcus Osdoba <marcus.osdoba@googlemail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Sep 9, 2010 at 11:40 AM, Marcus Osdoba
<marcus.osdoba@googlemail.com> wrote:
> =A0Dear mailinglist,
>
> I run a kernel 2.6.35.4 on my SeagateDockStar which is based on the
> sheevaplug (kirkwood armv5te).
> Once searching the archive of the this mailinglist, I figured out, that
> there problems in the past with running xfs on CPUs with virtually indexed
> caches (like arm). A series of patches was applied in Febuary 2010 with t=
he
> purpose to resolve the problems on arm devices.

The Marvell 78x00 processors have VIVT caches. Is the Kirkwood series
different? Would a VIVT cache require different patches to a VIPT
cache, and what types of cache architectures were the patches for?

> With the recent linux kernel I'm using, I still discover errors. I was
> forced to run xfs_repair -l /dev/sdx1 before I could mount the partition
> again.
> I was asked by one of the respectable mailinglist members to give the
> complete output of the commands I launched.
>
> Please find below the hardcopy of my terminal output and let me know, what
> debug information do you need and how (and when) this must be obtained.
>
> Thank you and kind regards,
> Marcus
>
> $ mkfs.xfs -f /dev/sda1
> meta-data=3D/dev/sda1 =A0 =A0 =A0 =A0 =A0 =A0 =A0isize=3D256 =A0 =A0agcou=
nt=3D4, agsize=3D19535620
> blks
> =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D=
512 =A0 attr=3D2
> data =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096=
 =A0 blocks=3D78142479, imaxpct=3D25
> =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sunit=3D0=
 =A0 =A0 =A0swidth=3D0 blks
> naming =A0 =3Dversion 2 =A0 =A0 =A0 =A0 =A0 =A0 =A0bsize=3D4096 =A0 ascii=
-ci=3D0
> log =A0 =A0 =A0=3Dinternal log =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 block=
s=3D38155, version=3D2
> =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=3D=
512 =A0 sunit=3D0 blks, lazy-count=3D1
> realtime =3Dnone =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extsz=3D4096 =A0 blo=
cks=3D0, rtextents=3D0
> $ mount -t xfs /dev/sda1 /data
> $ dmesg|tail
> sd 0:0:0:0: [sda] Assuming drive cache: write through
> sd 0:0:0:0: [sda] Attached SCSI disk
> SGI XFS with ACLs, security attributes, large block/inode numbers, no deb=
ug
> enabled
> SGI XFS Quota Management subsystem
> XFS mounting filesystem sda1
> Ending clean XFS mount for filesystem: sda1
> $ cp /bin/* /data
> $ umount /data
> $ xfs_logprint /dev/sda1|tail
> -------------------------------------------------------------------------=
---
> Oper (0): tid: 22e742e6 =A0len: 4 =A0clientid: TRANS =A0flags: WAS_CONT E=
ND
> Left over region from split log item
> -------------------------------------------------------------------------=
---
> Oper (1): tid: 22e742e6 =A0len: 512 =A0clientid: TRANS =A0flags: none
> Left over region from split log item
> -------------------------------------------------------------------------=
---
> Oper (2): tid: 22e742e6 =A0len: 256 =A0clientid: TRANS =A0flags: none
> xfs_logprint: unknown log operation type (e3cf)
> **********************************************************************
> * ERROR: data block=3D66 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> **********************************************************************
> Bad data in log
> $ mount -t xfs /dev/sda1 /data
> $ dmesg|tail
> SGI XFS with ACLs, security attributes, large block/inode numbers, no deb=
ug
> enabled
> SGI XFS Quota Management subsystem
> XFS mounting filesystem sda1
> Ending clean XFS mount for filesystem: sda1
> XFS mounting filesystem sda1
> Ending clean XFS mount for filesystem: sda1
> XFS mounting filesystem sda1
> Ending clean XFS mount for filesystem: sda1
> XFS mounting filesystem sda1
> Ending clean XFS mount for filesystem: sda1
> $ mkdir /data/usr;cp -r /usr /data/usr
> $ umount /data
> $ xfs_logprint /dev/sda1|tail
> xfs_logprint: unknown log operation type (e3cf)
> Bad data in log
> Oper (0): tid: 22e742e6 =A0len: 4 =A0clientid: TRANS =A0flags: WAS_CONT E=
ND
> Left over region from split log item
> -------------------------------------------------------------------------=
---
> Oper (1): tid: 22e742e6 =A0len: 512 =A0clientid: TRANS =A0flags: none
> Left over region from split log item
> -------------------------------------------------------------------------=
---
> Oper (2): tid: 22e742e6 =A0len: 256 =A0clientid: TRANS =A0flags: none
> **********************************************************************
> * ERROR: data block=3D66 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*
> **********************************************************************
> $ mount -t xfs /dev/sda1 /data
> mount: mounting /dev/sda1 on /data failed: Input/output error
> $ dmesg|tail
> Ending clean XFS mount for filesystem: sda1
> XFS mounting filesystem sda1
> Ending clean XFS mount for filesystem: sda1
> XFS mounting filesystem sda1
> Starting XFS recovery on filesystem: sda1 (logdev: internal)
> XFS: xlog_recover_process_data: bad clientid
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed
> $
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



-- =

Regards,
Richard Sharpe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
