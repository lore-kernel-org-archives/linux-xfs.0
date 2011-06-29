Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TF8Amx109123 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 10:08:10 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 572301D7DB49
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 08:08:08 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id iTvTQ0MlNYDNpjnI
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 08:08:08 -0700 (PDT)
Received: from dermichi-2-pt.tunnel.tserv23.zrh1.ipv6.he.net
	([2001:470:25:4f4::2])
	by firestarter.dermichi.com with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.76) (envelope-from <mw@dermichi.com>) id 1QbwN4-0005s0-M8
	for xfs@oss.sgi.com; Wed, 29 Jun 2011 17:08:06 +0200
Message-ID: <4E0B3FD4.4090704@dermichi.com>
Date: Wed, 29 Jun 2011 17:08:04 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: Re: long hangs when deleting large directories (3.0-rc3)
References: <20110621212201.GA1755@x4.trippels.de>	<20110621185701.GB1723@x4.trippels.de>	<20110622000449.GQ32466@dastard>	<20110622070647.GA1744@x4.trippels.de>	<20110622073047.GT32466@dastard>
	<20110629043143.GA1026@dastard>	<20110629061954.GA1711@x4.trippels.de>	<20110629072446.GR561@dastard>	<20110629074127.GA1746@x4.trippels.de>	<20110629121001.GS561@dastard>
	<20110629124814.GA1762@x4.trippels.de>
In-Reply-To: <20110629124814.GA1762@x4.trippels.de>
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

Hi Marcus / Dave!
> 
> This completely fixes the issue. As a bonus "rm -fr && sync" completes
> much quicker now.
> ...
> So many thanks Dave. Your prompt help is very much appreciated.
> 
I just wanna add that i've seen these kinds of hangs too when removing
directories with millions of files. My "solution" was to recreate the
filesystem - which was several years old at that time. Looking forward
to the fix. Thanks for the great work going on here - both for the
in-depth investigation and the fix.

cheers,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
