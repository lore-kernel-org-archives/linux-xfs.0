Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D748C35646
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 17:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5177F206E2
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 17:50:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GXl2K2q2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgBURuH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 12:50:07 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28743 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgBURuG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 12:50:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582307406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pibwraHe2suNw96tGr7c+vXnC0+HB1o+rC1B8djVfCQ=;
        b=GXl2K2q2+jJHGzvdc7friEQuWmsddJBI6bohQcnTqLa+rUBKaGroObUXsSFg8ildQE07xw
        9DzdInaJOJobnt8Rh7HmR+vuRZdZPsiguIN4NqNgBZiapTbjL6+LXfdV4uspzEdLL3OxUS
        A8TMNk/d2Vs1bCWIRqaSMuiyBCyJkv8=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-XAs7XZkwMqqPFdhU7UtYjA-1; Fri, 21 Feb 2020 12:50:04 -0500
X-MC-Unique: XAs7XZkwMqqPFdhU7UtYjA-1
Received: by mail-vk1-f197.google.com with SMTP id h197so1236353vka.5
        for <linux-xfs@vger.kernel.org>; Fri, 21 Feb 2020 09:50:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pibwraHe2suNw96tGr7c+vXnC0+HB1o+rC1B8djVfCQ=;
        b=o+ALR27sdzxPkaM68dHatqqYGdTjuXBOPKVbVsoLHnld5dvu3i08GKT0epygCodYyF
         cmE+2+694+oUAZY+Z+dk7LgYQOs3RyzvXqZEEjxEnhAga04PW6betl/hYBq7KHf4oN3o
         rlMGoMOQIBStRcygvdHVc5J6ekHxy/4+KjZA2zpPADzSv/BCyzeOorIIfXpXxMwAG4Sq
         k1m+ey+kEwZQKSlGqWOlLTcbb7R2OKE3hXXYGJuIOMyUR06vWgHL3kUYaWCLPzXaZCtW
         LSkE8SFFg+dQ2tSj5fKFtQHUht1eX6D8lsFWEtRDMvHizviHg1X/7mo9E5PjIxCCyVOV
         Ffeg==
X-Gm-Message-State: APjAAAWAQGNHBOwhNdX86QVeC/lRXynzPcIX+WvPjDgh2zR1TJ9TdfJK
        V2dsmG9h6YRMM3e4hktNS67OhzivNWtj6h7x5Fo+/y0bcRNVQxe8K3qHa2aY1Y0VFjTSfWBlPQ5
        QmxS4vB4FWbV0ihMw/IqW5cdmQgjP3ix0aury
X-Received: by 2002:a05:6102:7a4:: with SMTP id x4mr19901090vsg.85.1582307403748;
        Fri, 21 Feb 2020 09:50:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqwnVCxtylLMJ5CTsUdX0Qj0fK3N5l/+0PtareB4eLTXqxUvXqxMgX7hznU+R1eQMKvuaDzeR2xRqVFiio0d5I4=
X-Received: by 2002:a05:6102:7a4:: with SMTP id x4mr19901077vsg.85.1582307403425;
 Fri, 21 Feb 2020 09:50:03 -0800 (PST)
MIME-Version: 1.0
References: <20200214185942.1147742-1-preichl@redhat.com> <20200217133521.GD31012@infradead.org>
 <20200219044821.GK9506@magnolia> <20200219184019.GA10588@infradead.org>
In-Reply-To: <20200219184019.GA10588@infradead.org>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Fri, 21 Feb 2020 18:49:52 +0100
Message-ID: <CAJc7PzWVnV+ny_13rZVjEq_GMYWQciH_hWm+OXkw-OFQtn-zDg@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 7:40 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Feb 18, 2020 at 08:48:21PM -0800, Darrick J. Wong wrote:
> > > > +static inline bool
> > > > +__xfs_rwsem_islocked(
> > > > + struct rw_semaphore     *rwsem,
> > > > + bool                    shared,
> > > > + bool                    excl)
> > > > +{
> > > > + bool locked = false;
> > > > +
> > > > + if (!rwsem_is_locked(rwsem))
> > > > +         return false;
> > > > +
> > > > + if (!debug_locks)
> > > > +         return true;
> > > > +
> > > > + if (shared)
> > > > +         locked = lockdep_is_held_type(rwsem, 0);
> > > > +
> > > > + if (excl)
> > > > +         locked |= lockdep_is_held_type(rwsem, 1);
> > > > +
> > > > + return locked;
> > >
> > > This could use some comments explaining the logic, especially why we
> > > need the shared and excl flags, which seems very confusing given that
> > > a lock can be held either shared or exclusive, but not neither and not
> > > both.
> >
> > Yes, this predicate should document that callers are allowed to pass in
> > shared==true and excl==true when the caller wants to assert that either
> > lock type (shared or excl) of a given lock class (e.g. iolock) are held.
>
> Looking at the lockdep_is_held_type implementation, and our existing
> code for i_rwsem I really don't see the point of the extra shared
> check.  Something like:
>
> static inline bool
> __xfs_rwsem_islocked(
>         struct rw_semaphore     *rwsem,
>         bool                    excl)
> {
>         if (rwsem_is_locked(rwsem)) {
>                 if (debug_locks && excl)
>                         return lockdep_is_held_type(rwsem, 1);
>                 return true;
>         }
>
>         return false;
> }
>
> should be all that we really need.
>

You don't see the point of extra shared check, but if we want to check
that the semaphore is locked for reading and not writing? Having the
semaphore locked for writing would make the code safe from race
condition but could be a performance hit, right?

Thanks for comments.

