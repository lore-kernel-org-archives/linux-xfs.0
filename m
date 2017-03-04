Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35172 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752042AbdCDB6z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2017 20:58:55 -0500
Received: by mail-qk0-f173.google.com with SMTP id v125so24882580qkh.2
        for <linux-xfs@vger.kernel.org>; Fri, 03 Mar 2017 17:58:54 -0800 (PST)
Message-ID: <1488592730.2997.4.camel@redhat.com>
Subject: Re: [RFC PATCH v1 11/30] fs: new API for handling i_version
From: Jeff Layton <jlayton@redhat.com>
Date: Fri, 03 Mar 2017 20:58:50 -0500
In-Reply-To: <8737etncfb.fsf@notabene.neil.brown.name>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
         <1482339827-7882-12-git-send-email-jlayton@redhat.com>
         <8737etncfb.fsf@notabene.neil.brown.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: NeilBrown <neil@brown.name>, linux-fsdevel@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Sat, 2017-03-04 at 10:55 +1100, NeilBrown wrote:
> On Wed, Dec 21 2016, Jeff Layton wrote:
> 
> > We already have inode_inc_iversion. Add inode_set_iversion,
> > inode_get_iversion, inode_cmp_iversion and inode_iversion_need_inc.
> 
> This list of added interfaces is incomplete.
> And some of these interfaces could really use some justification up
> front.
> 
> You later add a "force" parameter to inode_inc_version.
> Why not do that up front here?
> 

First, thanks to you and Bruce for having a look.

Yes, it's clear from this and the earlier emails that I didn't do
enough documentation and explanation. I'll plan to respin this when I
get a chance, and lay out the justification and discussion a bit more.

I'll also make sure the not change the API midstream like this when I
respin.

> > +
> > +/**
> > + * inode_get_iversion - read i_version for later use
> > + * @inode: inode from which i_version should be read
> > + *
> > + * Read the inode i_version counter. This should be used by callers that wish
> > + * to store the returned i_version for later comparison.
> > + */
> > +static inline u64
> > +inode_get_iversion(const struct inode *inode)
> > +{
> > +	return inode_get_iversion_raw(inode);
> > +}
> 
> I don't understand why this can use the _raw version rather than the
> _read version.
> Surely you need to know about any changes after this read.
> 

The approach here was to convert everything to a new API and have it
work much like the code works today and then to morph it into something
that only conditionally bumps the counter.

In the later implementation, yes you do need to know about changes
after the read, but in the initial implementation it doesn't matter
since the counter is bumped on every change anyway.

I'll try to do a better job laying out this rationale in follow-on
postings.
-- 
Jeff Layton <jlayton@redhat.com>
