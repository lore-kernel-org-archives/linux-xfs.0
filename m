Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37FC9C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 15:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09A6E2250E
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 15:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbhASPDw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 10:03:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390548AbhASOj0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 09:39:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611067079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4X0aSRcZWHASUcoiod1Bmt8ZeZURe34BJDJA1CdM9Ho=;
        b=ItRBXqhyxySvoQ7gAjKAYKacLR1tHrMElPxhaEJmAEL+BhPIqulzrlJ4pKc0d19S9UBM6G
        S9M7GbNo5sjXrCH9lKLf5wCXl6lK7arvX0jfsv+8cmCT4T/rN2GHY7rbOwoDKuYi6kat1l
        8R16yaFZ3J+gST+iwmUlYjSkQNGIKEU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-1LxMpFeSM4OsuV1J6Msi7w-1; Tue, 19 Jan 2021 09:37:57 -0500
X-MC-Unique: 1LxMpFeSM4OsuV1J6Msi7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 825C3801817;
        Tue, 19 Jan 2021 14:37:56 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0844062A25;
        Tue, 19 Jan 2021 14:37:55 +0000 (UTC)
Date:   Tue, 19 Jan 2021 09:37:54 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: clear the needsrepair flag
Message-ID: <20210119143754.GB1646807@bfoster>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
 <161076029319.3386490.2011901341184065451.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161076029319.3386490.2011901341184065451.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 15, 2021 at 05:24:53PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clear the needsrepair flag, since it's used to prevent mounting of an
> inconsistent filesystem.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Code/errors look much cleaner. Though looking at the repair code again,
I wonder... if we clear the needsrepair bit and dirty/write the sb in
phase 2 and then xfs_repair happens to crash, do we risk clearing the
bit and thus allowing a potential mount before whatever requisite
metadata updates have been made?

Brian

>  repair/agheader.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> 
> diff --git a/repair/agheader.c b/repair/agheader.c
> index 8bb99489..d9b72d3a 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -452,6 +452,21 @@ secondary_sb_whack(
>  			rval |= XR_AG_SB_SEC;
>  	}
>  
> +	if (xfs_sb_version_needsrepair(sb)) {
> +		if (!no_modify)
> +			sb->sb_features_incompat &=
> +					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +		if (i == 0) {
> +			if (!no_modify)
> +				do_warn(
> +	_("clearing needsrepair flag and regenerating metadata\n"));
> +			else
> +				do_warn(
> +	_("would clear needsrepair flag and regenerate metadata\n"));
> +		}
> +		rval |= XR_AG_SB_SEC;
> +	}
> +
>  	return(rval);
>  }
>  
> 

