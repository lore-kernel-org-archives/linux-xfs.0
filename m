Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED893C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 17:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF0E864E0A
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 17:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbhBDRz2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 12:55:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238669AbhBDRzR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 12:55:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612461227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ui4aqfVARo0fmk7uDbyi3TMp7mU2gObkpleRWBT6nDQ=;
        b=C3VDaccn7IBJEplyL+IzB8Qfkfd1530sCSiKC6BHT4L+Fm0zEM3+6KTmhJaMA4ZFfxoGND
        nz/JypHQaOIXCL/nd9BdoIsMGks03tnJWFT+n3lrPtSLdjYNyBxF8c/iHsGJyX6diKqHxK
        miCfOCmqXOhuyhyHXQKyiy9EldoUxD0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-i9YiZbQMMZueaBgQZhV8qQ-1; Thu, 04 Feb 2021 12:53:43 -0500
X-MC-Unique: i9YiZbQMMZueaBgQZhV8qQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 882B71005501;
        Thu,  4 Feb 2021 17:53:42 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 17E5E5D6D7;
        Thu,  4 Feb 2021 17:53:42 +0000 (UTC)
Date:   Thu, 4 Feb 2021 12:53:40 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_admin: clean up string quoting
Message-ID: <20210204175340.GA3721376@bfoster>
References: <161238139177.1278306.5915396345874239435.stgit@magnolia>
 <161238139753.1278306.12571924344581175091.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161238139753.1278306.12571924344581175091.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 11:43:17AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clean up the string quoting in this script so that we don't trip over
> users feeding us arguments like "/dev/sd ha ha ha lol".
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  db/xfs_admin.sh |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index bd325da2..71a9aa98 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -43,7 +43,7 @@ case $# in
>  
>  		if [ -n "$DB_OPTS" ]
>  		then
> -			eval xfs_db -x -p xfs_admin $DB_OPTS $1
> +			eval xfs_db -x -p xfs_admin $DB_OPTS "$1"
>  			status=$?
>  		fi
>  		if [ -n "$REPAIR_OPTS" ]
> @@ -53,7 +53,7 @@ case $# in
>  			# running xfs_admin.
>  			# Ideally, we need to improve the output behaviour
>  			# of repair for this purpose (say a "quiet" mode).
> -			eval xfs_repair $REPAIR_OPTS $1 2> /dev/null
> +			eval xfs_repair $REPAIR_OPTS "$1" 2> /dev/null
>  			status=`expr $? + $status`
>  			if [ $status -ne 0 ]
>  			then
> 

