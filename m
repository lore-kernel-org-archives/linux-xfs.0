Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C581AC33CB1
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 14:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 971BA2465A
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 14:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W0ENApzw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgAOOdJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 09:33:09 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26812 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726248AbgAOOdJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 09:33:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579098788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XqD3pqzYEsk0yMLB7Dx3tGxERF6IsUQ3IjFl8IYrhAk=;
        b=W0ENApzwWfRAeX0PgqlzjNvuJQILu2YBHWIwiXj4KbfBPeWQka+WtukJVaa1eltWJflSeb
        jxgP/Tlk5mHad8+AsEioh7zegcUrGxqF398Hvrw0NpLa5mL1EXA19F8n9kHanl6c2RHA46
        oiStNCY2z6hW2WNhIRTdcHx9r5ro6eU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-r2VAey6-O1aPVFm48vgOoA-1; Wed, 15 Jan 2020 09:33:05 -0500
X-MC-Unique: r2VAey6-O1aPVFm48vgOoA-1
Received: by mail-wm1-f70.google.com with SMTP id h130so9347wme.7
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2020 06:33:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=XqD3pqzYEsk0yMLB7Dx3tGxERF6IsUQ3IjFl8IYrhAk=;
        b=Zo9tV0rYodUh6IIVpAvUWuLVfYVEUcd8brVkRy0h/xW3npJ35waFjahpG2ltUGbXue
         ZPSXTXTNaD9dgM6MpOZlBUuNcqjxeQl6pPLKjB58iN33TyvDHE/THO/qzhABJUiMt2eT
         Db8I1tffQIDczdWCa/63PBPbffJaI6HvEDXw8tsmfXL8YjzkM43PVmzZ7st00Q6rNbmX
         bvuw5UuXWGlQ25ccXF0CdaUg0g3xrbWFHrR2QV9itdp/dtY5jwPMCYvdy8gKpFPp+Npv
         KrvYHLjMVefhkGO774vCiIfP5zV3Hpv3LlYshfH9AaAxlCu6n5/HPgH9dBHoURdWbdF6
         AqgA==
X-Gm-Message-State: APjAAAVT4Bi7hZjDIRE3xb/ii8E5l3b+FEzdlHk5N/mSCi1Swm9WTqz3
        CpTHOlos/+TnsLnnlWZgU/WYwtkMrt9hstDWh4Rp+P3ayNU9bqZGRt4wllrDRrKyb5wsDmfWTnz
        E9tzMqK/fbimMUgYoKWRB
X-Received: by 2002:a1c:e007:: with SMTP id x7mr21648wmg.3.1579098784214;
        Wed, 15 Jan 2020 06:33:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqyAvZaGR0Gjb61rGxOdv7aQOkcnENmzpMrs/ik1I3xyCSDi5ydiJ0lzd1JrZX3/S8d8aW9WLw==
X-Received: by 2002:a1c:e007:: with SMTP id x7mr21628wmg.3.1579098784054;
        Wed, 15 Jan 2020 06:33:04 -0800 (PST)
Received: from orion (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id a9sm23276wmm.15.2020.01.15.06.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 06:33:03 -0800 (PST)
Date:   Wed, 15 Jan 2020 15:33:01 +0100
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix IOCB_NOWAIT handling in xfs_file_dio_aio_read
Message-ID: <20200115143301.4b5hap4fm6irjwto@orion>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20200115134653.433559-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115134653.433559-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 02:46:53PM +0100, Christoph Hellwig wrote:
> Direct I/O reads can also be used with RWF_NOWAIT & co.  Fix the inode
> locking in xfs_file_dio_aio_read to take IOCB_NOWAIT into account.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Resending standalone to get a little more attention.
> 
>  fs/xfs/xfs_file.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c93250108952..b8a4a3f29b36 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -187,7 +187,12 @@ xfs_file_dio_aio_read(
>  
>  	file_accessed(iocb->ki_filp);
>  
> -	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
> +			return -EAGAIN;
> +	} else {
> +		xfs_ilock(ip, XFS_IOLOCK_SHARED);
> +	}
>  	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL,
>  			is_sync_kiocb(iocb));
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> 

Looks good to me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos

