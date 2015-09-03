Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A4C47F9B
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 15:11:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DB696AC007
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 13:11:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EmEfku6CgGwykfEx for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 13:11:10 -0700 (PDT)
Subject: Re: [PATCH 1/3] xfs: create global stats and stats_clear in sysfs
References: <1441298187-29064-1-git-send-email-billodo@redhat.com>
	<1441298187-29064-2-git-send-email-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E8A95D.9060103@sandeen.net>
Date: Thu, 3 Sep 2015 15:11:09 -0500
MIME-Version: 1.0
In-Reply-To: <1441298187-29064-2-git-send-email-billodo@redhat.com>
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
To: billodo <billodo@redhat.com>, xfs@oss.sgi.com

On 9/3/15 11:36 AM, billodo wrote:
> Currently, xfs global stats are in procfs. This patch introduces
> (replicates) the global stats in sysfs. Additionally a stats_clear file
> is introduced in sysfs.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  fs/xfs/xfs_stats.c | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_stats.h |  2 ++
>  fs/xfs/xfs_super.c | 17 ++++++++---
>  fs/xfs/xfs_sysfs.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_sysfs.h |  1 +
>  5 files changed, 177 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index f224038..856cf57 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -29,6 +29,89 @@ static int counter_val(int idx)
>  	return val;
>  }
>  
> +int xfs_stats_format(char *buf)
> +{
> +	int		i, j;
> +	int len = 0;

Oh, one other little nitpick, tab over "len" to match the rest.

> +	__uint64_t	xs_xstrat_bytes = 0;
> +	__uint64_t	xs_write_bytes = 0;
> +	__uint64_t	xs_read_bytes = 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
