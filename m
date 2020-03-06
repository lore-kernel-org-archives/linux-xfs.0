Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C13C3F2D6
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 09:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DE362073D
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 09:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="InemRz9j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgCFJm3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 04:42:29 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28708 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726034AbgCFJm3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 04:42:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583487748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l0d0g91HPcpg558zU9/GKdXR7kMeesNnYit/W41+dFI=;
        b=InemRz9jOzagHWOWthPU6oMjHOUk8jEuv8S1gug3g8qGUEJjxKdHwbUCdUirhCzHKWLPX+
        Toopbj/nis10h4Lb0xrmQVopJdKrAdbO3O/Dekagwq6tWeVESzZqicC+LlqoAcgxlD05t+
        ycb07uBG6AidY7XyQDWihKz1Tkpch08=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-Ts9sMYUVORG7LJcbl7x42w-1; Fri, 06 Mar 2020 04:42:26 -0500
X-MC-Unique: Ts9sMYUVORG7LJcbl7x42w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D83B6100550D;
        Fri,  6 Mar 2020 09:42:25 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E20510016EB;
        Fri,  6 Mar 2020 09:42:25 +0000 (UTC)
Date:   Fri, 6 Mar 2020 17:53:14 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: refactor calls to xfs_admin
Message-ID: <20200306095314.GY14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <158328998787.2374922.4223951558305234252.stgit@magnolia>
 <158329000059.2374922.2321079684090223330.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158329000059.2374922.2321079684090223330.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 03, 2020 at 06:46:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a helper to run xfs_admin on the scratch device, then refactor
> all tests to use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---



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

Looks good to me.

Althought on old xfs_admin doesn't external log device, this test fails if we
use SCRATCH_LOGDEV and USE_EXTERNAL=yes, it's fine for me.

Reviewd-by: Zorro Lang <zlang@redhat.com>

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

