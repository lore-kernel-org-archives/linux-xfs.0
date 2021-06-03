Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E1FC47096
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 12:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 468DC6136E
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 12:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFCMdi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:33:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50313 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhFCMdi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 08:33:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622723513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w68MC0CSaql2kBMD91UtgAuOsrTLN4OAUJYz93IW8Qg=;
        b=F+esZpL3e8LChKq9WOVTGt+x41uPZGBzZ4649m8gObQal2cccy/woO7t5bTGyCnnnat10H
        jdWMfkVI+56nGTwoCKi/QCxobXV6Nl2UrUaS9xFYZ0ALcBzLErwH5oFXQqatUbiP3c/NJ6
        HHJiItui6Kz1+KOm9N5VmqwAQHGTrRE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-GHyFzociMImtdBlrM5ZSdA-1; Thu, 03 Jun 2021 08:31:52 -0400
X-MC-Unique: GHyFzociMImtdBlrM5ZSdA-1
Received: by mail-qv1-f69.google.com with SMTP id dr11-20020a05621408ebb029021e40008bd5so3463100qvb.0
        for <linux-xfs@vger.kernel.org>; Thu, 03 Jun 2021 05:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w68MC0CSaql2kBMD91UtgAuOsrTLN4OAUJYz93IW8Qg=;
        b=EutBkzZo7rQcstiVNvfPw1GEiUfxAa9ftH0rXrfAj/PDwx25ETYqgY+ZrDnLQF9XqG
         JcfmseSPHid+sumZMH9tzXnLZ6revQZy5qAVgISBY0oeLlxhcvp7RvIuPt+Uk/UNIeup
         sF25VN75vlH5qq5oX3FQ+iPxkTAbFHMOOc9cjx5QMvTMrGUAv/dF1rNE/XvzSkU9rXAB
         /qs2M4E0nS4CQYvdCPepesPz6jybROZalTCbuSRskrVp5iZeURBUzBp13S5D0C0Ajadn
         0Tw1spda6HjaBStsRvh7Byp+J045KD7MJ0omOZSiIoW7iojBZjxrzUMr6+2f6ittk2Gs
         W9Gw==
X-Gm-Message-State: AOAM533WO4W/EI6zX6OvhfykREhjZmLo/DiaTmrnbKRlGKc9E/QZl9QS
        lwFnDiFfEg9zqSvfMotTBw1Gp+4me14vybm052X4suqUIhKpxzdNQm+h5MxQfNurY5wBhcmSbeB
        ubg4jE6X4UMZDudszXNis
X-Received: by 2002:a05:6214:a89:: with SMTP id ev9mr8135512qvb.34.1622723512111;
        Thu, 03 Jun 2021 05:31:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+ARYDzfaM7zLN11gz/JCjEqlAKAWZeDri8nd4Om+pWrGZxkG6vOkuhxAVqtZ0ZEOE8xqX6Q==
X-Received: by 2002:a05:6214:a89:: with SMTP id ev9mr8135502qvb.34.1622723511917;
        Thu, 03 Jun 2021 05:31:51 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id b4sm1657793qti.43.2021.06.03.05.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 05:31:51 -0700 (PDT)
Date:   Thu, 3 Jun 2021 08:31:49 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: don't let background reclaim forget sick inodes
Message-ID: <YLjLtfDLw89A0gbS@bfoster>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
 <162268997239.2724138.6026093150916734925.stgit@locust>
 <20210603044242.GQ664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603044242.GQ664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 02:42:42PM +1000, Dave Chinner wrote:
> On Wed, Jun 02, 2021 at 08:12:52PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > It's important that the filesystem retain its memory of sick inodes for
> > a little while after problems are found so that reports can be collected
> > about what was wrong.  Don't let background inode reclamation free sick
> > inodes unless we're under memory pressure.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_icache.c |   21 +++++++++++++++++----
> >  1 file changed, 17 insertions(+), 4 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 0e2b6c05e604..54285d1ad574 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -911,7 +911,8 @@ xfs_dqrele_all_inodes(
> >   */
> >  static bool
> >  xfs_reclaim_igrab(
> > -	struct xfs_inode	*ip)
> > +	struct xfs_inode	*ip,
> > +	struct xfs_eofblocks	*eofb)
> >  {
> >  	ASSERT(rcu_read_lock_held());
> >  
> > @@ -922,6 +923,17 @@ xfs_reclaim_igrab(
> >  		spin_unlock(&ip->i_flags_lock);
> >  		return false;
> >  	}
> > +
> > +	/*
> > +	 * Don't reclaim a sick inode unless we're under memory pressure or the
> > +	 * filesystem is unmounting.
> > +	 */
> > +	if (ip->i_sick && eofb == NULL &&
> > +	    !(ip->i_mount->m_flags & XFS_MOUNT_UNMOUNTING)) {
> > +		spin_unlock(&ip->i_flags_lock);
> > +		return false;
> > +	}
> 
> Using the "eofb == NULL" as a proxy for being under memory pressure
> is ... a bit obtuse. If we've got a handful of sick inodes, then
> there is no problem with just leaving the in memory regardless of
> memory pressure. If we've got lots of sick inodes, we're likely to
> end up in a shutdown state or be unmounted for checking real soon.
> 

Agreed.. it would be nice to see more explicit logic here. Using the
existence or not of an optional parameter meant to provide various
controls is quite fragile.

> I'd just leave sick inodes around until unmount or shutdown occurs;
> lots of sick inodes means repair is necessary right now, so
> shutdown+unmount is the right solution here, not memory reclaim....
> 

That seems like a dependency on a loose correlation and rather
dangerous.. we're either assuming action on behalf of a user before the
built up state becomes a broader problem for the system or that somehow
a cascade of in-core inode problems is going to lead to a shutdown. I
don't think that is a guarantee, or even necessarily likely. I think if
we were to do something like pin sick inodes in memory indefinitely, as
you've pointed out in the past for other such things, we should at least
consider breakdown conditions and potential for unbound behavior.

IOW, if scrub decides it wants to pin sick inodes until shutdown, it
should probably implement some kind of worst case threshold where it
actually initiates shutdown based on broad health state. If we can't
reasonably define something like that, then to me that is a pretty clear
indication that an indefinite pinning strategy is probably too fragile.
OTOH, perhaps scrub has enough knowledge to implement some kind of
policy where a sick object is pinned until we know the state has been
queried at least once, then reclaim can have it? I guess we still may
want to be careful about things like how many sick objects a single
scrub scan can produce before there's an opportunity for userspace to
query status; it's not clear to me how much of an issue that might be..

In any event, this all seems moderately more involved to get right vs
what the current patch proposes. I think this patch is a reasonable step
if we can clean up the logic a bit. Perhaps define a flag that contexts
can use to explicitly reclaim or skip unhealthy inodes?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

