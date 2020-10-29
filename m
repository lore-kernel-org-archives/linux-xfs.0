Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AE5C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 17:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6C862076D
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 17:39:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YVFDNG2Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgJ2Rj1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 13:39:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725849AbgJ2Rj1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 13:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603993166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=za4qqp11aWu/+2AHNdYdKBHeaC7lyDiORvL8Yt9mnTM=;
        b=YVFDNG2Zzf7Gi3oEDravLKgC9bmFuOpoyPtPaOpVwlvAEizRTVCGdHd+vs2Jv6G/2WSr0n
        x92RLqsNMahh3+Ur4kmJnMFRTkCtYHWkFaRGPvwjh0zKHyZxPMDqcOfzBg6Roq64ZFyC/p
        zfwg+m6GPfUmOmjl6EdnAQJsOrFwnk8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-nLFS-62lPFqMZb_PEUhmHg-1; Thu, 29 Oct 2020 13:39:24 -0400
X-MC-Unique: nLFS-62lPFqMZb_PEUhmHg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1065764159;
        Thu, 29 Oct 2020 17:39:23 +0000 (UTC)
Received: from bfoster (ovpn-113-186.rdu2.redhat.com [10.10.113.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EEB8614F5;
        Thu, 29 Oct 2020 17:39:22 +0000 (UTC)
Date:   Thu, 29 Oct 2020 13:39:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/122: embiggen struct xfs_agi size for inobtcount
 feature
Message-ID: <20201029173920.GB1660404@bfoster>
References: <160382541643.1203756.12015378093281554469.stgit@magnolia>
 <160382542261.1203756.6377970904886103725.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382542261.1203756.6377970904886103725.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:03:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make the expected AGI size larger for the inobtcount feature.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

It would be nice for the commit log to have a sentence or two about the
other changes as well, but either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/xfs/010     |    3 ++-
>  tests/xfs/030     |    2 ++
>  tests/xfs/122.out |    2 +-
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tests/xfs/010 b/tests/xfs/010
> index 1f9bcdff..95cc2555 100755
> --- a/tests/xfs/010
> +++ b/tests/xfs/010
> @@ -113,7 +113,8 @@ _check_scratch_fs
>  _corrupt_finobt_root $SCRATCH_DEV
>  
>  filter_finobt_repair() {
> -	sed -e '/^agi has bad CRC/d' | \
> +	sed -e '/^agi has bad CRC/d' \
> +	    -e '/^bad finobt block/d' | \
>  		_filter_repair_lostblocks
>  }
>  
> diff --git a/tests/xfs/030 b/tests/xfs/030
> index 04440f9c..906d9019 100755
> --- a/tests/xfs/030
> +++ b/tests/xfs/030
> @@ -44,6 +44,8 @@ _check_ag()
>  			    -e '/^bad agbno AGBNO for refcntbt/d' \
>  			    -e '/^agf has bad CRC/d' \
>  			    -e '/^agi has bad CRC/d' \
> +			    -e '/^bad inobt block count/d' \
> +			    -e '/^bad finobt block count/d' \
>  			    -e '/^Missing reverse-mapping record.*/d' \
>  			    -e '/^bad levels LEVELS for [a-z]* root.*/d' \
>  			    -e '/^unknown block state, ag AGNO, block.*/d'
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index cfe09c6d..b0773756 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -113,7 +113,7 @@ sizeof(struct xfs_scrub_metadata) = 64
>  sizeof(struct xfs_unmount_log_format) = 8
>  sizeof(xfs_agf_t) = 224
>  sizeof(xfs_agfl_t) = 36
> -sizeof(xfs_agi_t) = 336
> +sizeof(xfs_agi_t) = 344
>  sizeof(xfs_alloc_key_t) = 8
>  sizeof(xfs_alloc_rec_incore_t) = 8
>  sizeof(xfs_alloc_rec_t) = 8
> 

