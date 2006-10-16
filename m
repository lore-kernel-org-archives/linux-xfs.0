Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 14:58:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9GLvvaG028470
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 14:57:57 -0700
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9341D19842E
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 14:57:13 -0700 (PDT)
Message-ID: <4533FAEA.2080500@sandeen.net>
Date: Mon, 16 Oct 2006 16:34:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] Make stuff static
References: <20060929032856.8DA9C18001A5E@sandeen.net> <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local> <45338DDE.8020903@sandeen.net>
In-Reply-To: <45338DDE.8020903@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

Eric Sandeen wrote:
> Timothy Shimmin wrote:
>> Okay, started looking :-)

One other thing, based on the bug on osdl today, some of these larger
newly-static functions should probably be marked noinline to keep gcc
from doing things we don't want it to...

-Eric
