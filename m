Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E631C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 21:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiFVV3p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 17:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbiFVV3f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 17:29:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA2E13D2E
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 14:29:35 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t3-20020a17090a510300b001ea87ef9a3dso659573pjh.4
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 14:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AwGjaGvVXSVadCIgq4zB3YBGstSxvinSKkJIHUUjDrY=;
        b=MUDbkj++GT38k6KlfACNVPc2RJzZqTHgSJSJt3qOOGd50rqUyAoJu7lxJUXJQo9Gt0
         9qmZ1245jEGQdiTt7Pcw0C43PLgRqLnIl8HxwpLJsziTP/RYkIWG3bWxYBQY9s4oWrN+
         ys7hOdzVpmtHkufcwjUivE0olUgm0Tq8Tgz2eTpb8AygZUEGJnEw+3qvBbtPoAuvpFWw
         Ny7EeecVXbTQCdB60PSRxGSbR65nAutXCkusqJX/Qej2DdYhNUbAqdL5635BhgVBn9EV
         1m65kxGy2gNTxN/mmN22OfLOTHFmguPMP6IMa1d24FQ/Dgzh3+9t3USKfsOgm8q++8R3
         Sy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AwGjaGvVXSVadCIgq4zB3YBGstSxvinSKkJIHUUjDrY=;
        b=zcFsys5wBRIRgQL9/eVulLs02XulgMC7KiKKheUzE3R280BqIaygmnTAfIKiv+agHC
         NBU7cR1ccGLQJQa36Cgv7rCv5QJHxMCVZSyNDu1KUt7NP3h/D8eFbB9H1xq8q8ul2Vxm
         UlA2cRPsveeORU8OOP0v5kQFt2ZQ/em4vEnDjOSudok8oLlJ37aKHHGIIkkKZTyNMS/u
         tbV3Y0kroCGEJN5+y4XP1Pb6tB8WhdkBCOnn+ReBB1IdoytQ3l6uszbhHCpUzzL1CSNi
         FQPrV5DIQeQhcQenxvWOqVQLKwjaPCWo0t2VqccnFyRn9CHf3Ck8b4nHLVqrgtURmXAu
         hQsQ==
X-Gm-Message-State: AJIora/MM13dtxvpjNqXFMrLblJKXdBfWgGTw8g8ir5vbbdfiG45GwP+
        rpFFWpmIjlkmk40R28sOGDzwnUTyHnM=
X-Google-Smtp-Source: AGRyM1tCjTJ++hZIQyYdFfvyyZfgNeDI5ROX2VYexawDSFBfOlDxlugmbJTJIasQTDNd1hSmUfCMuQ==
X-Received: by 2002:a17:90a:6b0d:b0:1ec:93e5:c61b with SMTP id v13-20020a17090a6b0d00b001ec93e5c61bmr380410pjj.189.1655933374278;
        Wed, 22 Jun 2022 14:29:34 -0700 (PDT)
Received: from google.com ([2620:0:1001:7810:1c61:ca22:3ef4:fce9])
        by smtp.gmail.com with ESMTPSA id z28-20020a62d11c000000b0052517150777sm8854559pfg.41.2022.06.22.14.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 14:29:33 -0700 (PDT)
Date:   Wed, 22 Jun 2022 14:29:31 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, mcgrof@kernel.org
Subject: Re: [PATCH 5.15 CANDIDATE v2 0/8] xfs stable candidate patches for
 5.15.y (part 1)
Message-ID: <YrOJu6I5Ui0CGcYr@google.com>
References: <20220616182749.1200971-1-leah.rumancik@gmail.com>
 <YrNB65ISwFDgLT4O@magnolia>
 <YrNExw1XTTD1dJET@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrNExw1XTTD1dJET@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 22, 2022 at 09:35:19AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 22, 2022 at 09:23:07AM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 16, 2022 at 11:27:41AM -0700, Leah Rumancik wrote:
> > > The patch testing has been increased to 100 runs per test on each 
> > > config. A baseline without the patches was established with 100 runs 
> > > to help detect hard failures / tests with a high fail rate. Any 
> > > failures seen in the backports branch but not in the baseline branch 
> > > were then run 1000+ times on both the baseline and backport branches 
> > > and the failure rates compared. The failures seen on the 5.15 
> > > baseline are listed at 
> > > https://gist.github.com/lrumancik/5a9d85d2637f878220224578e173fc23. 
> > > No regressions were seen with these patches.
> > > 
> > > To make the review process easier, I have been coordinating with Amir 
> > > who has been testing this same set of patches on 5.10. He will be 
> > > sending out the corresponding 5.10 series shortly.
> > > 
> > > Change log from v1 
> > > (https://lore.kernel.org/all/20220603184701.3117780-1-leah.rumancik@gmail.com/):
> > > - Increased testing
> > > - Reduced patch set to overlap with 5.10 patches
> > > 
> > > Thanks,
> > > Leah
> > > 
> > > Brian Foster (1):
> > >   xfs: punch out data fork delalloc blocks on COW writeback failure
> > > 
> > > Darrick J. Wong (4):
> > >   xfs: remove all COW fork extents when remounting readonly
> > >   xfs: prevent UAF in xfs_log_item_in_current_chkpt
> > >   xfs: only bother with sync_filesystem during readonly remount
> > 
> > 5.15 already has the vfs fixes to make sync_fs/sync_filesystem actually
> > return error codes, right?
Confirmed "vfs: make sync_filesystem return errors from ->sync_fs" made
it into 5.15.y (935745abcf4c695a18b9af3fbe295e322547a114).

> > 
> > >   xfs: use setattr_copy to set vfs inode attributes
> > > 
> > > Dave Chinner (1):
> > >   xfs: check sb_meta_uuid for dabuf buffer recovery
> > > 
> > > Rustam Kovhaev (1):
> > >   xfs: use kmem_cache_free() for kmem_cache objects
> > > 
> > > Yang Xu (1):
> > >   xfs: Fix the free logic of state in xfs_attr_node_hasname
> > 
> > This one trips me up every time I look at it, but this looks correct.
> > 
> > If the answer to the above question is yes, then:
> > Acked-by: Darrick J. Wong <djwong@kernel.org>
> 
> I should've mentioned that this is acked-by for patches 1-7, since Amir
> posted a question about patch 8 that seems not to have been answered(?)
> 
> (Do all the new setgid inheritance tests actually pass with patch 8
> applied?  The VFS fixes were thorny enough that I'm not as confident
> that they've all been applied to 5.15.y...)

The setgid tests (ex generic/314, generic/444, generic/673, generic/68[3-7],
xfs/019) ran without issues. The dax config did have failures on both the
baseline and backports branch but the other configs all passed cleanly.
There were some changes to these tests since the last time I updated fstests
though so I'll go ahead and rerun this set to be sure.

Best,
Leah

> 
> --D
> 
> > --D
> > 
> > > 
> > >  fs/xfs/libxfs/xfs_attr.c      | 17 +++++------
> > >  fs/xfs/xfs_aops.c             | 15 ++++++++--
> > >  fs/xfs/xfs_buf_item_recover.c |  2 +-
> > >  fs/xfs/xfs_extfree_item.c     |  6 ++--
> > >  fs/xfs/xfs_iops.c             | 56 ++---------------------------------
> > >  fs/xfs/xfs_log_cil.c          |  6 ++--
> > >  fs/xfs/xfs_pnfs.c             |  3 +-
> > >  fs/xfs/xfs_super.c            | 21 +++++++++----
> > >  8 files changed, 47 insertions(+), 79 deletions(-)
> > > 
> > > -- 
> > > 2.36.1.476.g0c4daa206d-goog
> > > 
