Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4BFGJYC048335 for <xfs@oss.sgi.com>; Fri, 11 May 2012 10:16:20 -0500
Message-ID: <4FAD2D18.20403@sgi.com>
Date: Fri, 11 May 2012 10:15:36 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] xfstests: introduce 280 for SEEK_DATA/SEEK_HOLE
	copy check
References: <4F2FE410.2040508@oracle.com>
In-Reply-To: <4F2FE410.2040508@oracle.com>
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
To: jeff.liu@oracle.com
Cc: xfs@oss.sgi.com


On 02/06/2012 08:30 AM, Jeff Liu wrote:
 > Introduce 280 for SEEK_DATA/SEEK_HOLE copy check.
 >
 > Signed-off-by: Jie Liu<jeff.liu@oracle.com>
 >



> +static int
> +do_extent_copy(int src_fd, int dest_fd, off_t data_off, off_t hole_off)
> +{

...

> +
> +	while (len>  0) {
> +		memset(buf, 0, sizeof(buf));
> +		ssize_t nr_read = read(src_fd, buf, BUF_SIZE);
#RCJ The memset above is unnecessary.


> +static int
> +copy_extents(int src_fd, int dest_fd, off_t src_total_size)
> +{
> +	int ret = 0;
> +	unsigned int i = 0;

...

> +		++i;
> +		seek_start = hole_pos;
> +	} while (seek_start<  src_total_size);
#RCJ i is unused.

Other than the comments above, this version of the test looks good.
Reviewed-by: Rich Johnston<rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
