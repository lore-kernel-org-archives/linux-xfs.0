Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6C5C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Dec 2021 18:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245107AbhLJSat (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Dec 2021 13:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244333AbhLJSas (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Dec 2021 13:30:48 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC51C061746
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 10:27:13 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i12so9177949pfd.6
        for <linux-xfs@vger.kernel.org>; Fri, 10 Dec 2021 10:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:from:mime-version:date:subject:message-id
         :to;
        bh=0zwvU6+ZKy4avhzAXo8J+BpbGN+GPEJhStGNJjbu5t4=;
        b=NX0chaySuggqiNLL8CPDklUZDSY9Dv2+JuR+zxspW7thZxhWmeWRBwGD1vTz+8KnZh
         zQuVqdg3LR27dE4Ja0KYKU24O0UWl0unPNMXZxJ6C7w+6wU68rsSErOAV78S7VWZcChd
         F87PLPlITOhhl51F5aqgpJV4dQcNn2fOFSoAPQpMeQcUJAoMLfo61lWPuCCNJjV2AsbM
         c1h4RuivYyTE2RZTKAZmNB5kPdS/zDZk0AS2EjxsWE+f8cN4VqlgmtEDstGjwD+PRN3E
         gEKww7RE4wLMzoe6qNiOxpSzgYzB6XR/9i4vSOxrWbuV0o6O7udT0KWdr9hyF3dy/4I9
         DS6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version:date
         :subject:message-id:to;
        bh=0zwvU6+ZKy4avhzAXo8J+BpbGN+GPEJhStGNJjbu5t4=;
        b=ebBdQCJoxEI+yd5XZbOz11esKoaoQdAmx6+dM1KQVdRij5VHEtBUO4xJMk7sYb7AV3
         HDC30noC505BC6IKG9h4GH+KeCfL9wSIQqbAHCCNSYIWHjhKwT4O9p1gFssmjLHO8oS4
         VoppdNKcs2hv5GwZ+L0Jf2Z7pHc7Oy1wQwtNrCFPsNRXzeojALSMw6xwGGKZXLS/vJqB
         TeZeByJKAo4Q/ayNW5jnt6iIGJHp17HeZ3ac0tF0AAUSxu4F3nNWIDQwwW3SIT5YQaO5
         YMHvZXWuk16zzjc4NMV7ji/f14lf3KODfNCKPB5ZrrlELKfYtYT9H6EkfvdW7AMKPFt4
         jCRw==
X-Gm-Message-State: AOAM531LGZNqrMO15FxC8DktQcrqldZrhCHxvHnb31zt7kPyDL3sJ4rY
        JWc1LTt1FJ41A85hiUv/UI4=
X-Google-Smtp-Source: ABdhPJxJYEw3eQTboe4O88ZaUxEYTmliE69UXni6i7u6WRXSe0pWragf902dLLeeCXsOUienSHX06w==
X-Received: by 2002:a63:2a86:: with SMTP id q128mr1842305pgq.266.1639160833105;
        Fri, 10 Dec 2021 10:27:13 -0800 (PST)
Received: from smtpclient.apple ([216.9.31.138])
        by smtp.gmail.com with ESMTPSA id j17sm3860019pfe.174.2021.12.10.10.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 10:27:12 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Chanchal Mathew <chanch13@gmail.com>
Mime-Version: 1.0 (1.0)
Date:   Fri, 10 Dec 2021 10:27:11 -0800
Subject: XFS journal log resetting
Message-Id: <B11759AA-9760-4827-A9C9-BCF931B65D21@gmail.com>
To:     linux-xfs@vger.kernel.org
X-Mailer: iPhone Mail (19B74)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi

A question for the developers -

Is there a reason why a clean unmount on an XFS filesystem would not reset t=
he log numbers to 0? The xfs_logprint output shows the head and tail log num=
bers to have the same number > 0 and as CLEAN. But the log number is not res=
et to 0 without running a xfs_repair -L. Is there a reason it=E2=80=99s not d=
one as part of the unmount?

The problem I=E2=80=99m noticing is, the higher the log number, it takes lon=
ger for it to be mounted. Most time seems spent on the xlog_find_tail() call=
.=20



Thank you!



- Chanchal
