Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr014msb.fastweb.it ([85.18.95.103]:57074 "EHLO
        mr014msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbeBYLkt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Feb 2018 06:40:49 -0500
Subject: Re: Reflink (cow) copy of busy files
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 25 Feb 2018 12:40:47 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20180225024727.GD30854@dastard>
References: <9e69fcd01e1c02ea53e0e1ac66d60d24@assyoma.it>
 <20180224220757.GC30854@dastard>
 <711dd96e3c4b3e92d3fb38a01e77dc64@assyoma.it>
 <20180225024727.GD30854@dastard>
Message-ID: <25ebcdb42650430d83d283435053efed@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 25-02-2018 03:47 Dave Chinner ha scritto:
> 
> Yes, you have to freeze the filesystem to get a crash-consistent
> snapshot of the filesystem.
> 
> 
> You will end up with garbage.

Ok. Bonus question: am I right thinking this is due to the CoW copy not 
being atomic (ie: the various extents being in different state until the 
copy is finished)?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
