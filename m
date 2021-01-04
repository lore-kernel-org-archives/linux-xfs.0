Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FE6C433DB
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 17:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5D9C224DE
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Jan 2021 17:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbhADRJr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:09:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726098AbhADRJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Jan 2021 12:09:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609780100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RzeDgRDpSZ288RwSjcHTQSGtRUomGL0q+nMVShqbDvc=;
        b=LieJano/kZyzjqSDtIvYfiF62ZrkPAcS1ILpFumwuVXsd3rzv2kNtQM+73jjAz7tECGLv9
        JFhPr9TmDGx/VvvsufF/ISVOkDnEaPuuGt624tYBh1h+XPRwd136usUek+xNrWkI1cJ9ue
        MnCyCkDTwPlwsTjJyMbN7I4L0qZjRmo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-_aMrFbwkMwSwykB6_AUJEg-1; Mon, 04 Jan 2021 12:08:18 -0500
X-MC-Unique: _aMrFbwkMwSwykB6_AUJEg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D93B919251A0;
        Mon,  4 Jan 2021 17:08:17 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BB5262461;
        Mon,  4 Jan 2021 17:08:17 +0000 (UTC)
Date:   Mon, 4 Jan 2021 12:08:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "L.A. Walsh" <xfs@tlinx.org>
Cc:     xfs-oss <linux-xfs@vger.kernel.org>
Subject: Re: suggested patch to allow user to access their own file...
Message-ID: <20210104170815.GB254939@bfoster>
References: <5FEB204B.9090109@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FEB204B.9090109@tlinx.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 29, 2020 at 04:25:47AM -0800, L.A. Walsh wrote:
> xfs_io checks for CAP_SYS_ADMIN in order to open a
> file_by_inode -- however, if the file one is opening
> is owned by the user performing the call, the call should
> not fail.
> 
> (i.e. it opens the user's own file).
> 
> patch against 5.10.2 is attached.
> 
> It gets rid of some unnecessary error messages if you
> run xfs_restore to restore one of your own files.
> 

The current logic seems to go a ways back. Can you or somebody elaborate
on whether there's any risks with loosening the permissions as such?
E.g., any reason we might not want to allow regular users to perform
handle lookups, etc.? If not, should some of the other _by_handle() ops
get similar treatment?

> --- fs/xfs/xfs_ioctl.c	2020-12-22 21:11:02.000000000 -0800
> +++ fs/xfs/xfs_ioctl.c	2020-12-29 04:14:48.681102804 -0800
> @@ -194,15 +194,21 @@
>  	struct dentry		*dentry;
>  	fmode_t			fmode;
>  	struct path		path;
> +	bool conditional_perm = 0;

Variable name alignment and I believe we try to use true/false for
boolean values.

>  
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EPERM;
> +	if (!capable(CAP_SYS_ADMIN)) conditional_perm=1;

This should remain two lines..

>  
>  	dentry = xfs_handlereq_to_dentry(parfilp, hreq);
>  	if (IS_ERR(dentry))
>  		return PTR_ERR(dentry);
>  	inode = d_inode(dentry);
>  
> +	/* only allow user access to their own file */
> +	if (conditional_perm && !inode_owner_or_capable(inode)) {
> +		error = -EPERM;
> +		goto out_dput;
> +	}
> +

... but then again, is there any reason we couldn't just move the
capable() check down to this hunk and avoid the new variable?

Brian

>  	/* Restrict xfs_open_by_handle to directories & regular files. */
>  	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))) {
>  		error = -EPERM;

