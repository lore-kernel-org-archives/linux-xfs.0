Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AED8C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 17:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D640261107
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 17:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242381AbhD1Rse (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 13:48:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242385AbhD1Rsc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 13:48:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619632067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Np/0h7yK8mlO72O746vGN1gLf2I7R6Y5y97q0vaR2XE=;
        b=DtXCAAcjjGyO80J/rnB3ktCw/gF4k6l1iRYWJ5jk3V3CCnjO8mT59Bjbu/PLUZaTzKrMY+
        YgJ30Frx9PnTwRCE7OQUpf2ktAFB/MkmVY9s37Vfi0RoEkdmwh//BBiYt4VTGQvfsO2Oef
        tgiLSD0aUKkAmCPxnrrmc1jxH2avYyg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-lIC5KCN7M2awPe2k8PEHSA-1; Wed, 28 Apr 2021 13:47:45 -0400
X-MC-Unique: lIC5KCN7M2awPe2k8PEHSA-1
Received: by mail-qv1-f71.google.com with SMTP id f7-20020a0562141d27b029019a6fd0a183so28811991qvd.23
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 10:47:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Np/0h7yK8mlO72O746vGN1gLf2I7R6Y5y97q0vaR2XE=;
        b=NRS6PeFBpiZZ6HkIfWZitPwArl0PKLBzAecPNe9zRiKT1wA3rqgA4T/1azG0YoIZzq
         TH2gqUYus/J5mmj/8Ch/I3B6H5V8P/GWQjl90s1LRON7y3TU7lJWaHQt5HMG5yMsBrEg
         6jik4FOJDevFrdk1b48BiAhwB42D9BDJ82x+9X20OBGr7qRnlDfBZzEqbZxyUB7WJ+74
         ftf/47pwHBNlMbfFnO49ZVk3UcVz3MhHEOjaJsPjjerUQ7XvECHf5y2Y699/lfIIx7lU
         LXlZp3smn260Uuio27R6+5VnTyBRus14hHkd/AeW5P11flSuwL/VoGGiCni4Ro8W5WFV
         NiQw==
X-Gm-Message-State: AOAM531ltQYmq+bTIbmTAmZ99Iig9gpJLu5ono7eIWTJliu/GijhP40C
        kZqLKHaCXShB9+oZw7ELfUOxuoUM8I+ErPan7CR2C7V7zeHzAs9oG3MFNyOGXxNUgWLqkqcnDdX
        MRQHpf9Wl/uzy8u7izF4t
X-Received: by 2002:a05:620a:8dd:: with SMTP id z29mr22118697qkz.492.1619632065023;
        Wed, 28 Apr 2021 10:47:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+ROJMweWfnnaFHRM9hDW1zD8OrcysSIba1ln92bv5vcltrV6g044e9q/k56OIHBEzUjPjTA==
X-Received: by 2002:a05:620a:8dd:: with SMTP id z29mr22118691qkz.492.1619632064877;
        Wed, 28 Apr 2021 10:47:44 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id e13sm534274qtm.35.2021.04.28.10.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 10:47:44 -0700 (PDT)
Date:   Wed, 28 Apr 2021 13:47:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 4/5] xfs/004: don't fail test due to realtime files
Message-ID: <YImfvpWFzufkVUvR@bfoster>
References: <161958293466.3452351.14394620932744162301.stgit@magnolia>
 <161958295873.3452351.8562454394626118217.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161958295873.3452351.8562454394626118217.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:09:18PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test exercises xfs_db functionality that relates to the free space
> btrees on the data device.  Therefore, make sure that the files we
> create are not realtime files.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  tests/xfs/004 |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/tests/xfs/004 b/tests/xfs/004
> index 141cf03a..7633071c 100755
> --- a/tests/xfs/004
> +++ b/tests/xfs/004
> @@ -28,6 +28,10 @@ _populate_scratch()
>  	_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
>  	. $tmp.mkfs
>  	_scratch_mount
> +	# This test looks at specific behaviors of the xfs_db freesp command,
> +	# which reports on the contents of the free space btrees for the data
> +	# device.  Don't let anything get created on the realtime volume.
> +	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
>  	dd if=/dev/zero of=$SCRATCH_MNT/foo count=200 bs=4096 >/dev/null 2>&1 &
>  	dd if=/dev/zero of=$SCRATCH_MNT/goo count=400 bs=4096 >/dev/null 2>&1 &
>  	dd if=/dev/zero of=$SCRATCH_MNT/moo count=800 bs=4096 >/dev/null 2>&1 &
> 

