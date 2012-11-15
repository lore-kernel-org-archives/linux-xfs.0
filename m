Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAFHrjQW020684 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 11:53:45 -0600
Message-ID: <50A52CA3.3060604@sgi.com>
Date: Thu, 15 Nov 2012 11:55:47 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 17/32 V2] xfs: verify dquot blocks as they are read from
	disk
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-18-git-send-email-david@fromorbit.com>
	<20121114065013.GE1710@dastard>
In-Reply-To: <20121114065013.GE1710@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/14/12 00:50, Dave Chinner wrote:
> xfs: verify dquot blocks as they are read from disk
>
> From: Dave Chinner<dchinner@redhat.com>
>
> Add a dquot buffer verify callback function and pass it into the
> buffer read functions. This checks all the dquots in a buffer, but
> cannot completely verify the dquot ids are correct. Also, errors
> cannot be repaired, so an additional function is added to repair bad
> dquots in the buffer if such an error is detected in a context where
> repair is allowed.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> Reviewed-by: Phil White<pwhite@sgi.com>
> ---
> V2: quotacheck wasn't verifying dquots as they were read from disk
>

FYI:

The xfs_quota program does not generate output with V2 which causes 
xfstest 050 to fails.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
