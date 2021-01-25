Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F6EC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 23:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E50522A84
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 23:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732200AbhAYXTO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 18:19:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:35098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732860AbhAYXS6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jan 2021 18:18:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90322227BF;
        Mon, 25 Jan 2021 23:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611616697;
        bh=LSOrDkE6P+O8A6nc+88WDMq0nmD/pf/0KR/mN4NBLcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kIqcUTeu4rSPAKJP9kAXARHr8uncJJYMz06URce/Gc5oqx3qDN2GxtzYO/Ur1Ef4G
         U8r8YgGZ9WvJ2FoXHtWitMtWlTHft/llDE14iTDpJ0ZJScie+Xpjgd0kY7SUzmgOfk
         LQjqewRMDJz1cJlzqN23eOXqTv7g2NgI8ixDIdnhZUosQVzXSxwcp/bt7Dy0YZZZeB
         7ZdGM2tWjKVas9OpPoMsobRuJHSFP5ZDVSkurLbINdVPq0+0jUsaQqYIvb2b5ai34k
         VW9Lvl6/G4lyxTwhrzzJcg0X0XflED0LVne/Xmxug/sOkSymqD7sUA+h5DHNRDgJcm
         syr5nxnsWBg9Q==
Date:   Mon, 25 Jan 2021 15:18:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/3] xfs: use unbounded workqueues for parallel work
Message-ID: <20210125231816.GG7698@magnolia>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
 <161142799399.2173328.8759691345812968430.stgit@magnolia>
 <20210124095150.GF670331@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124095150.GF670331@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 24, 2021 at 09:51:50AM +0000, Christoph Hellwig wrote:
> On Sat, Jan 23, 2021 at 10:53:14AM -0800, Darrick J. Wong wrote:
> > -	pctl->wq = alloc_workqueue("%s-%d", WQ_FREEZABLE, nr_threads, tag,
> > -			current->pid);
> > +	pctl->wq = alloc_workqueue("%s-%d", WQ_UNBOUND | WQ_SYSFS | WQ_FREEZABLE,
> > +			nr_threads, tag, current->pid);
> 
> This adds an overly long line.

Changed.

> But more importantly I think xfs.txt needs to grow a section that we now
> can tune XFS parameters through the workqueue sysfs files, especially as
> right now I have no idea how to find those based on an actual device or
> XFS mount I need to adjust the parameters for.

Ok, I'll add a section.

--D
