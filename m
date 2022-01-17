Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE172C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Jan 2022 18:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbiAQSmb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Jan 2022 13:42:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233569AbiAQSma (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jan 2022 13:42:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642444950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x/Q3U/Vd6Qj9rm/nBiWqBsXqiLf/otr5/shlpSyBqHw=;
        b=NwagwQ7CzxVAhctSXfVT4YziGef7vjk8Mi0NJgfp4vlFQ41zjC43tyssKsX8cN9Cn5oqdQ
        pvmQ3j8U2RSvQDQPcN3n0CLJEsYKaEwHCWrKNzVvD+3l+C3QkJsSEoNGCqEeCjiMH6EWwT
        liLE5kSSLWkyZWLmxMmrGVMDecaE8Xw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-jZX7uvE3O4SMW6C3WOEM3w-1; Mon, 17 Jan 2022 13:42:28 -0500
X-MC-Unique: jZX7uvE3O4SMW6C3WOEM3w-1
Received: by mail-qk1-f197.google.com with SMTP id p68-20020a37a647000000b0047876d0c485so13921769qke.22
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jan 2022 10:42:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x/Q3U/Vd6Qj9rm/nBiWqBsXqiLf/otr5/shlpSyBqHw=;
        b=aZbmKYC1fhT2SOf3FUoxjK1yzwgu1iFepJEChEEBLJrzzW3BYLLK+P2JsMY9J+uOgO
         7ee1mpPRZ3dfK5nwNuA4MK8qW/8450i8PcfyeMq9C9d/1cNhdDhOwP+KhAlHWHaFxHmo
         Q9nvoX5QFB+wTfsHc1VdKZT1PRtSbzEl2w/n73erqJv+JRmVoG9XEHlnR0nWPK0VU2aT
         Tx0jgHnfu57UBVwDw4ITmGLszN4rUqLttwHV/NZ8UJmGn9YCwflUN9ies4W3oRsBDoly
         BdNyny2eeYOIR3AFW4SuGuY1OsJws8OBHfANx+MCMIUbpHVwSyxvbO+QDUnlPWSXFLsk
         0KnQ==
X-Gm-Message-State: AOAM5317rYuL33q94LQxyhb5Ys0LhQXSoDwTS/raQQlYY736344Rnacl
        IGogfaYSrOnJX7nSUILm5kUkknaYrnc7RBSMDTDfUQdtMGT10YTCkRlRRvZOC1quErFTWaSz87G
        itm1Jq2JCAHGfwRw/aWkS
X-Received: by 2002:a37:93c4:: with SMTP id v187mr15308884qkd.690.1642444948166;
        Mon, 17 Jan 2022 10:42:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwNQsRLrsq0GcLiiP9/XWDBACY0xvoBNWHeIzR9mJ4vVs3NU3QJtH9xLMhb+z99lZzn16vCpg==
X-Received: by 2002:a37:93c4:: with SMTP id v187mr15308874qkd.690.1642444947840;
        Mon, 17 Jan 2022 10:42:27 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id bj25sm1203596qkb.118.2022.01.17.10.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 10:42:27 -0800 (PST)
Date:   Mon, 17 Jan 2022 13:42:25 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Ian Kent <raven@themaw.net>, "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Miklos Szeredi <miklos@szeredi.hu>,
        David Howells <dhowells@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] vfs: check dentry is still valid in get_link()
Message-ID: <YeW4kaT5YkeG1EDZ@bfoster>
References: <164180589176.86426.501271559065590169.stgit@mickey.themaw.net>
 <YeJr7/E+9stwEb3t@zeniv-ca.linux.org.uk>
 <275358741c4ee64b5e4e008d514876ed4ec1071c.camel@themaw.net>
 <YeV+zseKGNqnSuKR@bfoster>
 <YeWZRL88KPtLWlkI@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeWZRL88KPtLWlkI@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 17, 2022 at 04:28:52PM +0000, Al Viro wrote:
> On Mon, Jan 17, 2022 at 09:35:58AM -0500, Brian Foster wrote:
> 
> > To Al's question, at the end of the day there is no rcu delay involved
> > with inode reuse in XFS. We do use call_rcu() for eventual freeing of
> > inodes (see __xfs_inode_free()), but inode reuse occurs for inodes that
> > have been put into a "reclaim" state before getting to the point of
> > freeing the struct inode memory. This lead to the long discussion [1]
> > Ian references around ways to potentially deal with that. I think the
> > TLDR of that thread is there are various potential options for
> > improvement, such as to rcu wait on inode creation/reuse (either
> > explicitly or via more open coded grace period cookie tracking), to rcu
> > wait somewhere in the destroy sequence before inodes become reuse
> > candidates, etc., but none of them seemingly agreeable for varying
> > reasons (IIRC mostly stemming from either performance or compexity) [2].
> > 
> > The change that has been made so far in XFS is to turn rcuwalk for
> > symlinks off once again, which looks like landed in Linus' tree as
> > commit 7b7820b83f23 ("xfs: don't expose internal symlink metadata
> > buffers to the vfs"). The hope is that between that patch and this
> > prospective vfs tweak, we can have a couple incremental fixes that at
> > least address the practical problem users have been running into (which
> > is a crash due to a NULL ->get_link() callback pointer due to inode
> > reuse). The inode reuse vs. rcu thing might still be a broader problem,
> > but AFAIA that mechanism has been in place in XFS on Linux pretty much
> > forever.
> 
> My problem with that is that pathname resolution very much relies upon
> the assumption that any inode it observes will *not* change its nature
> until the final rcu_read_unlock().  Papering over ->i_op->get_link reads
> in symlink case might be sufficient at the moment (I'm still not certain
> about that, though), but that's rather brittle.  E.g. if some XFS change
> down the road adds ->permission() on some inodes, you'll get the same
> problem in do_inode_permission().  We also have places where we rely upon
> 	sample ->d_seq
> 	fetch ->d_flags
> 	fetch ->d_inode
> 	validate ->d_seq
> 	...
> 	assume that inode type matches the information in flags
> 
> How painful would it be to make xfs_destroy_inode() a ->free_inode() instance?
> IOW, how far is xfs_inode_mark_reclaimable() from being callable in RCU
> callback context?  Note that ->destroy_inode() is called via
> 

As discussed on IRC, this was brought up in the earlier discussion by
Miklos. Dave expressed some concern around locking, but I'm not sure I
grok the details from reading back [1]. The implication seems to be the
lookup side would have to rcu wait on associated inodes in the destroy
side, which might be more of a concern about unconditional use of
free_inode() as opposed to more selective rcu waiting for unlinked (or
inactive) inodes. Dave would need to chime in further on that..

As it is, it looks to me that unlinked inodes unconditionally go to the
inactive queues and thus the create side (xfs_iget_cache_hit(), if we're
considering inode reuse) basically pushes on the queue and waits on the
inode state to clear. Given that, ISTM it shouldn't be that much
functional pain to introduce an rcu delay somewhere before an inactive
inode becomes reclaimable (and thus reusable).

I think the impediment to something like this has been more performance
related. An inode alloc/free workload can turn into a continuous reuse
of the same batch of inodes, over and over. Therefore an rcu wait on
iget reuse can become effectively unconditional and slow things down
quite a bit (hence my previous, untested thought around making it
conditional and potentially amortizing the cost). I had played with a
more selective grace period in the teardown side for inactive inodes via
queue_rcu_work(), since that's an easy place to inject an rcu
delay/callback, but that had some performance impact on sustained file
removal that might require retuning other bits..

Brian

[1] https://lore.kernel.org/linux-fsdevel/20211114231834.GM449541@dread.disaster.area/#t

> static void destroy_inode(struct inode *inode)
> {
> 	const struct super_operations *ops = inode->i_sb->s_op;
> 
> 	BUG_ON(!list_empty(&inode->i_lru));
> 	__destroy_inode(inode);
> 	if (ops->destroy_inode) {
> 		ops->destroy_inode(inode);
> 		if (!ops->free_inode)
> 			return;
> 	}
> 	inode->free_inode = ops->free_inode;
> 	call_rcu(&inode->i_rcu, i_callback);
> }
> 
> with
> 
> static void i_callback(struct rcu_head *head)
> {
>         struct inode *inode = container_of(head, struct inode, i_rcu);
> 	if (inode->free_inode)
> 		inode->free_inode(inode);
> 	else   
> 		free_inode_nonrcu(inode);
> }
> 
> IOW, ->free_inode() is RCU-delayed part of ->destroy_inode().  If both
> are present, ->destroy_inode() will be called synchronously, followed
> by ->free_inode() from RCU callback, so you can have both - moving just
> the "finally mark for reuse" part into ->free_inode() would be OK.
> Any blocking stuff (if any) can be left in ->destroy_inode()...
> 

