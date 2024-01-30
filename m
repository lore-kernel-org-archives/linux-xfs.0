Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFCA78665
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658283; cv=fail; b=NN8Kub/BKCl3gX9Ouoc2VLwr09TXza1vgoMbvy+qI7oXSBmgzmPc45IOKyZC652Z0nAzXA+RslQuKCnIzqXb3EIagA6Lxqkq6/iNMX6WuADYM0XPCh9jlLZ+0pvdYRGQQ9wS0u9niowu6X/O3qYFIDkgxcDO8ftP1ZafrQUMaHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658283; c=relaxed/simple;
	bh=9jdLXbKPGvpjeGaLcBjPtQQ8gALOgO68AiaPajhH/JE=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gIwAcdCb/l5+YIkJDwTIziYP1T3ByK711a7aFiFtLTCSdGDlL3WlSQubJwDY4CI9HofasfMJ5bJJnzzzFinTv2M5iI9Qk2aYt6w78k+YrQbxKOSGfCtwjlliydt4j+fnxUfHjhYkMqbJLDSEJdKuz3Ib6TW+ydewoozSGQsq7xA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PPu0qaJw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JI7AXVF0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PPu0qaJw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JI7AXVF0"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxubB030724
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=dH6ITgYzGSAXRWxmWl+up8WZ2wFyu3w11rbk+rKMkdE=;
 b=PPu0qaJwKHy5ygfNPTSIpjgI/C7vkn3cdanDWrJnFJ9V9+XiqXJz/trlnDI6M2M1UTch
 993q6hcC2ZPsSKi6IRHHvKtGf68w96qhRuzhHgx7tilLc2ImPPEgq1XT0CwDb6ojvzhX
 vmQq9joWhpeUX7Ze3QLo1u6WhxbL6sz6d7nXAwLs/0OV5UVNqHoEfoGxTQeGevvRxV65
 kfpGuDJIF8swv5dmOHh+tlBH89xRgRJGpAplUibRn6WJ1voI16yMB6tSv6HyZrljrKja
 SzgEZYJr4UuiovBcayfc5pxtBcV0iTQqDyyJy1iVUwPNThQ5xq/81HoPij6oBYN+XWC9 Zg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqb0d1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40UNdDDP031587
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:40 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr987ujd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 23:44:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7h9056rDfVeQqboAsWkx5ZpRe6fZVMZ79P+MlOlm/NbmFSi9c8zgQmnv3EUOBnAA2KnSL0euTIU9ytD4849molux5A6LGl6kRFXvTp7EIS2QhghuKmJnQQ+EjZdnwq/4YhIpv5BCPwHev1OPebfY9reCv8Jh8ymSstPPynlKiMlAT/liqSawacoNdVYkf3dUvc3wnz7fzWVMxOunVpW76ptsc79B4YclJBW7YYIjv3NUUx8qZfHySMI6FpEB2qNs0W70261qfzyW+RoAQyvDL2WRpbiLSKZX/BHnpzQTtkLQDe93icWJDVkUPOYqBdcpc8z3Z19ubDDi1uiJvgpHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dH6ITgYzGSAXRWxmWl+up8WZ2wFyu3w11rbk+rKMkdE=;
 b=dZ4ZTVqWUl8Gt3otk0bfvq5VkDinlEsIyZBYhBg9CMxmvTCtag18/8mEFmvHZVbSBJlYkJBmNkKGvWmNbhxx9F0eANer1Lu41KTOzimOL84DJzAkpp7Hneuxj/TR03S38YEBRb5kVqhtbro1aOl5IVLQvh3wkysoqdqC/dCC3u10FsbPNNfOaa35HMheLdbZCyo2jN19c+ocmW0OviCoWm4R8GP9VP6shTrbHuU+tieZq5N5ZiwfJz0rclqRwBfge0Fz1Mgd0yvy7mN+m7JltlcSlMWcHsIFN15Ex1rfRKHrnIztuOQUXOhNfziLhoznYQSFDXpMKPEaDAtXPBfniQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dH6ITgYzGSAXRWxmWl+up8WZ2wFyu3w11rbk+rKMkdE=;
 b=JI7AXVF0DYZSXyJdHZaC5K6HkHOogdj8qRHWiNEbbyKrI50PAkL/IKKOv89Ae09jrCB9F/pSQkaD1dcDyGhZ5HqpGxGQ0ru/0IGFCO52+Z/bjO1ZMOpmgg/v8W0FY1nigfYKykO0aPvFosd9Fu8AE9mu12KFItScJ5/01sJ1/Gk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5305.namprd10.prod.outlook.com (2603:10b6:610:d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:44:38 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.017; Tue, 30 Jan 2024
 23:44:38 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v1 08/21] xfs: handle nimaps=0 from xfs_bmapi_write in xfs_alloc_file_space
Date: Tue, 30 Jan 2024 15:44:06 -0800
Message-Id: <20240130234419.45896-9-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240130234419.45896-1-catherine.hoang@oracle.com>
References: <20240130234419.45896-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0213.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::8) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: 55fee1a5-0945-49dc-cab8-08dc21ed6c3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4anqb+p51zlimV7PcqYR6NacXEtIWv3XB0ULvQC9of7fWAdfUNLXUZVkVknKSDKByZZSZAamUOY9tEicog1lCsxb6B/+4nwquXVR3mP3ETf85BOBRBwQ2qdfjBmmYtWwvArBvv1GY+uxiUcvLRQLRIMIFMIlwcdCYLx/L1Gt3ffe4v0YD9BrWyD4Egf6BCyNPvBk31GkjW9ngIKoLYKpXBBm6ONUwXf0pq4YA4bHPJyjstRd/flXdJ++Xyx+wf506MzpYvGJRtyhKLghWa6pcyAGrVDBrGsTDg7Gly02/Vp8TRugcKaOIzEzO/r0SFQQC2U94TYtA3TsvdvbzU6KauWmmSuh94gdSE0hvuJe9cXusYTzucL2tyP5Nt8WiPWqFXRQafC9A1FAPHI54uXbUTDGUVa8OIXG9F29PoQTWr8NAoj42je1cwTYB4zy20EioAh6oTxHWCe2imYTcbCCdmutByHYHMmpAvgUt02aOSTikU1xg7BdE3uhXLN1qveUtbDgdkHG2959urBI+1crU7BtSn6Di3WMg315ztjOX5xjlLVcupukiIa0h/NB3Emr
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(346002)(366004)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(6666004)(6506007)(83380400001)(316002)(6486002)(478600001)(86362001)(66946007)(6916009)(66556008)(66476007)(2616005)(41300700001)(6512007)(44832011)(5660300002)(8936002)(8676002)(38100700002)(2906002)(1076003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?OBcmVx5vyjz7cfx/hOJoJxrrR+MmKdmL6YMb3KuBtu1ly+85IpssXozHdUot?=
 =?us-ascii?Q?X1fir7LqDvsUrak5PCvSvB7vQqaE+9s0iF/rSmYFUPFob3rqI3+OcBGIduLc?=
 =?us-ascii?Q?DmobE8BG75E8QUUjmdI+lYlIl/dzymMcceYTQtW3a/PhbGbvt1T0/VcOprkt?=
 =?us-ascii?Q?G9va8lhfnP8iKWW7erRM1yAO1aOVZiobyOmDtKvLziNq3JEx27W113QrTrM2?=
 =?us-ascii?Q?foyUbcrnViLNelFlzdbP2sB+IxVV6kK6j+3wQEYbK8gw/VMCxTajLWuemghS?=
 =?us-ascii?Q?hJUllibcXjH/j3AOAkI3rreimwFIKOVM9AhUR4pSOkMYu9K0htKqX+6+EdBd?=
 =?us-ascii?Q?n1w0NbHHEKGKWOnzheTJvF92zqIX28ss31rs5N+g2RUxq5U5tngm2pmhAr5Y?=
 =?us-ascii?Q?hEd+/COorKkB1czF6pdFm4javw0y0blxz7LW2Q3z4Ms2/1Zev0iAcyX+bwW5?=
 =?us-ascii?Q?rg2MJyH2lO8czKwmZccMTteOC5aNuOHMM53gJw9J7+WOjHjF2CNunC/gE+L5?=
 =?us-ascii?Q?tsjUCFC33M7lpgycn8z8oXNvRvBwlcAld6Sjx1dr/wZl70KWr3gAYVcvMVLx?=
 =?us-ascii?Q?6RzI/odcaxEE7HJASfZ/sIpXoU8O8c6n91lNncbKXtXfs2zhIAJezF5AFN0M?=
 =?us-ascii?Q?pBzCr1HvQ8/ARv3e6cmPeKTcnB4OhoR7YSxFsZhFCfHmTytxLZqEqlN2FV/R?=
 =?us-ascii?Q?7qeMhDmK/JUXN6UOwucK3gQkGifxNgIvpmeIjV8qQOU6eqHv4AMQb+MG6WKu?=
 =?us-ascii?Q?T8tjqZltvtDh+n19YpYLJ5w5xokLfyPVBDF9otjZiXRSHcBkptWB+71JM/k6?=
 =?us-ascii?Q?GO6o3wkLHkoP+TXTFH+991X3PNw1VaFcysxADvdRTUpWw6OGUjOO9b4CBfIN?=
 =?us-ascii?Q?5JLeY/3fQQVAAxuB0wnyyrii8rpdF4OLg4kN5C3ipuBUNNn5zXv7k8p115C1?=
 =?us-ascii?Q?0EXXxnydoqdHGeVMNztlcHkvX63WbV6vDY4Bk/HYyEFUBE9eCitDEp/9XStX?=
 =?us-ascii?Q?5Oh8XXYDNoXm1C8Ug93lh3TocY5EmvNW7irr2QNfpiDvJpdcLjyddpfQn9Yy?=
 =?us-ascii?Q?yLtAycsncc6QA8Gp4N44+zGxF7fKOYEwYrRJPgFbnlIBSQ1eTj0bmt85j85W?=
 =?us-ascii?Q?PQl62jzn5zWxKRy0thCLZifJjNM8y+i1sMnUtou/W3Hndxym1EYxxaxQQKh4?=
 =?us-ascii?Q?7DdWTzKmkvwoL4Hx4LFfpnBnYDq8x3Ef8YQaPmLayO/lU+Jhj3916SNdAxKq?=
 =?us-ascii?Q?LNekZcYoeObQXPFW9A4+IdfoXRXxNnNvyvDvTBf0ofVlZMStf1fav55MaOPf?=
 =?us-ascii?Q?H20zzQ/u+h5TfB461CP4QjSLa7FGfQd/36aSKCm8KK2I4rIT4favhdxMmwuC?=
 =?us-ascii?Q?nONzbJPYzBWY2IEIP26LCamFbJv34ug0GIvfrn6nvwR+pG1cuTUQcMM0npQU?=
 =?us-ascii?Q?gC2ergPC6n8ZmenKl+9heZWqqYfs2URH+BYcUO+CdMc8gDwUBJ2byfkyynzD?=
 =?us-ascii?Q?CkapBh7vZd2q+3pjjH/f7ZfLdhYCJbm3dJSeYz318M+LiR6qZkg9bfK5gM6N?=
 =?us-ascii?Q?tzuWXJPwnFYTY0Us/V00feqeCN5jVk5G3uYIVBwRFpkOR5pk6j2fseRJ1s6g?=
 =?us-ascii?Q?dGZhpghN4xgZGjs5JxpkyuHjUrWCFPkoZZCMkGTireu7CzTWmBJTzGZYClDb?=
 =?us-ascii?Q?0bw8/A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	RDpH8LO9VTcQbBJ9n8qdRmCiDWVZv+gzwSGb3Huj564Ym4yalufz+viTIJk+i9WaKiBSZkiDVf9KoPzC2TOrEtf0BVvQRMxV7HSALdQUaJpbFlkEuoyszxb9KrmrC9t982Ufdm3y7rkzmvCQWNlEx60rnRvRMk2d5NKdMzS8nbo+0DCu5Lgldp05VqtwUvhmyAMy27dmExuLiac68ZfZumvPlqf98Xo3XK3UUq+vC4FGENqtzVlvrC1a8fVJUkXcuF5ZdQKhQY54zGLNpOVkSzqEYdg8OXBhFImbbSYWqBLgsTZcp0m4tiYNSZFjxzwJK4eZS/PKzT4YAmYTwF0KCD1iJpFa2cWL4HVvXvxnZRYIHXhpGbqO371D4SuDuSCsF+BFiuNkHYVbBPx0dRTqP6KEExGH+XhIa2BgQZXRkmOqj+DsH8sU2ZzX/LjQla0ZAZjhrRBa3vYOQwgjYI701vHzov1fQtqbIWWgfwtoGyNrs1GbjTQ9rmQEyKAttzX6hvGJA5mkp/E8rqSafox6uYzIEgCnSYHLXr129BdB3VSR1JNNoyjCMhOWwgkaRxgNV5DvtkPKbAGidcOQSUQk/ucQGMl58SKroe5Ms5mtAv4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55fee1a5-0945-49dc-cab8-08dc21ed6c3d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:44:38.7525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1V9nBEqMaKvqtRPX9iuucnsDZceTVgeE/YAcCGzWWV2uRM+h47PAe7F+5V31Ccta/dDTDCzuafRYHobWn87BAPr3B0jB9Yc6YlP+Qd3s5qk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5305
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_12,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300179
X-Proofpoint-GUID: K0wHkr16Cf9Ct-V6VtewccVdKqNroTYE
X-Proofpoint-ORIG-GUID: K0wHkr16Cf9Ct-V6VtewccVdKqNroTYE

From: Christoph Hellwig <hch@lst.de>

commit 35dc55b9e80cb9ec4bcb969302000b002b2ed850 upstream.

If xfs_bmapi_write finds a delalloc extent at the requested range, it
tries to convert the entire delalloc extent to a real allocation.

But if the allocator cannot find a single free extent large enough to
cover the start block of the requested range, xfs_bmapi_write will
return 0 but leave *nimaps set to 0.

In that case we simply need to keep looping with the same startoffset_fsb
so that one of the following allocations will eventually reach the
requested range.

Note that this could affect any caller of xfs_bmapi_write that covers
an existing delayed allocation.  As far as I can tell we do not have
any other such caller, though - the regular writeback path uses
xfs_bmapi_convert_delalloc to convert delayed allocations to real ones,
and direct I/O invalidates the page cache first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fcefab687285..ad4aba5002c1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -780,12 +780,10 @@ xfs_alloc_file_space(
 {
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_off_t		count;
-	xfs_filblks_t		allocated_fsb;
 	xfs_filblks_t		allocatesize_fsb;
 	xfs_extlen_t		extsz, temp;
 	xfs_fileoff_t		startoffset_fsb;
 	xfs_fileoff_t		endoffset_fsb;
-	int			nimaps;
 	int			rt;
 	xfs_trans_t		*tp;
 	xfs_bmbt_irec_t		imaps[1], *imapp;
@@ -808,7 +806,6 @@ xfs_alloc_file_space(
 
 	count = len;
 	imapp = &imaps[0];
-	nimaps = 1;
 	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
 	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
 	allocatesize_fsb = endoffset_fsb - startoffset_fsb;
@@ -819,6 +816,7 @@ xfs_alloc_file_space(
 	while (allocatesize_fsb && !error) {
 		xfs_fileoff_t	s, e;
 		unsigned int	dblocks, rblocks, resblks;
+		int		nimaps = 1;
 
 		/*
 		 * Determine space reservations for data/realtime.
@@ -884,15 +882,19 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		allocated_fsb = imapp->br_blockcount;
-
-		if (nimaps == 0) {
-			error = -ENOSPC;
-			break;
+		/*
+		 * If the allocator cannot find a single free extent large
+		 * enough to cover the start block of the requested range,
+		 * xfs_bmapi_write will return 0 but leave *nimaps set to 0.
+		 *
+		 * In that case we simply need to keep looping with the same
+		 * startoffset_fsb so that one of the following allocations
+		 * will eventually reach the requested range.
+		 */
+		if (nimaps) {
+			startoffset_fsb += imapp->br_blockcount;
+			allocatesize_fsb -= imapp->br_blockcount;
 		}
-
-		startoffset_fsb += allocated_fsb;
-		allocatesize_fsb -= allocated_fsb;
 	}
 
 	return error;
-- 
2.39.3

