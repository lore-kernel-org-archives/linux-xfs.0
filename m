Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O2md0B174074 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 20:48:40 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ETOlOHo3aVCKyP6U (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Jan 2012 18:48:38 -0800 (PST)
Message-Id: <20120124023934.532008617@clark.kroah.org>
Date: Mon, 23 Jan 2012 18:35:39 -0800
From: Greg KH <gregkh@suse.de>
Subject: [119/129] xfs: fix endian conversion issue in discard code
In-Reply-To: <20120124024041.GA18422@kroah.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, Dave Chinner <dchinner@redhat.com>

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1239
Lines: 39

From: Dave Chinner <dchinner@redhat.com>

commit b1c770c273a4787069306fc82aab245e9ac72e9d upstream

When finding the longest extent in an AG, we read the value directly
out of the AGF buffer without endian conversion. This will give an
incorrect length, resulting in FITRIM operations potentially not
trimming everything that it should.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/xfs/xfs_discard.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -68,7 +68,7 @@ xfs_trim_extents(
 	 * Look up the longest btree in the AGF and start with it.
 	 */
 	error = xfs_alloc_lookup_le(cur, 0,
-				    XFS_BUF_TO_AGF(agbp)->agf_longest, &i);
+			    be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest), &i);
 	if (error)
 		goto out_del_cursor;
 
@@ -84,7 +84,7 @@ xfs_trim_extents(
 		if (error)
 			goto out_del_cursor;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, out_del_cursor);
-		ASSERT(flen <= XFS_BUF_TO_AGF(agbp)->agf_longest);
+		ASSERT(flen <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest));
 
 		/*
 		 * Too small?  Give up.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
