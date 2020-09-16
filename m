Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFCBC433E2
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E13421D90
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 20:40:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EPPtWrG6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgIPUkF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:40:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726803AbgIPRGN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 13:06:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600275962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sxawlgz87adndHvu34+9iWnaxmw0uAi2OWjOyCN0ATg=;
        b=EPPtWrG63SHMLi76DlelLOtz7NluBM0mwOPXQzyhV9w+siV18Eyui2LcTT2Mkd/+PMWE1s
        EPV7qGWDtsD9R0Ul9z7aU2RXX30Ccnq/39vdKkSKSyEctm7pXziJVT6+F5X9xc0ry3Z15q
        mDdFH5oRzmyYp/gedzL7ngaOqBNEtnk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-swFOcsk0P1KrfmtfgL4amw-1; Wed, 16 Sep 2020 07:27:43 -0400
X-MC-Unique: swFOcsk0P1KrfmtfgL4amw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFF158030BD;
        Wed, 16 Sep 2020 11:27:42 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38C975FC36;
        Wed, 16 Sep 2020 11:27:41 +0000 (UTC)
Date:   Wed, 16 Sep 2020 19:41:41 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 18/24] xfs/291: fix open-coded repair call to mdrestore'd
 fs image
Message-ID: <20200916114141.GI2937@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013429012.2923511.7187414322832672163.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013429012.2923511.7187414322832672163.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:44:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Attach any external log devices to the open-coded repair call.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/291 |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/291 b/tests/xfs/291
> index adef2536..5d4f1ac4 100755
> --- a/tests/xfs/291
> +++ b/tests/xfs/291
> @@ -110,7 +110,9 @@ _scratch_metadump $tmp.metadump || _fail "xfs_metadump failed"
>  xfs_mdrestore $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
>  [ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && \
>  	rt_repair_opts="-r $SCRATCH_RTDEV"
> -$XFS_REPAIR_PROG $rt_repair_opts -f $tmp.img >> $seqres.full 2>&1 || \
> +[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_LOGDEV" ] && \
> +	log_repair_opts="-l $SCRATCH_LOGDEV"
> +$XFS_REPAIR_PROG $rt_repair_opts $log_repair_opts -f $tmp.img >> $seqres.full 2>&1 || \
>  	_fail "xfs_repair of metadump failed"
>  
>  # Yes it can; success, all done
> 

