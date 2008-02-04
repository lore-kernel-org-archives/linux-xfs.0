Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Feb 2008 08:45:09 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m14Gj1tc009037
	for <xfs@oss.sgi.com>; Mon, 4 Feb 2008 08:45:04 -0800
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72791D82E15
	for <xfs@oss.sgi.com>; Mon,  4 Feb 2008 08:45:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id iHef4ycfGfTWF5Fp for <xfs@oss.sgi.com>; Mon, 04 Feb 2008 08:45:24 -0800 (PST)
Message-ID: <47A7411F.2040702@sandeen.net>
Date: Mon, 04 Feb 2008 10:45:19 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: RAID needs more to survive a power hit, different /boot layout
 for example (was Re: draft howto on making raids for surviving a disk crash)
References: <47A612BE.5050707@pobox.com> <47A623EE.4050305@msgid.tls.msk.ru> <47A62A17.70101@pobox.com> <47A6DA81.3030008@msgid.tls.msk.ru> <47A6EFCF.9080906@pobox.com> <47A7188A.4070005@msgid.tls.msk.ru> <alpine.DEB.1.00.0802040909010.2415@p34.internal.lan> <47A72061.3010800@sandeen.net> <47A72FBC.9090701@pobox.com>
In-Reply-To: <47A72FBC.9090701@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, xfs@oss.sgi.com

Moshe Yudkowsky wrote:
> So if I understand you correctly, you're stating that current the most 
> reliable fs in its default configuration, in terms of protection against 
> power-loss scenarios, is XFS?

I wouldn't go that far without some real-world poweroff testing, because
various fs's are probably more or less tolerant of a write-cache
evaporation.  I suppose it'd depend on the size of the write cache as well.

-Eric
