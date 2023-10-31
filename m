Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433DCC4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Oct 2023 16:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345451AbjJaQoL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Oct 2023 12:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346590AbjJaQoC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 12:44:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92CC10F
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 09:43:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8FCC433C7;
        Tue, 31 Oct 2023 16:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698770639;
        bh=3ihZSGpuCy0pZGpzca/totGSUjdjTTHtGxlPXQXCRCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gmOCIZguruq5YCzK+179odNpzA5RUeOqu6nMPRRwspiCt/Ux7ZNeHObOyXqXd6r9F
         Id28Rox4geUaWldKyNC1YH6amoIaNVvpaEOoVtmZlhLIwT12EMzSRXIM0N3LmeUwoz
         LGVDG3siM/WjDIa9nZRkCB342pQmSeZjODRAZ55We94OoKB1v722Geu9h/nMglu8Rs
         FuHs9FNM0n8vR8UT4UFk3WuSVC3kRdbs1zrAiws1y3Xnwnl02sSLXu3wWbJoT8mgSA
         4Gm1DaS3ACPOxF2CSwH+UjePTWAcfgsZ5NN1CXKL9wL3GHm8BmpNBNVblhjQL7W2Gp
         ZqpHMNRAzlQfw==
Date:   Tue, 31 Oct 2023 09:43:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Chandan Babu R <chandanbabu@kernel.org>,
        catherine.hoang@oracle.com, cheng.lin130@zte.com.cn,
        dan.j.williams@intel.com, dchinner@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        osandov@fb.com, ruansy.fnst@fujitsu.com
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to 22c2699cb068
Message-ID: <20231031164359.GA1041814@frogsfrogsfrogs>
References: <87fs1s3bk6.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20231031090242.GA25889@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231031090242.GA25889@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2023 at 10:02:42AM +0100, Christoph Hellwig wrote:
> Can you also pick up:
> 
> "xfs: only remap the written blocks in xfs_reflink_end_cow_extent"
> 
> ?
> 
> Also this seems to a bit of a mix of fixes for 6.7 and big stuff that
> is too late for the merge window.

If by 'big stuff' you mean the MF_MEM_PRE_REMOVE patch, then yes, I
agree that it's too late to be changing code outside xfs.  Bumping that
to 6.8 will disappoint Shiyang, regrettably.

The patchsets for realtime units refactoring and typechecked rt-helpers
(except for the xfs_rtalloc_args thing) I'd prefer to land in 6.7 for a
few reasons.  First, the blast radii are contained to the rtalloc
subsystem of xfs.  Second, I've been testing them for nearly a year now,
I think they're ready from a QA perspective.

The third selfish reason for wanting to get the xfs realtime stuff off
my plate is that my goal for 6.8 is to try to eliminate the indirect
->iomap_begin/end calls from iomap.  It'll be helpful for me to be able
to focus exclusively on that since I'd really like your help making sure
I do the transition correctly. :)

--D
