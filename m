Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4ECECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 21:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJ3VrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 17:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiJ3VrK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 17:47:10 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0767A473
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 14:47:08 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y13so9147458pfp.7
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 14:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Wv1C1Meb8rRcJApTFD9z+zpuWje8IlGRn2LNZt91Fs=;
        b=n7O0GMbv1Zncl8nsH2i/8UtZON1JKmZeKPfmxtJwMW1w6hGg5V47lJrBTcdk4YOcBY
         9r59CEj+ayV7JBEyb1FEwq3hSqU2kJhgPfnbw1FsH7NS/hZqyJz7XRm0szBfSOvB/u9W
         wwiTPNGr0SbppGI9u9h/qHV6V9VREZ/4Q4YdE+OlgeRuSs8n9kO8cFyj2FM4lzYtrmv5
         N8591rLp9l156RxEGRKtj/UADdVf/VxdrT/Hw3vq7pl98hlvnXI7F7jOyJT9WKYWZDNb
         LMGyx+/q0uq4Id1k8G4TALeUHCARNF/tXPEPrSSDAcB1MtyCYxWgKnF7JZbe+dQhk2rJ
         nhxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Wv1C1Meb8rRcJApTFD9z+zpuWje8IlGRn2LNZt91Fs=;
        b=xuUAo3b1PnKuBSOLiLOV0yZC/hsGEon6cUDA0yWW10aZSiUclUMerKqDUrt8V6kXwc
         AekXz1u7Ob2/gl1Yr6TNy5cy0ejcb7vO6viAJ+/9tg2pERGC3Xw11jdus5agFp/OFbA0
         kIGbkcKEvza/fpw9xjCKPwj2GyQL441yf74Lnbuz0mdFHxiYFRnDyhsQg0Gvz8EkErtx
         WuOnaTwoT5/Cf1ph7a0dpgST9Ers1HgcEPdTjh6p/LfHAgxs3kkxYxNN1O2aSxx+NAi5
         Ke9Mt7hU2ovhQXgIJ51plPE5/wqtG8MuvYlFe4UsDNh4iVtUZ+LDhyzWYJryinSf1/J2
         yczw==
X-Gm-Message-State: ACrzQf25m/8W+zbnPVgC7wzYsB2ZFzkMsaI30m2TGATC8XilYSBwpusK
        Un5RDMMGHurthTKiF+jIKHMZ7Q==
X-Google-Smtp-Source: AMsMyM5kFbtXp1eAvNXL4i2BzDOzO/B9mO1SiARzpPjshDhTPL+Xda4+HZ+viDLT1Nb21dnsoqVoEw==
X-Received: by 2002:a63:d716:0:b0:46f:3dfb:90b5 with SMTP id d22-20020a63d716000000b0046f3dfb90b5mr10079165pgg.58.1667166428119;
        Sun, 30 Oct 2022 14:47:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id gb7-20020a17090b060700b0020d9306e735sm2846787pjb.20.2022.10.30.14.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 14:47:07 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1opG91-008LVR-Nl; Mon, 31 Oct 2022 08:47:03 +1100
Date:   Mon, 31 Oct 2022 08:47:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 216639] New: [xfstests] WARNING: CPU: 1 PID: 429349 at
 mm/huge_memory.c:2465 __split_huge_page_tail+0xab0/0xce0
Message-ID: <20221030214703.GG3600936@dread.disaster.area>
References: <bug-216639-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216639-201763@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 30, 2022 at 02:38:17AM +0000, bugzilla-daemon@kernel.org wrote:
> Many xfstests cases fail [1] and hit below kernel
> (HEAD=05c31d25cc9678cc173cf12e259d638e8a641f66) warning [2] (on x86_64 and
> s390x). No special mkfs or mount options, just simple default xfs testing,
> without any MKFS_OPTIONS or MOUNT_OPTIONS specified.
> 
> [1]
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 hp-xxxxxx-xx-xxxx 6.1.0-rc2+ #1 SMP
> PREEMPT_DYNAMIC Fri Oct 28 19:52:51 EDT 2022
> MKFS_OPTIONS  -- -f -m crc=1,finobt=1,rmapbt=0,reflink=1,bigtime=1,inobtcount=1
> /dev/vda2
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/vda2
> /mnt/xfstests/scratch
> 
> generic/061       _check_dmesg: something found in dmesg (see
> /var/lib/xfstests/results//generic/061.dmesg)
> 
> Ran: generic/061
> Failures: generic/061
> Failed 1 of 1 tests
> 
> [2]
> [14281.743118] run fstests generic/061 at 2022-10-29 01:00:39
> [14295.930483] page:000000001065a86b refcount:0 mapcount:0 mapping:0000000064faa2f2 index:0x40 pfn:0x143040
> [14295.947825] head:000000001065a86b order:5 compound_mapcount:0 compound_pincount:0
> [14295.950100] memcg:ffff88817efe2000
> [14295.951215] aops:xfs_address_space_operations [xfs] ino:8e dentry name:"061.429109"
> [14295.955474] flags: 0x17ffffc0010035(locked|uptodate|lru|active|head|node=0|zone=2|lastcpupid=0x1fffff)
> [14295.958302] raw: 0017ffffc0010035 ffffea0004756c08 ffffea00050c1788 ffff88811e804448
> [14295.960624] raw: 0000000000000040 0000000000000000 00000000ffffffff ffff88817efe2000
> [14295.962927] page dumped because: VM_WARN_ON_ONCE_PAGE(page_tail->private != 0)
> [14295.965744] ------------[ cut here ]------------
> [14295.967201] WARNING: CPU: 1 PID: 429349 at mm/huge_memory.c:2465 __split_huge_page_tail+0xab0/0xce0
....
> [14296.015290] Call Trace:
> [14296.016083]  <TASK>
> [14296.018235]  __split_huge_page+0x2a5/0x11b0
> [14296.019675]  split_huge_page_to_list+0xb13/0xf30
> [14296.027369]  truncate_inode_partial_folio+0x1d9/0x370
> [14296.028940]  truncate_inode_pages_range+0x350/0xbc0
> [14296.059204]  truncate_pagecache+0x63/0x90
> [14296.060471]  xfs_setattr_size+0x2a2/0xc50 [xfs]

Yup, splitting a multi-page folio during truncate. Looks like this
has already been fixed in the Linus kernel by commit 5aae9265ee1a
("mm: prep_compound_tail() clear page->private") here:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5aae9265ee1a30cf716d6caf6b29fe99b9d55130

It was merged after your currrent head commit...

This won't reproduce on ext4 because it doesn't use multi-page
folios in the page cache.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
