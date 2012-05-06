Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q46AVrNa184661 for <xfs@oss.sgi.com>; Sun, 6 May 2012 05:31:53 -0500
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 8POigXoDOHXeBlxG for
	<xfs@oss.sgi.com>; Sun, 06 May 2012 03:31:51 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: suddenly slow writes on XFS Filesystem
Date: Sun, 6 May 2012 12:31:50 +0200
References: <4FA63DDA.9070707@profihost.ag>
	(sfid-20120506_121127_622020_FC89E0F4)
In-Reply-To: <4FA63DDA.9070707@profihost.ag>
MIME-Version: 1.0
Message-Id: <201205061231.50526.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com
Cc: Stefan Priebe <s.priebe@profihost.ag>

Am Sonntag, 6. Mai 2012 schrieb Stefan Priebe:
> Hi,

Hi Stefan,

> since a few days i've experienced a really slow fs on one of our
> backup  systems.
> 
> I'm not sure whether this is XFS related or related to the Controller
> /  Disks.
> 
> It is a raid 10 of 20 SATA Disks and i can only write to them with
> about  700kb/s while doing random i/o. I tried vanilla Kernel 3.0.30
> and 3.3.4 - no difference. Writing to another partition on another xfs
> array works fine.

How do you measure the 700 KB/s?

Anything in dmesg?

I and likely others here would be interested in vmstat and iostat outputs 
during slowness.

See:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
