Return-Path: <SRS0=chL6=C7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE20C4363D
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 17:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C50A235FD
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Sep 2020 17:44:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FwUdQTcM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgIVRo3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:44:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726563AbgIVRo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 13:44:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600796668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G0+afcQ04DbxWy43SgRBN/kdW/RdDHuMR8auJ4s7ya8=;
        b=FwUdQTcMPCgapzf1uZ4JbnJt6u0AoCuQXdoi5dZEtzmtuyHmNMz/ZKlky6F8FQtRgL7Xlp
        TsMkaa3gP/DmgWJ1rz/ySbBdg87hAWlar6f+CgJbatjQEEhw+RJ7i5ViVFBh19aA7PuWGd
        fJuO28qKLnTddm8sNbTt2+BQVGlTLOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-wP5c1s4HMs6QxnnLSmumlQ-1; Tue, 22 Sep 2020 13:44:24 -0400
X-MC-Unique: wP5c1s4HMs6QxnnLSmumlQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31BEE104FCA6;
        Tue, 22 Sep 2020 17:43:50 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4678378808;
        Tue, 22 Sep 2020 17:43:49 +0000 (UTC)
Date:   Tue, 22 Sep 2020 13:43:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH 1/3] xfs: directly return if the delta equal to zero
Message-ID: <20200922174347.GG2175303@bfoster>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
 <1600765442-12146-2-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600765442-12146-2-git-send-email-kaixuxia@tencent.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 22, 2020 at 05:04:00PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> It is useless to go on when the variable delta equal to zero in
> xfs_trans_mod_dquot(), so just return if the value equal to zero.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_trans_dquot.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 133fc6fc3edd..23c34af71825 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -215,10 +215,11 @@ xfs_trans_mod_dquot(
>  	if (qtrx->qt_dquot == NULL)
>  		qtrx->qt_dquot = dqp;
>  
> -	if (delta) {
> -		trace_xfs_trans_mod_dquot_before(qtrx);
> -		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
> -	}
> +	if (!delta)
> +		return;
> +


This does slightly change behavior in that this function currently
unconditionally results in logging the associated dquot in the
transaction. I'm not sure anything really depends on that with a delta
== 0, but it might be worth documenting in the commit log.

Also, it does seem a little odd to bail out after we've potentially
allocated ->t_dqinfo as well as assigned the current dquot a slot in the
transaction. I think that means the effect of this change is lost if
another dquot happens to be modified (with delta != 0) in the same
transaction (which might also be an odd thing to do).

Brian

> +	trace_xfs_trans_mod_dquot_before(qtrx);
> +	trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
>  
>  	switch (field) {
>  
> @@ -284,8 +285,7 @@ xfs_trans_mod_dquot(
>  		ASSERT(0);
>  	}
>  
> -	if (delta)
> -		trace_xfs_trans_mod_dquot_after(qtrx);
> +	trace_xfs_trans_mod_dquot_after(qtrx);
>  
>  	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
>  }
> -- 
> 2.20.0
> 

