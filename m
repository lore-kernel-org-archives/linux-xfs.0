Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 23:16:05 -0700 (PDT)
Received: from smtp103.sbc.mail.mud.yahoo.com (smtp103.sbc.mail.mud.yahoo.com [68.142.198.202])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6K6FsDW032196
	for <linux-xfs@oss.sgi.com>; Wed, 19 Jul 2006 23:15:54 -0700
Date: Wed, 19 Jul 2006 23:15:27 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: stable xfs
Message-ID: <20060720061527.GB18135@tuatara.stupidest.org>
References: <1153150223.4532.24.camel@localhost.localdomain> <17595.47312.720883.451573@base.ty.sabi.co.UK> <1153262166.2669.267.camel@localhost.localdomain> <17597.27469.834961.186850@base.ty.sabi.co.UK> <1153272044.2669.282.camel@localhost.localdomain> <17598.2129.999932.67127@base.ty.sabi.co.UK> <1153314670.2691.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1153314670.2691.14.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>, Linux XFS <linux-xfs@oss.sgi.com>

On Wed, Jul 19, 2006 at 09:11:10AM -0400, Ming Zhang wrote:

> what kind of "ram vs fs" size ratio here will be a safe/good/proper
> one?

it depends very much on what you are doing

> any rule of thumb? thanks!
>
> hope not 1:1. :)

i recent dealt with a corrupted filesystem that xfs_repair needed over
1GB to deal with --- the kicker is the filesystem was only 20GB, so
that's 20:1 for xfs_repair

i suspect that was anomalous though and that some bug or quirk of
their fs cause xfs_repair to behave badly (that said, i'd had to have
to repair an 8TB fs fill of maildir email boxes, which i know some
people have)
