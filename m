Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62A90C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 169BF64E5A
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 17:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhBIRVd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 12:21:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232912AbhBIRVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 12:21:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612891205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y/Nvxyh5eV8y01vtjk7yk6YW4Yfvey4fgk2wAI+1ZKU=;
        b=DhfPsr0u7d1tVeGCghbmgator/1i+UxtuST+XnJ3qVyHZw5oXjKJ9+7VUJ9nZ7GE3GsILo
        dHoCVTufK5AehoZBtG1JgOaC6IJuJ7O4LJwcN3kYd31NCTWdKbME1wduGzb2f9VoePOhIR
        5o1jWzR9S+OoRU757yCs97Mq1PmfiS4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-6xiet4a7O-S2bn1L11DxSg-1; Tue, 09 Feb 2021 12:20:03 -0500
X-MC-Unique: 6xiet4a7O-S2bn1L11DxSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17C79803F4F;
        Tue,  9 Feb 2021 17:20:02 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 998E260CE0;
        Tue,  9 Feb 2021 17:20:01 +0000 (UTC)
Date:   Tue, 9 Feb 2021 12:19:59 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs_db: support the needsrepair feature flag in
 the version command
Message-ID: <20210209171959.GB14273@bfoster>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284382116.3057868.4021834592988203500.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284382116.3057868.4021834592988203500.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:10:21PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach the xfs_db version command about the 'needsrepair' flag, which can
> be used to force the system administrator to repair the filesystem with
> xfs_repair.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/check.c |    5 +++++
>  db/sb.c    |   13 +++++++++++++
>  2 files changed, 18 insertions(+)
> 
> 
> diff --git a/db/check.c b/db/check.c
> index 33736e33..485e855e 100644
> --- a/db/check.c
> +++ b/db/check.c
> @@ -3970,6 +3970,11 @@ scan_ag(
>  			dbprintf(_("mkfs not completed successfully\n"));
>  		error++;
>  	}
> +	if (xfs_sb_version_needsrepair(sb)) {
> +		if (!sflag)
> +			dbprintf(_("filesystem needs xfs_repair\n"));
> +		error++;
> +	}
>  	set_dbmap(agno, XFS_SB_BLOCK(mp), 1, DBM_SB, agno, XFS_SB_BLOCK(mp));
>  	if (sb->sb_logstart && XFS_FSB_TO_AGNO(mp, sb->sb_logstart) == agno)
>  		set_dbmap(agno, XFS_FSB_TO_AGBNO(mp, sb->sb_logstart),
> diff --git a/db/sb.c b/db/sb.c
> index d09f653d..cec7dce9 100644
> --- a/db/sb.c
> +++ b/db/sb.c
> @@ -379,6 +379,11 @@ uuid_f(
>  				progname);
>  			return 0;
>  		}
> +		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> +			dbprintf(_("%s: filesystem needs xfs_repair\n"),
> +				progname);
> +			return 0;
> +		}
>  
>  		if (!strcasecmp(argv[1], "generate")) {
>  			platform_uuid_generate(&uu);
> @@ -543,6 +548,12 @@ label_f(
>  			return 0;
>  		}
>  
> +		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
> +			dbprintf(_("%s: filesystem needs xfs_repair\n"),
> +				progname);
> +			return 0;
> +		}
> +
>  		dbprintf(_("writing all SBs\n"));
>  		for (ag = 0; ag < mp->m_sb.sb_agcount; ag++)
>  			if ((p = do_label(ag, argv[1])) == NULL) {
> @@ -691,6 +702,8 @@ version_string(
>  		strcat(s, ",INOBTCNT");
>  	if (xfs_sb_version_hasbigtime(sbp))
>  		strcat(s, ",BIGTIME");
> +	if (xfs_sb_version_needsrepair(sbp))
> +		strcat(s, ",NEEDSREPAIR");
>  	return s;
>  }
>  
> 

