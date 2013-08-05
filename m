Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A5C437CBF
	for <xfs@oss.sgi.com>; Mon,  5 Aug 2013 15:16:52 -0500 (CDT)
Message-ID: <52000830.1010500@sgi.com>
Date: Mon, 05 Aug 2013 15:16:48 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 25/49] libxfs: introduce xfs_trans_resv.c
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-26-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-26-git-send-email-david@fromorbit.com>
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
> The log space reservation calculation code has been separated from
> the core transaction code in kernelspace. THi smeans we can add it
> here in preparation for removing xfs_trans.c to further reduce the
> differences between kernel and usrspace files.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

xfsprogs equivalent of the for 3.12 kernel patch 10/49.

move the transaction reservation items from xfs_trans.[ch] to new 
xfs_trans_resv.[ch] with shortened structure name.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
