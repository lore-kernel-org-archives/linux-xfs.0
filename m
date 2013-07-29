Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 42FAF7F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 17:24:18 -0500 (CDT)
Message-ID: <51F6EB8E.4060706@sgi.com>
Date: Mon, 29 Jul 2013 17:24:14 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 47/49] xfs: split the CIL lock
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-48-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-48-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:25, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The xc_cil_lock is used for two purposes - to protect the CIL
> itself, and to protect the push/commit state and lists. These are
> two logically separate structures and operations, so can have their
> own locks. This means that pushing on the CIL and the commit wait
> ordering won't contend for a lock with other transactions that are
> completing concurrently. As the CIL insertion is the hottest path
> throught eh CIL, this is a big win.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

read semaphore/xc_cil_lock (original lock) protects cil entries
write semaphore/xc_push_lock (new lock) protects the cil push

Looks good.

Review-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
