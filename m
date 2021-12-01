Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E572C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Dec 2021 16:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351658AbhLAQsc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Dec 2021 11:48:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351517AbhLAQqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Dec 2021 11:46:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638376975;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fuWponqes6VhO075r7aSGZGmq+5KvEV3psFaKe37cZg=;
        b=gqqBsL1VBhACUzBhyIqlUfOTWMXxujSICBR8pAbGNlSRE+ob825SMuEarbjA4QfsD+FuoT
        XNDx5z2Qsh4Oh6FDxYtuSyn2rsWtD3njeBW3PDNNTEpQTvBMyEvf6lkRdrI6U4mrUoaCPW
        0dl4LSEa0lqO6krhHUwOYtkNhHLwwSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-415-9FgcmBxUN9K7gXOkCmFwrA-1; Wed, 01 Dec 2021 11:42:52 -0500
X-MC-Unique: 9FgcmBxUN9K7gXOkCmFwrA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8193681CCBF;
        Wed,  1 Dec 2021 16:42:51 +0000 (UTC)
Received: from [127.0.0.1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CEAA4EC37;
        Wed,  1 Dec 2021 16:42:51 +0000 (UTC)
Message-ID: <2106770b-5977-47b6-8b91-22b829cc5bf7@redhat.com>
Date:   Wed, 1 Dec 2021 10:42:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH] xfs: remove incorrect ASSERT in xfs_rename
Content-Language: en-US
From:   Eric Sandeen <esandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>
References: <bbb4b6d5-744c-11c8-fcda-62777e8d7b19@redhat.com>
Reply-To: sandeen@redhat.com
In-Reply-To: <bbb4b6d5-744c-11c8-fcda-62777e8d7b19@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/30/21 11:17 PM, Eric Sandeen wrote:
> This ASSERT in xfs_rename is a) incorrect, because
> (RENAME_WHITEOUT|RENAME_NOREPLACE) is a valid combination, and
> b) unnecessary, because actual invalid flag combinations are already
> handled at the vfs level in do_renameat2() before we get called.
> So, remove it.
> 
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 64b9bf3..6771f35 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3122,7 +3122,6 @@ struct xfs_iunlink {
>        * appropriately.
>        */
>       if (flags & RENAME_WHITEOUT) {
> -        ASSERT(!(flags & (RENAME_NOREPLACE | RENAME_EXCHANGE)));
>           error = xfs_rename_alloc_whiteout(mnt_userns, target_dp, &wip);
>           if (error)
>               return error;
> 

Ugh, I don't understand this flavor of whitespace mangling I'm getting now,
I'm sorry :(

