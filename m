Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49969 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdH3QWf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 12:22:35 -0400
Date: Wed, 30 Aug 2017 09:22:05 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't set DAX flag for v2 inodes
Message-ID: <20170830162205.GO4757@magnolia>
References: <20170830155517.GI4757@magnolia>
 <20170830161500.GA1755@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830161500.GA1755@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>

On Wed, Aug 30, 2017 at 09:15:00AM -0700, Christoph Hellwig wrote:
> How about returning an error from xfs_set_diflags for
> anything that would go into di_flags2 for v2 inodes?

I had also thought about refactoring all those xfs_ioctl_setattr_xflags
validity checks into a single separate checking function, how about that?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
