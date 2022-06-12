Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DAFC43334
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Jun 2022 18:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiFLSFt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Jun 2022 14:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiFLSFt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Jun 2022 14:05:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D15275EC;
        Sun, 12 Jun 2022 11:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7Nnl5YE6Nlyi6nNG3WhEXA+A0IHz8VS9qyuPEsMmlBg=; b=ZIDtl94J7yI3edbWezhoJ/4XqN
        2Eu/GSyuq4UqtA1cM2joO1Tdgo5ARiWnb9onXe8TCGqhMHv1u1yW/FX8mIlsYc0sxVE7zWGi8qjhT
        wzZgALuMWwvKBEkJYhx8aVqQvsFtIRLsBQm720zFxZ2W1FqdNy83cqHLBDbZodddYJQdASExCp+VE
        jE+V8yZfZ/n0KxvVd+wy1tk34s+ZcMi7eu8SfxLFkk/PBTa27YxUlpjN67aBFA3y3RvWAWcWGYOC1
        p3fzsVI3RhTyat5Rq1vVXnfAqi7tNU3wVG5khIAcuX2+EOGAHD5sVG5Ngd3mext09rXKk+3mErLaU
        Fur5n1sg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o0Rxz-00GB1o-K9; Sun, 12 Jun 2022 18:05:39 +0000
Date:   Sun, 12 Jun 2022 19:05:39 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Uladzislau Rezki <urezki@gmail.com>, Zorro Lang <zlang@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        bugzilla-daemon@kernel.org, linux-s390@vger.kernel.org,
        linux-xfs@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, Kees Cook <keescook@chromium.org>
Subject: Re: [Bug 216073] New: [s390x] kernel BUG at mm/usercopy.c:101!
 usercopy: Kernel memory exposure attempt detected from vmalloc 'n o area'
 (offset 0, size 1)!
Message-ID: <YqYq846zFUInllTw@casper.infradead.org>
References: <bug-216073-27@https.bugzilla.kernel.org/>
 <20220606151312.6a9d098c85ed060d36519600@linux-foundation.org>
 <Yp9pHV14OqvH0n02@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220608021922.n2izu7n4yoadknkx@zlang-mailbox>
 <YqD0yAELzHxdRBU6@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <20220612044230.murerhsa765akogj@zlang-mailbox>
 <YqXU+oU7wayOcmCe@casper.infradead.org>
 <YqXkGMY9xtUvPR5D@pc638.lan>
 <YqYh0xyJvoNsSOpy@casper.infradead.org>
 <CAOUHufbBkcjChkMfF8exh3=6=JM09-GCU71KXhUGmz4UdOhUmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOUHufbBkcjChkMfF8exh3=6=JM09-GCU71KXhUGmz4UdOhUmg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 12, 2022 at 11:59:58AM -0600, Yu Zhao wrote:
> Please let me know if there is something we want to test -- I can
> reproduce the problem reliably:
> 
> ------------[ cut here ]------------
> kernel BUG at mm/usercopy.c:101!

The line right before cut here would have been nice ;-)

https://lore.kernel.org/linux-mm/YqXU+oU7wayOcmCe@casper.infradead.org/

might fix your problem, but I can't be sure without that line.

> Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
> CPU: 4 PID: 3259 Comm: iptables Not tainted 5.19.0-rc1-lockdep+ #1
> pc : usercopy_abort+0x9c/0xa0
> lr : usercopy_abort+0x9c/0xa0
> sp : ffffffc010bd78d0
> x29: ffffffc010bd78e0 x28: 42ffff80ac08d8ec x27: 42ffff80ac08d8ec
> x26: 42ffff80ac08d8c0 x25: 000000000000000a x24: ffffffdf4c7e5120
> x23: 000000000bec44c2 x22: efffffc000000000 x21: ffffffdf2896b0c0
> x20: 0000000000000001 x19: 000000000000000b x18: 0000000000000000
> x17: 2820636f6c6c616d x16: 0000000000000042 x15: 6574636574656420
> x14: 74706d6574746120 x13: 0000000000000018 x12: 000000000000000d
> x11: ff80007fffffffff x10: 0000000000000001 x9 : db174b7f89103400
> x8 : db174b7f89103400 x7 : 0000000000000000 x6 : 79706f6372657375
> x5 : ffffffdf4d9c617e x4 : 0000000000000000 x3 : ffffffdf4b7d017c
> x2 : ffffff80eb188b18 x1 : 42ffff80ac08d8c8 x0 : 0000000000000066
> Call trace:
>  usercopy_abort+0x9c/0xa0
>  __check_object_size+0x38c/0x400
>  xt_obj_to_user+0xe4/0x200
>  xt_compat_target_to_user+0xd8/0x18c
>  compat_copy_entries_to_user+0x278/0x424
>  do_ipt_get_ctl+0x7bc/0xb2c
>  nf_getsockopt+0x7c/0xb4
>  ip_getsockopt+0xee8/0xfa4
>  raw_getsockopt+0xf4/0x23c
>  sock_common_getsockopt+0x48/0x54
>  __sys_getsockopt+0x11c/0x2f8
>  __arm64_sys_getsockopt+0x60/0x70
>  el0_svc_common+0xfc/0x1cc
>  do_el0_svc_compat+0x38/0x5c
>  el0_svc_compat+0x68/0xf4
>  el0t_32_sync_handler+0xc0/0xf0
>  el0t_32_sync+0x190/0x194
> Code: aa0903e4 a9017bfd 910043fd 9438be18 (d4210000)
> ---[ end trace 0000000000000000 ]---
