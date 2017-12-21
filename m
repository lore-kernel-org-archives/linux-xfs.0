Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:32806 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753934AbdLUQqL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Dec 2017 11:46:11 -0500
Date: Thu, 21 Dec 2017 08:45:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ZOMG RFCRAP PATCH 0/2] xfs: horrifying eBPF hacks
Message-ID: <20171221164535.GS12613@magnolia>
References: <20171213061825.GO19219@magnolia>
 <20171221133338.GD1567@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171221133338.GD1567@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Richard Wareing <rwareing@fb.com>, david@fromorbit.com

On Thu, Dec 21, 2017 at 05:33:38AM -0800, Christoph Hellwig wrote:
> Eek.  Whie eBPF is a really nice debug tool we should never use
> it for actual required kernel I/O functionality.

Certainly not in its current hacky form.  I'm curious if Richard has had
a chance to try out these patches to see if it affects performance in a
noticeable way?

I /think/ bpf has enough safety mechanisms (no loops, no direct writing
to kernel memory, bytecode verifiers, opcode count limits) that such a
beast could be hidden behind a kconfig option that isn't turned for the
general public.  For people who have these particularly specific use
cases I think it better to have a general mechanism to accomodate them
vs. scattering code all over xfs vs. "no sorry go away", though this
ebpf thing isn't necessarily the final answer.  We do validate that the
proposed iflags are allowed for the fs geometry, though I acknowledge
that the prospect of running ebpf with ilock_excl does give me pause.

I'm curious, though, what are your (and everyone else's) concerns about
this?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
