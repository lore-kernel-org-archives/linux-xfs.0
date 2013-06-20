Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 881657F37
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 11:59:43 -0500 (CDT)
Message-ID: <51C334FF.6070005@sgi.com>
Date: Thu, 20 Jun 2013 11:59:43 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/60] xfs: add pluging for bulkstat readahead
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/18/13 23:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> I was running some tests on bulkstat on CRC enabled filesystems when
> I noticed that all the IO being issued was 8k in size, regardless of
> the fact taht we are issuing sequential 8k buffers for inodes
> clusters. The IO size shoul dbe 16k for 256 byte inodes, and 32k for
> 512 byte inodes, but this wasn't happening.
>
> blktrace showed that there was an explict plug and unplug happening
> around each readahead IO from _xfs_buf_ioapply, and the unplug was
> causing the IO to be issued immediately. Hence no opportunity was
> being given to the elevator to merge adjacent readahead requests and
> dispatch them as a single IO.
>
> Add plugging around the inode chunk readahead dispatch loop tin
> bulkstat to ensure that we don't unplug the queue between adjacent
> inode buffer readahead IOs and so we get fewer, larger IO requests
> hitting the storage subsystemi for bulkstat.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
