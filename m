Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B05CC4167B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAB7C206C1
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 16:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgLGQbu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Dec 2020 11:31:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27307 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbgLGQbu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 11:31:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607358623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bJg6A70oFBCYcS7UIcDzd5kK+7fQdugMuHcHn8u5V8A=;
        b=TtHVSGW339snR0hkVG1TGvAYibx3fUsDWT55TwvvYAS80ikaUmp8BHDTqOXxp3bjAvDaBP
        MqZVpSQLlp5ksJyNjHJOyxvntjaUEe5FiysKicVo/C0h8QH5QAHIcoj3Jq1o0766VyZRHv
        9J30xBZKoBBjL9i3k5O4FdN+21BNWaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-NdUDc7L-NyqAPmZxR8780w-1; Mon, 07 Dec 2020 11:30:21 -0500
X-MC-Unique: NdUDc7L-NyqAPmZxR8780w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B189107ACE3;
        Mon,  7 Dec 2020 16:30:20 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 06EC210016F5;
        Mon,  7 Dec 2020 16:30:19 +0000 (UTC)
Date:   Mon, 7 Dec 2020 11:30:18 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: initialise attr fork on inode create
Message-ID: <20201207163018.GD1585352@bfoster>
References: <20201202232724.1730114-1-david@fromorbit.com>
 <20201204123137.GA1404170@bfoster>
 <20201204212222.GG3913616@dread.disaster.area>
 <20201205113444.GA1485029@bfoster>
 <20201206233322.GK3913616@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206233322.GK3913616@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 07, 2020 at 10:33:22AM +1100, Dave Chinner wrote:
> On Sat, Dec 05, 2020 at 06:34:44AM -0500, Brian Foster wrote:
> > On Sat, Dec 05, 2020 at 08:22:22AM +1100, Dave Chinner wrote:
> > > On Fri, Dec 04, 2020 at 07:31:37AM -0500, Brian Foster wrote:
> > > > On Thu, Dec 03, 2020 at 10:27:24AM +1100, Dave Chinner wrote:
> > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > > index 2bfbcf28b1bd..9ee2e0b4c6fd 100644
> > > > > --- a/fs/xfs/xfs_inode.c
> > > > > +++ b/fs/xfs/xfs_inode.c
> > > > ...
> > > > > @@ -918,6 +919,18 @@ xfs_ialloc(
> > > > >  		ASSERT(0);
> > > > >  	}
> > > > >  
> > > > > +	/*
> > > > > +	 * If we need to create attributes immediately after allocating the
> > > > > +	 * inode, initialise an empty attribute fork right now. We use the
> > > > > +	 * default fork offset for attributes here as we don't know exactly what
> > > > > +	 * size or how many attributes we might be adding. We can do this safely
> > > > > +	 * here because we know the data fork is completely empty right now.
> > > > > +	 */
> > > > > +	if (init_attrs) {
> > > > > +		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
> > > > > +		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> > > > > +	}
> > > > > +
> > > > 
> > > > Seems reasonable in principle, but why not refactor
> > > > xfs_bmap_add_attrfork() such that the internals (i.e. everything within
> > > > the transaction/ilock code) can be properly reused in both contexts
> > > > rather than open-coding (and thus duplicating) a somewhat stripped down
> > > > version?
> > > 
> > > We don't know the size of the attribute that is being created, so
> > > the attr size dependent parts of it can't be used.
> > 
> > Not sure I see the problem here. It looks to me that
> > xfs_bmap_add_attrfork() would do the right thing if we just passed a
> > size of zero.
> 
> Yes, but it also does an awful lot that we do not need.
> 

Hence the suggestion to refactor it..

> > The only place the size value is actually used is down in
> > xfs_attr_shortform_bytesfit(), and I'd expect that to identify that the
> > requested size is <= than the current afork size (also zero for a newly
> > allocated inode..?) and bail out.
> 
> RIght it ends up doing that because an uninitialised inode fork
> (di_forkoff = 0) is the same size as the requested size of zero, and
> then it does ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> 
> But that's decided another two function calls deep, after a lot of
> branches and shifting and comparisons to determine that the attr
> fork is empty. Yet we already know that the attr fork is empty here
> so all that extra CPU work is completely unnecessary.
> 

xfs_bmap_add_attrfork() already asserts that the attr fork is
nonexistent at the very top of the function, for one. The 25-30 lines of
that function that we need can be trivially lifted out into a new helper
that can equally as trivially accommodate the size == 0 case and skip
all those shortform calculations.

> Keep in mind we do exactly the same thing in
> xfs_bmap_forkoff_reset(). We don't care about all the setup stuff in
> xfs_bmap_add_attrfork(), we just reset the attr fork offset to the
> default if the attr fork had grown larger than the default offset.
> 

I'm not arguing that the attr fork needs to be set up in a particular
way on initial creation. I'm arguing that we don't need yet a third
unique code path to set/initialize a default/empty attr fork. We can
slowly normalize them all to the _reset() technique you're effectively
reimplementing here if that works well enough and is preferred...

> > That said, I wouldn't be opposed to tweaking xfs_bmap_set_attrforkoff()
> > by a line or two to just skip the shortform call if size == 0. Then we
> > can be more explicit about the "size == 0 means preemptive fork alloc,
> > use the default offset" use case and perhaps actually document it with
> > some comments as well.
> 
> It just seems wrong to me to code a special case into some function
> to optimise that special case when the code that needs the special
> case has no need to call that function in the first place.....
> 

I'm not sure what's so odd or controversial about refactoring and
reusing an existing operational (i.e. add fork) function to facilitate
review and future maintenance of that particular operation being
performed from new and various contexts. And speaking in generalities
like this just obfuscates and overcomplicates the argument. Let's be
clear, we're literally arguing over a delta that would look something
like this:

xfs_bmap_set_attrforkoff()
{
...
+		if (size)
-               ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
+			ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
                if (!ip->i_d.di_forkoff)
                        ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
		...
}

Given all of that, I'm not convinced this is nearly the problem you seem
to insinuate, yet I also don't think I'll convince you otherwise so it's
probably not worth continuing to debate. You have my feedback, I'll let
others determine how this patch comes together from here...

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

