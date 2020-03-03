Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C6AC3F2C6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 16:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE3DE20863
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 16:50:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=davidb.org header.i=@davidb.org header.b="Apb3uGKC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgCCQuH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 11:50:07 -0500
Received: from mail-qk1-f171.google.com ([209.85.222.171]:41894 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgCCQuH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 11:50:07 -0500
Received: by mail-qk1-f171.google.com with SMTP id b5so4033484qkh.8
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2020 08:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidb.org; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=km4OkNROSJ95qCsFpDWcpvbc+H2xzz8ZET0YXgKWASc=;
        b=Apb3uGKCP0YMy64bDJHYWO/GgwJE5/yj3MkIqlzjm2ciKhjSMIp4Ycw0yhfoQH5bua
         kaw0trqt/FZLImyxCT/ImhWO0is3BUC2/en56B0c3xZuM11VtKoPIF9ckVqYUWMtsyz/
         FRXqVUAsNSZrlDQx9NAfiHc7508J2Rjvcx3f4MsHPLUgVQ6vyHx7NVBMb6IQdJYoxCYy
         Gxh1XSkahVucQxvU8mzaKzM4kuJjP0COD8yFzcEYY5nC5+lO++5hiaZYmMYSNoj0FVSa
         xY2bSseJ1Em7KTMGsX3hSameuL2WPurZ8YsZJr7oSE6/0g7a0SeytmhqinXeTAtL7Sx9
         qtug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=km4OkNROSJ95qCsFpDWcpvbc+H2xzz8ZET0YXgKWASc=;
        b=mS4qOZ4/614xhosF1RSoqtKbA/FPYxIzNaci4BHl1etDcx5vNIkGaj4rVqF2KW6KlF
         Sa/B7MEYNB9Mxnuv/KcWl7bCzuJl5LsdKqvwODDpwsm4q0Qpc3k2m8C94BpIjAdbvWAf
         NuZtvqmtIYrXfUwqZjViYR0Yw+BzqS0pj+CJNYlVVEFejUmYu5RGmB7+2IAk3IFNCVib
         6sT80heDT01JYVRl2+XLSx8YQIRGqUYoUqAghTw2Yr69OHBhiRbLV5IHdYXxADy8k4hd
         CRDdyVqeyz5dL0zZOBQzz4850J8m3P5CweiWZlXpsXIfk/81wx2SE6q3aAc3rFVDzN27
         jwBA==
X-Gm-Message-State: ANhLgQ1k+9ArTBEGLt5vAjK9gS8IaAXd0L1Hzm2lgl5qgK7ylGD3xqsL
        Rq3cFCqNDGswBbFsFStqFLptGKUnDQ2K3a8woETsOGQclcoqJSOrR9xOnWMunFTQEw5knQ9H0/a
        9AtXjT4awNb/e4Oj/fxePkHJc0w7M/lAlOrO0lRQ2V20PbFsC6LrZpNLKqaj8u4ERItf4Vws=
X-Google-Smtp-Source: ADFU+vvqvAXKYn0EEnpBof+7mTTHNkCdFeus2k3XFhEInHqk4iDrw377sG8HaNbNlj7jHrWhprAXtw==
X-Received: by 2002:a05:620a:6ca:: with SMTP id 10mr4867219qky.462.1583254203901;
        Tue, 03 Mar 2020 08:50:03 -0800 (PST)
Received: from davidb.org (cn-co-b07400e8c3-142422-1.tingfiber.com. [64.98.48.55])
        by smtp.gmail.com with ESMTPSA id r5sm12516077qtn.25.2020.03.03.08.50.02
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 08:50:03 -0800 (PST)
Date:   Tue, 3 Mar 2020 09:50:00 -0700
From:   David Brown <davidb@davidb.org>
To:     linux-xfs@vger.kernel.org
Subject: Unable to xfsdump/xfsrestore filesystem
Message-ID: <20200303165000.GA33105@davidb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I am using xfsdump with multiple levels to backup my main system
(Fedora f31, xfs root and home on LVM).  Kernel is
5.5.6-201.fc31.x86_64.

When doing a test restore of my backup, when I reach my level 2
backup, I get the following warnings:

    xfsrestore: directory post-processing
    xfsrestore: WARNING: unable to rename dir orphanage/422178422.2232121414 to dir <<path>>/b-cloud: No such file or directory

In addition, I get hundreds of these.  They seem to all be related to
that same directory.

    xfsrestore: restoring non-directory files
    xfsrestore: WARNING: open of orphanage/422178422.2232121414/modules/atmel/cmake_install.cmake failed: No such file or directory: discarding ino 2833282
    xfsrestore: WARNING: open of orphanage/422178422.2232121414/modules/atmel/asf/common/cmake_install.cmake failed: No such file or directory: discarding ino 2833283

When I verify the restore (using https://github.com/d3zd3z/rsure), I
indeed find that <<path>>/b-cloud is missing, but another directory
next to it is still present that should be removed.

Restores of subsequent print similar messages (and don't restore the
directory), until one of them dies with this:

    xfsrestore: WARNING: unable to rename dir orphanage/422178422.2232121414 to dir <<path>>/b-cloud: No such file or directory
    xfsrestore: node.c:539: node_map: Assertion `nh != NH_NULL' failed.

Any ideas on how to debug this?

Thanks,
David
