Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7848FC43381
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AF7B64D9C
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhBKODi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 09:03:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231293AbhBKOBo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Feb 2021 09:01:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613052006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7hjjFxJO1NIl9P5s05of4Buxt1YHeAXMctK7wzzPMyM=;
        b=dW8yUsbUfc0jpglyZlLou6rhi4NkPuGIHKn2rr1Dxm7XYd0OyBL8Xd7kxxAn8AVeBYJ4qQ
        sUoK4i2kBH3i6vqzt5Fi9A5imcDrDNfCwe+YDXO3zD7MNh/B1ivG4rmr9svYbg1zXqMixt
        la4cnrzLVrxVr1RWvMWMMwM8Sofb9Ig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-fafYZwOuN8qNiC_XwvK2Xw-1; Thu, 11 Feb 2021 09:00:02 -0500
X-MC-Unique: fafYZwOuN8qNiC_XwvK2Xw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92CB7107ACF2;
        Thu, 11 Feb 2021 14:00:00 +0000 (UTC)
Received: from bfoster (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB304E177;
        Thu, 11 Feb 2021 13:59:59 +0000 (UTC)
Date:   Thu, 11 Feb 2021 08:59:58 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/6] common: capture metadump output if xfs filesystem
 check fails
Message-ID: <20210211135958.GB222065@bfoster>
References: <161292577956.3504537.3260962158197387248.stgit@magnolia>
 <161292579087.3504537.10519481439481869013.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161292579087.3504537.10519481439481869013.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 06:56:30PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@djwong.org>
> 
> Capture metadump output when various userspace repair and checker tools
> fail or indicate corruption, to aid in debugging.  We don't bother to
> annotate xfs_check because it's bitrotting.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  README     |    2 ++
>  common/xfs |   26 ++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> 
> diff --git a/README b/README
> index 43bb0cee..36f72088 100644
> --- a/README
> +++ b/README
> @@ -109,6 +109,8 @@ Preparing system for tests:
>               - Set TEST_FS_MODULE_RELOAD=1 to unload the module and reload
>                 it between test invocations.  This assumes that the name of
>                 the module is the same as FSTYP.
> +	     - Set SNAPSHOT_CORRUPT_XFS=1 to record compressed metadumps of XFS
> +	       filesystems if the various stages of _check_xfs_filesystem fail.
>  
>          - or add a case to the switch in common/config assigning
>            these variables based on the hostname of your test
> diff --git a/common/xfs b/common/xfs
> index 2156749d..ad1eb6ee 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -432,6 +432,21 @@ _supports_xfs_scrub()
>  	return 0
>  }
>  
> +# Save a compressed snapshot of a corrupt xfs filesystem for later debugging.
> +_snapshot_xfs() {

The term snapshot has a well known meaning. Can we just call this
_metadump_xfs()?

> +	local metadump="$1"
> +	local device="$2"
> +	local logdev="$3"
> +	local options="-a -o"
> +
> +	if [ "$logdev" != "none" ]; then
> +		options="$options -l $logdev"
> +	fi
> +
> +	$XFS_METADUMP_PROG $options "$device" "$metadump" >> "$seqres.full" 2>&1
> +	gzip -f "$metadump" >> "$seqres.full" 2>&1 &

Why compress in the background? I wonder if we should just skip the
compression step since this requires an option to enable in the first
place..

> +}
> +
>  # run xfs_check and friends on a FS.
>  _check_xfs_filesystem()
>  {
...
> @@ -540,6 +564,8 @@ _check_xfs_filesystem()
>  			cat $tmp.repair				>>$seqres.full
>  			echo "*** end xfs_repair output"	>>$seqres.full
>  
> +			test "$SNAPSHOT_CORRUPT_XFS" = "1" && \
> +				_snapshot_xfs "$seqres.rebuildrepair.md" "$device" "$2"

Why do we collect so many metadump images? Shouldn't all but the last
TEST_XFS_REPAIR_REBUILD thing not modify the fs? If so, it seems like we
should be able to collect one image (and perhaps just call it
"$seqres.$device.md") if any of the first several checks flag a problem.

Brian

>  			ok=0
>  		fi
>  		rm -f $tmp.repair
> 

