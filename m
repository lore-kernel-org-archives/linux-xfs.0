Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 31B017F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 16:45:07 -0600 (CST)
Message-ID: <547E40EF.1000109@sgi.com>
Date: Tue, 02 Dec 2014 16:45:03 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs: active inodes stat is broken
References: <1417473270-17467-1-git-send-email-david@fromorbit.com>
	<547DC411.3090202@sgi.com> <20141202210204.GA18131@dastard>
	<20141202223452.GF18131@dastard>
In-Reply-To: <20141202223452.GF18131@dastard>
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

On 12/02/14 16:34, Dave Chinner wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> vn_active only ever gets decremented, so it has a very large
> negative number.  Make it track the inode count we currently have
> allocated properly so we can easily track the size of the inode
> cache via tools like PCP.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Nice to have that working.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
