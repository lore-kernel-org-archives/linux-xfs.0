Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39378 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726367AbeHQQ3D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Aug 2018 12:29:03 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 564C32B8C9
        for <linux-xfs@vger.kernel.org>; Fri, 17 Aug 2018 13:25:39 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200835] XFS hangs in xfs_reclaim_inode()
Date: Fri, 17 Aug 2018 13:25:39 +0000
Message-ID: <bug-200835-201763-JsTdcO9J4D@https.bugzilla.kernel.org/>
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

Mike Snitzer (snitzer@redhat.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |snitzer@redhat.com

--- Comment #8 from Mike Snitzer (snitzer@redhat.com) ---
(In reply to Dave Chinner from comment #5)

> Finally, after the second set of warnings, there are no more warnings, so
> whatever is occurred is temporary and the filesystem is not actually hung.
> i.e. there's no direct evidence in that trace that there was a complete
> system hang. However, there is evidence of a potential problem if your XFS
> filesystem is hosted on dm-crypt volumes.
> 
> i.e. this:
> 
> Aug 16 02:33:30 hpmicroserver kernel: Workqueue: kcryptd kcryptd_crypt
> [dm_crypt]
> Aug 16 02:33:30 hpmicroserver kernel: Call Trace:
...
> Aug 16 02:33:30 hpmicroserver kernel:  ? init_crypt+0x7f/0xd0 [xts]
> Aug 16 02:33:30 hpmicroserver kernel:  __slab_alloc+0x1c/0x30
> Aug 16 02:33:30 hpmicroserver kernel:  __kmalloc+0x18e/0x1f0
> Aug 16 02:33:30 hpmicroserver kernel:  init_crypt+0x7f/0xd0 [xts]
> Aug 16 02:33:30 hpmicroserver kernel:  encrypt+0x15/0x20 [xts]
> Aug 16 02:33:30 hpmicroserver kernel:  crypt_convert+0x954/0xec0 [dm_crypt]
> Aug 16 02:33:30 hpmicroserver kernel:  ? bio_alloc_bioset+0x132/0x1e0
> Aug 16 02:33:30 hpmicroserver kernel:  kcryptd_crypt+0x2b8/0x370 [dm_crypt]
> Aug 16 02:33:30 hpmicroserver kernel:  process_one_work+0x1e9/0x3b0
> Aug 16 02:33:30 hpmicroserver kernel:  worker_thread+0x2b/0x3f0
> Aug 16 02:33:30 hpmicroserver kernel:  ? pwq_unbound_release_workfn+0xc0/0xc0
> Aug 16 02:33:30 hpmicroserver kernel:  kthread+0x119/0x130
> Aug 16 02:33:30 hpmicroserver kernel:  ? __kthread_parkme+0xa0/0xa0
> Au
> 
> This appears to be a potential deadlock via incorrect memory allocation
> contexts in dm-crypt. i.e. the crypto code it uses is doing GFP_KERNEL
> allocations while setting up the encryption context which allows it to get
> stuck in a filesystem that can't make progress until the encryption
> completes. . i.e. the dm-crypt/crypto allocation context should probably be
> GFP_NOIO to prevent memory reclaim recursion into contexts that might be
> already be dependent on dm-crypt making progress (i.e. filesystems)....

So problematic call chain is:
crypt_convert -> encrypt -> init_crypt -> __kmalloc

crypto:xts.c:encrypt is:

static int encrypt(struct skcipher_request *req)
{
        return do_encrypt(req, init_crypt(req, encrypt_done));
}

There are no gfp flags passed in.  SO yes, to be able to work for all callers
init_crypt() should be changed from GFP_KERNEL to GFO_NOIO.

init_crypt() does the allocation with:
        gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
                                                           GFP_ATOMIC;

So another option would be for DM-crypt to _not_ set CRYPTO_TFM_REQ_MAY_SLEEP
in struct skcipher_request *req's base.flags (I wonder if it defaults to
setting it?)

The crypto code gets opaque quite quickly.. not yet sure where the relevant
dm-crypt code is that would be able to ensure CRYPTO_TFM_REQ_MAY_SLEEP is _not_
set in skcipher_request req->base.flags

In any case, it really does seem to make sense to change xts.c:init_crypt() to
use GDP_NOIO instead of GFP_KERNEL.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
