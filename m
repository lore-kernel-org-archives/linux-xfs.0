Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jul 2008 04:16:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6IBGN6n006211
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2008 04:16:27 -0700
Received: from smtp-out04.alice-dsl.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8CC7304858
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2008 04:17:31 -0700 (PDT)
Received: from smtp-out04.alice-dsl.net (smtp-out04.alice-dsl.net [88.44.63.6]) by cuda.sgi.com with ESMTP id dbgL12MSjelldPmd for <xfs@oss.sgi.com>; Fri, 18 Jul 2008 04:17:31 -0700 (PDT)
Subject: Re: Power loss causes bad magic number??
From: Andi Kleen <andi@firstfloor.org>
References: <F46A887185FC6044A7FAC577E31118AE022316C0@rsbne01.RSBNE.LOCAL>
	<487D5F80.1050909@sandeen.net>
	<F46A887185FC6044A7FAC577E31118AE021E0623@rsbne01.RSBNE.LOCAL>
	<20080716073503.GE29319@disturbed>
	<F46A887185FC6044A7FAC577E31118AE021E0625@rsbne01.RSBNE.LOCAL>
	<487F4AC5.3000806@thebarn.com>
	<F46A887185FC6044A7FAC577E31118AE02231846@rsbne01.RSBNE.LOCAL>
Date: Fri, 18 Jul 2008 13:17:21 +0200
In-Reply-To: <F46A887185FC6044A7FAC577E31118AE02231846@rsbne01.RSBNE.LOCAL> (Stephen Porter's message of "Fri, 18 Jul 2008 07:52:43 +1000")
Message-ID: <87zlofqw5a.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen Porter <stephenp@r-s.com.au>
Cc: Russell Cattelan <cattelan@thebarn.com>, xfs@oss.sgi.com

"Stephen Porter" <stephenp@r-s.com.au> writes:
>   
> I think this is going to be my only option (unless I want to keep
> updating fstab entries each time _something_ updates on the box).  Time
> to visit google again.  I realise this is now way off topic, but is
> there a "preferred method" with regards to mounting by labels or uuid?

Modern distributions generall give you several other options using udev.
e.g. common is using /dev/disk/by-path/ (which should be stable)
Drawback is that this always requires a initrd for mounting /

-Andi
