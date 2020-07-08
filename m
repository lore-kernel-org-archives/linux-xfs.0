Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA60C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 12:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 929AD20720
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 12:42:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RVrzy58r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgGHMmQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:42:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31727 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728803AbgGHMmQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 08:42:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594212135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=seVLlmPeKZN8mXaTPo00K+QMni7ieNnhIGb9PuA9DC8=;
        b=RVrzy58rhEK4rYNoCbnun3vHQncYPBYb3Q458Yd5XDUQ+2UfOfCeL8RsjtK2FdPRkERIVz
        gy+Oge8DQ9wbWb2DBhHN+qw6AwWTRhwZYGkfMAC4jaEQZYmRIHLsigL6D7Vy6rlrni1/Zy
        WtLT8JMts+d0dSNxtE7mWs9QL9cNFKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-sYXzhx52PkeJOH1s7aDGFQ-1; Wed, 08 Jul 2020 08:42:12 -0400
X-MC-Unique: sYXzhx52PkeJOH1s7aDGFQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 197E519253C3;
        Wed,  8 Jul 2020 12:42:11 +0000 (UTC)
Received: from bfoster (ovpn-112-122.rdu2.redhat.com [10.10.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B539C1002388;
        Wed,  8 Jul 2020 12:42:10 +0000 (UTC)
Date:   Wed, 8 Jul 2020 08:42:08 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v10 14/25] xfs: Remove xfs_trans_roll in
 xfs_attr_node_removename
Message-ID: <20200708124208.GB53550@bfoster>
References: <20200625233018.14585-1-allison.henderson@oracle.com>
 <20200625233018.14585-15-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625233018.14585-15-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25, 2020 at 04:30:07PM -0700, Allison Collins wrote:
> The xfs_trans_roll in _removename is not needed because invalidating
> blocks is an incore-only change.  This is analogous to the non-remote
> remove case where an entry is removed and a potential dabtree join
> occurs under the same transaction.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

Ok, but I think we should be a bit more descriptive in the commit log so
the reasoning is available for historical reference. For example:

"A transaction roll is not necessary immediately after setting the
INCOMPLETE flag when removing a node xattr entry with remote value
blocks. The remote block invalidation that immediately follows setting
the flag is an in-core only change. The next step after that is to start
unmapping the remote blocks from the attr fork, but the xattr remove
transaction reservation includes reservation for full tree splits of the
dabtree and bmap tree. The remote block unmap code will roll the
transaction as extents are unmapped and freed."

With something like that in place:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1a78023..f1becca 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1148,10 +1148,6 @@ xfs_attr_node_removename(
>  		if (error)
>  			goto out;
>  
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			goto out;
> -
>  		error = xfs_attr_rmtval_invalidate(args);
>  		if (error)
>  			return error;
> -- 
> 2.7.4
> 

