Return-Path: <SRS0=V8GW=V7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB98C0650F
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Aug 2019 00:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87E652086A
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Aug 2019 00:54:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FWsXxXH3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387690AbfHCAyB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Aug 2019 20:54:01 -0400
Received: from mail-qt1-f175.google.com ([209.85.160.175]:40882 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387633AbfHCAyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 20:54:01 -0400
Received: by mail-qt1-f175.google.com with SMTP id a15so75745543qtn.7
        for <linux-xfs@vger.kernel.org>; Fri, 02 Aug 2019 17:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=kXeRbiceGANVN1A28ITYKSNGDU7LQQBnISFd0f7lnlM=;
        b=FWsXxXH37HLASXPNyy/w5R5e0VKhJ/D6ydtd8fmJDK152tPNgBPAgnEjIIY/UtWQKZ
         DlOuZrWJmiYbBryZYQcNkmslX93DbovUT39mm2OWMVUji07h/z6TUH7FCUbEfNK9wSt9
         x0f6tfW4sjpyaZzndvl+O60jwZLlaPWFXnB35BXjkhMTJgbWPTWyvDoLn6Aa+8sF+dzg
         lkJ412VXMRPm2/RSkN61gD/pc0tUGiYlVhQj9EX/HmJpGtBdt8HX0+Rab4QFrXyfRkdI
         Ln9XYNNlYuLvZFLrL1k9EbQasHHWOBv058vMrTkKoxin2RihhPK53IDQuV930PyghS7i
         uBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=kXeRbiceGANVN1A28ITYKSNGDU7LQQBnISFd0f7lnlM=;
        b=ZXXUw8LmeUkEIrN/+n9ZSskUU/EybDsLOlArGnIWgHKx21NF7mxLF8H9gJbm7qzcXS
         m47VEoV/VK2g9bdNa74tGU6Iym1JEhC5JCO01llcoUKV5sMKug5zle+o87ZoqoKAXp/s
         POOsHQIjwOPG1xgvJZQKJcN/wIV32tQuyktYjbchVbAx+LDE/Funs9Ym4tke4iTqSVYo
         tvBMgEZEG3xqdi8056o9zGELI40sQGvU5TRGB3xHwKreHKjUa/X/aZQpIvGViUB1QP8W
         eBsDwve7e5J1l7NzdRQ5Km/OV2aVw1knduB3W7dVByon+hXMvvOmcb1vg0IzMgOJfHie
         zVJw==
X-Gm-Message-State: APjAAAXvTMMx1Yba66IBrhXl9PIDBX1UowKHEmN2Dzbgb97us7PmC/eA
        lAUZJjmJp2QfmW0Ghlu85mqPEGc=
X-Google-Smtp-Source: APXvYqyPBREWltBhVs6RE3p7xITmE67bNb4dDC8P3FGyKcDbDsf4z6oI203yscJBKjNGkLQzOSvFhg==
X-Received: by 2002:ac8:1c65:: with SMTP id j34mr97495294qtk.323.1564793639726;
        Fri, 02 Aug 2019 17:53:59 -0700 (PDT)
Received: from lud1.home ([177.17.22.67])
        by smtp.gmail.com with ESMTPSA id z1sm37843846qkg.103.2019.08.02.17.53.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 02 Aug 2019 17:53:59 -0700 (PDT)
Date:   Fri, 2 Aug 2019 21:53:56 -0300
From:   Luciano ES <lucmove@gmail.com>
To:     linux-xfs@vger.kernel.org
Subject: XFS file system corruption, refuses to mount
Message-ID: <20181211183203.7fdbca0f@lud1.home>
X-Mailer: Claws Mail 3.14.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Message-ID: <20190803005356.IbpKoZJO2dUiztXKlEyOTSXIkoQeIZO_P6P08TS0u_w@z>

I've had this internal disk running for a long time. I had to 
disconnect it from the SATA and power plugs for two days. 
Now it won't mount. 

mount: wrong fs type, bad option, bad superblock on /dev/mapper/cab3,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so.

I get this in dmesg:

[   30.301450] XFS (dm-1): Mounting V5 Filesystem
[   30.426206] XFS (dm-1): Corruption warning: Metadata has LSN (16:367696) ahead of current LSN (16:367520). Please unmount and run xfs_repair (>= v4.3) to resolve.
[   30.426209] XFS (dm-1): log mount/recovery failed: error -22
[   30.426310] XFS (dm-1): log mount failed

Note that the entire disk is encrypted with cryptsetup/LUKS, 
which is working fine. Wrong passwords fail. The right password 
opens it. But then it refuses to mount.

This has been happening a lot to me with XFS file systems. 
Why is this happening?

Is there something I can do to recover the data?

-- 
Luciano ES
>>
