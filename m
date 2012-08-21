Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7L9CDlc060129 for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 04:12:13 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id qUVgvd5Yqs4c9YSa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Aug 2012 02:12:12 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q7L9CAdM022339
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 09:12:11 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q7L9CA0W001550
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 09:12:10 GMT
Received: from abhmt108.oracle.com (abhmt108.oracle.com [141.146.116.60])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q7L9C931017440 for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 04:12:09 -0500
Message-ID: <503350B5.1010505@oracle.com>
Date: Tue, 21 Aug 2012 17:11:17 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v8 0/4] xfs: seek_data/seek_hole refinements
Reply-To: jeff.liu@oracle.com
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

Hello,

Here is the updated patch set of refine xfs_seek_data/xfs_seek_hole with page cache lookup for unwritten extents.
Hopefully, this version is qualified to be merged. :)

Changes from v8 to v7:

- xfs_find_get_pgoff()
  . Sample the next page index without page lock.  Also, add comments to clarify why it's safe to check page->index without page lock.
  . Remove (pgoff_t) PAGEVEC_SIZE.

- xfs_seek_data()/xfs_seek_hole(), ASSERT(i > 1).


Old version:

Version 7 of this posting can be found at
http://www.spinics.net/lists/xfs/msg13171.html

Version 6 of this posting can be found at
http://oss.sgi.com/archives/xfs/2012-08/msg00028.html

Version 5 of this posting can be found at
http://www.spinics.net/lists/xfs/msg12987.html

Version 4 of this posting can be found at
http://oss.sgi.com/archives/xfs/2012-07/msg00279.html

Version 3 of this posting can be found at
http://oss.sgi.com/archives/xfs/2012-07/msg00050.html

Version 2 of this posting can be found at
http://oss.sgi.com/archives/xfs/2012-06/msg00407.html

Version 1 of this posting can be found at
http://www.digipedia.pl/usenet/thread/11980/26875/


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
