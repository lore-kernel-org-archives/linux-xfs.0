Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 388D07F37
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 00:38:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AD15DAC04F
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 22:38:09 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id BilpvlB5hBv430t3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 22:38:08 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r4H5c5Bb030627
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:06 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H5c6dZ007180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:07 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H5c6JX012437 for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:06 GMT
Message-ID: <5195C239.5010905@oracle.com>
Date: Fri, 17 May 2013 13:38:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 0/8] xfs: log space validation
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hello,

This is version 2 of fix log space calculation if the log stripe unit is specified.

I changed the subject in this round since there are many changes belong to the log
space reservation interface adjustment.

Major changes of v2->v1:
- The interface of xfs_trans_reserve() has been changed to:
  xfs_trans_reserve(struct xfs_trans *tp, xfs_trans_res *tres, int blocks, int rtextents);

- Introduce a new inline helper m_tresp() to fetch pointer of mp->m_reservations structure,
  so that we don't need a big code change if someday we rename m_reservations to another
  name.

- Introduce xfs_log_rlimit.[c|h] to isolate the maximum transaction log space validation
  related routines.  There are two functions can be shared with the user space which are:
  void xfs_log_adjust_max_attrsetm_res();
  void xfs_log_get_max_trans_res();

- Calculate the maximum length in bytes that would be required for a local attribute value
  as large attributes out of line are not logged according to Dave's advise.

- Don't return if the given log space at mount time is too small, drop a message via syslog
  in critical level instead.

Testing:
xfstests/generic and xfs specified test cases(except a dozens of cases need a tap device or
xfsdump) works without panic.

[PATCH 1/8] xfs: Introduce a new structure to hold transaction reservation items
[PATCH 2/8] xfs: Introduce tr_fsyncts to m_reservation
[PATCH 3/8] xfs: Make writeid transaction use tr_writeid
[PATCH 4/8] xfs: Refactor xfs_trans_reserve() interface
[PATCH 5/8] xfs: Get rid of all XFS_XXX_LOG_RES() macros
[PATCH 6/8] xfs: Refactor xfs_ticket_alloc() to extract a new helper
[PATCH 7/8] xfs: Add xfs_log_rlimit.[c|h]
[PATCH 8/8] xfs: Validate log space at mount time

The patches of user space sync up with those kernel space change will be sent out later as I
have to go out to deal with a urgent thing right now.

v1:
http://comments.gmane.org/gmane.comp.file-systems.xfs.general/52201

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
