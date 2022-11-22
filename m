Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF9BC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Nov 2022 04:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiKVEfN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 23:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiKVEfK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 23:35:10 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C31922BFA
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 20:35:09 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id b62so13105731pgc.0
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 20:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=scy0DmMGTndLYIcghN4C4vI1CT4dWzOGN33Vj8jyBtY=;
        b=m/fIvq1vC1qWchfsWqRsJP51CNbInf+gR3FquxeqkFPXcG+kaLDVZ+1mxItDGw2eH+
         ZtbKfWmIQeoI7dPLYVCdJvQUU0ZAyhG7arTlTpEBLj3HouzBkkH7ICVKfrK5QSwnVBwU
         Z/iCd4NVzizA0MqaHJ5iQ/ClZrCVxtIw04TBHG7t2cSsXraho7IxZmg5HwUKRoXJzhLA
         iBi6jvmqbBgiNPCGO/zD9WATujpO12mmtqxPZDrhL+Xs929d+g5VognOoI6+FxMwlzG0
         PU5IE09mf/jo0yknFaqDaG3Og42DGrxT95E4obaovm/CoAQkQ4i0sEH7v2SvNap/075P
         Orgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=scy0DmMGTndLYIcghN4C4vI1CT4dWzOGN33Vj8jyBtY=;
        b=svgNvRPYL3Ne13m9IHSpREx05HI+ZO7XHUyLPG+eAFPsCWbXxcpFmCCcNZGLGzgda4
         SKkhgzGi2bRW1UG0Ujb3EKFJn50Rm4yInUysH5UtrYR4pN3ELDaLbIXv6fp9b7Oqkmcr
         JscxxU7lIVsTWQdJKXf6tPxiLUpDNzavnS1+Gau0ag16u+qYV28j74DnYoRJKJURj5DB
         dGxDq6FBusNezlvMskuykv4CzmMT13L8NVcQR80Le/UQonAsqOCohLusu8vt4KhUPb/U
         iPo4g181ZBFF6fGDROP+94JdWHmrucqY7m8Bq7hAxfm9d6G+QhP/q8dQZAVhOjpLB+yK
         yoCw==
X-Gm-Message-State: ANoB5pldJLnMWEUtSHA49xmYaEqnu8GGc0QE8FEGC/LpqLV+OBt7N/aA
        NnS+rjtm5HuXjU7NGAAYK3hrFQ==
X-Google-Smtp-Source: AA0mqf596Txp11x5tiRrEjIDxQqG/EjyLieoEul7qeiIeWFjAaLwhNdpLfSzP/tIBX83YuVcDfNPnQ==
X-Received: by 2002:a05:6a00:140c:b0:56b:b520:3751 with SMTP id l12-20020a056a00140c00b0056bb5203751mr4077818pfu.29.1669091708854;
        Mon, 21 Nov 2022 20:35:08 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id i29-20020a63131d000000b00460ea630c1bsm8218427pgl.46.2022.11.21.20.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 20:35:08 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oxKzw-00H8ZN-Vf; Tue, 22 Nov 2022 15:35:04 +1100
Date:   Tue, 22 Nov 2022 15:35:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     syzbot <syzbot+1d8c82e66f2e76b6b427@syzkaller.appspotmail.com>
Cc:     djwong@kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] kernel BUG in assfail
Message-ID: <20221122043504.GR3600936@dread.disaster.area>
References: <00000000000063536805ee0769d8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000063536805ee0769d8@google.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 21, 2022 at 08:14:43PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    eb7081409f94 Linux 6.1-rc6
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12e5bb0d880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8cdf448d3b35234
> dashboard link: https://syzkaller.appspot.com/bug?extid=1d8c82e66f2e76b6b427
> compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=169e86fd880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1691470d880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/4a019f55c517/disk-eb708140.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/eb36e890aa8b/vmlinux-eb708140.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/feee2c23ec64/bzImage-eb708140.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/c5c0a12afa51/mount_2.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1d8c82e66f2e76b6b427@syzkaller.appspotmail.com
> 
> loop0: detected capacity change from 0 to 32768
> XFS (loop0): Mounting V5 Filesystem
> XFS (loop0): Log inconsistent (didn't find previous header)
> XFS: Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 429

Not a bug. Not even close to a bug.

The kernel was clearly ompiled with CONFIG_XFS_DEBUG=y, which will
trigger debug asserts when things go wrong in ways that should not
ever happen in normal circumstances.

Turn off CONFIG_XFS_DEBUG, and this failure will return
-EFSCORRUPTED as expected because syzbot fed it a corrupt log. THe
mount will simply fail as you'd expect given the malicious
corruption that syzbot has performed.

If syzbot is going to maliciously corrupt XFS filesytsems and then
try to abuse them, then syzbot has two choices. Either:

1. do not enable CONFIG_XFS_DEBUG; or
2. do not report the inevitable stream of ASSERT failures that will
   be encountered to the XFS list.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
