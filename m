Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DD2C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Dec 2021 00:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244113AbhLKANT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 19:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237677AbhLKANT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Dec 2021 19:13:19 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1421C061714
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 16:09:43 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y8so7332751plg.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 16:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=1+qgrk5AS3qqzgNJdFLV7zq7Tf+TLnOirNe64zTymI0=;
        b=ZXJrq65mSTDiJVsMB8MXGmHwqJZz99CQlqdzq5bGIpNUS2BHwNYtJRFkgOlt/Zp91D
         wqZpBh9pXQzqFJrnYbKbXNQ+OGRy3cbWZYhvwVtYDyNfpvZ78Vqj7F2RomVu/yTlOYNr
         ZljuEuywact/laM702R5dCiCLmzkoPLIT5RT9jNS391WmqkigmCKav6cgeT+8Frc8xjz
         5r23Vkx9HSVybNU/eHEVjJD+Xtmg5bAe4KsUJC+bIFVVZVRxJdSTaY9QWyJVg8JOxp3i
         kPGPQa8ZtR5n/X4Nx9V24WVw5G/NmYs04y3hsJzKjxMPN1ri0rlvPjETiZansOEtdwpR
         OkTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=1+qgrk5AS3qqzgNJdFLV7zq7Tf+TLnOirNe64zTymI0=;
        b=PwQTMAJuLb0LB2nUekgsKfdwkNngzsXIlXgR8a2ixaGX0/b9EBw9cmOhmxG2QEADhn
         DAdNaLMQDqZ7KiG3yRrHRLEQVKqJ3s0F/7/BUYNf/fIGxG1Abmz7SfjepILRMwANRMKy
         k3bJBn+Krt3BKUxo06Sl8ELCN5mswOjZV9IdWbbV+wbzfMpguXJk0oqC9Xpcwmnmzdux
         FZns8hqLDCU37igE1oIAcZ6VlDcpIcjrlbcxZQrUDTOMT+jwwAWScpYcnq7lN75Ly1qA
         QlJ2c1i/9meFgGnm8eFEWwG56q16MJuTDImWhnJ+QsxM5PKjw/XydUUm1e2HuwVoZ/bY
         e+Aw==
X-Gm-Message-State: AOAM533ecyKs7CUie7C1tlqv8tl7Apb1hwM1whoF956PCZt+hmfLc2Hf
        ai3sAeWTTMI3WcgPlqvoZ3Az4hXoPhE=
X-Google-Smtp-Source: ABdhPJyHDg/n1Nxs6fv7bnca0Uku2GrJkFahqk3px1ICaC29NJ68jRt0RqSLyaZ5QKD4VFAjTZBg4A==
X-Received: by 2002:a17:902:a714:b0:143:d007:412f with SMTP id w20-20020a170902a71400b00143d007412fmr77576246plq.18.1639181383053;
        Fri, 10 Dec 2021 16:09:43 -0800 (PST)
Received: from smtpclient.apple ([216.9.31.138])
        by smtp.gmail.com with ESMTPSA id y11sm4130802pfg.204.2021.12.10.16.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 16:09:42 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Chanchal Mathew <chanch13@gmail.com>
Mime-Version: 1.0 (1.0)
Subject: Re: XFS journal log resetting
Date:   Fri, 10 Dec 2021 16:09:41 -0800
Message-Id: <24D44CB5-F383-4F2A-B9C3-87770DFD7CDB@gmail.com>
References: <20211210213649.GQ449541@dread.disaster.area>
Cc:     linux-xfs@vger.kernel.org
In-Reply-To: <20211210213649.GQ449541@dread.disaster.area>
To:     Dave Chinner <david@fromorbit.com>
X-Mailer: iPhone Mail (19B74)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thank you for the explanation!

Wouldn=E2=80=99t we expect zero pending modification or no unwritten data wh=
en a device is cleanly unmounted? Or do you mean, a successful =E2=80=98umou=
nt=E2=80=99 run on the device doesn=E2=80=99t guarantee there are no pending=
 changes?

The devices I=E2=80=99m testing on are image files with same amount of data.=
 One with lower log number is quicker to mount.=20

$ sudo xfs_logprint -t /dev/mapper/loop0p1
=E2=80=A6
    log tail: 451 head: 451 state: <CLEAN>


Whereas, the one with higher log number, such as the one below, is about 4-5=
 times slower running xlog_find_tail().

$ sudo xfs_logprint -t /dev/mapper/loop0p1
=E2=80=A6
    log tail: 17658 head: 17658 state: <CLEAN>


The images are of same size, and have same amount of data as well (as verifi=
ed by df and df -i once mounted)

The only way I can work around this delay for an instance started from an im=
age file with higher log number is, to reset it to 0 with xfs_repair.=20



Chanchal=20=
