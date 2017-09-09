Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:46823 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752355AbdIIX0p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Sep 2017 19:26:45 -0400
Subject: Re: XFS and sector size on thin volumes
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 10 Sep 2017 01:26:42 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <20170909231215.GK17782@dastard>
References: <d95f09118ee6cb2fe0562ad35303715c@assyoma.it>
 <20170909231215.GK17782@dastard>
Message-ID: <0c59ba403f83e571d695a716ccad5d0a@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Il 10-09-2017 01:12 Dave Chinner ha scritto:
> 
> Probably not. And, worse, you open up the possibility of torn
> "single sector" writes if the underlying device isn't a native 4k
> sector device.

Good catch, I was not thinking on how sectsize=4K could interact with 
non-4K disks.

However, if using only 4K disks below the thin volumes/ZVOLs, should I 
manually set sectsize=4K?
Or, again, I should stick with the default and stop worring?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
