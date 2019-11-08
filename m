Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D909FA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 05:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 497072085B
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 05:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfKHFnp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 00:43:45 -0500
Received: from verein.lst.de ([213.95.11.211]:32985 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfKHFnp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Nov 2019 00:43:45 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 79A6A68BE1; Fri,  8 Nov 2019 06:43:43 +0100 (CET)
Date:   Fri, 8 Nov 2019 06:43:43 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/46] xfs: cleanup xfs_dir2_data_entsize
Message-ID: <20191108054343.GB29959@lst.de>
References: <20191107182410.12660-1-hch@lst.de> <20191107182410.12660-42-hch@lst.de> <20191108010558.GI6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108010558.GI6219@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 05:05:58PM -0800, Darrick J. Wong wrote:
> > +static inline int
> > +xfs_dir2_data_entsize(
> > +	struct xfs_mount	*mp,
> > +	int			namelen)
> 
> Why not unsigned int here?  Neither names nor entries can have negative
> length.  Other than that, looks fine...

Ok, updated.
