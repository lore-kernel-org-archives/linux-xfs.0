Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88AB8C352A1
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Dec 2022 02:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiLGCYK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Dec 2022 21:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiLGCYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 21:24:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030B34C25B
        for <linux-xfs@vger.kernel.org>; Tue,  6 Dec 2022 18:24:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B72JiX5002944
        for <linux-xfs@vger.kernel.org>; Wed, 7 Dec 2022 02:24:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=ve99DZuHpP+IvgQT9wsrknuk4PKV7sDs0T5SS+m728U=;
 b=BtoscKY2ArWYWUPyp9JupjD2g8soTzItOUNKTJN1YobSK3HlLGrwmoBozdWKA5XW4BIt
 mEQHigHzi/BIPIMu1HaxRkiPx1GTHFGWIqvWxdpn9qd1U+zGKvLopfUvLfMLPeURQJe9
 uCQTgwfaFyzMduSxATi9Nb99tva4JK7Ph7PPclNKJI3n7oN/Bvf3yJwE8vA5zcQLcE5s
 veWv7kXxr0y+4RJZSBboOB9FKKqPtz3zJy1HGSbX12Al9Gj5qVXaaoLULbKBjl1qbd8f
 T0QPxCsSn5rYmA3K0fEd4fNbhZDjcQOyJaEyGeMRjfvsyDUFObAHaDT9a2mOz6KLZ8J3 VQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ydjhrpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Dec 2022 02:24:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B700JCo026252
        for <linux-xfs@vger.kernel.org>; Wed, 7 Dec 2022 02:23:56 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa8etx6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Dec 2022 02:23:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxiuy/xJJJ3F8oLf9js/TA21w6Cl0TL1xXnXP/fVOiEB1YyxvnLTo2SablKW9Ew+n+B7xoHVwV8E6Ti9b6+51WEdTQwenQPkTVHHiB5GE0o5vtjdicZlfZllDs7gI+16p1PzAGJIPok3nAVFnHYZtpJSatfpXOtO4AlLXDHxURIB8U8YXSrqzUZtgnQglBf61pA90MKTPsBHQZvY90di0xqB6ukWUmQKsyZgGtCF7qqebbgKwaN0LI6IucoHFSPBUA0XGo37svwHkWSIoKh9YmdKWZNI5NaI5HGsGmYwkvTd4zX6AveA+M+ZGjjPcXkY9f8BNOLSZXFTwlfsjRVSEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ve99DZuHpP+IvgQT9wsrknuk4PKV7sDs0T5SS+m728U=;
 b=JyfuoKYSmKOzFmqaPmkdC0snJUWGp0QsIQWPEnhYzeo5lMhfuMAzlJbM79UpU5JTMGmVNFmNGo0Z2yXFN+YmAI12LQIt2YVAficMOVp/48flBwiq64GU7k+lnzYOHDCLIEBT7klK4v/t6fFutFXq+GGj4YVnn8WeNFn4aZ7jqo4fxbKsgDuPG1Il52Cq9HMImdu5DQC4m1PagRFnAOHCLAw2bNmdHfL3+h2+XBSvUszyTZjTPbWvD2GVCMG7IIW1bgueSXyCX+J+otYxlHmX+MhwqUYsi2ySuZ96UgQiQAD9WNzmmy8gUEHsVNQ+nShgNu1ecXL6P4KauiIWRm4Tnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ve99DZuHpP+IvgQT9wsrknuk4PKV7sDs0T5SS+m728U=;
 b=cWwgcP0tvRcJmtFhF7EIgpagOyraK1pOldoshp1idPLIwwVeZR88scXH6T91lDndq4UAJcXWHNoTJ3SjDGJZ63tmRxXLr9mgf5nsOQRCMUGaGIlABp7aiyF9QCvLPp8f+pFF+nnlYht5XN2cw5LU9cp0avq/oGDVATtvJ56Bb0Q=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6983.namprd10.prod.outlook.com (2603:10b6:510:286::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 02:23:54 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e%6]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 02:23:54 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 2/2] xfs_admin: get UUID of mounted filesystem
Date:   Tue,  6 Dec 2022 18:23:46 -0800
Message-Id: <20221207022346.56671-3-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20221207022346.56671-1-catherine.hoang@oracle.com>
References: <20221207022346.56671-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0053.namprd08.prod.outlook.com
 (2603:10b6:a03:117::30) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6983:EE_
X-MS-Office365-Filtering-Correlation-Id: 3323240d-765a-4256-bd19-08dad7fa1601
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jonupsftMI0Y50Lq/Xd87Wlf8zKX2El48cjSW7LXwaqpPqvhyQ7Mpkb9am7N8sFNj7xcxFNjBaxaAqLRJ4c/jEQFGP2fB/MorHcy+gRdNd80NCPNpeG1xXOP37F1aiYqmn5po6pyFcmWNrWE252cXSYiklJtaUi68Y4HUGiIq+uLHqqNO4X4HEe2yE1y0olFav7kYSKj+2ZZKgtacOFqobl69YVgrYeAbZMZKLg8dmxcUPRZmBxeFPDHe7ZP1z2MBSJ8xniyVc7gyYIGeTEs5DtLE8SJSrLQh0LrpUJ8Hr7iFfAhOqKfkCHZKQeTyeqxzhExn7UEdUkQIAxZ3OMy1TUOY9vK3AmYOM+HFpa5UReLmlIvTK5TPCfB56hwPW+I3Cryonzuh5lpg2VjUUeI2+SpfnpZ5GhnQFWTe81pbeRCiRL8O+BjtJXc1YD6vdhOjxUvMkUf173ov7+CwJ2rVdEOQVl6rKs+F1X+xd81Zo2ljKlWTFXwqQWP4ecXjBmn7h69WXP67w3YhSInO0QRpcg1JbmQXPTZx682aCuCH10wCf0eiHU/PDN4xDdblCk5V/mafITaBGCw5rc1SIqnCcw3w0znABB3LbZbNO0YQODHpadcW5VjY44kpMBGbiZo98/Kqy+UEN+VcVQL2bJEuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(2906002)(44832011)(478600001)(6486002)(66476007)(41300700001)(8676002)(66556008)(86362001)(8936002)(5660300002)(66946007)(36756003)(6512007)(1076003)(186003)(2616005)(6916009)(38100700002)(6666004)(83380400001)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JaH2zomg+WvIYfyaIzgj03ss17K+paKpH5dHOkybHNLJa0hT13eRzRoFrF4H?=
 =?us-ascii?Q?K0KO9M9P+D3AilsZZJDHzJ1TuxdcFZGrhhovzTS4RrbzyK7wQlGUsL77ZtP+?=
 =?us-ascii?Q?wHp3TMyWIHrtjrswhZJvBhmDztnN5D1fD8p5m767hqVAQih5OdO+f4S8FUQJ?=
 =?us-ascii?Q?LAPhXx2WhplH9Zg1oShZftUY2U5J9tviqb0cl85RL2czJjDU/Tk5pgcqidgY?=
 =?us-ascii?Q?kt2YvvtzfpI71HZtJbOrw3JoF8aA5iYcnQoF0IyDzd7zTIM4dHNQ86OvN8FA?=
 =?us-ascii?Q?6PmHGjrAVdQ4jh1TMvyUvHwuM2Rrppvmu8Qn8NOyRyCtO0oXEsizWdcA3sw4?=
 =?us-ascii?Q?UkEtKN6XRav3fN7hhzFMBnF5UBwfT2WQe+cmJRjor4klEsIIZxm5uL60Cvu2?=
 =?us-ascii?Q?H2+ielaoDcr8h+Dj1f9Cfnt8HqIxxRTmKNZgZfr3icE5WsB0+LKzlA19By4k?=
 =?us-ascii?Q?FKZxQqs0jk4CPLYGVJtkyhkQvwSj/9Fqq7N/ntSd2txmg3jnWNGVm7DnA/Vt?=
 =?us-ascii?Q?iOckr3aybSjjYV2hxGA8/rvBUo1DNaROt5eP9asjEwdShN0Z/Lp51WTV5occ?=
 =?us-ascii?Q?09PjeyKB2mGe18bJqqU3uIN87T+359AyKor8mJdJH5OoyCvtcEuyPvA5/GXe?=
 =?us-ascii?Q?/AetkWfI5WNZ4DXGPdUYEncqGXHv3auy4ob/V+Gr6A8POf++Bf72SsgHn45T?=
 =?us-ascii?Q?p9E0ffUsJVq6UTSew9W0Gpkkb/VuW2jtjjxtS1dbJRfrMf4KqgwPCJM2IL4U?=
 =?us-ascii?Q?EVk2c9QBVanBOiOMfUwOFKvAofQ5VPJ1wTF1hwT1FrW1CzdLX2kDyCQpHIrz?=
 =?us-ascii?Q?teuOn2tz0yCkQ/6PvOeEvUqCdkVjfE6AcmFlpQCC7GYbNClYuq/hvqmjctyQ?=
 =?us-ascii?Q?/KMht9Rv8BoBojKb0MQUIlEgOg6e4Rtyqlp0gSVJKOLzP5+gpFt3iY2zScA1?=
 =?us-ascii?Q?1YVVgHjANZjY6VHlYnB5xsHaxN9iOZXklrrwGF8F//KYHfJLrHXKbpqVsjUt?=
 =?us-ascii?Q?gfodDGvlFLdzZJg9IXfwMUv/u18tCjWZJ/I5uFz5yJE2efzEuTPNrXZv2Fos?=
 =?us-ascii?Q?XRN+UQH13zxCpeckTF83tIbgWeC8Ys4D7GNwH1u1tw01mFWJx2R2r+3VN0JM?=
 =?us-ascii?Q?2dh0LNxAD6gfM0mP6gj8VrsUjZ31znWw+uYL/u5SE5jIplDAinIlcTgspyNP?=
 =?us-ascii?Q?NJ+iAoEMu/+GJVKGcQerF05YMDjntJWySJ+QUPKGN9H8wqINiqF1KVikkSVk?=
 =?us-ascii?Q?reP0jw2hEQQEV6tTcVNTDVqHf6esCFKBM/XGXraGRj863Re7yKdFNiTROVgy?=
 =?us-ascii?Q?utBNDpVdJhwpNthuEIfJbVQtE6Dd0aaEb7HyKc/OOvrqOW3CxVGKwkPju4oP?=
 =?us-ascii?Q?Tpph+R02tNkraELpMy326n0UAxTH6ABDQYkdB6tj1gEvq0sExUJDasO1b8wq?=
 =?us-ascii?Q?Z94jHKdKcm+0Ed/+jiGjoHESVvtv1AVfAPV3utRzV00jmgrZ4NDE3EXP8T7R?=
 =?us-ascii?Q?GciXLKxJ1u+GhfjgGb6Xsa/x/v+yLxYftxFRqX4Y21oS9MNqe5a4N6fxmAvL?=
 =?us-ascii?Q?OVPI9+CMwovuI374EmarNlomzEK40ZRFoFedsqR05/z/DPNsNjY3kjB84eZS?=
 =?us-ascii?Q?M+uioCu9z5p6tTNJezOUHNM+zOjL8ea//pIdyxMcFXJjjjrtD8/T60cgZqDx?=
 =?us-ascii?Q?lCnhaQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wu3dTJluTpro0/xm2mnQTGqirha6M/e7ukMb5ORM+UjWatyrsRvlzrHe7HHa4KsNS0mFWGVYzDe9rPA25yHYmfJYIOdFS5CUKnX66A5TubbosYcSVjGERY5Ncbb3fX+EHJJm5vpOpMGFDjzdnO5npXTprbF1I0mR2HAJDbouM28t9RaMOeH5YV7VVjKkOiNgPzTGX1+9o35nJdgIgqMFNpKr9lHUXhsvaVv0y9tLpzG4IeG1HYYi0607eSTUdkIPRM/1m4LDuVYmBw5Jn52shKLbqxPwWU7YayPR9gt7+cQu+z/VXpDmEfLSuH5G0zdjVNpBQoiE7JLyboEdseXr2yLRjhYooupbJPwoAgZ+4YwYs1q6+zzJ5cO/sG3z88AzXnVUM14ueRQF7EEWY9NUr2CpUfigg+RfBCENPozEHb5P/OzqZYQBZMYYvnHyATO+g+2wVSLbrKwMUO/QtCQicWwZ1drrlEk4CJv44cYshEfLsixkhvRMS2/0TSe1oiblzz/gLe9F+XI7HhH9bUVUjAaHJN8Gj8nI9iBKh/S+M6fBYXoErTjklXq5u4nD94dPR31YLpNr7akHJDDjJlCob3ZTDoWQ4Z2VOqd1DMKilREluUKuzJaup6We2ru09pD4Itnn1WfDgyvnDTso9rLsy+P0Zm27E9EcC+0oeRoRAZ355F24LxYcLdJ/h9CpEkGy2+Jd1ShXzzxUyCn5hLkocFbRE133vyCwRcN0XaibrM43ks8WCvpF3KIgw0XtFqWPGdYf3Q4lM6sJZu6xsFL6xA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3323240d-765a-4256-bd19-08dad7fa1601
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 02:23:54.1586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G9L28lTyJWrXr15s5UpS3Sx+QY7EZDWoZDSWFKRG7RFYxxklBYpjk3Yer111yZYS/+VToHfo/xUwPP2X+hXqY2p7kExClvil/3+vRWUQhRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6983
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_12,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212070014
X-Proofpoint-ORIG-GUID: Zwvuj67or8w4MjAGsERldgRpGZEoTq1w
X-Proofpoint-GUID: Zwvuj67or8w4MjAGsERldgRpGZEoTq1w
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Adapt this tool to call xfs_io to retrieve the UUID of a mounted filesystem.
This is a precursor to enabling xfs_admin to set the UUID of a mounted
filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 db/xfs_admin.sh | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 409975b2..0dcb9940 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -6,6 +6,8 @@
 
 status=0
 DB_OPTS=""
+DB_EXTRA_OPTS=""
+IO_OPTS=""
 REPAIR_OPTS=""
 REPAIR_DEV_OPTS=""
 LOG_OPTS=""
@@ -23,7 +25,8 @@ do
 	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG";;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
 	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
-	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
+	u)	DB_EXTRA_OPTS=$DB_EXTRA_OPTS" -r -c uuid";
+		IO_OPTS=$IO_OPTS" -r -c fsuuid";;
 	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
 	V)	xfs_db -p xfs_admin -V
 		status=$?
@@ -38,14 +41,26 @@ set -- extra $@
 shift $OPTIND
 case $# in
 	1|2)
+		# Use xfs_io if mounted and xfs_db if not mounted
+		if [ -n "$(findmnt -t xfs -T $1)" ]; then
+			DB_EXTRA_OPTS=""
+		else
+			IO_OPTS=""
+		fi
+
 		# Pick up the log device, if present
 		if [ -n "$2" ]; then
 			LOG_OPTS=" -l '$2'"
 		fi
 
-		if [ -n "$DB_OPTS" ]
+		if [ -n "$DB_OPTS" ] || [ -n "$DB_EXTRA_OPTS" ]
+		then
+			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS $DB_EXTRA_OPTS "$1"
+			status=$?
+		fi
+		if [ -n "$IO_OPTS" ]
 		then
-			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS "$1"
+			eval xfs_io -x -p xfs_admin $IO_OPTS "$1"
 			status=$?
 		fi
 		if [ -n "$REPAIR_OPTS" ]
-- 
2.25.1

