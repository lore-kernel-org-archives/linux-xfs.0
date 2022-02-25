Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C23C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 09:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238194AbiBYJpy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 04:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbiBYJpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 04:45:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4337239D4C
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 01:45:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40B7F60EF1
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 09:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434D4C340E7;
        Fri, 25 Feb 2022 09:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645782321;
        bh=ySWxk8Oce+/6Brr5BRns9wSvVUNNoVYgnQCzyHepk5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BkDshegM+bTlzJd8fquQbud+COpMRtjG2WqOHfcyl5fojeWhm/gSYn6GA7XX5Azvt
         eDgRaF8PJ4NhFDiwuSM7yzONcBgxWKkzP8DuZk0eiUMDrkYQlfZ8PjPjprKnDrBq6h
         pOqBYcJviqhWeKNkoXjFWAsRWy9AJOvDCxo3fUJibKUZiSFZ4xdl6e6xiB8p24tTXH
         L6m3wfS6KPeHPqC1qvdLQB23+LP/jscfVItMpI0vLH/yX32cR1sNlfgnynlcPmVORM
         q6cVGBE2e1ODgfXQ7phKW4kdo5pSe9a2MYpj5t4LOL2gH9+Jeir8urL5t7omFsmPoY
         udV7AJEgLUEug==
Date:   Fri, 25 Feb 2022 10:45:17 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-xfs@vger.kernel.org, christian.brauner@ubuntu.com, hch@lst.de
Subject: Re: [PATCH] xfs: do not clear S_ISUID|S_ISGID for idmapped mounts
Message-ID: <20220225094517.cd7ukcczezhspdq5@wittgenstein>
References: <20220221182218.748084-1-andrey.zhadchenko@virtuozzo.com>
 <20220225015738.GP8313@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220225015738.GP8313@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 24, 2022 at 05:57:38PM -0800, Darrick J. Wong wrote:
> On Mon, Feb 21, 2022 at 09:22:18PM +0300, Andrey Zhadchenko wrote:
> > xfs_fileattr_set() handles idmapped mounts correctly and do not drop this
> > bits.
> > Unfortunately chown syscall results in different callstask:
> > i_op->xfs_vn_setattr()->...->xfs_setattr_nonsize() which checks if process
> > has CAP_FSETID capable in init_user_ns rather than mntns userns.
> > 
> > Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
> 
> LGTM...
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Darrick, could I ask you to please wait with applying.
The correct fix for this is either to simply remove the check here
altogether as we figured out in the thread or to switch to a generic vfs
helper setattr_copy().
Andrey will send a new patch in the not too distant future afaict
including tests.
