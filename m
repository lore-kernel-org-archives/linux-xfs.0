Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 May 2007 19:25:33 -0700 (PDT)
Received: from smtp102.sbc.mail.mud.yahoo.com (smtp102.sbc.mail.mud.yahoo.com [68.142.198.201])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4U2PQWt021126
	for <xfs@oss.sgi.com>; Tue, 29 May 2007 19:25:29 -0700
Date: Tue, 29 May 2007 19:25:24 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: xfs_fsr 2.2.38 bug/kernel 2.6.21.3 cannot defrag volume
Message-ID: <20070530022524.GA20275@tuatara.stupidest.org>
References: <Pine.LNX.4.64.0705291404430.2944@p34.internal.lan> <20070530004140.GX85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530004140.GX85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com, apiszcz@solarrain.com

On Wed, May 30, 2007 at 10:41:40AM +1000, David Chinner wrote:

> Remember - xfs_fsr does best effort defrag - if it can't make
> progress, it does nothing, and it can't defrag directories...

Also, it's not going to do much in many cases unless you have free
space...  if you don't have enough *suitable* free space then it won't
be able to do much.
