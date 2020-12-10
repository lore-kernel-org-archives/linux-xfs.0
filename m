Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACC2C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 07:43:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64C9C23D23
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 07:43:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgLJHnw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 02:43:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728959AbgLJHnq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 02:43:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607586139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GeDKQ3SF7ZCizi4URjkxw/8Y7RWVlFfrwf6ZI1offAs=;
        b=PrinhW1VZqfnKoEKFtHeQOvOBU3R0trBn4g9L8mvcy7NwgZqlUzw2YUpcLysHxnOUlqmhW
        mzz+xNVCi+eZwLHiQruh8vT/IOxu61xQcwlqOqKGyOEk30pNmuNeAGCzOCI04qHdDusW3p
        ql6kAsBi1a9s6xbs+4cC+s+rKv8mDuo=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-2KyL_XjoM5CWSSOYkKQGNA-1; Thu, 10 Dec 2020 02:42:17 -0500
X-MC-Unique: 2KyL_XjoM5CWSSOYkKQGNA-1
Received: by mail-pf1-f200.google.com with SMTP id k13so3062201pfc.2
        for <linux-xfs@vger.kernel.org>; Wed, 09 Dec 2020 23:42:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GeDKQ3SF7ZCizi4URjkxw/8Y7RWVlFfrwf6ZI1offAs=;
        b=LEJSzro5Rw3OiSXdfu3dwxDIpZmy+A2b9jwjITYY56daud8Gxhe3FsQqSIzrP/Gi2+
         C+G93sjEXx3MYDT6Rzf4Qot+Gcmj0hciL3qGuNa/XTlD8mrqNkI/IrnjmqE7GEKXP0xt
         /ijolbJo7EIBGElzv5f5Bl+QhvTVvbDBNArT3C778iUbvd79KVF+mVBLhUm0kp01/3gL
         s4gUF5BrtGILC8iy1Ld1sHUIzJ5dB+qzfr6pyyfnoHx0eVS/HWDzSipH0SyjTcw1kltO
         hjIeSbJ1RbomR4OWrMYpNyyrXvPsC2p0hYMLo8h3mmkuXma1nTXjChUQ2+7mWW2MHQtz
         wuOw==
X-Gm-Message-State: AOAM532ZEs73hJsRtyJxGK4zGVJOfCG8Li/00bWwF4OmBy8e/dY12UUm
        1yk/cW8bl41o3QCKnwm9azq1coixh7bc5bUAoMy4TzbK/c5mgdZ8u/wQHX0ii0tzfYEFoWM43ev
        cr5D7XMbHNk87D6Bb7bdd
X-Received: by 2002:aa7:8517:0:b029:19d:d70f:86ec with SMTP id v23-20020aa785170000b029019dd70f86ecmr5702337pfn.19.1607586136137;
        Wed, 09 Dec 2020 23:42:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwG42pMrr5xLAdmQoV7oQc1DfNTg6/M59f4LYL2nE5DbQfJcXyphX8qVyqfj+CfC/rcigUv+Q==
X-Received: by 2002:aa7:8517:0:b029:19d:d70f:86ec with SMTP id v23-20020aa785170000b029019dd70f86ecmr5702330pfn.19.1607586135928;
        Wed, 09 Dec 2020 23:42:15 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q16sm5343923pfg.139.2020.12.09.23.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 23:42:15 -0800 (PST)
Date:   Thu, 10 Dec 2020 15:42:06 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove xfs_vn_setattr_nonsize
Message-ID: <20201210074206.GA293649@xiangao.remote.csb>
References: <20201210054821.2704734-1-hch@lst.de>
 <20201210054821.2704734-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201210054821.2704734-2-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 10, 2020 at 06:48:20AM +0100, Christoph Hellwig wrote:
> Merge xfs_vn_setattr_nonsize into the only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me (if it's needed),
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

