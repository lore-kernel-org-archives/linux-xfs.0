Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 823167F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 17:15:46 -0500 (CDT)
Date: Mon, 20 May 2013 17:15:42 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 09/14] xfs: remote attribute lookups require the value
	length
Message-ID: <20130520221542.GG20028@sgi.com>
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1369007481-15185-10-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, May 20, 2013 at 09:51:16AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When reading a remote attribute, to correctly calculate the length
> of the data buffer for CRC enable filesystems, we need to know the
> length of the attribute data. We get this information when we look
> up the attribute, but we don't store it in the args structure along
> with the other remote attr information we get from the lookup. Add
> this information to the args structure so we can use it
> appropriately.

Looks good.  Applied.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
