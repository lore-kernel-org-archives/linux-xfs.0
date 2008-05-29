Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 04:35:54 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TBZkZ3001101
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 04:35:49 -0700
Received: from lxorguk.ukuu.org.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEAC11B98682
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 04:36:38 -0700 (PDT)
Received: from lxorguk.ukuu.org.uk (earthlight.etchedpixels.co.uk [81.2.110.250]) by cuda.sgi.com with ESMTP id mEzQk6t9bHGHA2p3 for <xfs@oss.sgi.com>; Thu, 29 May 2008 04:36:38 -0700 (PDT)
Date: Thu, 29 May 2008 12:22:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Message-ID: <20080529122223.462bf396@core>
In-Reply-To: <483DE40D.8090608@tmr.com>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
	<95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
	<20080528195752.0cdcbc6d@core>
	<483DE40D.8090608@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jens =?UTF-8?B?QsOkY2ttYW4=?= <jens.backman@gmail.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

> I really don't think that's any part of the issue, the same memory and 
> bridge went 4-5x faster in other read cases. The truth is that the 
> raid-1 performance is really bad, and it's the code causing it AFAIK. If 
> you track the actual io it seems to read one drive at a time, in order, 
> without overlap.

Make sure the readahead is set to be a fair bit over the stripe size if
you are doing bulk data tests for a single file. (Or indeed in the real
world for that specific case ;))
