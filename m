Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1D9C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 20:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiEJU2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 16:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiEJU2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 16:28:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71915393F5
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 13:28:10 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AJ66PX032663
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=93P+zu1pLsvwm9APL8WAyf7cUvuIpf+GxJD15z3TWos=;
 b=j+hrxhB1HVkq+c2Yyxv4YVm7LYfp44RB5pwM676IfY7tpKkhV2dA54es6A90WlQxlwm9
 A1SeR8x4AhQSJzTHWwvwx+44HlM2xKh073Z8Be0yQzRUa1xgKnP75L6vFVDTTZEwncoJ
 /Qe30zEcN3AuZE6s/xyt0btxKJn+S7J+z8EsO1p3hjpbf0mNsQ2PdAXefPAyOkagLetQ
 Jh89qxtb/1oSJE1QWL4BbXmkMnrN9RZb21ylNwV/P0Kqjkyp2LqlwodTuK0WD3GAsgqq
 E4H4NsVqhoRAMEE7q70VhbjykdL01yGXkxBngIqN0fLZoFSMg/RMy9pt1EGoveBPJ8d9 dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fwhatfvu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24AKLiLU012173
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:09 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fwf73gr3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 20:28:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cca/ciKGgFKHxK15Ap2dy6JF8suu9xFB7bbcS8DtcOAY6rq1axZcry1J2hFQ1562tgvnujABj9biPPFKV3hxGzsiqOAjtsFoZQ3oxcYP9CR0MYUzfDwYW2XhUfaEiIX5BSmI9YjS05QvpWDw9pWvyPJabIDeTGtsKJ4vtwk6hTSC9muWE9WJzX71f+BnSkMUcP8gGGXdTMtpp9h/H/7StxUqTXW/rvhjyyuu1IKYKxZbdZROUNmCn6mbsOwMQtuu5ZdPFiEQfdNDEsOUmmurFMTasrp8gW3Nvg3HEgzThzPhYOfIUYUiRo8uty3yHoU2rrjRir+MKUoHrSSjqs7tLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93P+zu1pLsvwm9APL8WAyf7cUvuIpf+GxJD15z3TWos=;
 b=aeY8BWmpjN4h6Dbj/1FxP5RH4Ux7qxUIAoIXx/vtpGsgL8DGk3MKyLUHPAN6hGOTTB1jgrk323Mgnk5RMvs6io1VgplEAxPFFyO7ZesUPVu8GOIcRw7Outi/FJAmBWjl0DFCCYhjh+9nQtv/K6+dkszSbuqIfrihwWEAOICCxZRHMroTq7BzAQk4ZPZUH9Bv/tcKC5p0JNiu5A9E7CNflCuMEuWoh3CwHAJ1cIP5Ap8P4PFFAyBp8Umc6bj7c6kcu6X62GEMivEYMJ832iFye9BPC5wX6LNdJCANwhMsGAgVgJ6VOOsYiv1UTzaLatmEozxu1tudO554vPBKqBx8Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93P+zu1pLsvwm9APL8WAyf7cUvuIpf+GxJD15z3TWos=;
 b=u9/11Z1iX6StHXQl6NgOhu0MeAPBl38eUqyJBzMDH/hgBvsc3LPInn3Hyyg/e2wPt9icHtzJQm88sWh1YllwrnEwJ3q9ybCANUrp2V08KhJs05uPWAm8LHVJDawLqurFO9x59hRpA1kmNOJSftYeBUArbPCPm0yYeXSsIKI77ic=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB3859.namprd10.prod.outlook.com (2603:10b6:a03:1b6::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Tue, 10 May
 2022 20:28:07 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::8433:507c:9751:97b0%3]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 20:28:07 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/3] xfs: remove quota warnings
Date:   Tue, 10 May 2022 13:27:57 -0700
Message-Id: <20220510202800.40339-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::31) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce4b6dd5-3d26-4587-e77b-08da32c397b8
X-MS-TrafficTypeDiagnostic: BY5PR10MB3859:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB38597E5C3350D800CCFF7B4189C99@BY5PR10MB3859.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q+A4rRPqrwKngXUDfEdSOT4/67IA49majEuPDxND2V7ruqp+x7HggvYtZLR3Qwa99YM/+sZoRhvRRGZJxkGrVPBTUdOQ8/EmWKIR30+ZxkJjZ+9JiXRuRKqhGto4nPucbrfjQ1ucZT9z7VWWNCUaoH4quJk+EPYdBlVKueMxvEdqDUi20qd1V72zt/lQi4ghvTXV7vI65imuCSBwozewpYjKj9IakOW13h1tEquTTHiiOKthJrNJU8reepBSBntFCVZG7W22lG9vkwdmhOvakeHxZ+QlAszxJNOXJUTX74vZbI3xS1clsI8U6SjpAirQUDfqwYhxLnv2n6R9w+KzcJVIFNTh1vJg31gOIGMGSmf+deBrYouIdDCTuNuQCpcKih7Iv3utMHaxWzhGya+rvjrcjfZeC57VjsHfHnXG5wCAcyC36trXWkHlgX0zYahuTK0ZqKly/Mwo+ALlS9J/AafJPt2Iiv/l+f7CKyfQwDpFXQW6F0mGe/3D33xK6mXTtTMeEdUjZJgSnopnvfDzCb/T7G2LcAQ3ZP1vjG3bcEmZyiUE5WMYdFj7/4lBb51B2/hPD3NGr1uiJXGLsln5nx09U/Ykb3aMnqXbG7QuoyNOW+t6JToGBKYTUL3FOxVrHguak5xu0PJ3SOaLOvPb0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(15650500001)(36756003)(6486002)(2616005)(316002)(8936002)(6916009)(8676002)(66556008)(66946007)(66476007)(38100700002)(83380400001)(6512007)(508600001)(2906002)(5660300002)(52116002)(186003)(6666004)(1076003)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUJLangyWENoZ0orMlR5RmFGNUJQcGZ2V1BjRkFPZUU2dmJqa04vMGFvay9R?=
 =?utf-8?B?REhjSXFSeFc3ZTVvbVROWGRwVzd5RnB5VE13Ynd5RGN1UFRxMjFvYjZySTgy?=
 =?utf-8?B?ZEozRkNSUVRVYzNjWTFIUVpTQ0t4eUc0dHN0WlhtWjlvS1REZVUvdFhuTysx?=
 =?utf-8?B?UjI3YnVHNE5seENXaDF2Kzg3aEJRT3FSY0RkR28vMzB0TXpKTFc2UnhHdENt?=
 =?utf-8?B?bnJZRWtUcklCMXVYcUdrUDRDUlMzTUJUMENvYzVRSTQvQU9sN0w1RVdHc3cw?=
 =?utf-8?B?Z1oydjVFYnFrUEE2MC9JSEFoS1U0UFZWWE9mTzZ0VGVETjlzOEJzWGFiT1F3?=
 =?utf-8?B?NVVCREFPZVZxK3ZjZHFHVHFDUmwxUTJ5bTRpSVQyZzdxckFzNEhtK0pkcFJR?=
 =?utf-8?B?YmFIcjBHTyt6ODVldklhTjNoV3VZLytKeVJJcFgrT1FHWFgzd1krTk9UQjdj?=
 =?utf-8?B?djlvSXB1MXdHRXVmaXlnd1N1ejdIWVlPWTB5MmNsWFVDdE8rL0w3RmE3L1RE?=
 =?utf-8?B?S2xzVzdWR2JCaHdlZXNlT3NTZnllUHRVNEhWOG4zOUFYTWJlZ2xnM3hNT0hj?=
 =?utf-8?B?WEpKTkxhY0wyRzk0NWlHcTdOTHFrQjZwZ2FkS21ITERnZ0cwMTRJMms4VXlh?=
 =?utf-8?B?SkxhSVRHSktsaWVYYTBWaHg0cUFRZDRpMjRwSEFFNitGbHAvb1RKc0N5bXZt?=
 =?utf-8?B?MGZsSjdiM3hZaU1wcGVPUEdQTUNia012TTRMZzFDRjluMkxueDRYUlQ0QVRr?=
 =?utf-8?B?U2dHdzNiWjVGRTc2UUp4UE12Ri9LVFltMS9MbjFoUUZVczZLb1lyeGZIK1g1?=
 =?utf-8?B?WWVMZ2d3SGxLV3BPYjIyb0hmQjduNFRYUTNvV0VFUHhsN0dkaVZGK0hkc0Z6?=
 =?utf-8?B?K3I1MTAwQjZHTXBVU0pQRndJTWxtTGhEOHlhNTN4d2hubEc4ZW9rK1JXaHQ5?=
 =?utf-8?B?TytITiszSmM4RTN2Y3N3cWFMVEtBYlkwYms3NkQyYUVld3M4ekVVbjdPcHhV?=
 =?utf-8?B?NGVTQVhnc0tnK1NJNXJmT1RxUCtHNll0cUs5Vy9DdzdQaDRvUThxdFZ3eEg2?=
 =?utf-8?B?YTljT0x5dFFpOWsydFd3N2syTGVWZXhESFRMdC9DeDQxeThlenM0eHl3WFBh?=
 =?utf-8?B?U0RNQXVndWtQOFArQ1R2QVNGbE9LaWNqVnR1NmVmTG50YTdqa2pNQUp4OHlL?=
 =?utf-8?B?cExoa2lYc1ordEh0LzZORDdyVVFobUxCbHB6ODdCWHVwUUNFM2ZGazNhb0xL?=
 =?utf-8?B?Vm9tbUdaRWJ2a0RxZWt0RC9ydm42YnNWQmFMNjFVS1ViOTlFT3ZTMnd5THhG?=
 =?utf-8?B?RFAxYUxmbzRPYkUvNTZJZW0yeVZqZnBsN0JhTi9FNG9DVXk3b0tDS09LRFRW?=
 =?utf-8?B?dGhIQUNWSHlidzZ4RUtqQ1RJYm5rT0tET0V6bG15Q0xLZUN6ckptMGNoOTBq?=
 =?utf-8?B?Wi96dWZ6MnY4cVNpbU9aVDIvdUIxWG1kOU9GOHNRUERORE9DRTN4akJ1aGFo?=
 =?utf-8?B?THVaRUNWQTN2cmM0S2N3MnUvbmxJMk9BRmhkUHFNVXgxREFkNUVRUXlqQW5X?=
 =?utf-8?B?aCtvMXBxM1hKWTZyNzF1WG82Smg4RDY0dGt5TEVuWWlwRzdNK3BpVkZ1bnM4?=
 =?utf-8?B?dlJ6b05OK1F0VHBKdHVxK0xQNUNsVXFGS000NU5Rb1lhLzlTZGx6VjZYMzR2?=
 =?utf-8?B?b3FPYTNPZS9TY1B1Ymg0Qy96REwrMVBXRFYxSHVJZXA3WU54eEttNEhsL0tJ?=
 =?utf-8?B?MjFieDJwSWgzd2R4SlNJQ0VkU0wzZlR6bDVXb1RDVy9wMm4rL1JWOXR4Y3JX?=
 =?utf-8?B?dTgwdWZDYTJvVE9FNDJVbThXL3doVGE1eHZ2bnIxYmZnREVZQW9zUHIzSEFQ?=
 =?utf-8?B?aHVUbU1RSHRkcHdiVkY3Y3JOM2gyblY2UTVnWC9OK2g3WjJ1eC9ib2FWUTRD?=
 =?utf-8?B?Nzl4TEMydzdrb3NOZVZqQWxvTm5uLzRBYlVuZVVHd01LZ3Y3VkpCUWFtMjJB?=
 =?utf-8?B?TDhOUnNNZ3VDRy9tdmZhOGZLYVBUTUdUZ1A4Uk1rN3FxbHNpcEhGdVcwWXFI?=
 =?utf-8?B?WkFzU3loNXArTUJTaGgySEt4c3g5YWltT2NkckR2amxCZzNCNlZ5ZzRxUXBR?=
 =?utf-8?B?Y25HS0h6K21abkI4aEsrSzRZbmZQR0VnQjhwY2d3UW83RlRFYkhhQmt6Ykoy?=
 =?utf-8?B?eEJ0alJLaGdZY1licUtFdDJ0UEhYZCtUdDJ3bTdPaG93eHVDY3gwaTdXb09k?=
 =?utf-8?B?cVdGK1U4bEN1TFc4elp5NzBLVmQ5SnFWWmVQT1lIR3BYdkhOdDJrcjl3NEhF?=
 =?utf-8?B?VXAwSWtlWEZCTWt0MkhYbmlLcUY0Ly94Y2YrSUJXL0NrTnR3aWlnQmFVL2t3?=
 =?utf-8?Q?j+lJcHfSzJAB/gsIdWWp4irvNuSugTsG12BJDhjEPmVNE?=
X-MS-Exchange-AntiSpam-MessageData-1: NxcuA+2JwRUA13FWQDCmuUg1nMk2E7USxiw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4b6dd5-3d26-4587-e77b-08da32c397b8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 20:28:07.4335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: llQ3yAmuPYTR8eaGzXztPCJMHIGRFKXck6J+PCE+qNibK8bycsEf6gO1Yt8Y63XGWAImMbd6Op+Nz/NWD3nOzBlXYRQ+7BxW6dKj5/Ct960=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3859
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-10_06:2022-05-09,2022-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100084
X-Proofpoint-GUID: lxwpdKOgS1o_vZKye4_Mi7o--FeJWjSS
X-Proofpoint-ORIG-GUID: lxwpdKOgS1o_vZKye4_Mi7o--FeJWjSS
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Based on recent discussion, it seems like there is a consensus that quota
warnings should be removed from xfs.

Warnings in xfs quota is an unused feature that is currently documented as
unimplemented. These patches remove the quota warnings and cleans up any
related code. Future patches will also remove warnings from the VFS code,
since that seems like the logical next step.

v2->v3:
- Fixed spacing issues
- Added patch 3 to prevent warning values from being set

Comments and feedback are appreciated!

Catherine

Catherine Hoang (3):
  xfs: remove quota warning limit from struct xfs_quota_limits
  xfs: remove warning counters from struct xfs_dquot_res
  xfs: don't set quota warning values

 fs/xfs/libxfs/xfs_quota_defs.h |  1 -
 fs/xfs/xfs_dquot.c             | 15 ++++-----------
 fs/xfs/xfs_dquot.h             |  8 --------
 fs/xfs/xfs_qm.c                |  9 ---------
 fs/xfs/xfs_qm.h                |  5 -----
 fs/xfs/xfs_qm_syscalls.c       | 26 ++++----------------------
 fs/xfs/xfs_quotaops.c          |  8 ++++----
 fs/xfs/xfs_trans_dquot.c       |  3 +--
 8 files changed, 13 insertions(+), 62 deletions(-)

-- 
2.27.0

