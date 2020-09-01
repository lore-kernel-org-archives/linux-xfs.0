Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EBAC433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 08:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62F69206CD
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 08:18:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZaNpQP6f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgIAIS0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 04:18:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50214 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725949AbgIAISY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 04:18:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598948303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KUJg9PcCaMv119kvgcSqQgoJExzyQQomSi9R3DYpyYY=;
        b=ZaNpQP6f8yRt5YQDwoiOrit5RN5rXpgAG8wTdLbkeb6cthmTrahUPWe14TCe6LTcMtlEkP
        xvHFcPWiIj+PKXeLJsWqVW+uffSD6k+gxA7/NQ7lsVQMsy4PVKfgk0e8q0uAQJBbYzHhBD
        Pbrg/CQl6ltJCQMMsQsQSH3dNYIJCko=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-DwREyx2vN4qPsdOZ3zflDQ-1; Tue, 01 Sep 2020 04:18:21 -0400
X-MC-Unique: DwREyx2vN4qPsdOZ3zflDQ-1
Received: by mail-pj1-f70.google.com with SMTP id lx6so145368pjb.9
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 01:18:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KUJg9PcCaMv119kvgcSqQgoJExzyQQomSi9R3DYpyYY=;
        b=DgdRrYxtSTcBLuwcs9IMo1WXocaCYM52SinLlhHgRZuusg4+e0Rdngy+cHXzKTEM9Y
         stXWCX5caIE+AK30ExKBhxmSgzeBGoHQmNsmGMBloTd++HDx2Uhd0538FjK3bLR3Skpl
         XLqXi1dcthrWhzko67mDCYMClrnQj4XuFrXdBgy2yPoLZQ+jPmNIT7Ni3l0MVxrnVxXJ
         5ebwAyyrm2LIOAuJHw2guW7BvWAZox3En2ZJ6YSqVi9q62LHI5NScpGliBHEyW037bS3
         sE0EoC/7PHQ8pKY3iw+hZi61O4fW/00fM+4iHdPGLnaO4jAoTogSRyu5QFYegGR4gUBn
         usJA==
X-Gm-Message-State: AOAM532VrhGn4u1VKJqaHZmPYfKDxyPFUfmt2kRsGQyLFQ/sDrcXf5Rj
        uWLamlghH/55Wc3dF8zJKckVoXpad/dv9nXIvGDEFsLtSwBCGEAY8K9Obu/Cpf9ZWUsh/Cu62QU
        wAI+0DkPFWB5T3j5RoD59
X-Received: by 2002:a17:90b:4b04:: with SMTP id lx4mr473998pjb.150.1598948300794;
        Tue, 01 Sep 2020 01:18:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw26hl6atm8YJuer41X7nTpg+U568A/8kf9U9JQXqyScc0o0aJB4HmrojVreTXFBLNx7VlK4A==
X-Received: by 2002:a17:90b:4b04:: with SMTP id lx4mr473977pjb.150.1598948300543;
        Tue, 01 Sep 2020 01:18:20 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e16sm851411pfl.100.2020.09.01.01.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 01:18:20 -0700 (PDT)
Date:   Tue, 1 Sep 2020 16:18:08 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH 01/11] xfs: explicitly define inode timestamp range
Message-ID: <20200901081808.GA32609@xiangao.remote.csb>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885401259.3608006.3598200231687223740.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159885401259.3608006.3598200231687223740.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:06:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Formally define the inode timestamp ranges that existing filesystems
> support, and switch the vfs timetamp ranges to use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>

Looks good to me (if it needs),
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

(will skip quota related patches since I'm not familiar with that...)

Thanks,
Gao Xiang

