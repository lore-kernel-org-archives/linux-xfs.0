Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6IM9HBJ130444 for <xfs@oss.sgi.com>; Mon, 18 Jul 2011 17:09:17 -0500
Subject: Re: [PATCH 0/2 v8] XFS TESTS: ENOSPC Punch Hole Test
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1310946766-30217-1-git-send-email-achender@linux.vnet.ibm.com>
References: <1310946766-30217-1-git-send-email-achender@linux.vnet.ibm.com>
Date: Mon, 18 Jul 2011 17:09:13 -0500
Message-ID: <1311026953.2790.49.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Sun, 2011-07-17 at 16:52 -0700, Allison Henderson wrote:
> This patch set adds the ENOSPC test that was used for ext4 punch hole testing.
> This test will verify that a hole can be punched even when the disk is full.
> Reserved blocks should be used to complete the operation when there is not blocks
> to further fragment the file.
> 
> Because punching a hole does not always require extra blocks, there needs to 
> be several iterations of punching holes, and then filling the file system to 100% 
> usage before it is forced to grow the tree in order to handle the fragmentation. 
> The growing of the tree is what would cause ENOSPC if not for the use of reserved blocks.

I have reviewed both of your updated patches.  They
both look good to me.  I'll give it another day or
two for others to comment if they like, but unless
someone suggests changes I'll commit this for you.

Reviewed-by: Alex Elder <aelder@sgi.com>




> Allison Henderson (2):
>   XFS TESTS: ENOSPC Punch Hole: Move su routines in 123 to common.rc
>   XFS TESTS: Add ENOSPC Hole Punch Test
> 
>  123       |   24 ------------
>  256       |  120 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  256.out   |    1 +
>  common.rc |   81 +++++++++++++++++++++++++++++++++++++++++
>  group     |   12 ++++--
>  5 files changed, 210 insertions(+), 28 deletions(-)
>  create mode 100644 256
>  create mode 100644 256.out
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
