Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2BAC54FD0
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4A4720722
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgDVCe2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:34:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55124 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVCe1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:34:27 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jR5DD-00815r-17; Wed, 22 Apr 2020 02:34:07 +0000
Date:   Wed, 22 Apr 2020 03:34:07 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     ira.weiny@intel.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jeff Moyer <jmoyer@redhat.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V9 09/11] fs: Introduce DCACHE_DONTCACHE
Message-ID: <20200422023407.GH23230@ZenIV.linux.org.uk>
References: <20200421191754.3372370-1-ira.weiny@intel.com>
 <20200421191754.3372370-10-ira.weiny@intel.com>
 <20200421202519.GC6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421202519.GC6742@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 21, 2020 at 01:25:19PM -0700, Darrick J. Wong wrote:

> > DCACHE_DONTCACHE indicates a dentry should not be cached on final
> > dput().
> > 
> > Also add a helper function to mark DCACHE_DONTCACHE on all dentries
> > pointing to a specific inode when that inode is being set I_DONTCACHE.
> > 
> > This facilitates dropping dentry references to inodes sooner which
> > require eviction to swap S_DAX mode.

Explain, please.  Questions:

1) does that ever happen to directories?
2) how much trouble do we get if such inode is *NOT* evicted for, say, several
days?
