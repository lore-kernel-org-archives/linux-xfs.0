Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 04BCA7F78
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 15:47:25 -0500 (CDT)
Message-ID: <520BED03.6040707@sgi.com>
Date: Wed, 14 Aug 2013 15:48:03 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/003: regression test for subvol delete V3
References: <1376510872-9951-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1376510872-9951-1-git-send-email-jbacik@fusionio.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 08/14/2013 03:07 PM, Josef Bacik wrote:
> We were allowing users to delete their default subvolume, which is problematic.
> This test is a regression test to make sure we don't let that happen in the
> future.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V2->V3: remove comment and abstract out the subvolid logic as per Eric's
>    suggestions
> V1->V2: address the comments made by Eric Sandeen.

Thanks for the patch Josef, this has been committed.

--Rich

commit f3df3fab7d3870aab222512126b06668d7db5d71
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Wed Aug 14 20:07:52 2013 +0000

     xfstests: btrfs/009: regression test for subvol delete

     We were allowing users to delete their default subvolume, which is 
problematic.
     This test is a regression test to make sure we don't let that 
happen in the
     future.  Thanks,

     Signed-off-by: Josef Bacik <jbacik@fusionio.com>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

     [rjohnston: renumbered test from 003 to 009]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
