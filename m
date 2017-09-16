Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:45487 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751231AbdIPQnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Sep 2017 12:43:24 -0400
Subject: Re: XFS and sector size on thin volumes
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 16 Sep 2017 18:43:20 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <e94a47555325c3e87e5d184e1cab20b4@assyoma.it>
References: <d95f09118ee6cb2fe0562ad35303715c@assyoma.it>
 <20170909231215.GK17782@dastard>
 <0c59ba403f83e571d695a716ccad5d0a@assyoma.it>
 <20170909235323.GL17782@dastard>
 <838841738c3d8ca84328075615f95475@assyoma.it>
 <9d6b72e9-37ca-70f9-a40d-62ceaafc9db6@sandeen.net>
 <e94a47555325c3e87e5d184e1cab20b4@assyoma.it>
Message-ID: <1357a2ee8280242c68d92cd4aba06f51@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 12-09-2017 07:24 Gionatan Danti ha scritto:
> Hi Eric,
> so no performance decrease is expected by letting the journal to be
> aligned to 512 byte boundary, even on an underlying 512e/4K disk?
> 
> Thanks.

Hi all and sorry for the bump...

So, just to be sure: there is *no* performance penalty in creating an 
XFS filesystem with 512B sector size on a 512e/4Kn disk (which is not 
recognized as an AF disk due to the ZVOL in-between)?

Or should I use "-b size=4k" with mkfs.xfs?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
