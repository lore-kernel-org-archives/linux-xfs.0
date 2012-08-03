Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q736BTvB044804 for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 01:11:29 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id qXioV2HLq6BX6Uo3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Aug 2012 23:11:28 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q736BRFE006221
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 06:11:28 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q736BQYD029367
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 06:11:27 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q736BQoN019189 for <xfs@oss.sgi.com>; Fri, 3 Aug 2012 01:11:26 -0500
MIME-Version: 1.0
Message-ID: <501B6B3F.7040502@oracle.com>
Date: Thu, 2 Aug 2012 23:10:07 -0700 (PDT)
From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH v6 0/4] xfs: seek_data/seek_hole refinements
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

This is the new version of supplying xfs_seek_data/xfs_seek_hole refinements by probing page cache
to find out the desired offset for unwritten extents.

Hi Dave,

According to your comments for v5, we have to check both page->index && page->mapping after locking a page due to
memory reclaim or truncate.  For page->mapping, it definitely need to check up again as it may be invalidated or
truncated.  For page->index, we have a reference on this page at pagevec_lookup(), to this point, its mapping may
be set to NULL, but it would still resides in cache or swap space IMHO, so the index will not change because of that.
I think I must missing something in this point, could you please give some hints?


Changes from v6 to v5:

- Fix off-by-one bug for calculating the number of pages to be mapped.

- Fix a few comments according to Mark and Dave's comments.

- Introduce a new helper routine xfs_lookup_buffer_offset() to lookup the desired offset from one page.
  This could help reducing one level of indention at xfs_find_get_pgoff().

- Verify page->mapping after page got locked at xfs_find_get_pgoff() as a searched page may be invalidated/truncated
  at memory reclarim or page truncation stage.

- xfs_seek_data()/xfs_seek_hole(): loop bodys are indent by one level as for if statements.


Old version:
 
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
