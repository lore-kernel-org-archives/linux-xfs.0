Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33328 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfBEKAX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Feb 2019 05:00:23 -0500
Received: by mail-lj1-f195.google.com with SMTP id v1-v6so2379406ljd.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 Feb 2019 02:00:22 -0800 (PST)
Subject: Re: [PATCH] xfs: allow disabling xfs tracepoints via Kconfig
References: <20190204212035.9919-1-linux@rasmusvillemoes.dk>
 <20190204215332.GB14116@dastard>
 <4d66f2c2-bf5c-be47-9ef1-e581c5901823@rasmusvillemoes.dk>
 <20190204231346.GC14116@dastard>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <8d36092f-adea-a025-380f-a97de6bc93e0@rasmusvillemoes.dk>
Date: Tue, 5 Feb 2019 11:00:20 +0100
MIME-Version: 1.0
In-Reply-To: <20190204231346.GC14116@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On 05/02/2019 00.13, Dave Chinner wrote:
> On Mon, Feb 04, 2019 at 11:12:57PM +0100, Rasmus Villemoes wrote:
>> On 04/02/2019 22.53, Dave Chinner wrote:
>>> On Mon, Feb 04, 2019 at 10:20:35PM +0100, Rasmus Villemoes wrote:
>>>> linux/tracepoints.h allows individual subsystems to disable their
>>>> tracepoints. Add such a knob for xfs. Disabling XFS_TRACEPOINTS
>>>> reduces the resident size of xfs.ko by about a third, or ~350 KiB.
> 
> Do you have a specific need for this, or is it just "I noticed this,
> here's a patch"? 

A little of both, actually. I noticed it, did the patch for the kernel I
use on my laptop, and thought others might find it useful. But no, I
don't currently deal with any customer boards where it'd be relevant.

> If you need it and will use it, great, let's add
> it. But config options that don't ever get used tend to rot....

Fair enough, I'll just keep it privately and resend if I encounter a use
case in the wild.

Rasmus
