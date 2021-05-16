Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983A2C433B4
	for <linux-xfs@archiver.kernel.org>; Sun, 16 May 2021 15:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6972E61075
	for <linux-xfs@archiver.kernel.org>; Sun, 16 May 2021 15:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhEPP7h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 May 2021 11:59:37 -0400
Received: from out20-3.mail.aliyun.com ([115.124.20.3]:42561 "EHLO
        out20-3.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhEPP7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 May 2021 11:59:32 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.3407878|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.0235408-0.00299268-0.973467;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047202;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.KEF-Yx2_1621180694;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KEF-Yx2_1621180694)
          by smtp.aliyun-inc.com(10.147.43.230);
          Sun, 16 May 2021 23:58:14 +0800
Date:   Sun, 16 May 2021 23:58:14 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCHSET 0/8] fstests: miscellaneous fixes
Message-ID: <YKFBFprgsInkvfta@desktop>
References: <162078489963.3302755.9219127595550889655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162078489963.3302755.9219127595550889655.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 07:01:39PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Various small fixes to the fstests suite, and some refactoring of common
> idioms needed for testing realtime devices.

I applied patch 1 3 5 and 7. I have some comments in patch 2 and 8, and
need more eyes to look at patch 4 and 6.

Thanks,
Eryu
