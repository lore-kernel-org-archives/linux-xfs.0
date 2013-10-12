Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 094A47F4E
	for <xfs@oss.sgi.com>; Sat, 12 Oct 2013 16:07:42 -0500 (CDT)
Message-ID: <5259BA1A.1060202@sgi.com>
Date: Sat, 12 Oct 2013 16:07:38 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4 V2] xfs: remove newlines from strings passed to
	__xfs_printk
References: <52584C8A.1060808@redhat.com> <52584D04.3020907@sandeen.net>
	<5258ACE9.6000401@sandeen.net>
In-Reply-To: <5258ACE9.6000401@sandeen.net>
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

On 10/11/13 20:59, Eric Sandeen wrote:
> __xfs_printk adds its own "\n".  Having it in the original string
> leads to unintentional blank lines from these messages.
>
> Most format strings have no newline, but a few do, leading to
> i.e.:
>
> [ 7347.119911] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
> [ 7347.119911]
> [ 7347.119919] XFS (sdb2): Access to block zero in inode 132 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 1a05
> [ 7347.119919]
>
> Fix them all.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---

Thanks for the updated patch. It looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
