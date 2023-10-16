Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A923CDB465
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Oct 2023 12:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjJPMdS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 08:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjJPMdQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 08:33:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C01AD
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 05:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697459549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tLG//EhK9I8o7cV+2JFGlMWf+fyb5KvdWdST0xQgYhY=;
        b=Kn8ufPOSX0WXcVtmTvwSvejA8LWy4I6b5SM/fgGhPaDTzF5JN5T8rO6ZL3MSlAsrEuu6zV
        BQJw5U6f1S7fHENszupER/TXH+YrAFLA91eCtF3ZKDIz1FiK1vo494SXtKug1phCNZ44PI
        BIiyHP/6Z/PSoy175xlNMAaFVli3Rls=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-CIKWoCJqM-CJz-Q0QEYlhQ-1; Mon, 16 Oct 2023 08:32:28 -0400
X-MC-Unique: CIKWoCJqM-CJz-Q0QEYlhQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9ba247e03aeso307122666b.1
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 05:32:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697459547; x=1698064347;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tLG//EhK9I8o7cV+2JFGlMWf+fyb5KvdWdST0xQgYhY=;
        b=OWcYrs0LiEeQPgwdS1EfZ9Wgd9ewo2G+YApPmbtWF7ZcBk5C1Af/PAz3enPomBInDg
         o5GC+uxG2QaeHl4fUP4osET1o/tU+/GIawvbDce2gsVTvRz3ng4lzfqxQQrHGUT4IcdS
         gi+qhnSuyfk86ux6epTMtwPFCt6Kd67KLFf9nc2fKZTKpOb9980UT8xUzkz0S1Rs+th3
         ex6xU0FFRg0bC+TVELafrMHk7+P7SGWLv8rxATRh8UG+LJ6FeFx1qLJzF/dFvs0SIWmY
         XdJhJ3Ao8YyIX74UYjlKStP/QeAvRLL0Tqm0NVPEcI2vgGeLxlnsVgYNxKkYNMIIqvZD
         XZHg==
X-Gm-Message-State: AOJu0YwBWoodTWL8ibMQj2sqKakz90KVNP7kZd31cbt3WdJLaj/YXWh8
        hdk1AR1fTf7zeedoj/4L/Iz7sW045Itj9Acbav+/yrNxGWt29AIvT/GvUDqsrLjsCcIAPu+0L8S
        Uan28a1II7n5nCEW5WRzt3lk9wFY=
X-Received: by 2002:a17:907:d24:b0:9bf:697b:8f44 with SMTP id gn36-20020a1709070d2400b009bf697b8f44mr5569178ejc.6.1697459547458;
        Mon, 16 Oct 2023 05:32:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGB7qmw8VW3+nswiOyGckEp+ZRTcyaKDpWkU2ZIQBuNuhNhMfbhluSMuibOxhIeC+aBVGt8lg==
X-Received: by 2002:a17:907:d24:b0:9bf:697b:8f44 with SMTP id gn36-20020a1709070d2400b009bf697b8f44mr5569163ejc.6.1697459547155;
        Mon, 16 Oct 2023 05:32:27 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id u26-20020a50951a000000b0053ecef8786asm1641132eda.75.2023.10.16.05.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 05:32:26 -0700 (PDT)
Date:   Mon, 16 Oct 2023 14:32:25 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, djwong@kernel.org, ebiggers@kernel.org,
        david@fromorbit.com, dchinner@redhat.com
Subject: Re: [PATCH v3 11/28] iomap: pass readpage operation to read path
Message-ID: <xic2dogypvli45ku7nasuuszslvv55tadj6etpl7r3gubvw2o6@hms55yjiqsiq>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-12-aalbersh@redhat.com>
 <ZSz/FLK+tNIQzOA/@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSz/FLK+tNIQzOA/@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-10-16 02:15:00, Christoph Hellwig wrote:
> Looking at the entire series, it seems like the only XFS-specific
> part of the fsverity processing in iomap is the per-sb workqueue
> now that the fsverity interfaces were cleaned up.
> 
> Based on that it seems like we'd be much better just doing all the
> work inside iomap, and just allow XFS to pass the workqueue to
> iomap_read_folio and iomap_readahead.  The patch below does that
> as an untested WIP on top of your branch.
> 
> If we go down that way I suspect the better interface would be
> to allocate the iomap_readpage_ctx in the callers of these functions
> instead of passing an extra argument, but I'm not entirely sure
> about that yet.

From the discussion in v2 [1] I understood that btrfs would like to
have this bio_set/submit_io interface for iomap transition; and any
other filesystem deferrals would also be possible. Is it no more the
case with btrfs? Would fs-verity verification in iomap_read_end_io
combine both solutions (fs-verity verification in iomap +
submit_io/bio_set interface).

[1]: https://lore.kernel.org/linux-xfs/ZCxEHkWayQyGqnxL@infradead.org/#t

-- 
- Andrey

