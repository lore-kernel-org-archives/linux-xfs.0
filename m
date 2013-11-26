Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E8B987F4E
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 00:41:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5656304032
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 22:41:12 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	36PEgeVc5Kt6cOZk for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 22:41:11 -0800 (PST)
Date: Tue, 26 Nov 2013 17:41:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests,btrfs: add wrong compress type regression test
Message-ID: <20131126064107.GN8803@dastard>
References: <20131125210055.GG8803@dastard>
	<1385445677-27762-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385445677-27762-1-git-send-email-miaox@cn.fujitsu.com>
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
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 26, 2013 at 02:01:17PM +0800, Miao Xie wrote:
> Btrfs would crash when the users wrote some data into a file with compress
> flag but the compression of the fs was disabled. This test case is to check
> this bug still happen or not.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
> Changlog v1 -> v2:
> - address the commit from Dave Chinner.

Testing every change before posting them for review is a good habit
to develop. This:

> +	$XFS_IO_PROG -f -c "pwrite 0 1M" -c sync $work_file | _filter_xfs_io

will dump this:

wrote 1048576/1048576 bytes at offset 0
XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
command "sync" not found

into the output file and hence the test will fail as the golden
image file in the patch was not updated to match the new test output.

It also points out that "-c sync" command is invalid - the
command to fsync a file is "-c fsync".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
