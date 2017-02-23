Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145832.6f6x7hv5uukxlkg5@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from aserp1040.oracle.com ([141.146.126.69]:46209 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbdBWQ6X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Feb 2017 11:58:23 -0500
Date: Thu, 23 Feb 2017 08:57:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [f2fs-dev] [PATCH] vfs: hoist {XFS, EXT4}_IOC_{GOING, SHUT}DOWN
 to the VFS
Message-ID: <20170223165758.GC5837@birch.djwong.org>
References: <20170223075230.GB5837@birch.djwong.org>
 <e8ce1e4a-3333-39d1-b9bd-1464512aa125@huawei.com>
 <20170223101518.GA1769@jaegeuk.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170223101518.GA1769@jaegeuk.local>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Chao Yu <yuchao0@huawei.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>, Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net

On Thu, Feb 23, 2017 at 02:15:19AM -0800, Jaegeuk Kim wrote:
> Hello,
> 
> On 02/23, Chao Yu wrote:
> > Hi Darrick,
> > 
> > On 2017/2/23 15:52, Darrick J. Wong wrote:
> > > ext4 and XFS expose the same shutdown ioctl with the same parameters,
> > > so let's hoist the whole mess into the vfs headers.
> > 
> > Could you cover f2fs in this patch since f2fs has already supported SHUTDOWN ioctl?
> 
> It's funny that I submitted a similar patch two years ago along with f2fs
> support.
> 
> https://patchwork.kernel.org/patch/5814991/

Heh, I didn't even realize that.  I'll pull f2fs into the patch shortly.

--D

> 
> Thanks,
