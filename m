Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B91C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 10:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 729072246B
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 10:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbhAKKy0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 05:54:26 -0500
Received: from verein.lst.de ([213.95.11.211]:50184 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729401AbhAKKyZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 05:54:25 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2323F67373; Mon, 11 Jan 2021 11:53:43 +0100 (CET)
Date:   Mon, 11 Jan 2021 11:53:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 11/12] ext4: simplify i_state checks in
 __ext4_update_other_inode_time()
Message-ID: <20210111105342.GE2502@lst.de>
References: <20210109075903.208222-1-ebiggers@kernel.org> <20210109075903.208222-12-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109075903.208222-12-ebiggers@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 08, 2021 at 11:59:02PM -0800, Eric Biggers wrote:
>  	if ((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
> -			       I_DIRTY_INODE)) ||
> -	    ((inode->i_state & I_DIRTY_TIME) == 0))
> +			       I_DIRTY_TIME)) != I_DIRTY_TIME)
>  		return;
>  
>  	spin_lock(&inode->i_lock);
> -	if (((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
> -				I_DIRTY_INODE)) == 0) &&
> -	    (inode->i_state & I_DIRTY_TIME)) {
> +	if ((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW |
> +			       I_DIRTY_TIME)) == I_DIRTY_TIME) {

I think a descriptively named inline helper in fs.h would really improve
this..
