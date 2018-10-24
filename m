Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52928 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725821AbeJYEkN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Oct 2018 00:40:13 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id A39882AF6F
        for <linux-xfs@vger.kernel.org>; Wed, 24 Oct 2018 20:10:39 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201453] Bug 1640090 - [xfstests xfs/490]: xfs_db print a bad
 (negative number) as agi freecount
Date: Wed, 24 Oct 2018 20:10:39 +0000
Message-ID: <bug-201453-201763-bguEGVYkfx@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201453-201763@https.bugzilla.kernel.org/>
References: <bug-201453-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201453

--- Comment #5 from Eric Sandeen (sandeen@sandeen.net) ---
So zorro correctly points out that the big vs little endian certainly should
not matter for this u8.

What does matter is the signed type, because getbitval is doing tricks to try
to handle sign extension and it does it differently for big vs. little endian:

                if (getbit_l(p, bit + i)) {
                        /* If the last bit is on and we care about sign
                         * bits and we don't have a full 64 bit
                         * container, turn all bits on between the
                         * sign bit and the most sig bit.
                         */

                        /* handle endian swap here */
#if __BYTE_ORDER == LITTLE_ENDIAN
                        if (i == 0 && signext && nbits < 64)
                                rval = (~0ULL) << nbits;
                        rval |= 1ULL << (nbits - i - 1);
#else
                        if ((i == (nbits - 1)) && signext && nbits < 64)
                                rval |= ((~0ULL) << nbits);
                        rval |= 1ULL << (nbits - i - 1);
#endif

Switching it to FLDT_UINT8D makes "signext" false so none of this happens, but
that's papering over the underlying bug with signed types.

The bug seems to be the test for if ((i == (nbits - 1)) ...) - this is testing
the last / rightmost bit in the number, which is /not/ the MSB.

But I cannot seem to wrap my head around the right way to fix it, yet.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
