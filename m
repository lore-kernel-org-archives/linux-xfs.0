Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66169C54EAA
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Jan 2023 00:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbjAZAdV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Jan 2023 19:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjAZAdU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2023 19:33:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A35E2B614
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 16:33:19 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PM3f01006689
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 00:33:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=b9hL/97SEAcGQrUb1s0+u4mc6uFOZnb/0bRJD35HRiE=;
 b=jg5rYxeZDhJK2eQrsW5kNaU6uk4ykCDGgqqJ1NBtp47gOtn+BL9Wq+CrPSCVIKyM2v7P
 RQh7ZXJy53mdX3dHqcdSgNHuxVb4g0TF1+QXN/YvZPFW/nL7ZwJk13OD4RtcSdp7l3KC
 Y7uFBSL67klQ6csUbQDve6nCmo53VstvfZhA5m+4FsCS7X2NCd3FqKpVJZojjHJ78hjp
 LNKvqvavKtSNWdjVKg51lh5+thedVzyN+bprBg6rM01Pvf9eDnFOfbx6Fg3O3kCZfCkQ
 AnCCOPdtISyJSiUxdmmGgw8npubbkVaLWZJAVBwg1PxGqwchEHL936lgH2z56YBRil1h gA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n883c9f74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 00:33:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30PNAUAW028439
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 00:33:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g6tw4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2023 00:33:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlOMYzksLzGfOOYAZHfkAr5pdHSUsOnlTFbUE7hHJFevHjCMsEGLnqpvNE0H3UW18JDaT/nAkapxEPtWbJUiZhW0P+KDqsfMhi9Ht2EgBFzGcUiyUY7LO/7lpRwWRdSOLa69M4K2YyH9VI9/EtxopTDam9V8HD3tK1o4rATdlW3wNoeZHgj/28BB18U5qYOEw/lUt19v7wJElU3P94lJE2/VywtyTQRnqV6ZWjNfdnKAZYLh5N6hEbBaj2ZZORxOwfRox/DQziaQ8+HOs1s7HKT3EXK9fkzQxkgeYtzeIy80xbNWXEjBbU3F1ZYbKCXzoDhFGtdB/Jn7M/RZMWIsnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9hL/97SEAcGQrUb1s0+u4mc6uFOZnb/0bRJD35HRiE=;
 b=ZdXas/eMrDphZ+jpg8oMMZfQVhbyzzM7hKhnc4JZ7bL/t64QjyQhvI+4HATLfPIAqfctARy2vF1FlT1CHbu29vMIVfT1mAV6rg74T4ZXGlTlqdBio5UG8c+f09Vtmt43oRROZt+2npCaQ1fACk/uTE95ne1lpGlsEHsMp1Ibu16rcDT2dtEbEAvobBwdyHm9gKIvvK5qzn914HHnxkKF3MKY+OZx5/iYhkpE45IXYpwqSPH6AqvXAZoPFCzAYc+YBvfwqxHHPaQHeZDNO7E+5h+Q2tRVrycuEA9HZ8h91UXhNayHp2atIP32wBLgXUvLT8w0WM4W2hqKrtL+mIVzUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b9hL/97SEAcGQrUb1s0+u4mc6uFOZnb/0bRJD35HRiE=;
 b=u/7Msp7aexxv6/YyE1+AlVj1vxlecmtZ/IsBYbdBFQ5m44p9i2Fa8zwKnWW62VA8Ku+NpbMvK8Sfd9UfojXNFU8b444+bvHpsa9ZTEgW7LULHGykky6UKRjhObf90jhFXl0yWVIxIG5EecLcJlqPJ6LXOdED77hu4NA0tyaIB94=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by CH0PR10MB5034.namprd10.prod.outlook.com (2603:10b6:610:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.20; Thu, 26 Jan
 2023 00:33:16 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::23fc:fc94:f77a:5ed5]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::23fc:fc94:f77a:5ed5%5]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 00:33:16 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 1/2] xfs_admin: correctly parse IO_OPTS parameters
Date:   Wed, 25 Jan 2023 16:33:10 -0800
Message-Id: <20230126003311.7736-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20230126003311.7736-1-catherine.hoang@oracle.com>
References: <20230126003311.7736-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|CH0PR10MB5034:EE_
X-MS-Office365-Filtering-Correlation-Id: e8f84eb1-7f27-40f5-ff0f-08daff34ea35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ETu0D+xcNoVymApBt7Vb9cPDFWfUovdi+r4oRt3rQhb+Ue/5ofb9meKvNt77ygQFiX4R5hxnO5uFPpTG+PYchsOHAISnPFgVNcDg7Qm/uLIw8jj1u0cjlhV47Y9pkAzl+mKgXbyv+rNzZC0sffMIeCxv9cIa64zi2JztgkB05vsNu+63r9BeGpQCs2KdiNZ2GNdgB40Hsu4pGXyKziA4qIQOAGv+6xPdHO/ujeYh/5eEPtdct3KVEle2cAm07hIbmhXGJEH3Lh1SfvjkzbYGLpw5VhPvWmIODfVjlcKQwRoMA4dLhB2t7b662L9B/mVgDhqDfQDRXSVaxiAPK5whBf4DDlRdgtPzb0xT77V61lW7xTJ2vRYHBwOV+wUQfzSzg9prnj4WSkGdqn4qdQHF1z0neOilogx4WdqNnKYOanbbnIPDDmi9RE4E3kGr0lPzfmspRklky64fR+UMh9RZrVisN8wymxlbVlGg7EYW03CzPxfi+dPX9R+rvFu4IzM9dXRssU7icU4lUmmxChkA3fM3mnMeeBr4PSLYnRxttVDlF8YmxiNyJa9v3GUObS0k0CF9wus8u/qXSVfd9iKJ05t4scUfoSUpjt+V+qhj0si7ssoAvGBlu4agEk/ZSfhBtbwTw5zCA+JD/gP8rnP/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(376002)(366004)(396003)(136003)(451199018)(1076003)(66476007)(2616005)(6512007)(6506007)(186003)(478600001)(6486002)(316002)(66946007)(66556008)(6666004)(41300700001)(6916009)(83380400001)(8676002)(5660300002)(8936002)(4744005)(44832011)(2906002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nXltqe8XjFB1wmO0iDnjKe1kQTDzTcexB4WKRmPLojWAbZPlIafarEKNZy7t?=
 =?us-ascii?Q?gxKvTcCNN+CPy50OLawzaoxPlXsme7qG2rUpVgy0ZergXNchzat7uVglNgB0?=
 =?us-ascii?Q?tdA/Sdp+b5LstgfHcSWe/FQuCwrrNO004i77c5k+nL5a7WcqfbvRnwjWrfHa?=
 =?us-ascii?Q?cf5OY1JbKqaYxXJxLBQCf5S1kdOotluyy/Rpj0Ag2cqJ+utYaEE3mvP2h287?=
 =?us-ascii?Q?AagMaS/7ePPBMS9C0uYjsm5hp+zXusR82iamwEcrcCbdsdA37zq+6fUCtlYw?=
 =?us-ascii?Q?pWF032WcM+bQsm9xqqURqttUpVb6my5lj1fqbPDuNl4PrMLGSngU4L0xqlVy?=
 =?us-ascii?Q?iAQqRXln8XHaQNrLlz/7/8X/fZWig3LlVnui698cFpuQjoYm/MrLcOM8dG5Y?=
 =?us-ascii?Q?Ng9IbMQvEPMWfhKh3eH77rcmXpv1y0NmJhbsnl9hrCdRggZiTaJRcsMUjCW0?=
 =?us-ascii?Q?KkLkEcoC9wdkF6d9/31y/06ZosTbPRyufknhRlCNoDZSoTvvM0AhppcrCm47?=
 =?us-ascii?Q?3M4M/iBiPjIzzad4jyWMduL+EXIf7BbzmvfBsOgWqQSGtQJWOTr3zr4XvphW?=
 =?us-ascii?Q?tP7cWD/UGNcSyc+59n1//hsh/RVVzhYo8eJj4ndBL9PXPT+cKCTBzKwDoxMh?=
 =?us-ascii?Q?RB9ZpaeOmHu5J6nWDfW0LE1+M1BVqDat89X7sYR4KmEv+Ylyod6wyHXjyRD0?=
 =?us-ascii?Q?l4B9HDsVOWAQ21+KvAzQqpXfHmgueRnR1qc3WixsqMMv0oQ5NGnAYCcBF9S4?=
 =?us-ascii?Q?HAWsQaNGhrAWL+hxKXy3vQN9J65JiElWMKXxnVq3gzPwaTNAakXIRdTtK+UT?=
 =?us-ascii?Q?IWTCHiON5CLzQydgMd+iODIuxcj77O9KVILkKD6/SZV67t4bx4azVwFloHJz?=
 =?us-ascii?Q?wJeSc4So0EPnaekkp68CFe21FVBr5vgdpoGMpqx6simOi7O2fFxbCGa+1g/5?=
 =?us-ascii?Q?MAVsWXYne25ZRhn+n2OnN2wP8bJs+iyl69psfnMuPAwvIMNbr96AG/ycTMr7?=
 =?us-ascii?Q?BnVumj1+8l/Nq8mXXOKaPzkDh1+OqiHiqwjoJygJHgWEChXmqqvtByZyOjtp?=
 =?us-ascii?Q?g15pbMqD9lBASKxcp8Jie35Kgo1js6NeH/c1pLNjr+XOeAod68u801UxWJud?=
 =?us-ascii?Q?kJAtiBHWQLUlIp4O7CwkZWNmnaSfHoiksTQtguRdFl0hwvhA0fUzJvTkn62N?=
 =?us-ascii?Q?TnTyu7d8yxIVaNjB2nvE+h7/hudDd1mFh2BaChe3w8m3/Q4DpG4GgEtlP5RK?=
 =?us-ascii?Q?dvEuTHFKemkUNr0TruqC2wigfHJSw2S2kZKTzy7+tmUOX607YvSXHS4yyCGi?=
 =?us-ascii?Q?LT44DNkdnAN9UeJ1bpWbmhi/qOtv89MgZk3/cDWeDRxnBVYQ1JD2fGG/+gMy?=
 =?us-ascii?Q?I1cdnnElBNJiRL/uTcddS4uVSyKmSWe1cTObAQXM9rMTJ9/QO5yYy1pA1t/0?=
 =?us-ascii?Q?amNh7z0+hEWJ5yr53rADHvoNMZwzZepJKoCiiRcHhjvj+jvIT465iMEs1V1S?=
 =?us-ascii?Q?9Jb1XBYrqtwES7Op6YJ2XlH3zTNU6QJvkKWcuBol51ko27UFLljy/aCLqYyE?=
 =?us-ascii?Q?JOSeOVq5P2j6o5F1/8KLqmIQP5z6+D94nYLdnJugxh/HPW3cSfx+mVd8Bffc?=
 =?us-ascii?Q?GT2oGbt+a/PaRM3kIK7cJUzOBCVB+xqP6nzeqFuxsJE9XuR4dSPuNRq4/mKM?=
 =?us-ascii?Q?rgflUa/ILgCyv0X8WOlHKpF0ClI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: liPhY7KXQuG+7Iof+At8nalfwV3F8ccjhAoy1XvbSSK8dbo/L2AbHK6go2AzakH326jV3yCU5nCGaNFXuRolQjE+IDkS0VI8AIeylz8Ui/iY79Oe+mHyrV6T0EJ/CRO5KIJH0keNBXK1tao+KDfWme+DGQ1eFrNCzgUQMv2YImO1E0qA9gtQaHryKsAQtqHgcHtmaIoSD3ME6HI8mdIQRsWYWPSUuwXjmSfo94AQINKZlfUO5DG5V8we54gBPXHFoOWoekRlYQWRyzSC9nO/HuBsmPnQDG6oKGmKoAIhXJVt4UQjoNlYzJBcZm81yk0OnblwGPaOUjRp16ijOhDFffy5lbTiIj7Lw2yDC7aTMZ49XqAKqfhympqFTbFU5+QnwAdarY1Uh4EI8+X0B7J/RIkYxAku0vie2kFhUgHaNQrKDtxcQZkYYunGAyDoObiJfxeabCRFGjtGy4c4Dr1bX8+9S335BE5QQYPBfuS6vy9NgNhts3YbCYZXILs7COoEmfT/7F5HBdnLErcgTApmtOf62CVtCIhCqaCQROSNoY7BRXvAqio8oOzIaza4DfBqO/ZIQPTBZErS0ul3wgKKKXMwm6oYeQSXaNt5RU7v5nTVoj+ncmi/UvsrNEc1FEBy1JwXSqos1HowvTNX3qwu9QhJNY6lWetLZjM/xd97w8w45Yq7Z5GKlOfZrnyN2sxr4ZR5Yb8bKnHSLTbROEAEYyci1OYjtGpaQQgbYtGNu0+jOWzmE2hKD81mdk/7iLud0Ua4HYvfDN7K9HHdWLC/qg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8f84eb1-7f27-40f5-ff0f-08daff34ea35
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 00:33:16.0385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4+vLLd6rHHG7+RR4GUa7ytIUclaAyU2wmEYf2SnkO3kZK9V2yQUap9N8juTIN/56lSfuCf3lLzAkdGhSlp3Eh5qp71wMS98Ogzuw+LGeQos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5034
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_14,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260001
X-Proofpoint-ORIG-GUID: YlOG-JajP2Bj3-lpC3vVXGKmfSMs-xL2
X-Proofpoint-GUID: YlOG-JajP2Bj3-lpC3vVXGKmfSMs-xL2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Change exec to eval so that the IO_OPTS parameters are parsed correctly
when the parameters contain quotations.

Fixes: e7cd89b2da72 ("xfs_admin: get UUID of mounted filesystem")
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
---
 db/xfs_admin.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index b73fb3ad..3a7f44ea 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -69,7 +69,8 @@ case $# in
 			fi
 
 			if [ -n "$IO_OPTS" ]; then
-				exec xfs_io -p xfs_admin $IO_OPTS "$mntpt"
+				eval xfs_io -p xfs_admin $IO_OPTS "$mntpt"
+				exit $?
 			fi
 		fi
 
-- 
2.34.1

