Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B4BC432BE
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 11:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CBBB610CE
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 11:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhHALSU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Aug 2021 07:18:20 -0400
Received: from out20-49.mail.aliyun.com ([115.124.20.49]:56753 "EHLO
        out20-49.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhHALST (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Aug 2021 07:18:19 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07652099|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0589589-0.00576045-0.935281;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.KtpL9V7_1627816690;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KtpL9V7_1627816690)
          by smtp.aliyun-inc.com(10.147.40.44);
          Sun, 01 Aug 2021 19:18:10 +0800
Date:   Sun, 1 Aug 2021 19:18:09 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, fstests@vger.kernel.org,
        guaneryu@gmail.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/530: Do not pass block size argument to
 _scratch_mkfs
Message-ID: <YQaC8SrE/pWwu47O@desktop>
References: <20210726064313.19153-1-chandanrlinux@gmail.com>
 <20210726170827.GU559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726170827.GU559212@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 10:08:27AM -0700, Darrick J. Wong wrote:
> On Mon, Jul 26, 2021 at 12:13:11PM +0530, Chandan Babu R wrote:
> > _scratch_do_mkfs constructs a mkfs command line by concatenating the values of
> > 1. $mkfs_cmd
> > 2. $MKFS_OPTIONS
> > 3. $extra_mkfs_options
> > 
> > The block size argument passed by xfs/530 to _scratch_mkfs() will cause
> > mkfs.xfs to fail if $MKFS_OPTIONS also has a block size specified. In such a
> > case, _scratch_do_mkfs() will construct and invoke an mkfs command line
> > without including the value of $MKFS_OPTIONS.
> > 
> > To prevent such silent failures, this commit removes the block size option
> > that was being explicitly passed to _scratch_mkfs().

Patch looks fine to me, and queued for update.

> 
> Yes, that makes sense.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

I'm wondering if mkfs.xfs could restore the behavior that allows
re-specified options, and the last specified wins, e.g.

mkfs -t xfs -b 1k -b 2k -f /dev/sda2

and mkfs.xfs didn't report failure but created xfs with 2k blocksize.
This may cause less problems like this patch resolved.

Thanks,
Eryu

> 
> --D
> 
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/530 | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tests/xfs/530 b/tests/xfs/530
> > index 4d168ac5..16dc426c 100755
> > --- a/tests/xfs/530
> > +++ b/tests/xfs/530
> > @@ -60,7 +60,7 @@ echo "Format and mount rt volume"
> >  
> >  export USE_EXTERNAL=yes
> >  export SCRATCH_RTDEV=$rtdev
> > -_scratch_mkfs -d size=$((1024 * 1024 * 1024)) -b size=${dbsize} \
> > +_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
> >  	      -r size=${rtextsz},extsize=${rtextsz} >> $seqres.full
> >  _try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
> >  
> > -- 
> > 2.30.2
> > 
