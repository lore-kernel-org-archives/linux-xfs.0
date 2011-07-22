Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MJnjHx102730 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:49:45 -0500
Subject: Re: [PATCH 12/12] xfs: Remove the macro XFS_BUFTARG_NAME
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110722003408.21069.44409.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003408.21069.44409.sendpatchset@chandra-lucid.beaverton.ibm.com>
Date: Fri, 22 Jul 2011 14:49:41 -0500
Message-ID: <1311364181.2771.114.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-07-21 at 17:34 -0700, Chandra Seetharaman wrote:
> Remove the definition and usages of the macro XFS_BUFTARG_NAME.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>


Wow, I hadn't looked at the definition of
xfs_buf_target_name() before.  It's not safe
(using a pointer to since-released stack space),
though in practice it's going to be fine.

Defining it as an inline function with a static
buffer would at least avoid that, though it
means it's not reentrant either.

I would personally prefer doing it that way though.

/* NB: returns pointer to buffer reused on each call */
static inline char *
xfs_buf_target_name(struct xfs_buftarg *target)
{
        static char __b[BDEVNAME_SIZE];

        return bdevname(target->bt_bdev, __b);
}


Anyway, you didn't change this, but you're touching
the code that uses it.  So unless others object I
would like to see this changed along with the
rest of what you do here (which is all good, by
the way).

Either way:

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
