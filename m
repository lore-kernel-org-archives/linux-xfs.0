Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A199D7EEE4
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658281; cv=fail; b=XGtY+PWJIcYAHlui30qQUsz83MgG/WFjbaqQjXaAW+OGfupGJ1zddkucflZrUmhco3wxXDigSVtX965679e6DQuJ7Biyze0ps3t1nP0gGRm3JV/5pY3mm3oAv6RlmL7Dsy7Q+fP6qHdklkyjYnADzLWNVfOx1SDfcvXB0O+yMsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658281; c=relaxed/simple;
	bh=6NU8jXfF3y1dMdGjBwDfsEPQOv2g8hDn3+JdauLKzoM=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=o4oAX+qOPGRvZ/PvsqigH31aIA7Gp0rFtHxQAj9eNk9a25XYGnGK1pTnhq8kXhUX92dkw5cYi4Ng40TMxuXCZ0isSrBkV2O6kQ2zYFwcXpUqKP7z77L1DRemCCBi5qOrknEmURhQRv+Ekyb9ugeUJb7xFhqhjz+W0NL6och9TrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Vge3l6F3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=K65uaZpe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vge3l6F3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="K65uaZpe"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxPT0023727
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=F+IEb7c+21Wxpkhnb4dFre/qwU36rFvNI+SL7WfsXpo=;
 b=Vge3l6F3Ff7fLzQmQEKI+26ZN+u+jIRWo6RCvKMyozF3078Jsh4PaQTIAS9i8jjMZO1n
 uRSoTl7gGqs4h78yIcIal964bY/pCKm7NiE2jhY7qH9x1juZqACsKaWIRIN6iAteGYV8
 0ji4NDE1NSMyMtdNT9azH8/JhWne0CKRgAY1jTa6x1Bq/JIbNgi+E35QkQjFeYUr9IeG
 Oo1IREaKDPJxbIkulci390axeEl8rWo53e8r+afa2oKXWwKpwufTdy3/FwVToFtVdrUM
 zjrZ8u7h2qjuj/RWoU/81ho4j/JJ3eefowqSs0sSWQqtrI5UZkq117Pd/xnemLKPBxlG mg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvre2gjjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UM7lKg014564
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:38 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9800uu-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2qQFVXh/jtEHChiBF+KJpkWETKOe4SziIcx1E7LLJKIUKbwvBgkHnmjtBUiuW2ZByetIBmGtitjKOSzIveaDTRegpfdQyCyJoDCeqgb1RRNlPUVgJR9rkACr4igKH3Z8JGnBFkcGh7fNU/Z8pYe1Sg0NSc65o7yUntf4kDLlA1eYD7+pzvauEH926I3vkX/fTLXyQOinyB5ST/bS1rWi8K34m2lFqjN05woCB1g8EynE5GxiMDqb0pd09jDDKRyHj50qhv9/eI2FiPBdB4naoqK72XMpKX3H4Fj+HSu8mzR+gm51ROLwF7yhsm8rHRF3O5SdwWwFpHy3N6Y223h8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+IEb7c+21Wxpkhnb4dFre/qwU36rFvNI+SL7WfsXpo=;
 b=cAQ3yrsFHnhp/qbsl7CI4GoRrwxRkieQaTAq61mfFGZ23hJAoI/aVjsLOXiedu7LSWWJBdd788ojSpImED0wyCQLf7U9+f15pF15zJ0+yWcu3P5V7ZFR8DyfTUOCchNKEhTx5pJwusGj3xmuAMRyl0xL0gsovLEQQwk2XOWL09Z7nQhL71ZPVIYidonz+5z73u0JmZkdpzHP4ca6NzzJ1B++YSAll+PP7KAhQyU1EXqRXb9uZa+uZK6J8AcWW5zG+D7uoZ87BzOhheGSSEpgh77cWjuXjSBz09yKxGCV++LEwRgIkaFZwPmHkPMj/3kZirQ9CgFwCfWY2wXbDhUwtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+IEb7c+21Wxpkhnb4dFre/qwU36rFvNI+SL7WfsXpo=;
 b=K65uaZpeQxfVpT59zE74jq28mJlnp8sz0YhwEy28yXrdteTFzAUlA/vuYLSnFjw7n3u333+WAX69oB0+gg7GoWzGEjw8cdg/nL2h40k4vcnHbhsm3Ll1W54HhspAsnJWFnPDUv6xDq58NQGg5aNOvNKdNofFzmKFcIzXliUgQTM=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:33 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:33 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 05/21] xfs: fix units conversion error in xfs_bmap_del_extent_delay
Date: Tue, 30 Jan 2024 15:44:03 -0800
Message-Id: <20240130234419.45896-6-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0024.namprd21.prod.outlook.com
 (2603:10b6:a03:114::34) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: ee6d7f26-9643-478c-cb16-08dc21ed68fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	JORQdWU7ljEV+3An18K35RLL/6ytMvnKpzAhLGws9prLs0MklgV3lTx3x8JL4MyUOwYJuai6crhk8KLwk7zpt6WEp+kF0EJr7DB86P5Cqz/Fh4CpfuOqBPKh60kLVfHf6Xdqj6rRamEkhflpfj+aqT8ExZSaeaeVoyuZX18FSlVkPMZahcuurJ0MTk9rHHNytMRoC7BySiZcXvjf2Ph+mXhlPSAtn2NAXu6xeuXBclSw7YlNldQutWSEG3J2pP2TcJLki3HgdrizCwG98x1IvBUdL7uNec4OP93wP/1xxsvLJt3MIrAi4Ob6pRWqKcOTYI1I/mM1YiDZeGxBhF/Dn+AZZVdiUBd4HRaH27+a/Vm/L4WsRTLjDO4QqpW6WCNTdm5f4av2B8wvdjG6Ek/fXr7Jek+qc4Q2GemmI/gG4jup5LE8B8cmzDR2Py6dLANuYHtatImWdNcNIQBfgO8tcbx76Mketzfi+fGInFrlf/WN3HUWYx5YmwhvV+S+Ra8MJ3vhZxf/mNmUmZ9+QOBitp/PsIU7dz0BWot0Q6Bv6LqdgfFfzBYvwI81HOrLTgae
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(2906002)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?YemgkLXe2fHlhBo8G0gO8n5F41PK0LyxezfWLRnxxMRZfQ8Wpw7WrhLFgdcn?=
 =?us-ascii?Q?H/SE0kFFnW4NHsNkIiADaYQFnOs1QrWLulVVxoWVxF0+XIwymzBOYNkjYQka?=
 =?us-ascii?Q?oqF5nkSl8f8d8EtfmvKth2WxaNkempuGph695treudMkNyvlAI8uAD1PJS0T?=
 =?us-ascii?Q?YrDPD7SGz+bjiaOjzMDF8UvwvjZlCobrspVoyzFkyV+Rz3ACVBaL4lW+MVJ5?=
 =?us-ascii?Q?ogfbQqeI4bZ4Izx3/nD8HGln5ZYLJBDraGbaH9NyD1BO9RTRuR7BCbsjsYMx?=
 =?us-ascii?Q?4IS2/oOaa896Pdxke5AptCqeHERRwoow9/pZXDDJLMXNT+8EVIrYDdUK7fVa?=
 =?us-ascii?Q?yG/8/DXOweT2jFOCArciINcQFju2L0VDurJRz08IBKVngxAQ5QKzqKlLjH6B?=
 =?us-ascii?Q?2prwJjqNVpa/Ee0VrQVKBXhea5GdTjYh/3Ta3iB+e5C/jbM7inR7ms+0EnME?=
 =?us-ascii?Q?URBcjyRsr6Z+6BhqyE/ApgBixaCdDt3dgxWl/pvDQdo9Mw6D9mzFMlCCnOvz?=
 =?us-ascii?Q?t+I3B2uP4ELEspSTH3zonhJUIF5eDLnzyYMPJuMvzoguYiV8tKaFJ2XKa/wj?=
 =?us-ascii?Q?zlD/c09+69CbXMVEbzGoz8whlR2zytbedA45gvo5yXfbpblMjQe5ISjjqfX9?=
 =?us-ascii?Q?mqMdyNFo/5KwEjBFiC79n+eEmHvtIC2JPuoNI1aIF318mN1i4UcxQMXU3EZQ?=
 =?us-ascii?Q?PuPV7JSSI8uSit4stiMiVMucRTk99N2maSNx5bt2X2WNbxzExa6S/Yj+ms9X?=
 =?us-ascii?Q?blJMYg8Eovb8w77U+Q8iC3L1G+nDgnIghl1SP9p2uo6yGT7MZqsnw+42/+u3?=
 =?us-ascii?Q?ypcVY4EF0ju1l8RLahd0/DMBR2sN5O3hfc3S96SbV4oAFV1A1bW19evIrMk6?=
 =?us-ascii?Q?wBcApKpDo/+yQR4d1KNW0whK/3O9Ff2e4Vum0IcpW5QJT3xOlgIzDpiHAmF3?=
 =?us-ascii?Q?AMh/7mvHBCQfqF5l3+LkH9b8pDXA+b9NVNdHL/C2uwprrP7mINIAxijh2Tmf?=
 =?us-ascii?Q?PQI7J3vBU9pyZ/FdCRtVMPjsONylUggBPyGHnw/Ri5bNd9MNtLw5E6oeTPed?=
 =?us-ascii?Q?ff30Mza+05PU2NvLmxmwglOplf5FsmOpGfCYNR21lupVx7kim52O+1G1c8XT?=
 =?us-ascii?Q?YiLJr3Qaztz1vPYJdcWA3C+u//VHhCKRpOp42wQqHOUIFb49/nb+dCyNyHTh?=
 =?us-ascii?Q?P3+/67bxmuTDrsPUGi2PSjRBd+G/dZzRziDQ/B0qncOYRU725zPKypJIdpdy?=
 =?us-ascii?Q?E5FNg5bvTZ0+lnef/87UTSnS23wGq0nZ7sEnZk/HNqj4FiPoZQApR7Wib+mC?=
 =?us-ascii?Q?BV7ZpA+V8q5k34L9D8I8wKB0L5IUzx1QeTQMvxVwrzfH61EpugbSe02WpAL1?=
 =?us-ascii?Q?ZCmbIMrsakL1OhMh/BcVd5mjoTNRMxUBToE7axMTqW8yxD+4la46STigSy4W?=
 =?us-ascii?Q?4k6kIET/d0RaHkF9tzAhXuN1L4I7G7qXah8omCjpVezSo57T/2FN4HjFv2qz?=
 =?us-ascii?Q?t9xKjmCtTjZDhOc/8q0JS6xpIbK8u3Psxapyci5Ih84qpJ04zomJwHVGQENZ?=
 =?us-ascii?Q?kNUUdqV2xh2sSU20GjPVSRbe0YzLGnBwiQrXi8u9RMCpShgADrpE7Qy3SPPq?=
 =?us-ascii?Q?28b2Q2WmRM+2lfbKq/TnkpIFqx5H9O21k/NtORVyyoibbK3EoP2GT/Un8Prz?=
 =?us-ascii?Q?vw+G7A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	LP1qSOwudMx0mBPRuf1CjCsH4ImPel+wLWX0kP3AKyTwxu7Z6HQkUXRKsIp1Jd2fRLGEmfS1g0emgdNUEOmUb8HgO+ydttSpxGA/83kKR9EXMfKnfccFyI5riRRntxxvKIosiUKLbNzf8C5qBQbwMzkyLqa8iCmFyWJPknZp6gsZMGq56hqwxxQJw4ePTxGD9FOHYhDFW7581dziKbM0v/En+qDFIfeunbI7kmSP59J1mDOypFqVy+eA93YCFvz+hlmF9j2zqmdCzBXAzdqX8XXXCBP4vF4sgfFRhj8ff7MPcg16GtR6zkmEvU2C0QeLTE/ASSICnCFmcF4dAFWkxisVfaBkg8S4T0ePlCmj/ZgTnwarfXa4vHqt45FDeCGelf8eCxhVt2qHTom6slq+0iB3m0YuagdJqtFJT9zUrRcHVKtKYe3l6wR2oCRA+Qto6bWWghM+a7WD0wDoFYLI2w1nGGgUhwE1JHwYp13tyOkbBqX9GVnzyHkOiFl2Are7PfheK7vOPb3fzsltfcTVLFPPmLJDZ37vAUVKemE0q7VOe7AIkTs6K2jGZYm2Yd36UYlwAYciCtz6s04bisc3YeDJvgHLMjvktHDNpyX1s5U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee6d7f26-9643-478c-cb16-08dc21ed68fa
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:33.2736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yirIZSWfS87UTBV7OFMaRYLg+Gb1WUSekvDzKeCF+QrWGGBbxUFevxsL30mCmyGSZpINJNbLw/SXUMKwJ22ZuP10MrIOw3Qe1eyJmO4h+Sk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-GUID: IL1qtIH6PrnmL6VV4DnESmFyiY3Oqvw8
X-Proofpoint-ORIG-GUID: IL1qtIH6PrnmL6VV4DnESmFyiY3Oqvw8

From: "Darrick J. Wong" <djwong@kernel.org>

commit ddd98076d5c075c8a6c49d9e6e8ee12844137f23 upstream.

The unit conversions in this function do not make sense.  First we
convert a block count to bytes, then divide that bytes value by
rextsize, which is in blocks, to get an rt extent count.  You can't
divide bytes by blocks to get a (possibly multiblock) extent value.

Fortunately nobody uses delalloc on the rt volume so this hasn't
mattered.

Fixes: fa5c836ca8eb5 ("xfs: refactor xfs_bunmapi_cow")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 26bfa34b4bbf..617cc7e78e38 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4827,7 +4827,7 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got_endoff >= del_endoff);
 
 	if (isrt) {
-		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
+		uint64_t	rtexts = del->br_blockcount;
 
 		do_div(rtexts, mp->m_sb.sb_rextsize);
 		xfs_mod_frextents(mp, rtexts);
-- 
2.39.3

