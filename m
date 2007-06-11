Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Jun 2007 00:36:10 -0700 (PDT)
Received: from smtp113.sbc.mail.re2.yahoo.com (smtp113.sbc.mail.re2.yahoo.com [68.142.229.92])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5B7a5Wt003963
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2007 00:36:06 -0700
Date: Mon, 11 Jun 2007 00:35:59 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: xfs_fsr allocation group optimization
Message-ID: <20070611073559.GA26257@tuatara.stupidest.org>
References: <1181544692.19145.44.camel@gentoo-johan.transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181544692.19145.44.camel@gentoo-johan.transmode.se>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Johan Andersson <johan@e-626.net>
Cc: xfs@oss.sgi.com

On Mon, Jun 11, 2007 at 08:51:32AM +0200, Johan Andersson wrote:

> So I run some tests. And as Chris pointed out, when running xfs_fsr
> on a badly fragmented filesystem, it completely destroys the
> locality of files.

You can always do something like:

   find path/to/defrag/ -type f -print0 | xargs -r0 xfs_fsr -v

and check /var/log/daemon.log (or whatever) for a progress report.

This will of course only make one pass, so you might want to wrap it.
But unless you're really low on space it's probably not useful to make
many passes anyhow.

You might always want the -d argument (not sure if the man page has
this).
