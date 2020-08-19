Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53D61C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A8DE20657
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:58:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NjkEEpm3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgHSA6p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:58:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32391 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726367AbgHSA6o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:58:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597798723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vF+vVYQqJRG25C0OQpxpzVAMiI/WzCQFwPaVm65n6qY=;
        b=NjkEEpm31gvn1WcMPP5j0gJMWradxoV6izrTCKzuMrOfd29Nr+TU9dxG9WiLft3A+KXilE
        FmmNbFSGZxzNREjkJumuw01gXsstNJiS962gOoVxCoyDL4GU+/x21P4gsOP8edkQm50IdI
        lFcHfBDz7YN3a0fNGtrkP1qEFVjZT2s=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-kmfEMNY1MlCQJvyOGis-aQ-1; Tue, 18 Aug 2020 20:58:42 -0400
X-MC-Unique: kmfEMNY1MlCQJvyOGis-aQ-1
Received: by mail-pj1-f71.google.com with SMTP id ei10so440452pjb.2
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 17:58:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vF+vVYQqJRG25C0OQpxpzVAMiI/WzCQFwPaVm65n6qY=;
        b=eNCJ93H1yhoCzG8AQOW3HOQOfXVClZU8oswlUJvPx62WMzrpqptizqiFlmtUjGOuBf
         O6xhJD/k5AXbNB9SgxD+zCOBeiDG11f4lWYIqm0Tb371FLcT2c3Ph8WHkaSP86kjWv/p
         PMXaLNjoy0lRXV1P4BGsqOP5M87Lth6YhKNt+qipiIrU2fKwWCKfPQxLs/JMjjYxVNlX
         g8bCYthMqrcXFyic4qvZ+uflP6SYkRcFBt36dq9hxWs6VLB1mx/n8qoZ5KNjY0GQmFUq
         qFtr5WFxrzyHSyKcZ4h8FZuuAo/UbWITY77ufC0OOsTXnnnk+6k8kwuHKtnH1+nxIYAs
         /qig==
X-Gm-Message-State: AOAM5330lx5TYWiaethpI6mqH8h0OMwd60D/XMvIdKtV7kCaDO6sC84t
        CFxXoYq20xwZtI5TI3dChIFdIoGkopeH1D2UViWiWL3BFWN7yGikzI0MdvrF/eAVBx73Mi19x/j
        TB3cDS0NTGiaEzzjoOVxR
X-Received: by 2002:a17:90a:fd82:: with SMTP id cx2mr2123288pjb.67.1597798720663;
        Tue, 18 Aug 2020 17:58:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZV1Halg5V4zaNFdNvpV9mC+aytCFG61UP8+GYIMvcDqAQBf/pR1KhjMZ3xZCxajZD6YkWOQ==
X-Received: by 2002:a17:90a:fd82:: with SMTP id cx2mr2123269pjb.67.1597798720409;
        Tue, 18 Aug 2020 17:58:40 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bv17sm1026547pjb.0.2020.08.18.17.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 17:58:39 -0700 (PDT)
Date:   Wed, 19 Aug 2020 08:58:30 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: arrange all unlinked inodes into one list
Message-ID: <20200819005830.GA20276@xiangao.remote.csb>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-5-david@fromorbit.com>
 <20200818235959.GR6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818235959.GR6096@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 04:59:59PM -0700, Darrick J. Wong wrote:

...

> > +	bucket_index = 0;
> > +	/* During recovery, the old multiple bucket index can be applied */
> > +	if (!log || log->l_flags & XLOG_RECOVERY_NEEDED) {
> 
> Does the flag test need parentheses?

Yeah, that would be better.

> 
> It feels a little funny that we pass in old_agino (having gotten it from
> agi_unlinked) and then compare it with agi_unlinked, but as the commit
> log points out, I guess this is a wart of having to support the old
> unlinked list behavior.  It makes sense to me that if we're going to
> change the unlinked list behavior we could be a little more careful
> about double-checking things.
> 
> Question: if a newer kernel crashes with a super-long unlinked list and
> the fs gets recovered on an old kernel, will this lead to insanely high
> recovery times?  I think the answer is no, because recovery is single
> threaded and the hash only existed to reduce AGI contention during
> normal unlinking operations?

btw, if my understanding is correct, as I mentioned starting from my v1,
this new feature isn't forward compatible since old kernel hardcode
agino % XFS_AGI_UNLINKED_BUCKETS but not tracing original bucket_index
from its logging recovery code. So yeah, a bit awkward from its original
design...

Thanks,
Gao Xiang

