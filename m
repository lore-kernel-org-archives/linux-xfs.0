Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95214C35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D94C2082F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 15:47:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="rZtO+Qsr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbgBYPrA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 10:47:00 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38663 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730246AbgBYPrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 10:47:00 -0500
Received: by mail-qt1-f196.google.com with SMTP id i23so9332402qtr.5
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2020 07:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jzzR6L46tUOZAhynuJXzNpU9O0uz0Bf0qECc4tNwkIg=;
        b=rZtO+QsrE3oj/5lFyd8Y3/K8ZQ8r1IDNHDwGoDkgnrb/nVLhmTI9e2PI2ohrrbqfM0
         bEAbu6R8+pp0LB650RskEjp8tbYMa6WPYQuDYX85AcR98/GXNnc00u6KaTULY1nh9R02
         h7joh4MOE0qdRwEDRb8TqJ70ug4V87jrId+YRPAX8ueDWb/Ym9MDZ7D/uLar6DDJnzSe
         7gxdHkG/x0RlId4D112NQs3qwtM3pseZOtHu76echkC3TSCquc+1k7kGtLaS9/7E71PE
         N7ZguGElmb+5sB4xm3FmjEV1HJe/460Og7WXc3OiQ7B5Y+gj7L/7F2WlETxYgUl47m+m
         xvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jzzR6L46tUOZAhynuJXzNpU9O0uz0Bf0qECc4tNwkIg=;
        b=sgOTxRsf977otFr9K681bZwJ3zfeENuDnR0cmQCC54jfXpF2WvGJYk5CrLnhK0Apab
         hI4WiItMlul1RPFGkT8x/MHKpH1xZZjblm9c+okkRI5yYlpV8o5Im6ahf9LeRN3jvY4q
         Q/etapsvUUMsxFWqktXRY5vQbicS4zZD724OGWQ9IYl1Y9tlPg+c8qAktcvD+X1AWjEo
         83EDs2wlZpiu+gmplDL97SHjwfjtmPV7y0o4OypWD0OrJaibzdDV+fQaP2ZWn88NHoSb
         bplWDlHwcGgL5LbweXM9UJ4lieKIleKI3A7vkLn5r98MfJOLgLYq9/4lFAnlIj+VxV6v
         HGEg==
X-Gm-Message-State: APjAAAVMGjIqKoZt0HwccIh/0nBanUtceVcy8kNc+/wQ0BnAHfOzv10f
        R2PElaQf3hyuAPWkyWdw94Z3uzJ2cSM=
X-Google-Smtp-Source: APXvYqxMu0HdQd0eLwWSBS5Bck4EomA2B40EfTWaFa15jcXKpXWpGw+8+C9hBtEIoLqlQabr5/n3uA==
X-Received: by 2002:aed:2284:: with SMTP id p4mr53320481qtc.329.1582645619001;
        Tue, 25 Feb 2020 07:46:59 -0800 (PST)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id o55sm7921809qtf.46.2020.02.25.07.46.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Feb 2020 07:46:58 -0800 (PST)
Message-ID: <1582645616.7365.118.camel@lca.pw>
Subject: Re: [PATCH] xfs: fix an undefined behaviour in _da3_path_shift
From:   Qian Cai <cai@lca.pw>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 25 Feb 2020 10:46:56 -0500
In-Reply-To: <20200225152805.GG6740@magnolia>
References: <1582641477-4011-1-git-send-email-cai@lca.pw>
         <20200225152805.GG6740@magnolia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2020-02-25 at 07:28 -0800, Darrick J. Wong wrote:
> On Tue, Feb 25, 2020 at 09:37:57AM -0500, Qian Cai wrote:
> > state->path.active could be 1 in xfs_da3_node_lookup_int() and then in
> > xfs_da3_path_shift() could see state->path.blk[-1].
> 
> Under what circumstancs can it be 1?  Is this a longstanding bug in XFS?
> A corrupted filesystem?  A deliberately corrupted filesystem?

in xfs_da3_node_lookup_int(),

	for (blk = &state->path.blk[0], state->path.active = 1;
			 state->path.active <= XFS_DA_NODE_MAXDEPTH;
			 blk++, state->path.active++) {
<snip>
		if (magic == XFS_ATTR_LEAF_MAGIC ||
		    magic == XFS_ATTR3_LEAF_MAGIC) {
			blk->magic = XFS_ATTR_LEAF_MAGIC;
			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
			break;
		}

		if (magic == XFS_DIR2_LEAFN_MAGIC ||
		    magic == XFS_DIR3_LEAFN_MAGIC) {
			blk->magic = XFS_DIR2_LEAFN_MAGIC;
			blk->hashval = xfs_dir2_leaf_lasthash(args->dp,
							      blk->bp, NULL);
			break;

Isn't that if the first iteration in the loop calls any of those "break", it
will have state->path.active = 1 ?

I suppose this is a long-standing bug that need UBSAN (no obvious harm could be
done later because it will bail out immediately in xfs_da3_path_shift()) and a
set of specific conditions to met to trigger.

> 
> > 
> >  UBSAN: Undefined behaviour in fs/xfs/libxfs/xfs_da_btree.c:1989:14
> >  index -1 is out of range for type 'xfs_da_state_blk_t [5]'
> >  Call trace:
> >   dump_backtrace+0x0/0x2c8
> >   show_stack+0x20/0x2c
> >   dump_stack+0xe8/0x150
> >   __ubsan_handle_out_of_bounds+0xe4/0xfc
> >   xfs_da3_path_shift+0x860/0x86c [xfs]
> >   xfs_da3_node_lookup_int+0x7c8/0x934 [xfs]
> >   xfs_dir2_node_addname+0x2c8/0xcd0 [xfs]
> >   xfs_dir_createname+0x348/0x38c [xfs]
> >   xfs_create+0x6b0/0x8b4 [xfs]
> >   xfs_generic_create+0x12c/0x1f8 [xfs]
> >   xfs_vn_mknod+0x3c/0x4c [xfs]
> >   xfs_vn_create+0x34/0x44 [xfs]
> >   do_last+0xd4c/0x10c8
> >   path_openat+0xbc/0x2f4
> >   do_filp_open+0x74/0xf4
> >   do_sys_openat2+0x98/0x180
> >   __arm64_sys_openat+0xf8/0x170
> >   do_el0_svc+0x170/0x240
> >   el0_sync_handler+0x150/0x250
> >   el0_sync+0x164/0x180
> > 
> > Signed-off-by: Qian Cai <cai@lca.pw>
> > ---
> >  fs/xfs/libxfs/xfs_da_btree.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > index 875e04f82541..0906b7748a3f 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > @@ -1986,7 +1986,11 @@ static inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
> >  	ASSERT(path != NULL);
> >  	ASSERT((path->active > 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
> >  	level = (path->active-1) - 1;	/* skip bottom layer in path */
> > -	for (blk = &path->blk[level]; level >= 0; blk--, level--) {
> > +
> > +	if (level >= 0)
> > +		blk = &path->blk[level];
> 
> ...because if the reason is "corrupt metadata" then perhaps this should
> return -EFSCORRUPTED?  But I don't know enough about the context to know
> the answer to that question.
> 
> --D
> 
> > +
> > +	for (; level >= 0; blk--, level--) {
> >  		xfs_da3_node_hdr_from_disk(dp->i_mount, &nodehdr,
> >  					   blk->bp->b_addr);
> >  
> > -- 
> > 1.8.3.1
> > 
