Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64BDCE7D240
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Sep 2023 07:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbjIZHOv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 03:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjIZHOr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 03:14:47 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09D8DE
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 00:14:40 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-3215f19a13aso7927770f8f.3
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 00:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695712479; x=1696317279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FcvvehAS/f631aYRS24SIzDnar4GvFNRE/vcZDypjLg=;
        b=EyvKsA2ycd4P5I2WFBX6Q07rAsQ/QP2HCWlsyzx92lZT+6XqU1jxeJJUEfLvtXJGYO
         ws1dki9pMJod55kAumE4rc27+c6NlPm5HgB0uTBBmHzHOIZDYU9IxPZfvjFeH7CbgV6R
         zjmjwZRwziPQfHTjPPOg4tnqlubmAjARnEZ+PRZDjcuT1u4v4/3VBbf60tB5VX3xd+pA
         PDJiIhMiaYVp6H7WEfDGOzAAv/jXNNfQ/m1s3Dqe5IVoW8eEL0NX1Di1fCsxJVNHHV8f
         a8pNuhH+hb7QmYUxS0sWKIe8k4jOzWNMwLCe1NAa9XioJIW4mlshePqs4PSfxNBGRWLO
         4JTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695712479; x=1696317279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FcvvehAS/f631aYRS24SIzDnar4GvFNRE/vcZDypjLg=;
        b=X3VkE9pHHOi7frynA6tEfp3a+Vk0zW9csgpJsCiOPP7XPB5sgVB3cYxOE6Nj2vgqgI
         K8WNzLGhmbWJNN/lBpD/Dnc6yXvrZE4I7va9iJGFSgZOqiHxLdh/JQFV6VJG6ZnLjsDr
         0RRWiMzygPi31K6lP/nZAZxzLM2lJ2CDv6I/XzROEZKqD6gfjo0+dphRAz7X46ROmjzB
         I8GIql0cRzeVvqTaWZBwx3XjNStiCSeCHgfDMPEpyNfMbVf9QrNJ/YUO05SC2+O61nS8
         VKhIBVn7QT4tG3vSvALvxcihONg2knUydlbFnJW7+6D2TpD4O019HkZXFOjWcgEEyDrN
         F/4A==
X-Gm-Message-State: AOJu0Yx4/Alrr4PSTnAqlPj8T+9rifMipvGsdbpHe5Rb4/dKx12mSqXW
        NvHE4ERq/1QYh8UBY44os+iQcjCDUJM=
X-Google-Smtp-Source: AGHT+IHPy2YlWhLl8E310WMcSkW6Nxx/dwNRTza5a1tBf7zm0yAtn4gv9l6wtklCavZ6lyz18eIrPQ==
X-Received: by 2002:adf:a456:0:b0:323:1d6e:bd02 with SMTP id e22-20020adfa456000000b003231d6ebd02mr5710588wra.57.1695712479176;
        Tue, 26 Sep 2023 00:14:39 -0700 (PDT)
Received: from krnowak-ms-ubuntu.fritz.box ([45.135.60.1])
        by smtp.gmail.com with ESMTPSA id r5-20020a05600c320500b003fc0505be19sm9046210wmp.37.2023.09.26.00.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 00:14:38 -0700 (PDT)
From:   Krzesimir Nowak <qdlacz@gmail.com>
X-Google-Original-From: Krzesimir Nowak <knowak@microsoft.com>
To:     linux-xfs@vger.kernel.org
Cc:     Krzesimir Nowak <knowak@microsoft.com>
Subject: [PATCH 0/1] Fix cross-compilation issue with randbytes
Date:   Tue, 26 Sep 2023 09:14:31 +0200
Message-Id: <20230926071432.51866-1-knowak@microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I hope this is the right place to send the xfsprogs patches - the
documentation about contributing is rather scarce.

This is a patch that we carry in Flatcar in order to make xfsprogs
buildable.

I think that the issue with cross-compilation is here since
d8a19f2986c0f65c5ed02110192f3fd5f86e2b32.

Krzesimir Nowak (1):
  libfrog: Fix cross-compilation issue with randbytes

 libfrog/randbytes.c | 1 -
 libfrog/randbytes.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.25.1

