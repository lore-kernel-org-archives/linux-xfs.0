Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr003msb.fastweb.it ([85.18.95.87]:32997 "EHLO
        mr003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdILFYg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2017 01:24:36 -0400
Subject: Re: XFS and sector size on thin volumes
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Sep 2017 07:24:32 +0200
From: Gionatan Danti <g.danti@assyoma.it>
In-Reply-To: <9d6b72e9-37ca-70f9-a40d-62ceaafc9db6@sandeen.net>
References: <d95f09118ee6cb2fe0562ad35303715c@assyoma.it>
 <20170909231215.GK17782@dastard>
 <0c59ba403f83e571d695a716ccad5d0a@assyoma.it>
 <20170909235323.GL17782@dastard>
 <838841738c3d8ca84328075615f95475@assyoma.it>
 <9d6b72e9-37ca-70f9-a40d-62ceaafc9db6@sandeen.net>
Message-ID: <e94a47555325c3e87e5d184e1cab20b4@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, g.danti@assyoma.it

Il 12-09-2017 00:28 Eric Sandeen ha scritto:
> I don't think -b size=4k will change anything.  If you specify -s 
> size=512, that
> might shut up the warning.  If the warning doesn't bother you, I don't 
> think
> anything is particularly wrong with the filesystem it created.
> 
> -Eric

Hi Eric,
so no performance decrease is expected by letting the journal to be 
aligned to 512 byte boundary, even on an underlying 512e/4K disk?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
