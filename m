Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE609C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 11:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1BFD60EE9
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Oct 2021 11:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhJTLxY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Oct 2021 07:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhJTLxX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Oct 2021 07:53:23 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F596C06161C
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 04:51:09 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id a25so24892674edx.8
        for <linux-xfs@vger.kernel.org>; Wed, 20 Oct 2021 04:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=qft4Ov4wy7FTzKolLao2d2bfdlidrug4OG9ujAKN/WY=;
        b=DGThwnbtA+CAhtiukEyOTEEIOvUoEHJ8wxBIWWb7UBl1tApaYgjSEvbd9SmgAvL3uc
         T4PEzH0rAqNkS4lFYTI2DiziPI02g34tMZt5Uhau2DOCH2bO0BcQPihXdU6LUr9wDwUL
         Kg55Bwd4zcNzP0lvCAcpYlRpWzc40nSMInDliaLdWzq+fY4N9lXL8Ly8sy++H14zjKit
         VUizGiB1vYng98/j14JubBhQpGiZcbqb2rjxnNxYwQg2fNGKyQL9uYOO5ofM8CAVslnh
         8fe64yFTxg+tsEkmYHkQ/vv1Wsjt98M7sS7kfcEvYax+sWyHJrHhsf9HI6UWyqL5eDnp
         lVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=qft4Ov4wy7FTzKolLao2d2bfdlidrug4OG9ujAKN/WY=;
        b=N1E8RR3e7TFaO5TXdCEuMtUs91EqP/NojNGazg9XrPlK/mwHEPRtqlJ+nDjXfyfqc4
         3EITjHFdhnIMUS096KsEVSa2l8RE4wZIMyKlsRzXvV0pcmQiEbqU+CPnhINO5G6swjLh
         YYjj786TdZkBj3bBJElHiCqgbG1nKbmN8Z5Cius8IpKtBBsfhVRRDFI0uJiRfPqdWjkB
         mjUyOlsL7ktoSl5E/umWqOpEbQZHTBe6f/srMU2kgb81n9sbPs2P255dOScvABxMjtS9
         ofjAu9xV5UmEZdK8ITNwVOZI0i0wGSqcQWkXpaHx9dSnYYHBAZLQe+YjtfcvqfbFnwF2
         Llng==
X-Gm-Message-State: AOAM533YpoXbOCrPGu0bt6gm1Uo06xtNBCH7mXX84L12PLftDV9+iD6g
        CvHVWqfE6BQYjZGS3T+7tzMRoANLBP0=
X-Google-Smtp-Source: ABdhPJxvFHlX6zfr19BN4jzkeHSHhjq5H3IMkwWrUuFbGYIboY8LJQNR8Owkr6tIl1LjBpNRgaywSg==
X-Received: by 2002:a17:906:d541:: with SMTP id cr1mr47516571ejc.81.1634730667440;
        Wed, 20 Oct 2021 04:51:07 -0700 (PDT)
Received: from smtpclient.apple (105.245.6.51.dyn.plus.net. [51.6.245.105])
        by smtp.gmail.com with ESMTPSA id j3sm927073ejy.65.2021.10.20.04.51.06
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Oct 2021 04:51:06 -0700 (PDT)
From:   Dan Greenfield <dgrnfld@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: XFS NVMe RDMA?
Message-Id: <965EC18A-BF96-4544-AFE0-FA0F1787FD49@gmail.com>
Date:   Wed, 20 Oct 2021 12:51:05 +0100
To:     linux-xfs@vger.kernel.org
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dear XFS Experts,

   as you may or may not know, XFS on NVMe was used as part of the #1 =
entry to the IO500 benchmarks, as announced at ISC21. That entry swept =
away the other competition (albeit on large custom hardware), including =
systems using Intel=E2=80=99s DAOS using Octane/PMem, WekaIO, Lustre, =
GekkoFS and others.

There=E2=80=99s no publication associated with it, however there=E2=80=99s=
 a video presenting how they did it:
https://www.youtube.com/watch?v=3DBJpkpA6hsDc

In it they describe how they used XFS for storing data chunks, and =
RocksDB for storing metadata. I=E2=80=99m trying to dig deeper on how =
they could have used XFS, and in particular how they could have used =
RDMA to access XFS data. The XFS DAX mode as far as I=E2=80=99m aware =
requires PMem rather than NVMe?

Do you have any ideas how they could have been able to utilise RDMA so =
that node A can directly access data chunks stored on XFS on node B? Is =
the only approach to mmap the chunk on node B and then RDMA it to/from =
node A?

Kind regards,
   Dan=
