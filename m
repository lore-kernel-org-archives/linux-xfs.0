Return-Path: <SRS0=TUUv=4H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F41C34047
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 17:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CD9C20801
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Feb 2020 17:32:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cW+nfZxb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgBSRcT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 12:32:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44511 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726551AbgBSRcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 12:32:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582133537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6EAIGhYQbY9GEvFaHNboMfRJuKFkwqgHovRFuDUE6uU=;
        b=cW+nfZxbh1t0QgdHSQ96bIf7YUNFA4Pewh0S5xbRfY342dGutaEzON70Ju41XpREqJNSXQ
        vURJ3OQQ1xlNfp2xJllC9kA46OucyIOq9x9eNE0u7tVV81nyjxowbcAjfLrgkDbe/05/lg
        8jvGV4I23FAH1SQL1WFfA38v88G6pb4=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-Sp8Q-kqHOZaAzyhuE2L4pw-1; Wed, 19 Feb 2020 12:32:12 -0500
X-MC-Unique: Sp8Q-kqHOZaAzyhuE2L4pw-1
Received: by mail-vs1-f69.google.com with SMTP id t3so228445vsa.18
        for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2020 09:32:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6EAIGhYQbY9GEvFaHNboMfRJuKFkwqgHovRFuDUE6uU=;
        b=YxzoHkkDofDPRZsRrt9m3xe75vvWkg3QHTlxTOhH5CHUVPH9qgpxi9PYiuRFUwK2yI
         ajmTnZq5ds673qLi81wqEjzQO/KJEr9M/cQflysH3WnF1raICp2ak8/qmBuehSogqaWF
         6jatxq8djDdX7oJbC0m3rBM9tedqbKLZy7tOn+g6lR6wituhSi+Lqsjd/3ICHjG3L8Wo
         d3mCmlyCfmUKfDIhxRuXMawdxbL/urfmDtbj3Nbxj2PEnnEmBBMKhc+dHXwES9JJQxbB
         l7Dy3U6NQBuS4eJJFPU/0iHG/bLuxgfAvX5IN32Qu0ilXqIwxuyIoe4jCGbniBPw0UtF
         t40A==
X-Gm-Message-State: APjAAAX437vGGGKOXIlB3RH6LRjF4/TWOxpspcgoxkYSM4qzDuHy1IrQ
        9qqrvmIsMUAj4N8nGYwXwQntfuCSDhxTYlOHmn8HUFmmbAExHA2aSkaR1yHI8AeFwqXlJPx+zIQ
        g+mg52uu6mvXVJmGkIV1oobGD1/bzTWsghiTu
X-Received: by 2002:a05:6102:8f:: with SMTP id t15mr14138850vsp.77.1582133529680;
        Wed, 19 Feb 2020 09:32:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqxRBkqHKBl0nWAPEZvvNNbeJsr9XEgAC3PcRdlR/Gm+M7CkYH8fP++LthIZEMayhAAw6pcoryIAc9a+VpDwnNo=
X-Received: by 2002:a05:6102:8f:: with SMTP id t15mr14138830vsp.77.1582133529466;
 Wed, 19 Feb 2020 09:32:09 -0800 (PST)
MIME-Version: 1.0
References: <20200214185942.1147742-1-preichl@redhat.com> <20200217133521.GD31012@infradead.org>
 <20200219044821.GK9506@magnolia>
In-Reply-To: <20200219044821.GK9506@magnolia>
From:   Pavel Reichl <preichl@redhat.com>
Date:   Wed, 19 Feb 2020 18:31:58 +0100
Message-ID: <CAJc7PzU48krFoaDyovAAeTc4u_-GOhUVWABf-Tj4ZNFL_-+_fg@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] xfs: Refactor xfs_isilocked()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 5:48 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Mon, Feb 17, 2020 at 05:35:21AM -0800, Christoph Hellwig wrote:
> > On Fri, Feb 14, 2020 at 07:59:39PM +0100, Pavel Reichl wrote:
> > > Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
> > > __xfs_rwsem_islocked() is a helper function which encapsulates checking
> > > state of rw_semaphores hold by inode.
> > >
> > > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > > Suggested-by: Dave Chinner <dchinner@redhat.com>
> > > Suggested-by: Eric Sandeen <sandeen@redhat.com>
> > > ---
> > >  fs/xfs/xfs_inode.c | 54 ++++++++++++++++++++++++++++++++--------------
> > >  fs/xfs/xfs_inode.h |  2 +-
> > >  2 files changed, 39 insertions(+), 17 deletions(-)
> > >
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index c5077e6326c7..3d28c4790231 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -345,32 +345,54 @@ xfs_ilock_demote(
> > >  }
> > >
> > >  #if defined(DEBUG) || defined(XFS_WARN)
> > > -int
> > > +static inline bool
> > > +__xfs_rwsem_islocked(
> > > +   struct rw_semaphore     *rwsem,
> > > +   bool                    shared,
> > > +   bool                    excl)
> > > +{
> > > +   bool locked = false;
> > > +
> > > +   if (!rwsem_is_locked(rwsem))
> > > +           return false;
> > > +
> > > +   if (!debug_locks)
> > > +           return true;
> > > +
> > > +   if (shared)
> > > +           locked = lockdep_is_held_type(rwsem, 0);
> > > +
> > > +   if (excl)
> > > +           locked |= lockdep_is_held_type(rwsem, 1);
> > > +
> > > +   return locked;
> >
> > This could use some comments explaining the logic, especially why we
> > need the shared and excl flags, which seems very confusing given that
> > a lock can be held either shared or exclusive, but not neither and not
> > both.
>
> Yes, this predicate should document that callers are allowed to pass in
> shared==true and excl==true when the caller wants to assert that either
> lock type (shared or excl) of a given lock class (e.g. iolock) are held.
>
> --D
>

Hello,

thanks for the comments.

Would code comment preceding the definition of __xfs_rwsem_islocked()
work for you?

Something like:

/* This is a helper function that encapsulates checking the state of
 * rw semaphores.
 *
 * if shared == true AND excl == true then function returns true if either
 * lock type (shared or excl) of a given semaphore are held.
 */

