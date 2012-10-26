Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QFp3eq239454 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 10:51:04 -0500
Message-ID: <508AB230.1010102@sgi.com>
Date: Fri, 26 Oct 2012 10:54:24 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstests: Assume yes when test device is not partitioned
References: <1315038799-2150-1-git-send-email-prasadjoshi.linux@gmail.com>
In-Reply-To: <1315038799-2150-1-git-send-email-prasadjoshi.linux@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Prasad Joshi <prasadjoshi.linux@gmail.com>
Cc: linux-ext4@vger.kernel.org, Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>, xfs@oss.sgi.com

On 09/03/2011 03:33 AM, Prasad Joshi wrote:
> If an entire device used for file system creation, the mkfs.ext2/3/4
> asks for confirmation before proceeding. Since the device is
> configured for testing it is safe to assume positive response
> during mkfs.
>
> The patch also replaces hard coded mkfs path with MKFS_PROG variable.
>
> Signed-off-by: Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>
> Signed-off-by: Prasad Joshi <prasadjoshi.linux@gmail.com>
>
> ---
> 032       |    4 ++--
>   049       |    2 +-
>   073       |    2 +-
>   common.rc |    4 ++--
>   4 files changed, 6 insertions(+), 6 deletions(-)
>
Looks good

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Prasad,

This patch has been committed to git://oss.sgi.com/xfs/cmds/xfstests, 
master branch, commit ID 9ea06dce.

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
