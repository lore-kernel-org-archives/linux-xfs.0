Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7PHwl6x215642 for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 12:58:57 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 51238304097
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 10:59:40 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 0/7] inode allocation cleanups
Date: Tue, 25 Aug 2009 12:57:16 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABCE@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090824153030.GA19864@infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

> ping?  any reviewers for this?

I no longer have these in my mailbox, but I've reviewed them
all, and they all look good.  Very nice result of getting rid
of duplication and making functions a more manageable size.
One comment on patch 5 below.

					-Alex

# [PATCH 1/7] xfs: factor out inode initialisation   Christoph Hellwig
Reviewed-by: Alex Elder <aelder@sgi.com>

# [PATCH 2/7] xfs: improve xfs_inobt_get_rec prototype   Christoph Hellwig
Reviewed-by: Alex Elder <aelder@sgi.com>

# [PATCH 3/7] xfs: improve xfs_inobt_update prototype   Christoph Hellwig
Reviewed-by: Alex Elder <aelder@sgi.com>

# [PATCH 4/7] xfs: factor out debug checks from xfs_dialloc and xfs_difree   Christoph Hellwig
Reviewed-by: Alex Elder <aelder@sgi.com>

# [PATCH 5/7] xfs: untangle xfs_dialloc   Christoph Hellwig
    No cursor cleanup on WANT_CORRUPTED_RETURN() just after "if (pagno == agno)".
    (Maybe I'm misreading the patch.)  I realize this is still better than the
    ASSERT() in place currently, but maybe it should be WANT_CORRUPTED_GOTO(error0)
    instead.
Reviewed-by: Alex Elder <aelder@sgi.com>

# [PATCH 6/7] xfs: rationalize xfs_inobt_lookup*   Christoph Hellwig
Reviewed-by: Alex Elder <aelder@sgi.com>

# [PATCH 7/7] xfs: speed up free inode search   Christoph Hellwig 
Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
