Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F6F4EB21
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171657; cv=fail; b=JOhKte0ksA+Dhx6FadVciSO9tVZ5qMsKL2ZB5PxGhULz6gI8clebDCRvc0BbzdRhz8Y1gQ3E27FoSsda08T4KIYVtGOgg5fmqLeuoHpO4vwzlQq3vEW7dTN1jIdyVZxclo3GPYCGgtt9lFQ6aBtNNCcM+nNQtAbKEeWJyVRLkSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171657; c=relaxed/simple;
	bh=XOfbk8qGFuFL0GcUI5J89/40P/g1UrwlDY+n5vdHYIM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MO2+Tzlq0kKYI7fY6n4OgBzT1okfAVh0jlQ3GnQBnpr/sOrXyTXuHFIhlpRo7ZA33hSwFnnJhFjlj4cW4FoUpIVxu20cUfsS+axWxot7VWP/G1GYW6cNLPeOlXtNrHNU3gRV7KGV9bor8tDbfPxfHkX4ZK5djYWbDatutBZ0h58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f5oZq0E9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y4fyW9GW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f5oZq0E9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y4fyW9GW"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LFwBY004733
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=QyCIJIbHJ97JEBUXH58a1kTVRpj1f5cqYQJ+rTYfLME=;
 b=f5oZq0E9Mu6ZGFLT5XnkGg2BGuLfykdVfgSArJobPzcSvwOlgqg4wG5kvor9lPiq4UCZ
 ih15yKibOWOtfoG86s/4nGQO7md5h8WDegQfjmEFxbOLnpoG78YclS20vvl5kRM+ZhxH
 V8qVQwaLZYi5UbFlU+hsMXZpGhmVIYEfQDHJaXY4+U+RLLjgesX9R7AGu5DMOPhnb17A
 dptjPK7r4fZ56Cx3wj37WrMtgntFkjYe72xVWtyzkICgV0H4tEyRUJ3tbP2x+qKvSNgR
 4ZhZStKwcGl9PjiZkGmTxYpmOiZeGTlEmbw7sFk7ZGGEzy4IebcMNThVtz4GtRyWZXew Cg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1e1v56b6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415M07K4039488
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx66849-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kssABPw3YYP78gQdQoGviiCD5qzOzzEkm9JxGHptGYxJk3hAl20iPmJUH7R30RJn9X0VT2o3pfewD0+QEl+lz+xSTVH3H6rSb13VYnos8WF3TOC9ZK8dLBjMaaW8pmiYzKZelLDA9/BrNT5asT9p2bYF2BOJrYleuItItV6Vdl4zvOyStcbYrd3+CHqM/DacNY0AvQ/oyH3nAMZz4/PSVsekFIe1qGK/sr0hvhAGGU0r9nvQ0iO4IhRWF/EBsLQyAW0dsPEojhq1xjvBKR/8xgrzL0LjPUX5EZWd8nA9+4TPw7Yn7xQ9V9RGxej2PGKvhvPrdztiRzS/AsYgKeiqpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QyCIJIbHJ97JEBUXH58a1kTVRpj1f5cqYQJ+rTYfLME=;
 b=Qbg8Tw9xXq7ZM0pNcuYjQg1EBRj6AwOkWZfpFrbmfWQia8kHWhGBxwsu6pqrONFaSIifYQA1yZ0rohoxuJH68v9UVVPZc5r6ronY531zQKGriKhO8scot+qkih2KmsJm9jXrgcbZJHq4XcDBPKh0dAfDgpdXel9XzNGdCKwsP4OyGfFxUCXlcewIlQ9NUG+gYoG27fSsLaaAs8C0ePLblT6UBuBug/f7HGFWSTA3hiwl8JCBo2P3StrD/4/3CmUvoDANX/aUL6vd0pxRoqjwEmG8LDK/ccROlrftXVM2rkrjLABnCm6XU3kapoB2+ukI5VBkL252QYQpo2AiVPtKsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QyCIJIbHJ97JEBUXH58a1kTVRpj1f5cqYQJ+rTYfLME=;
 b=y4fyW9GWsSqQzeSC38PPq5IUpN2qCWvod6bQuU+HWThPcynuWf8rpwNY2H7Q3AgrDfRqRDF+19RtGHcEtW31BswQCYvQDKY9pYp4c9Hi8zKVYZSnoj7UeP+AZEsfnbaD1rosZpMFTBhsz5Ki+TYZtmgGJEzC4Fhff3fjCptilsM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4164.namprd10.prod.outlook.com (2603:10b6:a03:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:52 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:52 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 17/21] xfs: inode recovery does not validate the recovered inode
Date: Mon,  5 Feb 2024 14:20:07 -0800
Message-Id: <20240205222011.95476-18-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::10) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: 43c52282-3041-48c7-9dbe-08dc2698b706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Y2dUMh8AS3NkbWy2MvN0NJhc2iN0XlM2MDCmG12HDD9ouoXWwhJETRHqNP55aExcLLn2qosq+0VulD4ExjhkHIowh/fWePNQQhZdBuhGMofb4W3gXQVxkIJiA5Sw5K4ThwgRV5fX9t04olOEQJBhuP32F8+qAI2Zq1RXTHUMnPMFwJYgv9LF7lsotFEPI+MAa1eNSiT0f/F/z8ndfm7X1Z5l7BKMcWAfu34z+g2IEnP/G4yPJKVf2f4Byd1TbPjPducOIpW8PZkIkRw22z+WTM9ScK8T5V9E7gUkUy3FPqR/mfaCKu0TvFtYbU3S5dTYsq0uO55jTdn6AOLMUDr605KExc8o1PHWxG6qrQrq+DdMWme++xLkMm/6Xb8PEF//KOUk4dK+k8RGI61XcEX8doi0InBE8dkhwPW9VnzbV9wWWtWMs3ZuKtu9WmZ4LggyzjG9S5tzDZ3CS0+/PX5yoT0CvmkIP/rK7bALXGcAu2w5zfJNlSHFQ+unyB3Im4vMCgDdhIjoMIFbE96mrBtVqn8t2W/vqGrxRegW0ZFOxYsxOB/OrI4qdm9xoh+kuWRs
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(39860400002)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(41300700001)(316002)(66556008)(66946007)(6916009)(66476007)(86362001)(6506007)(36756003)(6666004)(478600001)(6486002)(44832011)(8676002)(83380400001)(38100700002)(8936002)(1076003)(2616005)(6512007)(2906002)(15650500001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?T4q2SBHqHpdFBjYrbrqzlRYmbew/aZdnvDzFUDuJDWv33M2p7fHvky/yPoWI?=
 =?us-ascii?Q?KczBFX2halIYqvHZT+rwkssvoFdfxk6zTdcDkswPOuJNJhzFYIb2pydbptSX?=
 =?us-ascii?Q?MKNz9fSyPYKOl65tGab26wWfMF5TUOynxkQDYzLpAsfdyLMMpaZHmjMkELNw?=
 =?us-ascii?Q?HIynVMK1ergLh3GyZsKyF/OANNNqn/iAxeGgtZL6+G2ReWrYfnlL/buXQSjT?=
 =?us-ascii?Q?nNg6umx8NqvGq6c8pF2da48n/TaAdfumByNqAVmFA5SrqFouHUIPsAWYVhki?=
 =?us-ascii?Q?tao16p2ZHxfllVGBBWfgxwMB6DRDuQyKG25VGDwvCLf2girbm0sZOZyl0tNS?=
 =?us-ascii?Q?H27+VJP0pPzbmgolxL3U1rYbriSMhElJN9XH+8tKCKeAW9tXHacESgVBsefa?=
 =?us-ascii?Q?5mLVtQu+YG05ljT4nzO+elhNab3rhzSTdCc5vO/FETFUdnAmdRrVKSCM2ypx?=
 =?us-ascii?Q?IuwBEGjqHbYORGEdZWg7Vpqr0/W40ZJrm5dkU3JCCvhXZEM/7Wq9AF3sAebR?=
 =?us-ascii?Q?S54t23uNVupzgSTx8yY+qCQ/QvN/hgVlynEZ7igztEDZ5SgUgT/k4wrGJ+Dh?=
 =?us-ascii?Q?wpzaGAtW2yH0SSCtmPQkHvWrZQfDj84doXe3FO/wBHRPoBYXB6L92EwQOQ1r?=
 =?us-ascii?Q?ipS+i01F6qxyxVCo7wr69PHXytBJVJl/Ydsw3+rKbunxjicfTZjv0PH/ZCuf?=
 =?us-ascii?Q?9tJ43uRXq360wXZiXf/RtkZrUuf00XTedNK3xdOCWVVUXaTOcSpk2AqoQaG2?=
 =?us-ascii?Q?MpL8iPxJuHglOl1t2tXYCmFQBK6Uur+YAg2FTRr2JEzWcDbYIY1I602D1z2M?=
 =?us-ascii?Q?wo8zNukNB+fYkx/6M8jw89UVj6pYQ3Wl8v5kwxmkKAAYBvk8yD4UsNeSkpB3?=
 =?us-ascii?Q?yDhafoBQySyb8GM5gy690CrYfBjcKKxdHdY4g0Mm0geLs4tk74Z7UoIXb+yr?=
 =?us-ascii?Q?E8Qtwb0U3eksMy1LQHJPs/gC/DzqFqq5CxJSxpnY5YJc+T6DRmKGXOTuPO43?=
 =?us-ascii?Q?O5HBFBxj/Z2TdLCLQlL/YeXnmVIkyyFRzp14skfYemdxa/UM8t5T98OwzNkg?=
 =?us-ascii?Q?EKjGpbMhyUCnjYB9nx0GwdtVVbhBVWUfuRcXjjbaOscBQL5rUY0eZZrZ8WbO?=
 =?us-ascii?Q?ax2BhbCtmyb7G2PX/bsJp9lSumrYNx+VPNWIWHSKRXOYOXXk8XvbUASuxwsO?=
 =?us-ascii?Q?MTXiEv6lexUdoBxouLg43p5yUIGGaiO0BGXNRocRMWgzembowpWOZzMT2PXA?=
 =?us-ascii?Q?zXSew91/L4PlZR5Iyrs1P3oVU5ToQUQVVwV3NzjG4lwEy0kM9P98zLhc0xrW?=
 =?us-ascii?Q?FPLAAsuUkyLG5jD0RgIc05hV8oDqnAuwW/WpFjC1claoXzGMgSvL4Xvq8wTF?=
 =?us-ascii?Q?a47HaiPLeyB7OiV2/XCHhopfsOQRcCHpddKKVmJ9SAWiE8UuuRaxtfftLD+p?=
 =?us-ascii?Q?HERDCYGqiNi11OvvS9/ATNRZ/iTv6RqgOYtfs5nQHQMHTGYcCcgr0K9K0CNi?=
 =?us-ascii?Q?oiKLFephYoRXn+Dsv2CgXia8n4icBUD8CZ+BVoZ71ombEcOLcS9UrOTIrnPf?=
 =?us-ascii?Q?8gD4QdsN85PXCRXJaVg211W5JP8T6s2l8IhnJ2WYAhyJNxggebjk8nwPx7SV?=
 =?us-ascii?Q?oJ90aoW5k/1+4ePsdQlGloJrFN3sbWLgN0wo52QXlkxItGRBMsrYH11F+ysC?=
 =?us-ascii?Q?413VjQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	rmK6QRVq6w05xGkGikJrFAGigprvT4xXmWlHIN1we6WagCH1U6T/wqIPWX5eYRXKF8RlZFp+Ax+SuiHrUDAAQpPPymXE8HQLCvyQtFHMGJgKVl5aesa4ILfJXQ0nPa6okMpM7SoH8//hkvh/nYya0J498zSz4ANDmGmkDNCNK6TKi0qC5izkZ+IaXTL+TF+XmICdMHOCC/tfiZjSVnwbZqgHm5KzOR/LfujxNcfSVoz5VwlqvSonXr93RmQshKYjzr46z0R4f9F7LlC9Fuz7zDrvgPKL0l4+T0Jbj2FMMihQVEP9SkT+m3xKq5BoAS9OiCpS8wmhFNCQjy5vBQBP8IuNaW6lt39edbrseQ9DlqygahSEmpgyJForM/3Lvwn9tRS+/TA/IQui6hilGfXmWXlZ59wg2MBvxDEC5XkH100EacBCHt3HIT3IFfpWbDx8hRoOjKjGNd0UO/EqyCdTOezk6RO8bJpxdYHZSpZrt8vI7bzbFFDxdBBGbbnO5co59pHkUbHB4kn6u4g7eFs8aAdlVjflxKVDaMN4o9HzwaB7dlwVljCMIEVisG0zf5qx7ZrqSLcIxfljq3E4g+0Ur8OLKNxVUzG1GbcktgV3IAk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c52282-3041-48c7-9dbe-08dc2698b706
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:52.9053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3w+tsinzQCBzAu9KYXh160fa7wrKoptMYHkruM69aAPGwDwB2jN1WuWQ3/QMUPTRgT7SXzV06RXVKO73L9c5D6MdIUBKjNYV43BFJ1iP1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402050168
X-Proofpoint-GUID: nbXM5YurKalRHzaU8qoHOWV86vEUoR6q
X-Proofpoint-ORIG-GUID: nbXM5YurKalRHzaU8qoHOWV86vEUoR6q

From: Dave Chinner <dchinner@redhat.com>

commit 038ca189c0d2c1570b4d922f25b524007c85cf94 upstream.

Discovered when trying to track down a weird recovery corruption
issue that wasn't detected at recovery time.

The specific corruption was a zero extent count field when big
extent counts are in use, and it turns out the dinode verifier
doesn't detect that specific corruption case, either. So fix it too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |  3 +++
 fs/xfs/xfs_inode_item_recover.c | 14 +++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a35781577cad..0f970a0b3382 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -508,6 +508,9 @@ xfs_dinode_verify(
 	if (mode && nextents + naextents > nblocks)
 		return __this_address;
 
+	if (nextents + naextents == 0 && nblocks != 0)
+		return __this_address;
+
 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
 		return __this_address;
 
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index e6609067ef26..144198a6b270 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -286,6 +286,7 @@ xlog_recover_inode_commit_pass2(
 	struct xfs_log_dinode		*ldip;
 	uint				isize;
 	int				need_free = 0;
+	xfs_failaddr_t			fa;
 
 	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
 		in_f = item->ri_buf[0].i_addr;
@@ -530,8 +531,19 @@ xlog_recover_inode_commit_pass2(
 	    (dip->di_mode != 0))
 		error = xfs_recover_inode_owner_change(mp, dip, in_f,
 						       buffer_list);
-	/* re-generate the checksum. */
+	/* re-generate the checksum and validate the recovered inode. */
 	xfs_dinode_calc_crc(log->l_mp, dip);
+	fa = xfs_dinode_verify(log->l_mp, in_f->ilf_ino, dip);
+	if (fa) {
+		XFS_CORRUPTION_ERROR(
+			"Bad dinode after recovery",
+				XFS_ERRLEVEL_LOW, mp, dip, sizeof(*dip));
+		xfs_alert(mp,
+			"Metadata corruption detected at %pS, inode 0x%llx",
+			fa, in_f->ilf_ino);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
 
 	ASSERT(bp->b_mount == mp);
 	bp->b_flags |= _XBF_LOGRECOVERY;
-- 
2.39.3

