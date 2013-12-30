Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2470029DF8
	for <xfs@oss.sgi.com>; Mon, 30 Dec 2013 12:35:15 -0600 (CST)
Message-ID: <52C1BCE5.1070707@sgi.com>
Date: Mon, 30 Dec 2013 12:35:17 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/10] xfs: xfs_bulkstat_single consolidation
References: <52BEB3E7.2080706@oracle.com>
In-Reply-To: <52BEB3E7.2080706@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/28/13 05:20, Jeff Liu wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> In xfs_bulkstat_single(), xfs_bulkstat_one() and xfs_bulkstat() might
> return different error if either call failed, we'd better return the
> proper error in this case.  Moreover, the function argument done is
> useless in terms of xfs_ioc_bulkstat(), hence we can get rid of it.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---

Yes, I know dmapi is not loved here but SGI still uses it and it wants 
the done flag still.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
