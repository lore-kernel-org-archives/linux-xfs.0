Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2E6C352A1
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Dec 2022 02:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiLGCXy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Dec 2022 21:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLGCXx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 21:23:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B744C25B
        for <linux-xfs@vger.kernel.org>; Tue,  6 Dec 2022 18:23:52 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B72JiX4002944
        for <linux-xfs@vger.kernel.org>; Wed, 7 Dec 2022 02:23:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=7gPZ7kVBxtYI159qBMIdLp3fFFVJO5/7zL+DtKtgR+E=;
 b=Pbi9zNNu9coZY/QZFkLnIL+S4kNGXSt5M4Xo2YV/jpHZXgj1SF8X27EJS9fivXk7p3Rk
 9FXmqc95O5pe0PU7VjrL+0fXRtpNFA7Z2+w86pzDmc4jmNNFNgZtDpXNlfvTQNyFTTNR
 /GBIJKdybxIRnUn06PgdYhwL2N1BntbQI06ok04aB1bk/neAxw7/m5MjJvIp+a1eiDi/
 dSfGtXFkTxODlx3Na/voTi8H+kbaj19eJDYbuKgb+q/6vIg/c4KoeoaxOGcwv5DNx5ry
 75uT+0oVdNLz6Oho11tQVeAO4eGfKjAZ4MMSVnjvzZHsXpZy7Vk4qtM/K3mhOZ0qkD81 Iw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ydjhrp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Dec 2022 02:23:52 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6NjhsV008226
        for <linux-xfs@vger.kernel.org>; Wed, 7 Dec 2022 02:23:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa4p3d56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Dec 2022 02:23:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LO/uzFA7FNUWs3x1P1bTMnb44eKyPyydH+FlxQm6NFMX4awsrpMivfBrVVwLO6iBm2PDa2nbWLmrC6PvVdSBbHQJGwdwSf/1OB1RcxPuVkvjMBPmNEnfuEH3rk0MdII4BniUUmnrRfc3tCFHYHvkNJdGkeku675euSfVFTKLD8pkz69vc2bGRgwbnMLrS6sS6zuyN34KRWYf3XkI5aHmR2bCYcxKAncdwRwi8+tbosIlgcBuzpygonNQjGLEUNYH//zUrvmhxSVmiGkjv76us42qjWqSevqjrzlFpHKlSj0qRPQKX/OgpdRLdAvut6+mqXYCYNFFhV8u3Na+YjVnUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gPZ7kVBxtYI159qBMIdLp3fFFVJO5/7zL+DtKtgR+E=;
 b=MBGfZsSRD2IbJgbdPb3N/MLo33A3Tq4KB0UORpSxedh8v/+64ApGR0hpCbUwydF5WAw1v6ovr/eXY4vqr6Di/R4i++qxYTo9cZXA5EBua9qu9Vi/HfWV18iiYl8roFpbGPMbAQ+M+VmRqJWRy/es6QcS6oFJ9w8dp0o39XV6wyUU+CZvMta+bTgtd2knHFruEJvdTiIcc9BHKsAmxVck4UMEzMJr/XrOl8a1535JL+L9guzFxA76w4PK+e+pKrhbM1g+7mQC1vA+OfpkxzqhkNFw9Mln1yGIfbkk0v2wdCOD0NEmKyYZNXKjRBoeAn3xKTDCgS3uKxJ+zjArTuJyng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gPZ7kVBxtYI159qBMIdLp3fFFVJO5/7zL+DtKtgR+E=;
 b=d/icIvECWXVC1hR5AoVUp0tQUq3tlZmFnN7DD+dVP1I0HLpEIwytud4u1zfE4lV6UEifMDYrFe4Y2J89OqCUCI9L1DuilsFuAbMyTZmVQXJ6f4zok84IAh2UJmFZLa6oSbY24Gowwbvw8R8yp5JgyX+HNL9A9VI28h8ZN5b+fiQ=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by PH0PR10MB6983.namprd10.prod.outlook.com (2603:10b6:510:286::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 02:23:49 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e%6]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 02:23:49 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 0/2] get UUID of mounted filesystems
Date:   Tue,  6 Dec 2022 18:23:44 -0800
Message-Id: <20221207022346.56671-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|PH0PR10MB6983:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cda34bb-f636-497c-c75c-08dad7fa1324
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u6c0qXBZNWSrYS2RYrxp/zmK6b7nIKf5HgTxJaNGTd7nh/wM1evqlz5pvWNlUXimQbaRuWf1MkZwE76ACPcxyPiELWOkWKn8asWrcw+HeGRYsWRLZ34FEv1A1fLc8OvUCkFTpZocXmD8ZKrcXtLLiNHVlqXRwmeQJddQIuIMqdnHHVumDTX+sr9c2i6UjQXAnx3IwcW5gOaYdxE9F3Us+NeSZIFaJdHcWyIJVsMUXB0KpFQfZ2ZGM5XJkTQrUEen+w63v+EBk6745bgo/M8CizwUbk4SXyDYAB6nb4LfhcD32EG0uDU2yzX5dGefThXGka3ehQHqmOb7KH/3QOFMRznBHEvodBCLJWHXaQW/lwDVDAu+UXXSxhr0Do58wwk8ZKUdxYlbNb7nUZgMqzf7LyHHeMM1s2G1YLtPOPRe6+U2SQ4h9ttiX0AIhEDWIZVEfRtHjF9Z1q3EgfaupL8IbZu/9K3ruVxDRyuCZggVSw2Lr9w9i+yIPHP9zRDcBVX2dsCJeUV9/sCnfA2akuyLQ2z3+5eWyop8ErqGiW5pvTLiyHEeQEgkSXKibG1gy+Kemtofs7pOMzrTOHZPsQ4RqfKB5NzAVznu70hvUY6MANCw/NaGOCNnbhq1vkeksjPnHUt88SIYFs1AE4AeWsY1zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(4744005)(2906002)(44832011)(478600001)(6486002)(66476007)(41300700001)(8676002)(66556008)(86362001)(8936002)(5660300002)(66946007)(36756003)(6512007)(1076003)(186003)(2616005)(6916009)(38100700002)(6666004)(83380400001)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/senHpeNkYoWiaEuo+wkYU6kYgnFZSr9kgOAlTdevO0bs6iIZeMpc3M5qOjx?=
 =?us-ascii?Q?WL4/ouED+J5hBK+vbliIns490JeVxX8vV5EO43ZHVRl/DivhNnGGiXlamIrj?=
 =?us-ascii?Q?WqAB6dh5zH69yYTq1KtCUUlMquPpLIEguiX7yIhppKZietW9tf3eofth2Jd+?=
 =?us-ascii?Q?1K/qVGi7/cZucGoR7dqYSSqFt97K7B/0hXbAqTk1lqFOsshldwpOMXOX+/7g?=
 =?us-ascii?Q?b2uKMGRGs6zQRhzxj2ezB0ugspy07AZ3z5va4hNe01lnmnVHyY6L6fY2Ju0w?=
 =?us-ascii?Q?M1KB0ClA2UPOTNLxSs+BGCabZ4SozmKsmnDzBZN7WA06XkI+ZjQuBXnc0T8d?=
 =?us-ascii?Q?tSLhmGXxHUSviKL/ped4gCHo2+XrkBvN+e4kUEnzCrjwDD9zASPLSZJTFv0y?=
 =?us-ascii?Q?pAd6rgPiNtqLpoW+ZvbC5wzj/m7rmypkt3I3XgWCQnhP5vkE2Q9gqTmGEGRa?=
 =?us-ascii?Q?4Cqhp6X16X2+CEfACUB9LcQDBJ2xx3LK+EjrSvGA9j5UO10GD8c2J46s02Xn?=
 =?us-ascii?Q?1SekPSZRByeDg8F/YL08jlKbcpMmhOZPlk0D7ACIT3aYgZahjKLOTdUFy8QW?=
 =?us-ascii?Q?owSOcUSz3FgJbjG39X5uKdgXdpELDOjs05sUGMAyyNV8IOnE8BA70EMkpxND?=
 =?us-ascii?Q?fFr5Pni7NsV8NMHhtmHtV3FGcqIozlVh4eS6EZuRMwEMfQ422aHru717LKow?=
 =?us-ascii?Q?bJXQVyzAoVISMa3s8RjkmyEHlVbMwQOhffcWXJkUCDeyWcrzkWf5HQz6kZ9g?=
 =?us-ascii?Q?8IDZ5IHQJDSfKjIub2nQvmiACEY+rlm9GrWFNlKFgmmoMwVYrYAUvUnvoQX2?=
 =?us-ascii?Q?yeKklyHIcX1bqYUvbyhzA3tlldJ2gJJn+ytlBlnVTHweCcU7WQNHfQUbDnT/?=
 =?us-ascii?Q?1k07rbDfurfsKM9JwKdnWgFFDKzlIrBDPaOplE28SGesGFmNVjCAROJ6L+9D?=
 =?us-ascii?Q?ysyfb7guSQvQURM9iNVV52pYFEkQHgsOLDpzKTl4pacW33uQoPHsicPSdQhV?=
 =?us-ascii?Q?aCz8I7v2mQbEuWgOycn+2bMMrfap5B7sFhEA/EkF04MtvW12GQ3hwJ0f/pvR?=
 =?us-ascii?Q?5Rae+fSSCSnnh6k9a52RkuEN9spMcxzuwlH/DTFooazVb8mku7pxwlhErsmT?=
 =?us-ascii?Q?x6T7Fz8NvitKbBaMmEU3lFj172V+4hDQck9j6gExl3Y+sixZ38zTZ/zBVx0Q?=
 =?us-ascii?Q?8pAXcIewyoedYhFNgir8QXiG+0tpOGVGR70uTaFeKHQTzqa6akqJL5R3WpAA?=
 =?us-ascii?Q?bHdKa32V35fIwcGHzC7OONDHC2o+bRmdhQKOiHnuWwpmQ54hzFnfqf9iQVmh?=
 =?us-ascii?Q?zyVZElP4g4Sr4ZohEWDebJUOFuZCSTBn687IhdkOcYrS7znpEEaAy5FhksFd?=
 =?us-ascii?Q?A5BRDegf82jnsjjo+Wu2IyI8Fnz7XDyfv0xVAIuAPoY81dV0OPvHDym5rPAo?=
 =?us-ascii?Q?8GLRUWcuwH94dk7r9Y5xER3A3KJ0Py5ZUgM9oDYmWePP7+MX/L8VxSlFNx3T?=
 =?us-ascii?Q?DMcu2e+muAjfzDCIyOSZeEjmvPOjirolPk6/nQf95v+tLFV3lNNTLZMqrrbx?=
 =?us-ascii?Q?JARbVPTH0qO/71MA4IHfiGCkFLOLIUME8yEc+YyIjPOIVPI5IX94g6h9oxSG?=
 =?us-ascii?Q?fxIyEoTDk6s9ASbbftE8OHDmetBJzGUHklbW4pAbdVNS5Tho3nDoM7fl2IgS?=
 =?us-ascii?Q?W1mGlA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: RAiBYr1lghiQ8iZq7HAj0j6aM3ADDGgC6pCWgKHuzZtn/0TDtdHYEe8rtE0rwK2R4FMuxsEs4/6HFDeWYU68v8EA708ovqK/7EsTpVp/1AlSK+8gXc5C8wSEsjL5myJvWE36XV7FyYvnISl6TNMb6GY+MUzZ/KdJHXe4YIjxWstXg2YmZpnWSLQZK5ggnwJjdbXy/YkVi6ocNnygjGtL+z4R45CKyaR37UHvYrl1F90TeaB8AiZZfgNmWmOIc6Z+anfEKcEPJHxh3pqeZzPMveg1rplwf/jFMIL+PJnGo3pnlEVLKDY7GF+jNeIwAPN6edhBCEphTRJoCkBy9Ok9a1TdOivy03oUD4jo4O/M5dORhT/9/ocMbvIuSUyof3d91k7KcWvSyigpLHbff9ZPkhp8MNrXJnpt/FVAkRyCZXv7SpCkkW4QbL1FMNSLWVEmBSlg3K+bnBFJ37Vik7FJ1W3AUsgpwsjnl+bPBKwcfkyKtUZ8cUReee8bOLPmkm8vQgcLtMT6z/mJ9TxmmuoBGo9LFSfLe/Cd7DzSDCmaYmmW4DXCcXrP95Mi8YfyB+/Yjg9xlmxGPeJVtXYqKXQtbkReavv5iQiBRpLshOaO936nwoysJ5lM1Siw3pRkjejex4sxk/PqhOWjFNQ6yUlt/dbjgB3FiRAnhJSTAGWZI93f/Zdg0tQB0+ly2FtsaRRrxiucAaxNB9W7fG8HPVMblmSoSypYFlp9jx8yr0EIDFLpNTl+08Fz7fVGApzAhKhSmEX4EUq5+RdaIld63G/pUQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cda34bb-f636-497c-c75c-08dad7fa1324
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 02:23:49.1350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: od1zY2VR9ti016mXatSE98T6PVhQpjhVP7au66ldHwATiiU9ytF8DpHtSVKVLMAhlYMPznKSoOSfZBM76vqOMRhAUydfMcwuGz2vqNvn6t8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6983
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_12,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=764 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212070014
X-Proofpoint-ORIG-GUID: vw_0nn_TnOellaMgnZiObpzlaLinS5j3
X-Proofpoint-GUID: vw_0nn_TnOellaMgnZiObpzlaLinS5j3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series adds a new fsuuid command and adapts xfs_admin to call xfs_io
when a filesystem is mounted. This is a precursor to enabling xfs_admin to
set the UUID of a mounted filesystem.

Comments and feedback appreciated!

Catherine

Catherine Hoang (2):
  xfs_io: add fsuuid command
  xfs_admin: get UUID of mounted filesystem

 db/xfs_admin.sh | 21 ++++++++++++++++++---
 io/Makefile     |  6 +++---
 io/fsuuid.c     | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c       |  1 +
 io/io.h         |  1 +
 5 files changed, 72 insertions(+), 6 deletions(-)
 create mode 100644 io/fsuuid.c

-- 
2.25.1

