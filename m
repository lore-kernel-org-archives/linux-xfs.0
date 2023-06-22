Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FC2EB64D8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jun 2023 05:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjFVFfA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jun 2023 01:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjFVFe7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 01:34:59 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CA9E42
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 22:34:58 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4f95c975995so311353e87.0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 22:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687412096; x=1690004096;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OjoT31gl796kFxnYg4s5OWfbapn6Gr3Nryd8bH6El/o=;
        b=BnWWDm8eT+CzsPrM1fBby8YyqgiZsmQCXJ2xV7i/ZGiNYUnxr/ZSA0QOl5be9kVrw5
         7JH91FcqSQ5mHnictcU/qpJ8yYmGzB/WGRsZ9kCEf5HJ3IuAmD9XmdNc+Pz8l1fBpaSj
         uo63J7a9DKPt7eWeKDxocc4WD+S85aVxuIOInsF2tyaEvqJsidDhCauHJMT3Io6zg4nQ
         J5L82vH8qYTaC2KIXqGPJkFnEWo8Ffbu2Xh287AEHbjrGoQLZtSieyF/yklr3aqHjOrq
         i6Lv2L0OwGeGhkQ5oOJSulrdDtq5mSaw3Lmgp2/b24LO7MLmzMFJhubw4Ib0buoU57DS
         i9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687412096; x=1690004096;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OjoT31gl796kFxnYg4s5OWfbapn6Gr3Nryd8bH6El/o=;
        b=FaB6BZG++ACC68ahAs5cp6YbiJ0Ybw+aNSEcKIO0a/6VrPlatVnpfzqjiK4uDVSxWc
         shZvrPRoyHDkUawu/5KhsSCUMMgOOvcxyP/ddO0FYUpBNViBePnChWr7zf4J1wLV5vq0
         uusVFPBtCQ5KqrfCB5stTBICecX48+7jPt3QfJCtwZuWgXMZ40l9OSZjq39sDM6SYiwG
         wk3t7T+bBJQfQUBrYLXHtQhphJoUKVh1VEr2OahVfHJrZ0o8VDJOLfa7ZklNQIaLknxC
         YmUzimCT7fc+ZR2C+ge16ZGxd1MhBbclLwy0JmQQtCEchYXFR0jUbEVvJKlhzxFas2Fk
         1Puw==
X-Gm-Message-State: AC+VfDxLD7ur9N8QV5pSjO1goilqdFO65KGH4EofNzqUIl4i/cKs5/qg
        scz2W6S844H+OmhC64O7H+pO0sjfgv9rjTdTWSHSU7Wi1tc=
X-Google-Smtp-Source: ACHHUZ79HIt60GjRQbtfV/U1SiJldzzmLD5Pr/SewxYhmk4/FCbcYdaa0Cfs8AT5JW2zubC2BaVCLRsqrV9pUbRnSHs=
X-Received: by 2002:a2e:a261:0:b0:2b3:4efe:dcd3 with SMTP id
 k1-20020a2ea261000000b002b34efedcd3mr10142055ljm.0.1687412095453; Wed, 21 Jun
 2023 22:34:55 -0700 (PDT)
MIME-Version: 1.0
From:   Masahiko Sawada <sawada.mshk@gmail.com>
Date:   Thu, 22 Jun 2023 14:34:18 +0900
Message-ID: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
Subject: Question on slow fallocate
To:     linux-xfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000008a236b05feb13e04"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--0000000000008a236b05feb13e04
Content-Type: text/plain; charset="UTF-8"

Hi all,

When testing PostgreSQL, I found a performance degradation. After some
investigation, it ultimately reached the attached simple C program and
turned out that the performance degradation happens on only the xfs
filesystem (doesn't happen on neither ext3 nor ext4). In short, the
program alternately does two things to extend a file (1) call
posix_fallocate() to extend by 8192 bytes and (2) call pwrite() to
extend by 8192 bytes. If I do only either (1) or (2), the program is
completed in 2 sec, but if I do (1) and (2) alternatively, it is
completed in 90 sec.

$ gcc -o test test.c
$ time ./test test.1 1
total   200000
fallocate       200000
filewrite       0

real    0m1.305s
user    0m0.050s
sys     0m1.255s

$ time ./test test.2 2
total   200000
fallocate       100000
filewrite       100000

real    1m29.222s
user    0m0.139s
sys     0m3.139s

Why does it take so long in the latter case? and are there any
workaround or configuration changes to deal with it?

Regards,

-- 
Masahiko Sawada
Amazon Web Services: https://aws.amazon.com

--0000000000008a236b05feb13e04
Content-Type: application/octet-stream; name="test.c"
Content-Disposition: attachment; filename="test.c"
Content-Transfer-Encoding: base64
Content-ID: <f_lj6peac20>
X-Attachment-Id: f_lj6peac20

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPGZjbnRsLmg+
CiNpbmNsdWRlIDx1bmlzdGQuaD4KCmludAptYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKewog
ICAgY2hhciAqZmlsZW5hbWUgPSBhcmd2WzFdOwogICAgaW50IHJhdGlvID0gYXRvaShhcmd2WzJd
KTsKICAgIGNoYXIgYmxvY2tbODE5Ml0gPSB7MH07CiAgICBpbnQgZmQ7CiAgICBpbnQgdG90YWxf
bGVuID0gMDsKICAgIGludCBuX2ZhbGxvY2F0ZSA9IDA7CiAgICBpbnQgbl9maWxld3JpdGUgPSAw
OwogICAgaW50IGk7CgogICAgZmQgPSBvcGVuKGZpbGVuYW1lLCBPX1JEV1IgfCBPX0NSRUFULCBT
X0lSV1hVKTsKICAgIGlmIChmZCA8IDApCiAgICB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJj
b3VsZCBub3Qgb3BlbiBmaWxlICVzOiAlbVxuIiwgZmlsZW5hbWUpOwogICAgICAgIHJldHVybiAx
OwogICAgfQoKICAgIGZvciAoaSA9IDA7IGkgPCAyMDAwMDA7IGkrKykKICAgIHsKICAgICAgICBp
bnQgcmV0OwoKICAgICAgICBpZiAocmF0aW8gIT0gMCAmJiBpICUgcmF0aW8gPT0gMCkKICAgICAg
ICB7CiAgICAgICAgICAgIHBvc2l4X2ZhbGxvY2F0ZShmZCwgdG90YWxfbGVuLCA4MTkyKTsKICAg
ICAgICAgICAgbl9mYWxsb2NhdGUrKzsKICAgICAgICB9CiAgICAgICAgZWxzZQogICAgICAgIHsK
ICAgICAgICAgICAgcHdyaXRlKGZkLCBibG9jaywgODE5MiwgdG90YWxfbGVuKTsKICAgICAgICAg
ICAgbl9maWxld3JpdGUrKzsKICAgICAgICB9CiAgICAgICAgdG90YWxfbGVuICs9IDgxOTI7CiAg
ICB9CgogICAgcHJpbnRmKCJ0b3RhbFx0JWRcbiIsIGkpOwogICAgcHJpbnRmKCJmYWxsb2NhdGVc
dCVkXG4iLCBuX2ZhbGxvY2F0ZSk7CiAgICBwcmludGYoImZpbGV3cml0ZVx0JWRcbiIsIG5fZmls
ZXdyaXRlKTsKCiAgICBjbG9zZShmZCk7CiAgICByZXR1cm4gMDsKfQ==
--0000000000008a236b05feb13e04--
