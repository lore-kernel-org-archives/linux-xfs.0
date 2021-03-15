Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FCDC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 19:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9340064E27
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 19:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhCOTHF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 15:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232940AbhCOTGd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Mar 2021 15:06:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF3F364E27;
        Mon, 15 Mar 2021 19:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615835193;
        bh=edsYhPFMmgR1kVe/Xv0RgFwCetC2S27n3OYZNMvtz9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vFt0NZaHyuLHH5IqdTJOG1rRCaKQHeQkf/1Faitn8r1V1OBksUwTRtnPSteJgPRAC
         wBybohlSDB1h4cOnrf9qA1Z17aDPArb25uXd4aNl+lLS3p25aBMuxKHsBYi8+PasNf
         KESqjTyDtqVMQW6ADkex2wcMd8bYnNz70ITuwRBsgsufjzNcPvIzNZY2suTU4cWXWe
         C/vi3aDXBwsTN9Mb4A3A1MaWEKPta/uTV0M8HgLjy0kGvJVaCiMb2LPCHelnuc4+tI
         JF3MvIcwMt0aGY073uGjWD/oQngByPsbCzC444vTf2d98omeZ1LBLDDwG3WsO5No4y
         x2HXOfGOIE5vw==
Date:   Mon, 15 Mar 2021 12:06:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: decide if inode needs inactivation
Message-ID: <20210315190632.GG22100@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543196269.1947934.4125444770307830204.stgit@magnolia>
 <20210315184741.GC140421@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315184741.GC140421@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 15, 2021 at 06:47:41PM +0000, Christoph Hellwig wrote:
> On Wed, Mar 10, 2021 at 07:06:02PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a predicate function to decide if an inode needs (deferred)
> > inactivation.  Any file that has been unlinked or has speculative
> > preallocations either for post-EOF writes or for CoW qualifies.
> > This function will also be used by the upcoming deferred inactivation
> > patch.
> 
> The helper looks good, but I'd just merge it into patch 6, without
> that is isn't very helpful.

Done.

--D
