Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D512C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 06:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiFWG2s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 02:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiFWG2r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 02:28:47 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020243632B
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 23:28:47 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id 184so4214241vsz.2
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 23:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2rdmvrzvmj+KFUxKSCH6J3bamrs7uYhMroOl56MRpEI=;
        b=qI8sF92uQSQh90DCAT0VpJmNDpCBm9dC0g+FvH2Z5kaWiIZSiSdINhWUPxQWm+2HN2
         HT3XhXBFVhUZCtak7IAwFZ9Yjb3SY57sdv32w2RC28RWZ4UrNq/+1iZA4VwvwC82RLaf
         nYd/ONUmAWP1966TZT98QEBO65grUvRbVvS/Kw7hOjrXwXU5+JOzKAgy9iqVyvpC4lyY
         un4kxChQciHTxKIfyNQXimqsh5P3TgaQsNwhVq8IQJWjZXxYNSRGnhEtTAX6q/oxa8u8
         RcbJMuF+WXwWSzwsvGdBLQ7IlgylEQlyuEeRqMaIlZ437G3w2+xGHcIan5ebNpUu5gyx
         52Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2rdmvrzvmj+KFUxKSCH6J3bamrs7uYhMroOl56MRpEI=;
        b=jtDIGBmZ4mk/3y9A9Uk2zbvvIseBsjlLsggExRADB+QDYVZOt9JAzhtxTeU3iQPleH
         pwBNO25h7HIEVUabpTyHn05CbAwR9IjwNCbjjiHB4qAAKLXPryvafkIBTozB4X7qXL7s
         +CCiOVj5IrWoPcYNCWUgDY2vYBqD7gqxiPAgfC1tZKLdlBB0DOfV4+28ujpImgdndULg
         EyfDxgTCBpnJ9tf17SOWkAchLy/zw/RJDP9IJUn4pvuh6MpRTv5bYRa42SKi//aBuaBn
         1s3S0wf+6vEs6/FBDojWYMAmBo+fDOiaGOLvWheCumh5OQjislHSCuwn+8zeVSFrZJgt
         IBgg==
X-Gm-Message-State: AJIora/no7q3XuBp9z+2k8jiXwXI7UhQewAS8lXRC3/c06RtPrxaQd/e
        TliabdLkPyQpLWFaYdfgwEYcTod68/gAL4sP6AL+daps+eu9Mg==
X-Google-Smtp-Source: AGRyM1tCZ4NUyzovmDl2kTTNqhH+sKYaLnrlUlb+kvlXj1gbEGkv2rwAkoQnneR6631cgjzedUAk0nrpRIdcb1Dy5Ok=
X-Received: by 2002:a67:fa01:0:b0:354:3136:c62e with SMTP id
 i1-20020a67fa01000000b003543136c62emr9578492vsq.2.1655965726029; Wed, 22 Jun
 2022 23:28:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrNB65ISwFDgLT4O@magnolia> <YrNExw1XTTD1dJET@magnolia> <YrOJu6I5Ui0CGcYr@google.com>
 <CAOQ4uxh=mzrLxn_xRfApJzFD7kZ8evxnxwyFMzRYDgg5Y3_Oqg@mail.gmail.com>
In-Reply-To: <CAOQ4uxh=mzrLxn_xRfApJzFD7kZ8evxnxwyFMzRYDgg5Y3_Oqg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 23 Jun 2022 09:28:34 +0300
Message-ID: <CAOQ4uxgteXDU-KF3dEwTi3wrkpDB_if68k+HJM6jtc_kYO6pEQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 23, 2022 at 7:53 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, Jun 23, 2022 at 12:38 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> >
> > On Wed, Jun 22, 2022 at 09:35:19AM -0700, Darrick J. Wong wrote:
> > > On Wed, Jun 22, 2022 at 09:23:07AM -0700, Darrick J. Wong wrote:
> > > > On Thu, Jun 16, 2022 at 11:27:41AM -0700, Leah Rumancik wrote:
> > > > > The patch testing has been increased to 100 runs per test on each
> > > > > config. A baseline without the patches was established with 100 runs
> > > > > to help detect hard failures / tests with a high fail rate. Any
> > > > > failures seen in the backports branch but not in the baseline branch
> > > > > were then run 1000+ times on both the baseline and backport branches
> > > > > and the failure rates compared. The failures seen on the 5.15
> > > > > baseline are listed at
> > > > > https://gist.github.com/lrumancik/5a9d85d2637f878220224578e173fc23.
> > > > > No regressions were seen with these patches.
> > > > >
> > > > > To make the review process easier, I have been coordinating with Amir
> > > > > who has been testing this same set of patches on 5.10. He will be
> > > > > sending out the corresponding 5.10 series shortly.
> > > > >
> > > > > Change log from v1
> > > > > (https://lore.kernel.org/all/20220603184701.3117780-1-leah.rumancik@gmail.com/):
> > > > > - Increased testing
> > > > > - Reduced patch set to overlap with 5.10 patches
> > > > >
> > > > > Thanks,
> > > > > Leah
> > > > >
> > > > > Brian Foster (1):
> > > > >   xfs: punch out data fork delalloc blocks on COW writeback failure
> > > > >
> > > > > Darrick J. Wong (4):
> > > > >   xfs: remove all COW fork extents when remounting readonly
> > > > >   xfs: prevent UAF in xfs_log_item_in_current_chkpt
> > > > >   xfs: only bother with sync_filesystem during readonly remount
> > > >
> > > > 5.15 already has the vfs fixes to make sync_fs/sync_filesystem actually
> > > > return error codes, right?
> > Confirmed "vfs: make sync_filesystem return errors from ->sync_fs" made
> > it into 5.15.y (935745abcf4c695a18b9af3fbe295e322547a114).
>
> Confirmed that it made it into 5.10.y and that
> 2719c7160dcf ("vfs: make freeze_super abort when sync_filesystem returns error")
> also made it to both 5.10.y and 5.15.y

Correcting myself:
All of these vfs fixes are in 5.15.y:

* 2d86293c7075 - (xfs/vfs-5.17-fixes) xfs: return errors in xfs_fs_sync_fs
* dd5532a4994b - quota: make dquot_quota_sync return errors from ->sync_fs
* 5679897eb104 - vfs: make sync_filesystem return errors from ->sync_fs
* 2719c7160dcf - vfs: make freeze_super abort when sync_filesystem returns error

5.10.y has only 2719c7160dcf and dd5532a4994b which applied cleanly
and are outside of the fs/xfs/* AUTOSEL ban.

I have backported the two other patches to 5.10, but I may defer them
and the readonly remount patch to the next submission.

Thanks,
Amir.
