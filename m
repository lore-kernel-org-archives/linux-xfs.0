Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02F1FC4361A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 00:59:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 993DA224B2
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 00:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgLDA7l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 19:59:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38244 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727042AbgLDA7k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 19:59:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607043494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N+slr0Rz12Si+GG7tUCpeMdeQ1gN0SZ7mi1WEvVPjCc=;
        b=fPAOnJCQMQxQ7SvoC0t547ICDbfpoeo7jeee7HhgE8qmwmRARIRBezfx5zFaygSbHsokLS
        GA9oE4EaP7TA/iX4uQCwg4A9wI1Pz7iQxJY0czMu109DXNrbpcxew1YQ12KqkPqdqAsGvR
        3I3csZNdq+JcAzDMS1d0xFlN5VwyiJ4=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-_B2m2rruMqi-I8Jq_2JPUQ-1; Thu, 03 Dec 2020 19:58:13 -0500
X-MC-Unique: _B2m2rruMqi-I8Jq_2JPUQ-1
Received: by mail-pg1-f199.google.com with SMTP id b35so2479163pgl.8
        for <linux-xfs@vger.kernel.org>; Thu, 03 Dec 2020 16:58:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=N+slr0Rz12Si+GG7tUCpeMdeQ1gN0SZ7mi1WEvVPjCc=;
        b=slT3j9TmmKb/hgN3giOQs2lBY2UuKSyz9zAvxommfP1wAXj/ig2j8jSJssr0uxZPJa
         WOAuK6D2T7JFRgHa3Sw3bI+yiSso5v5DNbvlnFwR65G/11zCFbkon2l9xqTr0gX0x7Xi
         Y1Lvj3TuS+ASLcEUdnPNj3p2/Dt/Fwydx7D7rCCYrK0J/npw2A1opIMnzvnyylUYJT+R
         p6vYix+5Ca5Rrs9zM0CW8aiZ9ouDe6VV1Sg0Kc5i6fYRYSUJgCPwgoEazMqgOmuzVmgl
         GO5rLfJTiAEecE84bl6PlDAY+Te6YJruvmTCuq03LL/QhFSakkIzxphuTlq507vVQO4Q
         2fcw==
X-Gm-Message-State: AOAM5305oCadVyjrBoObEE4v2+Y1GRAi6UQZNka1O1G08Gn4xSEAs0e2
        PFqiMVH38ZfwYKXd0tYlCJG2JyT/VY1KBo4bwhY+ZB6oytXGHRBvUwN1Pjp5ymGDrkgUQ/jjQGS
        SuSYaOs/RyVi2Kal8pS+V
X-Received: by 2002:a17:90a:7c44:: with SMTP id e4mr1658572pjl.138.1607043491846;
        Thu, 03 Dec 2020 16:58:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyDQMgDxTkeT4f+kfjP68REawL2mbj74fFaidXk9/YazhdfB4MlqEHcsdsC9Y+1V09qtc4BFQ==
X-Received: by 2002:a17:90a:7c44:: with SMTP id e4mr1658557pjl.138.1607043491568;
        Thu, 03 Dec 2020 16:58:11 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y188sm2875307pfy.98.2020.12.03.16.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 16:58:10 -0800 (PST)
Date:   Fri, 4 Dec 2020 08:58:00 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH v2 3/6] xfs: move on-disk inode allocation out of
 xfs_ialloc()
Message-ID: <20201204005800.GA1963435@xiangao.remote.csb>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
 <20201203161028.1900929-4-hsiangkao@redhat.com>
 <20201203203130.GB3913616@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201203203130.GB3913616@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Fri, Dec 04, 2020 at 07:31:30AM +1100, Dave Chinner wrote:
> On Fri, Dec 04, 2020 at 12:10:25AM +0800, Gao Xiang wrote:

...

> > - * directly to the superblock - and so have no parent.
> > + * Initialise a newly allocated inode and return the in-core inode to the
> > + * caller locked exclusively.
> >   */
> > -static int
> > +static struct xfs_inode *
> >  xfs_ialloc(
> 
> Can we rename this xfs_dir_ialloc_init()?
> 
> That way we keep everything in xfs_inode.c under the same namespace
> (xfs_dir_ialloc_*) and don't confuse it with functions in the
> xfs_ialloc_* namespace in fs/xfs/libxfs/xfs_ialloc*.c...

Ok, thanks for the suggestion! Let me revise it in the next version.

Thanks,
Gao Xiang

> 
> Otherwise looks good.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

