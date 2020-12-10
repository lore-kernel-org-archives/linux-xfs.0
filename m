Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB57CC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 07:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 945D223B99
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 07:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgLJHuq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 02:50:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727567AbgLJHul (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 02:50:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607586551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=geTJ0CLPub3/U9/2474CmvOAmgo3qAZuJ4XhvFRQ/6o=;
        b=IhffEH6hbtmJZJfAxVe2l72+nYs53JjorMfKp7ofgI/4SamH6c5vTY+/gI6WO6AbiBbaJA
        4lQ6mNC86uacGpLfLs4Sqgu/JPSZjC8xA3TSLpIfRUTKF56e5gShoNQlV09C5fHzVtd4+t
        6nnAZMVdcv1RXji6MntufHtBxiEgPg4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-XbGfJ2qzP5Kd11fpK0cOvA-1; Thu, 10 Dec 2020 02:49:09 -0500
X-MC-Unique: XbGfJ2qzP5Kd11fpK0cOvA-1
Received: by mail-pg1-f200.google.com with SMTP id g24so3179992pgh.14
        for <linux-xfs@vger.kernel.org>; Wed, 09 Dec 2020 23:49:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=geTJ0CLPub3/U9/2474CmvOAmgo3qAZuJ4XhvFRQ/6o=;
        b=QdO6HJN8JVTxbE8jAhMWIcSlyclfzFxTz6jPQAnZIuv1rW25dBTgcPazuBGSZZ2asF
         sqH2ZSgaCv/e8WzNLwrIr0KaSRH2SOE/oh3JQMozZMTaygW4+goiYAwQqvXHmH0KZzoX
         YjjtV9kOf6araJR38ITRWM2iygEJExr6zb0Os66Ms9OTKZ/qUxjwT0MAI3wnKxd6mp3A
         znG4snVTDr5Fpw3Ex+i5t2jq03QkAep9Spnp6EMayx8aha71Pr5wjxewqPpeNliHEl4j
         gc5ep9MKoFd7UXhwzSApuJf+mizt8kQURSILvFH+mJ/qAUOdTImJZljIcHYwpj+NgwmQ
         YzbA==
X-Gm-Message-State: AOAM530aD3QjuR8V9lH8D068nS42vVUcmW8E2QaPqIgBm44sVtOur/H+
        PBTIP37DrjH+/fBPe0d2vzTz3rzf/Eu2qwLPhYOGgvF4hG5g1ErzQfFKd7GC1N9tDeU/ogE+9rW
        7bSVKqex61pHlEtQP0k3h
X-Received: by 2002:a17:902:fe95:b029:da:fa53:666 with SMTP id x21-20020a170902fe95b02900dafa530666mr5511603plm.72.1607586548361;
        Wed, 09 Dec 2020 23:49:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxlKWo6pQ8tKEtlp5TLvi0qCzK3TLoZft/GjTaAtd8k6bGC+WhzN9FO5vWVQM6KExm9gPowQg==
X-Received: by 2002:a17:902:fe95:b029:da:fa53:666 with SMTP id x21-20020a170902fe95b02900dafa530666mr5511594plm.72.1607586548166;
        Wed, 09 Dec 2020 23:49:08 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b10sm5453930pgh.15.2020.12.09.23.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 23:49:07 -0800 (PST)
Date:   Thu, 10 Dec 2020 15:48:58 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: open code updating i_mode in xfs_set_acl
Message-ID: <20201210074858.GB293649@xiangao.remote.csb>
References: <20201210054821.2704734-1-hch@lst.de>
 <20201210054821.2704734-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201210054821.2704734-3-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 10, 2020 at 06:48:21AM +0100, Christoph Hellwig wrote:
> Rather than going through the big and hairy xfs_setattr_nonsize function,
> just open code a transactional i_mode and i_ctime update.  This allows
> to mark xfs_setattr_nonsize and remove the flags argument to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me (if it's needed),
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

