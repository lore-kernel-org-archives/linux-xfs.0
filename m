Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D05A97F3F
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 07:38:29 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BEBD530407A
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 05:38:26 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id oPSk9FfMjYX6cMOn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Nov 2013 05:38:25 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAQDcOhg005302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 13:38:25 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAQDcNK0001193
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 13:38:23 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAQDcNnC001186 for <xfs@oss.sgi.com>; Tue, 26 Nov 2013 13:38:23 GMT
Message-ID: <5294A449.9010202@oracle.com>
Date: Tue, 26 Nov 2013 21:38:17 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 0/3] xfs:  fix quota related problems
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

Here is the revised version for fixing the infinite loop when turning group/project
quota off but keep user quota being active.  After this fix, I ran into another
assertion failure which can be triggered by running fsstress and turning group/project
quota off concurrently.

Since the tests will fail without applying the previous fix:
[PATCH v2] xfs: fix assertion failure at xfs_setattr_nonsize

So I wrapped it up in this series as the 1st fix, maintainers please ignore that in
another post, the 2nd patch is used to fix the infinite loop, the 3rd one is trying
to solve the assertion issue.

Dave,

Since the infinite loop and assertion issue are failed due to different issues, I
wonder if we'd better to add two test cases to cover them separately or not? i.e,
One sanity check to verify turning group/project off quota with user quota is active,
another test to verify turning group/project quota off with fsstress is running.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
