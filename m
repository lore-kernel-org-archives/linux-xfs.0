Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED752C6FD1F
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Mar 2023 04:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjCNEVX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 00:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCNEVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 00:21:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9955D8A8
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 21:21:21 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32E3xtJh009795
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=p4RJvjwOta6i2ZH8blVM0nNFlNdMwqwHKzNPOHyhb4Y=;
 b=1XPqLs2tapvE/9zJF06QygDmebbKVICgUR1XWnxQmeYLc99rFbjHLgWPMcN7FzkxM4j5
 5gMI6ZeqAi2WfRJ78bcvz1Q05qLvRvz9oBoZfJkc7hZFXSE94IiTdXnTDwV7UvWc2aiQ
 DdWQFl80PMwm3LkANQNbCuUEhOQo3HgouR+jBw0xXBkaLcDy29HQ2gIh5iKyeuDC33tB
 +6enwo1ER0VizggbrnOmpQhI1psTOFECW9LLV9BbqAPIKCY3sUDuaCQu/2VBu6EKeXS1
 Xqit27KM7bPeeX67+kuz/yL4NifTr8skyJrynKsujJd26C2DqOQrtkDfgEHrwPjbfj/3 oQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8ge2wcw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32E43iIK008039
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:19 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g35hs49-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 04:21:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W46nvwUAAhBVgesSrts0/WbUxPGrMbt/evAcIO6N9KqtjlQmfoyhyKGyhirKMuzMXne+SZXtlLyb3JjA1F+A4Fykm5Z7mHcbVSKs5Pq386ausBno7LIUTzS9XMm+B22nJ/tVA3SWkIIpAW8WeJaVNhxkc4VX2BciHqe57Qv1zE7GqEeC0UZs6RMbbV9O4WhcOO6LfI59x/5NRIPMb3IIgDZms3oImrzNdHIvV9MVJiFEbfEKx0WZLjOqn9UWdT6CNlqr2Gx1pZ4DO6OddtdC76mA58s+iMO/x8SCojusGujh5Re0d/cwtLiyntBUWm4MqWbPOorsju9V+P/Av/OesQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p4RJvjwOta6i2ZH8blVM0nNFlNdMwqwHKzNPOHyhb4Y=;
 b=TauVUB+Z8uS5goFYp59hP0yp0+qkxF+Ygcwplcxxtsh0V0bAI+AV3RD5Oi3OOXr8ZN+ruFUhgFX7Kqs7tvwI03HkWrYPWRmaP/ShqfzZtw5sgBJDZILeIvptSZC0xbvZ4bG/KanPl3PSa8rwHvOF6EBZgVYwXnGtSfsYkd2PVQ8QatUe00ZamJwtVqQW2qmmJ7AdWgOgq2Jsz7xjC5hRWkk9JOZn3S3BEaIzxoHD496ZqbGiHqdXjf3k+0Eh6mKrzjvQPxzdoC/p6gbQMzXRNva2VGM7Bo/iQu6mTl/YXT2zdKKumRx3UiT+2c55LKCopkYNGeEw+/USjICL5XLxmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p4RJvjwOta6i2ZH8blVM0nNFlNdMwqwHKzNPOHyhb4Y=;
 b=p53D42yZdv12+90iZhcB9ynooqB8bviReempf0D5Rkuto31XnbU5F/nXkx+uR/FqyaBvDYfs3IeMK3Wse1IsSrx2PsZuRBCJ/+Jc1a0w8a/on53Mya+JrN9xrrNjAtaQrRQsW/rFy9ePffnhEvdziuaUQXUMDeBw20KPyCRni74=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by BY5PR10MB4371.namprd10.prod.outlook.com (2603:10b6:a03:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 04:21:16 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b647:355b:b589:60c]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::b647:355b:b589:60c%4]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 04:21:15 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 0/4] setting uuid of online filesystems
Date:   Mon, 13 Mar 2023 21:21:05 -0700
Message-Id: <20230314042109.82161-1-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0159.namprd03.prod.outlook.com
 (2603:10b6:a03:338::14) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|BY5PR10MB4371:EE_
X-MS-Office365-Filtering-Correlation-Id: f992639c-fa38-4130-deb6-08db24438d41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HqJoeiX2gSu32Vbw06HHArGro8fl1E4h1397/nJKWWo/KGbos0ZVqOoLq8J+IyelBhXdonzazVAMQBje5nMfvy0xTY8AVsrdMXgidkcPKB0EmSrU7t1QPxXhEun4ljBCT+HEE0oF9dUcG89HJW/LDTh03h/stzmasDOD16NXKLqujkbkpqHPg7+zyn0JcDN80df8SA3Hbgu4c+oSpg2aPwF7VRTfOYUxHYT1qC4YxcMREIV+8YsDsjuGovGSvl3wp6eu1iMehXgLy6kWhu/bLibfaWoiRBtA/x7A/+BWI0t2gDm9Ehbdn5tFQYtBhWOTXd6sQ6WwYmWnnD/FRMkx909vSDRq2JlUoVIRfrnCSAWbyljFPWo2ByR+Y4NU5leUcFtjQnfGD02JhUOwhpLnoCF1G+cfxCF1V4C2vyXkL+nW7M3KTY+0kkHajStIMh0/RijaF1nvXEnaxvFbRMA85FxXZxPKQz5biDHwIvGEupz1Whvdn9DogdacdeHX5nwmYw4OCbxTolWN+5EGJtYHRTZwzb43BPFjBBxOopwSxYgSXHLsn7VtE8KJdI3jcOUBD+foNc8b+FsUic9iI7Nb30ZjszeM0zciX/KCzX8+O2sdL0X0GXr+6DkRg4ftJajDFlPIggbRBOuT595xL4jBgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199018)(36756003)(86362001)(6916009)(41300700001)(6512007)(6506007)(1076003)(186003)(5660300002)(2616005)(8936002)(316002)(478600001)(6486002)(8676002)(66556008)(66476007)(66946007)(38100700002)(6666004)(2906002)(44832011)(4744005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8FERGtDtmQ5DXull1tZn1Vuae0p32+6EbhoqPemuFJLBs08wSQsUL8qM5f9D?=
 =?us-ascii?Q?q1RJuvpZg3dYcpx1GuJfwEl/VX9gZJoawRVzNrwoAMAm2lA4bkNcPkj93FV5?=
 =?us-ascii?Q?Z16OEv2LogISvj1afz2v3f/OGtc4ayPHsmDcee6VKHhUIpZFFdICG0Ymi3Jm?=
 =?us-ascii?Q?6D43yLkK6BZinTds5W7M5a5T9T5ks0KJUL+w88IfcmQoO6imoW6VHWfUCzbT?=
 =?us-ascii?Q?q+Yr8+0rzlPey0dwGO3XpGh2pEagc6leJo2rVk0X9UNrYBHPVv+xMmxNei7D?=
 =?us-ascii?Q?DRIO8bs0McdJhCtyR2UWtnbvzYnJltZu0bIFFwrZXkgdqc/PmBovjUh5U5zB?=
 =?us-ascii?Q?aimQ+EvguE/79mh0DojvLSMudrwS6DkpBa4AWVdGDHIS5xo5AXKwBf28PQfI?=
 =?us-ascii?Q?Cpy5zlnpueSJXOy/vdb9WDhJlmfumZo6K8Hvp1SpU/9WJpYtQaBg1xp0JLru?=
 =?us-ascii?Q?v0lGgyFzKUM/v9Xx+Xm5d+A8+joIE6VFDaT5VBPS897O2xURZ26tHnS9+iuY?=
 =?us-ascii?Q?kwQ83wB1zj1pwHB5oAsP5Mg2W7El8mSTvogvs9f9W8KYAseeazdqwe7fcjC7?=
 =?us-ascii?Q?2tUoDqG4N+EIn9WAYbvMTsFyxskuJw86B++lGP6rpy/uNgwaKyc2EGHd+5LE?=
 =?us-ascii?Q?QgTc+TDtTRtwY6XyXaiwgySvGGxb8d0HDtJ9qyf1+LhXP9UtTguDDZiTAGBq?=
 =?us-ascii?Q?tJ0gPiIkGvbigAI2CThzsUCmzWsuUfhCTm+2IP/L+M4IwtTUvyne4WdXojRs?=
 =?us-ascii?Q?zPvD7k1UU9A+WbhEEPQP/Z8+p5paF1f47ED9BBoJ9l7BRYhnZZJ7H4ro8Kxc?=
 =?us-ascii?Q?4kMwBb/15G15rrqSDVbDUz/hyALUHrLSeCstcm2mB+YpKkEeDo00Kyjpwcyb?=
 =?us-ascii?Q?iOLjRhfYnveRZx3AExcEGtW4kUmbXxMKXgHl6ZYZvyyYoCU01giP0j4TTHBZ?=
 =?us-ascii?Q?mlEGkxoX1ByDhODhPiDC9ioiad/rqat0lu3wsX3J6V07I+WsykyHcJOcHL0M?=
 =?us-ascii?Q?xuYBJs5JBx8lUZX7ob+Qeu1Y8GolZtWKa+b4ipCg/kxnpncsFsZZNaRJ73nP?=
 =?us-ascii?Q?A88sUfbBuXJStqTfvsxsivJ8MqIiyUGgskMDKuDeHA3KbGNEmJfSLqORZAwI?=
 =?us-ascii?Q?Snbb7RUAAGHL6Gy8rcxF144aXsWfip1TKZl1tBGVmz9nzQhoiI9tQRolmopV?=
 =?us-ascii?Q?vOvxsVeSPH8ioKJTuUG8eq4yQMsJvm0IEFO+ZoetwMfZ76OcSemBjV6ooH22?=
 =?us-ascii?Q?jCS04IPYxAWrvqyOzAy3qLbQdkVDgF4pjrkkwG8TsIRbv5SntcDT4UJ7XYnE?=
 =?us-ascii?Q?/IuO8cZW3ET1fpCBas6nFw6bRwDQWxzablTDGE8S12NW14jeGKymPnGpCIHO?=
 =?us-ascii?Q?5GBcUHyEbpSBd3OSpa/2453WcM/vcNKboDnphNG8WAFjCuxNG9MEsI2BjLd1?=
 =?us-ascii?Q?breIpYO7/CINs3ea85SCQlbDWClGTp7GavbnSeMPMa5Z2Q0N0kNLPN8DVzFu?=
 =?us-ascii?Q?Ip95n7mbXF/WqZFXW99IlAldm6x4Bfiaic4gNOaWOnf5l6sM/xw6q5C2fN7V?=
 =?us-ascii?Q?5GCmUkMhd+Na0Khg9jLtztb9e2xky8pyI/pywfi3Go0q0r1C7yry4aa+NeTD?=
 =?us-ascii?Q?fX0CMd0CudjxrA+fHQdzogf97ZPH0tXInRNWDa1xv0S8TJmnA1lOkEUJvjK7?=
 =?us-ascii?Q?rTlKXA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Z8jxrEuCVZScS5LWmErR7+1akmLDCQjKWyUS6yyM3livpcPxdP9IMDxoGZXVLcSMlpgs9HqHoXb2TqmalG3sOW5gg46igncaXPNEUtx+KeaE2X68wxZjhkZYsmbDyER6B2eZoC3nQ3Zjs8U5TR8xJY1HZgfDdbIgL7/QfJ/HFC1vA2Vu5V3xWkhHzHpt8J7a2QSYc9Q0BPG1hyct4sPs7x4c82t5LMy1ZK8mkfOMjR/NUN6bV6lKZfmvCYLbIdq2UnsOumRdjZXef4IzM42UlW5475xnp42GyUpoDSsBE5zqGWcVKa7gnrJqSJVUmEbU/4ttPBk3HpUb36GzkrtK9xTBW/yk71W78uE+uQyNU+pvftEjOEzCPmJyphuuN5LZv5ef5QdNEAJpLAs4nKFUn9mCWEpjMPOORkaMFu7gdKXmuzzAn1YCpMN+C9B31yPrQTPC4VudcViUzBTAWzz74mb6zVUvSkGUikA22hMhnMWPZSSZUMWhY6cqPnc75WXS3LLA4k0LooB7djl3wQZ2M7KuTY4GHM1NFMBkHLMt/vZlyuJ+8qI0MKEXj/6Axklgvp8PUJpQt1cZVg32ciLrdqFy3rgVa4pfFQyl3FsuGdBRBn9LC9W5mGDLx+M+nopExtUvHC/qQN2gsOqX2J7xl5T/1QY3frbzMV5OZl5zy+qJMne60SAqhiwwH3PYKHb4OCoClsMvjQoAbpbDII2nRs/SqQxsYDEhYihGE2bJfmmaqUpJlBQwKr2ykr1tOlDIaCU23fyGJG2YSEIAvEinfg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f992639c-fa38-4130-deb6-08db24438d41
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 04:21:15.5307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zm2DGkRxYNzXFQekaLoX4uscaCNbCrls5qmNyndTEq5W13KDj7ONwao+O7I8L4v5C9jyhoqIkWM//J68RBCgcCT1XJOdGxhUT6Wp+xs7k14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4371
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_13,2023-03-13_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=488 phishscore=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140037
X-Proofpoint-GUID: KFMv0a1oiZuQ9lc9b_an_WEJdunfwiTC
X-Proofpoint-ORIG-GUID: KFMv0a1oiZuQ9lc9b_an_WEJdunfwiTC
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series of patches implements a new ioctl to set the uuid of mounted
filesystems. Eventually this will be used by the 'xfs_io fsuuid' command
to allow userspace to update the uuid.

Comments and feedback appreciated!

Catherine

Catherine Hoang (4):
  xfs: refactor xfs_uuid_mount and xfs_uuid_unmount
  xfs: implement custom freeze/thaw functions
  xfs: add XFS_IOC_SETFSUUID ioctl
  xfs: export meta uuid via xfs_fsop_geom

 fs/xfs/libxfs/xfs_fs.h |   4 +-
 fs/xfs/libxfs/xfs_sb.c |   5 ++
 fs/xfs/xfs_ioctl.c     | 107 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log.c       |  19 +++++++
 fs/xfs/xfs_log.h       |   2 +
 fs/xfs/xfs_mount.c     |  30 +++++++++--
 fs/xfs/xfs_mount.h     |   2 +
 fs/xfs/xfs_super.c     | 112 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_super.h     |   5 ++
 9 files changed, 280 insertions(+), 6 deletions(-)

-- 
2.34.1

