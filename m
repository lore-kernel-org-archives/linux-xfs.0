Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AE4C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Jan 2022 05:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240800AbiAXF1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Jan 2022 00:27:20 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:1536 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240794AbiAXF1T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jan 2022 00:27:19 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20NNlE5Q001908
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=LNsQHKsWH37KD7N/wBKaHy0iHjH49k4mz7GuH/YFA3Q=;
 b=fBUpR8g326DApXdoe+DFSASMrGiRVhs5vegahX3V52LeGprCC1RG0mwK4scsO6W1oQoD
 zZfATUJcz8+sNInQUxemHFSOMf2JD0cwIb72xNJ6/p+fz9M96o+lJ/8Nv6cONmVYx6G+
 b41rX8RozQIvb1cDNfZikA1xn1w+4QLyNBRkYFkJZKoipoXijdGRuxIQLCT4MXeatr/a
 PA2EZwdqQ5kl8phoDS10ppIx40957zIqQDqBLMzjjV7cTwVMdnGctv+3a1LFG37+9aGM
 HyJQI21c2A1B4nAY13vHY3FlcgCYQiQUNaHnFZ+nsGaZiQuIT2tbW1Isw/Lblb9/dwpq 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dr9tb2yhj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20O5Qr8J087767
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 3dr71up23q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jan 2022 05:27:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtFu/RIvCPLReTUzu58ZC/7kT3cv7HbiWwKqaOw0cRl5/22S6QDqt4SIcsDW3/e6REQawjY+q0zigmg5hFbAYvK80vY2+16AtQw3TSSYSs3ry+7cqlbt8mThxNR3pyJ4+MtmFnMa4tKyxPy+jUX/6lEyDXjQ8kx4KMgvAmu10lplH1NYZA1NWxPK3Jt1lfE8CFBdsmWkBHYV0Bzv8Yn6CqHAwu4pLl6ZemW0oD1DhObt9J2gYLSMeol3UUb/VLmXNOM9yRi7Lloe9QaoAGC1xEiQUPJUcVeHLFlq7y53Qb4m1luHqRv6ns+7Qb2+LfC1HaN0enLiVQk0WpoR5LifAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LNsQHKsWH37KD7N/wBKaHy0iHjH49k4mz7GuH/YFA3Q=;
 b=I/XgNT3q1t3y6VYjGxsnsRrzj41GDTFf2p7G+bkUL0QwVEHVx7Vbcg1rTGFQPbTNL7thzvNbuFSArdviB9jhrIU2n34masbhfqHni7nqCZL5b5CJ5X8pyrrPwmcVe6+3LanxeNoHPL2q7TtPT3vnqRNujyuZ3XKRoI/SfgeHDpHuGK20MJJJ/R+7zjCpPVslvJewIaWs0cmi7KfSdw7M6JbiDbnktGe4GKmXxjKiT81gU1HlU39KJ8m4FnlaS17PPsrNzz9cy76CDvXhOZ6iO5kJ/0ceYL1WFjhIbDmh0vG/pbWJPiqvwop0HBifhn1QRcYi5cA4TQBkZ/ZDoYY71w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNsQHKsWH37KD7N/wBKaHy0iHjH49k4mz7GuH/YFA3Q=;
 b=lKuPo0c6QQJ+jTmWECXxsEUK9yVnALZoTTemXuYzYwzARdqFqOuCLHrzlvER/a6/7HlR9vF9sqTWpzDozJW35DBRENphSMLzUUGk64D2V8HFddiZL0rXIHT+QTb2bAo0pkr4I2dFYFccwuTfqZReFOYpB6SyGskKnnIBJWisCb0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW5PR10MB5874.namprd10.prod.outlook.com (2603:10b6:303:19c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Mon, 24 Jan
 2022 05:27:15 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::3c8d:14a4:ffd3:4350%6]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 05:27:15 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v26 00/12] xfs: Log Attribute Replay
Date:   Sun, 23 Jan 2022 22:26:56 -0700
Message-Id: <20220124052708.580016-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:254::13) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5302d3a2-334a-407f-1f08-08d9defa2e6c
X-MS-TrafficTypeDiagnostic: MW5PR10MB5874:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB58749D4804D800B5D6CEC765955E9@MW5PR10MB5874.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9m6av/OGW1ZoG0Eju/64OgnQVX988jW+jsE4nxmXPVk8HT5PBR1c8hnDUuSh9BvBwkFAp4cU8cXHDmblxhTzju7m3HMqtaUAW5opvzayfk2LpARSEKDuDWeCDFs7uHbn5xxd5Bw/d598uenNiuoMWDZK5+hCFpNuaSoj4L+WFBIqf54tUMfbiLfoQo+yBR1HsHcVIrpQN4ag9JU2pd3ezPuM4tRzf+ksV16sM4z1hIfc4LNmvUosUeOxNqEucaK6wBuZvjhRzWUVDEVLVIaI4xcodRl9DlBgzj6KnxyYq/e04ugBK7KC2tiW7Wfi4tVcbxygwyDe9I1KPn47XImXrGT2E0veyyneomfHohPssrCkwzhRleLTQCKJcPwAambkoVazkZL6uz5Q2fkHT19hvm/nP3eKpmBdMLJLbi68E+pi+tIh0Bjyvgm3eYpxWlpN+JyVjSNc53ekylH0nL/TUmO0YLoeE3iju1XhmFodnzA6oFFvVT8I0WIqDOBNsNmLr+e2La1ssxSLQRHo9rhp9RHeAwUdbxrrjVJyqlooOCcYkbL3e0Doq17435Z0r09GjC3ItbSI3AvebCBW1gSMf+lizE+EDP7/2qtnRsethSpXf1jaLvsH70MmWavpYeovDQrWc4krUHDJBAoHRpYyXcwSGbLrgUoww8hIGA+8sjRvCavc2gi6Rk/44hHsuxcxTOyF3LuP7a3axK0SnxAbWZyRia1uYpKgNzk/FteeR6sgQt5kpwXrrKOZY5pevhPpMIRCqocLS7XZzH1hlEFr/S5hJzHI3mK3k/SB45lGte6+MA6jvBsiewWJ3KIWZtv+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(66476007)(8676002)(6916009)(6506007)(6512007)(66556008)(6486002)(44832011)(1076003)(2906002)(83380400001)(8936002)(38100700002)(38350700002)(2616005)(52116002)(86362001)(508600001)(66946007)(6666004)(316002)(26005)(186003)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ps4O6HSM4RaJwoUKHc3mubjb7k1d457WzgmXkqVB8YczpYmDK+uwODETLW3D?=
 =?us-ascii?Q?SNXKf4pCxzNjWCCgE6mrNuvEUGzf+FP7hVJRQeV9E3L3S9XiiUnVUOKupw8m?=
 =?us-ascii?Q?nHPIqpAPqHn8cIOb3hcbhqPJKgaZ98DZuRZjeTrUHuTkYOoSVNxsEb5BKMdQ?=
 =?us-ascii?Q?sN7dyBex0hqX8hn7eaCd5ZKYDK5qW1ynonOOoYdNFTZlb2pXuHVIrGGfBUXI?=
 =?us-ascii?Q?liKiVqdwhmsvVZypnQmMNcoBT9cbBeO+ohR122gb4ND1l7+/i+7hgx9FZFku?=
 =?us-ascii?Q?PhkV6bcILm4KxFMfpuKs39knxUZk5SYGjz84vdxQbo5veSZgexgozJUa7+4Q?=
 =?us-ascii?Q?yxRQ8gf5Y9WOAPc5hPMTp518i/0ZAIN+UBPl21e01FPcoO23UDT6q8td/rIJ?=
 =?us-ascii?Q?Nlx3pIVMqpHNKhjNH4lcHNtk31lv/c3QsH/r12kOsHMr8nYG2qYaxl/oX3iF?=
 =?us-ascii?Q?zC/30PrM9qxkDrfcTENSGaQp4vMqPtr+XJ21c35Cc20jQv6fe/uGi+YukDYR?=
 =?us-ascii?Q?qhBYNvQ9ykNYaFXnDWey9M9J1CnbGyJo+i4+dnP0NLDoXRnUl3tctlBdecJr?=
 =?us-ascii?Q?tPoeaRYweGqqXGvHkIaXhdsvkDu0YYHf9eA3PK8OCmRROX0nSOdh66EMHNd7?=
 =?us-ascii?Q?ZQYU6wG26bniteh5ERZEXt3TiGCx8QnUJ7gCpngTCH8o3GQssSOdAQbToU2W?=
 =?us-ascii?Q?QEORLaVrv0AFvvu39rmNE6eBCrdMeQwaTUjzgZFyP6lkljbk6hDcJGQzNVLW?=
 =?us-ascii?Q?bmPIKSTlzL5QM7htJyjcRYSOeFZTUVFsxCKe+qgUy0NIMSlgM0Kdsy0FoJsx?=
 =?us-ascii?Q?+UIP5Yy4Cl6lSJmYP0mO6AZzDqALRvp7YO4DuNC7GCufbMhh/ued8iG3t3k2?=
 =?us-ascii?Q?KBgjBvySCRaQXWuTNlzRiwv5K7MSk4hL6uiL521yX+6FsiKqswG/dzqMszPM?=
 =?us-ascii?Q?UCzSglSb0i4peeW+3xMmuZqk/6frYR67/Q9Whw2nqs2hV/qIyAYRe+4/ZAK6?=
 =?us-ascii?Q?7Y1S7d6NXBNkmrmgStip/XXQ5P5/xLIDcWMuOeCYY2Q+02LZYGrNZrnH8G5q?=
 =?us-ascii?Q?FIy+DYA2HGhMswQEbWAHrFKaJfxUZIZet9SDxUSuThIVQkzJoiw8SWkyJ1/I?=
 =?us-ascii?Q?BTGs8ErnrHtY+x4prGN9HJqhVHHnmyPlgYAKu38187OM1Ijk51lrjt2UPCtm?=
 =?us-ascii?Q?+3/EKALSMHnvJEwMNZRsYfb62SqK+dUxv0ZuIEqMr8R+Nb7GWE1PDytRUKUx?=
 =?us-ascii?Q?GDVanUpb2XR+kBJf3Y0kMP8ZnWbFj/swRycpJfj8F+xWDkAH5N429LSa642R?=
 =?us-ascii?Q?uwXuyVkIwcKgfgzeoQQC8nJ8qmQBX8z8ouLh5FARmNl+jqS4syIQVkmpbUTv?=
 =?us-ascii?Q?kb93uUbVXZ2lDryeQZhh00HdCIHQzkTeduVnDZKqyGKbj1C8XZ7/Vm1WAlPE?=
 =?us-ascii?Q?7/zAHezk6jpNEfSOSDUJFPT+nFbaq4ljDEBYiQCP2xwLuE2Lw0VlMELKgBo6?=
 =?us-ascii?Q?NqFSHhkWmqKpyAnfRQPx8m2nIxCsIO9f/z3N5zV1tnot6hTXTcoIiU/BEpWj?=
 =?us-ascii?Q?gKmLlwTBmB5CluJ8CO9Sm82ZyefM1P18AtljSvsscRpAIINVACezRIMJQNfE?=
 =?us-ascii?Q?Qio1FNc+4HmZxzM9lpkaNz70IeKkZi22zC6bdPogRm1AmUM6jgQxjfumygE6?=
 =?us-ascii?Q?MwCV0A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5302d3a2-334a-407f-1f08-08d9defa2e6c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 05:27:15.3746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PKlV9cLtkj5r2lmoGBFjQTs8Saoxmb1fnIN2a0IpiCbA23QtJJg6RZsDbb0lmFK7S3CGtiegFXn3SWMYES5Mvvj4vej8WG0JdepTwfKanyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5874
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10236 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201240036
X-Proofpoint-GUID: tTI3r5wvAxCVklJOPMUkKJ748hH7OrF1
X-Proofpoint-ORIG-GUID: tTI3r5wvAxCVklJOPMUkKJ748hH7OrF1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This set is a subset of a larger series parent pointers. Delayed attributes allow
attribute operations (set and remove) to be logged and committed in the same
way that other delayed operations do. This allows more complex operations (like
parent pointers) to be broken up into multiple smaller transactions. To do
this, the existing attr operations must be modified to operate as a delayed
operation.  This means that they cannot roll, commit, or finish transactions.
Instead, they return -EAGAIN to allow the calling function to handle the
transaction.  In this series, we focus on only the delayed attribute portion.
We will introduce parent pointers in a later set.

The set as a whole is a bit much to digest at once, so I usually send out the
smaller sub series to reduce reviewer burn out.  But the entire extended series
is visible through the included github links.

Updates since v26:

xfs: Set up infrastructure for log attribute replay
	Removed xfs_da_format.h include
	Investigated adding xfs_attr_namecheck to xfs_attri_validate
		Skipped since the name/value lengths need validation before copy
		from user space gets a name to check
		xfs_attr_namecheck added to calling functions when name is available
	Added attri/attrd slab caches
	Fixed size_t variable in xfs_attri_copy_format	
	Indentation in xlog_recover_attri_commit_pass2
	Indentation fix xfs_attri_item_size
	Comment fix in fs/xfs/xfs_attr_item.h
	Re-ordered members in xfs_attrd_log_item

xfs: Implement attr logging and replay
	Renamed xfs_trans_attr_finish_update to xfs_xattri_finish_update.
	Updated comments
	Investigated hoisting xfs_trans_get_attrd into xfs_attr_create_done
		Skipped since xfs_trans_get_attrd has more than one caller

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v26

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v26_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv5

In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v26
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v26_extended

To run the xfs attributes tests run:
check -g attr

To run as delayed attributes run:
echo 1 > /sys/fs/xfs/debug/larp;
check -g attr

To run parent pointer tests:
check -g parent

I've also made the corresponding updates to the user space side as well, and ported anything
they need to seat correctly.

Questions, comment and feedback appreciated! 

Allison
Allison Henderson (12):
  xfs: Fix double unlock in defer capture code
  xfs: don't commit the first deferred transaction without intents
  xfs: Return from xfs_attr_set_iter if there are no more rmtblks to
    process
  xfs: Set up infrastructure for log attribute replay
  xfs: Implement attr logging and replay
  xfs: Skip flip flags for delayed attrs
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
  xfs: Remove unused xfs_attr_*_args
  xfs: Add log attribute error tag
  xfs: Add larp debug option
  xfs: Merge xfs_delattr_context into xfs_attr_item
  xfs: Add helper function xfs_attr_leaf_addname

 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        | 491 ++++++++++---------
 fs/xfs/libxfs/xfs_attr.h        |  68 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   3 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  37 +-
 fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
 fs/xfs/libxfs/xfs_defer.c       |  51 +-
 fs/xfs/libxfs/xfs_defer.h       |   3 +
 fs/xfs/libxfs/xfs_errortag.h    |   4 +-
 fs/xfs/libxfs/xfs_format.h      |   9 +-
 fs/xfs/libxfs/xfs_log_format.h  |  44 +-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_attr_item.c          | 803 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  46 ++
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_error.c              |   3 +
 fs/xfs/xfs_globals.c            |   1 +
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   2 +
 fs/xfs/xfs_log.c                |  45 ++
 fs/xfs/xfs_log.h                |  12 +
 fs/xfs/xfs_log_recover.c        |   2 +
 fs/xfs/xfs_ondisk.h             |   2 +
 fs/xfs/xfs_sysctl.h             |   1 +
 fs/xfs/xfs_sysfs.c              |  24 +
 fs/xfs/xfs_trace.h              |   1 +
 27 files changed, 1388 insertions(+), 278 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.25.1

