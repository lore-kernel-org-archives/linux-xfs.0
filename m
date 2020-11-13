Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746A5C56202
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 02:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16303216C4
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 02:13:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fpq+SGHc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKMCNJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 21:13:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25175 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725965AbgKMCNI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 21:13:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605233586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=6oM1dXJozOSLVQz6gRBJs6vUBSSzAUJlN3r5T2Civp0=;
        b=Fpq+SGHcxgdx2Gucntr5NmhA/C9GXGJZsJNQEGhxbKrGP6YtBwOMsFR/PiMhFa+j9cxQAw
        i/zP0dYnvsCBbVQ6HBeIVyGxOj6GtWc2tmUdlq8l3pZP+95aQAiBPqOm3WKzqyXBYjy2gV
        W//h3PKcUXw/QBSAiDhYs2DrdIt5xpc=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-BfgJ_jOzN7WnQS7I6De0mw-1; Thu, 12 Nov 2020 21:13:04 -0500
X-MC-Unique: BfgJ_jOzN7WnQS7I6De0mw-1
Received: by mail-pg1-f198.google.com with SMTP id v2so5127370pgv.2
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2020 18:13:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6oM1dXJozOSLVQz6gRBJs6vUBSSzAUJlN3r5T2Civp0=;
        b=LaHxn9ldObJbJGWq48vemdIWh2Jf1DsJ1Ldk0NXghWfCoPUUShYetgaUywNkGb7Vbg
         0C8tNEK/U0wjhrGDElmgS18Id9S41SKO+jBLrq3/J1l/8NNRbrfP9wyKT/m1e9w8aMlC
         aS92/xySnZIkKMQNongvMr9BXbn7t35giq6ZaqAYYc0hFxTyCn1mTM3+4EwQTtz4ZSLR
         yT2XuqKwizo3nRaosjWXh8jlIBw/ejYties82eB0wgtSZWEPHkNMiwMuIs/dQ3nuLHEd
         tWTozTm5FyCxEUXx7fq6GkI3x0xv89Nn6rsfmma1wC/cPKasUhwlZ0ttDMEmfQbKBYdH
         DPhg==
X-Gm-Message-State: AOAM531YPznX2GctEJQeQe2cooIWhF+AQZeajgP47IsCelIVY8uz72/G
        +ziVOFRvmByDkbwDgj/25k+lKZxERkkZestkhonNKBbHMLLafPLt0c+yaPT6OJZGTDRwYmMhVfj
        XQEHiEiV5sI8elrRdSw4C
X-Received: by 2002:a17:902:8490:b029:d6:d165:fde with SMTP id c16-20020a1709028490b02900d6d1650fdemr2195824plo.73.1605233583662;
        Thu, 12 Nov 2020 18:13:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzHEDnci5VkmW35p+GkK2tlw+enhePU4PuyWiPsmXmq5IOOlswViaz7fgp8I0I7jxwD/I/nJQ==
X-Received: by 2002:a17:902:8490:b029:d6:d165:fde with SMTP id c16-20020a1709028490b02900d6d1650fdemr2195806plo.73.1605233583359;
        Thu, 12 Nov 2020 18:13:03 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c24sm7011431pgk.34.2020.11.12.18.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 18:13:02 -0800 (PST)
Date:   Fri, 13 Nov 2020 10:12:51 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dennis Gilmore <dgilmore@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix signed calculation related to XFS_LITINO(mp)
Message-ID: <20201113021251.GA847175@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113020413.GA844372@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[ sorry for forgetting to Cc dgilmore on this reply, it would be
  much better/helpful with a "Tested-by:" for v2... Let me resend,
  sorry for annoying. ]

Hi,

On Thu, Nov 12, 2020 at 10:30:04AM -0800, Darrick J. Wong wrote:
> On Thu, Nov 12, 2020 at 09:53:53AM -0600, Eric Sandeen wrote:
> > On 11/12/20 12:30 AM, Gao Xiang wrote:
> > > Currently, commit e9e2eae89ddb dropped a (int) decoration from
> > > XFS_LITINO(mp), and since sizeof() expression is also involved,
> > > the result of XFS_LITINO(mp) is simply as the size_t type
> > > (commonly unsigned long).
> > 
> > Thanks for finding this!  Let me think through it a little.
> >  
> > > Considering the expression in xfs_attr_shortform_bytesfit():
> > >   offset = (XFS_LITINO(mp) - bytes) >> 3;
> > > let "bytes" be (int)340, and
> > >     "XFS_LITINO(mp)" be (unsigned long)336.
> > > 
> > > on 64-bit platform, the expression is
> > >   offset = ((unsigned long)336 - (int)340) >> 8 =
> > 
> > This should be >> 3, right.
> > 
> > >            (int)(0xfffffffffffffffcUL >> 3) = -1
> > > 
> > > but on 32-bit platform, the expression is
> > >   offset = ((unsigned long)336 - (int)340) >> 8 =
> > 
> > and >> 3 here as well.
> > 
> > >            (int)(0xfffffffcUL >> 3) = 0x1fffffff
> > > instead.
> > 
> > Ok.  But wow, that magical cast to (int) in XFS_LITINO isn't at
> > all clear to me.
> > 
> > XFS_LITINO() indicates a /size/ - fixing this problem by making it a
> > signed value feels very strange, but I'm not sure what would be better,
> > yet.
> 
> TBH I think this needs to be cleaned up -- what is "LITINO", anyway?
> 
> I'm pretty sure it's the size of the literal area, aka everything after
> the inode core, where the forks live?
> 
> And, uh, can these things get turned into static inline helpers instead
> of weird macros?  Separate patches, obviously.

Thanks, I've addressed all comments in these two reviews in v2:
https://lore.kernel.org/r/20201113015044.844213-1-hsiangkao@redhat.com

As for LITINO itself, btw, what would be the suggested name for this?
I'm not good at naming, and will seek time working on cleaning up this.

> 
> > 
> > > Therefore, one result is
> > >   "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
> > >   assertion failure in xfs_idata_realloc().
> > > 
> > > , which can be triggered with the following commands:
> > >  touch a;
> > >  setfattr -n user.0 -v "`seq 0 80`" a;
> > >  setfattr -n user.1 -v "`seq 0 80`" a
> > > on 32-bit platform.
> > 
> > Can you please write an xfstest for this? :)
> 
> Seconded.

Will seek time on this later as well.

> 
> If this is the fix for the corruption report that dgilmore reported on
> IRC, this should credit him as the reporter and/or tester.  Especially
> because I thought this was just a "oh I found this via code review"
> until someone else pointed out that this was actually a fix for
> something that a user hit in the field.
> 
> The difference is that we're headed towards -rc4 and I'm much more
> willing to hold up posting the xfs-5.11-merge branch to get in fixes for
> user-reported problems.

Yeah, sorry for ignoring this original bugreport, since I thought
the original bugzilla couldn't open publicly.
 https://bugzilla.redhat.com/show_bug.cgi?id=1894177

It would be better to get a "Tested-by:" tag to check the original
case for v2. :)

> 
> > > Fix it by restoring (int) decorator to XFS_LITINO(mp) since
> > > int type for XFS_LITINO(mp) is safe and all pre-exist signed
> > > calculations are correct.
> > > 
> > > Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
> > > Cc: <stable@vger.kernel.org> # 5.7+
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > > I'm not sure this is the preferred way or just simply fix
> > > xfs_attr_shortform_bytesfit() since I don't look into the
> > > rest of XFS_LITINO(mp) users. Add (int) to XFS_LITINO(mp)
> > > will avoid all potential regression at least.
> > > 
> > >  fs/xfs/libxfs/xfs_format.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > index dd764da08f6f..f58f0a44c024 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -1061,7 +1061,7 @@ enum xfs_dinode_fmt {
> > >  		sizeof(struct xfs_dinode) : \
> > >  		offsetof(struct xfs_dinode, di_crc))>  #define XFS_LITINO(mp) \
> > > -	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
> > > +	((int)((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb)))
> > 
> > If we do keep the (int) cast here we at least need a comment explaining why
> > it cannot be removed, unless there is a better way to solve the problem.
> 
> It's still weird, because "size of literal inode area" isn't a signed
> quantity because you can't have a negative size.

I'm fine with either way, since my starting point was to address
the regression of e9e2eae89ddb as I mentioned on IRC. And it can
also be simply fixed directly.

Thanks,
Gao Xiang

> 
> > I wonder if explicitly making XFS_LITINO() cast to a size_t would be
> > best, and then in xfs_attr_shortform_bytesfit() we just quickly reject
> > the query if the bytes are larger than the literal area:
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index bb128db..5588c2e 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -535,6 +535,10 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
> >         int                     maxforkoff;
> >         int                     offset;
> >  
> > +       /* Is there no chance we can fit? */
> > +       if (bytes > XFS_LITINO(mp))
> > +               return 0;
> > +
> >         /* rounded down */
> >         offset = (XFS_LITINO(mp) - bytes) >> 3;
> 
> So if LITINO is 336 and the caller asked for 350 bytes, offset will be
> negative here.  However, offset is the proposed forkoff, right?  It
> doesn't make any sense to have a negative forkoff, so I think Eric's
> (bytes > LITINO) suggestion above is correct.
> 
> This patch was hard to review because the comment for
> xfs_attr_shortform_bytesfit mentions "...the requested number of
> additional bytes", but the bytes parameter represents the total number
> of attr fork bytes we want, not a delta over what we have right now.
> Can someone please fix that comment too?
> 
> --D
> 
> > 
> > or, maybe simply:
> > 
> > -        offset = (XFS_LITINO(mp) - bytes) >> 3;
> > +        offset = (int)(XFS_LITINO(mp) - bytes) >> 3;
> > 
> > to be sure that the arithmetic doesn't get promoted to unsigned before the shift?
> > 
> > or maybe others have better ideas.
> > 
> > -Eric
> > 
> >   
> > >  /*
> > >   * Inode data & attribute fork sizes, per inode.
> > > 
> 

