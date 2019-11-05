Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785E4CA9ED3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52F5820848
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 01:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfKEBw4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 20:52:56 -0500
Received: from verein.lst.de ([213.95.11.211]:42540 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbfKEBw4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Nov 2019 20:52:56 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id BEA9468BE1; Tue,  5 Nov 2019 02:52:54 +0100 (CET)
Date:   Tue, 5 Nov 2019 02:52:54 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/34] xfs: make the xfs_dir3_icfree_hdr available to
 xfs_dir2_node_addname_int
Message-ID: <20191105015254.GE32531@lst.de>
References: <20191101220719.29100-1-hch@lst.de> <20191101220719.29100-15-hch@lst.de> <20191104202523.GS4153244@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104202523.GS4153244@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 04, 2019 at 12:25:23PM -0800, Darrick J. Wong wrote:
> On Fri, Nov 01, 2019 at 03:06:59PM -0700, Christoph Hellwig wrote:
> > Return the xfs_dir3_icfree_hdr used by the helpers called from
> > xfs_dir2_node_addname_int to the main function to prepare for the
> > next round of changes.
> 
> How does this help?  Is this purely to reduce stack usage?  Or will we
> use this later to skip some xfs_dir2_free_hdr_from_disk calls?

The latter.
