Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1791C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 05:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD0DC61420
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 05:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhDUF5E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 01:57:04 -0400
Received: from verein.lst.de ([213.95.11.211]:53009 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230343AbhDUF5D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 01:57:03 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 691A868BFE; Wed, 21 Apr 2021 07:56:29 +0200 (CEST)
Date:   Wed, 21 Apr 2021 07:56:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH 3/7] xfs: pass a xfs_efi_log_item to xfs_efi_item_sizeof
Message-ID: <20210421055628.GB28961@lst.de>
References: <20210419082804.2076124-1-hch@lst.de> <20210419082804.2076124-4-hch@lst.de> <20210420170952.GI3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420170952.GI3122264@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 20, 2021 at 10:09:52AM -0700, Darrick J. Wong wrote:
> On Mon, Apr 19, 2021 at 10:28:00AM +0200, Christoph Hellwig wrote:
> > xfs_efi_log_item only looks at the embedded xfs_efi_log_item structure,
> > so pass that directly and rename the function to xfs_efi_log_item_sizeof.
> > This allows using the helper in xlog_recover_efi_commit_pass2 as well.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_extfree_item.c | 15 +++++++--------
> >  1 file changed, 7 insertions(+), 8 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > index ed8d0790908ea7..7ae570d1944590 100644
> > --- a/fs/xfs/xfs_extfree_item.c
> > +++ b/fs/xfs/xfs_extfree_item.c
> > @@ -70,11 +70,11 @@ xfs_efi_release(
> >   * structure.
> >   */
> >  static inline int
> > -xfs_efi_item_sizeof(
> > -	struct xfs_efi_log_item *efip)
> > +xfs_efi_log_item_sizeof(
> 
> Shouldn't this be named xfs_efi_log_format_sizeof to correspond to the
> name of the structure?  Two patches from now you (re)introduce
> xfs_efi_item_sizeof that returns the size of a struct xfs_efi_log_item,
> which is confusing.

Well, that was the main reason to move these out of place, as they are
rather misnamed.
