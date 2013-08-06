Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A964429DFB
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 10:33:09 -0500 (CDT)
Message-ID: <52011734.3040307@sgi.com>
Date: Tue, 06 Aug 2013 10:33:08 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 34/49] xfs: don't special case shared superblock mounts
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-35-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-35-git-send-email-david@fromorbit.com>
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

On 07/19/13 01:45, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Neither kernel or userspace support shared read-only mounts, so
> don't beother special casing the support check to be different
> between kernel and userspace. The same check canbe used as neither
> like it...
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

matches kernel patch 28/49.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
