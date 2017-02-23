Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145811.6zhb32dh2fj5kr7l@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mail.kernel.org ([198.145.29.136]:39418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750952AbdBWKPW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Feb 2017 05:15:22 -0500
Date: Thu, 23 Feb 2017 02:15:19 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [f2fs-dev] [PATCH] vfs: hoist {XFS, EXT4}_IOC_{GOING, SHUT}DOWN
 to the VFS
Message-ID: <20170223101518.GA1769@jaegeuk.local>
References: <20170223075230.GB5837@birch.djwong.org>
 <e8ce1e4a-3333-39d1-b9bd-1464512aa125@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8ce1e4a-3333-39d1-b9bd-1464512aa125@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chao Yu <yuchao0@huawei.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>, Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net

Hello,

On 02/23, Chao Yu wrote:
> Hi Darrick,
> 
> On 2017/2/23 15:52, Darrick J. Wong wrote:
> > ext4 and XFS expose the same shutdown ioctl with the same parameters,
> > so let's hoist the whole mess into the vfs headers.
> 
> Could you cover f2fs in this patch since f2fs has already supported SHUTDOWN ioctl?

It's funny that I submitted a similar patch two years ago along with f2fs
support.

https://patchwork.kernel.org/patch/5814991/

Thanks,
