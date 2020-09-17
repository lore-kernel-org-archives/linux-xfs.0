Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CE5C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 05:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8168208E4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 05:20:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dw6Jm/8C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgIQFUk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 01:20:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725267AbgIQFUk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 01:20:40 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 01:20:39 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600320038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=JV6HYaL48gAOZrh2ZlwzMF3jTx5tcdI3QomukudpFCE=;
        b=Dw6Jm/8C/qvb/hbWcMw9AGMaFe7pDxPLN8+139U1B8lfCvioljdC6FHLBJSLEvcA5Brmmy
        I9QC8XK4BrkZRHvOhdoaQIoHsOatvv/2TW9krw5TUQi2ampSokMV/t09V0BOlUUuaZQyeA
        Q95gBhpxEdgfSArd35fmYM2XtguyRt8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-qTfCIGnYP_2VpJSKKi_o9Q-1; Thu, 17 Sep 2020 01:14:26 -0400
X-MC-Unique: qTfCIGnYP_2VpJSKKi_o9Q-1
Received: by mail-pf1-f200.google.com with SMTP id a16so698918pfk.2
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 22:14:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JV6HYaL48gAOZrh2ZlwzMF3jTx5tcdI3QomukudpFCE=;
        b=Oaupnd9VnvGe5LacqnsBE+tUlyURhzPAQP8WCK07wLH+23j59THfFcpZCtM787Bh4Z
         kIyOQTrjgIKnNaxRLeA47BsQ1DGR9tWoClZmV/rBmpR/+RjxppinTCePMDc+IRz7fKNn
         GekGOtcpLx0ScvkFeJF9rDtHOMSXdQoZDcUWJr3Snc4A9o5D/l06D4tyUC8y7A2M17cA
         yhjPutPwksLGYx2jLx+fGOsSR72Zx1540Q0364RpfYo+IzHSwA2N2tfx9QLetG/CnX17
         7/F67rUx8Y8GhLlT7H+aEc6WxYHzs6ljuRdQ1GyN7mOMKSuKbu82wf/wPiOXmDEmi+jV
         Nvog==
X-Gm-Message-State: AOAM533pgy+V8m4rz0QqNUSY2KAquUKE1/CQtl4/Qsg399xe0X3xiO4g
        9uVi/WxGf9cHpc3f7+fNxO/F3IIgd+a/baRu/d63nttY4I6r6D1KtksKEkBTV+2ae7Tf/8ykpNu
        seteKTIafo0kcr/eW3SvK
X-Received: by 2002:a05:6a00:1481:b029:142:2501:35d7 with SMTP id v1-20020a056a001481b0290142250135d7mr9686431pfu.55.1600319665173;
        Wed, 16 Sep 2020 22:14:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLu/uCSXSRloFAyJ+JwbnkJAibTRsyMjWvCCUfLxqn8COZXguHH/BjDcqgrDodbSTE7TZBgg==
X-Received: by 2002:a05:6a00:1481:b029:142:2501:35d7 with SMTP id v1-20020a056a001481b0290142250135d7mr9686414pfu.55.1600319664966;
        Wed, 16 Sep 2020 22:14:24 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w2sm4269921pgb.43.2020.09.16.22.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 22:14:24 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2 0/2] xfs: random patches on log recovery
Date:   Thu, 17 Sep 2020 13:13:39 +0800
Message-Id: <20200917051341.9811-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Here are some patches after I read recovery code days ago.
Due to code coupling, I send them as a patchset.

This version mainly addresses previous review from Brian,
sorry for taking some time due to another work.

I already ran fstests and no strange out on my side and
detail changelog is in each individual patch.

Thanks,
Gao Xiang

Gao Xiang (2):
  xfs: avoid LR buffer overrun due to crafted h_len
  xfs: clean up calculation of LR header blocks

 fs/xfs/xfs_log.c         |  4 +-
 fs/xfs/xfs_log_recover.c | 87 ++++++++++++++++------------------------
 2 files changed, 36 insertions(+), 55 deletions(-)

-- 
2.18.1

