Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 May 2007 16:40:54 -0700 (PDT)
Received: from smtp111.sbc.mail.mud.yahoo.com (smtp111.sbc.mail.mud.yahoo.com [68.142.198.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4KNepfB028856
	for <xfs@oss.sgi.com>; Sun, 20 May 2007 16:40:52 -0700
Date: Sun, 20 May 2007 16:40:48 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Review: ensure EOF writes into existing extents update filesize
Message-ID: <20070520234048.GA7423@tuatara.stupidest.org>
References: <20070520233417.GA85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520233417.GA85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, May 21, 2007 at 09:34:17AM +1000, David Chinner wrote:

> In that case, we use a read mapping of the extent, and this also
> happens to use the read I/O completion handler instead of the
> write I/O completion handle. Hence the file size was not updated
> on I/O completion.
>
> Comments?

I've had this (well, the first version you sent to Jeremy) for a few
days on a testing machine without any obvious ill effects.

Once people are happy with this it should be checked to see if it
needs to go into -stable.
