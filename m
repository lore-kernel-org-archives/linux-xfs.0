Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5EFECAAD3
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Sep 2022 14:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238671AbiIEOqP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Sep 2022 10:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbiIEOp5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Sep 2022 10:45:57 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695DE40E1A;
        Mon,  5 Sep 2022 07:45:04 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 97BAE68AA6; Mon,  5 Sep 2022 16:45:01 +0200 (CEST)
Date:   Mon, 5 Sep 2022 16:45:01 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     akpm@linux-foundation.org, djwong@kernel.org,
        Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        Christoph Hellwig <hch@lst.de>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Jane Chu <jane.chu@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>, nvdimm@lists.linux.dev,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm/memory-failure: Fix detection of
 memory_failure() handlers
Message-ID: <20220905144501.GC6784@lst.de>
References: <166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com> <166153428781.2758201.1990616683438224741.stgit@dwillia2-xfh.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166153428781.2758201.1990616683438224741.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
