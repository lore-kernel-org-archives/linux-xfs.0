Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C592C636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjBMEGn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBMEGl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:06:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60029EC57
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:06:40 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iAAd009303;
        Mon, 13 Feb 2023 04:06:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=IpFtZNqJQx+KVXhORLOyrc41NXdOK2m3SvDVRYqpHvE=;
 b=aH6csOba/ra3HuG+wmWz3zinAc0MkJ2AEDcqcV+f5RhftNN7r3BKQkPETkvExGwfY46+
 6HFkcvvPrDdVdROLEZ2kHBuw6bHzSuw5czmqzchD56Zf0JySNZwnCrNwvEWqyjm4Y9yy
 wBq3Elmw2hDNbDl8mbK8lk3u4LxrzgOcab2+EALwmZPsCZOQ/6VRo0XEHfoctSJiTRU6
 Ni8CKjAfCZauSOyNCuwnr6ckcflO2YqHQDXIl2JyXdtrLH22r5EwU535rULk4EO7cMnW
 L7bzQiD3Jme179mFFXGw9QSgqwssfF9MZFN09OEM3DZcbosvV+/XS3JqIdAgNa8XcZIx XQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xb1wty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D3Bp7N028986;
        Mon, 13 Feb 2023 04:06:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3jy27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqKcs0/gik3Wtx7as9Ls+WGkaxGCxWKPqJcVqW0jbJvK8POx1tAJ9roMVnb7Ti8lpyAbTsj9kO7xQEy2hwU4bx7fCCYYjkYv/Z7vmgxtGd4C+5TsLnUBdvGEzJ3SFVuBvY0ov0r9QM7wIZndR6pLqW3Ds0fs2FoO/QNcTqsrDpI+tadvfM4BmcCx/QeId5X0JyNuP/Jv2tMNSrtRc+8eo+PPeLHm1/G1m/cu+iyueILvmstbFuuFaOr0dTE7Rk+TwVwrNXrI0UkEG6FkwnsUzUg/0UGcrIhqz/ycjeIply449r+XCA1dJDJHAMVk5FiAP912/aevEkA0Iuau/eZQeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IpFtZNqJQx+KVXhORLOyrc41NXdOK2m3SvDVRYqpHvE=;
 b=U2KbLGwe5NbNl42nT7jqmCHEJRZMiOOJZqeO+8QJHirA0sOVy8yC3tWTBhf2dgvoJ6B9igcXfjHumnOxC2Ct66LR3AYftP8jpTYo7gzMFqcjF7jr8cfHpR5gCdAJfVoY0FxNIbMqfBTmubiEANVnltl0dB4FQaDRMzj6LKMAmH7QHbtOCM7QVAxXdKRTvp2mfEincRN3cIAYaZ/JkshvbM42JFyyaMxnTtNBzPbDM8/xhraz91n5yJlsnqHUyXZ7e+0lRBc5gDUFFexZ/D/Mkg3idLthLD09MEm5lGq1IAQpeYFORx8OQAh/pUWaMC1dYfNV/f9EdYef+xpFMrp43w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IpFtZNqJQx+KVXhORLOyrc41NXdOK2m3SvDVRYqpHvE=;
 b=RWLZ5YIXswrIgvw70TzF20E2IHnsJH+gAqEJ2bbU3wR17X9qAL7iE6zgpT+ywERgfOWWV86wONZbyoEgyPw1ec3dUWQI4fixWVICCRSY4MS9Dm/sxq8D5wQJ/hqWMHL3HBWSJlYM+QYYw3xSEfKik5lX0dNQXtRfIdwbgxxtA/U=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:06:34 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:06:33 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 13/25] xfs: xfs_defer_capture should absorb remaining transaction reservation
Date:   Mon, 13 Feb 2023 09:34:33 +0530
Message-Id: <20230213040445.192946-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: 97468934-f125-44de-b899-08db0d77b1ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Nm3vLYsPmAP75vM2LMO/UIiblutlT/eEhJ5B2TjUV0Y5vXA8FQXfQf2cvndBklw5XKpKg9gqFlChZuclaCvHgDbzFORv9/X3MEwdxhw3OjignuPa0jU9t5IXK9zGzvZEL03SN/GRtMb5SACg4GTSiGsK5ktyvnXcy1a8NWPqLYs35vIR33SqoZxIfb3LbCCqT9Ud3t5fwgmrEs3FtgKTbAyM1Zkoef46ih6iuIUjmKsg7Xu3pcmVDX4M5NSAMDUed1N9JjP8BToPcWkhWal0pNY9eQuB0XPT+TlC7UUabRqweoLiXQcDC5yvZbwdH5Eupy31igcL/S1RJ4Ehhi8Hp2Hx6FZpT9htDkMrPh15jtgOORF6feePbvcu0ipaar1ppTcFiW4UN3Q7XBtPTRzFVNyMhHVoXNIRxp+krBQs05rwVZs0eSWU8R1m1soAGcTMKvxvMsP8VBLUFbNcP/MZqJvoqyxDoqoClcpoYlHh3x9E0bv98/SsT5qrxF1LcNBRZ1SRThEAVMeo1qHRAqWvaOyFV6ZebDaPh+jfwvOOUB+OCShH9bdX7WoOkhlJ4JDGWFcDc9w9gCEkOarfQjLeQUegKJdSVg5DH4OhJm/oCHKwtMVRpzhc9cs5knD35V59KRCOZxOLwPLgpYFEmNGTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HzQ+xEWzy+Hw/DXPwVzwNhtkaQ+DJHQFanxJRVmbEn3kLXG2rgihuARCqGiT?=
 =?us-ascii?Q?ZCQmVKnIOOpJGhyL+e43vyJygayNF/4Q+KLMcI164Hkw20hcBAFyt5EO3woA?=
 =?us-ascii?Q?vzfEgsDnAVZPGonn8y1VrU3fS60ZyS/Rfuzb9lSpEZeJNxRbYRMj6uuoMjOV?=
 =?us-ascii?Q?UJJ1alHpABeJTO7/GuuMPBwus0svudzMNyNAitBUUWViXUUj/NW0f+PsGgoh?=
 =?us-ascii?Q?lWEvAvhmh6LT0WDrW4LqWLYJSnRRk8F1zhh/+Gl/areVXq7Hsu3NNmT9IF4r?=
 =?us-ascii?Q?qntz8QvYd7+LhL9lcwAZiXvNhElNFaeQjhA55TBDC2dw1b6cPWrsy3F1VXVR?=
 =?us-ascii?Q?HX3+abmpZF0FzVkCmZF1nrjcrRbzvn+1PuuoRG5uSj9eH9oaV1MiiK64MSzt?=
 =?us-ascii?Q?kXsQcF9bbl8ZLATnDhOYYkO8T8yxWkwq/EKt2ep70yKHB3mXm3dkrYbBwWbS?=
 =?us-ascii?Q?I9adiDV+VETavbqAJYmTAyJtWaJhOhTDj5+i6jVV0YPrx5IBesmRoSknjlAx?=
 =?us-ascii?Q?2kxzqHN24KuFyUJ3laKUEQU224AXlUthj0mZy28yWkDWLhYfKnLFFEl/TAu8?=
 =?us-ascii?Q?pU3wpxm0Ufar5UdsjKMNg0UEWjN18LyJt17hNi7DjkWP7vj09KB4qafwu3TU?=
 =?us-ascii?Q?tpqIF0PUhc6cfN8OmvwdkqdDvszuDST4EzO4YwKJshb8OnUMf3tjUpMAsl6+?=
 =?us-ascii?Q?wnmvTmKVQkjricwd94SIyqUFj1Gn+hzZX7i9Z8m1LFofCeZ91Z9q0YrRoX0t?=
 =?us-ascii?Q?qqBZGp4WVnj6Rf6tdHyjI4G2UaSRuXFTMSVP1D0dR+azNyGGMlYQwYewnPUO?=
 =?us-ascii?Q?CMg2EhZLJzDGk2r+ZfcwE/12CdKmoXRhZ5suOF0Y9MRZGrUkyIOhGbB12QRJ?=
 =?us-ascii?Q?y1kY86QJV7AudcdjVskocSqZxhMCOLym2HQyET77oqCFPN36g5xINl86Vjv2?=
 =?us-ascii?Q?l3YHj19B+2ccgMEbgj2bM9ChCQyUVjHOtZAX379IZ3SDgrlEb4PIFyetZef6?=
 =?us-ascii?Q?FyMeknN137eAQXdqZykCYdBKrJPIB6BRkH5eh0MCmNY+0JIurlt8tO+1pxTW?=
 =?us-ascii?Q?mFUj5vJOSKF4YauWbgBiaXqlHM31Ff12/erYTCF9hjr0ZKqn6gR8FsaxEo9v?=
 =?us-ascii?Q?tjvTx45yX2wmKUZADIDeCW+L2ZhxIT7gxIfgRe6uE7lIsTh2JUhfEzkavyLk?=
 =?us-ascii?Q?yUjCQo/gxunWXyCw++3Tai2NYoimWpZLN65ixOQ0P10RxFeob1M8EE5bErdb?=
 =?us-ascii?Q?0dvFEYemrrlPONEkPBFTJLsICyl25/ubqVDuZxNfAonrbLTw7nI/bvzHkV2c?=
 =?us-ascii?Q?yTxD2g3EpdrWFUFDIn1SsjEdVk9oMH4W/oO1kY65pnsN8e7/kFZX/Zj6SrEv?=
 =?us-ascii?Q?Eo7pHgzBDz4dbPbjDrN4AcnWAIgjeC39VCOEFzaQ3QTOORlEqybjYgdkbGQI?=
 =?us-ascii?Q?1DUDgOIZN+oH07DmOa0DfTBc9QaeYMvg3G/8SWAkMPsx9n240DVIgCcYlJyk?=
 =?us-ascii?Q?Gcids+zojg6JY5TZG6kjSE+02wGNLKt3tNxJiufpHSDL7IFVNkuS07tzpDW6?=
 =?us-ascii?Q?nkBAn9V8d0e1rKqqQx8iMejeoVHffcFvzPjffntLO9blhg69LZ5nAHZeCnqW?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Oax6ULodUkva+xVKNWuZPvjtlaIcHFcAHdyRoPyoYJKqxv07tX0bQDJYn3JrrGTrVfMaOVAKn3aEcANsvYwybTvHcVieUoYrbvSQfRZTh6D9E1pfIrNDUqgFxwFAF++WB3FjnD6PL9a0u1FVeKav/TBJNjgbkqZ1Up9oTr6cGMoxoYVyS23SHTfC5B2msDtLb5o8i8h2HPicI84O6euqdV78u6B+QCVr0i0vMzdZ1HMVcuJg7nU+K+rqAmlaup6pyO7MtndMONsFwKm238dfUbZjccEQWSDABK3r8Mk+itv+0N/1XwpJtJf6MmzUk6e5G2ZoxQoojQdWKMMJ740lu/nYoaBv/E5FMbCzdyOQ/emqb7XXMvQtERMIj2JFRq9dNjuE6hAOmQBXzY7P1Avfd7HZY/Z4kfi4/cdfj4k7V9z9mmVQco/LxDMJnE+r3lW7PQwIiCpbGzicuDxgHdzqg1V0jqYKMhheTL+FtN7+fd+SmPBShVjX/J1+6VuXcE/PQ7o4MiofAAROrcTviUjsqxG9DbPn2nPdNHPlwoaZTaozg61hTuQW/5iG1Vrs1wHWwXNpI3zbtU4607jR3/kWJx3MTl/G+oSjUSUsLhE8z3ko6MUY8bIczfzyHsOL1Ed/TeppwmqpLKo8DUQSmAzhOsUgZ6ex9IyBJtA7L0CqJhebOcJhXxYmbMPPXKqhmSIOqu9FccMHip4PDZgNhQ9E5Ek5ZClVfuoDf9QScQduRsNAp7PfNPbV9HSvhmvD/Q9BHH3ioBWswgptxhTVsobNFT0jjYMm/Rghj3fHzFvrwjkMpP0XjXY6QQCTEGn7Mojf
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97468934-f125-44de-b899-08db0d77b1ac
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:06:33.9194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3CEh32KJwK3P+hrW9PMDowJX3/+lKK3Hf7fhcHDt1btta6CooksRCjgeQd+oUkguULZWZxk3QAuLuF6A/RlRMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130036
X-Proofpoint-ORIG-GUID: dEkTZt5K0AuxjxtNGdbqczYTd1tRccu4
X-Proofpoint-GUID: dEkTZt5K0AuxjxtNGdbqczYTd1tRccu4
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 929b92f64048d90d23e40a59c47adf59f5026903 upstream.

When xfs_defer_capture extracts the deferred ops and transaction state
from a transaction, it should record the transaction reservation type
from the old transaction so that when we continue the dfops chain, we
still use the same reservation parameters.

Doing this means that the log item recovery functions get to determine
the transaction reservation instead of abusing tr_itruncate in yet
another part of xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c |  3 +++
 fs/xfs/libxfs/xfs_defer.h |  3 +++
 fs/xfs/xfs_log_recover.c  | 17 ++++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 4c36ab9dd33e..d92863773736 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -593,6 +593,9 @@ xfs_defer_ops_capture(
 	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
 	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
 
+	/* Preserve the log reservation size. */
+	dfc->dfc_logres = tp->t_log_res;
+
 	return dfc;
 }
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 7b0794ad58ca..d5b7494513e8 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -77,6 +77,9 @@ struct xfs_defer_capture {
 	/* Block reservations for the data and rt devices. */
 	unsigned int		dfc_blkres;
 	unsigned int		dfc_rtxres;
+
+	/* Log reservation saved from the transaction. */
+	unsigned int		dfc_logres;
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a591420a2c89..1e6ef00b833a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4769,9 +4769,20 @@ xlog_finish_defer_ops(
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-				dfc->dfc_blkres, dfc->dfc_rtxres,
-				XFS_TRANS_RESERVE, &tp);
+		struct xfs_trans_res	resv;
+
+		/*
+		 * Create a new transaction reservation from the captured
+		 * information.  Set logcount to 1 to force the new transaction
+		 * to regrant every roll so that we can make forward progress
+		 * in recovery no matter how full the log might be.
+		 */
+		resv.tr_logres = dfc->dfc_logres;
+		resv.tr_logcount = 1;
+		resv.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+
+		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
+				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 
-- 
2.35.1

