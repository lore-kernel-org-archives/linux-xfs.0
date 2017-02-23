Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227150156.hv5o3pcoyvv5fip4@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from szxga01-in.huawei.com ([45.249.212.187]:2835 "EHLO
        dggrg01-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751070AbdBWI4e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Feb 2017 03:56:34 -0500
Subject: Re: [PATCH] vfs: hoist {XFS,EXT4}_IOC_{GOING,SHUT}DOWN to the VFS
References: <20170223075230.GB5837@birch.djwong.org>
From: Chao Yu <yuchao0@huawei.com>
Message-ID: <e8ce1e4a-3333-39d1-b9bd-1464512aa125@huawei.com>
Date: Thu, 23 Feb 2017 16:54:47 +0800
MIME-Version: 1.0
In-Reply-To: <20170223075230.GB5837@birch.djwong.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-f2fs-devel@lists.sourceforge.net, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>

Hi Darrick,

On 2017/2/23 15:52, Darrick J. Wong wrote:
> ext4 and XFS expose the same shutdown ioctl with the same parameters,
> so let's hoist the whole mess into the vfs headers.

Could you cover f2fs in this patch since f2fs has already supported SHUTDOWN ioctl?

Thanks,

