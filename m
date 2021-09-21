Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6298C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 22:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3B4C61050
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Sep 2021 22:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhIUWtp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Sep 2021 18:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhIUWto (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Sep 2021 18:49:44 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA550C061574;
        Tue, 21 Sep 2021 15:48:15 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so759330pjb.5;
        Tue, 21 Sep 2021 15:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=thKs9j7NHeXLAC4xy9oBr17LsKWi1X85iRFnQIqyr0Q=;
        b=pQX4ZkrPA53HhkZoUo5o8Pxthv04MmobXRXc8OUHNcjYjHQHHH7obUReCw/sslQjnE
         /gPkrJVsthQbTQc2HiisflbLQo9wd+Y+PSvbezvBpNtCQTuvo1fSlNc8yCe4RAK1RRky
         dlsYLJSJ+O4wPM/sunNHQ3jouNg0msXrXyuLHpYyroGM/PmTdhyt+kBEiUv9cigQI9np
         I9KAH/JwYG2Ii2+s6TPYwbmmGwy2LS8eO09I+cLRwk0wz5kMMQwrkNBZ+P7+OIqQh8gZ
         hLu/3yJHJEOjkdA18jn9DxClLMiw1KCAKV4HC3I4jr2AU98rJ91MehnPhyzUXkxh5FII
         m9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=thKs9j7NHeXLAC4xy9oBr17LsKWi1X85iRFnQIqyr0Q=;
        b=7ntg4qSHbFzbzoBz52B0aXf93kbMW7SwZXPDl+v6tky/HSsmVSWqwVBh8qT/YkK+KD
         E7oCVlTQhd8iuIK8KPxzXVtASP5mOGxXEUT1/Gazn/keN15AMwK++Y/DsZExkqaSjRwb
         dv7ETFJFmZ6tplifHYHT0XQIQ2xwkadfbqBeIjLxoUE6Ts6jJP0OXwrBzBdtKdKXx6mh
         HQu6/xrKY0Hteb6/vzJCQ/ZUc1h5Ec6tdj7NDOZ3JtguxUTOy/AjlOd7ZTL6xho12qXY
         kFbZPbkI2Io2ZFIpG/CT49eRcY8pD5P7/p5okAxjc4QA4e25+8MPJeo7QQp0aEecoAtH
         P+ug==
X-Gm-Message-State: AOAM530O6+LwlIlUA8W9+iFxBeTwSUrFIyE81cy1NWDhkTrfc86mMHHu
        7NM/0jkP8yKnj86MEtHBIIezrZJLOes0MtP3
X-Google-Smtp-Source: ABdhPJxWXHEz4y1vSJ67Os2NVr0i94RrC5LHb1WDFOz62HilC9V67SuEZM4fzzQ4HSCISnGr3aOheQ==
X-Received: by 2002:a17:902:a50f:b029:11a:cd45:9009 with SMTP id s15-20020a170902a50fb029011acd459009mr29708624plq.38.1632264495126;
        Tue, 21 Sep 2021 15:48:15 -0700 (PDT)
Received: from nuc10 (d50-92-229-34.bchsia.telus.net. [50.92.229.34])
        by smtp.gmail.com with ESMTPSA id p4sm191996pgc.15.2021.09.21.15.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 15:48:14 -0700 (PDT)
Date:   Tue, 21 Sep 2021 15:48:13 -0700
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     Eric Sandeen <sandeen@sandeen.net>, Fengfei Xi <xi.fengfei@h3c.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, tian.xianting@h3c.com
Subject: Re: [PATCH] xfs: fix system crash caused by null bp->b_pages
Message-ID: <YUphLS+pXoVwPxMz@nuc10>
References: <20201224095142.7201-1-xi.fengfei@h3c.com>
 <63d75865-84c6-0f76-81a2-058f4cad1d84@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63d75865-84c6-0f76-81a2-058f4cad1d84@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Fengfei, Eric,

On Thu, Dec 24, 2020 at 01:35:32PM -0600, Eric Sandeen wrote:
> On 12/24/20 3:51 AM, Fengfei Xi wrote:
> > We have encountered the following problems several times:
> >     1、A raid slot or hardware problem causes block device loss.
> >     2、Continue to issue IO requests to the problematic block device.
> >     3、The system possibly crash after a few hours.
> 
> What kernel is this on?
> 

I have a customer that recently hit this issue on 4.12.14-122.74
SLE12-SP5 kernel.

> > dmesg log as below:
> > [15205901.268313] blk_partition_remap: fail for partition 1
> 
> I think this message has been gone since kernel v4.16...
> 
> If you're testing this on an old kernel, can you reproduce it on a
> current kernel?
> 

I am trying to figure out/create a reproducer for this bug, so that I
could test it against upstream kernel, but it proves to be a bit hard so
far.
Fengfei, have you managed to come up with one? Have you tried block IO
fault injection (CONFIG_FAIL_MAKE_REQUEST)?

> > [15205901.319309] blk_partition_remap: fail for partition 1
> > [15205901.319341] blk_partition_remap: fail for partition 1
> > [15205901.319873] sysctl (3998546): drop_caches: 3
> 
> What performed the drop_caches immediately before the BUG?  Does
> the BUG happen without drop_caches?
> 

It does happen without drop_caches.

> > [15205901.371379] BUG: unable to handle kernel NULL pointer dereference at
> 
> was something lost here?  "dereference at" ... what?
> 

Here is my backtrace:
[965887.179651] XFS (veeamimage0): Mounting V5 Filesystem
[965887.848169] XFS (veeamimage0): Starting recovery (logdev: internal)
[965888.268088] XFS (veeamimage0): Ending recovery (logdev: internal)
[965888.289466] XFS (veeamimage1): Mounting V5 Filesystem
[965888.406585] XFS (veeamimage1): Starting recovery (logdev: internal)
[965888.473768] XFS (veeamimage1): Ending recovery (logdev: internal)
[986032.367648] XFS (veeamimage0): metadata I/O error: block 0x1044a20 ("xfs_buf_iodone_callback_error") error 5 numblks 32
[986033.152809] BUG: unable to handle kernel NULL pointer dereference at           (null)
[986033.152973] IP: xfs_buf_offset+0x2c/0x60 [xfs]
[986033.153013] PGD 0 P4D 0 
[986033.153041] Oops: 0000 [#1] SMP PTI
[986033.153083] CPU: 13 PID: 48029 Comm: xfsaild/veeamim Tainted: P           OE      4.12.14-122.74-default #1 SLE12-SP5
[986033.153162] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 10/21/2019
[986033.153225] task: ffff9835ba7b8c40 task.stack: ffffb581a7bbc000
[986033.153328] RIP: 0010:xfs_buf_offset+0x2c/0x60 [xfs]
[986033.153370] RSP: 0018:ffffb581a7bbfce0 EFLAGS: 00010246
[986033.153413] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000009
[986033.153471] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff97f716757c80
[986033.153526] RBP: ffff983702a81000 R08: ffffb581a7bbfd00 R09: 0000000000007c00
[986033.153581] R10: ffffb581a7bbfd98 R11: 0000000000000005 R12: 0000000000000020
[986033.153640] R13: ffff97f716757c80 R14: 0000000000000000 R15: ffff97f716757c80
[986033.153703] FS:  0000000000000000(0000) GS:ffff987471a40000(0000) knlGS:0000000000000000
[986033.153764] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[986033.153811] CR2: 0000000000000000 CR3: 000000560500a006 CR4: 00000000001606e0
[986033.153866] Call Trace:
[986033.153949]  xfs_inode_buf_verify+0x83/0xe0 [xfs]
[986033.154044]  ? xfs_buf_delwri_submit_buffers+0x120/0x230 [xfs]
[986033.154142]  _xfs_buf_ioapply+0x82/0x410 [xfs]
[986033.154230]  ? xfs_buf_delwri_submit_buffers+0x120/0x230 [xfs]
[986033.154326]  xfs_buf_submit+0x63/0x210 [xfs]
[986033.154410]  xfs_buf_delwri_submit_buffers+0x120/0x230 [xfs]
[986033.154516]  ? xfsaild+0x29f/0x7a0 [xfs]
[986033.154607]  xfsaild+0x29f/0x7a0 [xfs]
[986033.154651]  kthread+0xf6/0x130
[986033.154733]  ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
[986033.154781]  ? kthread_bind+0x10/0x10
[986033.154820]  ret_from_fork+0x35/0x40

> > [15205901.372602] IP: xfs_buf_offset+0x32/0x60 [xfs]
> > [15205901.373605] PGD 0 P4D 0
> > [15205901.374690] Oops: 0000 [#1] SMP
> > [15205901.375629] Modules linked in:
> > [15205901.382445] CPU: 6 PID: 18545 Comm: xfsaild/sdh1 Kdump: loaded Tainted: G
> > [15205901.384728] Hardware name:
> > [15205901.385830] task: ffff885216939e80 task.stack: ffffb28ba9b38000
> > [15205901.386974] RIP: 0010:xfs_buf_offset+0x32/0x60 [xfs]
> > [15205901.388044] RSP: 0018:ffffb28ba9b3bc68 EFLAGS: 00010246
> > [15205901.389021] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000b
> > [15205901.390016] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88627bebf000
> > [15205901.391075] RBP: ffffb28ba9b3bc98 R08: ffff88627bebf000 R09: 00000001802a000d
> > [15205901.392031] R10: ffff88521f3a0240 R11: ffff88627bebf000 R12: ffff88521041e000
> > [15205901.392950] R13: 0000000000000020 R14: ffff88627bebf000 R15: 0000000000000000
> > [15205901.393858] FS:  0000000000000000(0000) GS:ffff88521f380000(0000) knlGS:0000000000000000
> > [15205901.394774] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [15205901.395756] CR2: 0000000000000000 CR3: 000000099bc09001 CR4: 00000000007606e0
> > [15205901.396904] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [15205901.397869] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [15205901.398836] PKRU: 55555554
> > [15205901.400111] Call Trace:
> > [15205901.401058]  ? xfs_inode_buf_verify+0x8e/0xf0 [xfs]
> > [15205901.402069]  ? xfs_buf_delwri_submit_buffers+0x16d/0x2b0 [xfs]
> > [15205901.403060]  xfs_inode_buf_write_verify+0x10/0x20 [xfs]
> > [15205901.404017]  _xfs_buf_ioapply+0x88/0x410 [xfs]
> > [15205901.404990]  ? xfs_buf_delwri_submit_buffers+0x16d/0x2b0 [xfs]
> > [15205901.405929]  xfs_buf_submit+0x63/0x200 [xfs]
> > [15205901.406801]  xfs_buf_delwri_submit_buffers+0x16d/0x2b0 [xfs]
> > [15205901.407675]  ? xfs_buf_delwri_submit_nowait+0x10/0x20 [xfs]
> > [15205901.408540]  ? xfs_inode_item_push+0xb7/0x190 [xfs]
> > [15205901.409395]  xfs_buf_delwri_submit_nowait+0x10/0x20 [xfs]
> > [15205901.410249]  xfsaild+0x29a/0x780 [xfs]
> > [15205901.411121]  kthread+0x109/0x140
> > [15205901.411981]  ? xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
> > [15205901.412785]  ? kthread_park+0x60/0x60
> > [15205901.413578]  ret_from_fork+0x2a/0x40
> > 
> > The "obvious" cause is that the bp->b_pages was NULL in function
> > xfs_buf_offset. Analyzing vmcore, we found that b_pages=NULL but
> > b_page_count=16, so b_pages is set to NULL for some reason.
> 
> this can happen, for example _xfs_buf_get_pages sets the count, but may
> fail the allocation, and leave the count set while the pointer is NULL.

Thanks for the info, I will look into it.

> > 
> > crash> struct xfs_buf ffff88627bebf000 | less
> >     ...
> >   b_pages = 0x0,
> >   b_page_array = {0x0, 0x0},
> >   b_maps = 0xffff88627bebf118,
> >   __b_map = {
> >     bm_bn = 512,
> >     bm_len = 128
> >   },
> >   b_map_count = 1,
> >   b_io_length = 128,
> >   b_pin_count = {
> >     counter = 0
> >   },
> >   b_io_remaining = {
> >     counter = 1
> >   },
> >   b_page_count = 16,
> >   b_offset = 0,
> >   b_error = 0,
> >     ...
> > 
> > To avoid system crash, we can add the check of 'bp->b_pages' to
> > xfs_inode_buf_verify(). If b_pages == NULL, we mark the buffer
> > as -EFSCORRUPTED and the IO will not dispatched.
> > 
> > Signed-off-by: Fengfei Xi <xi.fengfei@h3c.com>
> > Reviewed-by: Xianting Tian <tian.xianting@h3c.com>
> > ---
> >  fs/xfs/libxfs/xfs_inode_buf.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index c667c63f2..5a485c51f 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -45,6 +45,17 @@ xfs_inode_buf_verify(
> >  	int		i;
> >  	int		ni;
> >  
> > +	/*
> > +	 * Don't crash and mark buffer EFSCORRUPTED when b_pages is NULL
> > +	 */
> > +	if (!bp->b_pages) {
> > +		xfs_buf_ioerror(bp, -EFSCORRUPTED);
> > +		xfs_alert(mp,
> > +			"xfs_buf(%p) b_pages corruption detected at %pS\n",
> > +			bp, __return_address);
> > +		return;
> > +	}
> 
> This seems fairly ad hoc.
> 
> I think we need a better idea of how we got here; why should inode buffers
> be uniquely impacted (or defensively protected?)  Can you reproduce this
> using virtual devices so the test can be scripted?
> 

That's the challenge, it would have been easier if syzbot hit this bug,
but so far it did not.

