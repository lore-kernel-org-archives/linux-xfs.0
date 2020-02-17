Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C180C34021
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 18:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04E73207FD
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 18:06:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZKsaypoi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgBQSGF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 13:06:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59794 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726707AbgBQSGF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 13:06:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581962764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WSS4Sxlw5n7hDmXoWjoR2N+JQhCKjC5XqqPU0reRhLo=;
        b=ZKsaypoiEPHFDtGuRU6xXWVCYongntL0t+RkLkbXKSnSl6gBikW+SzjRGO6WbbqTosh4uz
        B0SZBQVjLGPKLGw3Imc9fsvZT1aGtHpRELgxcLN6bNZQCLwc+QEUpKilk9vAcO6052cEHl
        G6Zah6UcGVwqZKngl/gCNHSLfbjPEXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-RxZkqWmFPOCPP32liA5rVg-1; Mon, 17 Feb 2020 13:06:00 -0500
X-MC-Unique: RxZkqWmFPOCPP32liA5rVg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A68D8017CC;
        Mon, 17 Feb 2020 18:05:59 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8DB95C241;
        Mon, 17 Feb 2020 18:05:58 +0000 (UTC)
Date:   Mon, 17 Feb 2020 13:05:57 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: refactor calls to xfs_admin
Message-ID: <20200217180557.GC6633@bfoster>
References: <157915149017.2375135.14166864164575311878.stgit@magnolia>
 <157915149642.2375135.15091840835027007949.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157915149642.2375135.15091840835027007949.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 09:11:36PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a helper to run xfs_admin on the scratch device, then refactor
> all tests to use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks Ok:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/config |    1 +
>  common/xfs    |    8 ++++++++
>  tests/xfs/287 |    2 +-
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/common/config b/common/config
> index 9a9c7760..1116cb99 100644
> --- a/common/config
> +++ b/common/config
> @@ -154,6 +154,7 @@ MKSWAP_PROG="$MKSWAP_PROG -f"
>  export XFS_LOGPRINT_PROG="$(type -P xfs_logprint)"
>  export XFS_REPAIR_PROG="$(type -P xfs_repair)"
>  export XFS_DB_PROG="$(type -P xfs_db)"
> +export XFS_ADMIN_PROG="$(type -P xfs_admin)"
>  export XFS_GROWFS_PROG=$(type -P xfs_growfs)
>  export XFS_SPACEMAN_PROG="$(type -P xfs_spaceman)"
>  export XFS_SCRUB_PROG="$(type -P xfs_scrub)"
> diff --git a/common/xfs b/common/xfs
> index 706ddf85..d9a9784f 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -218,6 +218,14 @@ _scratch_xfs_db()
>  	$XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
>  }
>  
> +_scratch_xfs_admin()
> +{
> +	local options=("$SCRATCH_DEV")
> +	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> +		options+=("$SCRATCH_LOGDEV")
> +	$XFS_ADMIN_PROG "$@" "${options[@]}"
> +}
> +
>  _scratch_xfs_logprint()
>  {
>  	SCRATCH_OPTIONS=""
> diff --git a/tests/xfs/287 b/tests/xfs/287
> index 8dc754a5..f77ed2f1 100755
> --- a/tests/xfs/287
> +++ b/tests/xfs/287
> @@ -70,7 +70,7 @@ $XFS_IO_PROG -r -c "lsproj" $dir/32bit
>  _scratch_unmount
>  
>  # Now, enable projid32bit support by xfs_admin
> -xfs_admin -p $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_admin failed"
> +_scratch_xfs_admin -p >> $seqres.full 2>&1 || _fail "xfs_admin failed"
>  
>  # Now mount the fs, 32bit project quotas shall be supported, now
>  _qmount_option "pquota"
> 

