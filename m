Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 44A3029DF7
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 10:38:11 -0600 (CST)
Message-ID: <547601ED.7060704@sgi.com>
Date: Wed, 26 Nov 2014 10:38:05 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: catch invalid negative blknos in _xfs_buf_find()
References: <546D15E3.5000200@redhat.com>
In-Reply-To: <546D15E3.5000200@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 11/19/14 16:12, Eric Sandeen wrote:
> Here blkno is a daddr_t, which is a __s64; it's possible to hold
> a value which is negative, and thus pass the (blkno>= eofs)
> test.  Then we try to do a xfs_perag_get() for a ridiculous
> agno via xfs_daddr_to_agno(), and bad things happen when that
> fails, and returns a null pag which is dereferenced shortly
> thereafter.
>
> Found via a user-supplied fuzzed image...
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---

Looks good.

I did a little playing with sending the try lock failure (EAGAIN?) and 
EFSCORRUPT error status up the stack. It looked straight forward and 
could save a xfs_buf allocation when we know it is not necessary.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
