Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 07:56:38 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2TEuQ6p016012
	for <linux-xfs@oss.sgi.com>; Thu, 29 Mar 2007 07:56:31 -0700
Received: from localhost (dslb-084-057-114-201.pools.arcor-ip.net [84.57.114.201])
	by mail.lichtvoll.de (Postfix) with ESMTP id BD4865AD36
	for <linux-xfs@oss.sgi.com>; Thu, 29 Mar 2007 16:56:23 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS and write barriers.
Date: Thu, 29 Mar 2007 16:56:21 +0200
References: <17923.11463.459927.628762@notabene.brown> <17927.19372.553410.527506@notabene.brown> <20070326090456.GO32597093@melbourne.sgi.com>
In-Reply-To: <20070326090456.GO32597093@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200703291656.22084.Martin@lichtvoll.de>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Montag 26 März 2007 schrieb David Chinner:

> > Is there some mount flag to say "cope without barriers" or "require
> > barriers" ??
>
> XFs has "-o nobarrier" to say don't use barriers, and this is
> *not* the default. If barriers don't work, we drop back to "-o
> nobarrier" after leaving a loud warning inthe log....

Hello David!

Just a thought, maybe it shouldn't do that automatically, but require the 
sysadmin to explicitely state "-o nobarrier" in that case. Safest default 
behavior IMHO would be either not to mount at all without "-o nobarrier" 
if the device has no barrier support or disable the write cache of that 
device. The latter can be considered a layering violation in itself.

BTW XFS copes really well here with commodity hardware such as my 
ThinkPads with 2.5 inch notebook harddisks *since* 2.6.17.7.

But right now I wondered about barrier support on USB connected devices? I 
have to check whether XFS does barriers on those. Does the usb mass 
storage driver support barriers?

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
