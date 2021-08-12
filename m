Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626F4C432BE
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 18:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28F6E6103A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 18:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhHLSof (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 14:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229905AbhHLSof (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 14:44:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E3FF61019;
        Thu, 12 Aug 2021 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628793850;
        bh=cZGvzIKrBe2XpCfMFvZigtXPpLXTYl9+RPEzsoVnz2M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PLilM9jGjQJDTlriU7+WWZ+BoSeqBNmyc795mQl4xNmLe1bKidHCFK3tsFvWUuEjw
         8BaCGAiwCHSIV+pVSkyQKQ8a8EVv/7EkivrZCzMssMTNaoV+/h1ZQWWf1XePYcZRLx
         b0oxvT1dMtIkMJ61HXC6N6aWX5z2weJaZ8AGwKsPez/MsvRxkngHgUP16RfxOk+rEG
         ztdk1f0ynUAlnbxCHW9RBr0/WSSLJ9iXiDb+oT9Sle4MQmJ6z2pIsqVgX3rMSqpcLD
         BVu8ToUjgzzv0+BYvzxQEoNduAVQ8t/YrRP1RmsAJIgF/iIJ25hWrRPZstvoRUfyNZ
         ooeEeAYTf9iNw==
Date:   Thu, 12 Aug 2021 11:44:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: remove the xfs_dinode_t typedef
Message-ID: <20210812184409.GV3601443@magnolia>
References: <20210812084343.27934-1-hch@lst.de>
 <20210812084343.27934-2-hch@lst.de>
 <6d28d82c-4113-3b74-c7bd-f430cf8fbfb3@redhat.com>
 <20210812171613.GT3601443@magnolia>
 <49db010a-b776-1fe8-4393-9d4a0753d6c8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49db010a-b776-1fe8-4393-9d4a0753d6c8@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 08:41:14PM +0200, Pavel Reichl wrote:
> 
> On 8/12/21 7:16 PM, Darrick J. Wong wrote:
> > On Thu, Aug 12, 2021 at 11:31:31AM +0200, Pavel Reichl wrote:
> > > On 8/12/21 10:43 AM, Christoph Hellwig wrote:
> > > >    	/*
> > > >    	 * If the size is unreasonable, then something
> > > > @@ -162,8 +162,8 @@ xfs_iformat_extents(
> > > >     */
> > > >    STATIC int
> > > >    xfs_iformat_btree(
> > > > -	xfs_inode_t		*ip,
> > > > -	xfs_dinode_t		*dip,
> > > > +	struct xfs_inode	*ip,
> > > > +	struct xfs_dinode	*dip,
> > > >    	int			whichfork)
> > > Hi,
> > > 
> > > since you are also removing xfs_inode_t I'd like to ask if it is a good idea
> > [assuming you meant xfs_dinode_t here]
> 
> Hmm, I'm sorry but I really did mean xfs_inode_t.
> 
> Since the patch is named "remove the xfs_dinode_t  typedef" removing
> xfs_dinode_t is quite expected. But removing xfs_inode_t not so much, hence
> I'm asking if I should send a patch that removes completely xfs_inode_t as
> is done for xfs_dinode_t by this very patch.
> 
> I hope I'm not missing something :-).

OH, you were referencing specifically the conversion of the xfs_inode_t
in that hunk, not the general theme of removing xfs_dinode_t.  Ok, no
worries. :)

--D

> 
> 
> > 
> > > to send a separate patch removing all other instances of xfs_inode_t? (I'm
> > > happy to do it).
> > Seems like a reasonable thing to me.
> > 
> Great, thanks!
> 
