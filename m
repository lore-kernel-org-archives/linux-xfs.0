Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A4CF07F51
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 16:57:19 -0500 (CDT)
Date: Mon, 5 Aug 2013 16:57:19 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 06/12] xfs: remote attribute read too short
Message-ID: <20130805215719.GC3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370607901-11538-7-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:24:55PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Reading a maximally size remote attribute fails when CRCs are
> enabled with this verification error:
> 
> XFS (vdb): remote attribute header does not match required off/len/owner)
> 
> There are two reasons for this, the first being that the
> length of the buffer being read is determined from the
> args->rmtblkcnt which doesn't take into account CRC headers. Hence
> the mapped length ends up being too short and so we need to
> calculate it directly from the value length.
> 
> The second is that the byte count of valid data within a buffer is
> capped by the length of the data and so doesn't take into account
> that the buffer might be longer due to headers. Hence we need to
> calculate the data space in the buffer first before calculating the
> actual byte count of data.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Goes with commit 551b382f5368900d6d82983505cb52553c946a2b

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
