Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B50271747
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711404505; cv=fail; b=sJaUKDpqV8U3YoNR4cCY2gXsdhlpax+aJm3pmGIfKElc9WpSJTg2/X11JMzUK0+3dxS3P5O1Uyuqm+3lk+0ndwDmQj0KsY1HMfnWWP3D+a7JfAIfuDsD5HMVKCw9wWENXqFfNcPXAq8mkR4w+tQK6Ngk70/QmdYR028Fut9O0f0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711404505; c=relaxed/simple;
	bh=hZgIyjX10qsOaqHEWxFRmfK3lfRT5srw83ssH/qjqsY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aCEN4ida5hVv1nd2Jwnnn5gpektUTd0wqvtPFXCSqcmGHSf+9zx8vAFYe3BdessvVAr6fHmxvN7o8aaW32eG8MKdNMbWxKkoiQ3asNpPt7WbovpD8PTuYokXdRyBZfZZ3Kr60kPSvVS7nXTsz5tzF/JCak80RqJ/iN6CJ5l7g9U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X7yOu/J6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rsPwWuXV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X7yOu/J6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rsPwWuXV"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLG94F032565
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=+25WyXrzuippma5QtHRS6LN/Fw5xJeR9GHTYiePAS88=;
 b=X7yOu/J6vJ/M3gVi8twlPtavB6BhaLCF9ngV9I/m1G5tl9mK70m+CJ1qpk/H5ViNJM7i
 KY6zqGa6kBlb36tbzpSEnhSi3k6QDhy+btdU3waiD6jq5c0SsOQFfeXVx5/qt1AcxpZT
 8TAASwrIVZ2HYWhY/CLddVPS2QpvGZKUPz5M4go/LLhVtdxWwgIbsWWmi2xPBQFAwhIj
 WVos35KxQUu7bngVj16QL7OqraXz8N/XwPdghUzyzv/3GP3b8ZJJXTpHG759oE/lJkb2
 Y2GgfGiYyWxpUin04kukRJPZo/l5pDr26R8XsoVsSHC0Grk3Ddqzjdx//WH+S9t9F7+m 7g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2f6h2r8c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PKNtd2024519
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:21 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh6ccn9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 22:08:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSayUvXN24NZwK8B28drWq7nVkJ8GFwDkkUvJdOmNXsgzgrNN51SoUE20FjPHYDrGLV72RzbU2cFp4ZKuLQzG/D6tCwuWKFbVhHG2J9afPP1fCmKbQBPmzN2V+6dhpQ2gaUCsPaino4JlKus0l2XA7qbRZeP+YIQh/FCaY/P50mWzC+bgBQ2hrwAWQkUIRyX3c1zo3XcMhxON9U+0bzPEQHork8bhbBBfGXjxI10iM4RdIlqnmjY0v927Ux1fsYBdTxDTtKo3auOJqNvmoOFT7kTFcxN9HBjP9iX9WId4RjXrQPdlB6bJ8Xznu9gUs2igpDurgK8D0Ns55qpV7Vqbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+25WyXrzuippma5QtHRS6LN/Fw5xJeR9GHTYiePAS88=;
 b=EhIzAm2bcmA0TR9X9h8nPx9/hvZ3ntg+OUJvEBqNOY8SJv11wC4WgM5xBsbwN38n91rX5vPXGYlpFxIUDylariAi+22hR9846l+zxT48DbGi0tW9HcrJmpbZDx0JGmabdWgohjlLdb+sp328O/gtb8r0wybwf9QF1nw2rOFOlI6dTGjUSLIcDwt/tevvhYFUWtDTal+uDSiv+J4Ju8CtCfkQVhh5LJvkOJQouGPFChwlCI6efczEBjFww6sbCKbWws1LKwmZu26rxc/1J9mJhMtFJtChe0EmVREmJ0fWsWv6DTW7cpAlFgOKfgDPwjzG4uq29Lwrp6j/6gquRZqJwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+25WyXrzuippma5QtHRS6LN/Fw5xJeR9GHTYiePAS88=;
 b=rsPwWuXVmouQse4XJ0bJ0/HrzrvkTuspaaJMeUqyYgtafbG8jNa8x/Szm32bRNpbFN5UnxFM2nEhFmV3avo/MnbAASaRq4LvcvtN5sPG93dqyHMaBmmsPlI7RBtmDvVr2bE6pg/JpsBn97NjsMSuCuqOR7jJ74GtydlqJYYnYo4=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by DS7PR10MB5005.namprd10.prod.outlook.com (2603:10b6:5:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:08:01 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:08:01 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 14/24] xfs: fix an off-by-one error in xreap_agextent_binval
Date: Mon, 25 Mar 2024 15:07:14 -0700
Message-Id: <20240325220724.42216-15-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240325220724.42216-1-catherine.hoang@oracle.com>
References: <20240325220724.42216-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::36) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|DS7PR10MB5005:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	0HRRTmqewiKVbOGMwSnVmmnzy6nyDOyYJozPC953T3GdeY9tHoTJhZ74/scsHm6zcxjRoI9kQ4R/OOwdR1sZyFJZ/Tz6zYPAayyWoAaomkPOAygw1QAIlM/efih5Xkh02ztiFpN19nNO/pixerJab6mzZlPRZnN9rVC9IUw1EbteRXGehY8vRKtR4eELOkiyQ49CVCZmeRg3GnQ8NzHUibUkHoJlgUBEe5MdC79AxkeHulldZJHd6GgmH/ZbZyQP4QeGsSCRbSH9KKY2FOensm2479JezJQuB/u9587G3f3a9Q03r4Ef/LHnDhVu24lP7ipzQM6VWMe1AJxRg3UtRgw0QOmpHphFuQAfcZbZzaG7FZBNGI35NzC4XnlCXse2QoXtheHxm5+K3fCd+vqEERcjCNBBTAI31oWlJLai9kccFHuplPr+s2G552IcEQ3cFuXcUCRRX1sl7C7Tm7/xWTh7trVdwOam6F3LgLvmm4DTzuarFMDVQqUdeB4iCoX78I+qKwRtgsrkGd8H7JNppv2pZLYD1C8W0U5gukICr7PsvQ+n/mza529aSJgl7hrR+2h/NkhEWq97NU5ZehXQU72bwEceY5oDKhD6Ky1lyiXP+Le9gUqSXn1C0TXPLTmbyXRrVosoOqnVrJobJZNE+HX/RAF6QGKJd0GIWVOOGIY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?UV+opYZXSepD4kSu6w6oWOLQafBK/e923Qkc6CLXYGF98X8rGQSYrcqv1Ljk?=
 =?us-ascii?Q?lV1a2LXeH/yYiSh5ABpdxWvpFcDHEim52iCu9B9TFC0QuomRru8wUTtGq4A+?=
 =?us-ascii?Q?qG87h/xb1bWKLBLhvaaNgAn6vgp/S2HbCDX4F19JLxmIAdGo/dHmOkBO7nY8?=
 =?us-ascii?Q?OlXHEMPO7oRmv0wSZGg+v35kY+XBdNwdAmpioGryiV1vNr3wZUXksqIu8oJy?=
 =?us-ascii?Q?s8VKlohbgZyKVR6DlefhO4TPTtthfdJ7eilGFA1dYRb527YyXBd1fKFPjnDA?=
 =?us-ascii?Q?KewkmaXLd4wxF2E8dG9peU1lasJWVj1KUR+VMrDQaZvA94P8ugP/kMuqi3gC?=
 =?us-ascii?Q?pnPIsI0P1kBVi5ENNvSMGovimA0e72gsZKPZXfzHRRX4mL5jXot82rRdq6b5?=
 =?us-ascii?Q?Z7G+OMRGWI03EODw/dq1g2z05M49Mqq6bANIad/lAaBa4h+T5hkL1p2h3okY?=
 =?us-ascii?Q?YOaZPQD5gzoZi1mVNeBxyjVDb1wka7FkmE3/Cqe1oyYgWvNn4VqkpG5RD28O?=
 =?us-ascii?Q?ctWsQhcRlROn9qCCZB5TvNXF43TwIn8xIuqaN7ggoOT0E7XEYMwwwOW5VM2W?=
 =?us-ascii?Q?4YyPDfCQlFccDLN8t/lpybEqT/rQervvwVyI0Q3N+ljRMl/N6O3cxAog/GOS?=
 =?us-ascii?Q?ezrzIMey7pMM1q5hXTxYZac7IvevMb24M86f5fdTXQeJQgfNW3VByrxnhOii?=
 =?us-ascii?Q?LwqXF1VKYOOXL4mT0b1pNI0y2s7ZnfYUXTH5KjqwcIsPjZ4h4uwu6ZxNp8oP?=
 =?us-ascii?Q?92od6R3YLGlStJ8YctkSTxyDR6gtoK1mAcmM5wzqRtcbPeDYT+i7d/9JoOAe?=
 =?us-ascii?Q?zKC9XlPYDsgIf0iFL6TEnWEwTX2a7B4jhz27xAMpKLxUGT9ST3BdgV+MV3Oc?=
 =?us-ascii?Q?Wb8BJoY0X9iLgGnCG9+i8m3GsdaylM4hZ/DsIJZCZgGlJbbnu+HM9nxLeqZz?=
 =?us-ascii?Q?lFtaZi+4APTlflPaJUJfSzgaAfFn6/mvRqwWJXWPkaePpjBR6NFAFBpQ0ATy?=
 =?us-ascii?Q?j/PN97ZoqmciEjhh80e5uox3vurCb6eNvQ3MCYIkjcUzF+jXfV953YuVgN4p?=
 =?us-ascii?Q?JrddkG58W7GoVQm1f0c7cKA4WHxErfgQUSP//ws8CMT9xQV02xiQgZ4caLyG?=
 =?us-ascii?Q?EoQgsrHQ6TwpuPRQUVGntwkQ7zAsn3zpfj8iTdK29MPmvju3QVsow6ubWQJT?=
 =?us-ascii?Q?P4BKUOnDjUeOsjRJCjs+uBYKt5t0jipcHBWqnimA6R63FyRWc2AFax2jXfEl?=
 =?us-ascii?Q?UAyUdMviiQVkPUZEwRzTH/+4qRrkNLgPumWQKSeL87iSMqizKzUrpCrswjnU?=
 =?us-ascii?Q?AE3YdbejFYQ8nSr/RnjqEkTfTvaNjoQJi7ZOeYS8FONoCCRcTnb0ccr0Er6b?=
 =?us-ascii?Q?iNSYD3sGLvzacBwfpY6k0OqCvHx2d3Kp2hkJ+ijal/TDTHqR4KKbEKDjFGzJ?=
 =?us-ascii?Q?WBe2+0cuuLV6MRvNImxm6E15GFKTj6L4A3oVsD5ovXipnzsDnHxnU1nUAUWw?=
 =?us-ascii?Q?J48jJ0Xf4JPqd19nUx0CrRB5XYVHfgOKpe4a5LP0+eQkcGKZkIU8DOMUbkdJ?=
 =?us-ascii?Q?lp6Z2ktYJ76j+g7jilBW5y3E/SjWRKy10zCC0mR0Q8TrsT85SCzHa0QfA6sz?=
 =?us-ascii?Q?tQ4M+lxTiex2LrJtVzeJt917FKuSt3RdwkXuADBI6gdSCwQckUUZMxlUyjCy?=
 =?us-ascii?Q?yNybgA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	yFuO9/PBo95NEuqxGXIfgNzs2TiGQQ1lpVSK/TFFXDk9LDa0T8dg8kqkTq95wFYnS3TelT0AH148NQv6Ms0mbZHsAsVvDQqhfVlUW4OukgaThKRnGZy0ZIm6sIJttPEh6vRRwJ05flYFofk1cuxJG9cbi50EmDGmZYJlWkpwBDAHX2pHdA3zmJIxq+LlD4lWjF8CXJD+kTMDeQXz/aokpO9E9mPxELW40IFzy6QOTECvr9GYD91xJmjBR0yNCt5F+jPIntgP6/qQ3dPPxLAJd/GCKaooPFrg1GKUtxS2/YedOjxfDbIZn2XC3RBUDbJAYsK301HAORSHoy5qFt0OvQ2G9otMji0B9jcoJLAHlaY/S9Db7XhYl0V/nzBZZlJGzk1gVhoke6vJfWwpGewsihVUy0alEMKqwpKtzIv620j4JYX9CXa1YFVkr05u9mPBBWLnCQeRBFeRfEJIT+AHtxJ+fNyEJw/+OF9GQoPh5wE/g4+Oiupa6jKilLgPNUCLxP/BzTFk6E066WsdU3bOg3VzLOIhj11ZeakBUjcscUHpLSgmxRwu2v9C/sw7Tvod+jAgeP0lu2leEDXQIn2HK/FIhcWjkqkrfVEs5g3eRu8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e8e092a-da0a-4c71-c2e2-08dc4d180961
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:08:01.3118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vl2e7AQp9pJv12+OTWtTOiJcjLU9P5npdQEONiTX04gLNxk8MBK+8l/uRX/2cpGkz/RNzGt4igCyqDaqazftFhaJ58YY3x7qUdj3B1bxMpI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250138
X-Proofpoint-GUID: PpIx2O4I3XJ23MMcxSlNB3LTSxyRNEnD
X-Proofpoint-ORIG-GUID: PpIx2O4I3XJ23MMcxSlNB3LTSxyRNEnD

From: "Darrick J. Wong" <djwong@kernel.org>

commit c0e37f07d2bd3c1ee3fb5a650da7d8673557ed16 upstream.

Overall, this function tries to find and invalidate all buffers for a
given extent of space on the data device.  The inner for loop in this
function tries to find all xfs_bufs for a given daddr.  The lengths of
all possible cached buffers range from 1 fsblock to the largest needed
to contain a 64k xattr value (~17fsb).  The scan is capped to avoid
looking at anything buffer going past the given extent.

Unfortunately, the loop continuation test is wrong -- max_fsbs is the
largest size we want to scan, not one past that.  Put another way, this
loop is actually 1-indexed, not 0-indexed.  Therefore, the continuation
test should use <=, not <.

As a result, online repairs of btree blocks fails to stale any buffers
for btrees that are being torn down, which causes later assertions in
the buffer cache when another thread creates a different-sized buffer.
This happens in xfs/709 when allocating an inode cluster buffer:

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 3346128 at fs/xfs/xfs_message.c:104 assfail+0x3a/0x40 [xfs]
 CPU: 0 PID: 3346128 Comm: fsstress Not tainted 6.7.0-rc4-djwx #rc4
 RIP: 0010:assfail+0x3a/0x40 [xfs]
 Call Trace:
  <TASK>
  _xfs_buf_obj_cmp+0x4a/0x50
  xfs_buf_get_map+0x191/0xba0
  xfs_trans_get_buf_map+0x136/0x280
  xfs_ialloc_inode_init+0x186/0x340
  xfs_ialloc_ag_alloc+0x254/0x720
  xfs_dialloc+0x21f/0x870
  xfs_create_tmpfile+0x1a9/0x2f0
  xfs_rename+0x369/0xfd0
  xfs_vn_rename+0xfa/0x170
  vfs_rename+0x5fb/0xc30
  do_renameat2+0x52d/0x6e0
  __x64_sys_renameat2+0x4b/0x60
  do_syscall_64+0x3b/0xe0
  entry_SYSCALL_64_after_hwframe+0x46/0x4e

A later refactoring patch in the online repair series fixed this by
accident, which is why I didn't notice this until I started testing only
the patches that are likely to end up in 6.8.

Fixes: 1c7ce115e521 ("xfs: reap large AG metadata extents when possible")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/scrub/reap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 86a62420e02c..822f5adf7f7c 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -247,7 +247,7 @@ xreap_agextent_binval(
 		max_fsbs = min_t(xfs_agblock_t, agbno_next - bno,
 				xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX));
 
-		for (fsbcount = 1; fsbcount < max_fsbs; fsbcount++) {
+		for (fsbcount = 1; fsbcount <= max_fsbs; fsbcount++) {
 			struct xfs_buf	*bp = NULL;
 			xfs_daddr_t	daddr;
 			int		error;
-- 
2.39.3

