Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB32C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 16:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 249C76100C
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 16:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhCaQju (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 12:39:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232109AbhCaQjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 12:39:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617208758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HBCbo4jvPNB5QH2dhZzaC6aPwPTBNtZsFsR4uwQo6GM=;
        b=GdJ1QZvEgZ7fnEaaoi8r4ERsO6zzPMx7zEd3mrzKq6d3wnRj7xfOd/TplT4VdyE/vmz8GM
        0p13vwfGUndJNxnVudttNylPztqoXznyDvNifIwsXg+Fwx2qHxO8MnAYrs3YFhVS/FrZkU
        3+hWHmMn0GeanRpAu7QZVMlJBLcAa6I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-M1hFM7W_NoyT16ZZpdpjhQ-1; Wed, 31 Mar 2021 12:39:15 -0400
X-MC-Unique: M1hFM7W_NoyT16ZZpdpjhQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F45F1966322;
        Wed, 31 Mar 2021 16:39:14 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 180EA50451;
        Wed, 31 Mar 2021 16:39:14 +0000 (UTC)
Date:   Wed, 31 Mar 2021 12:39:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/3] common/xfs: work around a hang-on-stdin bug in
 xfs_admin 5.11
Message-ID: <YGSlsLpZKtXYhV4b@bfoster>
References: <161715288469.2703773.13448230101596914371.stgit@magnolia>
 <161715289578.2703773.11659648563859531836.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161715289578.2703773.11659648563859531836.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 06:08:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_admin in xfsprogs 5.11 has a bug wherein a caller who specifies an
> external log device forces xfs_db to be invoked, potentially with zero
> command arguments.  When this happens, xfs_db will wait for input on
> stdin, which causes fstests to hang.  Since xfs_admin is not an
> interactive tool, redirect stdin from /dev/null to prevent this issue.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/xfs |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 189da54b..c97e08ba 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -277,7 +277,13 @@ _scratch_xfs_admin()
>  			_notrun 'xfs_admin does not support rt devices'
>  		rt_opts+=(-r "$SCRATCH_RTDEV")
>  	fi
> -	$XFS_ADMIN_PROG "${rt_opts[@]}" "$@" "${options[@]}"
> +
> +	# xfs_admin in xfsprogs 5.11 has a bug where an external log device
> +	# forces xfs_db to be invoked, potentially with zero command arguments.
> +	# When this happens, xfs_db will wait for input on stdin, which causes
> +	# fstests to hang.  Since xfs_admin is not an interactive tool, we
> +	# can redirect stdin from /dev/null to prevent this issue.
> +	$XFS_ADMIN_PROG "${rt_opts[@]}" "$@" "${options[@]}" < /dev/null
>  }
>  
>  _scratch_xfs_logprint()
> 

