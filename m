Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr001msb.fastweb.it ([85.18.95.85]:33843 "EHLO
        mr001msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753737AbdEHJfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2017 05:35:02 -0400
Subject: Re: XFS and multiple mounts protection (aka preventing multiple
 mounts)
References: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
 <63a045ae-0c12-e1b7-a7e0-df251dd88a4f@sandeen.net>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <473d24bc-bab5-8f1e-efe6-f60e099f636d@assyoma.it>
Date: Mon, 8 May 2017 11:34:53 +0200
MIME-Version: 1.0
In-Reply-To: <63a045ae-0c12-e1b7-a7e0-df251dd88a4f@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

On 05/05/2017 21:20, Eric Sandeen wrote:
> I guess this has been covered, but: no.  There is no cross-machine
> multi-mount protection in XFS.  Nothing like ext4's MMP.
>
> There is a unique UUID test at mount time, so you can't i.e. mount
> the same path twice /on the same box/, but there is no mechanism in
> XFS to prevent the same disk from being mounted by 2 /separate/ machines
> on a SAN.
>
> -Eric

Thanks Eric. Just out of curiosity, there are some specific technical 
motivations to avoid this check?

One more pragmatic question: what kind of corruption can be expected 
from shot-lived (ie some seconds) double mount? For example, in raiserfs 
I remember an immediate catastrophic faileres when a double mount 
happened. On XFS it *seems* that filesystem remain more or less 
consistent (even an xfs_repair does not find nothing wrong).

Thanks again.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
