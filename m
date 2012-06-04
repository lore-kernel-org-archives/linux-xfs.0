Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q54HPi80249563 for <xfs@oss.sgi.com>; Mon, 4 Jun 2012 12:25:44 -0500
Message-ID: <4FCCEF94.7020501@sgi.com>
Date: Mon, 04 Jun 2012 12:25:40 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: re-enable xfsaild idle mode and fix associated races
References: <1337875602-63025-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1337875602-63025-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 05/24/12 11:06, Brian Foster wrote:
> xfsaild idle mode logic currently leads to a couple hangs:
>
> 1.) If xfsaild is rescheduled in during an incremental scan
>      (i.e., tout != 0) and the target has been updated since
>      the previous run, we can hit the new target and go into
>      idle mode with a still populated ail.
> 2.) A wake up is only issued when the target is pushed forward.
>      The wake up can race with xfsaild if it is currently in the
>      process of entering idle mode, causing future wake up
>      events to be lost.
>
> Both hangs are reproducible by running xfstests 273 in a loop.
> Modify xfsaild to enter idle mode only when the ail is empty
> and the push target has not been moved forward since the last
> push.
>
> Signed-off-by: Brian Foster<bfoster@redhat.com>
> ---

I wouldn't mind keeping an large (a few minutes) wake up value for the
empty AIL case to be paranoid.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
