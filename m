Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55990 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751898AbdIVOkA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Sep 2017 10:40:00 -0400
Subject: Re: [PATCH] xfs: Capture state of the right inode in xfs_iflush_done
References: <20170922113555.17711-1-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e7c35561-3961-d0ec-ac8c-7430934e4cf6@sandeen.net>
Date: Fri, 22 Sep 2017 09:39:59 -0500
MIME-Version: 1.0
In-Reply-To: <20170922113555.17711-1-cmaiolino@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org



On 9/22/17 6:35 AM, Carlos Maiolino wrote:
> My previous patch: d3a304b6292168b83b45d624784f973fdc1ca674 check for
> XFS_LI_FAILED flag xfs_iflush done, so the failed item can be properly
> resubmitted.
> 
> In the loop scanning other inodes being completed, it should check the
> current item for the XFS_LI_FAILED, and not the initial one.
> 
> The state of the initial inode is checked after the loop ends
> 
> Kudos to Eric for catching this.

Coverity, actually, I'm just the messenger.

Fixes-coverity-id: 1417838

-Eric

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_inode_item.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 6d0f74ec31e8..015e8ee793a3 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -745,7 +745,7 @@ xfs_iflush_done(
>  		 */
>  		iip = INODE_ITEM(blip);
>  		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
> -		    lip->li_flags & XFS_LI_FAILED)
> +		    blip->li_flags & XFS_LI_FAILED)
>  			need_ail++;
>  
>  		blip = next;
> 
