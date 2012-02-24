Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1OGwva2069618 for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 10:58:57 -0600
Received: from a.mx.filmlight.ltd.uk (a.mx.filmlight.ltd.uk [77.107.81.250])
	by cuda.sgi.com with SMTP id lmhFkxs22eh7Svz3 for
	<xfs@oss.sgi.com>; Fri, 24 Feb 2012 08:58:56 -0800 (PST)
Subject: Re: creating a new 80 TB XFS
Mime-Version: 1.0 (Apple Message framework v1084)
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <4F47B020.4000202@cape-horn-eng.com>
Date: Fri, 24 Feb 2012 16:58:54 +0000
Message-Id: <C8615237-38FA-403B-956D-DBA0BE26A718@filmlight.ltd.uk>
References: <4F478818.4050803@cape-horn-eng.com>
	<20120224150805.243e4906@harpe.intellique.com>
	<4F47B020.4000202@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com


On 24 Feb 2012, at 15:43, Richard Ems wrote:

> =

> =

> On 02/24/2012 03:08 PM, Emmanuel Florac wrote:
>> Le Fri, 24 Feb 2012 13:52:40 +0100
>> Richard Ems <richard.ems@cape-horn-eng.com> =E9crivait:
>> =

>>> Hi list,
>>> =

>>> We are getting now 32 x 3 TB Hitachi SATA HDDs.
>>> I plan to configure them in a single RAID 6 set with one or two
>>> hot-standby discs. The raw storage space will then be 28 x 3 TB =3D 84
>>> TB. On this one RAID set I will create only one volume.
>>> Any thoughts on this?
>> =

>> If you'd rather go for more safety you could build 2 16 drives RAID-6
>> arrays instead. I'd be somewhat reluctant to make a 30 drives array
>> --though current drives are quite safe apparently.
> =

> Thanks, yes, this sounds good, but it's a matter of administration
> simplicity doing the backups why I chose to have only one
> volume/partition/XFS. At some point one of both drives will become near
> to full and moving dirs from one partition to the other won't be that
> easy with out backup system ...

You might consider making a software raid0 from the two raid-6 arrays.

--
Roger

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
