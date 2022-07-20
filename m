Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C07C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 18:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiGTSLc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 14:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiGTSLb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 14:11:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECE73B955
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 11:11:30 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f11so15695085plr.4
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 11:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/FmOdNJUVcNQc46kPy6TXLU2vsnWz7FBU6vLXoDGNIM=;
        b=BTfAnqG+u7ganFo7XbjTyHaCoMm7frdFBC73EeMJmPQJU/7+S5sr7mw9EpnLLMkX5Z
         qBGkTnoGaW74wYsUt6FdT125GT6a4PCcPN7hSFr2zOF81aObCts1PdRucjBNPiAw9ziC
         UXKlH+sKVD9vD6KAa0R3Zk5jsEkrk+cwhVKJadMeTUmcxNcFB14ISGpAX973lRNHVU+C
         h/XWpwAt0Xe4trMM5mZ7xN/oCzrQaiaF1W0Cj/T3yxdX9R1ovba/6OSE9MafWjCscjsG
         F4AE0KY1adrxSJMmmrjBkBatet2ckqaS57X6AC9gd26nsUfZ8yFpcq/vnpwcBWQcWzeI
         0EnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/FmOdNJUVcNQc46kPy6TXLU2vsnWz7FBU6vLXoDGNIM=;
        b=cYWGmW2WRdkU353od/E9nAy3DDETd1hlYvAMIqxamNYAU2BSRUMpg4sdNB//AKji2D
         PXJqut+F6KiaTFxrYHvSx0oKPYbzMuQh9MWLlanHdrpe8m8hSX+1WX8QG5p4H8xsEHu6
         9pfuJqVZHbYRsuzXhw7ATTw4oSm5AehV1rCDlVL5725nQyB+ALzSvn7Hssm6CUflwK09
         G5sko+wfthZ5B+td72opBX/t37QdwPn1VymzddAcXGWziAqGq8Y4yeqhpGaOICAILL/5
         JFb4JNtNaX5chmBHa4FhOaREmgqqaNp25KQDoPqS1FeWyyY4tYppag+mQ+MGHdla1iMa
         Lqag==
X-Gm-Message-State: AJIora9oACMnX5AEnh7Sg0qA7P7GmBFALrmkOd3cLSdOSP3LlLmKTl6A
        HM5Qgj3NTKdUOm/g7JmAKso=
X-Google-Smtp-Source: AGRyM1vomvny7AixhghRQvjTRJXKeQOYf2WaLckkinXzGYSKvLUiuUkOw8g+V2J8U5WzT9b4hcp32g==
X-Received: by 2002:a17:902:f253:b0:16d:1901:38fd with SMTP id j19-20020a170902f25300b0016d190138fdmr7487806plc.94.1658340690210;
        Wed, 20 Jul 2022 11:11:30 -0700 (PDT)
Received: from google.com ([2620:15c:2c1:200:bd01:d614:c22:9f6d])
        by smtp.gmail.com with ESMTPSA id h14-20020a63e14e000000b004161b3c3388sm12156648pgk.26.2022.07.20.11.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 11:11:29 -0700 (PDT)
Date:   Wed, 20 Jul 2022 11:11:27 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 5.15 CANDIDATE 0/9] xfs stable candidate patches for
 5.15.y (part 3)
Message-ID: <YthFT0bJlbEdhPTY@google.com>
References: <20220718202959.1611129-1-leah.rumancik@gmail.com>
 <YtXXhQuOioUeSltH@magnolia>
 <CAOQ4uxh13NPtWP98E-R7Sxfy=dkgCHxk7tysEykJ2rg3yhJ__A@mail.gmail.com>
 <YtbDSQjWaVvweLRC@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtbDSQjWaVvweLRC@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 19, 2022 at 07:44:25AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 19, 2022 at 10:44:29AM +0200, Amir Goldstein wrote:
> > On Tue, Jul 19, 2022 at 12:05 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Mon, Jul 18, 2022 at 01:29:50PM -0700, Leah Rumancik wrote:
> > > > Hi again,
> > > >
> > > > This set contains fixes from 5.16 to 5.17. The normal testing was run
> > > > for this set with no regressions found.
> > > >
> > > > I included some fixes for online scrub. I am not sure if this
> > > > is in use for 5.15 though so please let me know if these should be
> > > > dropped.
> > > >
> > > > Some refactoring patches were included in this set as dependencies:
> > > >
> > > > bf2307b19513 xfs: fold perag loop iteration logic into helper function
> > > >     dependency for f1788b5e5ee25bedf00bb4d25f82b93820d61189
> > > > f1788b5e5ee2 xfs: rename the next_agno perag iteration variable
> > > >     dependency for 8ed004eb9d07a5d6114db3e97a166707c186262d
> > > >
> > > > Thanks,
> > > > Leah
> > > >
> > > >
> > > > Brian Foster (4):
> > > >   xfs: fold perag loop iteration logic into helper function
> > > >   xfs: rename the next_agno perag iteration variable
> > > >   xfs: terminate perag iteration reliably on agcount
> > > >   xfs: fix perag reference leak on iteration race with growfs
> > > >
> > > > Dan Carpenter (1):
> > > >   xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
> > > >
> > > > Darrick J. Wong (4):
> > > >   xfs: fix maxlevels comparisons in the btree staging code
> > >
> > > Up to this point,
> > > Acked-by: Darrick J. Wong <djwong@kernel.org>
> > >
> > > >   xfs: fix incorrect decoding in xchk_btree_cur_fsbno
> > > >   xfs: fix quotaoff mutex usage now that we don't support disabling it
> > > >   xfs: fix a bug in the online fsck directory leaf1 bestcount check
> > >
> > > No objections to these last three, since they're legitimate fixes for
> > > bugs in 5.15, but I would advise y'all not to worry too much about fixes
> > > for EXPERIMENTAL features.
> 
> Also, to clarify -- if you /do/ want to pick up the scrub fixes, then
> yes, the Acked-by above does apply to the entire set.  I don't know if
> you have people running (experimental) scrub, but I don't know that you
> **don't**. :)

These fixes aren't a priority over here so I'll postpone scrub fixes in
the future since it doesn't seem like people care. For this set, is
there coverage in xfstests for them? If so, I'll go ahead and keep them,
but if not, I'll just drop them.

- Leah

> 
> > FWIW, from the set above, I only picked Dan Carpenter's fix for 5.10.
> > I'll include it in one of the following updates.
> 
> <nod>
> 
> --D
> 
> > Thanks,
> > Amir.
