Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF431C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jan 2022 05:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbiAUFTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jan 2022 00:19:55 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55886 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232204AbiAUFTy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jan 2022 00:19:54 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L04hqE009119;
        Fri, 21 Jan 2022 05:19:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=gnM0NN+pJUWgUxxfuPBuHrqjtwiaaUEbdP6uJPSOWk0=;
 b=YOXpiiImEELMSQtcyWE/mkS0YSeAgMsig3tG8qIzJ/fl6xRNqOEfNTN0E/JSh/7NkPSo
 ygujBP8t9IvvzubgbAdUEXKc2qW0z3tUITBPdXtYl9l2cgdGAOjsfwuSewxFVmFHPPvb
 GykQLGa25zF9+ufIoKEhDzml6A/u+vDqWnvn38nsZ3WpfXQc2oSF3sz9rIvKbOqntKFF
 ZWh6DdrIOLjxhDExqwxMJOcwCyD4MeLpuR9wqQSug+HZ0rZz+elgTFjJIVnUZLed5dko
 4U21rLP61kaZ2+qzD3rOa7OybbU8dvaGmnn7ahQk8Sowx7uI8hIB00ZDj3VsARTPbbQX cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqhykrcnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20L5G9PE156901;
        Fri, 21 Jan 2022 05:19:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3020.oracle.com with ESMTP id 3dqj0maucb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 05:19:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnP88b37/ezezW1M+D/xJnReP92n2tFyI8ZAsCtTqK6lXEr3/GWoRZPXz0UG0CHKapmM86ooZy6j4PnNA0FHxeSLcSrh2FyGRBh8GRWx3hxkcz5vf1gzzOxKQnGMtvkcDOyd+LtnDHSCMa6S6kcFd4rGFiKT2GXVf5uyptgNdSYP4rDlQPdyTlGO69gndBirSMvr4aZgMgZ5fRCTbsIuO28gkffRZIhfUC7pVy0n5RCo/kl9z9REtDUF2M/R+Z2UaRiNPkFVTsTk0pUUwuiU+F6h/5le1XQS6FBQP3wKymg5L2HcMBFvFs6ChragbhgeFj+S6QUPEEQ0+kiQs9VyCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gnM0NN+pJUWgUxxfuPBuHrqjtwiaaUEbdP6uJPSOWk0=;
 b=TdXIhuyDWOSC877RtfhZbO56yGibyjzGDXrUeeMuOdfFC/qtxRcXwXgbFtC7EyI9byfvraeFbJi44JV7KRj1KxVNm75h1r7smJOw0yOwpLlKlGkwGdKdlqAKgJ1naquCmEjw1MZciYMurGz37NtdihatT2u+XyOFaRrdJZp1IPFOcxvFiJsLxJadTHxo09nDg6R6xh6s4CS6HUYEsr5n4y1uQvOugzhN3n5eGVOuMAw/sFA2Hq5xGnvgoVorfSPFm8ytx0pibwYYOxdpIMa+enuHnWk0iWdoJ3uphxKpgUezqei9xQQ+3oho9v+kaQgJAWnoVSjHn2x9tbwIWYhwdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnM0NN+pJUWgUxxfuPBuHrqjtwiaaUEbdP6uJPSOWk0=;
 b=JwYzWQQGgw7s0hx4eJZtx+uAsJFA4NipfO4bh98lQO98nKJJXReoKD8pveeWUU7BpzDVOEsR5VMYIvsZ6x8n2ON4SuulJtwYIZTDJRrONmCh/iN+uOk877EKIFNtj89YP+SNxC3+890OBT+kQK+Uo9av92VYd1IZ1lAn7XDvLGQ=
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16)
 by CY4PR10MB1287.namprd10.prod.outlook.com (2603:10b6:903:2b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Fri, 21 Jan
 2022 05:19:48 +0000
Received: from SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b]) by SJ0PR10MB4589.namprd10.prod.outlook.com
 ([fe80::3ce8:7ee8:46a0:9d4b%3]) with mapi id 15.20.4909.011; Fri, 21 Jan 2022
 05:19:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        david@fromorbit.com, kernel test robot <lkp@intel.com>
Subject: [PATCH V5 10/16] xfs: Use xfs_rfsblock_t to count maximum blocks that can be used by BMBT
Date:   Fri, 21 Jan 2022 10:48:51 +0530
Message-Id: <20220121051857.221105-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121051857.221105-1-chandan.babu@oracle.com>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0027.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::22) To SJ0PR10MB4589.namprd10.prod.outlook.com
 (2603:10b6:a03:2d0::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4909ad0-08b9-493c-ad1f-08d9dc9da50d
X-MS-TrafficTypeDiagnostic: CY4PR10MB1287:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1287E9D8A0DB68AB65F27BF6F65B9@CY4PR10MB1287.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uiFd0JMX4ALZrPKrseTsFbesNE2+evtZkZDESKTDaivv/YRQdeZkOg+AdtrXi9f59BiBG/ViYdkuVSU6cJw+Ua5pHtmKU9PO2DdLsxfvFNWSw5kswx/ufzyAiJB6moVkT4IxJ2jRu9x0x9JYwWg5d67FSR8vxqG+LEt2sfVf/ZATXCqTxV0OerUL5VZI3crUGJrE5GgKfaHfStbNqO9bPm9hSMcxDxMIcxZHFdle4DENECnv2lVSiZk1Ihl5Kh3P7++glpT2TECVU+v/Fd3A5BBWrETyFYoWTaFV/uEWC9sb2c192XsmJyTfL5J8xIlMROSiNm31YitqDj0iCPu20JvX7htbtiO4I8EGUHwCfUCiJXPcQw9jbBftxoeR6GTxYU6Vq0s6ZUZfW3VQz3UIboNgB6iabdwta/Nr3W1/BnTit6EC1u1d93QpGPFw2Rx5saNamD2nlT6tmZ7JirIfed8QoLCNXCUKoKKN72gjtHZrj3IBXwYREglVloDW65Q6K2Q37X/PfQZjnBymJJUQ10h54z0+dGAmQd+m0GKGck6r7xag2ajm9syRfHCRr1MieK2EQjeg4okZQ1myv/e5j9y+DPNc6ifZ0eWhm/4/zNBXDsglhUw2APVdqa1IS+/lD/qAPK21eq9J+IiaxzK48i6He7NMAlYqAoIOfzcNMnJHVwuIqLVPOuPm0ws3q5jadwdLj/uNPKEiL7jxracsnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4589.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(52116002)(66556008)(26005)(6916009)(2906002)(8676002)(5660300002)(66946007)(2616005)(54906003)(6512007)(1076003)(4326008)(38100700002)(83380400001)(66476007)(86362001)(38350700002)(8936002)(6506007)(316002)(6486002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sxGUGYEovhox6PjOmyFtOibLNybWfhSyxIO11o7pI3EIrd0ncs7Jp2MNFtvh?=
 =?us-ascii?Q?1cb98kGORwccxwCvcq1mEhqIUXP848yu8+6toC6EYG8xmdVlnL6XlXjlsh43?=
 =?us-ascii?Q?crZAj+SPV5GYA3QCQl2x1z7pXP/kOJcluYDwQe+u3BSafD5ExjK+4iLYeIiU?=
 =?us-ascii?Q?9Zr8VaMwEBHG3XoTtEPPsSqQZ4hCH7TpNHlvt7jMlAGIcHgpYXNQwRdgITO7?=
 =?us-ascii?Q?pOXb8s+N1gRX6SZT+QKzKtNdkfyCHlM+jyhDuMxGWY6WXUgVdkcgoitkoy2C?=
 =?us-ascii?Q?q0ROlGeey5uDrGq/ygHW6jXlZGw/nCA62cE7bNk1FDHIxfx2ftoB6jzlGyj1?=
 =?us-ascii?Q?9m1EbvpXv0PFd712KGtneVyYx8F9vWUT+1i3ZhHG1nqvWmoDCsCGhnxS4CQe?=
 =?us-ascii?Q?rIyioirQ/RUhzPSjU+3cxPZ861T96rXqYUkrsMos0aLMLqEZQbGhNS462Rdy?=
 =?us-ascii?Q?qK0xPHlCG/U7GVFHoRracCCie0W2sFl8vN6XndA+HFSZeJfg3e5ag7jhsA7A?=
 =?us-ascii?Q?d22n4gEKVvZmD3BFY+Tz65dBR3D7EOIMVDtfDgMpE1tQEaqPCtoiUS+JtVS3?=
 =?us-ascii?Q?LO27TMT31iXtFxN+YIVpyTXZ3gz9YnAzbgkK589gBMNUFncqEZ+EZKwwBQsP?=
 =?us-ascii?Q?bA2SYJ5mrf31S4el5XVAxbGUvA7qEYbv8hkpW7j5O0Ngkg8g2VJQ9TB0mzB7?=
 =?us-ascii?Q?U54m8PXbRhCta0RgbvrL1O7KqXvUPBecBk5I7hHoO/+9tvrKcg7gEOT1naBH?=
 =?us-ascii?Q?Lu6FESICxU3hpLnTcB0n8fipQmkqrTWSR75wkW0M/2D6iOicl3p/qk4/pqav?=
 =?us-ascii?Q?K6uP8vl4zllKqndzKPX4iTnO1J9hosWbJHjcWAY5706rhdw0yNK+MOzgBxkl?=
 =?us-ascii?Q?rJgqlXhs6S5Vfejh5U/LjzyhO6nKLiYL+sv3lUAOZXeDzWbECl/+0ZnQwiEX?=
 =?us-ascii?Q?D2hXiYH+K3CtfwZ58EWvuO4fU1UNxxNJRuxJichUHUNVnQrH8oQzwcD2I2W/?=
 =?us-ascii?Q?g+7FUCI3bJn+EI8zRx8GW448ePw8nIfPS/HTyIHlVBEEPDF4oTXG3GesNmzF?=
 =?us-ascii?Q?CEhCwTVsQ/+/jZVTxrC2eT5tzmz5fz81V+D/Ba0NYezy1f1/qv1MxNIjhGl+?=
 =?us-ascii?Q?JYe84lKqwkN1AcjvEpGa16OhMUSbj6AsfnMO/ykwIexp9X0StsDPUlBRimFj?=
 =?us-ascii?Q?ZZhPCJrtJukFsby2bnAFsbrRiLWXCdOKdRjSDapmlpNCP8CZf1OBFOWkLs5o?=
 =?us-ascii?Q?G0NExdMB5oDJMW53ngD/0VufiMP9vf9cPJSm6jZTI0xubxP+WDZc4rVtBMef?=
 =?us-ascii?Q?c+aa0ckSQno7qjh3LAQlt9J0HRA8W8+3CdWkfCEzLWsKdDgtJy6r8MQE+jy9?=
 =?us-ascii?Q?49Bn9Q5wyJjI6nBdZ22FCRubhqdH265zSWWNKa5EnTdN5PK0F5rTInfrUM+q?=
 =?us-ascii?Q?gou3d58bKqE6KOZdcFuwqpdGzMvF1/4Z3MzwyUnfF9qVDcZwkU2nUck3vcaU?=
 =?us-ascii?Q?rx1FqpMFF8uh7IRz7VQbtrnE+UkkvN2eZm9JpxV7OlnQ5Wlm8AGjX3gn7EAb?=
 =?us-ascii?Q?d6MPQobEWH1pxARE1k694WDcoocliK8Yhvq3yuw19wjmK0qf05MsxKulQi/N?=
 =?us-ascii?Q?gvGIOveVaPH1MSPiuiVf5V4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4909ad0-08b9-493c-ad1f-08d9dc9da50d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4589.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 05:19:48.8779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hvnlTWH7bpKG6Q1SfnxTSvTkRRaSrPRadCbDM772XR91AJOBdILpn3DMh5gqjJgFGB5FcqqlijTJGRK+SCKNnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1287
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxlogscore=995 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201210037
X-Proofpoint-ORIG-GUID: KWG4wwKevbYyABIOCNgBTKExkT96udQf
X-Proofpoint-GUID: KWG4wwKevbYyABIOCNgBTKExkT96udQf
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6cc7817ff425..1948af000c97 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -53,8 +53,8 @@ xfs_bmap_compute_maxlevels(
 	int		whichfork)	/* data or attr fork */
 {
 	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
+	xfs_rfsblock_t	maxblocks;	/* max blocks at this level */
 	int		level;		/* btree level */
-	uint		maxblocks;	/* max blocks at this level */
 	int		maxrootrecs;	/* max records in root block */
 	int		minleafrecs;	/* min records in leaf block */
 	int		minnoderecs;	/* min records in node block */
@@ -88,7 +88,7 @@ xfs_bmap_compute_maxlevels(
 		if (maxblocks <= maxrootrecs)
 			maxblocks = 1;
 		else
-			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
+			maxblocks = howmany_64(maxblocks, minnoderecs);
 	}
 	mp->m_bm_maxlevels[whichfork] = level;
 	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
-- 
2.30.2

