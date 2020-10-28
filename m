Return-Path: <SRS0=iKFT=ED=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9BEC4363A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 22:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CDB620714
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Oct 2020 22:29:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jM0gcn9f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387615AbgJ1W3j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:29:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387610AbgJ1W3g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 18:29:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603924175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1a+Od4sgTvDB5zz3kdJ/uyuyxltSAMB2cl/27cor0V0=;
        b=jM0gcn9f+eyDPj/7rokDItLcD2cHleqldWJh5nmlnfQD3CfgsD6WaiSTbuGTmI4cN0hQIw
        H3EVE09uR7Y6HRfNvloEMIIwVqgGzIFCP397gTSMDPl6GJfOZPyCh1ay4sNmOPDiP7hM28
        t/Vb3sgOqCoFTiiPWcneM84eFHf8EdI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-7b3VsgAuOciUUhWNrlr0Sw-1; Wed, 28 Oct 2020 13:29:02 -0400
X-MC-Unique: 7b3VsgAuOciUUhWNrlr0Sw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC2B5108E1B0;
        Wed, 28 Oct 2020 17:29:01 +0000 (UTC)
Received: from bfoster (ovpn-113-186.rdu2.redhat.com [10.10.113.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2829F5C1D0;
        Wed, 28 Oct 2020 17:29:01 +0000 (UTC)
Date:   Wed, 28 Oct 2020 13:28:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs_db: support displaying inode btree block counts
 in AGI header
Message-ID: <20201028172859.GC1611922@bfoster>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375521177.880355.5574700800853381205.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375521177.880355.5574700800853381205.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:33:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix up xfs_db to support displaying the btree block counts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/agi.c |    2 ++
>  db/sb.c  |    2 ++
>  2 files changed, 4 insertions(+)
> 
> 
> diff --git a/db/agi.c b/db/agi.c
> index bf21b2d40f04..cfb4f7b8528a 100644
> --- a/db/agi.c
> +++ b/db/agi.c
> @@ -48,6 +48,8 @@ const field_t	agi_flds[] = {
>  	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
>  	{ "free_root", FLDT_AGBLOCK, OI(OFF(free_root)), C1, 0, TYP_FINOBT },
>  	{ "free_level", FLDT_UINT32D, OI(OFF(free_level)), C1, 0, TYP_NONE },
> +	{ "ino_blocks", FLDT_UINT32D, OI(OFF(iblocks)), C1, 0, TYP_NONE },
> +	{ "fino_blocks", FLDT_UINT32D, OI(OFF(fblocks)), C1, 0, TYP_NONE },
>  	{ NULL }
>  };
>  
> diff --git a/db/sb.c b/db/sb.c
> index 8a303422b427..e3b1fe0b2e6e 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -687,6 +687,8 @@ version_string(
>  		strcat(s, ",RMAPBT");
>  	if (xfs_sb_version_hasreflink(sbp))
>  		strcat(s, ",REFLINK");
> +	if (xfs_sb_version_hasinobtcounts(sbp))
> +		strcat(s, ",INOBTCNT");
>  	return s;
>  }
>  
> 

