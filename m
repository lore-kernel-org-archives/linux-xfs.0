Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB36C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 18:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B536D60C3D
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 18:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhBASqv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:46:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231152AbhBASqu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 13:46:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E1C564E2E;
        Mon,  1 Feb 2021 18:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612205169;
        bh=NV6mmcGptHnpa4Jav5oSh2gMplWdtaNBJ04g+oH6BvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QoBu5R6Bnyi9V0MyGEII4IpbWIhhGAwP1XmcT+Htnr2hez8cNZB5SzuZCLUOaRbTx
         Nvt2i9CzQqQE/BjAlPbgIRsfk07hPBBuw/S7sKWS1APPZJdXr9eDERdpzJVDvqKVSR
         VEM2lFjnJTfW8UNdnpAbSJo59h3pMnv6R6KeWB7ODeKOYJ7n7aedHPefHBoRdtAq8F
         nNuZCNhZMCB3VGfywu/VjefJ6Ix9YGF5wHdw30b3VYmuVOopFm/4+vOu1VEzSbjtsT
         KZjr4DRfvDiBfVNH7g7Q54fo8rf2JV6h3e8R1+EuXeZML9XWXsfW8qrpW0FuPhNGyv
         5GDcaIVLgqZWA==
Date:   Mon, 1 Feb 2021 10:46:09 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 13/17] xfs: move xfs_qm_vop_chown_reserve to
 xfs_trans_dquot.c
Message-ID: <20210201184609.GE7193@magnolia>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
 <161214510164.139387.1578453347437699937.stgit@magnolia>
 <20210201121730.GB3271714@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201121730.GB3271714@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 12:17:30PM +0000, Christoph Hellwig wrote:
> So looking at what is left of this function after your first patch
> I'd be tempted to just open code it.  Right now it has two callsites
> which either to udqp/gdqp or pdqp, althoug with your late changes
> we're even down to one.  And the current callers kinda duplicate
> the checks in it, I need to look at the new code in a little more
> detail, though.

Yeah.  I've dropped this patch in favor of open-coding a call to
xfs_trans_reserve_quota_bydquots in xfs_trans_alloc_ichange.
