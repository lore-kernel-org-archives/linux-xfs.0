Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0BA4C3AA
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 22:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707171646; cv=fail; b=H+ZsQkp/B3uKLpiwaDtpSaqbsEYOY2A5YGisFeyUmgrvLdb+oIfyxe7HYrIyE12c69tnkZG+jUapFdsEGSeOTX1s4Nhzne3Xlt9H9DcXVwPTw+Sq0PevhuJOWvRYCmupCLh7ES7M9oPk16kVK/dqf474ohvnzOjUIu4wIiCOE+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707171646; c=relaxed/simple;
	bh=1EXSZ4iU3I8pgM4bkKizf5fGqqe4QT7Of0bIhF3Y3W8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i3j5VYcJpSVU11Kk0xFs/xD+FSS253R41bhWlvvLd62F7bfxznzSxM67jDfW91bvHSm8EKEKplNzkpN7KFcRgy2Omsd6uWipcYo+duUINwbZP55d3QfL3Bu7u1xMSIIK7bjQbzwBae2WqUgtD53tVobVwqyzwq2/FfkMaRycgfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CowNkBf9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LO5Hq0VP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CowNkBf9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LO5Hq0VP"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415LFkJi024970
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2023-11-20;
 bh=P9KaY+5IMBkxdj2U2wEtdky3D0IGhPhNPnyjLehqSQ4=;
 b=CowNkBf9uADy077JTR84r0rJG0qM4I1V1EZSR1RDUkZXEmWS14WcvpaiwLN+6dPbc80G
 QVl8OyLPzEaFEbDktvm76OJtUG6LBm8/f/D2qTmGoLX+KmDvwXNcI623TSq9fAuNNhsC
 8PBMD0GYOl1YieN6Hmp1z/lpJP4w2dvgxkRYhV54YtGruwoB7PxDFxVBx3YWKlRC1sZ1
 NkNloeMR8aMBtiNeMQ8psvnUncYEFrV5Nm7v/AFwI9fMiAdqej2D/+213/K43FO3TNEc
 okGn+524vcGW9e3X3G7mWvVhErt6LyfLBH6dcvVB5Kx26oo5W9r0DmshQGIIJVDTyuku DA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1c32nabj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 415Laq8r036819
	for <linux-xfs@vger.kernel.org>; Mon, 5 Feb 2024 22:20:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6e1d1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Mon, 05 Feb 2024 22:20:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ll5yt5fQ5VhVCLa28D2EN3g/PhKgpP/fmfMXV1VLEvlWP3RwfzkebqIIsWJBVbQGDCW4HXJCjUNi5S3LTcS5sAZkzL66i+jGTVGCZjdynnWkao/X8Wq/c66G8+Lye4fjT4QrstgXM7zdh8vrSoiP0kME7RJkk5fxtLbKg3L9qyaeSlJDkFMEC6Y7jtLOvM2w8RRcjhP/kxYyxMbPbNcQSnd9/Nqn3qTfx2j91AWI+4guZopi8m+l2gpwKI/K8NKtUsznLFbu9MLO4dOMefeS7iI5GQlfxxGlr6HZ1ylxO/CQdDAirKPHQMSkjQFp6rHaqasIO2Mg8TAEd1X4KajcHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9KaY+5IMBkxdj2U2wEtdky3D0IGhPhNPnyjLehqSQ4=;
 b=B1rnxImxtMFgLkX59y6008RsEBAKF8R+Py36ovTWoaqhNFBBmvOH3XwCNHoLe+rAwA5LRS778pFkpZwpQQhRPGuHQVzcwJcAZYU3uBxtRRiIOD9r7lxZiybuE9obCu6DEB6dEOWQyXGRYeoTprGz5cqqmsC9PMvKBzSm+ZHR/oMQIBfwgga88yKjrlc9fvdHE08ei1go6KEfOkKP6nGhu+kThfidYUyBBjfCVpxFedfdaHLkbaZDZmcAqDdXCmmlZUVrXnLuT1Bneq43xGrZRNiYtGMbeHt1imxip26+SCa9XHcgRgdH/ES8hunc8JgvA+xlaOqQ32wPmHQuSPCWdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9KaY+5IMBkxdj2U2wEtdky3D0IGhPhNPnyjLehqSQ4=;
 b=LO5Hq0VP91jF9wKebkCutoExR00UZkgunkXqSbzypcC9jlaZNaYz9LKpoKitGkFoxpH57WtYu3K0kTVrMRF5Cdg/zPjlHJldXqvliPFIJekZVeqYaaLo5u6LqRpLXt/biOqGL2YGiAqsmmH5abGyb0PgN54sYn3XQsorit3HiHk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH7PR10MB6402.namprd10.prod.outlook.com (2603:10b6:510:1ac::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.34; Mon, 5 Feb
 2024 22:20:38 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::5758:bb17:6bb2:ab4f%4]) with mapi id 15.20.7249.035; Mon, 5 Feb 2024
 22:20:38 +0000
From: Catherine Hoang <catherine.hoang@oracle.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6.6 CANDIDATE v2 10/21] xfs: allow read IO and FICLONE to run concurrently
Date: Mon,  5 Feb 2024 14:20:00 -0800
Message-Id: <20240205222011.95476-11-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20240205222011.95476-1-catherine.hoang@oracle.com>
References: <20240205222011.95476-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH7PR10MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c4bac3b-3606-4a09-b267-08dc2698ae28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xBGzEE+Om1odOvG1FsoagsCO/hwdg4VbvmmYJuEMiiu/6Di2qvfz2PnQIddod//tfpGPMjEl5819On8YpeNM2LnPFG0zbeFrkhk9nnkw8GMes0Gmgucm2V2VMvhTwxFAzkjxG8dDKt8QNkSQXk8zV0V1WXIzM2dKKSkRiCal2ZOFwoRKPQMyGbM0pS0tfRmtJACvjdEs+kYj+E3RwBCSPoeyRHuCyOtD52J5qUlK8QePHqWs/hTqjLJPBCxMcKPALcK5ezejbk/M+mK+LQL+Y/WUqqE2tSVTu4Li3327qZhQy/rTYE5ArR8un+hCFYnWjTTo481M7reGsXRu+SlAutakPnD7VURsvnTSACeybwjpm7ua+ALjl5BznH3itReIogo3qoMEIwEnBP4wLCsFN00NEGBQyNfIt44W2022S33ncKiPwhgzppGXtsa6GiTxW5ZziTIWwDut5YKyrc2xuVYaPUBBT8MapW7qa2XqXot3nKHn4D7O1l4QslgOVjVBHNHQ8I4ymsLz7N1Vv0iIMTv4fl1ACwlV3II8p6Q/e+0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(396003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(6666004)(316002)(36756003)(8676002)(8936002)(966005)(6486002)(66476007)(66946007)(6916009)(66556008)(44832011)(5660300002)(2906002)(38100700002)(6512007)(86362001)(2616005)(478600001)(6506007)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?czer69t5h8jyT0L0Ga8DSbbZPIdeyHVdf4Cl7IeU4yIOw80z0aoRM+hRVOSz?=
 =?us-ascii?Q?LYRQLuUDKvzYmyjx+MNAisgsnaiXU+T8tLEEFlWf5Q41LzGR8s3b/+8gsQZO?=
 =?us-ascii?Q?cHfGe67+f4nCtZKOHynruyCljiUTmCz3DdYgxJXhNRGazwI7n5u3TykdCrae?=
 =?us-ascii?Q?0TD7P/x9jKlNssQacIGZCXA7ZlP7MYAzS6/2r8s90zmVFPaP6NIjImJ5rx02?=
 =?us-ascii?Q?vlMsrCuRvcYKWvuLI+M2m8bhl9IDBvIwwJ+GB9HotuiSr8U7GLDXu51zOev4?=
 =?us-ascii?Q?+hbcqDfsiYcs3SfTHYGBqFFSFbcu7zIpubFgO3Wr/uEXy5hjXv3du4F/Q6+J?=
 =?us-ascii?Q?wa45vATKaTh79WZhWMENjQSHXt2AP6PklH9SNvWMYhV7/fdq+SWlKSeOut8H?=
 =?us-ascii?Q?c5qK9LRRId/wbIe1wsfuaNYxel449I1/dV0EqrMddLbkNp2PkXVBN1cP/j6F?=
 =?us-ascii?Q?lpd3gL+WwpxYiXjLTFYwo4Q3bvfQwEKSFV7ZT4vUbLUjpwlQb0R9+9g3bt6J?=
 =?us-ascii?Q?CfupfQ/0mZt91EubGDGh8Gxo6aFkTD+uBH7QH5kRGThvaBn8bk8ddgOF55Vy?=
 =?us-ascii?Q?AAU7SG/3bv3YdwsFGgfzReFaBgIcDucQEDkPbyZW/r/J0t7HIVKqTtfYM3T1?=
 =?us-ascii?Q?Ejwyxtldq+83y47x3JL7HrlKapA/wz/Y9HTIMGfoIxr7SQM7UwZNkQZqQ9dG?=
 =?us-ascii?Q?9h2Qi+ruPJMySRWAHEyfv46AIqI52xLazVTamArSpBAqSp8brMmbJH4mWZuc?=
 =?us-ascii?Q?7N0OGUGweebUM/FwplCa9VFX+XHw6CpDH+Bz0sgPDbGvRutz5SBBh9Fj3bau?=
 =?us-ascii?Q?GBOb0s6ZUIITWb89r0wY3IvlJO3upWObzHxHGgQ1fLagQWULPNA7V5wZCfYr?=
 =?us-ascii?Q?K70obIEtRGejjAvKh5MJMvw4hfq/gZeEJE2mbpYQDc3SwPtEmNHkyA6JkNMS?=
 =?us-ascii?Q?gREtfhSb/Y1/T+8heRRDiojP/HA5NPMOA8pmtGLj1fW8UyUxYhR92xxAVJFW?=
 =?us-ascii?Q?9tA+U8p7AVbL6J7cojRM8Qpy/yhM/gyv6uB8OZEWxM3X8RHpZUfbfZ8xPDag?=
 =?us-ascii?Q?Ph4J8FQV0fR64q7V188XodKXlBpEkLP+hABMuni1Aa0yJW4YaA2uB7TTkdmb?=
 =?us-ascii?Q?QQrYvH8yK81/htmqk3VAxf/HOrwP1n5qZS4qb/htOU2JcrJnRz8+sogxQyMp?=
 =?us-ascii?Q?78UscIV2au3ajSoOM1/CyPcgmOB90ThosCghtSCR/l27Gfn5Q1luR8sSf+oy?=
 =?us-ascii?Q?+mTt2GAHNTa7w7zJ+131R1oUmhxyKA1cspbP2zc/rG2+P/moV77cEqYhdBaM?=
 =?us-ascii?Q?PLglPcxuWC+jrqBJ7fFRqm/gYlNGN/AX2ntePeApuTYOvApmi2+Us8XR7mhS?=
 =?us-ascii?Q?GBuIff3+vUVOP/DpF5ydhKxaHRExN4DHjZ9XhowiJfFqW9nvnO1cpn8dwZ8W?=
 =?us-ascii?Q?preH2GZp0CqtVK7s9gOAaQKq3Aq2Fi3oEALMOblSVXZkf+a0qSSKnKCCc+b7?=
 =?us-ascii?Q?+gULxvLfoqtrzVSqSKjRZLLui0Zd9+2sxX5B5iRi8URoX4oKv54rtnPMC8SU?=
 =?us-ascii?Q?ihcQ7GhBnIynRVk4cPCkswKX2Eb5TONEnmN3TNjYuyZpadCnHEuNpUHIHHV4?=
 =?us-ascii?Q?CmMdYqjXbNw2/11sAIA6JTgD80B38LpM5fBOoEXDHEaI2fFpXTI8kDfv+cCz?=
 =?us-ascii?Q?53DnvQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	B1HI8KF0vZZLdEd+kcwgqJEr5Z2Fd+ehnk7OfIJ/dHxNGdTd05yE6m3o15lwHUrkIvvhuVYZS/8sAADU7n3IsgEn6R+Y2vtklc2FR0bKcrtAS9OhUxe+cNTFYzxpw+zEPseP9wvutyMS/yhQZlB0N+Q0jg+w+orJhKHIKut2pxw7ZrLVa+vb3gTSPP7844P7TADvjAODNiQeES80w0+G9G0FaUSUgQaauVXSYBtTvHem8CkvMAyXO43CpG/haSkXvt4tA/AJGijguZHUluCf5NEaR42LFdIxlRSenKZqtX080vL7eVNx6f2zDZLMVUYtyBfN2RxO1xiU6IDlvqqWpjcQNKmTB8zPmB43u27DtqvmxgK2jdUOPERgLijfdB8WS8z30HqrhLM58mcFbup9KLjq3tBlGTDwYGiBqDemRFiXOBsjuiNxRHqUWC+RJPx24vdRoB0FGN+VV1OvmPrMHgrYeBTaJAYQbhquJ5VsvGPzPfaaWfRGg/ImS39AfN1tFr0nFothfh862llvnaAqXuLfjuCS9xtG1gzWfRcFeXs1fjvUj0/Hv1CkcCa48836zSNrYZ+JKREMllM88iYhCxvhWa4lHUCOKvuSgBHXLYk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c4bac3b-3606-4a09-b267-08dc2698ae28
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2024 22:20:38.0262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WxSOY9IAysf66OhwcAKmCFJm/DpdlD28sT6XOax6AVYNpUtzXqK0Xr0/DR73aTApCZuN2k2vHg2zNLK7tCIIq9eXHqbm+QLEZcg7kxtvN2c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6402
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_16,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050168
X-Proofpoint-GUID: FQ4cAg_9cMJixQtPxuzqj1EUlFBg0wbj
X-Proofpoint-ORIG-GUID: FQ4cAg_9cMJixQtPxuzqj1EUlFBg0wbj

commit 14a537983b228cb050ceca3a5b743d01315dc4aa upstream.

One of our VM cluster management products needs to snapshot KVM image
files so that they can be restored in case of failure. Snapshotting is
done by redirecting VM disk writes to a sidecar file and using reflink
on the disk image, specifically the FICLONE ioctl as used by
"cp --reflink". Reflink locks the source and destination files while it
operates, which means that reads from the main vm disk image are blocked,
causing the vm to stall. When an image file is heavily fragmented, the
copy process could take several minutes. Some of the vm image files have
50-100 million extent records, and duplicating that much metadata locks
the file for 30 minutes or more. Having activities suspended for such
a long time in a cluster node could result in node eviction.

Clone operations and read IO do not change any data in the source file,
so they should be able to run concurrently. Demote the exclusive locks
taken by FICLONE to shared locks to allow reads while cloning. While a
clone is in progress, writes will take the IOLOCK_EXCL, so they block
until the clone completes.

Link: https://lore.kernel.org/linux-xfs/8911B94D-DD29-4D6E-B5BC-32EAF1866245@oracle.com/
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_file.c    | 63 +++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_inode.c   | 17 ++++++++++++
 fs/xfs/xfs_inode.h   |  9 +++++++
 fs/xfs/xfs_reflink.c |  4 +++
 4 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 203700278ddb..e33e5e13b95f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -214,6 +214,43 @@ xfs_ilock_iocb(
 	return 0;
 }
 
+static int
+xfs_ilock_iocb_for_write(
+	struct kiocb		*iocb,
+	unsigned int		*lock_mode)
+{
+	ssize_t			ret;
+	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
+
+	ret = xfs_ilock_iocb(iocb, *lock_mode);
+	if (ret)
+		return ret;
+
+	if (*lock_mode == XFS_IOLOCK_EXCL)
+		return 0;
+	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
+		return 0;
+
+	xfs_iunlock(ip, *lock_mode);
+	*lock_mode = XFS_IOLOCK_EXCL;
+	return xfs_ilock_iocb(iocb, *lock_mode);
+}
+
+static unsigned int
+xfs_ilock_for_write_fault(
+	struct xfs_inode	*ip)
+{
+	/* get a shared lock if no remapping in progress */
+	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
+	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
+		return XFS_MMAPLOCK_SHARED;
+
+	/* wait for remapping to complete */
+	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
+	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
+	return XFS_MMAPLOCK_EXCL;
+}
+
 STATIC ssize_t
 xfs_file_dio_read(
 	struct kiocb		*iocb,
@@ -551,7 +588,7 @@ xfs_file_dio_write_aligned(
 	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	ssize_t			ret;
 
-	ret = xfs_ilock_iocb(iocb, iolock);
+	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
 	ret = xfs_file_write_checks(iocb, from, &iolock);
@@ -618,7 +655,7 @@ xfs_file_dio_write_unaligned(
 		flags = IOMAP_DIO_FORCE_WAIT;
 	}
 
-	ret = xfs_ilock_iocb(iocb, iolock);
+	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
 
@@ -1180,7 +1217,7 @@ xfs_file_remap_range(
 	if (xfs_file_sync_writes(file_in) || xfs_file_sync_writes(file_out))
 		xfs_log_force_inode(dest);
 out_unlock:
-	xfs_iunlock2_io_mmap(src, dest);
+	xfs_iunlock2_remapping(src, dest);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
 	return remapped > 0 ? remapped : ret;
@@ -1328,6 +1365,7 @@ __xfs_filemap_fault(
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	vm_fault_t		ret;
+	unsigned int		lock_mode = 0;
 
 	trace_xfs_filemap_fault(ip, order, write_fault);
 
@@ -1336,25 +1374,24 @@ __xfs_filemap_fault(
 		file_update_time(vmf->vma->vm_file);
 	}
 
+	if (IS_DAX(inode) || write_fault)
+		lock_mode = xfs_ilock_for_write_fault(XFS_I(inode));
+
 	if (IS_DAX(inode)) {
 		pfn_t pfn;
 
-		xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 		ret = xfs_dax_fault(vmf, order, write_fault, &pfn);
 		if (ret & VM_FAULT_NEEDDSYNC)
 			ret = dax_finish_sync_fault(vmf, order, pfn);
-		xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+	} else if (write_fault) {
+		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
 	} else {
-		if (write_fault) {
-			xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-			ret = iomap_page_mkwrite(vmf,
-					&xfs_page_mkwrite_iomap_ops);
-			xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-		} else {
-			ret = filemap_fault(vmf);
-		}
+		ret = filemap_fault(vmf);
 	}
 
+	if (lock_mode)
+		xfs_iunlock(XFS_I(inode), lock_mode);
+
 	if (write_fault)
 		sb_end_pagefault(inode->i_sb);
 	return ret;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fb85c5c81745..f9d29acd72b9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3628,6 +3628,23 @@ xfs_iunlock2_io_mmap(
 		inode_unlock(VFS_I(ip1));
 }
 
+/* Drop the MMAPLOCK and the IOLOCK after a remap completes. */
+void
+xfs_iunlock2_remapping(
+	struct xfs_inode	*ip1,
+	struct xfs_inode	*ip2)
+{
+	xfs_iflags_clear(ip1, XFS_IREMAPPING);
+
+	if (ip1 != ip2)
+		xfs_iunlock(ip1, XFS_MMAPLOCK_SHARED);
+	xfs_iunlock(ip2, XFS_MMAPLOCK_EXCL);
+
+	if (ip1 != ip2)
+		inode_unlock_shared(VFS_I(ip1));
+	inode_unlock(VFS_I(ip2));
+}
+
 /*
  * Reload the incore inode list for this inode.  Caller should ensure that
  * the link count cannot change, either by taking ILOCK_SHARED or otherwise
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0c5bdb91152e..3dc47937da5d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -347,6 +347,14 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 /* Quotacheck is running but inode has not been added to quota counts. */
 #define XFS_IQUOTAUNCHECKED	(1 << 14)
 
+/*
+ * Remap in progress. Callers that wish to update file data while
+ * holding a shared IOLOCK or MMAPLOCK must drop the lock and retake
+ * the lock in exclusive mode. Relocking the file will block until
+ * IREMAPPING is cleared.
+ */
+#define XFS_IREMAPPING		(1U << 15)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
@@ -595,6 +603,7 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_iunlock2_remapping(struct xfs_inode *ip1, struct xfs_inode *ip2);
 
 static inline bool
 xfs_inode_unlinked_incomplete(
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index eb9102453aff..658edee8381d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1540,6 +1540,10 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
+	xfs_iflags_set(src, XFS_IREMAPPING);
+	if (inode_in != inode_out)
+		xfs_ilock_demote(src, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
+
 	return 0;
 out_unlock:
 	xfs_iunlock2_io_mmap(src, dest);
-- 
2.39.3

