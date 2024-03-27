Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D2F2119;
	Wed, 27 Mar 2024 00:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711498369; cv=fail; b=nVUZ4znxj/C9JdSORFpEq5lKRCmDKdMgNTFYbbqCPK+O+HdN+JRw+0G9wk3TZAfWeGlTxx1FvYw07873OnYjhfcKSh1X4eWsg/vPey8jEQwX/sCLyFrE/e0mc/6kg/ZHJaifnmzykW8W60t4ISycocmH34QMqUwNdlsqFyx9QwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711498369; c=relaxed/simple;
	bh=HfOOvjKrGWUn0v29qT5EajaaK2ObVSEid1hruf+1Fxc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=pqAkcFmOqJJ/K6T+SH4R52v+SYohvyFCG0/NpFheARcMLDgAJn4S0Y7Y1k1yIlv9KshTUJxtLvwzNDf0Dj8uxJ6I8KkxcNczq9FRK5vBK590y2v2knlmQj0cOcrGI6FlaI/hxhfHXHwk9uO34YyksyUDDMHvSAvNLH0z3exDqvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U3zRBZ8q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uyr0o/5R; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U3zRBZ8q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uyr0o/5R"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QLilFr026106;
	Wed, 27 Mar 2024 00:12:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=Bsc4Igaw3xdUnQ2p3JAZtcOr8XidWcHYgDjautW+MUo=;
 b=U3zRBZ8qURVPsujm0scEINh8I1m+6Enc5GoWiCKft9kApBYS0ZB7fuyI0m5hSxTACBin
 cDnxywowwFWOWrFtynvYiMETtJGNsu3o+pb9L0bhOvycfuIiP9rVseVXNUQ5W2anFCAU
 6tsaiWjfaXz9XKlkSF5EPJasXKqQhMff07pZ/UO2RANjaSFP1YT8zHofD2iJiI0qXh2A
 nl3YKicJaidNv1TlYtfssJAvMNzVzzFob+i7JH3IONoFYVAz6D85qErwLbzwasiGgjCH
 aTC55u21vMNdq8sd3SOXiV2zKTrUDzlMWy5VVQ/CRJP7f7DFY1YmGSUWkLRezSxwl6U3 wQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gvsch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:46 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QNdLo5021933;
	Wed, 27 Mar 2024 00:12:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh80wyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 00:12:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2dw2jjCBofRuLd+3c1BvxdoLRvd1IWFoOe62KwfXD/URloTVxrnvR7zNXU+Kqa5+HnSnFe5vxOWqko0Pwo3lhiyS/2FWIYW2IMMH8fWNXPWgxsF9DeEb/c/hinGNMQdVlMItpjAcHXz0kdOkT8KbWCFN/o6V+mz4hIdaPgU/FTSzCtVwAsmVL1IUbrB/EuHUVOODhFpA2mGzEvLp20CxnMD8v9P5EE42g4LfLYVud5SU7RjGAkf7kJG63jPv+Eohf8kgZZCN3Y4i7VuDf6Yy3iqgusfKZ4DdRZPoMG2SUhG/kkOSYvC5wSdUiu1ig6lqRhbB7+fnEhN9/rF3JyBwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bsc4Igaw3xdUnQ2p3JAZtcOr8XidWcHYgDjautW+MUo=;
 b=Bpf7+UP/Ze2CA8Pl5Ixb2iJXZzPF8jU56e2IRZkUtiQ/DlMCesXPUERSPFA9jArp1MQYS/QFbZBwj5eh8TbWvw5bNYp7TKEbwcm9QcXE8CdtmeYqz04IZ5UqlLVwBOIrdMaZnv3r2BZQsdHqQ7JMStII+H3AGr0L6bKeZBXy2HS1+D2MmkFNvedrTw0z7Q4mxnDX3HxQQ9QNW9cgPVwNFBSFzz81AAdqgnuVQW/088ljSi5RI1NaBXNjZW96Y3fqZSP4C+0mUBgGoOcr7p+IrjMpFsCTv6qeH/VK0S6A439RteYxL957WgONd3prvAm4213JnvnP7IbV+Uce+RrvnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bsc4Igaw3xdUnQ2p3JAZtcOr8XidWcHYgDjautW+MUo=;
 b=uyr0o/5R6Xi/tasSWuelkd4D3KvBfSbpJ0AluIINNAwTwXcbKsd1oNGvMejHE4aBXYf9P+RWLbnkB9Uq9RFDwSVWrfzpTcS9Yx78s/H2lXN2yNAeV4FnQRBrls8yYumlEnLHLnI0SQVixp/yEUCEbzSah8BOVDogCqeiL/E8GYg=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6226.namprd10.prod.outlook.com (2603:10b6:510:1f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 00:12:43 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::404e:f2ff:fe2c:bd7a%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 00:12:43 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 00/24] xfs backports for 6.6.y (from 6.8)
Date: Tue, 26 Mar 2024 17:12:09 -0700
Message-Id: <20240327001233.51675-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::14) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6226:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	vUSV+wl8FOGAbLht3uC9GhUB7gwn1kcmLzCIHZa/jemN3jEdUDCXbDWNpuk6TGSfhtuw7gRzyzcZHwPLVAY2ru8n++Iga56cEhX/i/w37HWu0x+WCsytnCyuf/noVxoI5z4dYN9CoiSR3wfzNoecq9HqBdeioApT9WlfKj1NNkjvWiKQcDyVzuJ+A99Rmhz4u70kh5u6DHj+J0t+anbyqbxeSxJ0UuU6VQ8acIus2A5p3+pNFoJ1jaHIIC79NlkYjJHAaInnead6W89jn3Zbf2O/fmyAOH+InJbTsUVmstA2YNh41h8b2MqpGMCmP8X5pFRh5/tyEfUpeWea1JAPdgAeRBWr9er4zPkmI3naDQjruSks//KJe1UaMm70fnRB4Q0HdyB2xFa1MSE6ejQiB0ECUs7WPNZiPwrwQbvgm0ryQASxK5yJMBEgOnc+tsa9XUkfhTcoKlp7zkity6Ji3pbecAw55EaJTtHGjS5FS8eq8yiEVm/FmEGx1xOZZ4kvb5QKa6apPe6Z2GzHoWxGgUHWsrpBTJNs+q1SiY3DEEsr70jW6CLqeSW+JQGNUGrr0Rgtv8+DUHyTxx9xY/xGeH+j6SNjcVN4VrZyDAJ5f22RCnOJhUL/yg1j3hbIJLhgZee8V1X0CrBIeA3u/5gylCxLc4mCQ/s8C2BfQDy267c=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?sHrkAjjiwq7No2G1X0timkqOIbMH8cbH0PrMoiWTCAetARdSkpsqwS3L/Wwf?=
 =?us-ascii?Q?6hw+1Va7+AYiZ4pUfBBIdKAEqjEURj3cGYzP4KF2ACTiSk8eGgqdWu0YdsP8?=
 =?us-ascii?Q?aNKOGuSbQ4M9qFpSM7jCahmk5Ysdfe3VZNQjD/uK0Ss18R6U8YOOy6ApIfL9?=
 =?us-ascii?Q?ooSQa6A+CWW+J4HY1YWN38S0hT57UgWAaK0ykF+v49t+lOWmcF5THlKK+n7v?=
 =?us-ascii?Q?gcghijtYgpgmGbQX1lbO4H3ctrL7B42G5f3QAh2Pqj30O8A83DYGrsXxDW8s?=
 =?us-ascii?Q?dU2312bY5IRghwqqreOE3n21LRqUwFd0Cvb7JC2kmOShu38w7FUqgHyK8seg?=
 =?us-ascii?Q?eBzeDsuah8xAG4Gd2jqIwkvkMRGTw77L96M8rCSlIpqsWNNiKhESt/g5LoAz?=
 =?us-ascii?Q?2mO/+hv3Axn6qWVtIZhSksieXPC+CTTaDGg4bRZcIAljzCVzmN09yiO79xIV?=
 =?us-ascii?Q?vHeaql2hrqF4kOnaUynaEzH8IqLMWLT0Z/mjXAgBOVJQ+zpOJYJCPjVdaSgD?=
 =?us-ascii?Q?kBFMBoNqc/4UOhKaWm5Xiie6cs9w0AS3lvC9OcpQxyA178fsf8diT3NmY0VM?=
 =?us-ascii?Q?ktl3SE9jOTK5XIvB6n3jczWNx9Fh484NVRO42na+aFpbPjGungupOKENJsnw?=
 =?us-ascii?Q?2R4/2JU8RamfRGP/LvKknNxN+3ltlsp7PaOhYmwwFFnECY+4Kf1E0rYlhSLQ?=
 =?us-ascii?Q?I3Ab90v/x/EBhrEdVD3J07sln4I6Kbo5kXKIpCpIyPgM5xqkdm29NvKfgjYZ?=
 =?us-ascii?Q?U1nywrP9R9tFaLXGjktFBotlwMenzdNUwhWljTCVwkWUH/PzRn/M2kohHooS?=
 =?us-ascii?Q?WCAMPfoew4lah90vw6wM1S4N0rwv/uzG3HF/+nVZ78gVOBcBfaDK/MkwNq+e?=
 =?us-ascii?Q?omTw5rbkcjtuVnX8g4O7x9Zlk0OIIZSLul9pW1ybfZlJ7ueatvAUGoOk7Ol2?=
 =?us-ascii?Q?2ZYKIzj7ZdPjfacMtKV6ANYCNKMhMCTGqC/zh2L6yNubwL8330VfDE+/bYEf?=
 =?us-ascii?Q?aRPzBGbbURIJD3xTxEfTsH3pdksLfGPJXlEI5xMQcYWKuszzlg5padg+XHCs?=
 =?us-ascii?Q?AmupXU/TWmKYQ0YsAYVrb3Hj19GLxB8f55XMAdvGOl1T0xWFDIzTXFuCJs2p?=
 =?us-ascii?Q?7X451DAx8Hrqu9J3Tr1M8cdNvukMLqjnfKp0PZTZVuLyR/wsxMWOLOaWiur9?=
 =?us-ascii?Q?XzEQ5eQCjhL1IyLMrY5daZCgw4pRlbAEwtCqea1JH7vux24AMOA3fx4bLWPH?=
 =?us-ascii?Q?bVF3O4P2NlpyKf0D34Yf8iFoIjwM2eJ/8aEeQsfyAjnzgBqxKGd4J+dLw7hY?=
 =?us-ascii?Q?tLvBZkse1cKuoeTucHOvyz/BiqPKibSBt8brCLZnSzzSdd6d+gXm3vZm48t9?=
 =?us-ascii?Q?qsgxLDTVwPB+BTmiaiMc8K6fR6cInESC/gKg9c8NwVSk8N6e6LkbBgSWoRNA?=
 =?us-ascii?Q?BwcZ7iEaGT9I0QtLCYMMALuJZEGlID3SGXE5SzuHsDv4Ujdy/ynuULHS+EYU?=
 =?us-ascii?Q?zpHCf9hdIzQUsgn6DMJjZbYTIi7i6XS4LxAbLR1t+aTGZq16rrfHtJP7Fzg8?=
 =?us-ascii?Q?9esjX2scI8nQRSwCBnpIJm4xiYFzBek59QSQg9yOe05Vc7CQOEBHdtGhd0wM?=
 =?us-ascii?Q?f3/L8AW6cH18t8EgUFaIqOjJTJA46tWDZ2xr/E1G5pLavdaWGjz8oVQtXzBL?=
 =?us-ascii?Q?NNKBPw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	tv1pg9qomVACDOdyS8wbWSYfmOH8I0v+JGR0FVSFTplqJZcdP/TskV/WgOsteG80GWsx+fFQZE1D4fOhMlXlKgCvk7ACG4TP9MSSOGZEFPatc94Gq6ykyM2QfYU0Q43ib6BSYwa6/CMS8voBPXs+yUZJWZWe5w3j792i3zLeH08Km1W11BnNYBBh/Odd+BCemRVBPxpPeD89qnmc1p56NxDa/W+dcT/RbAJ4GWONA8syvjaAmO6naudZGR1e08kcZtkb1pzr1O6e6U4QEcIGmXCNf8ZBlgijXFL+T1iysAH4WYI/P645vlQKLiGZchtVh6RIXHtE1SHOuzODNtTeowpgnayXtDaGdRzVcZp8fOT5iY32zDMhRVaAv+auMEmDVWAGaWcxSyGotQiXhqqquv2sy424zxshjPadQPhrzxmyM/lcqcOTl/SzEoWkeZf+kcTZ+4zZikmxg2NjrxFXSZxQrnr4sZLjIq//HuTf6Ub1s2K8FsHs0+Kz08XW7Qt1X7gTRneDJKGydcil5ONk0e2btAu3v3YpeFx66hMO6fO4O9C25TqmrIPLnimP8TSjLq3Kn4uUcV2Ze2RqNBy/KSnna3DcMSZQsTMSnwSfGk0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18b705c3-8ac5-47ce-1c4d-08dc4df29f38
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 00:12:43.0114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5DjYme0BgA3+bLYobgPff7opLpvDm084tn4kVNqljFjgIy1eA2WZgoXBcuV9zcyQ1EJLKYPhrBz9mTsln2BM4rU/3DNpfBP3Mwu7d3xpwn4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6226
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_10,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=912 phishscore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270000
X-Proofpoint-GUID: QCcOX7VF86axe8fSQiPsqaGtIEbxM-oC
X-Proofpoint-ORIG-GUID: QCcOX7VF86axe8fSQiPsqaGtIEbxM-oC

Hello,

This series contains backports for 6.6 from the 6.8 release. This patchset
has gone through xfs testing and review.

Andrey Albershteyn (1):
  xfs: reset XFS_ATTR_INCOMPLETE filter on node removal

Christoph Hellwig (1):
  xfs: consider minlen sized extents in xfs_rtallocate_extent_block

Darrick J. Wong (16):
  xfs: move the xfs_rtbitmap.c declarations to xfs_rtbitmap.h
  xfs: convert rt bitmap extent lengths to xfs_rtbxlen_t
  xfs: don't leak recovered attri intent items
  xfs: use xfs_defer_pending objects to recover intent items
  xfs: pass the xfs_defer_pending object to iop_recover
  xfs: transfer recovered intent item ownership in ->iop_recover
  xfs: make rextslog computation consistent with mkfs
  xfs: fix 32-bit truncation in xfs_compute_rextslog
  xfs: don't allow overly small or large realtime volumes
  xfs: make xchk_iget safer in the presence of corrupt inode btrees
  xfs: remove unused fields from struct xbtree_ifakeroot
  xfs: recompute growfsrtfree transaction reservation while growing rt
    volume
  xfs: fix an off-by-one error in xreap_agextent_binval
  xfs: force all buffers to be written during btree bulk load
  xfs: add missing nrext64 inode flag check to scrub
  xfs: remove conditional building of rt geometry validator functions

Dave Chinner (1):
  xfs: initialise di_crc in xfs_log_dinode

Eric Sandeen (1):
  xfs: short circuit xfs_growfs_data_private() if delta is zero

Jiachen Zhang (1):
  xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real

Long Li (2):
  xfs: add lock protection when remove perag from radix tree
  xfs: fix perag leak when growfs fails

Zhang Tianci (1):
  xfs: update dir3 leaf block metadata after swap

 fs/xfs/libxfs/xfs_ag.c            |  36 +++++++--
 fs/xfs/libxfs/xfs_ag.h            |   2 +
 fs/xfs/libxfs/xfs_attr.c          |   6 +-
 fs/xfs/libxfs/xfs_bmap.c          |  75 ++++++++-----------
 fs/xfs/libxfs/xfs_btree_staging.c |   4 +-
 fs/xfs/libxfs/xfs_btree_staging.h |   6 --
 fs/xfs/libxfs/xfs_da_btree.c      |   7 ++
 fs/xfs/libxfs/xfs_defer.c         | 105 +++++++++++++++++++-------
 fs/xfs/libxfs/xfs_defer.h         |   5 ++
 fs/xfs/libxfs/xfs_format.h        |   2 +-
 fs/xfs/libxfs/xfs_log_recover.h   |   5 ++
 fs/xfs/libxfs/xfs_rtbitmap.c      |   2 +
 fs/xfs/libxfs/xfs_rtbitmap.h      |  83 +++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c            |  20 ++++-
 fs/xfs/libxfs/xfs_sb.h            |   2 +
 fs/xfs/libxfs/xfs_types.h         |  13 ++++
 fs/xfs/scrub/common.c             |   6 +-
 fs/xfs/scrub/common.h             |  25 +++++++
 fs/xfs/scrub/fscounters.c         |   2 +-
 fs/xfs/scrub/inode.c              |   8 +-
 fs/xfs/scrub/reap.c               |   2 +-
 fs/xfs/scrub/rtbitmap.c           |   3 +-
 fs/xfs/scrub/rtsummary.c          |   3 +-
 fs/xfs/scrub/trace.h              |   3 +-
 fs/xfs/xfs_attr_item.c            |  23 +++---
 fs/xfs/xfs_bmap_item.c            |  14 ++--
 fs/xfs/xfs_buf.c                  |  44 ++++++++++-
 fs/xfs/xfs_buf.h                  |   1 +
 fs/xfs/xfs_extfree_item.c         |  14 ++--
 fs/xfs/xfs_fsmap.c                |   2 +-
 fs/xfs/xfs_fsops.c                |   9 ++-
 fs/xfs/xfs_inode_item.c           |   3 +
 fs/xfs/xfs_log.c                  |   1 +
 fs/xfs/xfs_log_priv.h             |   1 +
 fs/xfs/xfs_log_recover.c          | 118 ++++++++++++++++--------------
 fs/xfs/xfs_refcount_item.c        |  13 ++--
 fs/xfs/xfs_rmap_item.c            |  14 ++--
 fs/xfs/xfs_rtalloc.c              |  14 +++-
 fs/xfs/xfs_rtalloc.h              |  73 ------------------
 fs/xfs/xfs_trans.h                |   4 +-
 40 files changed, 492 insertions(+), 281 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h

-- 
2.39.3

