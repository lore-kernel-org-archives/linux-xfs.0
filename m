Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7DD8Fiq004103 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 08:08:16 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id iuK2RJvRq28SfRxa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Aug 2012 06:08:15 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q7DD8D1N016121
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 13:08:14 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q7DD8D6u014905
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 13:08:13 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q7DD8DZZ007016 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 08:08:13 -0500
Message-ID: <5028FC0D.6030302@oracle.com>
Date: Mon, 13 Aug 2012 21:07:25 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v7 0/4] xfs: seek_data/seek_hole refinements
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

Here is the updated patch set for improving SEEK_DATA/SEEK_HOLE with page cache probing for unwritten
extents, it fixes a couple of issues according to Dave and Mark's review comments towards v6.

Changes from v7 to v6:

- xfs_lookup_buffer_offset(), remove page unlock out of it, fix comments for this routine.

- xfs_find_get_pgoff(), sample the next page index while the page is locked.

- xfs_seek_data()/xfs_seek_hole(), move extent state check up stuff to a loop in both routines.


Old version:

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
