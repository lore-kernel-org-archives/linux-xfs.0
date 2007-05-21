Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 May 2007 21:25:55 -0700 (PDT)
Received: from smtp103.sbc.mail.mud.yahoo.com (smtp103.sbc.mail.mud.yahoo.com [68.142.198.202])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4L4PkfB003611
	for <xfs@oss.sgi.com>; Sun, 20 May 2007 21:25:49 -0700
Date: Sun, 20 May 2007 21:25:42 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [xfs-masters] 2.6.22-rc2 built on ppc
Message-ID: <20070521042542.GA11798@tuatara.stupidest.org>
References: <20070520111408.GF3253@aragorn.home.lxtec.de> <9BA71D7C90D3CBF30ABEF4AF@timothy-shimmins-power-mac-g5.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9BA71D7C90D3CBF30ABEF4AF@timothy-shimmins-power-mac-g5.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: riesebie@lxtec.de, xfs@oss.sgi.com

On Mon, May 21, 2007 at 01:25:06PM +1000, Timothy Shimmin wrote:

> However, we can init it on definition to shut the warning up.

Please don't.  It's not a bug, doing an unneeded init just to silence
gcc (gcc could be smarter in some cases) has the potential to hide
real bugs later on.
