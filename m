Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 20:27:14 -0700 (PDT)
Received: from smtp111.sbc.mail.mud.yahoo.com (smtp111.sbc.mail.mud.yahoo.com [68.142.198.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6L3QwDW009627
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 20:27:03 -0700
Date: Thu, 20 Jul 2006 20:26:32 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: stable xfs
Message-ID: <20060721032632.GA4138@tuatara.stupidest.org>
References: <17597.27469.834961.186850@base.ty.sabi.co.UK> <1153272044.2669.282.camel@localhost.localdomain> <17598.2129.999932.67127@base.ty.sabi.co.UK> <1153314670.2691.14.camel@localhost.localdomain> <20060720061527.GB18135@tuatara.stupidest.org> <1153404502.2768.50.camel@localhost.localdomain> <20060720161707.GB26748@tuatara.stupidest.org> <1153413481.2768.65.camel@localhost.localdomain> <20060720190401.GA28836@tuatara.stupidest.org> <1153441178.2768.158.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1153441178.2768.158.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>, Linux XFS <linux-xfs@oss.sgi.com>

On Thu, Jul 20, 2006 at 08:19:38PM -0400, Ming Zhang wrote:

> what will be the side effect about this scattering?

there is a desire in some cases to have files in the same directory
close to each other on disk

> one thing i worry about fsr is when do fsr and some power loss
> events happen, can xfs handle this well?

yes, fsr create a temporary file, unlinks it, copies the extents over,
and does an atomic swap-extents-if-nothing-changed operation
