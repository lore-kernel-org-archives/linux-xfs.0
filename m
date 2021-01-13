Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C76DC433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 18:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D924D23383
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 18:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbhAMSTX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 13:19:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727254AbhAMSTW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 13:19:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610561876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bGgAbJt6lSQ56oaIt+htgLgBjs3BxKW+c+rP9yG9EXU=;
        b=KOLdVloyfdEnGSFpsuL1U3SHrrD73lveDLY7otIMoCYTEWDIA0YZhrcitNVRuCneX09h1L
        u1Hgrgvx69Gpl0EvpJL3NvCxr6SczW9DUcXzAZLqXm/TyGJnc+F2oLU90Z5FgnH7tao4Ej
        F87xnYDMBEW4J0VuEneUuZV1As2WC6E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-lf070DGdOJWsnSMBkpx8Dg-1; Wed, 13 Jan 2021 13:17:52 -0500
X-MC-Unique: lf070DGdOJWsnSMBkpx8Dg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57719AFA86;
        Wed, 13 Jan 2021 18:17:51 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C5DE45B4CE;
        Wed, 13 Jan 2021 18:17:50 +0000 (UTC)
Date:   Wed, 13 Jan 2021 13:17:49 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_repair: clear the needsrepair flag
Message-ID: <20210113181749.GC1284163@bfoster>
References: <161017367756.1141483.3709627869982359451.stgit@magnolia>
 <161017369673.1141483.6381128502951229066.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161017369673.1141483.6381128502951229066.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 08, 2021 at 10:28:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clear the needsrepair flag, since it's used to prevent mounting of an
> inconsistent filesystem.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  repair/agheader.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> 
> diff --git a/repair/agheader.c b/repair/agheader.c
> index 8bb99489..f6174dbf 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -452,6 +452,17 @@ secondary_sb_whack(
>  			rval |= XR_AG_SB_SEC;
>  	}
>  
> +	if (xfs_sb_version_needsrepair(sb)) {
> +		if (!no_modify)
> +			sb->sb_features_incompat &=
> +					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +		if (!do_bzero) {
> +			rval |= XR_AG_SB;
> +			do_warn(_("needsrepair flag set in sb %d\n"), i);
> +		} else
> +			rval |= XR_AG_SB_SEC;
> +	}
> +

Looks reasonable modulo the questions on the previous patch. When I give
this a test, one thing that stands out is that the needsrepair state
itself sort of presents as corruption. I.e.,

# ./db/xfs_db -x -c "version needsrepair" <dev>
Upgrading V5 filesystem
Upgraded V5 filesystem.  Please run xfs_repair.
versionnum [0xb4a5+0x18a] =
V5,NLINK,DIRV2,ALIGN,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT,CRC,FTYPE,FINOBT,SPARSE_INODES,REFLINK,NEEDSREPAIR
# ./repair/xfs_repair <dev>
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
needsrepair flag set in sb 1
reset bad sb for ag 1
needsrepair flag set in sb 2
reset bad sb for ag 2
needsrepair flag set in sb 0
reset bad sb for ag 0
needsrepair flag set in sb 3
reset bad sb for ag 3
        - found root inode chunk
Phase 3 - for each AG...
...

So nothing was ever done to this fs besides set and clear the bit. Not a
huge deal, but I wonder if we should print something more user friendly
to indicate that repair found and cleared the needsrepair state, or at
least just avoid the "reset bad sb ..." message for the needsrepair
case.

Brian

>  	return(rval);
>  }
>  
> 

