Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8LLNBNb132038 for <xfs@oss.sgi.com>; Mon, 21 Sep 2009 16:23:12 -0500
Received: from peace.netnation.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3514716AF091
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2009 14:24:28 -0700 (PDT)
Received: from peace.netnation.com (newpeace.netnation.com [204.174.223.7]) by
	cuda.sgi.com with ESMTP id WGdfLmj5XJNDGB57 for
	<xfs@oss.sgi.com>; Mon, 21 Sep 2009 14:24:28 -0700 (PDT)
Received: from sim by peace.netnation.com with local (Exim 4.63)
	(envelope-from <sim@netnation.com>) id 1MpqN2-0003n3-7o
	for xfs@oss.sgi.com; Mon, 21 Sep 2009 14:24:28 -0700
Date: Mon, 21 Sep 2009 14:24:28 -0700
From: Simon Kirby <sim@hostway.ca>
Subject: xfsprogs 3.0.3 seems to forget to increase nlinks in lost+found
Message-ID: <20090921212428.GA12139@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

After running xfs_repair on a 7 TB file system where the first 1 GB had
been accidentally formatted with mkfs.ext3, a number of paths and files
were found in lost+found, as expected.  However, nlinks of the directory
itself was set to 2, causing "find" to become confused.  A subsequent run
of xfs_progs found and repaired this error:

Phase 7 - verify and correct link counts...
resetting inode 265 nlinks from 2 to 11174
done

Perhaps it would be possible to remember to increment this while things
are being linked to it?

Simon-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
