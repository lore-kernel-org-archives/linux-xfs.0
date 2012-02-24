Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1OG5ug0062547 for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 10:05:57 -0600
Received: from smtprelay05.ispgateway.de (smtprelay05.ispgateway.de
	[80.67.31.99]) by cuda.sgi.com with ESMTP id LJhDA0CGokiLwUp8
	for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 08:05:55 -0800 (PST)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay05.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1S0xec-0000kc-Td
	for xfs@oss.sgi.com; Fri, 24 Feb 2012 17:05:54 +0100
Message-ID: <4F47B562.5080801@cape-horn-eng.com>
Date: Fri, 24 Feb 2012 17:05:54 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: creating a new 80 TB XFS
References: <4F478818.4050803@cape-horn-eng.com>
	<4F47A564.8090204@dermichi.com>
In-Reply-To: <4F47A564.8090204@dermichi.com>
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

On 02/24/2012 03:57 PM, Michael Weissenbacher wrote:
> Hi Richard!
>>
>> mkfs.xfs -i size=3D512 -d su=3Dstripe_size,sw=3D28 -L Backup_2 /dev/sdX1
>>
> This suggests that you plan to create partitions like /dev/sdX1 on the
> RAID-6. If you really do (which is not a good idea IMHO because it buys
> you nothing) you will have to be extra-careful to not mess up the stripe
> alignment. I think the better option is to create the XFS directly on
> /dev/sdX without partitions.

Ok, thanks. I think I will go then to /dev/sdX , no partitions.

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
