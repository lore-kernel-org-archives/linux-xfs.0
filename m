Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Sep 2008 04:46:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8LBjV6S008873
	for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 04:45:32 -0700
Date: Sun, 21 Sep 2008 13:46:52 +0200
From: Sven Geggus <lists@fuchsschwanzdomain.de>
Subject: Re: Ooops in Kernel 2.6.26.2
Message-ID: <20080921114651.GA3998@diesel.geggus.net>
References: <20080808180938.GA3760@diesel.geggus.net> <489FECCD.6050703@sgi.com> <489FF0EE.5040607@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489FF0EE.5040607@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

Lachlan McIlroy schrieb am Montag, den 11. August um 09:57 Uhr:

> The ticket allocation code got reworked in 2.6.26 and we now free
> tickets whereas before we used to cache them so the use-after-free
> went undetected.
> 
> This patch should do the trick.

Just for your Info:

The Problem was still persistent in Vanilla Kernel 2.6.26.5. So I
applied your patch and everything is working fine now!

Regards

Sven

-- 
Threading is a performance hack.
(The Art of Unix Programming by Eric S. Raymond)

/me is giggls@ircnet, http://sven.gegg.us/ on the Web
