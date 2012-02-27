Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1RCK5rc055005 for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 06:20:05 -0600
Received: from smtprelay01.ispgateway.de (smtprelay01.ispgateway.de
	[80.67.18.13]) by cuda.sgi.com with ESMTP id 85szdn3RSBzHCKxn
	for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 04:20:02 -0800 (PST)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay01.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1S1zYe-0007Op-T4
	for xfs@oss.sgi.com; Mon, 27 Feb 2012 13:20:00 +0100
Message-ID: <4F4B74F0.3040801@cape-horn-eng.com>
Date: Mon, 27 Feb 2012 13:20:00 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: creating a new 80 TB XFS
References: <4F478818.4050803@cape-horn-eng.com> <2897177.rcH5T34bLh@saturn>
In-Reply-To: <2897177.rcH5T34bLh@saturn>
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

On 02/27/2012 12:56 PM, Michael Monnerie wrote:
> Am Freitag, 24. Februar 2012, 13:52:40 schrieb Richard Ems:
>> The raw storage space will then be 28 x 3 TB =3D 84 TB.
> =

> Please remember that it will be 2,79 TiB per drive, that's 78 TiB =

> overall. So it's missing 6 TB in reality, depending on how you =

> calculated the source space you have and backup space you need. In =

> Multi-TB environments people still are surprised by the big "rounding =

> error" from harddisk TB to real TiB. And I've had customers who couldn't =

> even do their first backup, as the backup system was full already. They =

> calculated backup space only for one backup, and without the TB->TiB =

> conversion.

Thanks Michael, I have alrady taken this into account.

We have now about 40 TB to backup and about 60 TB max. And there is
space for 32 more HDDs in the backup system, which we will add later as
needed.

Richard

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
