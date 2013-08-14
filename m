Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CF21D7F74
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 15:26:32 -0500 (CDT)
Message-ID: <520BE81E.1040408@sgi.com>
Date: Wed, 14 Aug 2013 15:27:10 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add regression test for kernel bz 60673
References: <1375892154-11548-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1375892154-11548-1-git-send-email-jbacik@fusionio.com>
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

On 08/07/2013 11:15 AM, Josef Bacik wrote:
> There was a problem with send trying to overwrite a file that wasn't actually
> the same.  This is a test to check this particular case where receive fails when
> it should succeed properly.  I tested this to verify it fails without my fix and
> passes with my fix.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>   tests/btrfs/001     |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/001.out |    2 +
>   tests/btrfs/group   |    1 +
>   3 files changed, 113 insertions(+), 0 deletions(-)
>   create mode 100755 tests/btrfs/001
>   create mode 100644 tests/btrfs/001.out
>
Looks good but should have the btrfs folks look at this.

Note: The btrfs test numbers have been renumbered please update your 
xfstests git tree for future patches and updates.

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
