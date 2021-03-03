Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF1E4C43331
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B0B364E60
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349726AbhCDARL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:17:11 -0500
Received: from verein.lst.de ([213.95.11.211]:36143 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350566AbhCCKrX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 05:47:23 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5C59368B02; Wed,  3 Mar 2021 11:43:37 +0100 (CET)
Date:   Wed, 3 Mar 2021 11:43:36 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "jack@suse.cz" <jack@suse.cz>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "rgoldwyn@suse.de" <rgoldwyn@suse.de>
Subject: Re: [PATCH v2 09/10] fs/xfs: Handle CoW for fsdax write() path
Message-ID: <20210303104336.GA20371@lst.de>
References: <20210226002030.653855-1-ruansy.fnst@fujitsu.com> <OSBPR01MB2920500BEA2DF0D47885A8FDF4989@OSBPR01MB2920.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSBPR01MB2920500BEA2DF0D47885A8FDF4989@OSBPR01MB2920.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 09:57:48AM +0000, ruansy.fnst@fujitsu.com wrote:
> > What is the advantage of the ioemap_end handler here?  It adds another
> > indirect funtion call to the fast path, so if we can avoid it, I'd
> > rather do that.
> 
> These code were in xfs_file_dax_write().  I moved them into the iomap_end
> because the mmaped CoW need this.
> 
> I know this is not so good, but I could not find another better way. Do you
> have any ideas? 

mmaped copy is the copy_edge case?  Maybe just use different iomap_ops for
that case vs plain write?
