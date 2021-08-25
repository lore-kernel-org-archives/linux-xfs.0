Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25225C4320E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Aug 2021 19:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 062CB6109E
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Aug 2021 19:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbhHYTwl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Aug 2021 15:52:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:15426 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235554AbhHYTwk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Aug 2021 15:52:40 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17PIK48a010057;
        Wed, 25 Aug 2021 19:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=SDboWSrRrYjIdAOiO/Dj9AU+pchQQ55x8Uzy1Hcvbxs=;
 b=pkxfHft0T7h0+mQLFyEuA/Zkx04GEPxokwXp1h/Rvdgpo8Jwkl9ocqbagQSLPMP1TrZe
 vhzSgJHysc7GpwlCMzBF87d9tdSg8RHvGRstkaYjb5puNaMPXudFjP43Kp2DX2rki+T8
 Z89a3olkk1IKyr47w4wfv/bK+cpi+uUsZ1nK4Q+kcWPtijW0PIFZMr8Ui272TRRWI6ct
 YB0wIs2FRCaFGKKVm5R/modfLR6shPsw5FwGIfZCly0ImhViDeFrBkRTrSgqkZVCViE/
 zSyN3wfJee0l6sf8GahjFxPLbADqyjoYdCm1fdNtd1uqQX1yZl+3yC9QVtxGbkeol8TN xw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=SDboWSrRrYjIdAOiO/Dj9AU+pchQQ55x8Uzy1Hcvbxs=;
 b=BbduscI809Zvjm9+BSw0ScWg/cGUkp/MbjBt4NB9ZPbyVkzliXm5WCC/w4FIGhoevJAo
 lNus5Dgf1UDjpifmvsH81zrXcA+uS6R9E4jrs13n/pbJqdqY3aN8SzvAYhT/R/DSzBOZ
 wvIdOPDtTkCp1jt544VNYwNpG2gKjgpRHZ0KDxa3wddqDAR+HyOqhz2Wqgd6dG4i15ZI
 yifjDRmP29IZYuZ5Jpf32tkYJjz/wjiv0A8iKgLIBLOFQpExTQMcM0zNMfhASJAEr3ZI
 4EZDDZP4C0rojN+6sOH7xum+ZEeuFHhp0ISRIgKq3wBXgx/YnyJBnlKzaxMkhC/4wfSg Dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amv67crua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Aug 2021 19:51:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17PJpQ2j016195;
        Wed, 25 Aug 2021 19:51:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3030.oracle.com with ESMTP id 3ajqhh9emj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Aug 2021 19:51:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJCUddU6tGeJ1n7QAjIy7TGhtOP0ETH6Ushg6yqAqrE7N7RiL6W4ThB80hRN61wU+Vhf0f4rshTRsRCYPrUfQhlmi3cwj+VcohlqrLPiG9yHmq/ckdPUCJ2GD5wRbmU/WhleMXKmZzSwmES41NWedpv6q642AwIJFdbCoYkkKZVzstzO14wghF8eXS/pPgB6cUKapFrLlakNok2hzM5Z6qq/ewefvQ1ozSNhBaqyGV2wgrfO51trhx16xj4/nWRZVoGsA6OLkVX17EEh8Yd0eH6dWcHZvqer14CJB5tzx1nk9OuPV7z1Eo+R420GJR9lf6imCsGiJxUuUgSu3Xh2fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDboWSrRrYjIdAOiO/Dj9AU+pchQQ55x8Uzy1Hcvbxs=;
 b=Yot0ylnStJ1ft7KpqmKbLwYq8oH+MCd0lNtzBjQygw0NvSjGsOLhT7T5guix2T2kULkbrlj6R5s1jJ5SjSHHxPNOjSdben8mWwcRL3/Kux30DHCkn8Ue+V2QYH4IwHJp5vNzchynUbNrh3xQ8LGkOAP5+gZ7Wpeic39a4KG8bnrNcBXKt43ghsgItH55f2e0htlHMwgOu+AFvxaGXK69Uz627NFPEfQJOk0B7SmSBOUZQ/V2pGOYrfvJxlFLIlVKVwF2SK83S9ciNoaxaFPMHahXLni37SxigDdg2MjW9g4jUKami2VFEiQrLupgb0h8a8b684cVIXlFKQ9oB1R+OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDboWSrRrYjIdAOiO/Dj9AU+pchQQ55x8Uzy1Hcvbxs=;
 b=Js4/+ZX/40ZefsnpZ6SMCFsmohaZdJgTik+D4VPQ8/Hbj4uRqEgckY/DYX7Kezpv7STRKIND0D2zq9pg2tQrTXsDRXdPzcmtyVNGZgoI9si8y4yyWW4M3Mjn0Su4xTyvkviLiZq2o+KNh7AzpYTK9RyvrugcZ3L5ByKLiyGlWzw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM5PR10MB1850.namprd10.prod.outlook.com (2603:10b6:3:10a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.17; Wed, 25 Aug 2021 19:51:51 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a0c5:940:b31d:202b]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a0c5:940:b31d:202b%7]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 19:51:51 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v4 0/1] Log Attribute Replay Test
Date:   Wed, 25 Aug 2021 12:51:43 -0700
Message-Id: <20210825195144.2283-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0003.namprd13.prod.outlook.com
 (2603:10b6:a03:180::16) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from catherine-VirtualBox.attlocal.net (99.0.82.40) by BY5PR13CA0003.namprd13.prod.outlook.com (2603:10b6:a03:180::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 19:51:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f86846bc-9528-426f-a54c-08d96801c864
X-MS-TrafficTypeDiagnostic: DM5PR10MB1850:
X-Microsoft-Antispam-PRVS: <DM5PR10MB1850368889B04FDC3071973D89C69@DM5PR10MB1850.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3/xYU1kqZ9ArO77d5WLHQr2PbCINzF4SAQi4MAoLJtXCO2rsDj/SJEC4DcrsqT8jzrvH4ViGaDnGeVz8dwkevg45pEE4W05w1dsQiXN0ihh++EdU6mQKFW1OBZnJGcOMmDmYK6Jp0QpEPdT85ENijHuHDNTun/W52NKy1fjwizxjpGpTZYJLE8HEE52/WxJxrQZEoPnQdzZ0Gi8VcWCfr5aYDUX8nWlpBpFjnjF2jvDBR4I6qehlxieJ0A2/kr11hHZjWNlzD5HahBGlTqduYWSlx4UVeUcwbGRRh51p7AwQqdrw3v76DIEgP1uMC8J8B0AHSL8GTML68CCBQtG8w+D9HrcAnkVpS4M8p79towXYhNErHTiaL8ofosEY8h8wrugLz83kK++d+qYWYFVz1VSNA+CpXw9Fc/xIwU8lRMQZsdkIkqb/ENt28uOWGEpp8Smip2EZjdJTARaEVXjcHEwmDzJcJgzhfsqA+2nXEwShzGW+EFG2MFc5UerkGI2nhRFfa8fjuLGOLaC5MRoNk1GfbqODgMd454OC/yM57a6oF57KZ+M1EfUHpfhPEHvIgNKaVxKfVZrcVyFAujuwT5RtEEWEn3o4INfOD8R+1ROP5FLBdA9YbtVPzuFSPMMB2LOOIQV9mJ4880jv9AGOUaEc5z3Vt99QUH43UEeNGGr0uM57UvIZh7/0SzzXh2cDdSbpDmmIqjY8zPEb19cE8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(366004)(39860400002)(44832011)(2616005)(316002)(2906002)(956004)(8936002)(52116002)(1076003)(38350700002)(38100700002)(8676002)(478600001)(6506007)(66556008)(5660300002)(6666004)(36756003)(6512007)(4744005)(26005)(86362001)(66476007)(6486002)(186003)(450100002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k0fMFYzd9gW7TeAFrJ5VWc3Qlduui73tceWykN6Sz1IFuoGAvC7/CYCdvRcR?=
 =?us-ascii?Q?2Ky4Vwz3MQjFuMwHZD8M4OeAdUYOYFUwd6hF8qJAWBjqMa2e8MCqxDkUKgd0?=
 =?us-ascii?Q?xQnbw7UbYE0GtsZUri3K9CPuCeE2kQdd6moLgAwUFTIW2i+CB53wmjK8Zx2p?=
 =?us-ascii?Q?7P+J7P0VfU8NgdEGosiGqpDd2tAU2CfjMYhtALKgFGZewN4T7loH8onYB16G?=
 =?us-ascii?Q?Yg3i7KUsdaABtESdp9WDo1+dpLNaqTKVROSnYsgjoKUOo878Cc99C5DK7KI7?=
 =?us-ascii?Q?YPFhyt4cZOduvNG2qqILtwhrSyIXqFCXqgqAJo3FQL4BAudaS4n6gzNHrZYD?=
 =?us-ascii?Q?YZsInQ9Dh6NQFXZOf/0iz4LqcNGzufRx39Ja8Sa65frMG/jzoV9VXx0uoPDR?=
 =?us-ascii?Q?ySaPHOlt+1UC7kJHJBakM1NyS3j91fuqj3ZVXY05Cys6WKZq319XL8C2LaGy?=
 =?us-ascii?Q?YTJJB/TeC8a1qfccnV4pBBJuwu9Ta00YmR69Voe+3Lhwu68H0lKczT+0HIAR?=
 =?us-ascii?Q?nRwn7HIwnJePURyxh0HusX+4al3nt7TETQjLwTn3L4Ifrubl6/je2nTzeMMW?=
 =?us-ascii?Q?6hov/TqakZML1ytTXIifj/EuaQvM/hVM5zKeCw1xafPofuDY92PgzCM8rBfW?=
 =?us-ascii?Q?Hv8iyQ0AwI0s/TMqMQlzLGwt456LBZPBZUFABhT7x7X803R3PmTsJgP5YXXq?=
 =?us-ascii?Q?q/qASEp+xCRko66tANORrrns5RbjXAxD4EkY+82vbcNXXG6bL/F95b/HldtT?=
 =?us-ascii?Q?OUgJvKZTUJSYBDRvsKcyFouu133mWTRP4pBzgS5aqEZHxigTlmpzwS54cHAt?=
 =?us-ascii?Q?EuKz0Vsje8vIrnOPEOVjUWtf8QeLPVXJ5SPZlRr1PK/8ivuRtOW0BcY7ClDv?=
 =?us-ascii?Q?OClx8KgxVUXQCtgsxvJdT0JjOtZ6gGrjMI8FcOpKWqDDUeIDgRMXIGPdUvLe?=
 =?us-ascii?Q?gIHkcMzRsr4YXdK/B32tv9j/83uEeJV7oSXLnIFvYLTrjXMhaDFvSkzovfIJ?=
 =?us-ascii?Q?yzs7IWLsiI+abIY/ciJ5cil/WJzUDC+5zLbkIFmHbmOKim7eDu75ZF4Nlyfi?=
 =?us-ascii?Q?gzVkiTUlIgecFkz2WMJCM8XJVYlbweetqJkeQcpuYWXUbOobazj7zKaUu0ig?=
 =?us-ascii?Q?w6Ss1AkI/9S36N3Cy50kgbH+c6wFyv68PcsrTMOKvrv581mHBTosiETvFfc+?=
 =?us-ascii?Q?RFVEYEjcZ7TyDHBrKRlK+iiFkygdD1qA2kzk/P+LIW+UhZYSY5LVzcKDImNH?=
 =?us-ascii?Q?pBZlvPfOWs9X0zcL27QHQMppJHzOAa3mEh4yr46eGMwcZtRj5jtiTCWPV3bz?=
 =?us-ascii?Q?xffHML9qlpvl7EzvLlszY2l+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f86846bc-9528-426f-a54c-08d96801c864
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 19:51:51.8269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ae/CiRNExgP0M3xTM5RWC0bjt0a79kqwLTTaAADGJDbF7LE21Iwqbqk8osN8NlYaWUWeaCH+JqLSz5+F3SiRqKK1M3mnztWb8m9RuEPeKHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1850
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=931 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108250117
X-Proofpoint-ORIG-GUID: 2Y5C6BP7pp5ENg4AcfVKCYC2ujwsdT9p
X-Proofpoint-GUID: 2Y5C6BP7pp5ENg4AcfVKCYC2ujwsdT9p
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I am currently working with Allison on logged attributes. 

This patch adds a test to exercise the log attribute error inject and log 
replay. Attributes are added in increasing sizes up to 64k, and the error 
inject is used to replay them from the log.

Questions and feedback are appreciated!

Catherine

Allison Henderson (1):
  xfstests: Add Log Attribute Replay test

 tests/xfs/540     |  96 ++++++++++++++++++++++++++++++++++
 tests/xfs/540.out | 130 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+)
 create mode 100755 tests/xfs/540
 create mode 100644 tests/xfs/540.out

-- 
2.25.1

