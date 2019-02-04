Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33782 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfBDWNA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 17:13:00 -0500
Received: by mail-ed1-f68.google.com with SMTP id p6so1364294eds.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Feb 2019 14:12:59 -0800 (PST)
Subject: Re: [PATCH] xfs: allow disabling xfs tracepoints via Kconfig
References: <20190204212035.9919-1-linux@rasmusvillemoes.dk>
 <20190204215332.GB14116@dastard>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <4d66f2c2-bf5c-be47-9ef1-e581c5901823@rasmusvillemoes.dk>
Date: Mon, 4 Feb 2019 23:12:57 +0100
MIME-Version: 1.0
In-Reply-To: <20190204215332.GB14116@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On 04/02/2019 22.53, Dave Chinner wrote:
> On Mon, Feb 04, 2019 at 10:20:35PM +0100, Rasmus Villemoes wrote:
>> linux/tracepoints.h allows individual subsystems to disable their
>> tracepoints. Add such a knob for xfs. Disabling XFS_TRACEPOINTS
>> reduces the resident size of xfs.ko by about a third, or ~350 KiB.
> 
> Ok, now we can't debug typical problems on live production systems
> if tracepoints are turned off on the user/distro kernels.  So under
> what circumstances would we ever want to turn off tracepoints on
> XFS?

I don't expect any mainstream distros to turn it off. But for embedded
systems that use a hand-tuned .config, being able to shave off 100s of K
of the kernel image is quite valuable. Tracing _is_ useful,
also/especially when doing embedded development, which is why "just turn
off CONFIG_TRACING" isn't really an option.

Would the knob be more acceptable if it was under CONFIG_EXPERT?

Rasmus
