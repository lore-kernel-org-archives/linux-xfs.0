Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE96C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 13:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79EED64E16
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 13:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhBJNoz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 08:44:55 -0500
Received: from verein.lst.de ([213.95.11.211]:51232 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhBJNoy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Feb 2021 08:44:54 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id EE0636736F; Wed, 10 Feb 2021 14:44:09 +0100 (CET)
Date:   Wed, 10 Feb 2021 14:44:09 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
        darrick.wong@oracle.com, dan.j.williams@intel.com,
        david@fromorbit.com, hch@lst.de, agk@redhat.com,
        snitzer@redhat.com, rgoldwyn@suse.de, qi.fuli@fujitsu.com,
        y-goto@fujitsu.com
Subject: Re: [PATCH v3 10/11] xfs: Implement ->corrupted_range() for XFS
Message-ID: <20210210134409.GF30109@lst.de>
References: <20210208105530.3072869-1-ruansy.fnst@cn.fujitsu.com> <20210208105530.3072869-11-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208105530.3072869-11-ruansy.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


> +	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
> +	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))) {
> +		// TODO check and try to fix metadata
> +		rc = -EFSCORRUPTED;
> +		xfs_force_shutdown(cur->bc_mp, SHUTDOWN_CORRUPT_META);

Just return early here so that we can avoid the else later.

> +		/*
> +		 * Get files that incore, filter out others that are not in use.
> +		 */
> +		rc = xfs_iget(cur->bc_mp, cur->bc_tp, rec->rm_owner,
> +			      XFS_IGET_INCORE, 0, &ip);

Can we rename rc to error?

> +		if (rc || !ip)
> +			return rc;

No need to check for ip here.

> +		if (!VFS_I(ip)->i_mapping)
> +			goto out;

This can't happen either.

> +
> +		mapping = VFS_I(ip)->i_mapping;
> +		if (IS_DAX(VFS_I(ip)))
> +			rc = mf_dax_mapping_kill_procs(mapping, rec->rm_offset,
> +						       *flags);
> +		else {
> +			rc = -EIO;
> +			mapping_set_error(mapping, rc);
> +		}

By passing the method directly to the DAX device we should never get
this called for the non-DAX case.
