Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B140BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 12:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61CD764FE0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 12:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhCKMae (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 07:30:34 -0500
Received: from verein.lst.de ([213.95.11.211]:40787 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233084AbhCKMaJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Mar 2021 07:30:09 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 98CCA68B05; Thu, 11 Mar 2021 13:30:03 +0100 (CET)
Date:   Thu, 11 Mar 2021 13:30:02 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org,
        darrick.wong@oracle.com, dan.j.williams@intel.com,
        willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        david@fromorbit.com, hch@lst.de, rgoldwyn@suse.de
Subject: Re: [RESEND PATCH v2.1 07/10] iomap: Introduce iomap_apply2() for
 operations on two files
Message-ID: <20210311123002.GA18838@lst.de>
References: <20210226002030.653855-8-ruansy.fnst@fujitsu.com> <20210304054142.1147895-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304054142.1147895-1-ruansy.fnst@fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 04, 2021 at 01:41:42PM +0800, Shiyang Ruan wrote:
> Some operations, such as comparing a range of data in two files under
> fsdax mode, requires nested iomap_open()/iomap_end() on two file.  Thus,
> we introduce iomap_apply2() to accept arguments from two files and
> iomap_actor2_t for actions on two files.

I still wonder if adding the iter based iomap API that willy proposed
would be a better fit here.  In that case we might not even need
a special API for the double iteration.
