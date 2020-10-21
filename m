Return-Path: <SRS0=FA9X=D4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5257C388F9
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Oct 2020 14:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79DE420874
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Oct 2020 14:22:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J5tePHhs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442838AbgJUOWp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Oct 2020 10:22:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35775 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437414AbgJUOWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Oct 2020 10:22:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603290163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cVzfsxfYPtWCdtBN3vAsiw7mlOAPTzS3OFx80/jGlU8=;
        b=J5tePHhsfeAqmzB+zPs/tJRcQgUGTzlOP8/HRh3nfGQyj55PHaxR0iXd5rKcgokxZSxd3H
        90txGGKfVnKoS4MVDk6RpFYT4ZSGSNG+nTEpfrYLD1jaAL63lWIl1Y6dDC9LP625EKZiJH
        piGSXlxiMrm/Y3sD4Usq4JCBpxvyF3g=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-3zlfmQ96PkKfqfVbPIra0g-1; Wed, 21 Oct 2020 10:22:41 -0400
X-MC-Unique: 3zlfmQ96PkKfqfVbPIra0g-1
Received: by mail-pj1-f69.google.com with SMTP id gv16so1327926pjb.9
        for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2020 07:22:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cVzfsxfYPtWCdtBN3vAsiw7mlOAPTzS3OFx80/jGlU8=;
        b=LwadJfY6Ed5K2+3c1Wpma9jJlOYGUK/UBM9BO4lYNhycPu4NTXcd+3HgneEzk2aXby
         nyH+NXjO2rBXj+EuWrpMeQk7N1Shu1TMvcnJH8HcEwUZqxlgyeOz8/VTmxARSYIbVphP
         m0lt+ITH9xnQ7BdIxqaGx/kU3jw+A5DRso9dg1nMi0+lpCqTM6MLqTj1eVgXjjSI64eG
         IszCs7Qn1k44+428MbWAC/1jiT1H9RSJe9vn14Eh8sBZpZpw34NriQrGFTzlxGJCSkxh
         IRFSqWdrkO51sTJ1PhYT+4jdAIV2jHOhIdchy5M49HdDfPvG6jUwweqToPoj6vjpCON/
         GrQQ==
X-Gm-Message-State: AOAM532L3ARUkg4JD+PqHnLcpwssPzJVWa0tB7TmUJ4iy/zgUZGWy8iG
        U4KZSSJGDDwnYXo8DZBZT9BQqfFWB2xwNh4G2anUTLVaEONKy5o57nMZ4cdS7E9E0MDNbxhM3X7
        ayGTD94jhHY4rCS0/aLfs
X-Received: by 2002:a17:90a:ce8c:: with SMTP id g12mr3455018pju.185.1603290160663;
        Wed, 21 Oct 2020 07:22:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTx7v+QcqnEqJYZ/YY5/z5Ms8DmnwJuUadaDOKaTTzz0Og83Osk3NPW/aatfLpxBYu7nt/xg==
X-Received: by 2002:a17:90a:ce8c:: with SMTP id g12mr3455005pju.185.1603290160401;
        Wed, 21 Oct 2020 07:22:40 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i9sm2714709pgc.71.2020.10.21.07.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 07:22:39 -0700 (PDT)
Date:   Wed, 21 Oct 2020 22:22:30 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Gao Xiang <hsiangkao@aol.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs: support shrinking unused space in the last AG
Message-ID: <20201021142230.GA30714@xiangao.remote.csb>
References: <20201014005809.6619-1-hsiangkao.ref@aol.com>
 <20201014005809.6619-1-hsiangkao@aol.com>
 <20201014170139.GC1109375@bfoster>
 <20201015014908.GC7037@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20201020145012.GA1272590@bfoster>
 <20201021031922.GA31275@hsiangkao-HP-ZHAN-66-Pro-G1>
 <20201021095519.GA1327166@bfoster>
 <20201021132108.GA25141@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021132108.GA25141@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 21, 2020 at 09:21:08PM +0800, Gao Xiang wrote:
> On Wed, Oct 21, 2020 at 05:55:19AM -0400, Brian Foster wrote:
...
> > > > > > 
> > > > > > Interesting... this seems fundamentally sane when narrowing the scope
> > > > > > down to tail AG shrinking. Does xfs_repair flag any issues in the simple
> > > > > > tail AG shrink case?
> > > > > 
> > > > > Yeah, I ran xfs_repair together as well, For smaller sizes, it seems
> > > > > all fine, but I did observe some failure when much larger values
> > > > > passed in, so as a formal patch, it really needs to be solved later.
> > > > > 
> > > > 
> > > > I'm curious to see what xfs_repair complained about if you have a record
> > > > of it. That might call out some other things we could be overlooking.
> > > 
> > > Sorry for somewhat slow progress...
> > > 
> > > it could show random "SB summary counter sanity check failed" runtime message
> > > when the shrink size is large (much close to ag start).
> > > 
> > 
> > Ok. That error looks associated with a few different checks:
> > 
> >         if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
> >             (sbp->sb_fdblocks > sbp->sb_dblocks ||
> >              !xfs_verify_icount(mp, sbp->sb_icount) ||
> >              sbp->sb_ifree > sbp->sb_icount)) {
> >                 xfs_warn(mp, "SB summary counter sanity check failed");
> >                 return -EFSCORRUPTED;
> >         }
> > 
> > Though I think the inode counters should be a subset of allocated space
> > (i.e. inode chunks) so are unlikely to be impacted by a removal of free
> > space. Without looking into details, I'd guess it's most likely just an
> > accounting bug and it's easiest to dump the relevant values that land in
> > the superblock and work backwards from there. FWIW, the followon
> > shutdown, repair (dirty log) and log recovery behavior (write and read
> > verifier failures) are typical and to be expected on metadata
> > corruption. IOW, I suspect that if we address the write verifier
> > failure, the followon issues will likely be resolved as well.
> 
> After looking into a little bit, the exact failure condition is
> sbp->sb_fdblocks > sbp->sb_dblocks,
> 
> and it seems sbp->sb_fdblocks doesn't decrease as expected when the shrink
> size is large (in fact, it's still the number as the origin compared with
> correct small shrink size) I'm still looking into what's exactly happening.
>

Update: the following incremental patch can fix the issue, yet I'm not sure
if it's the correct way or not...

Thanks,
Gao Xiang

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 80927d323939..0a395901bc3f 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -149,6 +149,14 @@ xfs_growfs_data_private(
                                 nb - mp->m_sb.sb_dblocks);
        if (id.nfree)
                xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
+
+       /*
+        * update in-core counters (especially sb_fdblocks) now
+        * so xfs_validate_sb_write() can pass.
+        */
+       if (xfs_sb_version_haslazysbcount(&mp->m_sb))
+               xfs_log_sb(tp);
+
        xfs_trans_set_sync(tp);
        error = xfs_trans_commit(tp);
        if (error)


 

