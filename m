Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F81C4167B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 00:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7365B61177
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Oct 2021 00:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbhJGA2s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Oct 2021 20:28:48 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49574 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239983AbhJGA2q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Oct 2021 20:28:46 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196Nwx2b019750;
        Thu, 7 Oct 2021 00:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=0CmXZTjura0u5CgXkrxJMT70/ilW8RiGxkEmQEMfjy0=;
 b=wN4i8Ny7irmfA/Ad12TxhMGue3mGWI2QQO2CJMjQzOFPo9ImTlL2iugJJKCR4w8sf2Pm
 f4Co0/YS1HLdm6/XE0rp//c/ElD5gAfdb9ZcEv1EBh3535cbYmOh+HUo1SU8BztLmDet
 QBHBwHJ24o6zYslPtzKpUQfjbtoBCT37W4r7+l2QAYHo4usDO8AL5YKDx7v209ZDxhWj
 iKq4kSsO2CI5lCHp4YPbn/AGkmJIaXnCU7A8LcVZSTZn6sRm5OB+6QHbAmJ/E3zcG3br
 CUfz5xKln7MSuOnjPS6t/Z6QfSecu8nsgBP3LqXERqaa2gZvrjYrgSzshV/fmf+bAJpA pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bh2dnqjap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 00:26:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1970AkGD192858;
        Thu, 7 Oct 2021 00:26:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 3bf16vya41-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Oct 2021 00:26:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhMpel9gViMtUeaMhXcAAJV49WW0JaU5wFjycFKvkikD9ZKpYo3xGufHK8fFhWs7wU1ZqbJd6FdtMI0Cpe6XTZ0oAWKcr4c9+kZ8rUSpj1avwYcmC4ms3lxM8cf8tO9UVuV4Wp/mhH6l3M/IhKzntvgaGFWbk97tT8WdvatDnI2M5qLvscAmvZ3QHBOWegR5fxwV97udYANZNOc+ex61SyKGoJ/wAu8kZcOMKEkvdA6ZizaexTqUPFYk76TSXhJLh+wjxx9zH1nPI0daYLES3UfMauExahmQK6X4cLaXuBO4HrhhMwpNW3FFrwH7zy4QdnsYN8S2liKWASRoBmdFbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0CmXZTjura0u5CgXkrxJMT70/ilW8RiGxkEmQEMfjy0=;
 b=dEStN6JTskMW5S8BQdiBKK9t0pz/EknswKfLiaOl6kvKcsL1Rp08Idw2loVYRYovVnwMND/6gwK0F4dUxkNX+mjxzRBuY0R6aXqCTp8WNdJ3nnDf+TyFoMZxF7yHiJFH/wz68Quu0I0MddUE7YH6mm1Bkvit6sG3XEN/Z4EjvMdz4JQ3+iqNLfLjvsst9x8yGFMo0J6dyTaVNZwb+dAj/a6y+2km3OGwxDh4wNNXJv/TMfk4OTb9aMNfeCodkguAffRpHvhSAyTgus/crALAeA0ejG3vOhWKHSrowMXVtqejr4F0wTqBcZqDCtfH0rFnKZwlt9gK1t6IowcBcfzggA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0CmXZTjura0u5CgXkrxJMT70/ilW8RiGxkEmQEMfjy0=;
 b=f8cyv83HccBl4ijA5ahXLb7scU+Glf65z+tQ6u0BikIXCcv4RnI2rpuaC80AprTJ1HpSL80oK/2kRCRYp9GjfFCdZT71I5a+GjbZA0xqVGJHlLxF3+RAAKDJCeTLImRdvZLsrgXmYRUsMM0L2KktrL1Wz1E9ei0p9LjbJFBMlDQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DS7PR10MB5118.namprd10.prod.outlook.com (2603:10b6:5:3b0::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.18; Thu, 7 Oct 2021 00:26:48 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72%6]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 00:26:48 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH v2 2/4] xfstests: Rename _test_inject_logprint to _test_remount_dump_log
Date:   Thu,  7 Oct 2021 00:26:39 +0000
Message-Id: <20211007002641.714906-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211007002641.714906-1-catherine.hoang@oracle.com>
References: <20211007002641.714906-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:c0::32) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by MN2PR05CA0019.namprd05.prod.outlook.com (2603:10b6:208:c0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Thu, 7 Oct 2021 00:26:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee2225bc-7c16-48ac-e0d0-08d989292699
X-MS-TrafficTypeDiagnostic: DS7PR10MB5118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DS7PR10MB51180635A5657A17FC4C79A789B19@DS7PR10MB5118.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: daEAKlObEdSMewq2fUyOniBtqdInAR/t8GaQ0Qp0Go3r0SCFIkXqok8Ex0VXO0bfkx8TurJWli1prmNCL+Yw8y5AMuFFFMCNQG82l6vYQsqZZHMfwh7/EphC/wrvXcQ1S0VOzAL31oWvYk0dzH5TFNftobc4oKIc1pda1e1ZUP0IlivMsYy1wjujYq5VU8qhjvkyUPJKhbSLvwT1NryCisVwnB/i0I2l3E67qgu0pvgOJ6JGygG/26hd8rE4V0oGPleEWzI7rzLenj9f+GBl5wRsbSp2oAmkzGRzBDSPnOyvD9H6DmJneK2165TdDJqCKLM029LnjH634/eWt5Wm4AnV/chyCGNpIFZhx06uzA3saWBesdxcfsz/vL3c7baQG5N/HCWvKlpBWHtyBnszG8twmbpekSrFhYg72137r8H8W0kLbu2rxcb78jc6np5dRrYUXDrhxykCLi0TCw8S/i2GZhIs39pv+Xx5PjolAqrqjx444CyEs0YXz6VGby1kGUlCONyKdd1tUgCheBrTFbgDdSpsOvRe7X1lbRRo32B52b6251E+1Exe6CTTBb3sjv8ngGNjvirCyBNuN4T7gr4OcI1vFoajWnRyAQmXxP4dvINGg8sgYrhXy+YXTJeC28bAjTWBnjRemztpKb+r1NRetsAZVoxuVK6GOW38IbERzg+PjvmdF1wJPcmPUYy7AgVeO6QHkZ9xo7SvW+G4qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(508600001)(6666004)(38350700002)(186003)(2906002)(38100700002)(36756003)(107886003)(5660300002)(44832011)(83380400001)(8676002)(450100002)(316002)(4744005)(26005)(6506007)(52116002)(66556008)(66946007)(956004)(1076003)(8936002)(4326008)(6486002)(2616005)(86362001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1GGuokqpsRIoJ6GOubIvjENrBpcri0iVMaU9CNdjMAN7VdFEC3pnmRzNxbVe?=
 =?us-ascii?Q?DyQ9+wDsyD36htbvaKYTL6SWR2183fO+ojENbNQUumNwJmH8TKHOOgTzSJja?=
 =?us-ascii?Q?+TNxyPIUuh6yxNfCVzXWCu+AdrAsZjURMSWimH0RpjxkjnsvfCRc8++hWfHG?=
 =?us-ascii?Q?dDvOE7FYOQfDoVCoBIXPxDou/W7tWXlXoEG+IHc4h3hmgfLYnga+c4dwYVCg?=
 =?us-ascii?Q?3Gd+5GvvVQ9LeBbUC4kXvpBvVRZ8t6VblnTfN7rjZiSgr7CPh+zFKFYFZJqO?=
 =?us-ascii?Q?wKJzwilgZLLUzxogKSUPZiyVU3EP9SSOL1CdQ6M0Dhk61E3l6vbXWX2l7Ztx?=
 =?us-ascii?Q?/S/pHzAHvND4KImTQgFfStgsC7I+0MVLDHZgGKgXHKQJqSCuGJrbeJPb5OgW?=
 =?us-ascii?Q?yzTYrrrAxQmSK2xnoxqasj/d0TqZjECb69CsR50gBUzG1xs3Cp1+xYC/Kwtk?=
 =?us-ascii?Q?vRwcHRmM18MLamuFKE976SqZYEotU7RXOfFUon/swZ7tEkgzff7EJAGYFys6?=
 =?us-ascii?Q?YFKr9PttDVgoHXPXCkUxWIWwRb0DHUtfZjVnPq2c8CQ5ODDcugVwkAYHttXy?=
 =?us-ascii?Q?ZP6Ut75xEX+BsN5RWM46dDm/HnOw3/hodlmDIsDi2nHH7mcWRC3TFyKCFvn4?=
 =?us-ascii?Q?6JBEfv6VDK2yZfGH325/8h8EZ/kFdahpcjAQuXLusJ8waEgAHXRvp6xAept7?=
 =?us-ascii?Q?L0JaX5HxSw3WF0y+tR87tuGGfwc4CNZ8X1R9hvhwT38uz9mQd/JLOgAcCHmA?=
 =?us-ascii?Q?0SdK7NuMgYiYGWbkZhMsDi62oGGJLAbEoJ8AxM1x8dpvL+2nOyTPya2nuSP+?=
 =?us-ascii?Q?9DdBKd0ghUoDQmq3ixOElOxqJCbQ8ULkFxDOxGgiNcxuMUPwYVjsYSk2Or/A?=
 =?us-ascii?Q?riZf7ffwT3zVEnz8Z62msiCzjo9L1gewh4mbLVX1OUGX/j/TFnC1gLRyNPdz?=
 =?us-ascii?Q?8cbzImAPKGt/bHQAKKDlB+ov5W74jFt6ADHAyWqM+omvlI25e10NONBxKkEd?=
 =?us-ascii?Q?apBNGHf7MoXSeBGn/TdLyEWuSozRmpmh7dBaEKuWvJecyFa/qWUtivFRIuFu?=
 =?us-ascii?Q?1A+029ZFpct+mjes7MVYjL8emJuFJRGdS7jE5xwBf7jXBs6sImG8im5PLiCn?=
 =?us-ascii?Q?NARP/IUedmp2mq7VZAuv2OrgmU0ZDPa64ig4zbxOFpZAS6GcIjtNgh0ZB1cN?=
 =?us-ascii?Q?5xRsrhvQoXAuVJ7bwX96vrn8jz3Tbbq6bhawfofE5ChVQZnxqZsPlcBHA648?=
 =?us-ascii?Q?k2UGT6cZZFJqulLbjmYFZQoxPpfJZ1JH+OobYsTyZn+SX/XXlo4veBmA4UW1?=
 =?us-ascii?Q?SzxoqP3OEskmrpQPOa4EVcdw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee2225bc-7c16-48ac-e0d0-08d989292699
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 00:26:48.6227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hB+c+56RTrAIFndQ06apXHrx4DWx7ZhGBufPBf/ZE3k88uOCE1/fy1gf/WxCnZv+c+YytGqPXEzKwiKS27C1LeJKU0/iNirXPH0i42yyGRI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5118
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10129 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070000
X-Proofpoint-ORIG-GUID: cZVWWBFFfutw4ByYQkq6_NljbXywTiJj
X-Proofpoint-GUID: cZVWWBFFfutw4ByYQkq6_NljbXywTiJj
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Rename _test_inject_logprint to _test_remount_dump_log to better
describe what this function does. _test_remount_dump_log unmounts
and remounts the test device, dumping the log.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 common/inject | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/inject b/common/inject
index 3b731df7..b5334d4a 100644
--- a/common/inject
+++ b/common/inject
@@ -126,7 +126,7 @@ _scratch_remount_dump_log()
 }
 
 # Unmount and remount the test device, dumping the log
-_test_inject_logprint()
+_test_remount_dump_log()
 {
 	local opts="$1"
 
-- 
2.25.1

