Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBAKs9ie003809 for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 14:54:09 -0600
Message-ID: <50C64C83.4050906@sgi.com>
Date: Mon, 10 Dec 2012 14:56:35 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: don't zero structure members after a memset(0)
References: <50C64ACB.2090704@redhat.com>
In-Reply-To: <50C64ACB.2090704@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 12/10/12 14:49, Eric Sandeen wrote:
> Commit 408cc4e97a3ccd172d2d676e4b585badf439271b
> added memset(0, ...) to allocation args structures,
> so there is no need to explicitly set any of the fields
> to 0 after that.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>
> Note, compile-tested only.

Thank-you for cleaning up the junk I left behind.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
