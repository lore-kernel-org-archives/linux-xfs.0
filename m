Return-Path: <SRS0=w6e5=56=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198B0C2BB1D
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 06:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1025206E9
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 06:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405904AbgDNGWL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Apr 2020 02:22:11 -0400
Received: from verein.lst.de ([213.95.11.211]:37600 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729270AbgDNGWJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 Apr 2020 02:22:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8BB51227A81; Tue, 14 Apr 2020 08:22:04 +0200 (CEST)
Date:   Tue, 14 Apr 2020 08:22:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     ira.weiny@intel.com
Cc:     linux-kernel@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Jeff Moyer <jmoyer@redhat.com>, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V7 2/9] fs: Remove unneeded IS_DAX() check in
 io_is_direct()
Message-ID: <20200414062204.GA23154@lst.de>
References: <20200413054046.1560106-1-ira.weiny@intel.com> <20200413054046.1560106-3-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413054046.1560106-3-ira.weiny@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 12, 2020 at 10:40:39PM -0700, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Remove the check because DAX now has it's own read/write methods and
> file systems which support DAX check IS_DAX() prior to IOCB_DIRECT on
> their own.  Therefore, it does not matter if the file state is DAX when
> the iocb flags are created.
> 
> Also remove io_is_direct() as it is just a simple flag check.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
