Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_A1,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D6FC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 18:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09E1522287
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Dec 2020 18:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgLWSHT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Dec 2020 13:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgLWSHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Dec 2020 13:07:19 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692B8C06179C
        for <linux-xfs@vger.kernel.org>; Wed, 23 Dec 2020 10:06:38 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id c5so56720wrp.6
        for <linux-xfs@vger.kernel.org>; Wed, 23 Dec 2020 10:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=ynN5pA2Otd4QCrClFjnkUTM0uUvVh1Va9ymY5fYFGwQ=;
        b=K3HeFo1y8Jk2l3P7DgzOHKv/znXl1mAfBafIls8Q87cWhojIG3u68qw8vJxCIZ03Yu
         ldfoA+RKw6kx1eH+HRkGl76prZCES7xFd1S4WOWqCeTt6d7SNX/L50qMkbfRvbyKzesh
         0xu/XfTteCMDPv+qYV9Rr3zcWKyrxVW7uPpkS0HlD4TbH/RcpZ2J1nU4TZ284F7Rc0Id
         wFzFAHH2RXBtm8Cv10FsVcedTOy1Riizn3Gco4Qj5b+09hRAReVE6mx45IFyqtz18grP
         COVjENDsrSmk3OzjCN+fjQKjsMNQNYS81foIlSFMqNIDPBIka4NGEiz9qBeoU/tNrNbN
         JSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=ynN5pA2Otd4QCrClFjnkUTM0uUvVh1Va9ymY5fYFGwQ=;
        b=e1SUWC2EBfX3NcxwgYGCEaOuGxA9hko0aY7YmTk/A4FDfi8GSNlwWkOpF8fFG5Roaq
         roZNfD1tXuZmX8RLtxRkaXcy1qumQLXR1KsK2O3MGBkN9cGTMPESix/sn6gxIWwERlpd
         3OsjDZ7Rkzxt8fDi8/Uua0FULN+V9NAaG96nsFPy9nBaitj5TFmhxcd8K4+wkdel7lMx
         UBkzYAUd0+FG0/iCtiPvxukjrGlzUuNFR+L217S7mY6TL8wQ1xCMV0DVIhwn7+PBSJxN
         uFg8duh1j72gslX02FdUs0BF7I7JineSEr3+6wCrNSTkRjHWE+ywdIg1O4uaFon+E0zq
         mGog==
X-Gm-Message-State: AOAM531esoz5okeG1m7twXV6c9yu0//ysoNwd9EdgEsOYg88iNq/fsI4
        sD4+g2U0YGx5TsRrMLM/Ckn7ftT1UUST9w==
X-Google-Smtp-Source: ABdhPJww9JHDg7+xF2/TBLJIN5ajc6fH8ZzvpXpO+K3yG91aI10g2HUiTWlW1YG5BmrzKrh+8VhXtQ==
X-Received: by 2002:adf:e704:: with SMTP id c4mr30702299wrm.355.1608746796866;
        Wed, 23 Dec 2020 10:06:36 -0800 (PST)
Received: from [192.168.1.2] (static-129-201-27-46.ipcom.comunitel.net. [46.27.201.129])
        by smtp.gmail.com with ESMTPSA id h9sm617935wme.11.2020.12.23.10.06.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 10:06:36 -0800 (PST)
To:     linux-xfs@vger.kernel.org
From:   nitsuga5124 <nitsuga5124@gmail.com>
Subject: RE: XFS Disk Repair failing with err 117 (Help Recovering Data)
Message-ID: <70700963-9acb-f9f8-c3e7-4a356ce3336f@gmail.com>
Date:   Wed, 23 Dec 2020 19:06:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi, I'm continuing a series of emails I had with Eric Sandeen 
<sandeen@sandeen.net> on September 19, 2020, about trying to recover 
data from a corrupted file system where xfs_repair fails with `fatal 
error -- couldn't map inode 132, err = 117`

Last time the issue was declared to be a hardware problem; I have bought 
an equal drive to that one, and I have used ddrescue to clone the disk 
over to the new drive, without the encryption, so the data is not 
mangled and possible data logs should be more readable.
Trying to run xfs_repair on that drive clone leads to the same error, 
but using `photorec` does show that all the files are still readable, so 
there must be a way to recover them while keeping the file structure and 
filenames they had, as `photorec` does not do this. `testdisk` does do 
this, but it is not supported on xfs, so it's sadly not an option.

Since I have a drive clone now, I'm able to do more risky repair 
procedures like trying to use dd to rewrite corrupted areas to make 
xfs_repair work, or similar; but I'm unable to find any information 
about locating inodes on the drive, so help doing this would be appreciated.
The end goal is to have a readable drive, to then be able to backup all 
the files with their file structure, I know all the data is there and 
readable, so broken hardware is no longer an excuse, as the cloned data 
is on a brand new drive with 0 bad sectors and all OK S.M.A.R.T.

- Agustín (Austin in English)

