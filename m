Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A4DC433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 07:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4D9964E90
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 07:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbhBYHiT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:38:19 -0500
Received: from verein.lst.de ([213.95.11.211]:40529 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234418AbhBYHiS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Feb 2021 02:38:18 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id D893868B05; Thu, 25 Feb 2021 08:35:25 +0100 (CET)
Date:   Thu, 25 Feb 2021 08:35:25 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Ruan Shiyang <ruansy.fnst@cn.fujitsu.com>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, darrick.wong@oracle.com,
        dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
        viro@zeniv.linux.org.uk, linux-btrfs@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, david@fromorbit.com, rgoldwyn@suse.de,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 5/7] fsdax: Dedup file range to use a compare function
Message-ID: <20210225073525.GA3448@lst.de>
References: <20210207170924.2933035-1-ruansy.fnst@cn.fujitsu.com> <20210207170924.2933035-6-ruansy.fnst@cn.fujitsu.com> <20210208151920.GE12872@lst.de> <9193e305-22a1-3928-0675-af1cecd28942@cn.fujitsu.com> <20210209093438.GA630@lst.de> <79b0d65c-95dd-4821-e412-ab27c8cb6942@cn.fujitsu.com> <20210210131928.GA30109@lst.de> <b00cfda5-464c-6161-77c6-6a25b1cc7a77@cn.fujitsu.com> <20210218162018.GT7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218162018.GT7193@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 08:20:18AM -0800, Darrick J. Wong wrote:
> > I think a nested call like this is necessary.  That's why I use the open
> > code way.
> 
> This might be a good place to implement an iomap_apply2() loop that
> actually /does/ walk all the extents of file1 and file2.  There's now
> two users of this idiom.

Why do we need a special helper for that?

> (Possibly structured as a "get next mappings from both" generator
> function like Matthew Wilcox keeps asking for. :))

OTOH this might be a good first use for that.
