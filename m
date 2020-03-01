Return-Path: <SRS0=l9EO=4S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE20C3F2CD
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Mar 2020 22:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22A082469C
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Mar 2020 22:56:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="G5lSflCj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgCAW4P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Mar 2020 17:56:15 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37667 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgCAW4P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Mar 2020 17:56:15 -0500
Received: by mail-pl1-f193.google.com with SMTP id q4so3430194pls.4
        for <linux-xfs@vger.kernel.org>; Sun, 01 Mar 2020 14:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:subject:in-reply-to:references:date:message-id:mime-version;
        bh=YxgOqpgbQcmMoGMYAVFOXMchSBvpYzdR5unDu3ePoFE=;
        b=G5lSflCjBdUdrdAVY9fbc6OD3WvuAgAM3O//ZXOSIk3koNGb5/F3+h7lTdnklngQB2
         8vAAAWwrSP24AnXWhbwuMXXvTr8Xin4WORfUKhVoJIRli4h4YyIhPh5vK+WkgPry5Hj7
         rhcYjsLyZi1XwLChKgxt5P5EdSXliR+zUMXNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YxgOqpgbQcmMoGMYAVFOXMchSBvpYzdR5unDu3ePoFE=;
        b=fZllGo7UNmuWsztKoab5oL+CRfZq4FLCSeuk0ltci4cQcBY0xKhkpWamqghjllVlNi
         xgUaQlfmmkncszeb3zfRMmvVYDNaYuFSAy0b3p5kcWacJDHIvxUvqED5GPC2NvEl9ry/
         z4Zlti0yqQpbWNbLEGexUSX5qB3CXvReQ7JkuoHBMeTQMJlCkK10t7lfn00CSx6G/tj3
         VoN20QX5XE9sDeCql0+McTQaBy9BelbeTuu4lws2h1zW17J2xnsedmTItS1eAn22ramH
         klXu35izjA5hXIpMCuG1QEmtKCXPAXfzwfY6CyHuxNf+or5uXELu4QMLCo9LLy3uF6Z7
         pU2Q==
X-Gm-Message-State: APjAAAXV9PnTn2NwNsUR+59JYTrLKDDTWnKHk8YciYK0DZ/g8Qlnw66c
        /+OyuYKxRTe0Hlvpd4B0rvjBfQ==
X-Google-Smtp-Source: APXvYqyyBTU85xhidIp99iBInbf+ZsI59IZB1CB3kU2N4bl9kH0fYn/V3d4kOT6OoWV5pjrbZchZ8A==
X-Received: by 2002:a17:90a:928c:: with SMTP id n12mr18452305pjo.45.1583103374143;
        Sun, 01 Mar 2020 14:56:14 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-591b-db3f-06cb-776f.static.ipv6.internode.on.net. [2001:44b8:1113:6700:591b:db3f:6cb:776f])
        by smtp.gmail.com with ESMTPSA id h7sm19357775pfq.36.2020.03.01.14.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 14:56:13 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     syzbot <syzbot+6be2cbddaad2e32b47a0@syzkaller.appspotmail.com>,
        allison.henderson@oracle.com, bfoster@redhat.com,
        darrick.wong@oracle.com, dchinner@redhat.com, dvyukov@google.com,
        kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, sandeen@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: BUG: unable to handle kernel paging request in xfs_sb_read_verify
In-Reply-To: <00000000000074eed3059f9e3d0a@google.com>
References: <00000000000074eed3059f9e3d0a@google.com>
Date:   Mon, 02 Mar 2020 09:56:10 +1100
Message-ID: <87eeubr8fp.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot <syzbot+6be2cbddaad2e32b47a0@syzkaller.appspotmail.com> writes:

#syz fix: kasan: fix crashes on access to memory mapped by vm_map_ram()

> This bug is marked as fixed by commit:
> kasan: support vmalloc backing of vm_map_ram()
> But I can't find it in any tested tree for more than 90 days.
> Is it a correct commit? Please update it by replying:
> #syz fix: exact-commit-title
> Until then the bug is still considered open and
> new crashes with the same signature are ignored.
