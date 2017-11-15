Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:49808 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758564AbdKOSx5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 13:53:57 -0500
Subject: Re: Disabling barriers on NVC-backed HDD
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 15 Nov 2017 19:53:52 +0100
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20171115173100.GD5119@magnolia>
References: <8b91c685e344bdc5d084b11fab1d50af@assyoma.it>
 <20171115173100.GD5119@magnolia>
Message-ID: <434c9f876ca7fe93664419600e2e33a6@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 15-11-2017 18:31 Darrick J. Wong ha scritto:
> 
> I would evaluate these drives to find out if you really /can/ yank the
> power without losing anything.

If I can get some hard drives for testing, I'll surely do that. However, 
any in-house testing inevitably has limited scope and it can miss some 
important failure modes, so I am interested in other users' first-hand 
experience.

> That said, if the manufacturers aren't willing to tell you how that
> feature works, I'd just as soon pretend the feature didn't exist and
> continue sending flushes to the drive.

 From a point, I agree: I do not like black boxes. On the other hand, 
hardware RAID controllers *are* black boxes, and we all use them...

> FWIW if the drive really /does/ have a non-volatile WC then a flush
> should have nearly zero overhead.  (Or so you'd think...)

 From my understanding (and I can be wrong), these drives honour cache 
flushes, with the associated performance drop.

Ok, too much conjectures from my side, I think. I should *really* get my 
hand on some of these drives...

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
