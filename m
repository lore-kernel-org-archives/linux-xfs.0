Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8PGroQ3241986 for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 11:53:50 -0500
Received: from mail-iw0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D76F41D94096
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 09:54:46 -0700 (PDT)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	qdsv5QxDRwpg2sZ5 for <xfs@oss.sgi.com>;
	Sat, 25 Sep 2010 09:54:46 -0700 (PDT)
Received: by iwn39 with SMTP id 39so3191294iwn.26
	for <xfs@oss.sgi.com>; Sat, 25 Sep 2010 09:54:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100925155611.GA21928@infradead.org>
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
	<4C9C875D.9050308@open-e.com>
	<20100925155611.GA21928@infradead.org>
Date: Sat, 25 Sep 2010 09:54:46 -0700
Message-ID: <AANLkTik=wkAkbexmO+4WCCT2pusRu-DTq1=yNwv9V5f0@mail.gmail.com>
Subject: Re: Problem with file system on iSCSI FileIO
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Slawomir Nowakowski <slawomir.nowakowski@open-e.com>, xfs@oss.sgi.com

On Sat, Sep 25, 2010 at 8:56 AM, Christoph Hellwig <hch@infradead.org> wrot=
e:
>> So once again. We have created a RAID unit level 6. On the top of
>> the unit there is an LVM architecture, I mean a volume group that
>> contains logical volumes. The logical volume is formatted with XFS
>> and it contains one big file that takes almost all of the space on
>> the LV. There is some free space left in order to be able expand the
>> LV and FS in the future. The LV is mounted and the file is served as
>> iSCSI target. The iSCSI Initiator (MS Initiator from Windows 2k3)
>> connects to iSCSI target. The iSCSI disk is formatted with the NTFS.
>
> ok, so we have:
>
> Linux Server
>
> +----------------------+
> | =A0 hardware raid 6 =A0 =A0|
> +----------------------+
> | lvm2 - linear volume |
> +----------------------+
> | =A0 =A0 =A0 =A0 =A0XFS =A0 =A0 =A0 =A0 |
> +----------------------+
> | =A0 =A0iSCSI target =A0 =A0 =A0|
> +----------------------+
>
> Windows client:
>
>
> +----------------------+
> | =A0 =A0iSCSI initiator =A0 |
> +----------------------+
> | =A0 =A0 =A0 =A0NTFS =A0 =A0 =A0 =A0 =A0|
> +----------------------+
>
>> But we believe the problem is with the XFS. With unknown reason we
>> are not able to mount the LV and after running xfs_repair the file
>> is missing from the LV. Do you have any ideas how we can try to fix
>> the broken XFS?
>
> This does not sound like a plain XFS issue to me, but an interaction
> between components going completely wrong. =A0Normal I/O to a file
> should never corrupt the filesystem around it to the point where
> it's unusable, and so far I never heard reports about that. =A0The hint
> that this doesn't happen with another purely userspace target is
> interesting. =A0I wonder if SCST that you use does any sort of in-kernel
> block I/O after using bmap or similar? =A0I've not seen that for iscsi
> targets yet but for other kernel modules, and that kind of I/O
> can cause massive corruption on a filesystem with delayed allocation
> and unwritten extents.
>
> Can any of the SCST experts on the list here track down how I/O for this
> configuration will be issued?
>
> What does happen if you try the same setup with say jfs or ext4 instead
> of xfs?

I saw references to vdisk fileio in there and wondered why this was
being done rather than simply exporting the hardware raid 6 device?
Ie, why are all those other layers in there?

fileio uses submit_bio to submit the data and it defaults to
WRITE_THROUGH, NV_CACHE and DIRECT_IO (at least in the trunk, but I
suspect this has been the case for a long while) however, the person
making the complaint might have switched off WRITE_THROUGH in the
pursuit of performance, in which case a crash could corrupt things
badly but it would depend on whether or not clearing WRITE_THROUGH
also clears NV_CACHE and what the code assembling the caching mode
page does (and I have only had a cursory glance at the vdisk code).

What is needed here is the parameters used in configuring the vdisk
and the version of SCST in use.

-- =

Regards,
Richard Sharpe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
