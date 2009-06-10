Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5AFhKKq098574 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 10:43:21 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22453126E0D0
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 08:50:52 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id UE8Je5KH7W9oeUEZ for
	<xfs@oss.sgi.com>; Wed, 10 Jun 2009 08:50:52 -0700 (PDT)
Message-ID: <4A2FD4AD.9000802@sandeen.net>
Date: Wed, 10 Jun 2009 10:43:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_growfs doesn't grow on 2TB raid
References: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
	<4A2FB71D.3030606@sandeen.net>
	<BAY108-W34738AFF57BDF4BD9B742AF3450@phx.gbl>
In-Reply-To: <BAY108-W34738AFF57BDF4BD9B742AF3450@phx.gbl>
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
To: jack the ripper <evil_metalpeet@hotmail.com>
Cc: xfs@oss.sgi.com

jack the ripper wrote:
> *> cat /proc/partitions*
> major minor  #blocks  name
> 

... snip ...

>    9        5 2441919680 md5  <-- md device
>  253        1 1953534716 dm-1 <-- dm-crypt device
> 

it looks like your md device is larger, but your dm-crypt device is no
larger than it was, so it's not unusual that growfs isn't growing ...

At this point I guess it looks more like a dm-crypt/cryptsetup/LUKS
problem (or at least an admin question).

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
