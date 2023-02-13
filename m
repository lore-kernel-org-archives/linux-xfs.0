Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7190BC636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBMEIb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBMEIa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:08:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E692AE044
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:08:28 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1hws4013421;
        Mon, 13 Feb 2023 04:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=QXHChvJf6S1B1vkjlfBdI3n4LIWXm9pb4OEYHiw0koQ=;
 b=v4FaVZiJLkKo/CYZILpNCHcIA4WVv62IUOjYk7uvNU7NdrLAd//QmXxYT3COwPGHBveP
 Viea30ZonYQRhkUk6Md6owQAeB+D/+gkgod1BmhQyuWE2vhKjgCngJ6gwBxioWqe/Z1X
 Lb4kUIfBBqHEeCtYbu8QoQ7lAOHBRUVyzizXDH2l/v4cYlci5VqH/Xx7yilRyoBdGU63
 902+yK6Gs/1SayoZxBM4hKTwUIwvhLkYNSWCAbffKSTy8sFq5ex6E3BW3X0T1rGF2i49
 DGqBSPeKGnQVckauUW39Uz1uDtOiwpZos0KARDM+Qw+yfi9xfXIYyVb21EKSawoyOd++ xA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np32c9uku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:08:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D3SK36028770;
        Mon, 13 Feb 2023 04:08:25 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3jyt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmeX71f7MfsCWGQgYnRs47TTxNt6eDIJ6MbDUUgzzNXrWsWtFhwSBu9OKvWEX5Rdwo1EiTLov6TVeUdEyuNQYXuhJtcfRiCFsRuEjph8jHbVorxTDb9Ned86z6Qpl8E2+szvlewo773rWLhWkg1+Rd13y2saQWXlB0OsdUj6T8gkE16D1MWugdr+55UyxUpMIkQqcoOfcNAUrDYuMGUQaBZtngZGpqlpv/8f1ZpmvMrvmsghQFqfkcSGJ0+Uj3ETFsOc3Vr+s4JMmHgQnbue2SECOTeNYIlkjSWFafTMaKyBgQBgOKT+cVvqjTsgE+7Xhdj69tOyhVMuwDrE6TS9fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXHChvJf6S1B1vkjlfBdI3n4LIWXm9pb4OEYHiw0koQ=;
 b=UuR4vGzLHkx/cBJQCnp9KtqnMVd19rbDdo6v5e/JR5Za81VfMpteNhy8l283rZFs+LcLOjZT20HWkcSjqh/k15Y7qGWa8zk/oV7kLHeD7UxskmY+3qpPjeOCY6b0uGHMCudfinz1Iclr73Z+HwamJYqaCWRZGjqd5apOmFAAn1kPUcXo+X1BVfaI17pYsv9kjL7+PlvwL8vS40j/48xHVydPntyvn2PqG67ahxkz3D56dqRWBkaFuNWYI2MJFWGUIZ+0BtDI5EE+6Pjzkt+hYQSf9bni8B1vZfbz77doXsuUSX72LJIAa01GN/G10UIIHD25k/RRPnCuKZFVy+/nyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXHChvJf6S1B1vkjlfBdI3n4LIWXm9pb4OEYHiw0koQ=;
 b=zhauJ6hORecFT61JQ9DDaTD5YaIoY21OO39Di2+qDQITp2rv+XfqAREIWuGTLz7TsC4AyE/Uz7s8AA0a/i+veF4cGaF78oKcqMarpEAV04OjV1XSCfr/DMScr5PAi2J57Pb4FEWXZVPLFXRqm6SK58cB3soccDcaMCqWHAIAKLk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BL3PR10MB6089.namprd10.prod.outlook.com (2603:10b6:208:3b5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Mon, 13 Feb
 2023 04:08:17 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:08:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 24/25] xfs: prevent UAF in xfs_log_item_in_current_chkpt
Date:   Mon, 13 Feb 2023 09:34:44 +0530
Message-Id: <20230213040445.192946-25-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0028.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:262::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BL3PR10MB6089:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b4949e2-42cd-4bab-6441-08db0d77efaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OORa2cKYPlTvjeyPnntCfayDqzhQ7iJc32zZiLXQUwQBewk/H+gzjlE2/AkPGlVIcJC2GlUDI1/YbYTHiDiRepoGW7KXWsJGiNJ2i77brukAUGaibYnddYuZLdfo6ZFJXludSc7RZcfgZLQJM/t7W4/n00JkYsNZDMdWLGvsqaPKlp58FPqKrPDyQnCuMLcPt8kb+TNuIkvOvn0MJxRVKHEhY7m7B0jiJBTtNcN3Bt0jkOmpFOo1H3mvu2WlBrsHgtU6EeOZ8ocwGWQjnlm92r7yVaANW2q6bs3THRzeBsdWJTpJRcRZ0DNdzxF8uJAdYg4R1GZpHPsAjHQ8By8qVfY3IJbK+PhBrLysO5h1yFatjHNbwaxXuXCBMC5EjDSBK17y2BQJ70thx7echqvV7w+0UKlSwhHYTDGynt8WvQSjFE88AVzYe4rSsvX7MqiYxnkySVB4U1JH0cZaAwkgnC5+nz+WsyPVKsN9vv+stsoLqG24/BIVVGR1OqanG/xjBY8I9lRuGhwsEQQSznVrmJQJmGJrVJ6MBawzrW8Z7+oEKulSs+cS2xUzCkSTYKpD6eUth0CbzjGBMkar+AjSVgHvUAQfdTvLOHATXlyC6tUNZQy2HUsg09+02NfPCXllpTCLJExcZTbtkZOglZsgag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199018)(86362001)(36756003)(38100700002)(316002)(8676002)(4326008)(8936002)(66476007)(5660300002)(41300700001)(66946007)(6916009)(66556008)(2906002)(2616005)(83380400001)(478600001)(6486002)(186003)(26005)(6666004)(6506007)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ggb21CSR5/jiDqA9xS02cjhf0WUFhDRr2750+KpDJH4XfQss2Qia7/M/2odd?=
 =?us-ascii?Q?zQKz88pbRjimwQQfRdnnAq5T7yaiXV8yZ1S9aS7CHMzaYSmsJ3wYdwYt39z7?=
 =?us-ascii?Q?yQjcKG10y/+M6xEGwN1njcXqX6ZbsZgUsCYDD/DbdQTWHtR4IsLB8nYLF6XW?=
 =?us-ascii?Q?S8oBTZ44LPM60ICglHTAcYpRfOfmhRh9Wi2TMRDhcEHtCYXU049us9oKRaK6?=
 =?us-ascii?Q?Sg+2rq0NoI4/gvpTP5pmjHp76lnx3C8ELWehISML1t9PCEi9wtyBQ+mdZ5+w?=
 =?us-ascii?Q?EzhM4oiTCT6PoCVAPSHIFHp7Jj7m6YM94jR/A8JR4YD3/5LZe1V0G++EJIQc?=
 =?us-ascii?Q?1XlA97gBpbFRq6G3FqolZzx/shm0I4kwT7QbQsQCe1aP59U12v7DVoe/MO7d?=
 =?us-ascii?Q?MIPoP3nbbDWJ26alsChkTtJIFVV0oL03C9qTeKDu7/Wrsbr9/WqGLjYVfkAx?=
 =?us-ascii?Q?JdL/bP4Aw0U9md+vdfApQZOATAobxtMn2ArPKJTsJCOZNYjDJ1Wwdq9xgHge?=
 =?us-ascii?Q?1vBLzRNb6DtUSNGX5UFioeW4mBgkYM5lY2xoyPjcJigbJzaTNJPB0s5IzmBn?=
 =?us-ascii?Q?SsjmybwQ9D3YmaUAXNZSjjsanSA9mVWeecyW9+oUYaNpFJWNWySN64vJEzGK?=
 =?us-ascii?Q?4SFpJjfeAZpjsKKGbtU5gt9/5IWkkTX9en6fMhI7jE1acFrPEdzx2pHfEKFA?=
 =?us-ascii?Q?UudM93MF7ZSTEweGXdc8koLLYQ/nZR1bFdmOY76utKBfwcwhkr3VGrsD8LQg?=
 =?us-ascii?Q?x4RDCgTBEkxeS/hPRdJkmix3gLlXQo26mEdgmoZllQ9PcoLdDXYC4I1UeBG1?=
 =?us-ascii?Q?wyagTh2n8xEz+ltSBq1ATE/JkZKHhfMqi7+A3KK0CaqfeTQoSv/IYk4Bg9al?=
 =?us-ascii?Q?OESJ/fgSjjbAROgXTjTgE2h/IyCbQuFckZzJmigkvr/1XbsAlP5hGWhOMrG+?=
 =?us-ascii?Q?yd01EKNWT1LTrD+n9htRLCAz/wk3dH2HhCu/jRUxKmjza+ij7pYqF2KwfwsE?=
 =?us-ascii?Q?AgNhaO2/y4I18lzu+8onoA0R3q9PeLDPRdPNzWn/6xji4GG4mHfRAVQFA+dy?=
 =?us-ascii?Q?d3C1YRPCmm+tp8m4Rz2yhK4c+0rGQMoN1+keM0ui435j0G+uarHf+sW8vuZq?=
 =?us-ascii?Q?gJDdKWekEacg6ac6/UUMXXs8Kr+3AbdcfcW8ICuwuqlsm7jO3U+ac/hVe6dr?=
 =?us-ascii?Q?fYwEc6h3T1Ix5+uTaa2Gr2Etj1y5KNH36PJd4UotvaOz/nvPtMDshxkmc41e?=
 =?us-ascii?Q?p+XpIjYcTiUqzB7avNdmhvz6WAfCCLQbM6v+UYuU3TPlOiBpXFMlobbt4Tdh?=
 =?us-ascii?Q?esaKSCKK2fh096x80ySdtBh1IaDWfCrzL0E+S6jATKda2HdKxBEGS2rsviIm?=
 =?us-ascii?Q?Y5qaKCS056uBpGB0Q7l7ZSZ4AnY2k7EnM8g+nDwAO8gwDxRZVmjtRvNW/8jH?=
 =?us-ascii?Q?RCHvzGJeaf6pnkQwuUowA7nPlImANBg21CFsUO/UGE4ciZH0P5LG5gBBCTJz?=
 =?us-ascii?Q?FIkM+pY6K21pR0vdpEa+eNBeAnBGsXcx9Wb3TbioZWh5DGmn0MJ9lnTC9D9W?=
 =?us-ascii?Q?7dlQHSzhB0ArKF13GNqVWoYlBbsrLvHSn9pksBPrDf9nhEcbRYmmBnbOmiIB?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Q56F2q9H3HHdZKNzwrNHy98fB5/s7KyKXxIebFR23UfLgDyqGXWqTsKakEYQ8C/FpQSZBnCGozvvxsxfkb87jyAV0aZJuGJSH2osPItpyzzOcoTJHnJ8iJhKmhWuwjcyGNiXNK8n1RcpUoTqC43bov6uIloXNsUGZorBNdabQJXVEzcvMcHOlizMXwg1LkOnAVd/UV96xqek0xOvU8xFhLNXP0BHhTGCwTOBmW2aBe8JpEjK+r68DWqAvWdUaNRV0wxuKmJ+a7YvhnXuLvEiLdWRqpkp33Y+y1KslD/XePepHGQiQ9q0Njq0mNEjRdzI4FlIw7MO9KAB4ihPO/qgZ9UHDszugAVRkXMtGEpRKD0A5xRqdTzzrf86/z1GklSQ3KD+hllnhfWI+sfOCN/iJsWkjHbxVHhG5X0zvBChW4Z4UXaD14T8H3qSdNygcqtiAT27550vEWWZdkNXojTpllP3pBo19Gl3hFTr2fjanMflN/OilN6/7/ARN8WuPqhJtCyZMN1eqigjsQZ+1IvjW6HJx1FdEZFnpqt+iz10+v90XWHxi5/vIyUZcnLkWmf0ANp6CK3wLCGK095845a6Mh5+7ErJBpT9l9ZcUf/TwavBo5psMp2BRvPsZwYnMxWgDSsmyQcngtbPZnw40Pra7i5AaFL3DE8vCGI1l2FjSOGkgZRFC1dfePVgorz2Iwd5M46KWJ5vFJPAg+FdHo9uNCXe4j8DRrQGciyzKvkjd6GWSFQArV7tlrdatpMPAN3Upolmy0c7DHtoI8LP0TBxk9WjMeKLk+fxYGSwbKgwT4XkVUkcuAPx2SV4N+IRhyxI
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b4949e2-42cd-4bab-6441-08db0d77efaa
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:08:17.8434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VwPjLjhf38sYPpVYMXcSOYmhKDzDhb8WoaX6MS8N1WejHGZKBeK3zYuRcknleKqTdTwWeqMKatTVx82SJN6IPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6089
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_01,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302130037
X-Proofpoint-GUID: U9Wm_PoEoOcLfBFqGiYi9xJ1JQWZxRL8
X-Proofpoint-ORIG-GUID: U9Wm_PoEoOcLfBFqGiYi9xJ1JQWZxRL8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit f8d92a66e810acbef6ddbc0bd0cbd9b117ce8acd upstream.

[ Continue to interpret xfs_log_item->li_seq as an LSN rather than a CIL sequence
  number.]

While I was running with KASAN and lockdep enabled, I stumbled upon an
KASAN report about a UAF to a freed CIL checkpoint.  Looking at the
comment for xfs_log_item_in_current_chkpt, it seems pretty obvious to me
that the original patch to xfs_defer_finish_noroll should have done
something to lock the CIL to prevent it from switching the CIL contexts
while the predicate runs.

For upper level code that needs to know if a given log item is new
enough not to need relogging, add a new wrapper that takes the CIL
context lock long enough to sample the current CIL context.  This is
kind of racy in that the CIL can switch the contexts immediately after
sampling, but that's ok because the consequence is that the defer ops
code is a little slow to relog items.

 ==================================================================
 BUG: KASAN: use-after-free in xfs_log_item_in_current_chkpt+0x139/0x160 [xfs]
 Read of size 8 at addr ffff88804ea5f608 by task fsstress/527999

 CPU: 1 PID: 527999 Comm: fsstress Tainted: G      D      5.16.0-rc4-xfsx #rc4
 Call Trace:
  <TASK>
  dump_stack_lvl+0x45/0x59
  print_address_description.constprop.0+0x1f/0x140
  kasan_report.cold+0x83/0xdf
  xfs_log_item_in_current_chkpt+0x139/0x160
  xfs_defer_finish_noroll+0x3bb/0x1e30
  __xfs_trans_commit+0x6c8/0xcf0
  xfs_reflink_remap_extent+0x66f/0x10e0
  xfs_reflink_remap_blocks+0x2dd/0xa90
  xfs_file_remap_range+0x27b/0xc30
  vfs_dedupe_file_range_one+0x368/0x420
  vfs_dedupe_file_range+0x37c/0x5d0
  do_vfs_ioctl+0x308/0x1260
  __x64_sys_ioctl+0xa1/0x170
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f2c71a2950b
 Code: 0f 1e fa 48 8b 05 85 39 0d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff
ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 55 39 0d 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffe8c0e03c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 00005600862a8740 RCX: 00007f2c71a2950b
 RDX: 00005600862a7be0 RSI: 00000000c0189436 RDI: 0000000000000004
 RBP: 000000000000000b R08: 0000000000000027 R09: 0000000000000003
 R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000005a
 R13: 00005600862804a8 R14: 0000000000016000 R15: 00005600862a8a20
  </TASK>

 Allocated by task 464064:
  kasan_save_stack+0x1e/0x50
  __kasan_kmalloc+0x81/0xa0
  kmem_alloc+0xcd/0x2c0 [xfs]
  xlog_cil_ctx_alloc+0x17/0x1e0 [xfs]
  xlog_cil_push_work+0x141/0x13d0 [xfs]
  process_one_work+0x7f6/0x1380
  worker_thread+0x59d/0x1040
  kthread+0x3b0/0x490
  ret_from_fork+0x1f/0x30

 Freed by task 51:
  kasan_save_stack+0x1e/0x50
  kasan_set_track+0x21/0x30
  kasan_set_free_info+0x20/0x30
  __kasan_slab_free+0xed/0x130
  slab_free_freelist_hook+0x7f/0x160
  kfree+0xde/0x340
  xlog_cil_committed+0xbfd/0xfe0 [xfs]
  xlog_cil_process_committed+0x103/0x1c0 [xfs]
  xlog_state_do_callback+0x45d/0xbd0 [xfs]
  xlog_ioend_work+0x116/0x1c0 [xfs]
  process_one_work+0x7f6/0x1380
  worker_thread+0x59d/0x1040
  kthread+0x3b0/0x490
  ret_from_fork+0x1f/0x30

 Last potentially related work creation:
  kasan_save_stack+0x1e/0x50
  __kasan_record_aux_stack+0xb7/0xc0
  insert_work+0x48/0x2e0
  __queue_work+0x4e7/0xda0
  queue_work_on+0x69/0x80
  xlog_cil_push_now.isra.0+0x16b/0x210 [xfs]
  xlog_cil_force_seq+0x1b7/0x850 [xfs]
  xfs_log_force_seq+0x1c7/0x670 [xfs]
  xfs_file_fsync+0x7c1/0xa60 [xfs]
  __x64_sys_fsync+0x52/0x80
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 The buggy address belongs to the object at ffff88804ea5f600
  which belongs to the cache kmalloc-256 of size 256
 The buggy address is located 8 bytes inside of
  256-byte region [ffff88804ea5f600, ffff88804ea5f700)
 The buggy address belongs to the page:
 page:ffffea00013a9780 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88804ea5ea00 pfn:0x4ea5e
 head:ffffea00013a9780 order:1 compound_mapcount:0
 flags: 0x4fff80000010200(slab|head|node=1|zone=1|lastcpupid=0xfff)
 raw: 04fff80000010200 ffffea0001245908 ffffea00011bd388 ffff888004c42b40
 raw: ffff88804ea5ea00 0000000000100009 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff88804ea5f500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88804ea5f580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 >ffff88804ea5f600: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                       ^
  ffff88804ea5f680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88804ea5f700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ==================================================================

Fixes: 4e919af7827a ("xfs: periodically relog deferred intent items")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_cil.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 550fd5de2404..ae9b8efcfa54 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1178,21 +1178,19 @@ xlog_cil_force_lsn(
  */
 bool
 xfs_log_item_in_current_chkpt(
-	struct xfs_log_item *lip)
+	struct xfs_log_item	*lip)
 {
-	struct xfs_cil_ctx *ctx;
+	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
 
 	if (list_empty(&lip->li_cil))
 		return false;
 
-	ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
-
 	/*
 	 * li_seq is written on the first commit of a log item to record the
 	 * first checkpoint it is written to. Hence if it is different to the
 	 * current sequence, we're in a new checkpoint.
 	 */
-	if (XFS_LSN_CMP(lip->li_seq, ctx->sequence) != 0)
+	if (XFS_LSN_CMP(lip->li_seq, READ_ONCE(cil->xc_current_sequence)) != 0)
 		return false;
 	return true;
 }
-- 
2.35.1

