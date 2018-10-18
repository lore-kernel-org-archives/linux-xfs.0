Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45556 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727357AbeJROY4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 10:24:56 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 01283286FD
        for <linux-xfs@vger.kernel.org>; Thu, 18 Oct 2018 06:25:30 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201453] Bug 1640090 - [xfstests xfs/490]: xfs_db print a bad
 (negative number) as agi freecount
Date: Thu, 18 Oct 2018 06:25:29 +0000
Message-ID: <bug-201453-201763-sn1H5NB7CF@https.bugzilla.kernel.org/>
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

--- Comment #4 from Zorro Lang (zlang@redhat.com) ---
(In reply to Eric Sandeen from comment #3)
> Yep, does this fix it?

Yes, this's helpful.
# xfs_db -c "agi 0" -c "addr root" -c "print recs[1]" /dev/loop1
recs[1] = [startino,holemask,count,freecount,free]
1:[64,0,64,59,0xffffffffffffffe0]


> 
> diff --git a/db/btblock.c b/db/btblock.c
> index cbd2990..5a5b061 100644
> --- a/db/btblock.c
> +++ b/db/btblock.c
> @@ -513,7 +513,7 @@ const field_t       inobt_sprec_flds[] = {
>         { "holemask", FLDT_UINT16X, OI(ROFF(ir_u.sp.ir_holemask)), C1, 0,
>           TYP_NONE },
>         { "count", FLDT_UINT8D, OI(ROFF(ir_u.sp.ir_count)), C1, 0, TYP_NONE
> },
> -       { "freecount", FLDT_INT8D, OI(ROFF(ir_u.sp.ir_freecount)), C1, 0,
> +       { "freecount", FLDT_UINT8D, OI(ROFF(ir_u.sp.ir_freecount)), C1, 0,
>           TYP_NONE },
>         { "free", FLDT_INOFREE, OI(ROFF(ir_free)), C1, 0, TYP_NONE },
>         { NULL }

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
