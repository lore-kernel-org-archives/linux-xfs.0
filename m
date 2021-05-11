Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00348C433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 02:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDB35616E9
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 02:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhEKCfp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 22:35:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229628AbhEKCfp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 May 2021 22:35:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D7636008E;
        Tue, 11 May 2021 02:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620700479;
        bh=z1RNdnscfnLJe9wYV2Wx7iWNJkpwGMnDaSFAaC+Fpow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QBlnTW+DyQpeWukO7S2hnBRjMpuUKP9JrN+MAqQgnpl1XQN0eqOyRCXfG9hRvRlnp
         Aq7YAscKrmjouuC/T7bnWCYWdNLeqM9NEkZsMtDoydfFXgJOS70IAnh6qDPUQjUrOR
         QNKY4fCTpQHJQXTEXyrh1g/1vrRDCZaS12IRLsgy/B2d0IC4BWriqhxFoETyn2RW5f
         XuuYlFPEuVA88b7wMRQrWbrfJ3Ik2eEAxs1WxWazo3SUFU+4bGHyuLpd6DOyihQ7bC
         9hEytx65j5qq5M7cBHxv2GP2UTSsSF24gPQWPEGWVi7CvAU4uPFp897n91qyTjiiwk
         lxhDyOCRYwxzg==
Date:   Mon, 10 May 2021 19:34:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Zorro Lang <zlang@redhat.com>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH v4 1/3] common/xfs: add _require_xfs_scratch_shrink helper
Message-ID: <20210511023438.GK8582@magnolia>
References: <20210402094937.4072606-1-hsiangkao@redhat.com>
 <20210402094937.4072606-2-hsiangkao@redhat.com>
 <20210510175952.GA8558@magnolia>
 <20210511020248.GC741809@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511020248.GC741809@xiangao.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 10:02:48AM +0800, Gao Xiang wrote:
> On Mon, May 10, 2021 at 10:59:52AM -0700, Darrick J. Wong wrote:
> > On Fri, Apr 02, 2021 at 05:49:35PM +0800, Gao Xiang wrote:
> > > In order to detect whether the current kernel supports XFS shrinking.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > >  common/xfs | 14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > > 
> > > diff --git a/common/xfs b/common/xfs
> > > index 69f76d6e..c6c2e3f5 100644
> > > --- a/common/xfs
> > > +++ b/common/xfs
> > > @@ -766,6 +766,20 @@ _require_xfs_mkfs_without_validation()
> > >  	fi
> > >  }
> > >  
> > > +_require_xfs_scratch_shrink()
> > > +{
> > > +	_require_scratch
> > > +	_require_command "$XFS_GROWFS_PROG" xfs_growfs
> > > +
> > > +	_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
> > > +	. $tmp.mkfs
> > > +	_scratch_mount
> > > +	# here just to check if kernel supports, no need do more extra work
> > > +	$XFS_GROWFS_PROG -D$((dblocks-1)) "$SCRATCH_MNT" > /dev/null 2>&1 || \
> > > +		_notrun "kernel does not support shrinking"
> > 
> > I think isn't sufficiently precise -- if xfs_growfs (userspace) doesn't
> > support shrinking it'll error out with "data size XXX too small", and if
> > the kernel doesn't support shrink, it'll return EINVAL.
> 
> I'm not sure if we need to identify such 2 cases (xfsprogs doesn't support
> and/or kernel doesn't support), but if it's really needed I think I could
> update it. But I've confirmed with testing that both two cases can be
> handled with the statements above properly.
> 
> > 
> > As written, this code attempts a single-block shrink and disables the
> > entire test if that fails for any reason, even if that reason is that
> > the last block in the filesystem isn't free, or we ran out of memory, or
> > something like that.
> 
> hmm... the filesystem here is brandly new, I think at least it'd be
> considered as "the last block in the new filesystem is free". If we're
> worried that such promise could be broken, I think some other golden
> output is unstable as well (although unrelated to this.) By that time,
> I think the test script should be updated then instead. Or am I missing
> something?
> 
> If we're worried about runing out of memory, I think the whole xfstests
> could not be predictable. I'm not sure if we need to handle such case.

I'm not specifically worried about running out of memory, I'm mostly
worried that some /other/ implementation bug (or disk format variation)
will show up and triggers the _notrun, and nobody will notice that the
shrink tests quietly stop running.

--D

> > 
> > I think this needs to check the output of xfs_growfs to make the
> > decision to _notrun.
> 
> I could check some golden output such as "data size XXX too small", yet
> I still don't think we should check some cases e.g. run out of memory..
> 
> Thanks,
> Gao Xiang
> 
> > 
> > --D
> > 
> > > +	_scratch_unmount
> > > +}
> > > +
> > >  # XFS ability to change UUIDs on V5/CRC filesystems
> > >  #
> > >  _require_meta_uuid()
> > > -- 
> > > 2.27.0
> > > 
> > 
> 
