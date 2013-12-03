Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 430AD7F59
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 05:58:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31F23304071
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 03:58:39 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id BjVkYjHXsjP2yC0H (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 03:58:34 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rB3BwXdq031039
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 11:58:34 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB3BwWPu029314
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 11:58:33 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB3BwWTp014153 for <xfs@oss.sgi.com>; Tue, 3 Dec 2013 11:58:32 GMT
Message-ID: <529DC763.8000007@oracle.com>
Date: Tue, 03 Dec 2013 19:58:27 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 0/4] xfstests: introduce xfs tests 304/305 to verify turn
	quota/project quota off
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

Hi Folks,

Here is the 2nd version for introducing two new xfs specified tests to verify that
we can turn group/project quotas off while user quota is on and fsstress is running.

As a preparation step, the 1st patch is trying to introduce a couple of pre-checkup
routines to verify that if mkfs.xfs and kernel are have crc feature or not as per
Dave's comments.

v1->v2:
- Introduce _require_xfs_mkfs_crc to verify if mkfs.xfs have crc feature or not
- Introduce _require_xfs_crc to verify if xfs kernel have crc feature or not
- xfs/299, remove v5 super block number "5" from golden output file
- Re-number both test cases to xfs/304 and xfs/305 separately
- Redirect "Version 5 superblock detected. xfsprogs has EXPERIMENTAL support enabled!
  Use of these features is at your own risk!" to /dev/null from mkfs.xfs for all those
  changes.


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
