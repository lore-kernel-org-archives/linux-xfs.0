Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 10DC67F92
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 06:48:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E12E3304053
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 04:48:18 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ZsAyhDHKaMI10dDI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Dec 2013 04:48:17 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBOCmGil011655
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:48:17 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBOCmFSt010873
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:48:15 GMT
Received: from ubhmt105.oracle.com (ubhmt105.oracle.com [156.151.24.10])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBOCmFar010862 for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:48:15 GMT
Message-ID: <52B9828C.7030202@oracle.com>
Date: Tue, 24 Dec 2013 20:48:12 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 0/4] xfs: fsstress/godown bug fixes
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

I have observed another hang up when doing fsstress and shutting the file system.
The first two patches are manage to fix those issues, and the left are for code
clean ups.

Please note that, those patches are based on Christoph's previous fix:
[PATCH v2] xfs: remove xfsbdstrat error

I know that most of our folks are on vacation for the coming holidays, enjoy the
happy time, I just posted patches here. 


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
