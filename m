Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 534A7C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 09:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237519AbjFFJbg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237528AbjFFJbZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 05:31:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AECE10F3
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 02:31:11 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3566EAs7009199;
        Tue, 6 Jun 2023 09:31:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=AKnz81ct7IrmQ4SHxlXKP036DcV8oQnEYxMQtgGMyXM=;
 b=sBv9deRozDTgH3PlTfEMXhsVoO++WFfzQg3lLLYZCHHrnCuy82DbQdR0P0wcM5/VQLWm
 ypc3MzyuggRI74jbb/+5079MsuI3H7NObmwiL16fuOBzpO/IRVcxisYZMOZiOwGvWuFG
 C5c+pkzVhiDR1erDX8lvo9bcbaPhZ6lb5J6+g+SScrdtWpHh7bVDIDSqSIGdczIL6oF3
 ekKQhC9p/AHtsiROznMSR6R4kHr1qTmL+ro0j9EMEGRj63K8wmvrU/pUwwXw8LmV9Afu
 +Frg2SLO7esSng24gufDA10VLlHovoJ124Rgmx+wmL4xKt+E/Cn9hoSFLv4744HqBr4p lA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx1nvx96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:31:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3568l3MR011250;
        Tue, 6 Jun 2023 09:31:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r0tk04t78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Jun 2023 09:31:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I4zFf5pcBUde7hQzzJzB+IVSwf7zb9LsCZ4qU7elCLpuuP2MvhCRfO4DHJDM5GFtVtg9eHmJWUoGrvDwO0FBTGf6juVgUKs6h+EqZIvrWdPHjrdnuHBU6wKWrtBLaSSozdy2imoI+C/E3372oLydBDB85oHZ7nX8ejwkfUsiOCWYzkxg+dtNCYCfxGdADYFYOQyTZQiWSe0OB2+FOvJs/1sVpqEeJX4L9Z6YXU1n1WhLFmY6Y44bXVueuzQTRxI3UC3o9Na7GC/bsNTbJI4Iodrh4KCIpQxOdnQwgaP1czffIUOs3emDT0R4lcmlk7GyEoGfxyFZLujPdKYfHvqCDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AKnz81ct7IrmQ4SHxlXKP036DcV8oQnEYxMQtgGMyXM=;
 b=C6y+gdqKBw4/+1KTWAu3shIUytTgYIFRGd1IX4eI5wEVpcXDYHEXien84tr2jba/tNVmPgH8t4NPT9IY2QgBJoRHDj4fENK+AxRmE+XmgkOPW7dTQZlD8yM0CwuFUilFHsIprCz9LN5yI7VM3NKnJMaYgLpOLwS0j3qFyJopHerOUFQIHY2fTkaZTrsgwOPO/tV81NYw01aDhaR2J/03iK0di5UKFeU8bbbrRlKjJU0gGCl7uLsHgFLcA6WutpYePhhhOYhr6Pu+XJ6kJv8jH1ICajrsAbARQ93FjbRH7xZKoxGQ3OSSVi/wJf50wT4qCBgl+UUJXKtpzBSgPki1dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKnz81ct7IrmQ4SHxlXKP036DcV8oQnEYxMQtgGMyXM=;
 b=XgTTvE64k7mAkW9BYLV3pgTVlznk6XDnsp4tUYmNdv0iA+EJuRWMREltST0VKZajC0fKekngGaUYZTumyimtRm7V/2Mqa80778OPXa+dmF5pu7igCsEs9Uoigi2HA22LeuatR1jS+9YVPxFZKDuz0BkqA0j8rxsxMLQtUDdIiZQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by LV3PR10MB7747.namprd10.prod.outlook.com (2603:10b6:408:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:31:04 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:31:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V2 23/23] mdrestore: Add support for passing log device as an argument
Date:   Tue,  6 Jun 2023 14:58:06 +0530
Message-Id: <20230606092806.1604491-24-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230606092806.1604491-1-chandan.babu@oracle.com>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0140.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::32) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|LV3PR10MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: a13b3ba0-ce32-4330-12cd-08db6670bfe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fYqjha5/ByI+Xi/JLWWnRhSPH6zBcTkieNDryreFblZrfBq2NLjwnT4e10pZQaA04WMZUct6zfmua8MJX2pBsIGvOFfBaXWxV0fYYU/1aqPVm2AYWQYtEnbWq+XIQ5uHq8ioKkzVMDg67Ui2Y6n199o1eCsMFwH9o8XjepNJIvochtpxDf8hWbna4HagbIpHqjzLDxPLUs3i6GNjch34T6J5kzsm+6x70ywkYZj46ce5qKam6ktOJ1/ZWZmXfhaAt4p61nFwWIiy4qyVsJh+R2bybr3Iuq50mx0fuDDxte0Vxy2Ddz9Z/C7wrII8lTG4SGg+15XbCP5Y6N1aikyBZo/8QwaQLsInEOeuPAwiBwqKfB0vxX+GcguUMupodn32MiWnQwQiXUoks9FDKqbsq34o+E13BL2+5L4ZO2og6rioTEMfzsLe5Wn6sbWLiYe+CMgS3LRDyNTawRq/KdyQtTrR28GCjIbqtt3+LVPkF2SC6lEfCy+/EkmD9Nu0aHulIqlKoVzZSqdg9pv9+TrJBea6RphhMcCNTW8CXP8by7YKEMyhGknFeY9FphFOWLI6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199021)(186003)(478600001)(6916009)(8676002)(8936002)(4326008)(41300700001)(66946007)(38100700002)(316002)(66556008)(66476007)(2616005)(83380400001)(6486002)(1076003)(26005)(6512007)(6506007)(86362001)(5660300002)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MLSFPuBbS5M8iqbfSXTuTyWNMXDsKy2seAjQu8ug3stgUv37T4wwqMo3/4xq?=
 =?us-ascii?Q?WsDfR23tEt2YiX1Xyi8G7CoRNrvwEoYYPGMObq086lqXHjMng/z0d9ahUdY7?=
 =?us-ascii?Q?V0YGQkZIKq+L7iVlMf940siWP1mwthsjxu+LEkE7ysCN7iRXPKrBCAPk+Wsa?=
 =?us-ascii?Q?cs/yv8L9mVTQK60BMlvGDkVacyUX9O8BYx3Jao9k59sOI/FOq8xYoAovUcUQ?=
 =?us-ascii?Q?d4ilSzPmKdL5DPcpODkxRnT+fZ8QIPKEdJdtNwrbTH2KDxsDJK3nvKRFWEoy?=
 =?us-ascii?Q?/lvt6UXuakraS3F7s4d8MTsJo2zho9MDIvpGP7VWxCmhLO5ErVXw6Wx6J7UQ?=
 =?us-ascii?Q?x2wFiW9su+OSIlZ8DAdCMuJVDJzMReydil1zItJgLjYETfaKcNYXcmSsRLrE?=
 =?us-ascii?Q?U83jRSusjlJt4Ig3PuAv0BotexwsWFzaxlQy1mA9RwJMYI1mKZWL7d17MoK0?=
 =?us-ascii?Q?gxWVdwZ2ciHHeGxPgksHSKjZG0W+dkAJab8f3e8UOgoy60Ov3TWYa0AHGJ3j?=
 =?us-ascii?Q?YsemE7b/b/1GGnb4D3Y0BQjGPoWmIp1Et2bfqYFHyKk1Rb2rJ9TN9Ytviaau?=
 =?us-ascii?Q?txNuvgLX5fUHLQyYgVuyeBfYvgm838ULvZ8Jcj4NcavDhZHYPVrdwemj/hTl?=
 =?us-ascii?Q?VM+KpA9nGYywFH3RwGcb/2YynfmslbXZVXs8sreAUAfwn/3l5Vrw5msSXP/C?=
 =?us-ascii?Q?FDHnBGFvsbFS0qPM7YxRAj1IU3BiUPltq2gXgEPeinAHRnphtH6Nrgm0RAxO?=
 =?us-ascii?Q?edLt53gn6AJpKB2/9W5HHn6P3z0Z9fZklM2lwXTppoNpwjSxKw08xnkJWTn5?=
 =?us-ascii?Q?qF7xOY3YeS+sqvycFdBTUNkWmCN4XC5s3aphgUlnUY59JFc7ahqaAnex/ShI?=
 =?us-ascii?Q?BHu5xygl0ylEvMn5079JHS1XAT63SvZxdL0zmRvAFLxdMN2bOE3rJzF0ZjvB?=
 =?us-ascii?Q?99x/kmYSkBex4hxh77E+kDBX6ifXxV4Md4NAPVGrU8sdILkNf8m0TfnoG7iY?=
 =?us-ascii?Q?cC3u3KoGCRssvnIzKRIGz+6Qy0s/UgB/XTws1lnFTF/QXMEPQRm3m79iS6sa?=
 =?us-ascii?Q?3oEnH5SvlYWuaKCiIMFZRiSe/+9obIDgiH1N8WXD6JkcafgVEtbJ2G5jT4Y5?=
 =?us-ascii?Q?UWthHF9mJFj+akvMWs6bcJ6/m/q2A3nikA1CgRPuYRzto44WPWeT0TgaGLVi?=
 =?us-ascii?Q?0ZqIbX9KOOWc/+O/7FiZgXR+jdVdBK5GD3jXhQmMX53gYRZwzaaYktk1S+OM?=
 =?us-ascii?Q?63k6iZmHPV4S7WdbHz9pu/1K5IEuiwIv54mffLPHvLXmkpcrPF4ZFBoapfCZ?=
 =?us-ascii?Q?/CGhnGqgqItldeALUneyULkxKKzxKIBOj6ZKGZfOXh8tunVOdmR97p5gS447?=
 =?us-ascii?Q?6EG75ntNnhm2E0pj1Jlr2swGuZT7r+iWYk5V4wiGWVevzNsnSlR1d/uZlvES?=
 =?us-ascii?Q?blsTyCWCpZBDRi+OpHTWZioc7/mOhdQTRBE22cpEC74q8xQCe77zNjraqWei?=
 =?us-ascii?Q?CGoSL8EcuJVjtkTsyQ4n7RfMGo8I37jHQdVIvBZdUOi7Tb7xvirFgBOpN2sz?=
 =?us-ascii?Q?FCjtSxbLz5Oy+MeOb5reDgR1QDAoVdCBn6G249KLxePBPc50aSAkik1Eyl7I?=
 =?us-ascii?Q?MQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: OlY4+F159RW48jX8qmi5AE/6KY5AUzZibx0q0mUhfOXiN58RdCEDPoeQTFoQCoXKNtHc7tlMJVO6GJJvRrWVY45A4HU4b+oRB1ufEwF7V+E2z6KZeQijrI4P18aR/CLi7276Ov2pF7X07seFZJjcbliLXwakOu7fzGxihFUQ85xSDv81KPySRcahIn+PE9N4EQ5jHp5Vd3CObEkLDQzmigNkMrM7s3qzqBkfhYd/DaCOcoaJ1JhD7NOm5Nh8EvaytIRx4QZ9fkD0qDYgQPip4RiqE477bDYBkF+ni7ZI7tXnYtHL3XuuXLWt2CFiXSwBlq9R6AkI33juwxdQuG/lOOH0mO378FZaAw3EhSz4WyvO8Vp8JNmHQD9FcSbmkSgc0n06FqWzn5u9CPBA4bFZlTN3XJdmsK0nv9qTqQ0YgWan60Jhu8YOlkQXdE4INZ37w1rQ5vP2mdFfTcgP5R/zOtg/7Plet61fnjbvd5S2PdcfPYTi39xoWLgPIYAgdR38pEGksl9bDZVwTvo511KsLBTiyB4vEMi9hUrhKreTKs8ZrMlKq+Q7WOPJw9gjJ5ps2ZwAi/cmv/jeKrQjxHHrrNW+GTjBiY1Ie48px/xy2J6UjLw6r+97sGy74R+9Ct7mO/1iTcFWMQ/yOis0LRE2p5JXXdrNnNzhkXMF0BoPelpCYJ6lIsiJAffluSRoZAuiVJT0IQFax1qP0s0a4LAZBA0X4EKn1vB5HbsjG6QVPnN0UDe+ata3cdKZCq2MpfOZc4h9acUASIl1CS0DJh+zesEe+XWwxEPZJY6F0o4zDjw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a13b3ba0-ce32-4330-12cd-08db6670bfe3
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:31:04.6784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cTR9BE1lQ4xsDo11YF6JUgtL2EEeawPWavOhiIvvJXPq+2hPGQ4mOYrqNEzb7Hj9EngNG4fs5PRVbZHgZDyJVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_06,2023-06-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306060080
X-Proofpoint-GUID: kzMC5-ifSmN7IaiKOuLJMrfKGpDWfTtL
X-Proofpoint-ORIG-GUID: kzMC5-ifSmN7IaiKOuLJMrfKGpDWfTtL
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

metadump v2 format allows dumping metadata from external log devices. This
commit allows passing the device file to which log data must be restored from
the corresponding metadump file.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 man/man8/xfs_mdrestore.8  |  8 ++++++++
 mdrestore/xfs_mdrestore.c | 11 +++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index 72f3b297..6e7457c0 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -5,6 +5,9 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
 .B xfs_mdrestore
 [
 .B \-gi
+] [
+.B \-l
+.I logdev
 ]
 .I source
 .I target
@@ -49,6 +52,11 @@ Shows metadump information on stdout.  If no
 is specified, exits after displaying information.  Older metadumps man not
 include any descriptive information.
 .TP
+.B \-l " logdev"
+Metadump in v2 format can contain metadata dumped from an external log.
+In such a scenario, the user has to provide a device to which the log device
+contents from the metadump file are copied.
+.TP
 .B \-V
 Prints the version number and exits.
 .SH DIAGNOSTICS
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 7b484071..7d7c22fe 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -460,7 +460,8 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] [-i] source target\n", progname);
+	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
+		progname);
 	exit(1);
 }
 
@@ -490,7 +491,7 @@ main(
 
 	progname = basename(argv[0]);
 
-	while ((c = getopt(argc, argv, "giV")) != EOF) {
+	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
 		switch (c) {
 			case 'g':
 				mdrestore.show_progress = true;
@@ -498,6 +499,10 @@ main(
 			case 'i':
 				mdrestore.show_info = true;
 				break;
+			case 'l':
+				logdev = optarg;
+				mdrestore.external_log = true;
+				break;
 			case 'V':
 				printf("%s version %s\n", progname, VERSION);
 				exit(0);
@@ -536,6 +541,8 @@ main(
 
 	switch (be32_to_cpu(magic)) {
 	case XFS_MD_MAGIC_V1:
+		if (logdev != NULL)
+			usage();
 		mdrestore.mdrops = &mdrestore_ops_v1;
 		break;
 
-- 
2.39.1

