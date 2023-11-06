Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91760C4167D
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 13:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbjKFNLV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbjKFNLU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 08:11:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE62EBD
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 05:11:17 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Cx7Fb030873;
        Mon, 6 Nov 2023 13:11:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=xJNWOdDBQ1R8weOhpleTMMCdsFLjcchXMCndcZOulLQ=;
 b=gNBeaOdsaE3XFuFmMqdR87a7lk/qcgNWNeB007E4KFoBO21j6O+jOmFw1vbkU86ZJF3r
 McRFWJPdwVGjBWtRhPr+fZ2svbz3IhW0IuF6DR7FIcvJB7GIUuUU3eal6UOjey+k+zV4
 tDplAY7t3G2ZAgoD17NjDkxH+DnckPnq4ByDwv6so5cvieDRodq5Abl1tBdMiFWf1IfW
 6tCRUDxny6DZZp9TAlnjLPeA3+cBi8iHGupSXC07y7AvvMkMZecp2FEGq8GTLL/RkEKB
 qBKWw2W46vbcfxxWOLPeW46vpmXx0Fy1NLbn6Tak1j3ajkXGM2WV6JQFzpajmy+kQ/FG FA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u679thnwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6ChYW2020688;
        Mon, 6 Nov 2023 13:11:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cdba93u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Nov 2023 13:11:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZY1VAlL1Ic5A3LjASW0wUNi7hd6SfI/Mj12k3HkaA8B3colt4jkefeJ4JrJSxJgnsfW8rUAM0g/P9DjLqf4X8XeXJNIzNHLnxWL1FYHwPBXW7IZ0TmVSvBaZsM2r60TOrFxVPaBBQEtRRd2YV08jmpmOfTyhl/UKwBduLslcpFwinXdCKs+3Heyg8boqW1VtpMwAWw4AHlDtqsMoVX+ZyWHrjranzy2h3SmDk31IKsoi0UQ4GKodSAs74kJRJraUjWqbPI5TPFaPBBewVpkhs+0IjRit1RAzw9DQPPxBPCjDbfJWi7ZuoQXxI4aNWb1pgKioGR7PJytzaJji+/SUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xJNWOdDBQ1R8weOhpleTMMCdsFLjcchXMCndcZOulLQ=;
 b=maaEB0ZSSnVZb3+FaTaV+QWTqA0K9m6S3kp+9pKlgZZ3ICfdRCb33bYKD0EQE8FMnoNcG+9/dtmGXJe3TBf1s2o+sGGp0y754tw1rBeQTW9G6oi/EdpT56fWJ17sP1eFq0yjafAVcrdLJCAsq01jvOjXyCZ/OfXySmWxzkMYTrEp6yg09wFoTChH1cLa87RU32FZfgdDMf13pxoXyiIf06HrBg6rf8oPxKeKunKMUmIKHcNxKi6pihOkklwgAqB9+XumnzsXt0dsTcyRULlyjplGKKRqq/g9YygpqxpoK1+bLCIBsgzRKiQcT3JTehc05ZPFX/el3KqD01L5ndwwHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJNWOdDBQ1R8weOhpleTMMCdsFLjcchXMCndcZOulLQ=;
 b=UtwWyv+FTQfZJPG3LkEQeQxd9sEyO+Kyaa2ZHYFLdbCjuGLZgEuIjPXifgFei/0wkRp8NEOm0pzYRFx2jmchOuUJqUITSEgXcuhK8r87HImQhfs8WSmCeKuLO4OjgNuTL4UBfiT5rbALiA3l3rDrRbaAkWO5sa2zJ7O5UD0RzIk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:233::19)
 by MW4PR10MB6534.namprd10.prod.outlook.com (2603:10b6:303:224::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 6 Nov
 2023 13:11:11 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::9bf4:a5ad:d9cd:f62d%3]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 13:11:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, djwong@kernel.org,
        cem@kernel.org
Subject: [PATCH V4 00/21] Metadump v2
Date:   Mon,  6 Nov 2023 18:40:33 +0530
Message-Id: <20231106131054.143419-1-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0081.apcprd02.prod.outlook.com
 (2603:1096:4:90::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:233::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: c3448bef-d884-4441-efbc-08dbdec9d8cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pgqmTFtKsspHhv5hpn0qGRrLPg3gDaUWlucwNMVk/WmuQNfN1nHNnyu9sx+48NZZDWpZAUWP1qXsPiWk0wsWbkHRz8Ilr3YTSeqhOigAi8/JSaqRL7xpGSw4NPelMEU+pdpNB6SEieUOnAVWWQqDrKVvYqzyjoZ8X+B3+TraQS9QQIugzKSK0h0qq1S0NVQN5Lx0wtz72sAH+Fa8Kws2JgApl+rQ9SoY4ucqUCdW34VY59C3Z+Ev7/bGsmlqNGRULe2+0AMuvB67GkbFewxP8Aa1Dg4v8aG3CVTV15nG02OFHaclrgdeIXGrbom2c/pJcd6faMBHrfoXTbAum1oHY889Y7gx2HZI9qrxF2kXxaPj1a4v9D/quLMSOlAglNGflx3i7NzjVtjMYbBNQNlwLCnDbeYht5/BHwrU60IwwF35sc/FnLT1DiFEVCMjX4+6MAR4elPDjnNsFjfo1kMKaPTUfhbO9bX1IESF4B6bpGUSnRJWoK8hA9KTS9iI/6by0i9Fa2ElSyahBXFigkoXI9OIz+s8xnC+VsDR3xVC5F36uLI59EkU5+fsd+mFCV34BS5iQpz02AWWMn7CwDWBbcGTDUQnc3BoNXwsAFEPGrz/UZF+o3TrL9WkEfkVMLoFH+NgCgJqqj3fSJlQKYyRfawjqNXspSnuYw8yTNV9jDA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(346002)(39860400002)(376002)(366004)(230173577357003)(230273577357003)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(2616005)(6512007)(1076003)(26005)(478600001)(6486002)(966005)(5660300002)(8936002)(36756003)(4326008)(8676002)(41300700001)(86362001)(2906002)(66556008)(66476007)(6916009)(66946007)(316002)(6666004)(6506007)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rh4zQrF8S2g5JvNlQgRYSBZHEYi8mpJck1uygmQeHItIjfgtsjsnCWMc4Y89?=
 =?us-ascii?Q?fwrWpJ/mym7DuXi+nHGTJnuO8bM7xCseOzloOCvdPkmIZt5qjZqXKzaaccbO?=
 =?us-ascii?Q?B256XP7FzzXGhM1S5JIu21qTnIuAfZ4g5wVQUzTUlFb4hMi2yxsC+mCfuXic?=
 =?us-ascii?Q?ybCTImHSMJQ/zNbc1EaUnD7GI85hhJcTBoAh1wzCIrOvHNeXepMNFMJAiLMH?=
 =?us-ascii?Q?E0NRJpxVJZR3CTOZQbqFHPWSysq3lVgskpi+V+VEkGA9AmCY30SM2r/t2KuD?=
 =?us-ascii?Q?bL9cFp2fAlRkO64c2hSgv8fD3AFg74LfzBqPgAWoV5Hwzeatmu4mTqpETurf?=
 =?us-ascii?Q?hPmPhOPrdq3CeJs37lqwReymvU55bUUl3aFddAeGnUhc4//bTlRlwsRJevCL?=
 =?us-ascii?Q?nKYzIdwIqFoyEZAG+rEKw+IgyLlQmhsgoJ/2sjYW8YxyOBw3NJCrvrxnqdUA?=
 =?us-ascii?Q?LDfZenqZa3FuEz3hZmCiCAQrrPYInYp90/OiC0bA32ikAx4IH5Nb6WhPzawA?=
 =?us-ascii?Q?LxvomkhpMx23EQKDoacyGI8NmH6nh9FTYgE/bEv/ILaQJsEeVbRxeCr13ZLO?=
 =?us-ascii?Q?42GrSkK/QEy05Y2yMp/MBdoDfB56WoG6ZzNfMY7JEBMC7nGlNGFiCIDXuGOm?=
 =?us-ascii?Q?k2v3JB/HxQ8Un27oakDxplxXbGdcLxzai/Stmu9/Ic7B5WUoDTjp51u9iBfj?=
 =?us-ascii?Q?YbUgwnxpdpQaxR5obwtEJQyVXOkZ8Ftqjlnh0/AkOaOikIRAU9pt7Tdm2psz?=
 =?us-ascii?Q?5QKIA3nt1X0OoYgQ30Ik1YQV/jaan6VnPh2/adc7c4VUQyILm/orSCDGB0QB?=
 =?us-ascii?Q?UB0gvAIOI8LmKusc+zbDq0xYOLFx4k6vPSAFpK/hhgGbkZyceSA0a1OJmHs0?=
 =?us-ascii?Q?ipUJrEXASpqGKHpLHjy+ZOL0xDDdCF+zHg+rW6xXQsNawclxMW+avdK2q/CP?=
 =?us-ascii?Q?qOjNFbsTlbt3wzYhtcmg4GUZbj8TgbMp+52mj9wV1SNyXuznuBaa/q5y192l?=
 =?us-ascii?Q?uJYkiH4uXwxim9LwfbBRzVxPx+5Bd99+Gv2HUW818sfEPv/w2ugYomquZOKv?=
 =?us-ascii?Q?OkbGa5WBwMGTyt/oxM3xDwWsIzoU2ek5cyOR2GGXkRQ6qZ2pGW0BE3rqrQiq?=
 =?us-ascii?Q?ixfVEroIaR7WaT2BUpToPJzx0RRmtRryYg6Rml3UHdj1l5ztW0oUdxKPa5oY?=
 =?us-ascii?Q?3G2fjwMFq3HosthnGAezWhntI35kE9qlf/txeQpRiTYIIPa8mcDApEoWaEdU?=
 =?us-ascii?Q?eGGwoJ8uOk2ydHnFpwu9P6u6QcDCkBxkGQfLL13EeKWIOdhduxWzm1KLsmP5?=
 =?us-ascii?Q?WzvmjcjNolbxWIB70wB6SJLhXbC9CJNzI/4DlODlOOrMMuwQcQxpFLLszNXA?=
 =?us-ascii?Q?J83CaORqG+ForAda5OSYB2l4Jwo2GX5AOoLAbxqj3YstxpNBNXjsrxfGDNHA?=
 =?us-ascii?Q?pfV42sAns6quBfAl3l9VbvsB5GAWovaTspYrpArFJqrpsahSupOMkPGT2IG6?=
 =?us-ascii?Q?6A0fuceqvW/vIbV27SbTbzGTw/BBW1zy30TKDO0d8qLHMcxnQGJQ5mtpCgTn?=
 =?us-ascii?Q?cTGeWx4zceHz3PjIwpX70OYXOc+b+Xlp8Lvdv7Yn?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Zb5KNELbOJjIISvblsr9blw227c2Mo+I2fkUkVHLY45trn0SnWwHHjnVCsJq+SP6S5VG0K9u0DutV6zN3RkcP5OFUhUCFlL0Z10Yg3sBnuOR4uW9UIKn/pOScWCwtNOlYvcFUAWdzOexXHiNwtXi3Vx3qhYGmh1ucZGRxx8ZWfsnW+lLFEOKpjupB30JWXcvTExWAXy9TvlqOxaB1bMQKsHudXldXgqFjP84303RGYJZSYUvRc0sgkKDhJlr0JjbIStauOEwxln1i9GDfVZnwujKaFLFiz4Pw8te5Jw1Io7hY8kUOMN/O5NSaViJUBDnHqKkCSKGfgON688XcpaKq+qhquQEoskcZPYbBt77iXyuDwdaXKSccbLqHc3tjI7iJGaF9yEt+5PzJCzlNQ8cEjYXWqlKIezpqAtzRGZryggpXHfpU+rgn6ga91M7Cv1KIC/APITPWC12nTMoNNLIbCVKlGtrCoWto9/PqeB+9h8zTUlK8MBehErJZEfdyiEwJro5O7BnQaoERNf66xhH6WtAS4GTLWmurfCwdzXm7HOMDj5RmVrlRRxm2P4sMjU94hjbtdEB8BJoyCZS8LIPbw1ULPuJ0ee1VhLy1kwvauivRTdcZ+Fw8Q/sD1p6Fok0k1JIxcbWmfgbFkC9sqtF/fp+peXy+m5B1dWXzXQHi33lhCG9t3rIcA84s6JQa1p1Ko34H/UwZGFGT97mQXecRjQG0WSCLwyagUDYB3sfkkYBOIbHzgOmAHPNYBh/uges2lQs7SBFOWW7vIXTOFtq+MwMfD9eDJVfM+gTb2EHjw4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3448bef-d884-4441-efbc-08dbdec9d8cd
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 13:11:11.3622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kyNPDR5CRT57SrFggR0khTyIwOCryfaKm+cJQsGoGQbR4WhaHqaKD951kft6l5oUrGMKoMHCUs24b9bHNEBDZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6534
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060106
X-Proofpoint-ORIG-GUID: aYesF9pcXZnbjXsH6xB3-V1PGcz5YFph
X-Proofpoint-GUID: aYesF9pcXZnbjXsH6xB3-V1PGcz5YFph
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch series extends metadump/mdrestore tools to be able to dump
and restore contents of an external log device. It also adds the
ability to copy larger blocks (e.g. 4096 bytes instead of 512 bytes)
into the metadump file. These objectives are accomplished by
introducing a new metadump file format.

I have tested the patchset by extending metadump/mdrestore tests in
fstests to cover the newly introduced metadump v2 format. The tests
can be found at
https://github.com/chandanr/xfstests/commits/metadump-v2.

The patch series can also be obtained from
https://github.com/chandanr/xfsprogs-dev/commits/metadump-v2.

Darrick, The patch "mdrestore: Replace metadump header pointer
argument with a union pointer" is the only one that still needs to be
reviewed.

Changelog:
V3 -> V4:
  1. Rename XFS_MD2_INCOMPAT_* flags to XFS_MD2_COMPAT_*.
  2. Verify xmh_incompat_flags and xmh_reserved fields after reading
     the metadump header from disk.
  3. Fix coding style problems.

V2 -> V3:
  1. Document the meanings of metadump v2's ondisk flags.
  2. Rename metadump_ops->end_write() to metadump_ops->finish_dump().
  3. Pass a pointer to the newly introduced "union mdrestore_headers"
     to callbacks in "struct mdrestore_ops" instead of a pointer to
     "void".
  4. Use set_log_cur() only when metadump has to be read from an
     external log device.
  5. Verify that primary superblock read from metadump file was indeed
     read from the data device.
  6. Fix indentation issues.

V1 -> V2:
  1. Introduce the new incompat flag XFS_MD2_INCOMPAT_EXTERNALLOG to
     indicate that the metadump file contains data obtained from an
     external log.
  2. Interpret bits 54 and 55 of xfs_meta_extent.xme_addr as a counter
     such that 00 maps to the data device and 01 maps to the log
     device.
  3. Define the new function set_log_cur() to read from
     internal/external log device. This allows us to continue using
     TYP_LOG to read from both internal and external log.
  4. In order to support reading metadump from a pipe, mdrestore now
     reads the first four bytes of the header to determine the
     metadump version rather than reading the entire header in a
     single call to fread().
  5. Add an ASCII diagram to describe metadump v2's ondisk layout in
     xfs_metadump.h.
  6. Update metadump's man page to indicate that metadump in v2 format
     is generated by default if the filesystem has an external log and
     the metadump version to use is not explicitly mentioned on the
     command line.
  7. Remove '_metadump' suffix from function pointer names in "struct
     metadump_ops".
  8. Use xfs_daddr_t type for declaring variables containing disk
     offset value.
  9. Use bool type rather than int for variables holding a boolean
     value.
  11. Remove unnecessary whitespace.

Chandan Babu R (21):
  metadump: Use boolean values true/false instead of 1/0
  mdrestore: Fix logic used to check if target device is large enough
  metadump: Declare boolean variables with bool type
  metadump: Define and use struct metadump
  metadump: Add initialization and release functions
  metadump: Postpone invocation of init_metadump()
  metadump: Introduce struct metadump_ops
  metadump: Introduce metadump v1 operations
  metadump: Rename XFS_MD_MAGIC to XFS_MD_MAGIC_V1
  metadump: Define metadump v2 ondisk format structures and macros
  metadump: Define metadump ops for v2 format
  xfs_db: Add support to read from external log device
  mdrestore: Declare boolean variables with bool type
  mdrestore: Define and use struct mdrestore
  mdrestore: Detect metadump v1 magic before reading the header
  mdrestore: Add open_device(), read_header() and show_info() functions
  mdrestore: Replace metadump header pointer argument with a union
    pointer
  mdrestore: Introduce mdrestore v1 operations
  mdrestore: Extract target device size verification into a function
  mdrestore: Define mdrestore ops for v2 format
  mdrestore: Add support for passing log device as an argument

 db/io.c                   |  56 ++-
 db/io.h                   |   2 +
 db/metadump.c             | 777 ++++++++++++++++++++++++--------------
 db/xfs_metadump.sh        |   3 +-
 include/xfs_metadump.h    |  70 +++-
 man/man8/xfs_mdrestore.8  |   8 +
 man/man8/xfs_metadump.8   |  14 +
 mdrestore/xfs_mdrestore.c | 503 ++++++++++++++++++------
 8 files changed, 1020 insertions(+), 413 deletions(-)

-- 
2.39.1

