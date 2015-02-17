Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 64BD47F61
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 19:03:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E8835AC001
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 17:03:11 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Us7uzAPG6IhEV8jn for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 17:03:04 -0800 (PST)
Date: Tue, 17 Feb 2015 12:02:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 3/12] ext4: Add support FALLOC_FL_INSERT_RANGE for
	fallocate
Message-ID: <20150217010220.GH4251@dastard>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
	<1424101680-3301-4-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1424101680-3301-4-git-send-email-linkinjeon@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-man@vger.kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue, Feb 17, 2015 at 12:47:50AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This patch implements fallocate's FALLOC_FL_INSERT_RANGE for Ext4.
> 
> 1) Make sure that both offset and len are block size aligned.
> 2) Update the i_size of inode by len bytes.
> 3) Compute the file's logical block number against offset. If the computed
>    block number is not the starting block of the extent, split the extent
>    such that the block number is the starting block of the extent.
> 4) Shift all the extents which are lying bewteen [offset, last allocated extent]
>    towards right by len bytes. This step will make a hole of len bytes
>    at offset.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>

I'll leave this for the ext4 folk to review. If I don't get a review
by the time we're ready to merge the VFS and XFS code, then I'll
leave it out and let Ted merge it inhis own time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
