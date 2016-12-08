Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932359AbcLHDcx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 22:32:53 -0500
Date: Thu, 8 Dec 2016 11:32:50 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to a444d72e6090
Message-ID: <20161208033250.GD29149@eguan.usersys.redhat.com>
References: <20161207202501.GK4326@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161207202501.GK4326@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave,

On Thu, Dec 08, 2016 at 07:25:01AM +1100, Dave Chinner wrote:
> Hi folks,
> 
> The for-next branch of the xfs kernel repository at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> 
> has just been updated. This update contains a bunch of verification
> enhancments to detect field corruptions as metadata is read from
> disk, faster CRC calculations, a faster buffer cache indexing
> structure and some cleanups.
> 
> With the merge window likely to open next week, this may be the last
> update for the 4.10-rc1 cycle.  Let me know if there's anything
> critical that I've missed for 4.10 so I can sort it out before the
> end of the week.

I didn't see patch "xfs: use xfs_vn_setattr_size to check on new size"
was included in this update nor folded into other commits, do you want
to take it for 4.10?

http://www.spinics.net/lists/linux-xfs/msg02529.html

Thanks,
Eryu
