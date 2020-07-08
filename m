Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3977C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 23:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC5CE20720
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 23:40:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PDNlb5Y+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgGHXk5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 19:40:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49814 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726106AbgGHXk5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 19:40:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594251656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hFjhD94y7oj3QF+fodAQPJBB8CVZ3YgKopcMzTcVAS0=;
        b=PDNlb5Y+HKHpNVP1Cwd4R99/7YQZnNZhe6tQ4QKdag+yzt3Md1bCQmyl5K3ZjnyG5cwJN3
        Ou7MHLxMGDpfYOpDcKVsDPW2n0KXRk1kShWHOObltEqzlbpWI17mES2nd3qR0506HfpStr
        0Bq4XbmeynCohjUlBGvIhMAR0xIYsJE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-_32DAQl1OTyEo1KKpS9HBw-1; Wed, 08 Jul 2020 19:40:54 -0400
X-MC-Unique: _32DAQl1OTyEo1KKpS9HBw-1
Received: by mail-pg1-f200.google.com with SMTP id t6so413376pgv.5
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jul 2020 16:40:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hFjhD94y7oj3QF+fodAQPJBB8CVZ3YgKopcMzTcVAS0=;
        b=IS4CyX6KedxX/jrk1t0ir8ujxwwczs8w633qowkYKn8UnHpda3bQbjwA9UFaQf2W5Y
         sCQXg28oFfxZR7U+HkkMp3frwuGaTmW2oupx4YoZiakzUqxrFYPxiXJMakjNQjAOR0NK
         U85rFa7s9L8+q0PelaOX/2CVBrtes2v9XdOLcpOwUnt8BMFfj9N9e70OQaheYt89BO88
         eNtmCqoHsAMxTIZ7SE+d+qF2bl6UcmGLjxBAmxyl6xLjRXAPQw84Rw83Q5bDOt1Qgk3V
         eMhMTwtJf/84eiCrbXtVUqbt4ICb3E68n545mzwAJTxxYNzHv1B/tj8wywKSa9yInoa6
         nLlA==
X-Gm-Message-State: AOAM533eGSIxGBUfydD6zyQA1fl1Z/6k92ZyKQOiVtC2K0UiL2FkJzOl
        jYLSxHg7SUCWDpzESIFihciU5r/MVe5h2YvzaCftZnTUkPFAmMHhG+A47afvxDFIJ75LG2LhHjv
        Dokzc+ziYyi2MItKwxCJc
X-Received: by 2002:a17:90a:6048:: with SMTP id h8mr11882377pjm.230.1594251653289;
        Wed, 08 Jul 2020 16:40:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxD/e4R0rul9YQTNQKh5Ayx/3S8vANPuqORfBsHqoi6E97ulW72DtgIyaeW0g5mj95PecKyBA==
X-Received: by 2002:a17:90a:6048:: with SMTP id h8mr11882361pjm.230.1594251653004;
        Wed, 08 Jul 2020 16:40:53 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c134sm762598pfc.115.2020.07.08.16.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 16:40:52 -0700 (PDT)
Date:   Thu, 9 Jul 2020 07:40:42 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 2/2] xfs: don't access AGI on unlinked inodes if it
 can
Message-ID: <20200708234042.GA15249@xiangao.remote.csb>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200707135741.487-3-hsiangkao@redhat.com>
 <20200708170307.GD7625@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708170307.GD7625@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On Wed, Jul 08, 2020 at 10:03:07AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 07, 2020 at 09:57:41PM +0800, Gao Xiang wrote:
> > Currently, we use AGI buffer lock to protect in-memory linked list for
> > unlinked inodes but since it's not necessary to modify AGI unless the
> > head of the unlinked list is modified. So let's removing the AGI buffer
> > modification dependency if possible, including 1) adding another per-AG
> > dedicated lock to protect the whole list and 2) inserting unlinked
> > inodes from tail.
> > 
> > For 2), the tail of bucket 0 is now recorded in perag for xfs_iunlink()
> > to use. xfs_iunlink_remove() still support old multiple short bucket
> > lists for recovery code.
> > 
> > Note that some paths take AGI lock in its transaction in advance,
> > so the proper locking order is only AGI lock -> unlinked list lock.
> 
> How much agi buffer lock contention does this eliminate?

Sorry, I haven't got the point.

Did you mean I should show some number in the commit message from some workload?
I'm not sure if you mean that, it depends on the specific workload indeed. I
could do that if needed (it's of much help if some more hints here...)

Or I'm not sure if you mean the deadlock. There are some exist path I've found
when running fsstress, for example, xfs_create_tmpfile() will reading/locking
AGI when preparing an orphan inode in this transaction. So if I reading AGI
again under a new lock unconditionally, it should cause ABBA deadlock (since
another path takes mutex first and locks AGI buffer again).

> 
> > @@ -372,6 +372,9 @@ typedef struct xfs_perag {
> >  	/* reference count */
> >  	uint8_t			pagf_refcount_level;
> >  
> > +	struct mutex		pag_unlinked_mutex;
> > +	struct xfs_inode	*pag_unlinked_tail;
> 
> What do these fields do?  There aren't any comments....

Will add some comments in the next version, Thanks for the advice!

Thanks,
Gao Xiang

> 
> --D
> 
> > +
> >  	/*
> >  	 * Unlinked inode information.  This incore information reflects
> >  	 * data stored in the AGI, so callers must hold the AGI buffer lock
> > -- 
> > 2.18.1
> > 
> 

