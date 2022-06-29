Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8E8CCA47C
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 22:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiF2WlO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiF2WlN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 18:41:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D59A199;
        Wed, 29 Jun 2022 15:41:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9026619A3;
        Wed, 29 Jun 2022 22:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11970C34114;
        Wed, 29 Jun 2022 22:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656542471;
        bh=mYXhfv06FpBwp72IJsZx8X1ccWAAiw07HUb2Fw2vgQM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VqhkCbGCia4AckAuHtff3pAPdui7yZUQpuhRHpme2DAv+XhLto0zdvQwGLxfqlK8X
         HaSPCOAH4PjdtWCmm81G2YyAuvQzpTxn65oqzURQQEZg4u8NI30DUzi4tmfcjG4DRN
         5V/BM0inFqJ+qrZCiy1EWlK+Hrv8vdabtBQa7xWneHmTj/exOLt7dlAEwukUFiFsfj
         Ko2EKz4YC0u+OyWjdmrrrQXu9LswBBhntM2k+VB6J1B7yUbWHVouSZhgzonkqcSkCn
         0BHu/qvUHXEXlQu5I01pNsWUBgc6i/pigbD3m7hZ8EPM1nxSw0PTwyDWwPkUoJwOGX
         1pbeukbEI9N1g==
Date:   Wed, 29 Jun 2022 15:41:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs/070: filter new superblock verifier messages
Message-ID: <YrzVBs9h0lzYFvCo@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644768886.1045534.3177166462110135738.stgit@magnolia>
 <20220629041547.GO1098723@dread.disaster.area>
 <20220629091248.vtqtlk2wvqkmtxkm@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629091248.vtqtlk2wvqkmtxkm@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 05:12:48PM +0800, Zorro Lang wrote:
> On Wed, Jun 29, 2022 at 02:15:47PM +1000, Dave Chinner wrote:
> > On Tue, Jun 28, 2022 at 01:21:28PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > In Linux 5.19, the superblock verifier logging changed to elaborate on
> > > what was wrong.  Fix the xfs_repair filtering function to accomodate
> > > this development.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  common/repair |    1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > 
> > > diff --git a/common/repair b/common/repair
> > > index 463ef9db..398e9904 100644
> > > --- a/common/repair
> > > +++ b/common/repair
> > > @@ -29,6 +29,7 @@ _filter_repair()
> > >  # for sb
> > >  /- agno = / && next;	# remove each AG line (variable number)
> > >  s/(pointer to) (\d+)/\1 INO/;
> > > +s/Superblock has bad magic number.*/bad magic number/;
> > >  # Changed inode output in 5.5.0
> > >  s/sb root inode value /sb root inode /;
> > >  s/realtime bitmap inode value /realtime bitmap inode /;
> > 
> > Didn't I already fix that in commit 4c76d0ba ("xfs/070: filter the
> > bad sb magic number error")?

Ah whoops I guess we can drop this one then.

> Yes, you've added a line as below:
>   s/^Superblock has (bad magic number) 0x.*/\1/;
> which is equal to:
>   s/Superblock has bad magic number.*/bad magic number/;
> So we need to fix it again.

We .... do?

--D

> 
> > 
> > Cheers,
> > 
> > Dave.
> > 
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
