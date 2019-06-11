Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:36485 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727549AbfFKP7e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:59:34 -0400
Date: Tue, 11 Jun 2019 11:59:25 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
Message-ID: <20190611155925.GA5081@mit.edu>
References: <20190611153916.13360-1-amir73il@gmail.com>
 <20190611153916.13360-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611153916.13360-2-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 06:39:16PM +0300, Amir Goldstein wrote:
> Depending on filesystem, copying from active swapfile may be allowed,
> just as read from swapfile may be allowed.
> 
> Note the kernel fix commit in test description.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> 
> Per your and Ted's request, I've documented the kernel fix commit
> in the new copy_range tests. Those commits are now on Darrick's
> copy-file-range-fixes branch, which is on its way to linux-next
> and to kernel 5.3.

Thanks!  Are we sure at this point that the commit won't need to be
modified / rebased in Darrick's tree?

> +# This is a regression test for kernel commit:
> +#   a31713517dac ("vfs: introduce generic_file_rw_checks()")

					 - Ted
