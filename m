Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FDAC4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbjKFNNc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjKFNNb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:13:31 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D2BBF
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:13:29 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D1xLA006674;
        Mon, 6 Nov 2023 13:13:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=bQupO75Zvy0ifEPUPUOBCixJ8Lj5K4EIaTt5b0MTbAs=;
 b=r87c5TJAF8oM+yGz9zyGJ8stvBxtZOhUieZkZWKo/yehcC+uJf8/i9smtlytuPajuwWg
 /tAd7W8yqul/brfavFF+2zZfR+ENWaSVKX/NfepPPefcKqFo19jHE5XxyVum/dzRFNu4
 0U3R3ceYv8WwHrALIgHsSsDKLunNTdSxeK5EYJNDQykDhAEjTCpMZ61yWCVCCHrrS1GW
 7ccdM6/rOHRH76gRxrNTqORw0it2YjRz9BD+Qu/u1DQss2z3+vwAHekglZHG8SS9axW6
 skUqZbNuF6KXnCgBdszlrb4eJb7LFjKI3ISSDk46wa3ZUu0aJuuDHSHangaFXBp+7NNH fA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u5cvcb098-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:13:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D8Rjq023535;
        Mon, 6 Nov 2023 13:13:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd4tcfa-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:13:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcjA7scStaxyc8zrKLOGVYLfQ7zwCsdDQRXog6g6oxepaPOihfZfKXVKR/fpJHmFqapxD6SGW0+CknFrXzEr1SJLWXf/k8zG5tehsdhSdSBYeXLUbPm15K4gmpNAW/z63MhlNUymYbPQwO7Ysghmw/zYsMMSwQICRakuc8RNflHIN+2Hq5vvIdEJLvFcha+1W09pN/VOpY6fsst1PPRQbJZBr243kLfyDFxhC21qDIpL9daYuCyBy5qEwMi2CMIjKF16R1lh2vLu8IvEumilthqboeUg8MRmufh8mXhxLveU2/k9n6rMe3TeUlNWKmVKuSytX4H5MKjadRI2y0gRWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQupO75Zvy0ifEPUPUOBCixJ8Lj5K4EIaTt5b0MTbAs=;
 b=ngspb3EVCOWmMIkeW+9yFJH/nhKtvetFZFuxkqdpl7sEjexM8n3fR0fp3J67n2XKZIU7Dh9aMMPwrtXuiucPeLdRBY1BwHzPa4nGePcInidZ/Xd+xSIHEXxJfifEhSEStxPGhrkyI/ETRT+9r2TCxmzJ5UURTr4Oap2+64gBMgFowQWZEPpN1QUN7TbPxw/3dYHoto3BMeGElK0AtDqtcfrz1UH2o5RBwFcz0D52pVKmAjgiI5JXotY/JrzzrRt+iCUbYj9iBRyRQOC7h6/tEV483fuoRpmhU5yR+UGmjsEX3lVtpk3vquh5oqiA+FtDQYCQcycve6xC6Swkeh+EGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQupO75Zvy0ifEPUPUOBCixJ8Lj5K4EIaTt5b0MTbAs=;
 b=IerdUxFt4MkZyi92YUYcR2l2Dia6R9D4pvyjoqvHYoycZv0a6BONYzMgPd6Eqs7e10E2J4W8zhBPquqyPKm4tmN0vKet2taTw6Bq5q8HOeCmvKSFeSqSKrTjWHCyS8GVgvdNne5DHAIWjmMZxlfddpN3InU2qqe6leY6RNwi8SI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by CO1PR10MB4513.namprd10.prod.outlook.com (2603:10b6:303:93::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:12:34 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:12:34 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 15/21] mdrestore: Detect metadump v1 magic before reading the header
Date:   Mon,  6 Nov 2023 18:40:48 +0530
Message-Id: <20231106131054.143419-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20231106131054.143419-1-chandan.babu@oracle.com>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0182.apcprd06.prod.outlook.com (2603:1096:4:1::14)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4513:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b878381-93e3-4fbd-dfcf-08dbdeca0a3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U2/9Js4R9A9g7zi+aPTqJmWnVE6zrgTvUAUA1v6Vlp3xMeZQ9DF2J5HqzEfvCSjv1M56saOgg/gsYYwpds4AcnrFTHx91GGSUJSnGv01JusH8XkoOzryvwielYBaOSJFfMDV3rVGOyipBXSZxLoJFcrJO0A0HMCdbmVCDIyzbz9DABPhM8m0NZt0JK/p93uxp6mo9Fz+7Mwqoi/1XkRRXhEr3nXCvUmrTfnl28H0eAc+Z273hhNObv7u3MIqkXCHM+E49FKpP2y4mAUyMabyiHq2BDGe7mjcq0RLNvH5VlImcLnBGZC2RR6GpADDAxjba7kufarmVQPf1cBcITrsFEEi5JkNl7kApBeCdz+yq57M5QRoRSEH3jv4LqxEQxrHNzKpsZeWFl6NRkqZO+Qm8xWso4K90GuKAyE8DiUKtPLYHY/laVr0eJf3VXKyrd3K9l4LgY3+Ts9rykkJlzq/zVawYay49+O7fWCoHfbNy9WTQ/Ijau8jrdDt+HsuGx7zZZ77OUUDF9LszhCUuD3zgHVKPfUzoSpuRinC9MwSp1CvNTHwxVoU56TFnTJ7O8t0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(39860400002)(366004)(396003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(6512007)(41300700001)(6486002)(66476007)(66946007)(66556008)(6666004)(478600001)(5660300002)(6506007)(1076003)(4326008)(8676002)(6916009)(8936002)(316002)(2616005)(26005)(2906002)(83380400001)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9solgzHxLCUfrGw+eFofWa4sSky4fxnQGBPHUu1rkNHQ3OWwP0RfZkPyAfcl?=
 =?us-ascii?Q?ZXGOGgdYNtXeMUvbHueBmAgc6oJ7YLEurNKJHPPhYklvvrS2pYP0xU/8wuiB?=
 =?us-ascii?Q?y/X3yRRhy0XZwCUTPZOMPL9cDKNeJ76JVdMrB4D5eT4iyHSiUDj+L3HLeUIx?=
 =?us-ascii?Q?/Q/5+Gnr+q8dYLICu/gjq+z9Eig9RllHRTQYQvvXr7aVRo4ZQEYSpCuAkIRP?=
 =?us-ascii?Q?Y2eKF6gqkGKx/hYNIRtc5m0PaBlS8cARAvQjpb1EygnxHd8ujpSpLwMw+mvI?=
 =?us-ascii?Q?0mxkvK8Y8WK0wo+wiaUj3DdrjF2LkF6v1HDcrNgPPK9Dz4cND6BBGpn7ZD3A?=
 =?us-ascii?Q?mn5/zGDUs0hGM1j/WdAVRNyFst/TlF98npeYqDcoOla+1+JTQVfsv1T3beNT?=
 =?us-ascii?Q?o31q2gviuQDAovUpdXWTBLuNhUavtkxYanMQzPEoA3QxOPnQ3e9ksZMbiL8+?=
 =?us-ascii?Q?Ew3ottAKX9ooajvNvAtzG91OGdAJvaDgmfNmy4B9mNHQjr/PCgZMEPIChJJB?=
 =?us-ascii?Q?arAppFstqdlTQ/KRvwfMLE+g9Kl8GrHK3kD3qu1UX1lAEiUuTqzGoMJvILNi?=
 =?us-ascii?Q?uBbK1Ho55WJu8O41uCO60wj1L7VdaunaqT6/YrGKS5tDRLOg6jNQiBW7wVlF?=
 =?us-ascii?Q?AOj2x+HzjnFYiosXf2e99fkTjSZ6jIllNOtwt41IWksxBYsTj265v1ul5i8k?=
 =?us-ascii?Q?dHdA3DmhyA5p2nJSzaKQalkWdWqS4+dNCoKSf2Tv8eq+kGsOA3/eUmRtXI7w?=
 =?us-ascii?Q?vDCTYd8xEVmFJvPhU5hLC8OycOWkI1RSrbXAXBOF2X7z62QMKhYPeMiSJ7Sm?=
 =?us-ascii?Q?E6mLHA0iRlrbMPpNEu8r1wLkQXmsHNlMYtpqIH4jkWAJhD9zNasZ2Q07qU/s?=
 =?us-ascii?Q?ywQMVOfzs8wBA6SfFchUXIyrJ9+v1mXL3daJxWTwDGzpgOVQsMlHhFPVTTcD?=
 =?us-ascii?Q?husBrBbO9k3R+B4+XK7MJ/dVI2ufkLWw2RDwunpCBSa3QiVtYcArVV2uiP+R?=
 =?us-ascii?Q?8ucuFmP07gYCuKld4l5POtIGcNt8TPEGVp6jfN/euEyb/AvBkXCspwFAx4q3?=
 =?us-ascii?Q?JQfxELsoUjOLfMhmNchNzdpLOvv6F+iN+bmnHo8JStMDcMhJEBDc68cTBHex?=
 =?us-ascii?Q?lPP0z3uRQnKz5sfUkZ+CUVrX4eATUJH9ilRgEP46XEIi8ss8WLQNghx+Ry7H?=
 =?us-ascii?Q?pQANAajNJGeUxFtpdm6y44tPY9hYUboPZ6SBPNjfxA/pphF43AQuRikiWi4X?=
 =?us-ascii?Q?nWDMBtPNpRjudE3EJqSw+iJEqyVtkndYOfEUv1f3ghrCglLoUIg8PhBw7IuM?=
 =?us-ascii?Q?kNNOwwPz7FH/App+4tfUJbtblr5zLo1p/KPyysXQcs9iYq0PyCSVcLxgDGsO?=
 =?us-ascii?Q?ZuoiH0/40F+uPBkvulzcyXx91P54itDZN0bhEFmPd/DCgC2jt+9BcBHpfy+H?=
 =?us-ascii?Q?4jTnisLHWH98MCeqT0t+urvSBtWhpfX5DSwl6Gt5Fpmqadscdol6uqp4gr/E?=
 =?us-ascii?Q?eSTviUN0b66U3goPBCOGptuL3BvWdoDxDsj9JmpBqJp5lIODhr+owZIy0Kwg?=
 =?us-ascii?Q?khh1hq4ooCqtJMSfyCyqo0OP/AMB5h4AbUsXmn3/ndqIb1O+LiuUFHzKeDXX?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Wgjw4ESR+lNP1alQ4BNCpwO6MMpYQrmOb+eESoPkYWlyEKg2phkKpTLGeru8rRUHIGj2c3zrkU2aMWe0LMVuthlIVSYTWFrupk8AuDhWDvS5YeG/EZy+Ufm2gm+UFZlRB5mBbYGpf4JxfArKIIx0cB4Ywe9vs9ueu/k3YoeI+iRq33MMma4eSyezuL8loJKTz+pu76zwCCXYmWjgC04q44zGGw+Sm5pDLbk+2GMiqXw2SI3hIcuCuZFwfgOeOGjVXa8tTcYqEMuZzjGDy0EFwH5uEhh97aDByaLvNnW7GehJHMkOhqMoJrpYhPBp1HQCmjuuR9hw8Mibi37f7j5ITIVwTny0sXoATHohEj+5bHeRBs+17DaXpoMrWUM63og2BuVAwxcE7NFYVnFMmZ2HoAB/PUG4H3ZQ0bPYGrfzDf/PolgFEfn3ioNMD3TnsRKlp9ak6UxRFD8jX64EkXUXTgYaiJDcKORCLdwxc+B0MHUsGrwhJd7d9+IdVReB3XiXFnWkvb6duQDrW0Oeji/SNcMX5JmDrqGbnWqP+L7N2ggX8Z34/hOI2sMJBeoWvk6uS69VXkx0ciEAycZU9XSnf/jqJoi1xpUuHYPAn89Mo5EwJZg6lVi4Fs8HS4ioo3pNF0pYYxxTfnycyaE60/U1pJGmRTLx5UDigFHPNmfTPQi/vCQLUmGcYSOBCFirgqIH2pKpaIj7zaP9J7wP3RMn+QdScd6+ZFICHcsOBNK34GkEVSk8o6k8DrJgC7YSH8mKnHtMPicQ9+A6MsaFA1MmdnO9stOvu3zbl4MlqNRJkTU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b878381-93e3-4fbd-dfcf-08dbdeca0a3a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:12:34.2214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iAiXEIz+JrkfO1zaJ99ZHMAeXM+SW5FSPSNbjFxVPRytBvRio110HPrjFZ4TwBkyKFRvwao7FWC9RtvuVEVx4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4513
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311060107
X-Proofpoint-GUID: SnUpMvO9OXDs9cNKn8FwX6I94An32FNg
X-Proofpoint-ORIG-GUID: SnUpMvO9OXDs9cNKn8FwX6I94An32FNg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In order to support both v1 and v2 versions of metadump, mdrestore will have
to detect the format in which the metadump file has been stored on the disk
and then read the ondisk structures accordingly. In a step in that direction,
this commit splits the work of reading the metadump header from disk into two
parts,
1. Read the first 4 bytes containing the metadump magic code.
2. Read the remaining part of the header.

A future commit will take appropriate action based on the value of the magic
code.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 97cb4e35..ffa8274f 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -198,6 +198,7 @@ main(
 	int		open_flags;
 	struct stat	statbuf;
 	int		is_target_file;
+	uint32_t	magic;
 	struct xfs_metablock	mb;
 
 	mdrestore.show_progress = false;
@@ -245,10 +246,21 @@ main(
 			fatal("cannot open source dump file\n");
 	}
 
-	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
-		fatal("error reading from metadump file\n");
-	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
+	if (fread(&magic, sizeof(magic), 1, src_f) != 1)
+		fatal("Unable to read metadump magic from metadump file\n");
+
+	switch (be32_to_cpu(magic)) {
+	case XFS_MD_MAGIC_V1:
+		mb.mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
+		if (fread((uint8_t *)&mb + sizeof(mb.mb_magic),
+				sizeof(mb) - sizeof(mb.mb_magic), 1,
+				src_f) != 1)
+			fatal("error reading from metadump file\n");
+		break;
+	default:
 		fatal("specified file is not a metadata dump\n");
+		break;
+	}
 
 	if (mdrestore.show_info) {
 		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
-- 
2.39.1

