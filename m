Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 457AD7CA0
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2016 20:26:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C50C7AC001
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2016 18:26:14 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EpCNorA2643OpG1H for <xfs@oss.sgi.com>;
	Sun, 28 Aug 2016 18:26:12 -0700 (PDT)
Date: Mon, 29 Aug 2016 11:25:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: don't warn on buffers not being recovered due
	to LSN
Message-ID: <20160829012514.GL19025@dastard>
References: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
	<1470935467-52772-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470935467-52772-4-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 11, 2016 at 01:11:05PM -0400, Brian Foster wrote:
> The log recovery buffer validation function is invoked in cases where a
> buffer update may be skipped due to LSN ordering. If the validation
> function happens to come across directory conversion situations (e.g., a
> dir3 block to data conversion), it may warn about seeing a buffer log
> format of one type and a buffer with a magic number of another.
> 
> This warning is not valid as the buffer update is ultimately skipped.
> This is indicated by a current_lsn of NULLCOMMITLSN provided by the
> caller. As such, update xlog_recover_validate_buf_type() to only warn in
> such cases when a buffer update is expected.
> 
> XXX: other issues here? better to not validate in such cases?

I think this is OK - we really want to ensure that buffers that are
in cache always have the correct verifier attached to them. Hence if
we've read the buffer in, even if we are not modifying it because
it's more recent that what is being replayed we should still attach
the verifiers to it.

If it changes type due to later recovery replay, we'll change the
verifier appropriately at that point.

> @@ -2557,6 +2542,16 @@ xlog_recover_validate_buf_type(
>  			 xfs_blft_from_flags(buf_f));
>  		break;
>  	}
> +
> +	/*
> +	 * A NULL current LSN indicates the buffer update is skipped due to LSN
> +	 * ordering. Don't warn in such cases, we skip the update for a reason
> +	 * (it's no longer valid)!
> +	 */

I read that the first time as "we skip the update for a reason that
is no longer valid" :P

perhaps rework this to make it clear what is being referred to here.
e.g. No need to warn if the the buffer contents are more recent
that this recovery item and hence recovery did not modify the
buffer.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
