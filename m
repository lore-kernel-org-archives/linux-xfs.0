Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6CF177FB3
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 11:49:34 -0600 (CST)
Message-ID: <5130EA2F.9080209@sgi.com>
Date: Fri, 1 Mar 2013 11:49:35 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 07/10] xfstest: add fallocate/truncate vs AIO/DIO stress
	test
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-8-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361356935-29153-8-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On 02/20/2013 04:42 AM, Dmitry Monakhov wrote:
> Run  DIO, fallocate and truncate threads on a common file in parallel.
> If race exist old dio request may rewrite blocks after it was allocated
> to another file, we will catch that by verifying blocks content.
>
> this patch known to catch deadlock for ext4
> http://lists.openwall.net/linux-ext4/2012/09/06/3
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
