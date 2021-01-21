Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7989FC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 20:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36C9123A56
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 20:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbhAUUAW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 15:00:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28475 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726533AbhAUUAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 15:00:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611259129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S97i6C/rmHOY7co2zGc5iztRw+fgKvtpyG/eEee82jc=;
        b=bH7NFdW+nS1Vvim7V84PSH17icTpgFc1aWHLu20sv/h1T6jxcYHPzha4SfIsYMuzdN4CDe
        wMNx2AdJllG1+XVr0B4shH5FjeZWDDGPbnPXC0nziknXOaWm7o0KppkNCZZZO25+NR9BMO
        dnMl3ApP7Q/feNpk/lPbReUCvaAo3ic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-30ztVgtON1KTodTJEFfTvA-1; Thu, 21 Jan 2021 14:58:47 -0500
X-MC-Unique: 30ztVgtON1KTodTJEFfTvA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A942B801817;
        Thu, 21 Jan 2021 19:58:45 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F58560BF3;
        Thu, 21 Jan 2021 19:58:45 +0000 (UTC)
Date:   Thu, 21 Jan 2021 14:58:43 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
Cc:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: set inode size after creating symlink
Message-ID: <20210121195843.GD1793795@bfoster>
References: <20210121151912.4429-1-jeffrey.mitchell@starlab.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121151912.4429-1-jeffrey.mitchell@starlab.io>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 21, 2021 at 09:19:12AM -0600, Jeffrey Mitchell wrote:
> When XFS creates a new symlink, it writes its size to disk but not to the
> VFS inode. This causes i_size_read() to return 0 for that symlink until
> it is re-read from disk, for example when the system is rebooted.
> 
> I found this inconsistency while protecting directories with eCryptFS.
> The command "stat path/to/symlink/in/ecryptfs" will report "Size: 0" if
> the symlink was created after the last reboot on an XFS root.
> 
> Call i_size_write() in xfs_symlink()
> 
> Signed-off-by: Jeffrey Mitchell <jeffrey.mitchell@starlab.io>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_symlink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 1f43fd7f3209..c835827ae389 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -300,6 +300,7 @@ xfs_symlink(
>  		}
>  		ASSERT(pathlen == 0);
>  	}
> +	i_size_write(VFS_I(ip), ip->i_d.di_size);
>  
>  	/*
>  	 * Create the directory entry for the symlink.
> -- 
> 2.25.1
> 

