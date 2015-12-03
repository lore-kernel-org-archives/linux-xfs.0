Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 46E487F5A
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 00:22:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3988330405F
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 22:22:17 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	QEz8QDSnYcEGH53H for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 22:22:14 -0800 (PST)
Date: Thu, 3 Dec 2015 17:22:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/11] xfsprogs: xfs_repair: fix possible null
	dereference in traverse_int_dir2block
Message-ID: <20151203062201.GY26718@dastard>
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-10-git-send-email-t.vivek@samsung.com>
	<565FD863.3090105@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565FD863.3090105@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Wed, Dec 02, 2015 at 11:51:31PM -0600, Eric Sandeen wrote:
> On 12/2/15 5:19 AM, Vivek Trivedi wrote:
> > Fix possible null dereference in traverse_int_dir2block if buffer pointer is NULL.
> > Reported by coverity.
> 
> Hm, against what version of xfsprogs?
> 
> traverse_int_dir2block has been gone for a while now.  Can you please recheck
> against current git, and if there's still an issue, explain a bit more;
> I don't see offhand how we get a bp back from da_read_buf with a null bp->b_addr.

it's also worth pointing out that there are several callers of
da_read_buf() in this function, all of which have identical error
checking and hence are all going to have the same problem if it
does actually exist.

When coverity issues a warning, we really need to check all
instances of the same code for the same problem, even if coverity
doesn't warn about the other call sites....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
