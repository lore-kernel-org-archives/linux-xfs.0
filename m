Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932555AbdDGJ0X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Apr 2017 05:26:23 -0400
Date: Fri, 7 Apr 2017 17:26:16 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic: test FIEMAP on extended attribute blocks
Message-ID: <20170407092616.GT22845@eguan.usersys.redhat.com>
References: <20170406160130.GX4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170406160130.GX4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Thu, Apr 06, 2017 at 09:01:30AM -0700, Darrick J. Wong wrote:
> Make sure that FIEMAP produces some output when we add enough xattrs
> to force the xattrs to be stored in an external block.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Test itself looks fine to me. But given that there's disagreement on
fiemap on xattr (still an reasonable test?) and test crashes debug built
& 512b block size XFS, I'll hold this test for now.

Thanks,
Eryu
