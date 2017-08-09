Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46440 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750798AbdHIGb1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Aug 2017 02:31:27 -0400
Subject: Re: [PATCH 1/3] xfs: clear MS_ACTIVE after finishing log recovery to
 avoid inode leak
References: <20170809010444.GR24087@magnolia>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <216378c1-b182-cf4f-1888-855cc58ccb64@suse.com>
Date: Wed, 9 Aug 2017 09:31:24 +0300
MIME-Version: 1.0
In-Reply-To: <20170809010444.GR24087@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>



On  9.08.2017 04:04, Darrick J. Wong wrote:
> Way back when we established inode block-map redo log items, it was
> discovered that we needed to prevent the VFS from evicting inodes during
> log recovery because any given inode might be have bmap redo items to
> replay even if the inode has no link count and is ultimately deleted,
> and any eviction of an unlinked inode causes the inode to be truncated
> and freed too early.
> 
> To make this possible, we set MS_ACTIVE so that inodes would not be torn
> down immediately upon release.  Unfortunately, this also results in the
> quota inodes not being released at all if a later part of the mount
> process should fail, because we never reclaim the inodes.  So, clear
> MS_ACTIVE immediately after we finish the log recovery so that the quota
> inodes will be torn down properly if we abort the mount.
> 
> Fixes: 17c12bcd30 ("xfs: when replaying bmap operations, don't let unlinked inodes get reaped")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I think the whole series warrants:
Cc: <stable@vger.kernel.org> # 4.9

