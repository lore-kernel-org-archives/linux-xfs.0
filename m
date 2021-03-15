Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE04C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 19:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C8D64F3F
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 19:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhCOTDV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 15:03:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232908AbhCOTDM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Mar 2021 15:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A90764E86;
        Mon, 15 Mar 2021 19:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615834992;
        bh=kqsIBFtzyVe8aqTcr4tjgV3LB2pIsqZVXiUdmXF+PSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q8InHDdwzIhZTmpEKVcYHN5U3tyLZNDVyL+q4PqqWcgO+GQ5d1nS9wShbpb2x/zUZ
         +5syVwcuOkRlua9H8G1If4FQcfoJlG1U3DSLp+vHY770naVCjLe2CDwe0GolAiIdxP
         pzysVi2uu1oOg+YPPwKZfvmy5m5vU1Ox/BZdbQousiB6XArBPrha5Ru7VtD9X/l2UK
         rnFUYZhZNbCVua8SFedJcM8Qpq6+mZ6OohrPvWkOqF1SdTggi+JOI8CEhC8R3lYP2Y
         r71e2UYPtF8W4KZBTTG9TSW+53dl1MAqRH58ObfmX4SbRAR+0HxHXXKEK2gxg0Q712
         Q/Sr6D8CpPb1w==
Date:   Mon, 15 Mar 2021 12:03:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: parallelize inode inactivation
Message-ID: <20210315190311.GE22100@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543199635.1947934.2885924822578773349.stgit@magnolia>
 <20210315185551.GF140421@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315185551.GF140421@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 15, 2021 at 06:55:51PM +0000, Christoph Hellwig wrote:
> On Wed, Mar 10, 2021 at 07:06:36PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Split the inode inactivation work into per-AG work items so that we can
> > take advantage of parallelization.
> 
> Any reason this isn't just done from the beginning?  As-is is just
> seems to create a fair amount of churn.

I felt like the first patch was already too long at 1100 lines.

I don't mind combining them, but with the usual proviso that I don't
want the whole series to stall on reviewers going back and forth on this
point without anyone offering an RVB.

--D
