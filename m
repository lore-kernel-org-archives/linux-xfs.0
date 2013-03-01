Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D1E07FB3
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 11:50:08 -0600 (CST)
Message-ID: <5130EA51.7090306@sgi.com>
Date: Fri, 1 Mar 2013 11:50:09 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 08/10] xfstest: add fallocate/punch_hole vs AIO/DIO stress
	test
References: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
	<1361356935-29153-9-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1361356935-29153-9-git-send-email-dmonakhov@openvz.org>
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
> Run  random AIO/DIO activity (fio's job:direct_aio_raicer)
> random fallocate activity(fio's job:falloc_raicer)
> and random punch_hole activity(punch_hole_raicer) on a common
> file in parallel. If race exist old dio request may rewrite
> punched block after it was allocated to another file, we will
> catch that by verifier fio's job: "aio-dio-verifier".
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Looks good.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
