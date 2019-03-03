Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:45204 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726626AbfCCVLN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Mar 2019 16:11:13 -0500
Date: Mon, 4 Mar 2019 08:11:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/8] add generic interface to set/get project
Message-ID: <20190303211102.GP23020@dastard>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>

On Fri, Mar 01, 2019 at 11:05:33PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> Currently, Filesystem use FS_IOC_FS_SETXATTR ioctl
> to change project ID of file. However we don't
> support ioctl on symlink files, and it is desirable
> to change symlink files' project ID just like uid/gid.
> 
> This patch try to reuse existed interface fchownat(),
> use group id to set project ID if flag AT_FCHOWN_PROJID
> passed in.
> 
> Also extend statx() calles to get symlink files' project
> ID and inherit attribute.

I'll mention the generic book-keeping stuff here:

- Series needs to be cc'd to linux-api@vger.kernel.org
- commit messages should be formatted similar to email. i.e. line
  wrap at 68-72 columns, not 50
- all of the patches have duplicate "From:" lines in the commit
  message.
- most of the patches are missing commit messages.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
