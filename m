Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q75BZa8D199129 for <xfs@oss.sgi.com>; Sun, 5 Aug 2012 06:35:36 -0500
Received: from pavilion.ashurst.eu.org (pavilion.ashurst.eu.org
	[85.119.82.45]) by cuda.sgi.com with ESMTP id 8pmRZUSNAzexAbi3
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Aug 2012 04:35:35 -0700 (PDT)
Message-ID: <501E5A82.1020909@ashurst.eu.org>
Date: Sun, 05 Aug 2012 12:35:30 +0100
From: Andy Bennett <andyjpb@ashurst.eu.org>
MIME-Version: 1.0
References: <5017E426.2040709@profihost.ag> <20120804224336.GS2877@dastard>
	<C4E0639A-87DE-4D38-8097-9B71D0947ABE@profihost.ag>
In-Reply-To: <C4E0639A-87DE-4D38-8097-9B71D0947ABE@profihost.ag>
Subject: Re: xfs_growfs / planned resize / performance impact
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

>>> Is it a problem if this grow will happen in small portions (30GB =>
>>> 50GB => 75GB => 100GB => ... 300GB)?
>>
>> Growing a filesystem by an order of magnitude is the limit of what
>> I'd suggest is sane. Growing it by two orders of magnitude
>> (espcially if you start with a 16 AG filesystem because of stripe
>> alignment) is going to cause problems with the number of AGs and
>> the subsequent freespace management scale issue....
> I would start with ag=4 and end up in ag 48 in my tests.
> 
>> Growing it by two orders of magnitude
> what does that mean? (sorry no native speaker)

In base 10 an order of magnitude is 10x. Two orders of magnitude would
be 100x.

Numbers of the same order of magnitude have the decimal point (comma in
EU) in the same place.

300GB is an order of magnitude larger than 30GB.



Sometimes, I've seen computer scientists use binary orders of magnitude.
I.e. 2x, 4x, 8x, 16x. I'm not sure if this is generally accepted or not.






Regards,
@ndy

-- 
andyjpb@ashurst.eu.org
http://www.ashurst.eu.org/
0x7EBA75FF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
