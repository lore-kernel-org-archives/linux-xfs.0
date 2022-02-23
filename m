Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBC9C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Feb 2022 03:38:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbiBWDib (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Feb 2022 22:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236115AbiBWDi3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Feb 2022 22:38:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1FC38DB0;
        Tue, 22 Feb 2022 19:38:02 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MN7Iwo026632;
        Wed, 23 Feb 2022 03:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=jN8sqmDrc5JFCIQcglc7kiM6xK+9CwJmphjcT1qZtH8=;
 b=JlLbmeOo8dyWntSt5rkJibDuz5LpYFpLe1bOY9PCO7W9f+KSmqslYcQYAo+tjidhBHYz
 vferJQuzNpfF96E69t2WVfvXQDvhomAcGFD7aWs6PsC7BCvwrO5D8luku2x7WnxYtUh7
 Gd7QYCPjTDRclnqPYRqviuQ0XlHW155+aYEgNttuGU7PE0hzVqz6oYcyrbjG79y4mAvH
 tHbm7GaevmzdMTmPEr9l3txIq3Tw68YK4004tOBZnXH41IakI+7gePvBYJNRPVUMEzJ/
 BuMQGxjB8oxlq5essx4x1LNunh62bnjaMX836kyWa+0dR4iwSHMm8GzCicG6FR3Fm+gU Bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecv6etrgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 03:38:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21N3V1VQ160907;
        Wed, 23 Feb 2022 03:38:01 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by userp3020.oracle.com with ESMTP id 3eat0nvfss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 03:38:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODCgrZjyMIscqQS8uSrvHHGh8B6megynIRpcOdbTexI/dCPDdlNbgKzM+BLss8plX9Vo+XwnDIqNfGw8hzuh6LyJlQXmIHFD64kw5KCOx10n+jaWCNh75uM6np1LU3lVOunsV+hXiiwjkFwsFVtGcBS+Zf0be1ddSexd8Gtr/wTK3OZN3BYrWGA5k14mgE/5cKSkxy4o/ZRw9AHE+hU9SOQV9s0EZ6QgwiWc1RTaj3t6WDrIBwQxAa7jI6/4zkReWyvPkWL1JP9LTOui+XQ7Wj2GixihFYNXdUwCn+IeckDWcxJBic6xDY54Y9iWNx9RSbara+j3Qrn+kVxW91oPdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jN8sqmDrc5JFCIQcglc7kiM6xK+9CwJmphjcT1qZtH8=;
 b=PIHZsTqmyfEOH5KSo7jA0YDHlFQbHA5zFI/s2svO+EvHUT0N13/B6JYrHZtiaIEcAzixT+Amls5LpdPM+vS9LrrQQ/K9Ypa/JbTuDKOxLjZxKXUJwRk3x6Nou2rFydQxM2klmwv+jFr4H5fvfS4PWkmbpbVtMhwTKLsu+deEe/UaRDZp0jMtzL/o55wEqTIoENz+iP5V3IDnwymAChWL0NqgoXrGVI/oiLqVvv9eZpoPc+9oV9SDXd2kQkpGFIq4X6mgjY0rCxptTJsdKX2xdMVof5pRa3BR/YxAuvHg1GQV9Ks7AEBkHsSxGD9zxUxQTo2WON2LRGws9odXlEIuuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jN8sqmDrc5JFCIQcglc7kiM6xK+9CwJmphjcT1qZtH8=;
 b=cSSmI54d0PE2NfPofnDORDguvHHRnXmLcrL+Bz4nnsnFD+wajy9RQbe1IX+aP4mHgzQDWj4QjBGk6PJVTI/Ig7xyN+MM228TT5zRm7vUvplqPke7rxSHBxnWGA08f3/cemm6VjrCWHnzfg4bP7yRwe0EatG6weggowxVH+O7TZk=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BYAPR10MB3432.namprd10.prod.outlook.com (2603:10b6:a03:8e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 03:37:59 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::55de:6c2a:59c8:ed1e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::55de:6c2a:59c8:ed1e%8]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 03:37:58 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v7 0/1] xfstests: add log attribute replay test
Date:   Wed, 23 Feb 2022 03:37:50 +0000
Message-Id: <20220223033751.97913-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR12CA0011.namprd12.prod.outlook.com
 (2603:10b6:806:6f::16) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94ac01b1-90b5-422a-b081-08d9f67de2da
X-MS-TrafficTypeDiagnostic: BYAPR10MB3432:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3432B77A6F291BFCB745BC33893C9@BYAPR10MB3432.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CPOJRLonQnmsbKFFzWpp1QEI0bTcpfX7Qqj1FDIQ9/oXsp84Ld7qd9ey4eq3jtSaeI4ADPYROnGSEigMhy8LKrN8dCfT73d5zS1vxRtC7SjLh66tJmNDHrU5u0t49iapUwIN2Vh7FLMR5pOi2Q9q0kqEWOHYigAy2RZu50CESsAuHI3F6QibGCdHqBZzkKycS09NyF4l3RbWnd+6SVQbC2/2sfNySplc/bu7LA3TxtcnoN1BlhDgI7cd8eyKdYHYTH+AIN9gBj0zOsdl2SBZYenxj84aDweZl6s6CrlHR5kKaGEp48aHVXInIpCBSjslsU1LBBxVAaJpDoiWG17Nhd/fuMvdwdl0/92T96jfAHDOfvX6cRBxjlg4owwOpSAnf8rRY7QoKawnBHxfUbxCZqsKqn8jm4/HOkh+x5mFyCFYvvkc2HzRB7ScD3IBTyMpdztSA4ADPnCnj3+2Zr0xQJIjMqMe8kbWRHoIU7yc1hhCIwLm8azjDmidza2+qk5FVr8xWqBcMS0Qqswx7nNx5xgg6dpU8olEgRyKgdMrZsGUamzRL+84LUk0++6y6r6ToK+yM2p/RZvYVnxSEEZLSjwn8ggSxjdODcTjaV70nXuJGbYtW8ArdeJNVEJ9gbR4JQXopInVE3F+wrxgbEntRDJ1PHeQfQwYjNLqmJxbFH1utfLGj1fa0FSABkSwhC1QTl9BHP/ncZ5Ue4su9FLKNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(8936002)(86362001)(6486002)(2906002)(6506007)(38350700002)(6666004)(2616005)(6512007)(52116002)(38100700002)(26005)(1076003)(186003)(66476007)(8676002)(5660300002)(450100002)(66556008)(36756003)(316002)(44832011)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3RQUkV2dnFFYXFwc3pVcEIxbWsvRTVWekEwSzJ5S29jU0pMZ2tSVmVXSjZJ?=
 =?utf-8?B?emE0V096WDhaNGxselVMZmlxaGRNT0xBSXJ3WXQ1UkxqUUdiclFyVkVOdndw?=
 =?utf-8?B?dVRieDU5bU9wWFNYb2RKeVFYT09na01sOUw5bytXejcxemE5dkdMMUJHMm1o?=
 =?utf-8?B?Q3ZRMjkwaFNFSjVQRFFnRWliemNlWk44ZGVrVE9NRnJob2d2Zkg0dTh4L3lp?=
 =?utf-8?B?SjdWdWkyUG1mTk9kYUxMOFVZdjA2QTF3V2dSVzNJVDVqWkI2RnJJa2FxVGV6?=
 =?utf-8?B?eEM5R3FLa0h2dGhzRFkrVEVmcExZSW0rMElTS056QXdjRzJqK0pPdGtta1o2?=
 =?utf-8?B?UmxKM0ZCZ3dKczNNaTVoVzJOTmMvQlN1UzVnU2hvV3dDeEdiZHZ4cDJvNktE?=
 =?utf-8?B?N0pYRUhJcW1WNmFaNnBmdkJQK1lMdG8xSDF5V1hmTkI2TVdzaWt0Yk8vekxj?=
 =?utf-8?B?aEVJd1pFeDYrQ29pdUNhdGlGVWMveUwwUEpZQmxVOGQrSmVOaVphaVVuUUxx?=
 =?utf-8?B?S3haaHNBSm0yZVJubTE5ZUIrcnNvVXpHR3lrTm9KTm9tZkU5UVVGdDR2SWNy?=
 =?utf-8?B?b0kzLy9pL1kyYWN1b3UyUGp5SEM5c0hjajdRMmVYbmdiMGJwUXBnWkhNQS9y?=
 =?utf-8?B?UFVmbnczKzFjRHFGcjJvNTZBeXNGZ1ZjMVIvTlE5Q3BZaXVGT0lSNklmenhr?=
 =?utf-8?B?M1A3bUlaOTN1aXRsYmNtUWhKYjdoUDFiaGk1QSs4eENRay9KU1dKeXo4VFdx?=
 =?utf-8?B?MmVicjRKeXFIcmw2MGJnUzBFOEVTdzVueFBkR3liZWhkSkNNT3VaTWZmdWNT?=
 =?utf-8?B?czVFSDFmT1M5QVM3bDJqbDJtK05LRGlKRUpuRUZDS0IvdkdNUnlxRGF3elNu?=
 =?utf-8?B?ZWxFWFh0OWVRaGFhUEpJYUM2QkRLTnM5MndYOG1FUlhnZm01YzZJK1VKakx4?=
 =?utf-8?B?SUFwVDZyNTNDTkZvNjFDQkRLR2dxYmhZQTUvYWJvb0tiNE5MNlV1QTk4NzFK?=
 =?utf-8?B?OU9Ya2lxeGMzZmcrRUU3MWFvRzZJMUp2V2xmM0w2TDM2TnQ3ZlFmTllGTitK?=
 =?utf-8?B?dDBqUHoyaVRkOXIzclhHNlVBOEhWZWJyQWNtUmt6U21wYmY1S0JRd2tRTEFC?=
 =?utf-8?B?Q0xYNXlqL0JQS28yczBLNkp6dEtYNmludEtjVFNseDN0VElTaVpwMDRhNzBR?=
 =?utf-8?B?SlluWWZYbDZrWEw1YTJrSmhOVld1N2FDYjg1YTJFaFJTREx0eWxaK3lrbEJN?=
 =?utf-8?B?VnRIWUNtOVhUK0lUQStFemlGUzYxeFdXSHBFZ2x0d1ZLV0xITGk5UzdyYUhI?=
 =?utf-8?B?b3JzcHZmaUIrU2VvOUdTb3RKTVhaVWlKK0U0VjlJY2M0N3pYTHNSYmNJNmxs?=
 =?utf-8?B?bVdFbFVlQWpVcEpLMUxQWjdvNXFmemRnc3RzRTFJbkE2bm1yTWFRcURRR2gx?=
 =?utf-8?B?RTVuZ2JLMHNPdE5lYzFmOFNWVlMxcUlXb3ZIVWpTT2RreXRkWU4yMEZqS3Yr?=
 =?utf-8?B?NE5INWM3UGVvSTVLNHVnenhwQXFIZk1kQWFvd2MzRDdvbEhrVjhtaDlEeEp3?=
 =?utf-8?B?OWRqY0pmRkhuUzZpcHVlUndHTUpBbVpRRHhXbGY4VUNVWjd5WkhDdWVHNmtW?=
 =?utf-8?B?TnRFb2htVHVkRlcvdEhQRUlqNjRRVm5OUFgveXlCL0RnT1lRZXd4Rnk5L2JW?=
 =?utf-8?B?bStHQmdFc0RlKzVQTHVJd2tSRXdISGNHUnJVclN6UEt2ZE40Y2pjWjFUanVO?=
 =?utf-8?B?M2RhbGxuamQyT0QvSlhyYXFaYUJLOVZXenFMVnhXZ2I1T2NVWXlIQ2owd3VV?=
 =?utf-8?B?TTNDT2kwRzVvSmZqcWQrOG8rL2NiYVQ1Y0d0UCtCUlg5L01GZXRyaFh5bFBE?=
 =?utf-8?B?Ylg2NlNmS1QrN0luUUVCa3U2SUZHYmdwSzhRQXVVQ1UxY2MvMm1MRTJTSlZl?=
 =?utf-8?B?djEwSjUvOVZHdUdJaWZjaEdZQlRIdjBKWWZ3VHpVK256em9GRDdSbVA1aTNW?=
 =?utf-8?B?VmlscVNBR2lLdmNPVXgwbi9ad0pKL2tTUjdPUlpGQ3Iwd1djQ2VTNkU4VDhx?=
 =?utf-8?B?MTY1c25QTm8weTBBOWl5L21pamJEUGdBanE1alRoWDF0Qm5ER3pJQWF5ZGtQ?=
 =?utf-8?B?ZGI4Z09wSXllUXhhWSswNVFoeHZFWkxxV1E4RXVuWjZZeThDaGQwNk15VzZr?=
 =?utf-8?B?RUxOWjk4M3E0RlBXQ1JRcGdhYU5KWHBHb2lyWTh2Tyt2TTJZOXN2cG5SOGQ0?=
 =?utf-8?B?ZjJuODZCa1lqRDV1eWs5eWVDek5nPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ac01b1-90b5-422a-b081-08d9f67de2da
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 03:37:58.8838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hgKbYjXsO5x5ogTNqzZBOu7z8Wujsj53haer3HBSNjo2xTq7b+gM5x9r9DhCvQrQE38TGNlOzCdqetENFk5me/DsvDTjHerwARAsepI3JBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3432
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10266 signatures=677939
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=698 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230017
X-Proofpoint-GUID: WHIuhdyUO45EwgpZ269S_T43o0dTN_kB
X-Proofpoint-ORIG-GUID: WHIuhdyUO45EwgpZ269S_T43o0dTN_kB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch aims to provide better test coverage for Allison’s delayed
attribute set. These tests aim to cover cases where attributes are added,
removed, and overwritten in each format (shortform, leaf, node). Error
inject is used to replay these operations from the log.

The following cases are covered in this test:
- empty, add/remove inline attr		(64 bytes)
- empty, add/remove internal attr	(1kB)
- empty, add/remove remote attr		(64kB)
- inline, add/remove inline attr	(64 bytes)
- inline, add/remove internal attr	(1kB)
- inline, add/remove remote attr	(64kB)
- extent, add/remove internal attr	(1kB)
- extent, add multiple internal attr	(inject error on split operation)
- extent, add multiple internal attr	(inject error on transition to node)
- extent, add/remove remote attr	(64kB)
- btree, add/remove multiple internal	(1kB)
- btree, add/remove remote attr         (64kB)
- overwrite shortform attr
- overwrite leaf attr
- overwrite node attr 

Running these tests require the corresponding kernel and xfsprogs changes
that add the new error tags da_leaf_split and attr_leaf_to_node.

v6->v7:
- Rename larp_leaf_to_node to attr_leaf_to_node
- Check that the larp knob is writable
- Cleanup files that were created during testing

Suggestions and feedback are appreciated!

Catherine

Allison Henderson (1):
  xfstests: Add Log Attribute Replay test

 tests/xfs/543     | 176 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/543.out | 149 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 325 insertions(+)
 create mode 100755 tests/xfs/543
 create mode 100644 tests/xfs/543.out

-- 
2.25.1

