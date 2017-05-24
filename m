Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mr002msb.fastweb.it ([85.18.95.86]:39171 "EHLO
        mr002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932397AbdEXRwW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2017 13:52:22 -0400
Subject: Re: Shutdown filesystem when a thin pool become full
References: <c25a8ccc-f143-989d-3d49-3fe8753aa6f7@assyoma.it>
 <20170522230946.s3sdg4gd73oj7r5u@eorzea.usersys.redhat.com>
 <940c3b13-dea2-1887-d4ae-89555d1c2a4f@assyoma.it>
 <5f98a296-6023-f200-4c60-bcfdf0288d34@assyoma.it>
 <20170523122753.k7plzg3musc4up73@eorzea.usersys.redhat.com>
 <24daa89a452496d2cdffa5512a64ed2e@assyoma.it>
 <6b665d39-7bc4-9160-4c3a-d5b9c9994b01@sandeen.net>
From: Gionatan Danti <g.danti@assyoma.it>
Message-ID: <991de44e-ffee-b2d5-c61a-dde3eb786fe9@assyoma.it>
Date: Wed, 24 May 2017 19:52:18 +0200
MIME-Version: 1.0
In-Reply-To: <6b665d39-7bc4-9160-4c3a-d5b9c9994b01@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: it-IT
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Cc: g.danti@assyoma.it

On 23/05/2017 23:33, Eric Sandeen wrote:
> Try setting EIO rather than ENOSPC.
> 
> Even if you run out of space, xfs should not become corrupted.
> You may need to add space to successfully replay the log afterward,
> but if you do, it should replay and everyhthing should be consistent
> (which is not the same as "no data was lost") - is that not the case?
> 
> As for xfs happily running with metadata errors, the tunable error behavior
> should make it stop more quickly, at least if you set it for EIO.
> It usually will eventually stop when it hits what it considers a critical
> metadata IO error...
> 
> -Eric
>

Mmm ok, I need to play better with these tunables ;)

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
