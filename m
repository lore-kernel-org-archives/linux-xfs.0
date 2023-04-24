Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66CCC77B73
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Apr 2023 18:17:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjDXSRz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Apr 2023 14:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjDXSRw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2023 14:17:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAC36E8C;
        Mon, 24 Apr 2023 11:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84838627F2;
        Mon, 24 Apr 2023 18:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0807C433EF;
        Mon, 24 Apr 2023 18:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682360245;
        bh=ASrrGk1jUaQPkp2dZOJF3C4/M1gWJYkugMCwjxZLLiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WRhSa+AOv5/rx6XlLACjr73NOiH2KoRZK+dm+iMEmp9JpPsNDFjhkw7n3t/r9VO8I
         U+jS/4f9XnHGyZ49AXXMH0AVM1S7zBWtvvhf3PMUP+oJW5+nJczB4YK4jxLAI2BW9R
         CABwPfjAY7y1Tat4FfkM70q7zuAYuB+F2jjUojKxSI7pFSfCyII/ldPba+GaP17p7Z
         p4k6q2wAN8dwQlbvuROK9W2nuF1zWYf081kbWhvG/rWqYtebDedR1LtEF7w22eUVR3
         ryGDg8nZ/3BYQqF5E/Hi60x1KxS1EM/+E2AM6Tost059I+gO0orfI5mvROjynZLjZw
         S31K0a8cs4y4A==
Date:   Mon, 24 Apr 2023 11:17:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] generic/476: reclassify this test as a long running
 soak stress test
Message-ID: <20230424181725.GG360885@frogsfrogsfrogs>
References: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
 <168123683265.4086541.1415706130542808348.stgit@frogsfrogsfrogs>
 <20230422082456.6nsk5ve756j37jas@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422082456.6nsk5ve756j37jas@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 22, 2023 at 04:24:56PM +0800, Zorro Lang wrote:
> On Tue, Apr 11, 2023 at 11:13:52AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This test is a long(ish) running stress test, so add it to those groups.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/476 |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > 
> > diff --git a/tests/generic/476 b/tests/generic/476
> > index 212373d17c..edb0be7b50 100755
> > --- a/tests/generic/476
> > +++ b/tests/generic/476
> > @@ -8,7 +8,7 @@
> >  # bugs in the write path.
> >  #
> >  . ./common/preamble
> > -_begin_fstest auto rw
> > +_begin_fstest auto rw soak long_rw stress
> 
> Sorry for late reviewing. I thought a bit more about this change. I think
> the "soak", "long_rw" and "stress" tags are a bit overlap. If the "stress"
> group means "fsstress", then I think the fsstress test can be in soak
> group too, and currently the test cases in "soak" group are same with the
> "long_rw" group [1].

Hm.  Given the current definitions of each group:

long_rw                 long-soak read write IO path exercisers
rw                      read/write IO tests
soak                    long running soak tests of any kind
stress                  fsstress filesystem exerciser

I think these all can apply to generic/476 -- it's definitely a
read-write IO test; it's definitely one that does RW for a long time;
and it uses fsstress.

> So I think we can give the "soak" tag to more test cases with random I/Os
> (fsstress or fsx or others). And rename "long_rw" to "long_soak" for those
> soak group cases which need long soaking time. Then we have two group tags
> for random loading/stress test cases, the testers can (decide to) run these
> random load test cases seperately with more time or loop count.

I have a counterproposal -- what do you think about redefining 'soak' to
mean "all tests where SOAK_DURATION can be used to control the test
runtime directly"?  This shouldn't break anyone's scripts, since the
only members of 'soak' are the ones that get modified by this patchset.

--D

> Anyway, above things can be done in another patchset, I just speak out to
> get more talking:) For this patch:
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> 
> 
> Thanks,
> Zorro
> 
> [1]
> # ./check -n -g soak
> SECTION       -- simpledev
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64
> MKFS_OPTIONS  -- -f -m rmapbt=1 /dev/sda3
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch
> 
> generic/521
> generic/522
> generic/642
> 
> # ./check -n -g long_rw
> SECTION       -- simpledev
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64
> MKFS_OPTIONS  -- -f -m rmapbt=1 /dev/sda3
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda3 /mnt/scratch
> 
> generic/521
> generic/522
> generic/642
> 
> 
> >  
> >  # Override the default cleanup function.
> >  _cleanup()
> > 
> 
