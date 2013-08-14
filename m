Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2901D7F6D
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 15:00:26 -0500 (CDT)
Message-ID: <520BE1FF.10403@sgi.com>
Date: Wed, 14 Aug 2013 15:01:03 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/002, another send regression test
References: <1376334802-18960-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1376334802-18960-1-git-send-email-jbacik@fusionio.com>
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

On 08/12/2013 02:13 PM, Josef Bacik wrote:
> This is a regression test for a problem we had where we'd assume we had created
> a directory if it only had subvols inside of it.  This was happening because
> subvols would have lower inode numbers than our current send progress because
> their inode numbers are based off of a different counter.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>   tests/btrfs/002     |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/002.out |    2 +
>   tests/btrfs/group   |    1 +
>   3 files changed, 88 insertions(+), 0 deletions(-)
>   create mode 100755 tests/btrfs/002
>   create mode 100644 tests/btrfs/002.out

Thanks for the patch Josef, this has been committed:

commit 6ef348f857ee2912b034ab0148bab7cdb814c0e7
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Mon Aug 12 19:13:22 2013 +0000

     xfstests: btrfs/008, another send regression test

     This is a regression test for a problem we had where we'd assume we 
had created
     a directory if it only had subvols inside of it.  This was 
happening because
     subvols would have lower inode numbers than our current send 
progress because
     their inode numbers are based off of a different counter.  Thanks,

     Signed-off-by: Josef Bacik <jbacik@fusionio.com>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

     [rjohnston: renumbered test from 002 to 008]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
