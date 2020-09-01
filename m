Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC6CC433E6
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 11:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69E13206FA
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 11:46:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TTeG9rDI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgIALqU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 07:46:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45723 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726946AbgIALog (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 07:44:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598960666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+x78ojXaFMy/Z4wXujE8BWTk8WF13j5FDXj/tP7o1Iw=;
        b=TTeG9rDIbsp7FLYM8Oh0zJkveEH31c5kneAvGLGHfgXGHLUMicfjLlGVxvW8yibIIUE0VJ
        AlH7hIN82bxEzWiHuBW0EzDJB0x8BFxlYMzLw+ujKPYxs1LEoaLOa4tT3rbRwcpJOQsR9A
        YQikJ3sMWZjOhU8A75IOvJwV8erFh7Y=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-VB4YzaY4PheDZOEHttccQg-1; Tue, 01 Sep 2020 07:44:24 -0400
X-MC-Unique: VB4YzaY4PheDZOEHttccQg-1
Received: by mail-pj1-f71.google.com with SMTP id lx6so375077pjb.9
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 04:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+x78ojXaFMy/Z4wXujE8BWTk8WF13j5FDXj/tP7o1Iw=;
        b=fJAvY0SG6p8ReHbfS7KBAFPXHL2/VtER/MSstHApXeH3FPUclw87DVuWqFjSWLAJOi
         T7SwGFaeBns8+jy9/KhHdmmQQmXJkpGjocmd4NRP/mTJ72Rl79NsQCpMLeSOlPJeRSYz
         HnTWjcwD1XfgTvYR6cJpYbrjGBGeE8Unvx46nsnX4cBw482sxHG6Gbrr90er0TUW1Ow6
         sZIKAu8ufWqNm1kgro/TRRH+zHO5jGiHdQ/+bKc3ohVclOy/wM/YZs0NxuDuLPn4K0fw
         gB9QH8CewLUmNS/cdQ1GnM4Xq46vl4lnfHXDcXKxSHkN0Mykf+hWn2SCtHz5k0xifDv8
         dIPQ==
X-Gm-Message-State: AOAM531fHLpJawL5rPgORVkg2QBb3EYZ1QBio7vMBux4UZzhDd0CkpUL
        ckqQE5RwlE9n9idEJe5gTC2C+44HjtDdHiHwyM87Ga7wP+agtWnqjXFL5U1FB42I4R5ewlSzoFw
        f0K3kBbaQZGoxfyUQimUI
X-Received: by 2002:a17:90a:2d82:: with SMTP id p2mr1168857pjd.166.1598960663925;
        Tue, 01 Sep 2020 04:44:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEpb+t68K5QM0N6gaNLJ96G/S7vjYYLQN1jrXEicwpwYh5ZG1jnF1Yj2JP0sOsg2FeS31Zlw==
X-Received: by 2002:a17:90a:2d82:: with SMTP id p2mr1168840pjd.166.1598960663690;
        Tue, 01 Sep 2020 04:44:23 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c3sm1705790pfo.120.2020.09.01.04.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:44:23 -0700 (PDT)
Date:   Tue, 1 Sep 2020 19:44:12 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 08/11] xfs: widen ondisk inode timestamps to deal with
 y2038+
Message-ID: <20200901114412.GE32609@xiangao.remote.csb>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885405947.3608006.8484361543372730964.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159885405947.3608006.8484361543372730964.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:07:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Redesign the ondisk inode timestamps to be a simple unsigned 64-bit
> counter of nanoseconds since 14 Dec 1901 (i.e. the minimum time in the
> 32-bit unix time epoch).  This enables us to handle dates up to 2486,
> which solves the y2038 problem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Look good to me overall (although I'm little curious if
folding in xfs_inode_{encode,decode}_bigtime() would be
better (since it may have rare users in the future?)...
and may be

> +static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
> +{
> +	return (xfs_unix_to_bigtime(tv.tv_sec) * NSEC_PER_SEC) + tv.tv_nsec;

parentheses isn't needed here since it's basic arithmetic
but all things above are quite minor...

Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

