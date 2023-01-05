Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C55C61DB3
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Jan 2023 00:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbjAEAhY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Jan 2023 19:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241152AbjAEAg2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2023 19:36:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7090BAA
        for <linux-xfs@vger.kernel.org>; Wed,  4 Jan 2023 16:36:23 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304MEVVZ018553
        for <linux-xfs@vger.kernel.org>; Thu, 5 Jan 2023 00:36:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=TiKcRcE9Lng1qBH/VHH24Mk/ZU4q/tPTFVHFTX8xY00=;
 b=ukxPJGB2eyfuJpgIBuV70Cp4jNFwss0pd5rbaEKb9m3bkCNM8iXRDjOstUVk4MgpGpuQ
 VUn7EuLJtv3nBicf+YMZcA7s+LinK2wvnqx6L4OmTMqIHIGa3Ebc8FQj7wsIigGCmPCI
 B4ssKhNYk81VU28TYiJdtpz/uSEjcePSdR4pp3wuP1RfAQ3CvkOTgD2aechHr7yuxz4j
 gy/GTXBXyJhN1qZwM3AJaz1Cfq2x8+N7lH5kSNU+bd2nkd+qcbF8hPH+FwavtByAR6oZ
 nhhQkG0SEibPXM9ikWXswvlvdvIPSou3XTiYWxD+FPAjSY7G6pk2YavhQRY29UdIBy+i kw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtbp0yuvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jan 2023 00:36:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 304N2uwI022525
        for <linux-xfs@vger.kernel.org>; Thu, 5 Jan 2023 00:36:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mwevhty3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jan 2023 00:36:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hsb+xt9DLQgM9KVDPz1zS+kq7zhRH+jGMNp3yieTRyRocQ9OvAB6v9f1CVQIYRFiE+jJSUIipknR4JDLDK9aHkqKbARvWzxU4wUYAK6HKGl2msa0UbvW42fkSpvl1g9JFgbxXeOhPf0IfhVGVeyXBJUoPuPV3B8T7hFroKXLuYWg/dBTIBEdvY1Nx1dGfB1aXKijz3VZAByeDF059vj0yIbM2T457WKHE3QCWjdRfmBXiCp440mj3NUFkDol3GQfVGhc63FdeD1eXJNlTyh5aFhYg2nRou3BiKCQZGV8hzHGr5y4EowqxzdORGpgOQb94wDOJdKAwfRDqs5sJgJFmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TiKcRcE9Lng1qBH/VHH24Mk/ZU4q/tPTFVHFTX8xY00=;
 b=jbxjfLHIz8lco/0wp8z5o74D3fokC4SeP93WaVzTJ6K5s2MLJl/e552XY4E4LFgmyttAjcLNQnxYOZFlNWhQ09QpzbqXppDUHjncAoCM4HZeyCkeXbdJfMpgdysa64x5c+FrPDZOQsVQf7poeosqkpkxo9QqT3y5KUvQMlr5YGYppnon2osI6rcXwfkay7mBC+MYwSqklB5veWctZUD1Vba/s6nwLDYw//JNdzT7WIZgM3q9fWaxr26YMJbhhXL5q369S0OBSNwRGDibFZ39g6cwIcoI7v9sL6bDFoaW1B2jyl06549+G44emYRCygQLZH7oVYd/prhjDGCcRSKCGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiKcRcE9Lng1qBH/VHH24Mk/ZU4q/tPTFVHFTX8xY00=;
 b=WLCjji1K2eE4VI2MDQHc3nFriKpJ6XIzhgZibpzsS0enSHsPf3lJmDRpQyzEF7rIdmE7eByXKSOL6PpA4/Y/qASw+9z9uuM3dr3Cev36h0d/3RYtN/KrN+VGSYqENC6HFzMWb0kNn8Nxr/7IT+JTDuappXndy3SekFh1ITzVaXA=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SJ0PR10MB4622.namprd10.prod.outlook.com (2603:10b6:a03:2d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 00:36:20 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 00:36:19 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/2] get UUID of mounted filesystems
Date:   Wed,  4 Jan 2023 16:36:11 -0800
Message-Id: <20230105003613.29394-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::24) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SJ0PR10MB4622:EE_
X-MS-Office365-Filtering-Correlation-Id: bbbd8ee3-7019-45a0-8de1-08daeeb4dcd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JBAx4PZcwi5vc0Bmj/gMQaoHetpdpoDeQ/zpwunC3hjYPgeNBih/qw9mXC2VJeXTM3ZhsHkpcs8F+bSg6V5kEz5KIqhHSF1lolbsIWsMgntaW6pUeUIMuszOCAyvi5x/J0pNVMwYyTABvKun7O/k7zy/zpsr5fiWGYOqb0zYWYCGGVrSAnY18XDlXKgEU8A+r/7gPW5RR2eBflw9uEaOPKaUYOvx9X6BSUQW4aSbl+hGaC06j9vhKo0DxjnyqlyZYgxupBeXoMGmJJg4mCPHAnE2soVB4bjK2UbGtDcOtV7Wtms7iALPFy+Hu0s71tV7wj1Zm6blsxMrSJIjlm9OWVIETzygo77EsvVZtd7pBDO1JO87gY2K73XtJyX4Tfunl0BgB5CStXKQk/iobUeHNOVIYs2m57QjAgAckuXtDEDfroZHOVK4oweK4WMM0ENeXSa2O6r4+fnBVOVPPYmE0JBea9wogadyIED3twvCYquQJKKjKndaQsORrBKWBX69YOCsIzJcB/IU7Z7KRH3kg6l0iTw93BJHkzD9rY11nX3y4nDewKRj9xWV/PndI+N/35keisLVZTUD9MKG1ZnvNiw2K5subPlcXWn1FXNpPsXqHTbMQ1zZLhutUqNgpRGQ5jBBF5a/H5D24jQTrb3Niw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(346002)(136003)(39860400002)(451199015)(6916009)(86362001)(6486002)(6506007)(316002)(36756003)(186003)(6512007)(83380400001)(2616005)(1076003)(6666004)(8936002)(4744005)(478600001)(66556008)(38100700002)(2906002)(44832011)(5660300002)(41300700001)(8676002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RtxwV7Dzj/QZEVw0jqeix4QAqoO2Q7RP0zhmBni86IWUXmq3TR4pu78PCcjs?=
 =?us-ascii?Q?rPlrC/qbksyOqk+hsDp8HrZzHsPsWMFVpJcEwKRJx3YA/QhfjyQTtJC285fU?=
 =?us-ascii?Q?FMg1dhTPOUZ4dYVgu/dKoKkbsRHcoeQYE/mlxF3dFxESJinQXoBE6prFlIOE?=
 =?us-ascii?Q?5xQeeNCCdHc7LjIAJNqZ26qenUwaSREoqvm4OZw+rV59ZAJCcJl93SOZKZ+/?=
 =?us-ascii?Q?WwLDr9IN+dLyRdLXpXDYv3UuwZKjQ1GeTulHgbLOyNPg5x9SJI9fzm9CCK+g?=
 =?us-ascii?Q?kb/zajov7VRLELp1ilwdIcgcNDGOkuHjIMPVownltIQEsWrvmb39MLDLH8Md?=
 =?us-ascii?Q?bY3vGdRL0mM3THVCCSfiBzrsqCCk3Ot1wHhx3ZAj2/j7Z9HGyNqJbDXBdJjF?=
 =?us-ascii?Q?+y0Pso0AYraI4eWPuoQ6K8y9DKdHirB4QBR2UJkxDeiKpvF9a56eazLyRkr8?=
 =?us-ascii?Q?F+GeKFW97AJKuwJRl6p0NN7jxmJ/uQ5Sbpei+QpSG9uO1LR1oKPgkDdT0/q5?=
 =?us-ascii?Q?vMa4CUikjQHAHEGjbgwH0IKfQBwOpAVNiPuYlGcPH/JtUxMSS4RndSLMLFy0?=
 =?us-ascii?Q?BethTnL6NZ7UiWKTbQFXScBHdth+aDIM4VGQgZED45FinefGWihNPQdiS7YM?=
 =?us-ascii?Q?JvC7mJGa11ybKTqmq5WX/JeqSeqqoVUisxycoGl0cnW1k5rGyMZB6qsyVTuT?=
 =?us-ascii?Q?INcLi5gp044vsrw0SzB3xiWrRwVzZOmPSkgZImettw7zuTYzBTdocFM2bfym?=
 =?us-ascii?Q?0po51IykDbSa9AR3/G1q4D/vxpQ2r6wLFOoytY2Uux7wt2omtSe/bCy+4Qeh?=
 =?us-ascii?Q?5ZmZWn/33gdEOp28QgyT3rjPR0Ih0ycVjkcJdwFwiP8cxDcyRQjD2FT5JZSI?=
 =?us-ascii?Q?XuoEybFH2I4n8e4bJHLwpBASmrdX6128EibIXoJX2TxLmW5xFQooch5HCrHT?=
 =?us-ascii?Q?uslqKK69sqq/WwHN4A03LEaZDL6mkKbAo2AMnVbt+emPdLmK9mWeZcH7T/9p?=
 =?us-ascii?Q?ts+KTurCk3+r9reiGm0gFK8URmAcv4/VAYvjz/8MKFVdXOfdNojQ18uUz6r8?=
 =?us-ascii?Q?6eHH7CX6AsB0pfBFh72u3sUmMYtqrTHfTZyCNhXgzV4+kXTJh9Uv1pD3n3pe?=
 =?us-ascii?Q?J+7V4Ui6b/I75EVsrydYTtzqT1wLkiHZ5A74Jvh5VCSTagAamu5bkwtEeu8c?=
 =?us-ascii?Q?TLOvnRoOKbhFoBvu7D4bv4oRIJUvaMp6nrXlAyvK0x+6cz2ZBi93vLFwGZlW?=
 =?us-ascii?Q?hXihp9K4sTyUSu9dwZxBehATEKtkkoWNqoXxhH+wsQrukxm+YDYXS5j96mDu?=
 =?us-ascii?Q?oYqG22/azaxjETFC8e/XaLzbaQtJBftAh700sgT7Z/HxauNYzqkADpn7gJP7?=
 =?us-ascii?Q?zexI6jBvgwKLOneIQq4OJfWXR0zSxFtXp8TnWBcSwKvzPu207jrCqH6mPp9U?=
 =?us-ascii?Q?SfyGLWdOK5Su1G3RLTdZl5YzgzHHkC6nOTM7+BIKzT+IqN3n+pf4ISjI48bt?=
 =?us-ascii?Q?AFysCfCnW94qwlgrtiEiDIfisyxKQ791NCXw/X+WM3CMhcy+DPHQbdy/TU6t?=
 =?us-ascii?Q?P1a9lvyN0/oZRibmYdXkHFJbYJehXGlRy8J11sFDGy/xBQUmsXdkUySexCil?=
 =?us-ascii?Q?1ongFSskTbivR8elgOJw9n4wJv6ijkzL+RFLWBLILz/Tge5zzQw3NC9nvjt7?=
 =?us-ascii?Q?Mjwv6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yFj6HT8U6hGcjO73GaI5dhTofKgsc+r2v84zXeaEJ4U9vzH7OVUqLRGCkcw0RTBDGhkITPzehjcYGb8fpvxn9pvp3RfE9NRUAQb2FBSl5Rv7nozX6OSeaGQHEXcMUtFNh6vR8wm34ymCppv2EXvGNYQYdxA7a3clQYR+ihXTlCuSQwh7BLviODk5I5PqxVbZdxus3RoUu829SKTPMmHU5pQh5pLbWK6uTUjkYsBLA8NUkz417xk/mofhuRF6FyuIxsk9FJFGolajSQ8d5pFftMEtKqlD55zaFvxB4cN5xQtp6xntK3/WvIME5MQGnORTT0mYre2Y5WN33RAPcRtAOuWWOM4nfhLNn7vqd+oiFuTuWo+3I14liNqfJVjXj+wWdID1/byAgMRyZO7eeCOiKiX2bHESlGq2H7a7328rRqNBrdG8ZrJo7H2i7CAJawBY59ZiTl5sahwGA43tjPipmN3/onqcBXe1bFRwdqw3MR7GSaz3QzKsOqlNdfN8zRllfUZrAk0pyx+SX9rkdIQlH9L4pbXIUStwS52CuI2KyRxCs06Wb5KRz1OVmZ3h1liz6bb87BSUuiKvaYEjxaSjKxgC9mhdre9qsMyxXSennM7N6w5GNQm4ZXoL/0/FeCQMtVsAYlo6hB+7Bf7HwN2AY/edMSrppCRynyiNaV6e+8+4gqQup1TMQ8f8tC1JefFxlkdzmTb2cFOnhGV+mcVLSEgsHLJpxcH7/4u+h6horOf5BYhUOWMLMe2dULQgPKygL3zzjFxiLNa20j1o1Q62Lg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbbd8ee3-7019-45a0-8de1-08daeeb4dcd0
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 00:36:19.3932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u6wCKY5DZFwB+JMbQ18LASLeKcdG7sTCAeXx0nfqSK2JWBswMk8m4PC/5xLxu47HA3ek72HKl3392O0HIMVNhOJrRDvyntoUCJcSL4gvzkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxlogscore=861 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050002
X-Proofpoint-GUID: dXQAWUTyylv4f0N7jaVHeFv4poH1_vay
X-Proofpoint-ORIG-GUID: dXQAWUTyylv4f0N7jaVHeFv4poH1_vay
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series adds a new fsuuid command and adapts xfs_admin to call xfs_io
when a filesystem is mounted. This is a precursor to enabling xfs_admin to
set the UUID of a mounted filesystem.

v2->v3
- Keep track of which commands require a mounted/unmounted fs
- Return error if both online and offline options are specified

Comments and feedback appreciated!

Catherine

Catherine Hoang (2):
  xfs_io: add fsuuid command
  xfs_admin: get UUID of mounted filesystem

 db/xfs_admin.sh   | 61 +++++++++++++++++++++++++++++++++++++++--------
 io/Makefile       |  6 ++---
 io/fsuuid.c       | 49 +++++++++++++++++++++++++++++++++++++
 io/init.c         |  1 +
 io/io.h           |  1 +
 man/man8/xfs_io.8 |  3 +++
 6 files changed, 108 insertions(+), 13 deletions(-)
 create mode 100644 io/fsuuid.c

-- 
2.25.1

