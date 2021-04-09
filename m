Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DEFC433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 17:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD1861106
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 17:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhDIRcm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 13:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234303AbhDIRcl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Apr 2021 13:32:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C498361041;
        Fri,  9 Apr 2021 17:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617989547;
        bh=DgQsAYz7C3D7+7i4uqL4JLN3BiyxKkj6rW+7gpCpDEQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fXe9VAV4uRHbLZLI5WLHd7Sn+uPzQV5zB/fClT1/RDm9lTmbav5+33prfPWqYRw9d
         uKo5F69X1l/o+MYMgBQjzldhJz0F5adse0aYJaQO09zVoiipObuMsBfL/nCxfnzNb9
         m81XjCaL7TtwPCwcQRwGd4QKZAqk0e+f3xYMQn7XygHchZkHVkFPZesY5btZ+xvfM+
         DLuDwCjbKLv9fJQV/apkFIca5YfI0qkg5i4I0pz/5j2EuOGJlL8U3JdEcuAR0d3X54
         5PEvWM3aOCyDb8Rg90BdCx69cjY3lwR7Hc3oETJmZQ6gg6yDYNod8vlTKBHW8AbanT
         2M3I6T61BTfgQ==
Date:   Fri, 9 Apr 2021 10:32:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix return of uninitialized value in variable error
Message-ID: <20210409173227.GH3957620@magnolia>
References: <20210409141834.667163-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409141834.667163-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 09, 2021 at 03:18:34PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> A previous commit removed a call to xfs_attr3_leaf_read that
> assigned an error return code to variable error. We now have
> a few early error return paths to label 'out' that return
> error if error is set; however error now is uninitialized
> so potentially garbage is being returned.  Fix this by setting
> error to zero to restore the original behaviour where error
> was zero at the label 'restart'.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Looks correct to me...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 472b3039eabb..902e5f7e6642 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -928,6 +928,7 @@ xfs_attr_node_addname(
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
>  	 */
> +	error = 0;
>  	retval = xfs_attr_node_hasname(args, &state);
>  	if (retval != -ENOATTR && retval != -EEXIST)
>  		goto out;
> -- 
> 2.30.2
> 
