Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D9A0D29DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 09:59:48 -0500 (CDT)
Message-ID: <518BB9E7.5090005@sgi.com>
Date: Thu, 09 May 2013 09:59:51 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 11/8] xfs_logprint: fix continuation transactions
References: <20130430121300.GB10481@dastard> <20130501063136.GL10481@dastard>
In-Reply-To: <20130501063136.GL10481@dastard>
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

On 05/01/13 01:31, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> As demonstrated by xfs/295, continuation transactions cause of
> problems for xfs_logprint. The failure demonstrated by the test is
> that the buffer log format structures are variable sized on disk -
> the dirty bitmap is sized according to the buffer length, not fixed
> to the length of the maximum supported buffer size.
>
> xfs_logprint assumes that the buf log format reocrds are of fixed
> size, and so when a short buffer is found it fails to handle it
> properly and treats it like a continuation record.  This causses the
> opheader pointer to be incremented incorrectly and then logprint
> wanders off into a dark corner and gets eaten by a grue.
>
> While fixing this, make the xlog_print_record code that does the
> transaction opheader walking a little easier to read and stop it
> from outputting binary data direct to the console by converting the
> no-data-print case to use a hex dumping loop.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   logprint/log_misc.c |   22 +++++++++++++++++-----
>   1 file changed, 17 insertions(+), 5 deletions(-)


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
