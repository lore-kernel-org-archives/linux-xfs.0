Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CA5C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Dec 2021 18:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhLHSZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Dec 2021 13:25:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229958AbhLHSZr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Dec 2021 13:25:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638987735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wQAGoLpIdstYcL/lEWMWrXPDyu9EDy39dIv1JG3g8DY=;
        b=Jaxd6FpAoTRTmCcJuVkl7wp/J7wcBlMsOJ8SuyK9N8TFiO8zbYw4d6uNC5bDvV67IOvaU4
        1/Sdm9lUNzCpkf6Pp8HuZoyOGJw+9+ctD7cw02sLUCorJNLe6Dm+k6JG7BEhAeW97JwxWb
        TG0CKlkoCFpXkWVSL1viO76GdS1T+ek=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-XqDADo64MZmnyYae_1I0DA-1; Wed, 08 Dec 2021 13:22:14 -0500
X-MC-Unique: XqDADo64MZmnyYae_1I0DA-1
Received: by mail-wm1-f70.google.com with SMTP id ay17-20020a05600c1e1100b0033f27b76819so1700228wmb.4
        for <linux-xfs@vger.kernel.org>; Wed, 08 Dec 2021 10:22:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=wQAGoLpIdstYcL/lEWMWrXPDyu9EDy39dIv1JG3g8DY=;
        b=qPca40cfRuRz0GOS9qTHQklBilwkRt+xG0MT1m4sc6Ya54RoSnoO3qXJHucwlQ6qO+
         voqrWbo3J2rDAgI5qhcc+QrY3Ue9fGwLUygClS7hVCFbJYBSHgYUNTwb5gRjsMQ2mVXR
         zol+CViM7OZf1EZg7kkZHVoNASSDe79bnhqhxBdaOUV6oP+A/ftfB0u3FbyzsmcP3I51
         iDuUy8XI8Hp2DMMSH51iqZ61ZpFKK+wDTGREQtWfIoHWHRKgKc1g900MIR8dRHNKlxbo
         cyWR3pjxS80F+PTSLecIWbTsOF0/4CNnT7v6osLCkSgBkQ3gYg/KagmHG4eWlfyvcXM3
         kigw==
X-Gm-Message-State: AOAM530oqIKmcvaluHa3rbXB03qFA1mI1mLKqLFZiMkqHpMKukccaGE7
        QlZHk2xPAUTTWabJwzzEkTT420CymeIIXyRMhgyCAMDe2JknYwnJIrnXy10WxeNtVDxwNtP7LY0
        b+YteSMgd+e+ZiLksTJ/w7BPLu8x1YjvArVysT0U2zxwRllOc69U4lKY/3dQqFchx9lnjbZTP6g
        ==
X-Received: by 2002:a05:600c:3227:: with SMTP id r39mr492121wmp.120.1638987732898;
        Wed, 08 Dec 2021 10:22:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQIZEYhmwIBUeqd7iv0jnbwpxkeX7GLA4PaGpXmisQl0UNlKsWNr9gvgbz076yK6V4nwSjcg==
X-Received: by 2002:a05:600c:3227:: with SMTP id r39mr492064wmp.120.1638987732450;
        Wed, 08 Dec 2021 10:22:12 -0800 (PST)
Received: from andromeda.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id v6sm6463087wmh.8.2021.12.08.10.22.11
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 10:22:11 -0800 (PST)
Date:   Wed, 8 Dec 2021 19:22:10 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 215261] New: [xfstests xfs/177] test still fails after
 merge f38a032b165d ("xfs: fix I_DONTCACHE")
Message-ID: <20211208182210.whag2roth5dlqd5k@andromeda.lan>
Mail-Followup-To: linux-xfs@vger.kernel.org
References: <bug-215261-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-215261-201763@https.bugzilla.kernel.org/>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> xfs/177 - output mismatch (see /var/lib/xfstests/results//xfs/177.out.bad)
>     --- tests/xfs/177.out       2021-11-28 09:56:52.236830568 -0500
>     +++ /var/lib/xfstests/results//xfs/177.out.bad      2021-11-30
> 04:21:03.282699626 -0500
>     @@ -2,11 +2,14 @@
>      new file count is in range
>      inodes after creating files is in range
>      Round 1
>     -inodes after bulkstat is in range
>     +inodes after bulkstat has value of 102
>     +inodes after bulkstat is NOT in range 1023 .. 1033
>      inodes after expire is in range
>     ...
>     (Run 'diff -u /var/lib/xfstests/tests/xfs/177.out
> /var/lib/xfstests/results//xfs/177.out.bad'  to see the entire diff)
> Ran: xfs/177
> Failures: xfs/177
> Failed 1 of 1 tests
> 

I'm still looking into it, but I suspect this is an issue with the test itself.
In some occasions, the timer set for xfssyncd_centisecs is too short, and by the
time the test collect the amount of cached objects, the system is already
reclaiming unused objects, so, the test 'finds' fewer cached objects than it
expects.

> [2]
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/aarch64 hpe-apollo-cnxxxx-xx-vm-xx 5.16.0-rc2+ #1 SMP
> Sun Nov 28 06:10:24 EST 2021
> MKFS_OPTIONS  -- -f -m crc=1,finobt=1,rmapbt=0,reflink=1,bigtime=1,inobtcount=1
> /dev/vda3
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/vda3
> /mnt/xfstests/scratch
> 
> xfs/177 - output mismatch (see /var/lib/xfstests/results//xfs/177.out.bad)
>     --- tests/xfs/177.out       2021-11-28 10:04:49.415509327 -0500
>     +++ /var/lib/xfstests/results//xfs/177.out.bad      2021-11-29
> 04:47:32.148868974 -0500
>     @@ -2,7 +2,8 @@
>      new file count is in range
>      inodes after creating files is in range
>      Round 1
>     -inodes after bulkstat is in range
>     +inodes after bulkstat has value of 575
>     +inodes after bulkstat is NOT in range 1023 .. 1033
>      inodes after expire is in range
>     ...
>     (Run 'diff -u /var/lib/xfstests/tests/xfs/177.out
> /var/lib/xfstests/results//xfs/177.out.bad'  to see the entire diff)
> Ran: xfs/177
> Failures: xfs/177
> Failed 1 of 1 tests
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
> 

-- 
Carlos

