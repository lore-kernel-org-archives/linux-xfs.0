Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FFsU5C187178 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 09:54:31 -0600
Received: from smtprelay02.ispgateway.de (smtprelay02.ispgateway.de
	[80.67.18.14]) by cuda.sgi.com with ESMTP id PGzEVsQl80WkO6Bk
	for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 07:54:28 -0800 (PST)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay02.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1RxhBb-00078g-7y
	for xfs@oss.sgi.com; Wed, 15 Feb 2012 16:54:27 +0100
Message-ID: <4F3BD532.2040102@cape-horn-eng.com>
Date: Wed, 15 Feb 2012 16:54:26 +0100
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
References: <4F3A5B49.6020803@cape-horn-eng.com>
	<4F3AE9EA.1050609@hardwarefreak.com>
In-Reply-To: <4F3AE9EA.1050609@hardwarefreak.com>
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

On 02/15/2012 12:10 AM, Stan Hoeppner wrote:
> On 2/14/2012 7:02 AM, Richard Ems wrote:
>> lspci shows:
>>
>> LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI
> =

> PCI-X?  So this host and array have a few years on them I assume.

Yes. Bought 2007.

>>> Also check the performance data in the management interface on the
>>> InforTrend unit to see if you're hitting any limits there (if it has
>>> such a feature).  RAID6 is numerically intensive and that particular
>>> controller may not have the ASIC horsepower to keep up with the IOPS
>>> workload you're throwing at it.
>>
>> There is no performance data in the management interface to check.
> =

> Ok, so this is a relatively basic, entry level array?

It's an InforTrend InforTrend A24U-G2421, see
http://www.infortrend.com/main/2_product/es_a24u-g2421.asp


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
