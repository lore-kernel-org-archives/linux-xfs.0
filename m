Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Jun 2007 23:31:01 -0700 (PDT)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l536UtWt020599
	for <xfs@oss.sgi.com>; Sat, 2 Jun 2007 23:30:56 -0700
Message-ID: <46626019.3070807@goop.org>
Date: Sat, 02 Jun 2007 23:30:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
References: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan> <4661F511.4070207@goop.org> <Pine.LNX.4.64.0706021855260.3376@p34.internal.lan> <alpine.DEB.0.99.0706030115410.16496@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.0.99.0706030115410.16496@sheep.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Christian Kujau wrote:
> Just for the record, you mean this one:
> http://lkml.org/lkml/2007/5/12/93   ..right? (haven't been bitten by
> this one...yet)

That's the one.  It's fairly subtle; there's no metadata/filesystem
corruption, and the file just reverts back to a previous length, so if
it were append-only, it would just return to a previous state.

    J
