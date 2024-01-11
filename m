Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B6351C4C
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NuM8EcFo"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40BGmmK6024514
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:41:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=dRNwdAwJANN64GO4ywnDLSJtqgYyzn4sp7iP2Q75i3Y=;
 b=NuM8EcFoOAgzWkLcWmDP+sCEAjSfF4Rn9LsQ5VEzzNEnuJ8LHwjPZ923oirzTAgHRC+N
 4G+l5SvM8Gwbp3UDpbJ1gyU7VDi38620nJ6qaCkJ5HiTTFUEV5opu8jGLmT6VkYVDLQP
 PmxBnessjf9oajcIgjjCckvIxS7QOzMw5IJcQuf1EARtW2tGy2VKIwJZPo4CqNreyibV
 uMSL9nwZBgMN9SXwHWaHIJeNm9CBsQtPYdL+oFFyguKDClwG0MeGD9+StAGJs5nxVxA/
 E4em/Iduqpx/EVtYnkXJ41FaUfoioEVgZ8lgF6+78I86cb3Zjd7WMBppEIj3VWQE50A3 Wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vj4wwhtan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:41:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40BH1TuF008684
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:39:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vfuunfuxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:39:50 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40BHdogi012298
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 17:39:50 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-138-212.vpn.oracle.com [10.159.138.212])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3vfuunfuww-1;
	Thu, 11 Jan 2024 17:39:50 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 0/2] Introduce non-exclusive defrag to spaceman
Date: Thu, 11 Jan 2024 09:39:49 -0800
Message-Id: <20240111173949.50472-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-11_09,2024-01-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=790 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401110139
X-Proofpoint-GUID: COVHAwIaUX25ijp8LQ15pFv_QAuKh8LQ
X-Proofpoint-ORIG-GUID: COVHAwIaUX25ijp8LQ15pFv_QAuKh8LQ

Introduce non-exclusive defrag to spaceman.

Wengang Wang (2):
  xfsprogs: introduce defrag command to spaceman
  xfsprogs: modify spaceman man page for defrag

 man/man8/xfs_spaceman.8 |  22 +++
 spaceman/Makefile       |   2 +-
 spaceman/defrag.c       | 394 ++++++++++++++++++++++++++++++++++++++++
 spaceman/init.c         |   1 +
 spaceman/space.h        |   1 +
 5 files changed, 419 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/defrag.c

-- 
2.39.3 (Apple Git-145)

