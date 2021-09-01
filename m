Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEADDC4320A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 22:10:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B72666108E
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 22:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244785AbhIAWL3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 18:11:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:33644 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344607AbhIAWL2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 18:11:28 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 181I484g025820;
        Wed, 1 Sep 2021 22:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=St+gY3rzpdZEm7NXjGBq0Ahc2vkOGBP1RJKeGNNXWWc=;
 b=swCQ3Al2I6nP/c+ydQhaK2OHVAN89qhXCfQN57xMqFCb8/dsLUGEyVqhKtbOf28bmo32
 Imw+4hGg3vw8SEDHCLRY+8WiRbrvSoEepbse9H3KZCI5zleqpvAxm4QpTCgrMQyqxXWk
 cFMrThoP+pfFXXc3QcV6cHS9i83yrsVUnxATXuQxlC6jWuhdO5iANtnE3vdvq7TYRqlE
 azifAkGBfnbe4eJOJ44y/96WMnxbgC2WXwbPanhuKbYCOn9Is4lXcC2/PGb5a6paLwoG
 KVMzz673iqrgntPhvaWmdc76SWP73dtqWffsjWhdNtEZdDYuqAs459zXJnW0dsxk48Bn cA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=St+gY3rzpdZEm7NXjGBq0Ahc2vkOGBP1RJKeGNNXWWc=;
 b=EFpdKGgWIw/bbyukmRNx+6kkn/7L8aZT4QpUas7nbwJaBln8yTDQdQZOZQelcUGHcQCs
 mSatB6p3R4iwUt5P9buyRVVZZSZjpWSfwmGVsyJyL9FervDJXyG+751xhT60/ay4LCR2
 NLpkMie0qqQsvaaTnP80q+rgB7BMK/hYo6qikLVqopNB9F5i2g8VQ/lsr5KTUMY6vtZ5
 wQujbLN/EMx6djMwa6JXdnrfjUe5dcYJ4+PijU733DrPM9C2rpxWj0INPwVDz2oV4Q7c
 bbjf7ANSGc5jTuFe/oP6Af+hI0tEL+HxqFxuwYhdYOtUZdDCwywfbPimYmKf5Ry5CruI mQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3atdw58nrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 22:10:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 181MAS1F044096;
        Wed, 1 Sep 2021 22:10:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3ate04u7q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Sep 2021 22:10:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVEBzUXCH25vfUOIJ5ttsBjnuTnxSmjj10sGmsZBazfoe162gEOVy9ZmLMNe9kXkUyhP4ffbFCszzU4W3gACjLwz1we6cTFLR0vrEAbN98i92tgo0moUCn0gOl5QGYzLeV7dycpPZOGK/Yat/wfiVAbOcTbQAGdx11Wy4n/XMRgBgbE7icX3BBoThVx1Ilxc0lWEvuTq9QO9Eau4GOl/bahiR1dRoWM39iJWPJZTx9bt7eeaOKEUFEE5fE9ycgrw79MPA+HZMv6FlsWSxLEmnnA2w2hC6zR9kDznYP8jBSbvCwwMi93MvetMECUJGuWr+MvexN6ubD8yFMbLeQQBpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=St+gY3rzpdZEm7NXjGBq0Ahc2vkOGBP1RJKeGNNXWWc=;
 b=gKMIaGOYVIUVuMIEAfY61fagSRKbuSirbbdQsEQAGmKUhOvhGAexMke5piudHLfCGseYoPEdq3hlrlNnaL63xzvsUVN8RRmPQuG7iSyhupOQr3BBUB+T5Dj3lgMR4eQLqYxvbuiErR+u07V1rdeetsNE6TQMRqpYKsTGYc8bEGZrwq7fHviwMakbspsTy4dFkwX+knzL9TtA9cf0toHQTeqQatZkqAH/sjadnY5WnbAfMYPwMrPyPvYcYYzrr5AbnlpO2Pw6kGkbgaKRKBPc8mCTYUOmRTxwxpMMUFzqo3diGiw/F3Gk3oNnsLl6kAhhiKkbYrjmYWhWWBn8j1Khsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=St+gY3rzpdZEm7NXjGBq0Ahc2vkOGBP1RJKeGNNXWWc=;
 b=Me0YspJ1g3n4RdVMx2PAi3HUJHMTB2Q5V+WDyZRT7MXE/VyY6q3bpIqDPyuLD9LHqTHUtKpUO13youEepEOJUBbfljl7ZZq+7LxvChZdtMm9YQzdT5vgpXHr28BFkyooyNSmd2hFiVIN0M3xs+7X2ZVkg0cZonvOKMVqmdoUbjg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) by
 DM6PR10MB3211.namprd10.prod.outlook.com (2603:10b6:5:1a6::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.17; Wed, 1 Sep 2021 22:10:14 +0000
Received: from DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72]) by DM6PR10MB2795.namprd10.prod.outlook.com
 ([fe80::a59b:518a:8dc9:4f72%6]) with mapi id 15.20.4457.024; Wed, 1 Sep 2021
 22:10:13 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 0/1] Log Attribute Replay Test
Date:   Wed,  1 Sep 2021 22:10:05 +0000
Message-Id: <20210901221006.125888-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0069.namprd11.prod.outlook.com
 (2603:10b6:806:d2::14) To DM6PR10MB2795.namprd10.prod.outlook.com
 (2603:10b6:5:70::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from instance-20210819-1300.osdevelopmeniad.oraclevcn.com (209.17.40.39) by SA0PR11CA0069.namprd11.prod.outlook.com (2603:10b6:806:d2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 22:10:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68b11329-91cf-43f7-8cc5-08d96d95459b
X-MS-TrafficTypeDiagnostic: DM6PR10MB3211:
X-Microsoft-Antispam-PRVS: <DM6PR10MB3211393026A31DBDD8CBD6FD89CD9@DM6PR10MB3211.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: htfeekPM40JZqCbmmk+wmjyB049Z12U3mCD5zKp7RMG1bxzEdCxqoB1JxQgkyXUf7LKxM3VBP8V/iow651eF/ss41K7bdYh0ArgnjfReLNis73YOJ6TeeUfSaBV51OSzX13HgPs45y9FlJkBdHbPwFYPlsu9DkigyJpoL1kgezo0CwIccuKbRrL0/9IQ+ry1FEzSCJAYurLOcvdv/J5r1w1tl5McJBQ6dGkIpnRrIv004a2r7qIvcb7W3MIsOkkKDb3PU8O4n//wbGsx5fZYalIeDtoh67f01cKMooaZpnR4Z8x87IMoM/wubIxMqaVQ8Tq/DmwMp/gsQNvheesnK2Eg/L8cPeUB7+StvBnwSw0HRKITBM6qyR2tW0BqdwR3tD9F77KwqPm0fxT+EK8rW0LBMKh24dhI8U43VE5euZB7GMcPUtL9hYZjzkjYMJAAtRh3CqicQu1dN3QzYLSHUUb7QpJK7r0BPMTK/+N02dC4JsDx3NZEfkARD4aYPC2gszYGYHFNL8eoPY81Q241J9ktNqgBqS5GwIpnaTr4OrL0PpTAfx4tUbsfJgVxMnhWQ6Z7U3yRE1vbXG8YpXWe5QmOwqpf70B3/GT5V3nIH+enm+fUXsPsSACTyABcl+2q+M5vGtM/tjI6qm59K+ZBfqApgYFR843a/xyUU0EjjONxi0nczIfyajHdp+fV1H5DwGw8D6ZCchvT9FIaSjT81Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB2795.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(366004)(39860400002)(346002)(6486002)(956004)(38100700002)(38350700002)(6512007)(44832011)(316002)(2616005)(86362001)(66476007)(5660300002)(4744005)(478600001)(36756003)(6506007)(6666004)(2906002)(8676002)(66946007)(186003)(26005)(66556008)(450100002)(8936002)(1076003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4GH8l15O4pMNBVSpu6sbmy9wIFw0C3cdel4SmKMNr6Xf9rb1ehlV9ndgxmwZ?=
 =?us-ascii?Q?LiEfDMtNWCDPmVmESRPFf25W9/2EZLXFVagi5fKbw9jL5TozAid6vCODHLMM?=
 =?us-ascii?Q?KrN1tllo61WyCiH/x5Vl8tpTOGwVkN39wilerdeq9EGVO98VERqLCLFMULjR?=
 =?us-ascii?Q?Tx2Ia73YdsxmTwyKTXC0bLGXVn6PFoPUom4FbrI4PFI1cV3VdLGCxc98DlaS?=
 =?us-ascii?Q?RTFcPdmB8u2SlF7CveeS97NW0qBB4UT/XrA6jRoZW5MwH8evfLcGas4nVkC3?=
 =?us-ascii?Q?mjMTthLD9ZI/tlzYXYMLeZTPc6YIVY9roCsCWhV9DDM0mZU1I6cdwpnzQWK+?=
 =?us-ascii?Q?GqdWoIeOaiMSY+Z+p/SpPSiIkWHdkFwbKKcRM1t6Kab1bdU8/VxuvV74AMHQ?=
 =?us-ascii?Q?WHrFZNsKXbdyxxhRAgNxLg8KrRpmYZU9RUy8//oGt97i/6nVcWa2RcSgY2Pb?=
 =?us-ascii?Q?SouFl+8PWA9pbetnPBgVXcHifUQEmPyONJtpzXtd3SZvBltZLzWuzq3SkRfQ?=
 =?us-ascii?Q?OqkXCPw1i4GvFT9I3UTUzbUQzMMQkjlej9ESQNecO36OAawRZZtfQGzY0Vom?=
 =?us-ascii?Q?Drb6zDrYO8ggMTSJnHhN1YPtBzRS1giHUtBOwnsP4ygi20xd/bv5W6vwlK/3?=
 =?us-ascii?Q?wdKvVRQhJPCaHzD2P+dJaACOGRMG0l4nZdzR4fzKpH+yWBPCJcJQO2hd3/Zn?=
 =?us-ascii?Q?If461USrVXyaU3PuKvPSmaZ/DQe84Zjhf69nxrqOWI3+URLYUli8PSctxV9Y?=
 =?us-ascii?Q?TFHB7AYoOGQ2I1ATXO+Yo5Y4bUjd24orLbQt3Mhghf+h4cZF7xDNLlUpXElY?=
 =?us-ascii?Q?fEzR9TLHaucaprvNsGM2ljbKi4i3MJ7orXpUyfWCfWEB32lG8paFIeyGHbJz?=
 =?us-ascii?Q?nnUy4IAUznkh5zWrUNPFJBvPPXzCoQnkxVOOuNgkYjuanvlQHSQENfZRcIgE?=
 =?us-ascii?Q?3roRvRx7b6QxoW3u/Dc7RFuwnvAzI7cnAs0IBWxinW7JazNPOlahswlonqrk?=
 =?us-ascii?Q?HstlshiobJthIht9Gykd1XPApHgC855+7qmvTMG2Kp50cKF4AzQPJpVp5mAB?=
 =?us-ascii?Q?YroXJWsWtyBMPv6vus7iqMbGIjyO/PAZHTbeS2dZiF/dRrwmrbUHIEIih+0O?=
 =?us-ascii?Q?+jCDt8fjaei0KYZlheqzwdbuwBncnba68yvpKhqVuG+VtXxbFrQLAU3IaX/3?=
 =?us-ascii?Q?VRlFKBshyil12NiC+2CuB2p2Rr7cDKFJmYCjhbA4kprSawsiFsYdcpWy0XG3?=
 =?us-ascii?Q?qWuy6ogbk6QiPNSOH4oOHBsvdLTcdewCPBjDsEfUNH98bi9WWRAT494go2tR?=
 =?us-ascii?Q?noyBCj5bcFxyDYtcRtZ/te2r?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68b11329-91cf-43f7-8cc5-08d96d95459b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB2795.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 22:10:13.8330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YkdjfJZQOi/hN82niSiNC7OAXeAytMF32Pxu/XzmJIwgo1FZozqUypbLwgRSvVcfE4sG0FthxXQQUS77rphuxgrbGNM84mS2eUvjA3k72EY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3211
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10094 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=921
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2108310000
 definitions=main-2109010130
X-Proofpoint-GUID: fL3N3yMOSdWU9NoWpC0wtoaxjtWAb535
X-Proofpoint-ORIG-GUID: fL3N3yMOSdWU9NoWpC0wtoaxjtWAb535
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

 tests/xfs/540     | 101 ++++++++++++++++++++++++++++
 tests/xfs/540.out | 168 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 269 insertions(+)
 create mode 100755 tests/xfs/540
 create mode 100755 tests/xfs/540.out

-- 
2.25.1

