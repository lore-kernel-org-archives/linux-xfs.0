Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39115C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 18:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED59E64EA0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 18:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhBAS22 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:28:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232813AbhBAS2Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 13:28:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECAB564EA1;
        Mon,  1 Feb 2021 18:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612204064;
        bh=0SPHpD3StofXv0KY4XjnUsparE1lw/vjcIs83H0vekc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HTCemX85d7mj9gfjba2Sr66V6JgGFjg8jvQQDlVMZfjtcil8q1LCr3IMeMEQ5Piqv
         q8shDUJHZ7bECaFx7PxhWKLXQeRAlVMgNun2TyEJszQzWePjtzTRRnHmD0qcWloghW
         +TMlvHW5SOe393p6Bv/86Qe++8bSdU6fwzP+jAL3xJpUvBk2GghPnjSZuxwf3MUcb6
         0AcVQF9ru5A3dGVc3ezqFWeZf1QjgxQ3pwfzHiBTX3cg5g67g4qt608juBt9q4Q52y
         6byaCx7EwY6SyY/rtuvhcyUf7Pp3QCZxrxVfC976pavpQ4zHCVXyvE81IyMf1ojPiT
         tY+GttF3zSaVg==
Date:   Mon, 1 Feb 2021 10:27:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Subject: Re: [PATCH 14/17] xfs: clean up xfs_trans_reserve_quota_chown a bit
Message-ID: <20210201182743.GC7193@magnolia>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
 <161214510730.139387.4000977461727812094.stgit@magnolia>
 <20210201121834.GC3271714@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210201121834.GC3271714@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 12:18:34PM +0000, Christoph Hellwig wrote:
> >  
> >  	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
> >  	    i_uid_read(VFS_I(ip)) != udqp->q_id)
> > -		udq_delblks = udqp;
> > +		new_udqp = udqp;
> 
> We don't even need two variables for each type, instead we can just
> clear the original pointer to NULL if the conditions aren't met.

Once I've made xfs_trans_alloc_ichange the only caller of
xfs_trans_reserve_quota_chown, I think we could get rid of these checks
entirely, since there ought to be a 1:1 correspondence between (i_udquot
== new_udqp) and (i_uid_read(VFS_I(ip)) == new_udqp->q_id), if the
caller even passed in a new_udqp.

Though... if I take your (later) suggestion to move the call to
xfs_trans_reserve_quota_bydquots into xfs_trans_alloc_ichange, then it
makes more sense to drop all these patches.

--D

