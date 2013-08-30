Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 287A17F3F
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 07:21:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4899AC00A
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 05:21:17 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CVI4AVfhjBGzDd85 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 Aug 2013 05:21:13 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r7UCLCd9016626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 12:21:13 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r7UCLBJU019550
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 12:21:12 GMT
Received: from abhmt117.oracle.com (abhmt117.oracle.com [141.146.116.69])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r7UCLBWr019546 for <xfs@oss.sgi.com>; Fri, 30 Aug 2013 12:21:11 GMT
Message-ID: <52208DC0.2030805@oracle.com>
Date: Fri, 30 Aug 2013 16:19:12 +0400
From: Vasily Isaenko <vasily.isaenko@oracle.com>
MIME-Version: 1.0
Subject: SGID inheritance in different file-systems
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Dear XFS Members,

In the XFS test suite there is a test case generic/314 "Test SGID 
inheritance on subdirectories".
It is not specific to a particular filesystem thus selected for both xfs 
or ext4 test runs.
In other words, the same behaviour is expected and enforced for XFS and 
EXT4.

However, I have been told that EXT4 and XFS may have different behaviour 
as the
setgid-directory behavior is not guaranteed to work the same way on all 
filesystems.

Shall XFS test case reflect that difference or enforcing the same 
behaviour is appropriate?

Best regards,
Vasily

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
