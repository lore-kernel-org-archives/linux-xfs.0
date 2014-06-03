Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E94FE7F58
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 04:18:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BB728304053
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 02:17:59 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id l9YxvvGhtDOeCKCm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 02:17:54 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s539HrTg011410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:17:53 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id
	s539HqCF011930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:17:53 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id
	s539HoRW011845 for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 09:17:51 GMT
Message-ID: <538D92B6.5050402@oracle.com>
Date: Tue, 03 Jun 2014 17:17:42 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v3 00/10] xfs_ioc_bulkstat code refactoring and consolidation
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

Hi folk,

This is the revised patches for xfs_ioc_bulkstat consolidation and code
refactoring. As per Christoph's comments, I'm not include the per AG
inumber patch in this series given that I don't actually introduce the
relevant inumbers interface now. Similar to that reason, I also dropped
the per AG bulkstat patch, it would be included in parallel quota check
series.


v3->v2:
- one major bug fix is at xfs_bulkstat_ag_ichunk() regarding the user buffer
  pointer operations, it should be defined as a pointer-to-pointer since it
  would be updated inside xfs_bulkstat_ag_ichunk().

- separate xfs_inumber consolidate patch into two patches, the first one
  fix the formater function return value and consolidate the codes, another
  one does the actual logic changes for better error handling.

- Add a separate patch to get rid of the redundant user buffer count
  checks at xfs_bulkstat()

- fixed agino calculation issue at xfs_bulkstat_grab_ichunk().

v2: http://oss.sgi.com/archives/xfs/2014-04/msg00554.html
v1: http://oss.sgi.com/archives/xfs/2013-12/msg00901.html


Any comments are welcome!


Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
