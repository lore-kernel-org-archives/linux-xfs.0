Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Mar 2008 11:32:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2HIVpdH024313
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 11:31:56 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 843EEFBB478
	for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 11:32:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id teM1tUFjrcV7ANQD for <xfs@oss.sgi.com>; Mon, 17 Mar 2008 11:32:20 -0700 (PDT)
Message-ID: <47DEB930.7020108@sandeen.net>
Date: Mon, 17 Mar 2008 13:32:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix dir2 shortform structures on ARM old ABI
References: <47DB4181.7040603@sandeen.net> <20080315041722.GA25621@josefsipek.net> <47DB4F4F.8030407@sandeen.net> <20080315042703.GA28242@josefsipek.net> <47DB51A3.70200@sandeen.net> <20080315045147.GB28242@josefsipek.net>
In-Reply-To: <20080315045147.GB28242@josefsipek.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Josef 'Jeff' Sipek wrote:

> Josef 'Jeff' Sipek, wondering exactly how passionate one can get about
> structure member alignment :)

Very.  ;)

Tossing packed at all the ondisk stuctures bloats things badly on ia64.

cvs/linux-2.6-xfs> wc -l before.dis
166688 before.dis
cvs/linux-2.6-xfs> wc -l after.dis
182294 after.dis

That's +15606 lines.

http://digitalvampire.org/blog/index.php/2006/07/31/why-you-shouldnt-use-__attribute__packed/

Please, don't do this.

_Annotating_ ondisk structures sounds good to me, assuming something can
be done with it (i.e., testing for holes - I'd thought of this a while
ago too, but never came up with anything to make use of it) but don't
pack stuff just for fun.

-Eric
