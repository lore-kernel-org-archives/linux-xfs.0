Return-Path: <SRS0=V0Y3=4A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20794C3F68F
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 16:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC112082F
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Feb 2020 16:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgBLQKn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Feb 2020 11:10:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:30528 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbgBLQKn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Feb 2020 11:10:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Feb 2020 08:10:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,433,1574150400"; 
   d="scan'208";a="266718994"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga002.fm.intel.com with ESMTP; 12 Feb 2020 08:10:41 -0800
Date:   Wed, 12 Feb 2020 08:10:42 -0800
From:   Ira Weiny <ira.weiny@intel.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 06/12] fs/xfs: Check if the inode supports DAX under
 lock
Message-ID: <20200212161041.GE20214@iweiny-DESK2.sc.intel.com>
References: <20200208193445.27421-1-ira.weiny@intel.com>
 <20200208193445.27421-7-ira.weiny@intel.com>
 <20200211061639.GH10776@dread.disaster.area>
 <20200211175509.GD12866@iweiny-DESK2.sc.intel.com>
 <20200211204220.GN10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211204220.GN10776@dread.disaster.area>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 12, 2020 at 07:42:20AM +1100, Dave Chinner wrote:
> On Tue, Feb 11, 2020 at 09:55:09AM -0800, Ira Weiny wrote:
> > On Tue, Feb 11, 2020 at 05:16:39PM +1100, Dave Chinner wrote:
> > > On Sat, Feb 08, 2020 at 11:34:39AM -0800, ira.weiny@intel.com wrote:
> > > > From: Ira Weiny <ira.weiny@intel.com>
> > > > 

[snip]

> > > 
> > > This raciness in checking the DAX flags is the reason that
> > > xfs_ioctl_setattr_xflags() redoes all the reflink vs dax checks once
> > > it's called under the XFS_ILOCK_EXCL during the actual change
> > > transaction....
> > 
> > Ok I found this by trying to make sure that the xfs_inode_supports_dax() call
> > was always returning valid data.  So I don't have a specific test which was
> > failing.
> > 
> > Looking at the code again, it sounds like I was wrong about which locks protect
> > what and with your explanation above it looks like there is nothing to be done
> > here and I can drop the patch.
> > 
> > Would you agree?
> 
> *nod*

Thanks! done.
Ira

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
