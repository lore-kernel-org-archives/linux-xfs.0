Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:49710 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751571AbdFIXoU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Jun 2017 19:44:20 -0400
Date: Sat, 10 Jun 2017 09:44:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS journal write ordering constraints?
Message-ID: <20170609234408.GE17542@dastard>
References: <CALoZfD4-uqhRSfEh0Y+v8jjSDY2KkAh-hhwdLnRgZopHEETUXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALoZfD4-uqhRSfEh0Y+v8jjSDY2KkAh-hhwdLnRgZopHEETUXA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sweet Tea Dorminy <sweettea@permabit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 08, 2017 at 11:42:11AM -0400, Sweet Tea Dorminy wrote:
> Greetings;
> 
> When using XFS with a 1k block size atop our device, we regularly get
> "log record CRC mismatch"es when mounting XFS after a crash, and we
> are attempting to understand why. We are using RHEL7.3 with its kernel
> 3.10.0-514.10.2.el7.x86_64, xfsprogs version 4.5.0.
> 
> Tracing indicates the following situation occurs:
>        Some pair of consecutive locations contains data A1 and B1, respectively.
>        The XFS journal issues new writes to those locations,
> containing data A2 and B2.
>        The write of B' finishes, but A' is still outstanding at the
> time of the crash.
>        Crash occurs. The data on disk is A1 and B2, respectively.
>        XFS fails to mount, complaining that the checksum mismatches.
> 
> Does XFS expect sequentially issued journal IO to be committed to disk
> in the order of issuance due to the use of FUA?

Journal IO is not sequentially issued. It's an async process. At
runtime, ordering is handled by journal IO completion processing
being queued and run in order, so IOs can both be issued and
physically complete out of order.

Log recovery is supposed to handle this. It searches and finds the
latest contiguous journal entry and does not replay past holes that
may arise from out of order journal writes.

CRC errors like this in recovery imply that journal writes are being
torn or not completed fully, which may mean that your storage does
not correctly implement flush/FUA ordering semantics....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
