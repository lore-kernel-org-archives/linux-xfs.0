Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:36156 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726356AbeHQRIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Aug 2018 13:08:02 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BCE972BAE3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Aug 2018 14:04:32 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200835] XFS hangs in xfs_reclaim_inode()
Date: Fri, 17 Aug 2018 14:04:33 +0000
Message-ID: <bug-200835-201763-hTOAB0qHop@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200835-201763@https.bugzilla.kernel.org/>
References: <bug-200835-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200835

--- Comment #9 from Mike Snitzer (snitzer@redhat.com) ---
(In reply to Mike Snitzer from comment #8)

> init_crypt() does the allocation with:
>         gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
>                                                            GFP_ATOMIC;
> 
> So another option would be for DM-crypt to _not_ set
> CRYPTO_TFM_REQ_MAY_SLEEP in struct skcipher_request *req's base.flags (I
> wonder if it defaults to setting it?)
> 
> The crypto code gets opaque quite quickly.. not yet sure where the relevant
> dm-crypt code is that would be able to ensure CRYPTO_TFM_REQ_MAY_SLEEP is
> _not_ set in skcipher_request req->base.flags

drivers/md/dm-crypt.c:crypt_alloc_req_skcipher() is calling
skcipher_request_set_callback() with CRYPTO_TFM_REQ_MAY_SLEEP set.

But there are quite a few other modes that also set CRYPTO_TFM_REQ_MAY_SLEEP. 
And most crypto code uses GFP_KERNEL if that is set.

In any case, it would seem commit f1c131b45410a ("crypto: xts - Convert to
skcipher") is what ushered in the use of GFP_KERNEL underneath dm-crypt's IO
path.

> In any case, it really does seem to make sense to change xts.c:init_crypt()
> to use GDP_NOIO instead of GFP_KERNEL.

I still think switching to GFP_NOIO here needs further thought and review by
the crypto/XTS developers.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
