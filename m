Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78FD1C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 22:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiF1Wcz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 18:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiF1Wcz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 18:32:55 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F3C38190
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 15:32:54 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id n12-20020a9d64cc000000b00616ebd87fc4so1938812otl.7
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 15:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:message-id:date:mime-version:user-agent:to:subject
         :content-transfer-encoding;
        bh=+tUsOCuGSMPtNOlB7xKx42ANs6vNZAXz3/PqKn3QKfY=;
        b=QkeS/k7FKffmfkh9rn6HRLkkywIT4AZEhCCwQbR92I9S67HrWCY+cD905wIMTk6Zx/
         VaSRc6NjBRFQm9z4JYRSRJWk3Bqre8xiDwfJzBhwOZT8kYz31oMJX+juORmaYjBBJ6sn
         lRRZEHMxRawZBFFjpE+0YVqX9c3C5WNol790Rk6g793JYw4FkiFA+F/krtVXfEBXnP3d
         adl9ybig4Mj1LVV3IfkXB/ok9LDERbImeZB9stC6Dj7WwHC9IPZAJpB49OJrhrCrYeVi
         8LooRhvHQf9BS3sMVyRVsxVN5laBBZN331f4Rqe85c8MmDsusrCd9LU741S5FjBoZ6+h
         eENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:to
         :subject:content-transfer-encoding;
        bh=+tUsOCuGSMPtNOlB7xKx42ANs6vNZAXz3/PqKn3QKfY=;
        b=7UX2FGSlijL6xHrZj7tejr0ezIFFbDL+cqFKhvrLs+cqRTmJ0lq4huO6hhQ2ZDfsE9
         Pvv/JMdjkPtZ2drRLzJ0ljPD8pBhyaQvoZNL0jb6nLYpfn0YblZc2uizXyIxAYO3KG85
         EsvVKscBxZudv51WOdZUcLvqAJYSXCT0xj5Qy8cDf8DI22qrhsfCxEEQEoY+6FxqFnxT
         2ZdM4e0ZyDmZ9tjYDXMv4LnxQLbh1QqAV3yLTNmUJ29gIb3d11eMpN1i0q5snW2TWfTA
         LigtRuXXIaHiIq7Qk9dEGU7016iLuYjLuC9Kx4Toodmphfh+6yK4eSExVrOW6u2Y5kiW
         pOKw==
X-Gm-Message-State: AJIora+G/kDoJ7UVY8lwC9IzDQwbnbdZT8RQ9nt0vc3O7k6KKpa36/iO
        XgdQxP/ePXwNKd5RpBteirhRPZJUyTE=
X-Google-Smtp-Source: AGRyM1u9iIZqMTnV/XiFQhp/yGwXnmzRSTU0XYqRwjppA1FOFB9jqto55hrtS8Rz66KLUZjrtlHoYA==
X-Received: by 2002:a05:6830:924:b0:616:d6ce:9436 with SMTP id v36-20020a056830092400b00616d6ce9436mr172776ott.9.1656455574026;
        Tue, 28 Jun 2022 15:32:54 -0700 (PDT)
Received: from [192.168.68.32] (cpc77339-stav19-2-0-cust1016.17-3.cable.virginm.net. [82.40.31.249])
        by smtp.gmail.com with ESMTPSA id j24-20020a4a7518000000b0041b89126eacsm8291556ooc.14.2022.06.28.15.32.52
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 15:32:53 -0700 (PDT)
From:   corinhoad@gmail.com
X-Google-Original-From: ch.xfs@themaw.xyz
Message-ID: <089bacd9-6213-d73f-f188-d4a31d91f447@gmail.com>
Date:   Tue, 28 Jun 2022 23:32:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To:     linux-xfs@vger.kernel.org
Subject: [bug report] xfsdump fails to build against xfsprogs 5.18.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

I package xfsdump for NixOS, and I have found that a recent upgrade from 
xfsprogs 5.16.0 to 5.18.0 has caused a build failure for xfsprogs. See 
[1] for an excerpt from the build logs. My novice investigation of the 
issue and disccusion IRC indicates that the removal of DMAPI support is 
behind this.

Best,
Corin Hoad

[1]
content.c: In function 'restore_complete_reg':
content.c:7727:29: error: storage size of 'fssetdm' isn't known
  7727 |                 fsdmidata_t fssetdm;
       |                             ^~~~~~~
content.c:7734:34: error: 'XFS_IOC_FSSETDM' undeclared (first use in 
this function); did you mean 'XFS_IOC_FSSETXATTR'?
  7734 |                 rval = ioctl(fd, XFS_IOC_FSSETDM, (void 
*)&fssetdm);
       |                                  ^~~~~~~~~~~~~~~
       |                                  XFS_IOC_FSSETXATTR
content.c:7734:34: note: each undeclared identifier is reported only 
once for each function it appears in
content.c:7727:29: warning: unused variable 'fssetdm' [-Wunused-variable]
  7727 |                 fsdmidata_t fssetdm;
       |                             ^~~~~~~
content.c: In function 'restore_symlink':
content.c:8061:29: error: storage size of 'fssetdm' isn't known
  8061 |                 fsdmidata_t fssetdm;
       |                             ^~~~~~~
content.c:8061:29: warning: unused variable 'fssetdm' [-Wunused-variable]
content.c: In function 'setextattr':
content.c:8867:9: warning: 'attr_set' is deprecated: Use setxattr or 
lsetxattr instead [-Wdeprecated-declarations]
  8867 |         rval = attr_set(path,
       |         ^~~~
In file included from content.c:27:
/nix/store/7b84p7877fl9p8aqx392drggj0jkqd0j-attr-2.5.1-dev/include/attr/attributes.h:139:12: 
note: declared here
   139 | extern int attr_set (const char *__path, const char *__attrname,
       |            ^~~~~~~~
content.c: In function 'Media_mfile_next':
content.c:4797:33: warning: ignoring return value of 'system' declared 
with attribute 'warn_unused_result' [-Wunused-result]
  4797 |                                 system(media_change_alert_program);
       |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
content.c: In function 'restore_extent':
content.c:8625:49: warning: ignoring return value of 'ftruncate' 
declared with attribute 'warn_unused_result' [-Wunused-result]
  8625 |                                                 ftruncate(fd, 
bstatp->bs_size);
       | 
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
make[2]: *** [../include/buildrules:47: content.o] Error 1
make[1]: *** [include/buildrules:23: restore] Error 2
make: *** [Makefile:53: default] Error 2
