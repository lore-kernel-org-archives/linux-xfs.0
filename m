Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B55BC432BE
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 13:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62710610D2
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 13:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhHANCZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Aug 2021 09:02:25 -0400
Received: from out20-111.mail.aliyun.com ([115.124.20.111]:50093 "EHLO
        out20-111.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhHANCY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Aug 2021 09:02:24 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09353527|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0986455-0.00303062-0.898324;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047205;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.KtqKI5O_1627822933;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KtqKI5O_1627822933)
          by smtp.aliyun-inc.com(10.147.41.137);
          Sun, 01 Aug 2021 21:02:14 +0800
Date:   Sun, 1 Aug 2021 21:02:13 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] check: don't leave the scratch filesystem mounted
 after _notrun
Message-ID: <YQabVTp2WOh2VjIn@desktop>
References: <162743097757.3427426.8734776553736535870.stgit@magnolia>
 <162743098874.3427426.3383033227839715899.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162743098874.3427426.3383033227839715899.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 05:09:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Unmount the scratch filesystem if a test decides to _notrun itself
> because _try_wipe_scratch_devs will not be able to wipe the scratch
> device prior to the next test run.  We don't want to let scratch state
> from one test leak into subsequent tests if we can help it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  check |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/check b/check
> index bb7e030c..5d71b74c 100755
> --- a/check
> +++ b/check
> @@ -871,6 +871,11 @@ function run_section()
>  			notrun="$notrun $seqnum"
>  			n_notrun=`expr $n_notrun + 1`
>  			tc_status="notrun"
> +
> +			# Unmount the scratch fs so that we can wipe the scratch
> +			# dev state prior to the next test run.
> +			_scratch_unmount 2> /dev/null
> +			rm -f ${RESULT_DIR}/require_scratch*

I think _notrun has removed $RESULT_DIR/require_scratch* already, and we
could remove above line. I'll remove it on commit.

Thanks,
Eryu

>  			continue;
>  		fi
>  
