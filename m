Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A8FC54EE9
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Sep 2022 14:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238732AbiIEOqC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Sep 2022 10:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238701AbiIEOpk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Sep 2022 10:45:40 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463CC17AA9;
        Mon,  5 Sep 2022 07:44:42 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D3CBB68AA6; Mon,  5 Sep 2022 16:44:33 +0200 (CEST)
Date:   Mon, 5 Sep 2022 16:44:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     akpm@linux-foundation.org, djwong@kernel.org,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Jane Chu <jane.chu@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>, nvdimm@lists.linux.dev,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: Fix SB_BORN check in xfs_dax_notify_failure()
Message-ID: <20220905144433.GB6784@lst.de>
References: <166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com> <166153428094.2758201.7936572520826540019.stgit@dwillia2-xfh.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166153428094.2758201.7936572520826540019.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 26, 2022 at 10:18:01AM -0700, Dan Williams wrote:
> The SB_BORN flag is stored in the vfs superblock, not xfs_sb.

Oops, yes:

Reviewed-by: Christoph Hellwig <hch@lst.de>
