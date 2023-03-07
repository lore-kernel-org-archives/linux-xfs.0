Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD6AC6FD1A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Mar 2023 17:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjCGRZl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Mar 2023 12:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbjCGRZN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2023 12:25:13 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069239C988
        for <linux-xfs@vger.kernel.org>; Tue,  7 Mar 2023 09:20:22 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id p20so14826256plw.13
        for <linux-xfs@vger.kernel.org>; Tue, 07 Mar 2023 09:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678209621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dLoB7xqcbq2D/9EuKOfTh5Aky6biZ6xDYbDnw2JzEq4=;
        b=yCMuN5QpF6F8x7tzPPMVTle1TkAXahuai/5ScNH8qcZxtLsY0LY3EnY4oqj5IxyBpK
         qjR3aHTrHyXCGESRKUNkyiIycDwirn1STeR+2SWNv4cK7ROgSDf93lAst4nMkm7zPlEX
         GdrTSsm4IsWYfsmx2PAXdq6CAQLrJmpft5CMYI9JGCyWgP4lwiwsjwPJ8vNvi127sebR
         ueCn6r/r/ftBl2B5PzZCj2+hXkqgJdGk5ZwMgQ4kVO4ND6PQ/r5K+aY8uJCxpGhUmHWQ
         NeaFvLIvS71UEhLT5bQqyxIgWk5+rnm/6gJvoIW345E+6UBFbCw6/wvGriNv5M/S84XG
         M36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678209621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dLoB7xqcbq2D/9EuKOfTh5Aky6biZ6xDYbDnw2JzEq4=;
        b=A/MAWVMUxi3SAjm+vO9bmwEeQ306hddBZ23woCxkyPAkZYp+Ti+vQv7g+mnFESbCnl
         8Z6y6r1Xn/sFHSJNWBIPFM9jxi74siUbXj2hpXl2excqxpzjnIURGpX73KN2hRgR063L
         HKmr9ha4LajZF/6Cyy15A7cB/GzA4R/+O6SRpfygo9/PDrd5rA+kr2ykPTgbx3yIduYO
         3E7bMvQ3YHsxdej2HF1xL+mbBMaKLM9Lk8Yc3TDdiZe8Sncsg1FPqvG4S7+JuSBg3LXh
         0ys17+lk5LTvK79JOCICPJfCuIUaVawedAJbs28lByjtoAUPKQgR0hXvdlfSstRf7M80
         k2rw==
X-Gm-Message-State: AO0yUKXISrdz3NHlSgudDBFtUIPyqE80qlpQ3wGFY8xkFH3ZnrWSjcOf
        03KOCqVD7nfdl1DfVLx72M7asQ==
X-Google-Smtp-Source: AK7set8rDGYZOIgkIwn4GSWtWuoEh/oVIqQ7Cvp4xVlIHUntM7PhsBFAFUDiLHlQuD6P7d05dsSzVA==
X-Received: by 2002:a17:902:cec7:b0:19e:4cda:513 with SMTP id d7-20020a170902cec700b0019e4cda0513mr15454468plg.5.1678209621418;
        Tue, 07 Mar 2023 09:20:21 -0800 (PST)
Received: from localhost.localdomain ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id c17-20020a170903235100b0019e76a99cdbsm8651390plh.243.2023.03.07.09.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 09:20:20 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [PATCHSET for-next 0/2] Flag file systems as supporting parallel dio writes
Date:   Tue,  7 Mar 2023 10:20:13 -0700
Message-Id: <20230307172015.54911-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

This has been on my TODO list for a while, and now that ext4 supports
parallel dio writes as well, time to dust it off and send it out... This
adds an FMODE flag to inform users that a given file supports parallel
dio writes. io_uring can use this to avoid serializing dio writes
upfront, in case it isn't needed. A few details in patch #2, patch 1 does
nothing by itself.

-- 
Jens Axboe



