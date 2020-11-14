Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DA5C5519F
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 13:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBC8C22254
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 13:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NJvN1isd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgKNNtU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Nov 2020 08:49:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726356AbgKNNtT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 08:49:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605361757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ug9xoD0PUa5DKevh55gCjRc+sFfYVHm5RSwAOyirBQ4=;
        b=NJvN1isdoe4OoWGgdLbyHbWV9IgGswnIRHcKoZhhM0ajHCu4xjy4iKNo5hZuJQpzqQVcGm
        fat3T78xfqJ+52kntb0anrjcBCW478MpwLU+f8d+k331yyrT42kZSCTtpGue0QzutwGfF8
        vvxMnDJJY+Tjx7VZLXg9O0bAnn3DUV8=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-fuOg20RNM9W9cbLyf2B-0Q-1; Sat, 14 Nov 2020 08:49:15 -0500
X-MC-Unique: fuOg20RNM9W9cbLyf2B-0Q-1
Received: by mail-pg1-f197.google.com with SMTP id a27so8184184pga.6
        for <linux-xfs@vger.kernel.org>; Sat, 14 Nov 2020 05:49:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ug9xoD0PUa5DKevh55gCjRc+sFfYVHm5RSwAOyirBQ4=;
        b=Uf83vhTPtK6JG3nAZTUMdt/gfDVfmPg0h7WGCZQeN9lNSMTFFuecJICSkHr6Zbp2VM
         DVS66EgxS3qEjn4RtkwCpW2r+pgdkOe8dkTqj8srJ7L0Dcdgz8bxVfkYXRkBvIpiv+Ka
         /kZERCTtq5Wjgo43/jbPoDcM1jGIW8yE7AaBWKzKh+Mg4bLiSHiEcmUGqEVNkKiLTCrj
         3yvKXr3xvjD9KTpNLlIyZrtdmS//4McpXYHkjPrS/V1M6saQjLVagfazWPBVYZTW2K5x
         YLRdsrf9+nnJ3CDFoC3NcYyJjqwsc7aqRWpjKQNfBtDOoiypcwk0/RROmSAM1gTHQpfl
         gmsw==
X-Gm-Message-State: AOAM533W0MHIGN8VmwKEO0JB5LoQ2uXU5PpqquFIu16QVvWZUUTSPTOT
        lAhYbPOKsJnrZ28mr1GWBYacmFSJlR28juUraVwqOpbcOVdoyIN2eUWZ5lzNsWW8PIBugoPizbw
        LxeMpGq1zZngbvMIk+PGV
X-Received: by 2002:a63:e757:: with SMTP id j23mr5353260pgk.301.1605361754279;
        Sat, 14 Nov 2020 05:49:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz4+MActlPhr7QdN5M+1vxo6ALwKjsGv3neTqwMdVc/Z9pAtkdCMac/51dkDE1xAezO80WBeg==
X-Received: by 2002:a63:e757:: with SMTP id j23mr5353247pgk.301.1605361753962;
        Sat, 14 Nov 2020 05:49:13 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o16sm11500381pgn.66.2020.11.14.05.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 05:49:13 -0800 (PST)
Date:   Sat, 14 Nov 2020 21:49:02 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dennis Gilmore <dgilmore@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] xfs: fix forkoff miscalculation related to
 XFS_LITINO(mp)
Message-ID: <20201114134902.GA1151199@xiangao.remote.csb>
References: <20201112063005.692054-1-hsiangkao@redhat.com>
 <20201113015044.844213-1-hsiangkao@redhat.com>
 <20201114103249.GA19866@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201114103249.GA19866@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 14, 2020 at 11:32:49AM +0100, Christoph Hellwig wrote:
> On Fri, Nov 13, 2020 at 09:50:44AM +0800, Gao Xiang wrote:
> > Currently, commit e9e2eae89ddb dropped a (int) decoration from
> > XFS_LITINO(mp), and since sizeof() expression is also involved,
> > the result of XFS_LITINO(mp) is simply as the size_t type
> > (commonly unsigned long).
> > 
> > Considering the expression in xfs_attr_shortform_bytesfit():
> >   offset = (XFS_LITINO(mp) - bytes) >> 3;
> > let "bytes" be (int)340, and
> >     "XFS_LITINO(mp)" be (unsigned long)336.
> > 
> > on 64-bit platform, the expression is
> >   offset = ((unsigned long)336 - (int)340) >> 3 =
> >            (int)(0xfffffffffffffffcUL >> 3) = -1
> > 
> > but on 32-bit platform, the expression is
> >   offset = ((unsigned long)336 - (int)340) >> 3 =
> >            (int)(0xfffffffcUL >> 3) = 0x1fffffff
> > instead.
> > 
> > so offset becomes a large positive number on 32-bit platform, and
> > cause xfs_attr_shortform_bytesfit() returns maxforkoff rather than 0.
> > 
> > Therefore, one result is
> >   "ASSERT(new_size <= XFS_IFORK_SIZE(ip, whichfork));"
> > 
> > assertion failure in xfs_idata_realloc(), which was also the root
> > cause of the original bugreport from Dennis, see:
> >    https://bugzilla.redhat.com/show_bug.cgi?id=1894177
> > 
> > And it can also be manually triggered with the following commands:
> >   $ touch a;
> >   $ setfattr -n user.0 -v "`seq 0 80`" a;
> >   $ setfattr -n user.1 -v "`seq 0 80`" a
> > 
> > on 32-bit platform.
> > 
> > Fix the case in xfs_attr_shortform_bytesfit() by bailing out
> > "XFS_LITINO(mp) < bytes" in advance suggested by Eric and a misleading
> > comment together with this bugfix suggested by Darrick. It seems the
> > other users of XFS_LITINO(mp) are not impacted.
> > 
> > Reported-by: Dennis Gilmore <dgilmore@redhat.com>
> > Fixes: e9e2eae89ddb ("xfs: only check the superblock version for dinode size calculation")
> > Cc: <stable@vger.kernel.org> # 5.7+
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > changes since v1:
> >  - fix 2 typos ">> 8" to ">> 3" mentioned by Eric;
> >  - directly bail out "XFS_LITINO(mp) < bytes" suggested
> >    by Eric and Darrick;
> >  - fix a misleading comment together suggested by Darrick;
> >  - since (int) decorator doesn't need to be added, so update
> >    the patch subject as well.
> > 
> >  fs/xfs/libxfs/xfs_attr_leaf.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index bb128db220ac..c8d91034850b 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -515,7 +515,7 @@ xfs_attr_copy_value(
> >   *========================================================================*/
> >  
> >  /*
> > - * Query whether the requested number of additional bytes of extended
> > + * Query whether the total requested number of attr fork bytes of extended
> >   * attribute space will be able to fit inline.
> >   *
> >   * Returns zero if not, else the di_forkoff fork offset to be used in the
> > @@ -535,6 +535,10 @@ xfs_attr_shortform_bytesfit(
> >  	int			maxforkoff;
> >  	int			offset;
> >  
> > +	/* there is no chance we can fit */
> 
> Maybe:
> 
> 	/* 
> 	 * Check if the new size could fit at all first:
> 	 */

ok, let me quick revise it as the next version.

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

Thanks,
Gao Xiang

> 

