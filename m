Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A808A7F37
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 14:13:00 -0500 (CDT)
Message-ID: <52014ABB.5000002@sgi.com>
Date: Tue, 06 Aug 2013 14:12:59 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 44/49] xfs: refactor xfs_trans_reserve() interface
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-45-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-45-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:45, Dave Chinner wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> With the new xfs_trans_res structure has been introduced, the log
> reservation size, log count as well as log flags are pre-initialized
> at mount time.  So it's time to refine xfs_trans_reserve() interface
> to be more neat.
>
> Also, introduce a new helper M_RES() to return a pointer to the
> mp->m_resv structure to simplify the input.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

user equivalent of the for Linux 3.12 kernel patch 38/49
plus modifying the calls to libxfs_trans_reserve() in
xfsprogs.

Still think you should remove the M_RES(mp) define.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
