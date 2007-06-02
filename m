Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Jun 2007 15:54:18 -0700 (PDT)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l52MsEWt000899
	for <xfs@oss.sgi.com>; Sat, 2 Jun 2007 15:54:14 -0700
Message-ID: <4661F511.4070207@goop.org>
Date: Sat, 02 Jun 2007 15:54:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
References: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:
> Wondering as their were a lot of XFS related issues early on in
> development..? The 2.6.22-rc3 kernel has the core 2 duo coretemp patch
> by ruik which I want be running as long as 2.6.22-rc3 does not have
> any severe XFS issues? 

XFS currently has a data-corrupting bug, where files which were appended
by small amounts may lose their updates on umount - I see this
corrupting hg repos. There's a patch which works for me, and is in
2.6.22-rc3-mm1, but it hasn't been merged upstream yet.

J
