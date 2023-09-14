Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F8AEEAA61
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Sep 2023 18:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjINS0f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Sep 2023 14:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241310AbjINS0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2023 14:26:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D12231BE5
        for <linux-xfs@vger.kernel.org>; Thu, 14 Sep 2023 11:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694715930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3Rems6ec046N1ZDQp4fQVkBqdvBeyNXkrjFUlwXKQBE=;
        b=QoHsjJUDhsyGtKcJjQ3tMND8/FVEz8kkUlngoFew4EhZBE/kB5E3T6ohrKWdU9NloFO0+q
        hqB0W96Z95AxMGg4scCdHME3bIElUUFaUSoTX/yawD6tpksE7Aci9VI+Xvvji/xCwA0Urw
        PtJtozKKk46V1fuL7BgLfb0jzwgB94c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-bvomdskFMZGtfn_vXVXX0Q-1; Thu, 14 Sep 2023 14:25:27 -0400
X-MC-Unique: bvomdskFMZGtfn_vXVXX0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 348FF889062;
        Thu, 14 Sep 2023 18:25:27 +0000 (UTC)
Received: from redhat.com (unknown [10.22.10.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F1BE240C2070;
        Thu, 14 Sep 2023 18:25:26 +0000 (UTC)
Date:   Thu, 14 Sep 2023 13:25:25 -0500
From:   Bill O'Donnell <bodonnel@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs_repair: set aformat and anextents correctly when
 clearing the attr fork
Message-ID: <ZQNQFVG++pD4UkPq@redhat.com>
References: <169454757570.3539425.3597048437340386509.stgit@frogsfrogsfrogs>
 <169454760445.3539425.1849980383287926875.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169454760445.3539425.1849980383287926875.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 12:40:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Ever since commit b42db0860e130 ("xfs: enhance dinode verifier"), we've
> required that inodes with zero di_forkoff must also have di_aformat ==
> EXTENTS and di_naextents == 0.  clear_dinode_attr actually does this,
> but then both callers inexplicably set di_format = LOCAL.  That in turn
> causes a verifier failure the next time the xattrs of that file are
> read by the kernel.  Get rid of the bogus field write.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> ---
>  repair/dinode.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index e534a01b500..c10dd1fa322 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2078,7 +2078,6 @@ process_inode_attr_fork(
>  		if (!no_modify)  {
>  			do_warn(_(", clearing attr fork\n"));
>  			*dirty += clear_dinode_attr(mp, dino, lino);
> -			dino->di_aformat = XFS_DINODE_FMT_LOCAL;
>  			ASSERT(*dirty > 0);
>  		} else  {
>  			do_warn(_(", would clear attr fork\n"));
> @@ -2135,7 +2134,6 @@ process_inode_attr_fork(
>  			/* clear attributes if not done already */
>  			if (!no_modify)  {
>  				*dirty += clear_dinode_attr(mp, dino, lino);
> -				dino->di_aformat = XFS_DINODE_FMT_LOCAL;
>  			} else  {
>  				do_warn(_("would clear attr fork\n"));
>  			}
> 

