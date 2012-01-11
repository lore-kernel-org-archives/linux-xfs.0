Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BL7S6Y189981 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 15:07:29 -0600
Message-ID: <4F0DFA11.7030305@sgi.com>
Date: Wed, 11 Jan 2012 15:07:29 -0600
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


xfs_bmapi_read() returns the br_state == XFS_EXT_NORM for a hole.
There are a couple places that a hole can trigger a data test.
BTW, I could not generate a large enough hole that xfs_bmapi_read()
would return as more than one hole entry, so I will ignore those
situations and just list the couple places that a hole may be match
a data rule:

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
+
+			/* No data extent at the given offset */
+			if (nmap == 1) {
+				error = ENXIO;
+				break;
+			}
+
+			if (map[1].br_state == XFS_EXT_NORM ||
			^^^ could be a hole and not data^^^

I think you need to add back the br_startblock test:

+			if ((map[1].br_state == XFS_EXT_NORM &&
+			     map[1].br_startblock != HOLESTARTBLOCK) ||


in xfs_seek_hole():
+		/*
+		 * Landed in a delay allocated extent or a real data extent,
+		 * if the next extent is landed in a hole or in an unwritten
+		 * extent but without data committed in the page cache, return
+		 * its offset. If the next extent has dirty data in page cache,
+		 * but its offset starts past both the start block of the map
+		 * and the seek offset, it still be a hole.
+		 */
+		if (map[0].br_startblock == DELAYSTARTBLOCK ||
+		    map[0].br_state == XFS_EXT_NORM) {
			^^^ could be a hole ^^^

    and this only matters because this test is checked before the next test:
		
+
+		/* Landed in a hole, its fine to return */
+		if (map[0].br_startblock == HOLESTARTBLOCK) {
+			offset = max_t(loff_t, seekoff,
+				       XFS_FSB_TO_B(mp, map[0].br_startoff));
+			break;
+		}



Switching the order of these two tests would return the immediate offset
starting a hole seek at the offset of a hole.


None of these conditions will result in data corruption, only earlier
detection of a hole.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
