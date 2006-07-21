Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Jul 2006 06:12:09 -0700 (PDT)
Received: from orca.ele.uri.edu (orca.ele.uri.edu [131.128.51.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6LDB5DW032181
	for <linux-xfs@oss.sgi.com>; Fri, 21 Jul 2006 06:11:39 -0700
Subject: Re: stable xfs
From: Ming Zhang <mingz@ele.uri.edu>
Reply-To: mingz@ele.uri.edu
In-Reply-To: <20060721032632.GA4138@tuatara.stupidest.org>
References: <17597.27469.834961.186850@base.ty.sabi.co.UK>
	 <1153272044.2669.282.camel@localhost.localdomain>
	 <17598.2129.999932.67127@base.ty.sabi.co.UK>
	 <1153314670.2691.14.camel@localhost.localdomain>
	 <20060720061527.GB18135@tuatara.stupidest.org>
	 <1153404502.2768.50.camel@localhost.localdomain>
	 <20060720161707.GB26748@tuatara.stupidest.org>
	 <1153413481.2768.65.camel@localhost.localdomain>
	 <20060720190401.GA28836@tuatara.stupidest.org>
	 <1153441178.2768.158.camel@localhost.localdomain>
	 <20060721032632.GA4138@tuatara.stupidest.org>
Content-Type: text/plain
Date: Fri, 21 Jul 2006 09:10:31 -0400
Message-Id: <1153487431.2841.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>, Linux XFS <linux-xfs@oss.sgi.com>

On Thu, 2006-07-20 at 20:26 -0700, Chris Wedgwood wrote:
> On Thu, Jul 20, 2006 at 08:19:38PM -0400, Ming Zhang wrote:
> 
> > what will be the side effect about this scattering?
> 
> there is a desire in some cases to have files in the same directory
> close to each other on disk

then what is the benefit? because files under same dir can be accessed
with locality so put close will reduce disk head seek? other than this,
what else benefit?


> 
> > one thing i worry about fsr is when do fsr and some power loss
> > events happen, can xfs handle this well?
> 
> yes, fsr create a temporary file, unlinks it, copies the extents over,
> and does an atomic swap-extents-if-nothing-changed operation

so if i have 500GB file, will it be copied to another 500GB temp file?
sounds scary for me.

Ming
