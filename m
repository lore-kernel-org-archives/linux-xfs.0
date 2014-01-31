Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E7217FB1
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 15:51:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1523F8F8066
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 13:51:26 -0800 (PST)
Received: from mail-ea0-f171.google.com (mail-ea0-f171.google.com
	[209.85.215.171]) by cuda.sgi.com with ESMTP id
	BM1BEuvvj5kVZf72 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jan 2014 13:51:24 -0800 (PST)
Received: by mail-ea0-f171.google.com with SMTP id f15so2599169eak.16
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 13:51:23 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Not being able to recover a RAID 5 20 Tb partition, help needed
From: Juan Antonio Sillero Sepulveda <juan.sillero@gmail.com>
In-Reply-To: <20140131223715.0a977fc2@galadriel.home>
Date: Fri, 31 Jan 2014 22:50:51 +0100
Message-Id: <D52B7046-0672-4C4E-AC79-DCB7F811DB2E@gmail.com>
References: <1391002795.2573.79.camel@islero.dmt.upm.es>
	<1391009068.4294.83.camel@montana.filmlight.ltd.uk>
	<1391014448.2573.95.camel@islero.dmt.upm.es>
	<20140129184250.7af7200f@harpe.intellique.com>
	<CC18E95B-75B3-47CE-8FBE-9FA511A38CD5@torroja.dmt.upm.es>
	<20140131223715.0a977fc2@galadriel.home>
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
Cc: xfs@oss.sgi.com, Roger Willcocks <roger@filmlight.ltd.uk>, Guillem Borrell i Nogueras <guillem@torroja.dmt.upm.es>

Sorry,

Guillem, my colleague and expert, correct me. These is the hardware.

Disk /dev/sdq - 20 TB / 18 TiB - DotHill R/Evo 5730-2R
Disk /dev/sdr - 22 TB / 20 TiB - DotHill R/Evo 5730-2R
Disk /dev/sds - 22 TB / 20 TiB - DotHill R/Evo 5730-2R
Disk /dev/sdt - 22 TB / 20 TiB - DotHill R/Evo 5730-2R
Disk /dev/sdu - 22 TB / 20 TiB - DotHill R/Evo 5730-2R
Disk /dev/sdv - 22 TB / 20 TiB - DotHill R/Evo 5730-2R
Disk /dev/sdw - 22 TB / 20 TiB - DotHill R/Evo 5730-2R
Disk /dev/sdx - 22 TB / 20 TiB - DotHill R/Evo 5730-2R
Disk /dev/sdy - 22 TB / 20 TiB - DotHill R/Evo 5730-2R
Disk /dev/sdz - 20 TB / 18 TiB - DotHill R/Evo 5730-2R

We store everything, basically. Images, matlabs files, txt, dat, pdf, binar=
y files, hdf5 files, .mat, Fortran files, etc...


On Jan 31, 2014, at 10:37 PM, Emmanuel Florac <eflorac@intellique.com> wrot=
e:

> Le Fri, 31 Jan 2014 20:31:25 +0100 vous =E9criviez:
> =

>> The disk controller are QLogic:
>> =

>> 04:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel
>> to PCI Express HBA (rev 02) =

> =

> =

> So it's just a FC HBA, not a RAID controller, so there isn't much to
> do there. As I said previously, your best bet at this point is first try
> UFS explorer first.
> =

> Is your data made of  standard file formats (i.e. JPEG images, etc)? Or
> is it special?
> =

> -- =

> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |	<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
