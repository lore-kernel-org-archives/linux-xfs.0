Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF6AC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 01:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbiADBoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jan 2022 20:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiADBoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jan 2022 20:44:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D60C061761
        for <linux-xfs@vger.kernel.org>; Mon,  3 Jan 2022 17:44:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E43826123B
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 01:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B655C36AEE;
        Tue,  4 Jan 2022 01:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641260693;
        bh=42tys9VKjA/fpdwHidNN5IwGI6Tmkx2IqurtFRQnQec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bBEBnIFBkF30n7N0hOPPeneWXMdwS2lqSCUpcnaL+RKGyUK12/9pDGoo7zegFv4gk
         5HAEnZBxWmiUFgOcIWvyb4m/6KtcCw9QcJmgnVotBNEBOKvRe5P7t4/Wtne+J28/rU
         6x10nWmm+sT4eTV5z4LHrzDxgZI+mVHERr7WX8qC54KdrP6aXa7uwSAk1KdkdFufip
         Eu03IlTARLIVVcj+BOkXKpVh3KIFCd07wdUyztKe7gA60+2MetaRMVOGJzOspltPls
         MJqX8DJdjj/1WlIzMeCSX3DJsiLlwxZRLirr8SBVq+qmv9QvbwKy9wkYl2kU/kRO8l
         bDcjBhBU2KUsw==
Date:   Mon, 3 Jan 2022 17:44:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: [PATCH] design: fix computation of buffer log item bitmap size
Message-ID: <20220104014452.GC31606@magnolia>
References: <20211110015820.GX24307@magnolia>
 <87o857rh2g.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o857rh2g.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 23, 2021 at 11:36:15AM +0530, Chandan Babu R wrote:
> On 10 Nov 2021 at 07:28, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Wengang Wang was trying to work through a buffer log item by consulting
> > the ondisk format documentation, and was confused by the formula given
> > in section 14.3.14 regarding the size of blf_data_map, aka the dirty
> > bitmap for buffer log items.  We noticed that the documentation doesn't
> > match what the kernel actually does, so let's fix this.
> >
> > Reported-by: Wengang Wang <wen.gang.wang@oracle.com>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  .../journaling_log.asciidoc                        |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/design/XFS_Filesystem_Structure/journaling_log.asciidoc b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> > index 1dba56e..894d3e5 100644
> > --- a/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> > +++ b/design/XFS_Filesystem_Structure/journaling_log.asciidoc
> > @@ -992,7 +992,7 @@ The size of +blf_data_map+, in 32-bit words.
> >  This variable-sized array acts as a dirty bitmap for the logged buffer.  Each
> >  1 bit represents a dirty region in the buffer, and each run of 1 bits
> >  corresponds to a subsequent log item containing the new contents of the buffer
> > -area.  Each bit represents +(blf_len * 512) / (blf_map_size * NBBY)+ bytes.
> > +area.  Each bit represents +(blf_len * 512) / (blf_map_size * sizeof(unsigned int) * NBBY)+ bytes.
> >  
> >  [[Buffer_Data_Log_Item]]
> >  === Buffer Data Log Item
> 
> The calculation looks correct. However, wouldn't it be better to mention,
> 
> "Each bit represents XFS_BLF_CHUNK (i.e. 128) bytes"
> 
> ... or some such variant involving XFS_BLF_CHUNK.

Ok.

--D

> 
> -- 
> chandan
