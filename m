Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr014msb.fastweb.it ([85.18.95.103]:39228 "EHLO
        mr014msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbeBXW5f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Feb 2018 17:57:35 -0500
Subject: Re: Reflink (cow) copy of busy files
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 24 Feb 2018 23:57:32 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20180224220757.GC30854@dastard>
References: <9e69fcd01e1c02ea53e0e1ac66d60d24@assyoma.it>
 <20180224220757.GC30854@dastard>
Message-ID: <711dd96e3c4b3e92d3fb38a01e77dc64@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 24-02-2018 23:07 Dave Chinner ha scritto:
> Define "busy file", please.

Think about a running virtual machine. Maybe an XFS-based virtual image 
(ie: a CentOS 7 guest).

> If the file is being actively written, then the clone will not be
> consistent.
> 
> Yes, it's just like any other snapshot process - you have to quiesce
> everything that is writing to the file before cloning it. i.e. the
> data in the file needs to be in a stable, consistent, unchanging
> state if you want the clone to contain consistent data...

About *what* level of consistency are we speaking? I understand that 
application-level consistency requires a quiesced filesystem and, 
possibly, an application-level agent. But is it a quiesced filesystem a 
requisite for a *crash-consistent* ie: pull the plug) snapshot?

In other words: would a cp --reflink=always <vmdisk> <snapshot> of a 
runnig virtual machine produce an usable, crash-consistent snapshot, or 
it risks ending with binary garbage?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
