Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8RF4Qh2109140 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 10:04:26 -0500
Date: Thu, 27 Sep 2012 10:05:42 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v2] xfsprog: remove duplicate vector memalign from xfs_io
Message-ID: <20120927150542.GH13214@sgi.com>
References: <20120925142414.660506845@sgi.com>
	<20120925142421.398175185@sgi.com> <20120926220434.GG13214@sgi.com>
	<20120927124742.695778439@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120927124742.695778439@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 27, 2012 at 07:47:36AM -0500, Mark Tinguely wrote:
> The vector feature of xfs_io uses its own memory buffer in the iov structure
> and does not use the buffer entry. Remove the duplicate memalign.
> 
> v2: removed global buffer in __dump_buffer() and use passed buf pointer per
>     Ben's detection.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> Reviewed-by: Ben Myers <bpm@sgi.com>

Still looks good.  Don't forget to update the subject to xfsprogs.  Also the
line width looks like it might wrap.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
