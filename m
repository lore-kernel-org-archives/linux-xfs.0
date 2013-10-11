Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2807D7F3F
	for <xfs@oss.sgi.com>; Fri, 11 Oct 2013 16:59:09 -0500 (CDT)
Message-ID: <525874AA.9020300@sgi.com>
Date: Fri, 11 Oct 2013 16:59:06 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfs: remove newlines from 3 xfs_alert_tag error
	strings
References: <52584C8A.1060808@redhat.com> <52584D04.3020907@sandeen.net>
In-Reply-To: <52584D04.3020907@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 10/11/13 14:09, Eric Sandeen wrote:
> xfs_alert_tag passes the format string to __xfs_printk,
> which adds its own "\n".  Having it in the original string
> leads to unintentional blank lines from these messages.
>
> Most format strings have no newline, but these 3 do, leading to
> i.e.:
>
> [ 7347.119911] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
> [ 7347.119911]
> [ 7347.119919] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
> [ 7347.119919]
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> Reviewed-by: Carlos Maiolino<cmaiolino@redhat.com>
> ---

Is this true of xfs_alert() too? ie the newline in xfs_alert in 
xfs_dir2_leafn_rebalance(). The newline in xfs_alert() in 
xlog_unpack_data_crc() looks intentional.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
