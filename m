Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF77C19F2C
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Aug 2022 21:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233797AbiHAVNM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Aug 2022 17:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiHAVNL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Aug 2022 17:13:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B4717E09;
        Mon,  1 Aug 2022 14:13:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA49F611C5;
        Mon,  1 Aug 2022 21:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FC7C433D6;
        Mon,  1 Aug 2022 21:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659388388;
        bh=MRb0LW2uoy4/4LXJB4zr4kkfNVeM+rOLFCCS3vbYaq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bDupovY75NbqS34P5QGdH5b40ya0Yxb24REzFSpHaBQxtA2SijyvCQA/kKnpF6ipu
         nLmcLpzB2Ey2R63fj0ymC92XPsN6Fk4sLw2nm31FO8WFLr4iLIF+vnM1gB9EQHmUmT
         Xhu95Y2uH3uY2rrsPEQf5ZSK3ziPTMAV0z3BM5ZfYaWFVKkrYOs/iozgG+83p6y0ir
         Xty7LNoK0LG7J4nW+ukOc0SMl1zzjL8lqQD/B5LkypB17XBB2iyJhvwRGNsIMf7mBM
         zEcl5+t9qBZ/kyTJD24rBPWuCvpmfaqCh9z6D1+G8Kf9aWwpFpiijPB4xYIWweDoN2
         Rqcd/VyCQTqdw==
Date:   Mon, 1 Aug 2022 14:13:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] fail_make_request: teach helpers about external
 devices
Message-ID: <YuhB44OEEnmvd8vM@magnolia>
References: <165886493457.1585218.32410114728132213.stgit@magnolia>
 <165886494578.1585218.6398445606846645392.stgit@magnolia>
 <YuLdQC7dh6stnIbm@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuLdQC7dh6stnIbm@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 28, 2022 at 12:02:24PM -0700, Christoph Hellwig wrote:
> Ah, and this adds the per-bdev helpers.  So this looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> I can add an incremental patch to convert btrfs/271

Yes please. :)

--D
