Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F78BC433FE
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Apr 2022 16:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240449AbiDJQKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 12:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiDJQKX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 12:10:23 -0400
Received: from out20-15.mail.aliyun.com (out20-15.mail.aliyun.com [115.124.20.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4719E5DE61;
        Sun, 10 Apr 2022 09:08:12 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08045354|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.123095-0.000502195-0.876403;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047204;MF=guan@eryu.me;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.NNrBXRH_1649606889;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.NNrBXRH_1649606889)
          by smtp.aliyun-inc.com(33.40.23.6);
          Mon, 11 Apr 2022 00:08:09 +0800
Date:   Mon, 11 Apr 2022 00:08:08 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] xfs: add memory failure tests for dax mode
Message-ID: <YlMA6Nb4Azx7nTuZ@desktop>
References: <20220311151816.2174870-1-ruansy.fnst@fujitsu.com>
 <4abf66f4-2101-db09-f1c1-4c70668038d3@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4abf66f4-2101-db09-f1c1-4c70668038d3@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 11:00:59PM +0800, Shiyang Ruan wrote:
> ping...  any comments?

Sorry for the DELAY.. The tests look fine to me overall, but I'd like
xfs folks to take a look at them as well.

Thanks,
Eryu

> 
> 在 2022/3/11 23:18, Shiyang Ruan 写道:
> > This patchset is to verify whether memory failure mechanism still works
> > with the dax-rmap feature[1].  With this feature, dax and reflink can be
> > used together[2].  So, we also test it for reflinked files in filesystem
> > mounted with dax option.
> > 
> > [1] https://lore.kernel.org/linux-xfs/20220227120747.711169-1-ruansy.fnst@fujitsu.com/
> > [2] https://lore.kernel.org/linux-xfs/20210928062311.4012070-1-ruansy.fnst@fujitsu.com/
> > 
> > Shiyang Ruan (3):
> >    xfs: add memory failure test for dax mode
> >    xfs: add memory failure test for dax&reflink mode
> >    xfs: add memory failure test for partly-reflinked&dax file
> > 
> >   .gitignore                      |   1 +
> >   src/Makefile                    |   3 +-
> >   src/t_mmap_cow_memory_failure.c | 154 ++++++++++++++++++++++++++++++++
> >   tests/xfs/900                   |  48 ++++++++++
> >   tests/xfs/900.out               |   9 ++
> >   tests/xfs/901                   |  49 ++++++++++
> >   tests/xfs/901.out               |   9 ++
> >   tests/xfs/902                   |  52 +++++++++++
> >   tests/xfs/902.out               |   9 ++
> >   9 files changed, 333 insertions(+), 1 deletion(-)
> >   create mode 100644 src/t_mmap_cow_memory_failure.c
> >   create mode 100755 tests/xfs/900
> >   create mode 100644 tests/xfs/900.out
> >   create mode 100755 tests/xfs/901
> >   create mode 100644 tests/xfs/901.out
> >   create mode 100755 tests/xfs/902
> >   create mode 100644 tests/xfs/902.out
> > 
> 
