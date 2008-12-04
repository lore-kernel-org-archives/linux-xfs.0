Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB45afHS022806 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 23:36:41 -0600
Message-ID: <49376C6B.7070100@sgi.com>
Date: Thu, 04 Dec 2008 16:36:43 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: Assertion failed: atomic_read(&mp->m_active_trans)
References: <492BB095.1000104@sgi.com>
	<4934AAA9.5090405@sgi.com>	<20081203104849.GF15485@infradead.org>
	<20081203213950.GX18236@disturbed>
In-Reply-To: <20081203213950.GX18236@disturbed>
Content-Type: multipart/mixed; boundary="------------030200010109010408010008"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------030200010109010408010008
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dave Chinner wrote:
> On Wed, Dec 03, 2008 at 05:48:49AM -0500, Christoph Hellwig wrote:
>> I'd rather fix it properly.
> 
> Sure, but in the mean time, I'd suggest changing it to a WARN_ON()
> rather than an ASSERT(). That way we'll continue to have ppl bug us
> about it until the VFS can support read-only remounts without racing
> correctly.

That sounds like a much better idea.

Unfortunately we wont get feedback when people hit this on the root fs
unless they have serial consoles (since /var/log/... has gone away by then).

> Has that work been dropped on the floor, Christoph? We'vecat 
> been holding off removing this ASSERT or adding the hack
> I did to work around the common case of the assert triggering
> based on the fact that the problem in the VFS would be fixed
> in the next release. That was the case each release since
> 2.6.25 and there doesn't seem to be much progress...
> 
>> Do you guys have a somewhat reliable
>> testcase hitting it?
> 
> I used to have one of the xfsqa tests hit it every so often,
> but not what you'd call reliably....

Indeed, we dont hit this in regular qa. I guess most qa scripts dont
specifically exercise remount readonly wile stressing the filesystem.
The few occasions we have hit it were when rebooting in between test
runs when the root fs was xfs.

Don






--------------030200010109010408010008
Content-Type: text/plain;
 name="warn-if-transactions-are-in-flight-on-remount-ro"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="warn-if-transactions-are-in-flight-on-remount-ro"


--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -371,7 +371,7 @@ xfs_quiesce_attr(
        /* flush inodes and push all remaining buffers out to disk */
        xfs_quiesce_fs(mp);
 
-       ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);
+       WARN_ON(atomic_read(&mp->m_active_trans) == 0);
 
        /* Push the superblock and write an unmount record */
        error = xfs_log_sbcount(mp, 1);


--------------030200010109010408010008
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------030200010109010408010008--
