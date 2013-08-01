Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E3FE29DFB
	for <linux-xfs@oss.sgi.com>; Thu,  1 Aug 2013 09:56:15 -0500 (CDT)
Message-ID: <51FA770F.2060801@sgi.com>
Date: Thu, 01 Aug 2013 09:56:15 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix agcnts leak in xfs_repair's scan_ags
References: <51F9C70E.30702@sandeen.net>
In-Reply-To: <51F9C70E.30702@sandeen.net>
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
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On 07/31/13 21:25, Eric Sandeen wrote:
> agcnts is malloc'd but never freed in this function.
>
> Coverity found this.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
