Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E128CA9EB9
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 06:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76FC120862
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 06:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732074AbfJ2GY0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 02:24:26 -0400
Received: from verein.lst.de ([213.95.11.211]:38141 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfJ2GYZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Oct 2019 02:24:25 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AF1D568AFE; Tue, 29 Oct 2019 07:24:23 +0100 (CET)
Date:   Tue, 29 Oct 2019 07:24:23 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: refactor xfs_bmap_count_blocks using newer
 btree helpers
Message-ID: <20191029062423.GA17004@lst.de>
References: <157232185555.594704.14846501683468956862.stgit@magnolia> <157232186171.594704.2578816471579613071.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157232186171.594704.2578816471579613071.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 28, 2019 at 09:04:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Currently, this function open-codes walking a bmbt to count the extents
> and blocks in use by a particular inode fork.  Since we now have a
> function to tally extent records from the incore extent tree and a btree
> helper to count every block in a btree, replace all that with calls to
> the helpers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good with that additional comment:

Reviewed-by: Christoph Hellwig <hch@lst.de>
