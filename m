Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jan 2008 06:24:43 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0NEOYOB026370
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 06:24:37 -0800
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2002E54ED61
	for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 06:24:52 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by cuda.sgi.com with ESMTP id BRV2qFhz6jFmEDKr for <xfs@oss.sgi.com>; Wed, 23 Jan 2008 06:24:52 -0800 (PST)
Date: Wed, 23 Jan 2008 15:24:42 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: XFS doesn't correctly account for IO-Wait for directory reading
Message-ID: <20080123142442.GA12440@citd.de>
References: <20080123110027.GA10366@citd.de> <20080123121741.GA24405@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123121741.GA24405@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 23.01.2008 12:17, Christoph Hellwig wrote:
> 
> Try this one-liner patch which should give you much better I/O wait
> reporting.  There's some more I/O waits hidden in the log code, but to
> fix this we'd need to dig into the sv_t abstraction.  Given that it only
> has four users left I'm probably going to simply remove it and fix the
> I/O wait accounting while I'm at it.

Either with 2.6.23.12 & 2.6.24-git-HEAD, and the shown line changed, the 
%wa reported by top is still at 0.0





Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.
