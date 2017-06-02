Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdFBDdd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2017 23:33:33 -0400
Date: Thu, 01 Jun 2017 23:33:29 -0400 (EDT)
Message-Id: <20170601.233329.698047529665811283.davem@davemloft.net>
Subject: Re: [sparc64] crc32c misbehave
From: David Miller <davem@davemloft.net>
In-Reply-To: <9902b59c-0f73-f306-28e0-fea7ee4a1169@sandeen.net>
References: <20170601.174419.2151404855471358626.davem@davemloft.net>
        <20170601.215711.1719799806113363582.davem@davemloft.net>
        <9902b59c-0f73-f306-28e0-fea7ee4a1169@sandeen.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: matorola@gmail.com, sparclinux@vger.kernel.org, linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@sandeen.net>
Date: Thu, 1 Jun 2017 21:10:50 -0500

> On ARM, there was a gcc bug causing similar results - I /think/
> it was https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63293
> 
> "programs could fail sporadically with this if an interrupt happens at
> the wrong instant in time and data was written onto the current stack."
> 
> https://gcc.gnu.org/ml/gcc-patches/2014-09/msg02292.html
> 
> Maybe totally unrelated; if not, hope it helps.  :)

Wow, that looks exactly like what the bug is:

crc32c:
        .register       %g2, #scratch
        save    %sp, -176, %sp  !
        sethi   %hi(tfm), %g1   !, tmp121
        mov     %i2, %o2        ! length,
        ldx     [%g1+%lo(tfm)], %g2     ! tfm, tfm.0_4
        mov     %i1, %o1        ! address,
        lduw    [%g2], %g1      ! tfm.0_4->descsize, tfm.0_4->descsize
        add     %g1, 38, %g1    ! tfm.0_4->descsize,, tmp126
        srlx    %g1, 4, %g1     ! tmp126,, tmp127
        sllx    %g1, 4, %g1     ! tmp127,, tmp128
        sub     %sp, %g1, %sp   !, tmp128,
        add     %sp, 2230, %i5  !,, tmp130

Ok, %i5 holds the stack address of the shash context:

 ...
        return  %i7+8
         lduw   [%o5+16], %o0   ! MEM[(u32 *)__shash_desc.1_10 + 16B],

'return' deallocates the stack frame plus the register window, and at
the same time does a delayed control transfer to "%i7 + 8".  So in the
branch delay slot instruction %i5 becomes %o5.

And here we are accessing deallocated stack memory in the delay slot.

I'm using gcc-6.3.0 here.

And indeed the following patch makes the problem go away:

diff --git a/lib/libcrc32c.c b/lib/libcrc32c.c
index 74a54b7..bf831e2 100644
--- a/lib/libcrc32c.c
+++ b/lib/libcrc32c.c
@@ -43,7 +43,7 @@ static struct crypto_shash *tfm;
 u32 crc32c(u32 crc, const void *address, unsigned int length)
 {
 	SHASH_DESC_ON_STACK(shash, tfm);
-	u32 *ctx = (u32 *)shash_desc_ctx(shash);
+	u32 ret, *ctx = (u32 *)shash_desc_ctx(shash);
 	int err;
 
 	shash->tfm = tfm;
@@ -53,7 +53,9 @@ u32 crc32c(u32 crc, const void *address, unsigned int length)
 	err = crypto_shash_update(shash, address, length);
 	BUG_ON(err);
 
-	return *ctx;
+	ret = *ctx;
+	barrier();
+	return ret;
 }
 
 EXPORT_SYMBOL(crc32c);
