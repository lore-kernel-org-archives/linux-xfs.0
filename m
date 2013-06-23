Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0215B7F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 12:27:39 -0500 (CDT)
Message-ID: <51C7300A.10308@sgi.com>
Date: Sun, 23 Jun 2013 12:27:38 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 08/60] xfs: Introduce an ordered buffer item
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-9-git-send-email-david@fromorbit.com>
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
> If we have a buffer that we have modified but we do not wish to
> physically log in a transaction (e.g. we've logged a logical
> change), we still need to ensure that transactional integrity is
> maintained. Hence we must not move the tail of the log past the
> transaction that the buffer is associated with before the buffer is
> written to disk.
>
> This means these special buffers still need to be included in the
> transaction and added to the AIL just like a normal buffer, but we
> do not want the modifications to the buffer written into the
> transaction. IOWs, what we want is an "ordered buffer" that
> maintains the same transactional life cycle as a physically logged
> buffer, just without the transcribing of the modifications to the
> log.
>
> Hence we need to flag the buffer as an "ordered buffer" to avoid
> including it in vector size calculations or formatting during the
> transaction. Once the transaction is committed, the buffer appears
> for all intents to be the same as a physically logged buffer as it
> transitions through the log and AIL.
>
> Relogging will also work just fine for such an ordered buffer - the
> logical transaction will be replayed before the subsequent
> modifications that relog the buffer, so everything will be
> reconstructed correctly by recovery.
>
> Signed-off-by: Dave Chinner<david@fromorbit.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
