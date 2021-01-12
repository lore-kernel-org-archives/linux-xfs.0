Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE80C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 17:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA93A223E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 17:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390853AbhALROd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 12:14:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390846AbhALROc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jan 2021 12:14:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA5542311C;
        Tue, 12 Jan 2021 17:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610471632;
        bh=bgLT1+jbZqWHc2xoLDrt0ssg/wltxLREk4kn3RMZGWU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NxOve4slNuXql/v53AI9ekgZ51lp1FeVcYYWtmcO4XXsk1PU5XMJ+Z+KZoGpFK4UN
         UzaFh0a5ijfCwSQ1ZB6LEvybyJJv6TlRKJGtHrWvfJsxBTAIiBkvl11tv/rAiFADDB
         NyIC6C90PdZjoxI50UxlwnXZUiOKnkMJzevbkikTmhD1vdOLla0BmS/oJYWj4I/4+K
         6auYT8cG7AjGfjyutsNRtX1TvYuFpz3BZdfzLsTuL6uF0WD59htRAvRXFDqNYekZ2P
         GxU70TUkJSZ3bFzD+2JZ7X60lo3SML+8jJL2igEYLbHoobmRo6S+LGvmyoEqTxE2KL
         rcJimAwGdGaQA==
Date:   Tue, 12 Jan 2021 09:13:51 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     sandeen@sandeen.net, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_scrub: handle concurrent directory updates
 during name scan
Message-ID: <20210112171351.GP1164246@magnolia>
References: <161017371478.1142776.6610535704942901172.stgit@magnolia>
 <161017373322.1142776.5174880606166253807.stgit@magnolia>
 <87a6tev220.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6tev220.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 12, 2021 at 04:45:35PM +0530, Chandan Babu R wrote:
> 
> On 09 Jan 2021 at 11:58, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > The name scanner in xfs_scrub cannot lock a namespace (dirent or xattr)
> > and the kernel does not provide a stable cursor interface, which means
> > that we can see the same byte sequence multiple times during a scan.
> > This isn't a confusing name error since the kernel enforces uniqueness
> > on the byte sequence, so all we need to do here is update the old entry.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  scrub/unicrash.c |   16 +++++++++++++++-
> >  1 file changed, 15 insertions(+), 1 deletion(-)
> >
> >
> > diff --git a/scrub/unicrash.c b/scrub/unicrash.c
> > index de3217c2..f5407b5e 100644
> > --- a/scrub/unicrash.c
> > +++ b/scrub/unicrash.c
> > @@ -68,7 +68,7 @@ struct name_entry {
> >
> >  	xfs_ino_t		ino;
> >
> > -	/* Raw UTF8 name */
> > +	/* Raw dirent name */
> >  	size_t			namelen;
> >  	char			name[0];
> >  };
> > @@ -627,6 +627,20 @@ unicrash_add(
> >  	uc->buckets[bucket] = new_entry;
> >
> >  	while (entry != NULL) {
> > +		/*
> > +		 * If we see the same byte sequence then someone's modifying
> > +		 * the namespace while we're scanning it.  Update the existing
> > +		 * entry's inode mapping and erase the new entry from existence.
> > +		 */
> > +		if (new_entry->namelen == entry->namelen &&
> > +		    !memcmp(new_entry->name, entry->name, entry->namelen)) {
> > +			entry->ino = new_entry->ino;
> > +			uc->buckets[bucket] = new_entry->next;
> > +			name_entry_free(new_entry);
> > +			*badflags = 0;
> > +			continue;
> 
> If the above condition evaluates to true, the memory pointed to by "new_entry"
> is freed. The "continue" statement would cause the while loop to be executed
> once more. At this stage, "entry" will still have the previously held non-NULL
> value and hence the while loop is executed once more causing the invalid
> address in "new_entry" to be dereferenced.

Oops, good catch!  Will fix.

--D

> > +		}
> > +
> >  		/* Same normalization? */
> >  		if (new_entry->normstrlen == entry->normstrlen &&
> >  		    !u_strcmp(new_entry->normstr, entry->normstr) &&
> 
> 
> --
> chandan
