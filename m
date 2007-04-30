Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Apr 2007 14:35:47 -0700 (PDT)
Received: from smtp111.sbc.mail.mud.yahoo.com (smtp111.sbc.mail.mud.yahoo.com [68.142.198.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3ULZgfB003268
	for <xfs@oss.sgi.com>; Mon, 30 Apr 2007 14:35:43 -0700
Date: Mon, 30 Apr 2007 14:35:38 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: Slow performance when extracting tarballs
Message-ID: <20070430213538.GA30809@tuatara.stupidest.org>
References: <4635DAA4.4070402@griffith.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4635DAA4.4070402@griffith.edu.au>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen So <s.so@griffith.edu.au>
Cc: xfs@oss.sgi.com

On Mon, Apr 30, 2007 at 10:01:40PM +1000, Stephen So wrote:

> After looking at top during the extraction process, bzip2 uses about
> 80-90% of CPU initially and extraction seems quite fast but after a
> few seconds, it drops to 30-40%, the system becomes non responsive,
> and extraction is much slower.

what does "vmstat 1" look like during this?

> noatime, nodiratime, logbufs=8

have you also tried setting (increasing) logbsize?  (i think you need
v2 logs to make that work)
