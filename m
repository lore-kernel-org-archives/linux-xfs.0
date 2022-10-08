Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92FAFC4332F
	for <linux-xfs@archiver.kernel.org>; Sat,  8 Oct 2022 11:12:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJHLMV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 8 Oct 2022 07:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiJHLMU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Oct 2022 07:12:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F1050F91
        for <linux-xfs@vger.kernel.org>; Sat,  8 Oct 2022 04:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665227539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ImDEzEAV/tlquMgKF4ihNd+T83vdO0QO8PCm85Any8w=;
        b=PQZx0P2sAfCcRXPIN58au+sd9prXQqo4Hl9OcT5wsWO3/rtpik+YEcuDcmrpgIAf6WbBpT
        XE7yiW+XSGoWBnTur49uYYHhIWvJHsZ5x4PFNXrQganwiqPJkWblmdMqKGs8dlux+oltFq
        9Z/rmG068p1Pt8xdHJ5BcPsbYyzm/gY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-358-3NMqw52uMTCdM8uXKJBOxg-1; Sat, 08 Oct 2022 07:12:17 -0400
X-MC-Unique: 3NMqw52uMTCdM8uXKJBOxg-1
Received: by mail-qt1-f197.google.com with SMTP id cg13-20020a05622a408d00b0035bb2f77e7eso4679661qtb.10
        for <linux-xfs@vger.kernel.org>; Sat, 08 Oct 2022 04:12:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ImDEzEAV/tlquMgKF4ihNd+T83vdO0QO8PCm85Any8w=;
        b=vRKLNNnuhYSwxtY5sOobOWdMqsfv5uKXGaJYanicdDZFgotQ3RhAZVqf+I8WpyZMp8
         raRtlBq0GHCndnwnWF+K4NjXtVAMXz+wepraXeJMHXjL6LLv7pvDy5UkF2b8+rFF9Ajl
         7G1RQbbBPgDEMUhR6rn4KEDU8rXhAnj81jvyCSwqTv5dbTJV6dkNE4hV09vjIxVuTZ4T
         15GHqPQ4muX/JWzbTLuNuIK1De6oeQzVhwTc6InW1PIEhX0e0VEtkMOK734feKQR5BSF
         cJoySZ5j0IMWlzWh2JQdFuxOd/iMIt2WSGXmPmiqccfJqjhEPNL3UOG52RR0I3lptJYt
         5E4A==
X-Gm-Message-State: ACrzQf28c9gWVDy7KiTyE5M5DsTq9YEuO+SxN+nnHsMFsbhq1c3WfO/8
        R50SHphW2dpTUADpZSRfTP6N5HK02Zr6qR1QjmmmkeYSPk52xl3zHAv2V9akpMqcjylrEdv7mqc
        +nptLlrLAGhnQdAs0fzhS
X-Received: by 2002:a0c:810f:0:b0:47b:299a:56d7 with SMTP id 15-20020a0c810f000000b0047b299a56d7mr7504016qvc.12.1665227536766;
        Sat, 08 Oct 2022 04:12:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5tIbTYVKsXPjhnE8zAG9aZKvd32DcrCZTMOj6ObjfB8PAdF0jJRlZCjaODeHut4QTsg+VzTw==
X-Received: by 2002:a0c:810f:0:b0:47b:299a:56d7 with SMTP id 15-20020a0c810f000000b0047b299a56d7mr7504003qvc.12.1665227536527;
        Sat, 08 Oct 2022 04:12:16 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w19-20020ac843d3000000b003928b4a22afsm4083078qtn.12.2022.10.08.04.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Oct 2022 04:12:16 -0700 (PDT)
Date:   Sat, 8 Oct 2022 19:12:11 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5/6] common/populate: don't metadump xfs filesystems twice
Message-ID: <20221008111211.ofzim67axoybq4oi@zlang-mailbox>
References: <166500903290.886939.12532028548655386973.stgit@magnolia>
 <166500906102.886939.861772249521756043.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166500906102.886939.861772249521756043.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 05, 2022 at 03:31:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Due to some braino on my part, _scratch_populate_cached will metadump
> the filesystem twice -- once with compression disabled, and again with
> it enabled, maybe.  Get rid of the first metadump.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/populate |    1 -
>  1 file changed, 1 deletion(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index 9739ac99e0..4eee7e8c66 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -890,7 +890,6 @@ _scratch_populate_cached() {
>  	"xfs")
>  		_scratch_xfs_populate $@
>  		_scratch_xfs_populate_check
> -		_scratch_xfs_metadump "${POPULATE_METADUMP}"
>  
>  		local logdev=
>  		[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> 

