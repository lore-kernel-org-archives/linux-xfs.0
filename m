Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BLC0vv190184 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 15:12:00 -0600
Message-ID: <4F0DFB20.7030704@sgi.com>
Date: Wed, 11 Jan 2012 15:12:00 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Introduce SEEK_DATA/SEEK_HOLE to XFS V5
References: <4F06F71A.2010301@oracle.com> <20120110171855.GX6390@sgi.com>
	<4F0D21E5.7010908@oracle.com>
In-Reply-To: <4F0D21E5.7010908@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

xfs_has_unwritten_buffer() always returns the offset of the first
dirty unwritten page. This can cause xfs_seek_data() and xfs_seek_hole()
to give the wrong results in certain circumstances.


In xfs_seek_data(), every page past first dirty/unwritten page in the
unwritten extent will be reported as data.


in xfs_seek_data():
+		/*
+		 * Landed in an unwritten extent, try to find out the data
+		 * buffer offset from page cache firstly. If nothing was
+		 * found, treat it as a hole, and skip to check the next
+		 * extent, something just like above.
+		 */
+		if (map[0].br_state == XFS_EXT_UNWRITTEN) {
+			if (xfs_has_unwritten_buffer(inode, &map[0],
+						     PAGECACHE_TAG_DIRTY,
+						     &offset) ||
+			    xfs_has_unwritten_buffer(inode, &map[0],
+						     PAGECACHE_TAG_WRITEBACK,
+						     &offset)) {
+				offset = max_t(loff_t, seekoff, offset);
+				break;
+			}

Since the xfs_has_unwritten_buffer() returns the offset of the first
dirty/unwritten page (the first page in this example), the max_t()
comparison will say that every page after the first dirty page has
data.

		-----

xfs_seek_hole() can only find a hole if it precedes the first dirty
page.

in xfs_seek_hole():
+		/*
+		 * Landed in an unwritten extent, try to lookup the page
+		 * cache to find out if there is dirty data or not. If
+		 * nothing was found, treate it as a hole. If there has
+		 * dirty data and its offset starts past both the start
+		 * block of the map and the current seek offset, it should
+		 * be treated as hole too. Otherwise, go through the next
+		 * extent to fetch holes.
+		 */
+		if (map[0].br_state == XFS_EXT_UNWRITTEN) {
+			if (xfs_has_unwritten_buffer(inode, &map[0],
+						     PAGECACHE_TAG_DIRTY,
+						     &offset) ||
+			    xfs_has_unwritten_buffer(inode, &map[0],
+						     PAGECACHE_TAG_WRITEBACK,
+						     &offset)) {
+				if (offset > max_t(loff_t, seekoff,
+						   XFS_FSB_TO_B(mp,
+						   map[0].br_startoff))) {
+					offset = max_t(loff_t, seekoff,
+						       XFS_FSB_TO_B(mp,
+						       map[0].br_startoff));
+					break;
+				}
+			} else {
+				offset = max_t(loff_t, seekoff,
+					XFS_FSB_TO_B(mp, map[0].br_startoff));
+				break;
+			}

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
