Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5JF8GtV013736 for <xfs@oss.sgi.com>; Sat, 19 Jun 2010 10:08:16 -0500
Received: from procyon.opentrend.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E257159E11B
	for <xfs@oss.sgi.com>; Sat, 19 Jun 2010 08:14:49 -0700 (PDT)
Received: from procyon.opentrend.net (li144-209.members.linode.com
	[109.74.197.209]) by cuda.sgi.com with ESMTP id
	IbrRvoeVveCKBW1h for <xfs@oss.sgi.com>;
	Sat, 19 Jun 2010 08:14:49 -0700 (PDT)
Received: from castor.opentrend.net (unknown [192.168.120.16])
	by procyon.opentrend.net (Postfix) with ESMTP id 21D27CCAC
	for <xfs@oss.sgi.com>; Sat, 19 Jun 2010 15:10:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by castor.opentrend.net (Postfix) with ESMTP id 5E4704008625D
	for <xfs@oss.sgi.com>; Sat, 19 Jun 2010 11:14:38 -0400 (EDT)
Date: Sat, 19 Jun 2010 11:14:38 -0400 (EDT)
From: Robert Brockway <robert@timetraveller.org>
Subject: Re: Help with XFS
In-Reply-To: <20100618144821.0cab4bd4@harpe.intellique.com>
Message-ID: <alpine.DEB.1.10.1006191110490.26490@castor.opentrend.net>
References: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>
	<20100618132108.790921cf@harpe.intellique.com>
	<OF450B8187.BD5256B0-ONC1257746.003E79FF-C1257746.003EE62C@bergenofs.no>
	<20100618133458.6640ce96@harpe.intellique.com>
	<OF0E234D8E.F048FF4D-ONC1257746.003FC10E-C1257746.00407333@bergenofs.no>
	<20100618140028.05650928@harpe.intellique.com>
	<OF77BEDC85.715D16D2-ONC1257746.0043A985-C1257746.0044BAFC@bergenofs.no>
	<20100618144821.0cab4bd4@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-292231012-1276960478=:26490"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-292231012-1276960478=:26490
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 18 Jun 2010, Emmanuel Florac wrote:

> Le Fri, 18 Jun 2010 14:30:43 +0200
> Thomas Førde <thomas.forde@bergenofs.no> écrivait:
>
>> ill see if we can rebuild a different SAN with mirror functionalityt,
>> y have 384x300GB disk in my SAN, so it should be possible.
>
> No, a mirror will corrupt your data as well, a simple copy is better;

Exactly.  High availability and backups are two different things, although 
people often confuse them.

Here are my notes from my backup talk:

http://www.timetraveller.org/talks/backup_talk.pdf

This approach is honed over many years, having done many disaster 
recoveries in the real world.

Cheers,

Rob

-- 
Email: robert@timetraveller.org		Linux counter ID #16440
IRC: Solver (OFTC & Freenode)
Web: http://www.practicalsysadmin.com
Open Source: The revolution that silently changed the world
--8323329-292231012-1276960478=:26490
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323329-292231012-1276960478=:26490--
