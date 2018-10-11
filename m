Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbeJKNGa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Oct 2018 09:06:30 -0400
Date: Thu, 11 Oct 2018 07:40:50 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [GIT PULL] xfs: fixes for v4.19-rc7
Message-ID: <20181011054050.GB18271@kroah.com>
References: <20181010235534.GA8838@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181010235534.GA8838@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Thu, Oct 11, 2018 at 10:55:34AM +1100, Dave Chinner wrote:
> Hi Greg,
> 
> Can you please pull the XFS update from the tag listed below? This
> contains the fix for the clone_file_range data corruption issue I
> mentioned in my -rc6 pull request (zero post-eof blocks), as well as
> fixes for several other equally serious problems we found while
> auditing the clone/dedupe ioctls for other issues. The rest of the
> problems we found (there were a *lot*) will be addressed in the 4.20
> cycle.
> 
> Cheers,
> 
> Dave.
> 
> The following changes since commit e55ec4ddbef9897199c307dfb23167e3801fdaf5:
> 
>   xfs: fix error handling in xfs_bmap_extents_to_btree (2018-10-01 08:11:07 +1000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/fs/xfs/xfs-linux tags/xfs-fixes-for-4.19-rc7

Now merged, thanks.

greg k-h
