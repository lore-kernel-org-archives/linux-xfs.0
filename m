Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58Jaw82249707 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 14:36:58 -0500
Received: from smtp.internet-sicherheit.de (smtp.internet-sicherheit.de
	[194.94.127.56]) by cuda.sgi.com with ESMTP id nDik8BpHFR4QKz8l
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Jun 2012 12:36:56 -0700 (PDT)
Received: from [10.0.44.5] (unknown [10.0.44.5])
	by smtp.internet-sicherheit.de (Postfix) with ESMTP id D1CF2EE0032
	for <xfs@oss.sgi.com>; Fri,  8 Jun 2012 21:36:55 +0200 (CEST)
Message-ID: <4FD2545A.40503@internet-sicherheit.de>
Date: Fri, 08 Jun 2012 21:36:58 +0200
From: "Christian J. Dietrich" <dietrich@internet-sicherheit.de>
MIME-Version: 1.0
Subject: Re: Repeated XFS corruption on RAID-10 on Adaptec 51245
References: <4FD1C9B8.70907@internet-sicherheit.de>
	<20120608125138.20c79cee@harpe.intellique.com>
In-Reply-To: <20120608125138.20c79cee@harpe.intellique.com>
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
To: xfs@oss.sgi.com


Emmanuel,

Am 08.06.2012 12:51, schrieb Emmanuel Florac:
> "Christian J. Dietrich" <dietrich@internet-sicherheit.de> =E9crivait:
> =

>> I am running CentOS 6.2 (=3DRHEL 6.2) with kernel
>> 2.6.32-220.17.1.el6.x86_64 (most recent) and all OS updates installed.
>> Controller Firmware is the most recent (18948), driver version is
>> 1.1-5. HDDs are 2x WD2001FASS, 10x WD2002FAEX.
>>
> =

> I currently manage many servers (about 50) with Adaptec 5xx5 raid
> cards. The only case of data corruption I've met was with WD drives.
> =

> Therefore it's most probably related to the WD drives. WD desktop
> drives are well known for being (voluntarily) crippled for RAID
> operation. They will almost always create all sort of weird problems
> when running under high IO load.
> =

> It is of utmost importance that you at least take care of setting TLER
> in the correct mode on the drives. Beware that apparently newer WD
> drives don't even allow setting TLER properly anymore (I said
> "crippled").
> =

> http://en.wikipedia.org/wiki/Time-Limited_Error_Recovery

Indeed, it seems to be related to the WD HDDs, I am in contact with
Adaptec support and will dig deeper. A couple of disks have comparably
high CommandAborts.

Probably, I will rebuild the RAID volume using disks with proper TLER
support and activate TLER.

Thanks for your help,
Chris

-- =

Christian J. Dietrich
Institute for Internet Security - if(is)
Westf=E4lische Hochschule University of Applied Sciences
https://www.internet-sicherheit.de


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
