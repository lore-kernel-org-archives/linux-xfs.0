Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 369187F67
	for <xfs@oss.sgi.com>; Sun,  9 Nov 2014 20:54:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 15EE0304039
	for <xfs@oss.sgi.com>; Sun,  9 Nov 2014 18:54:38 -0800 (PST)
Received: from BLU004-OMC3S20.hotmail.com (blu004-omc3s20.hotmail.com
	[65.55.116.95]) by cuda.sgi.com with ESMTP id XToAF6blQF9DIGJH
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 09 Nov 2014 18:54:36 -0800 (PST)
Message-ID: <BLU175-W25E6AA8331685E7FEBB900DF800@phx.gbl>
From: GuangYang <yguang11@outlook.com>
Subject: RE: EIO and data corruption on XFS file system
Date: Mon, 10 Nov 2014 02:54:35 +0000
In-Reply-To: <20141106152741.2655245d@harpe.intellique.com>
References: <BLU175-W376F83659C1C70DE51C3D9DF840@phx.gbl>,
	<20141106152741.2655245d@harpe.intellique.com>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Thanks=A0Emmanuel. That clarifies things a lot.

Thanks,
Guang

----------------------------------------
> Date: Thu, 6 Nov 2014 15:27:41 +0100
> From: eflorac@intellique.com
> To: yguang11@outlook.com
> CC: xfs@oss.sgi.com
> Subject: Re: EIO and data corruption on XFS file system
>
> Le Thu, 6 Nov 2014 13:03:45 +0000
> GuangYang <yguang11@outlook.com> =E9crivait:
>
>> Hello,While working on the storage system, I got one question in
>> terms of the XFS utilities to fix file system corruption. Basically,
>> our storage system put 3 copies of data and the system would detect
>> data inconsistency on regular basis, there are two patterns we
>> observed so far: 1) the data is corrupted which result in an EIO, 2)
>> data is still accessible but the content is changed. I am wondering
>> the way to fix such issues from file system's perspective, do we
>> expect hardware failure for both cases or some xfs repairing tools
>> could help for such case?
>
> XFS relies on the underlying hardware to maintain data integrity. The
> latest XFS version comes with metadata checksums, which allows
> correcting invalid data in filesystem structures, but not data.
>
> Generally speaking, if the data is corrupted because of faulty hardware,
> xfs_repair can't help.
>
> regards,
> --
> ------------------------------------------------------------------------
> Emmanuel Florac | Direction technique
> | Intellique
> | <eflorac@intellique.com>
> | +33 1 78 94 84 02
> ------------------------------------------------------------------------
 		 	   		  =

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
