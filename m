Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B442C433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 20:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6201A206C3
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 20:37:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J8zrBreD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbgF2TVR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:21:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28863 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730339AbgF2TVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 15:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593458475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NNqolJZY0RiCRVnWOP0ZytjBi9Ox38pEe/a4yEmRnUE=;
        b=J8zrBreDPMctxCXKMQQCakUG8qOttlTpChNb46tOvaqA1Y5+LvZnht8QdT1Q2NdcuLG7B0
        vA5NtKY8NxVoZ/mdA4rViL/B9jyNKFXeGDgYkiKeN5sjcvBZVStRgeq5OAkldOXI3Gyny7
        vRTcndT1anj9h5MNFUav4DhLLI7Z05M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-rm3RVi2JOhm2grGji1bPXw-1; Mon, 29 Jun 2020 08:20:34 -0400
X-MC-Unique: rm3RVi2JOhm2grGji1bPXw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9276F100422;
        Mon, 29 Jun 2020 12:20:33 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 299E474193;
        Mon, 29 Jun 2020 12:20:33 +0000 (UTC)
Date:   Mon, 29 Jun 2020 08:20:31 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: complain about ag header crc errors
Message-ID: <20200629122031.GA10449@bfoster>
References: <159311834667.1065505.8056215626287130285.stgit@magnolia>
 <159311835284.1065505.8957820680195453723.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159311835284.1065505.8957820680195453723.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 25, 2020 at 01:52:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Repair doesn't complain about crc errors in the AG headers, and it
> should.  Otherwise give the admin the wrong impression about the
> state of the filesystem after a nomodify check.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/scan.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 505cfc53..42b299f7 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -2441,6 +2441,8 @@ scan_ag(
>  		objname = _("root superblock");
>  		goto out_free_sb;
>  	}
> +	if (sbbuf->b_error == -EFSBADCRC)
> +		do_warn(_("superblock has bad CRC for ag %d\n"), agno);

So salvage_buffer() reads the buf and passes along the verifier. If the
verifier fails, we ignore the error and return 0 because of
LIBXFS_READBUF_SALVAGE, but leave it set in bp->b_error so it should be
accessible here. Looks Ok:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	libxfs_sb_from_disk(sb, sbbuf->b_addr);
>  
>  	error = salvage_buffer(mp->m_dev,
> @@ -2450,6 +2452,8 @@ scan_ag(
>  		objname = _("agf block");
>  		goto out_free_sbbuf;
>  	}
> +	if (agfbuf->b_error == -EFSBADCRC)
> +		do_warn(_("agf has bad CRC for ag %d\n"), agno);
>  	agf = agfbuf->b_addr;
>  
>  	error = salvage_buffer(mp->m_dev,
> @@ -2459,6 +2463,8 @@ scan_ag(
>  		objname = _("agi block");
>  		goto out_free_agfbuf;
>  	}
> +	if (agibuf->b_error == -EFSBADCRC)
> +		do_warn(_("agi has bad CRC for ag %d\n"), agno);
>  	agi = agibuf->b_addr;
>  
>  	/* fix up bad ag headers */
> 

