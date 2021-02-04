Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FB8C433E9
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 16:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFFF064DEC
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 16:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbhBDQXf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 11:23:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29515 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237176AbhBDQXd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 11:23:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612455726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ujZyDypGeoW5tzcrJ/I1etU7i7ozhks8Fqe5FKICiNc=;
        b=HHpdP3rUlWAlE9QlHvSflfbEFeUV1lwwp9ZiDGJYcsMsPFxO7ZNw/uWu74Q7wIu+SZQctq
        p3hAhvkBpJ7TysrY+S4H4OiLqQhwoeLzihvU74mmTcEyofGfpu82ZhS0Fz96ccZZjoFyvY
        WdevXOaW+b1EfmZvGh+9ofgwF2qmts8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-86ZTS0S0OYKDr9Eh1AV24Q-1; Thu, 04 Feb 2021 11:22:04 -0500
X-MC-Unique: 86ZTS0S0OYKDr9Eh1AV24Q-1
Received: by mail-pf1-f200.google.com with SMTP id z3so2791396pfj.3
        for <linux-xfs@vger.kernel.org>; Thu, 04 Feb 2021 08:22:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ujZyDypGeoW5tzcrJ/I1etU7i7ozhks8Fqe5FKICiNc=;
        b=Ri77p7A8mJ5ftyLKUEAjSi84RabF9vETZXjfyW/Dc32esxw9RN+Ai7tYMhyxys0ooW
         vetdyN8RhQ+7p1vVKQjKQ3bsMGEowfzYeeAWf9OROZqDpn3JIT32JCk/ff5hysuNEszH
         1BFVjPZD/cW1iKaW6m1SxQqTsFAfue3HWDxmyaSJ+BN3p9Rtk8K71RBPtcpTYgFSf5dT
         keTruAh3SQh5oz1riZMbcNvLnPjecQF22F1EdQjfaTfkIdQiaw63yry7qGlW1Dc5hCA9
         9ebDVd2QTN8fcBlmOaeaDg1x65l2IZG9d3raih9qPS8NrTqVlGqe4KYUO/MPZ61xtm5J
         rDSQ==
X-Gm-Message-State: AOAM5325IPJNrTBBUuf9EwjCoRq1kq+VVQSVTQDrL2nPPyV9XOcKE73L
        Rb0KxOxeOvvdP8rlFRZp/3aMVQuRYrBkf5q6O9/ZikYXvPR2Hw4t+LDbEyxGaEsbt9IU3zkP4fY
        eSzDZij5gmZTjeE67Q1s4
X-Received: by 2002:a65:4083:: with SMTP id t3mr9782703pgp.150.1612455723681;
        Thu, 04 Feb 2021 08:22:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzN2qcRA1HTjf0OVqAx5S1/McIM7HVrC/8UziCuUH+BUuA0PsldYIUzTZy5dZeJq/u7bXvHgA==
X-Received: by 2002:a65:4083:: with SMTP id t3mr9782687pgp.150.1612455723380;
        Thu, 04 Feb 2021 08:22:03 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q132sm6919552pfq.171.2021.02.04.08.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 08:22:02 -0800 (PST)
Date:   Fri, 5 Feb 2021 00:21:52 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 6/7] xfs: support shrinking unused space in the last AG
Message-ID: <20210204162152.GE149518@xiangao.remote.csb>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-7-hsiangkao@redhat.com>
 <20210203142337.GB3647012@bfoster>
 <20210203145146.GA935062@xiangao.remote.csb>
 <20210203180126.GH3647012@bfoster>
 <20210204091835.GA149518@xiangao.remote.csb>
 <20210204123316.GB3716033@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210204123316.GB3716033@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Brian,

On Thu, Feb 04, 2021 at 07:33:16AM -0500, Brian Foster wrote:
> On Thu, Feb 04, 2021 at 05:18:35PM +0800, Gao Xiang wrote:
> > On Wed, Feb 03, 2021 at 01:01:26PM -0500, Brian Foster wrote:
> > > On Wed, Feb 03, 2021 at 10:51:46PM +0800, Gao Xiang wrote:
> > 
> > ...
> > 
> > > > > 
> > > > > >  
> > > > > > -	/* If there are new blocks in the old last AG, extend it. */
> > > > > > +	/* If there are some blocks in the last AG, resize it. */
> > > > > >  	if (delta) {
> > > > > 
> > > > > This patch added a (nb == mp->m_sb.sb_dblocks) shortcut check at the top
> > > > > of the function. Should we ever get to this point with delta == 0? (If
> > > > > not, maybe convert it to an assert just to be safe.)
> > > > 
> > > > delta would be changed after xfs_resizefs_init_new_ags() (the original
> > > > growfs design is that, I don't want to touch the original logic). that
> > > > is why `delta' reflects the last AG delta now...
> > > > 
> > > 
> > > Oh, I see. Hmm... that's a bit obfuscated and easy to miss. Perhaps the
> > > new helper should also include the extend_space() call below to do all
> > > of the AG updates in one place. It's not clear to me if we need to keep
> > > the growfs perag reservation code where it is. If so, the new helper
> > > could take a boolean pointer (instead of delta) that it can set to true
> > > if it had to extend the size of the old last AG because the perag res
> > > bits don't actually use the delta value. IOW, I think this hunk could
> > > look something like the following:
> > > 
> > > 	bool	resetagres = false;
> > > 
> > > 	if (extend)
> > > 		error = xfs_resizefs_init_new_ags(..., delta, &resetagres);
> > > 	else
> > > 		error = xfs_ag_shrink_space(... -delta);
> > > 	...
> > > 
> > > 	if (resetagres) {
> > > 		<do perag res fixups>
> > > 	}
> > > 	...
> > > 
> > > Hm?
> > 
> > Not quite sure got your point since xfs_resizefs_init_new_ags() is not
> > part of the transaction (and no need to). If you mean that the current
> > codebase needs some refactor to make the whole growfs operation as a
> > new helper, I could do in the next version, but one thing out there is
> > there are too many local variables, if we introduce some new helper,
> > a new struct argument might be needed.
> > 
> 
> That seems fine either way. I think it's just a matter of passing the
> transaction to the function or not. I've appended a diff based on the
> previous refactoring patch to demonstrate what I mean (compile tested
> only).

(forget to reply this email...)

Ok, will update in the next version.

> 
> > And I have no idea why growfs perag reservation stays at the end of
> > the function. My own understanding is that if growfs perag reservation
> > here is somewhat racy since no AGI/AGF lock protection it seems.
> > 
> 
> Ok. It's probably best to leave it alone until we figure that out and
> then address it in a separate patch, if desired.

Okay.

Thanks,
Gao Xiang

> 
> Brian

