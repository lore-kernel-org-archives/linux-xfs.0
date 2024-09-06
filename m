Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45914158D7B
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 21:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725657146; cv=fail; b=VJiWbg7u0Fen1umD4hZKa23oljdhL3dt99RzwVrUlfeBP81/OOsnsP7/jaGEHC3VWUbhqTs6IgzB4H1uv4A8c+8Bs5HlfL3/8nMO1HltQPrkSCF5zQneg0B/ZnDjoIh1la6w6TFNJbPwd4yNdCJqmf6SnML6eDpnFNOsxDtJ7+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725657146; c=relaxed/simple;
	bh=9R5gDYGRkD3zuEAj6D/OwgIiAtThfu1pQPpc/dE4v6w=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CwLLrDaIHmzaSvcaGuWCEu/UU6mAMADr8hYk6wi56ortwUXtfO+ellL+s6Rnx6mZ03/99E0Sj0jXWW0zTfGkwPry3YsLmWZ9tQy4m/nbD+jrRskoJizi9J1G0AGnRtI1Mjgpp03ktSPQOJgHaDpBHyp0jKlLZXnupiPy1YXy9M8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CnGJTo6R; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=q0I4mBg7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CnGJTo6R";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="q0I4mBg7"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486KXVVw032154
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=ryNP2/BUEI5XGaNMf5mCh93xxASKGerHyr9sWS/BFKk=; b=
	CnGJTo6RrOt28m+8f4keCjppie77pmh7elm/y/Og4L2NnvWg7svOXVoIxCRUp665
	GkTFTuPz04cXazEMD7iJclOq6T0IhiVaOnG083QHc9d5y0ch1o/DMcSqotgyzCNL
	VnOlZNIQxL7pbq4lwUFK7QTAKXTDiCxs8rTxT2m8DignhU44K3o7A+nbCz6Lv9md
	AARyNG0dnjuNxvnx8Wj71KsGFclRh3b4fWEDHsz+O0RUZzBT7ZHQ2i8l7ulm0sKQ
	cVUnoIOujaUoYy6GXkPo7jvKWQojWz9ARCY7yjJkMMhZNVVaDOtmj/ApcJdTPS1Z
	GHmV29p3AsVmPaIz94qvRQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41fhwntkr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 486JLXGm006826
	for <linux-xfs@vger.kernel.org>; Fri, 6 Sep 2024 21:12:23 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41fhydejdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Fri, 06 Sep 2024 21:12:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gzPSJtoz55umnEY2funkeYwCTmZgkTF5gpBWHC38tPHzBr9U8fuTIvmmtPkG1c4v5jY69gXvGyGrVvWniP/H8zZX/63PYVAgUtNJhLupPZq+87XhASN0IdK/0Ytf85WG1XFYWboREueIlU+Zad+2n9xnXHBNrKUgWhU34uFaGNfqdOs+5jdU2Hco2qFW8iew+osaYibYkbpm/1OoZ/cBIxsFEz1S4oJ2Gevdp++doHht9+dPfcK+2UVx8VUmUN0WEBRVhdHf0II06xo7GfdyOW456ijpqS5Sorr8JFuOvpT0E5X56c869QgWlFCO13VU6OUEP4Vl1pWlrRgGCd1/rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ryNP2/BUEI5XGaNMf5mCh93xxASKGerHyr9sWS/BFKk=;
 b=X1+VWztrOzd/+6JLDjz4za/MLbqpeK1o7cxObM7EsMcJa1NVvDZ0bw4WZjVL7s4K1AoLSn2uHdKnQameEpoqxZLdjPtHksOCUI+3a8YF1tqNVTHZ22uhKOhDqz2IAQeSkhWWrhIhnLU4nQN8AwGtPnAqxirUPCC/nexul1QnOeNMLV77+KYp0ECa+owx80HaDrj+gd7UYG4ZiFaqNXZaXg7AONZWB2eMTDl8e4JLrGZJbI5MkhyDXomQ+H6knzsRqjGVH39EpZ17bVjuPZLthbAfRdJrIrM+Iu8EBKcKOFsVdUzEmkzzkVNfGlB22dPiLGvkgeuU2HDz6N3XNiZ5vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ryNP2/BUEI5XGaNMf5mCh93xxASKGerHyr9sWS/BFKk=;
 b=q0I4mBg7p56cYgHeCfNhPPaxo8RpeAVgXJXKZBbfjJxzjdDPSvg/dd4NrJp+oeEW/wjY5bez5u0PIzQ1rIFxSCe5apgaU0XUGOws/EjFHf9nIqXTd/t64/iKdJ8WGhn+WDirbXCgclmyIDi9gmkHVBQzXgwAKM1uC6zKYti3KNU=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CO6PR10MB5587.namprd10.prod.outlook.com (2603:10b6:303:146::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.9; Fri, 6 Sep
 2024 21:12:20 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::a63b:c94b:7ed8:4142%4]) with mapi id 15.20.7939.010; Fri, 6 Sep 2024
 21:12:20 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE 20/22] xfs: fix freeing speculative preallocations for preallocated files
Date: Fri,  6 Sep 2024 14:11:34 -0700
Message-Id: <20240906211136.70391-21-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20240906211136.70391-1-catherine.hoang@oracle.com>
References: <20240906211136.70391-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::28) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CO6PR10MB5587:EE_
X-MS-Office365-Filtering-Correlation-Id: d67d837d-0feb-40f8-c9b5-08dcceb89874
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zWEUPVw1LS1mHTbtrcRT1bvusmTgWz4GmQB6UefYueoNZH2JE1/FXz2Ru/ss?=
 =?us-ascii?Q?qx8SI8BIph59j9kbVgSL4dCWTs4OTjxnjVxc4q8xJEiQDOuSijlzhHl3rN9D?=
 =?us-ascii?Q?PBnlLAPByVke0/ZQPPC6prEB8HmasR5SXjYJ6Yw7WN1D4K2VDm05id1FoMln?=
 =?us-ascii?Q?oAy3hBpQE/OhVad8BCzJokiTMnJBtuLz0dHzIelM7rcmN7g9xH9Y4O0SE88u?=
 =?us-ascii?Q?WYPLtzNJ1RROnv3eSG/kZGb1Xcj3gNPKWat7gpDrvT3H0lt9CovHOuvGEgsi?=
 =?us-ascii?Q?+zZZrFZhgRQ6G4UIHiQej/FLXc+vIGOQOwpjXBR3btChVfMMw7O1NZ2ZjnBn?=
 =?us-ascii?Q?vRl6vUe7P4i7NhcrAv4Ad941nE4KNB3pi8Eax5+dulC9FR7bn04fy+3t6u7i?=
 =?us-ascii?Q?P0AHdXJq0WxXlEanES8NkrQUd/L4bPnlH5uZLZ4oAi/6IyXoySkQ4OqdV2i/?=
 =?us-ascii?Q?v2xW4qdD4FW5cppt4hWevtnPGlCMtnbx9VBUgZiTxf6hTakyEW169ACisQaP?=
 =?us-ascii?Q?m7ZRtkDAzcbcXa+TkAXGcFr3gAPWbAEmtkUCvz0jJFZZYdCkewHbU8rdGt52?=
 =?us-ascii?Q?IOlUM8XjngDhLuI26E7DSrwjV12P1yl5So/OxDbsHWPr33GzD1Lt8feo+/D3?=
 =?us-ascii?Q?DpMN86CqeI+Y8cCSkSjE3gggAdP4tEsUuWaVv1+clzWrDnq3Zu+V3TmfpKM3?=
 =?us-ascii?Q?simcYZDy88iQ+lUPjGEVhhtxtPG+QRx6XtxlzcFMd7JUxlEHcS3uBanvW5t+?=
 =?us-ascii?Q?LUlcortVvcx/vZpcQlYLQ71wNU+XBoSRynsa5BB3yzaiextj70v3CnAsySKv?=
 =?us-ascii?Q?ob6WAxZuufaFvC2DpV+tkfEBAZU3cwBGQHpTeoyAt/k7zJUcS83w1G3Jis/L?=
 =?us-ascii?Q?EQWytdJsW4SLD3NX13Y3CZ2aerixNtrEy2FuSxgN59yDEvXfpnFgNFfS+hlO?=
 =?us-ascii?Q?h5+tmRSgOkvCPfGknVK9j5g7KappV6lfRp/ZLuoYWWN+HVfibYf4IFOY+rAk?=
 =?us-ascii?Q?GvU18r9PrPni+l/QoFcvq4x9lw/tNFYJ151zZ2M3TbMlc/XMOTLNZ3yNA0nC?=
 =?us-ascii?Q?2zZww5vWMHxxkT03XYPIpX3sL/uvtT8B6N7DEF6Ix8WFtgQvcCY57aWlOTz1?=
 =?us-ascii?Q?NcPNNKLkJq6e3iSQQ6tBaSGHCcA4kHSFbfwkSsAdWkjB+dJf0y8xSyyw044c?=
 =?us-ascii?Q?re8EsLl+1BU8OPW9apwymPJgo1f1XLE7VtMFeuR0LTgGfoioTo4k6f70Mjk2?=
 =?us-ascii?Q?Ps7jcxCEzU3hnEF6UGNRAp5MuFYxT0LhUcLpO8vgvBJwX+pA1hOXL2J/ScXH?=
 =?us-ascii?Q?1pXy4GSK8lK1lQHTZJdruMhXdmo1FGCdgs18yWjX76B3CA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hMo6CvuVaB2MHt3LqNZ7Rb1ngQmPthM5WhONlu9ew3ODRYJ/peHUagmx/83i?=
 =?us-ascii?Q?CuALzKB74ICOq7RbLMqXPT50P2H26g5PyQeiRPgWh2cp3vDMHw9Rot+vm/xN?=
 =?us-ascii?Q?hZ+BgzuGASSiWzBa0KDPkDLmNRzTwCmLeVYSIfMq8dVED6jM/80szSVC0Wf2?=
 =?us-ascii?Q?RrC2Zve4UMiJ2qYndKseY+E700ssphzoTO23Ut+wdDnN55/ATXLhOKl/0di8?=
 =?us-ascii?Q?ud/t7mujJTmopcooCpSB+72RssrIaH9wmEA2I0+wsYvGtr7X46PSNdBmqEQu?=
 =?us-ascii?Q?ehkKgVdjaV7bjpMZXOLFTLDUg1OYsej3Ny9nXwdMiKSBv4PcOnHKlfOoRxF4?=
 =?us-ascii?Q?vR20r3NU3pvvq+98q7SyJjMNFAKOABz48G05vxz1+x+dcoZTpLxROrQmWIu+?=
 =?us-ascii?Q?Kov30zclxbd1LIn4Fpc047aWoR3nYY6zY33cEesfQyuRzHXW26qfzRYanzXw?=
 =?us-ascii?Q?ME9XK1q2PuZcsgJc7o10lFphdJz6ecEbxzyZFaZbKNlkYeUnZgzr/4shg0hB?=
 =?us-ascii?Q?FCF+cbaV5pCk/mKGdoJhUf1CbK2D3zmDPB8DdyctylNCv0MtwgjWUzmvDhxE?=
 =?us-ascii?Q?v8OgFJ0fcS1M0VtoIGuPPbWlTKII8Jk6b92t+O2HQHGGwiGot6LuugMTejii?=
 =?us-ascii?Q?iDSBlIQY4gPoJBvSgmhvEr76ZaaCjeI56zhrXxc6usehKH4gqWi1Fy61OpBZ?=
 =?us-ascii?Q?9vnawQwGpVOY/yk4rTEKyGnTb0tuZ+uppyuUQU5NacM0TK6+z/yKxdnqVKaO?=
 =?us-ascii?Q?9bjmAHt5Y1Nhj+sMdC5ogJIwBNUfVDneU6MFF7zPsZYz91DUGC+AgnghSSfZ?=
 =?us-ascii?Q?rtGuQYQxWy9QYih13JFu2UImJ2y/Hyf2Jj3Ql3tYhqhOTfQS6o54r1laAxGN?=
 =?us-ascii?Q?92hE1f+7zvClDGosiCQR694s9LpI1QWr4PBMRPw2kRiFB3LCTabqeHNVF6NJ?=
 =?us-ascii?Q?VVD6AFex9csi4JwTVcPjOljEIaFOPpfp81CjWCbYFgPShaqECblhs/V1Rk8d?=
 =?us-ascii?Q?ETEgMtVCjoKiDv8kLP2XxXKrt1bYWRWQFn3ER9mEdq+jA5sdtewSs9k5Lqja?=
 =?us-ascii?Q?LBeadIqcA64FybIGsRGLsr/HFylVq2w3UF77UEYt3XXEnlcicSk7svk6hxjv?=
 =?us-ascii?Q?eCFzjk40pYp4fXZlYwJMaNH/tXJOABLLmBFpH5SnI5whRtOlymm5vLd4Sqil?=
 =?us-ascii?Q?GdypKByjZPe1Cq1eQiHh7KlMJnGI97DMS2cQiPvdUlLz0ja1nhdziih6c2sC?=
 =?us-ascii?Q?xkgtzgkHNbr+hp4zL5jLwEAkZ+t1e2lX6TCAuitNyeRnG0khvJFb0EbFWijh?=
 =?us-ascii?Q?RKsoLoFGLVHPRvabfrbtDIhkk7gApT91+cwT0GSsdaF8KLoXORXps/FY/qin?=
 =?us-ascii?Q?O7CkQu/ynEb2axf55uejkIHul/jZzZDDcvlVslNLcCvWdIkuc+w5U4hyA1q+?=
 =?us-ascii?Q?ybBGfWch7qD7tczBPoslNZQ26jYaPLqciOlgq+q4vkA0J2pppnJL7lUwovpz?=
 =?us-ascii?Q?rPAlhPUD2/XsmBrhkMbrlPeoSw5dox/K+yL/+xINDMCv2n6ezkbNLin8U2c9?=
 =?us-ascii?Q?HBtsWlqe3FKQm2be4PKtbbWbh6BvoJ3n9n21rx8AM46qO2BZVKwcw4DasFDP?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bgCzrOzYSL0ozTuGi9L0baDKJtxb7aC/RR/jPfWC/8cXz4nmIe4YMdTWS9s1FzzF3QGh6X0yiJYAZDNm/Kxyzv4doS+x45C+SaqMcFOxhFjvJy8fWD7bsnLyXo8VVQJCYpOFpoGQU8tkEvRUt53U+18nPl1Qs9NoB/ZP7+zHKrdhOI0LWQHi3SOz5lrxnZ/im7wIOoHJKprYkcOHIWxCVMr8AleYt6JFt0zRYoTwcqlWkxp4m8ZwkI7/LftnHlghOD2kQzxka0Bwhkm5hy9H5BWJ7YRwCSnVmvFq2bwTBRxaIscd377wDMIeA7GWn8L9nL8Dg6nxsVxCzH441wEGZ6sI1WARHdB//3iNE0xG7sCq9gh7fLrWIc06kNDGyI05mGdKCyj5/JeWdsKOR21rvCTQ05r8TSMBwOucwRUpmjxhZ5gySWI1FUfNp20oAxetV+IppWRyc3WYH0SsfIIyW/73vBUEhRCgEZ55hWvQ8LUxWS5CQmTD30jrJfeg5w+S4N5gxVsq3SDxz3YYiXKzS6j3J+TE4VB9HFXADgn8xIpJ21vQWUPb8qlS0xNNW4vCrs47ekCPbwVq/Vn+lshdd7cBf4Xg+J96GqB+n7+ihyc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d67d837d-0feb-40f8-c9b5-08dcceb89874
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 21:12:20.8150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j5dgPS4CaFymMwMQsYLZ4hRLUc6koHwK/PQFG3GoBYSAOMq5imJ2tqf5pDD1nfGFbFUif0jUFEi/BGkmqgJwG5zhTodWR30LumW1JSdhFSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5587
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_06,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409060157
X-Proofpoint-GUID: B62xc2MrBBPrLXOZqIMaGNj-lT_3wumC
X-Proofpoint-ORIG-GUID: B62xc2MrBBPrLXOZqIMaGNj-lT_3wumC

From: Christoph Hellwig <hch@lst.de>

commit 610b29161b0aa9feb59b78dc867553274f17fb01 upstream.

xfs_can_free_eofblocks returns false for files that have persistent
preallocations unless the force flag is passed and there are delayed
blocks.  This means it won't free delalloc reservations for files
with persistent preallocations unless the force flag is set, and it
will also free the persistent preallocations if the force flag is
set and the file happens to have delayed allocations.

Both of these are bad, so do away with the force flag and always free
only post-EOF delayed allocations for files with the XFS_DIFLAG_PREALLOC
or APPEND flags set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 30 ++++++++++++++++++++++--------
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_icache.c    |  2 +-
 fs/xfs/xfs_inode.c     | 14 ++++----------
 4 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4a7d1a1b67a3..f9d72d8e3c35 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -636,13 +636,11 @@ xfs_bmap_punch_delalloc_range(
 
 /*
  * Test whether it is appropriate to check an inode for and free post EOF
- * blocks. The 'force' parameter determines whether we should also consider
- * regular files that are marked preallocated or append-only.
+ * blocks.
  */
 bool
 xfs_can_free_eofblocks(
-	struct xfs_inode	*ip,
-	bool			force)
+	struct xfs_inode	*ip)
 {
 	struct xfs_bmbt_irec	imap;
 	struct xfs_mount	*mp = ip->i_mount;
@@ -676,11 +674,11 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Do not free real preallocated or append-only files unless the file
-	 * has delalloc blocks and we are forced to remove them.
+	 * Only free real extents for inodes with persistent preallocations or
+	 * the append-only flag.
 	 */
 	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
-		if (!force || ip->i_delayed_blks == 0)
+		if (ip->i_delayed_blks == 0)
 			return false;
 
 	/*
@@ -734,6 +732,22 @@ xfs_free_eofblocks(
 	/* Wait on dio to ensure i_size has settled. */
 	inode_dio_wait(VFS_I(ip));
 
+	/*
+	 * For preallocated files only free delayed allocations.
+	 *
+	 * Note that this means we also leave speculative preallocations in
+	 * place for preallocated files.
+	 */
+	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
+		if (ip->i_delayed_blks) {
+			xfs_bmap_punch_delalloc_range(ip,
+				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
+				LLONG_MAX);
+		}
+		xfs_inode_clear_eofblocks_tag(ip);
+		return 0;
+	}
+
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error) {
 		ASSERT(xfs_is_shutdown(mp));
@@ -1048,7 +1062,7 @@ xfs_prepare_shift(
 	 * Trim eofblocks to avoid shifting uninitialized post-eof preallocation
 	 * into the accessible region of the file.
 	 */
-	if (xfs_can_free_eofblocks(ip, true)) {
+	if (xfs_can_free_eofblocks(ip)) {
 		error = xfs_free_eofblocks(ip);
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 6888078f5c31..1383019ccdb7 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -63,7 +63,7 @@ int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
 
 /* EOF block manipulation functions */
-bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
+bool	xfs_can_free_eofblocks(struct xfs_inode *ip);
 int	xfs_free_eofblocks(struct xfs_inode *ip);
 
 int	xfs_swap_extents(struct xfs_inode *ip, struct xfs_inode *tip,
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index db88f41c94c6..57a9f2317525 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1149,7 +1149,7 @@ xfs_inode_free_eofblocks(
 	}
 	*lockflags |= XFS_IOLOCK_EXCL;
 
-	if (xfs_can_free_eofblocks(ip, false))
+	if (xfs_can_free_eofblocks(ip))
 		return xfs_free_eofblocks(ip);
 
 	/* inode could be preallocated or append-only */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8bfde8fce6e2..7aa73855fab6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1469,7 +1469,7 @@ xfs_release(
 	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL))
 		return 0;
 
-	if (xfs_can_free_eofblocks(ip, false)) {
+	if (xfs_can_free_eofblocks(ip)) {
 		/*
 		 * Check if the inode is being opened, written and closed
 		 * frequently and we have delayed allocation blocks outstanding
@@ -1685,15 +1685,13 @@ xfs_inode_needs_inactive(
 
 	/*
 	 * This file isn't being freed, so check if there are post-eof blocks
-	 * to free.  @force is true because we are evicting an inode from the
-	 * cache.  Post-eof blocks must be freed, lest we end up with broken
-	 * free space accounting.
+	 * to free.
 	 *
 	 * Note: don't bother with iolock here since lockdep complains about
 	 * acquiring it in reclaim context. We have the only reference to the
 	 * inode at this point anyways.
 	 */
-	return xfs_can_free_eofblocks(ip, true);
+	return xfs_can_free_eofblocks(ip);
 }
 
 /*
@@ -1741,15 +1739,11 @@ xfs_inactive(
 
 	if (VFS_I(ip)->i_nlink != 0) {
 		/*
-		 * force is true because we are evicting an inode from the
-		 * cache. Post-eof blocks must be freed, lest we end up with
-		 * broken free space accounting.
-		 *
 		 * Note: don't bother with iolock here since lockdep complains
 		 * about acquiring it in reclaim context. We have the only
 		 * reference to the inode at this point anyways.
 		 */
-		if (xfs_can_free_eofblocks(ip, true))
+		if (xfs_can_free_eofblocks(ip))
 			error = xfs_free_eofblocks(ip);
 
 		goto out;
-- 
2.39.3

