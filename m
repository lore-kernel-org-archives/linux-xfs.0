Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9402C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75EB364EF5
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 22:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235344AbhBXWdT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 17:33:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53582 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235342AbhBXWdR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 17:33:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614205911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cFTPnKxlBzNxKvGSiO/h2YQzjVgKam7YECE6hGFGUcE=;
        b=UDTeAXPk9LIjFvGhCh26GMRf0AWoWy4E+2vTulkdn9c/x9IHVFLd4ZVpSzlF1ps2PeYmKe
        yT5eNBLgXoVanz0Y/XHcKKE+fGTx+N+f/RgKvxkAl9oLIHzWy7FJjrkbt9Ti55lxKP+TRc
        EBv/OIwla5bPx3ZfADiyT5tPbi0vPuU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-g7v272iFPpKi1X58DRsYbw-1; Wed, 24 Feb 2021 17:31:49 -0500
X-MC-Unique: g7v272iFPpKi1X58DRsYbw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D053C1935780;
        Wed, 24 Feb 2021 22:31:48 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93E6062460;
        Wed, 24 Feb 2021 22:31:48 +0000 (UTC)
Subject: Re: [PATCH] man: document XFS_XFLAG_APPEND behavior for directories
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20210224222913.GF7272@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <cfaa010e-d348-7639-e680-7e7cbc8bfa77@redhat.com>
Date:   Wed, 24 Feb 2021 16:31:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210224222913.GF7272@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/24/21 4:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For directories, the APPEND flag means that files cannot be unlinked
> from the directory.  Files can be linked in or created, just not
> unlinked.  Document this behavior, since it's been in the VFS for years
> though not explicitly mentioned.  This patch is in preparation for
> trying to hoist the fsgetxattr ioctl documentation to the man-pages
> project.

sounds good.

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man2/ioctl_xfs_fsgetxattr.2 |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
> index e2cbfca3..2c626a7e 100644
> --- a/man/man2/ioctl_xfs_fsgetxattr.2
> +++ b/man/man2/ioctl_xfs_fsgetxattr.2
> @@ -104,6 +104,7 @@ will be returned.
>  .B XFS_XFLAG_APPEND
>  The file is append-only - it can only be opened in append mode for
>  writing.
> +For directories, this means that files cannot be unlinked from this directory.
>  Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
>  capability can set or clear this flag.
>  .TP
> 

