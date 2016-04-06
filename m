Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B5EFC7CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 05:57:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 78ACE304053
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 03:57:10 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id rJ2Z8xSlHvbTUZBT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2016 03:57:07 -0700 (PDT)
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id u36Av5Kj029222
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 6 Apr 2016 10:57:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id u36Av5u3016590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 6 Apr 2016 10:57:05 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id u36Av2w9009276
	for <xfs@oss.sgi.com>; Wed, 6 Apr 2016 10:57:04 GMT
Date: Wed, 6 Apr 2016 13:56:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: xfs: use named array initializers for log item dumping
Message-ID: <20160406105657.GA30644@mwanda>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Hello Darrick J. Wong,

The patch 5110cd82ca90: "xfs: use named array initializers for log
item dumping" from Mar 7, 2016, leads to the following static checker
warning:

	fs/xfs/xfs_log.c:2085 xlog_print_tic_res()
	error: buffer overflow 'trans_type_str' 43 <= 43

fs/xfs/xfs_log.c
  2080  
  2081          xfs_warn(mp, "xlog_write: reservation summary:");
  2082          xfs_warn(mp, "  trans type  = %s (%u)",
  2083                   ((ticket->t_trans_type <= 0 ||
  2084                     ticket->t_trans_type > XFS_TRANS_TYPE_MAX) ?
                                                ^
Should be >=.  Why is zero invalid?

  2085                    "bad-trans-type" : trans_type_str[ticket->t_trans_type]),
  2086                   ticket->t_trans_type);
  2087          xfs_warn(mp, "  unit res    = %d bytes",


regards,
dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
