Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 38D087F9E
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 17:14:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5FF8AC003
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 15:14:06 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	11AwcEr1DMmSz1IN for <xfs@oss.sgi.com>;
	Wed, 22 Jan 2014 15:14:05 -0800 (PST)
Date: Thu, 23 Jan 2014 10:12:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3 V3] xfs: clean up xfs_buftarg
Message-ID: <20140122231231.GF27606@dastard>
References: <52DEF81D.4090100@redhat.com>
 <52DEF869.6040107@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52DEF869.6040107@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jan 21, 2014 at 04:44:57PM -0600, Eric Sandeen wrote:
> Clean up the xfs_buftarg structure a bit:
> - remove bt_bsize which is never used
> - replace bt_sshift with bt_ssize; we only ever shift it back
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
