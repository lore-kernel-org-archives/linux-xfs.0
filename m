Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E64FC636D7
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 04:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjBMEGb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Feb 2023 23:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjBMEGa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Feb 2023 23:06:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDA1EC57
        for <linux-xfs@vger.kernel.org>; Sun, 12 Feb 2023 20:06:27 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D1iGSt018536;
        Mon, 13 Feb 2023 04:06:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=XpPF42QuC/PJzRnZa8d1wUXXsJIzcc1x3E0b9GAGNjc=;
 b=KWbqaANwNvAHIapuLQe8FIjZwS4qra0hROPS1vQB6EZWH0XnGWeq/XvmuGZ4b4gjccvJ
 M9VMiM/KmdwOHiUnyibzorJiyCNoBqHBjfXCtORQf272JOqJbFBIMH9Igh3YUOEaKnOj
 nxYOssrTJab/Mr1ReNq9sSW9u19jY4TD9W+EgXeg+2FaYKIVQ+JW2mfIfWLBC5i390cm
 I+QNjRLzK5HvKA3nQgwE6CGQyFDnnZwy+vSx7WmF2IvnhHzMkRqqfLODp1h/p4RIwdih
 9IJIcsVjnXwBrwY/gXRPXeXAawB083qVsFbiNkwgMN8+lcrjU/oNdMtEIxexrfDvjaxL aw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2w9sv5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31D30M95011564;
        Mon, 13 Feb 2023 04:06:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f3k0ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 04:06:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLvc3MI5PU0c5aOQgnUDEJz5+GCeDny8qbI7i6P9dS94feWOKQIq7LaX4lEgOCSBE4FB1e++dRWFAMZc17JGBpifDWIIeIg2QCDLBx5LPvf4lJXPnm1V2S3MvgjqRbd+Ljjt5ILZE6eAnopDQXMzUbOT9Estl5uwxtUgYgPzsyruPvWUnvllp+bxilWLErfQWWIunt8vymR1YiUVqjlOotw1ihfxnmR3AT4hCDe/okwbrA+2DVEI7iplw/GWvoshcoKYt0dM0NEY6G2Iw0ZdpTVKR2FrAugjte9LDj5MwD4r3Syv0U2ZQcy7JIPLhL//hEYT9wEuX7zKnInlzPiDVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XpPF42QuC/PJzRnZa8d1wUXXsJIzcc1x3E0b9GAGNjc=;
 b=CrW9CSJ60wa0CR64gf2d5UdLo/v4PwRekFGUZCav47KCva8HHT5w/81Oyarh/pzmiiDBkXdNDOlhzkiIa+Hz8zK1Vy+rdgRAt93on+Ol30yyGk/V70Wb4Z3wuvACTuIstq3Qq49cz1itJv1zCufL4Pn3VWilnfQ8Wq+i2yP24tCopvt44B6R3iifyrpDJLp/b5pd6ye5FXUQvuDrhsTa5Yq55OKZN4SUHfV3bZ4YTq+x2nP8rbGBr02eVil/3iK9xms3lD0/F4g/aOyBYKVBhdhPz9t4+o7ob1aOzQg/ut5H/PbsHZ9wwk8qID0Gr/SWx16hkbLA2qAbzNiMIR7NGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpPF42QuC/PJzRnZa8d1wUXXsJIzcc1x3E0b9GAGNjc=;
 b=dPf8GoGqKUj2pCjttS9sQjtMbqBS5EFFY0nouBsZPGGeWJ/HXgkwRewFxtHleBQZjroG8jE5tp5xo0Qo7X6WSEF+agzLN5itz+L1TmFjsAT2iB8lOVIAAIGv9gTyrawmZBo8d8xsWjFkEhcbOZ/BfdNCyeiKHqZZcphEGz9xt6Y=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH0PR10MB5225.namprd10.prod.outlook.com (2603:10b6:610:c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Mon, 13 Feb
 2023 04:06:19 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.009; Mon, 13 Feb 2023
 04:06:19 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     djwong@kernel.org
Cc:     chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 CANDIDATE 11/25] xfs: proper replay of deferred ops queued during log recovery
Date:   Mon, 13 Feb 2023 09:34:31 +0530
Message-Id: <20230213040445.192946-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230213040445.192946-1-chandan.babu@oracle.com>
References: <20230213040445.192946-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0032.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH0PR10MB5225:EE_
X-MS-Office365-Filtering-Correlation-Id: b2349417-0297-4e81-098f-08db0d77a931
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5RYXO4Ze+/s/8xxTbRvjjgrnjX/BBIzjqVMBkkdC8Kp8nPOutnAxbbENvgHYEW18rorEH69F24M8VtqcsjGUVACwvtC3djE8K71bo3L1EkLBmsDNhomubpC/vq46ShwMDRIp7hhjKd2lhI8DF5Dasrbw1GDQmPv/eMHDd6Qs6YtnwizUKhGKy8j5Xcbn207JWgvcoWSek/opg9u2wg+438cSMKMvrpip+WNh0eqPVyGFoaN4SAPLOgGh6xJoXts+ZrTvkO3EV/hj5gEz4ySziEPjLADXjnF35ZZP+grjTY/HOmYVzI20qWGWMaDXIwo+kPUTpbuSyKbeq0hy6z+nO/HI/1Sz4A6Nxk2h/Pht36o9p3AT2lbRO9g7p6xmt5Jpuq7lQU9nP7gvZlVol2xU91BhOUryi6Tanm1NliEjPceqJ8LpSTw6/Jnmor65Dvcsqrgl/8cmM5i73K1f3YDCTsEJ5fKlCD0bSUmQ45BoKgNe+my1l2r5H21hWsnva3H0+QMbzhsDsE7LPZ0FI97tanUcxOHAIvI33iS6527HTWEVkCyG++YN56ndbgHhCQgpuCdgnpwkwRynla/fl/KlMPkqfZlay38E8KJ3Tix/Daq04nTmOpc91QPGv9oukTbmLI8K8ychcd3NZ/ertxlVRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(8936002)(36756003)(30864003)(5660300002)(86362001)(2616005)(83380400001)(6916009)(4326008)(316002)(38100700002)(66556008)(66946007)(66476007)(41300700001)(8676002)(6486002)(478600001)(6666004)(6512007)(1076003)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tCy0ItMDWyb68DuqCXlMI4+wxx7nJ6Vllf28jBf73rzvZ7kI5c0gIiyBrjOn?=
 =?us-ascii?Q?Zu3bQXKw8ojmaGmlpAL5F6v5uNZwtG/7RSKQYglDLePCIgcg+7UCkH23R+kJ?=
 =?us-ascii?Q?9mnKAOJoyoJgMm3ZZgKflsvsLJW1xwPHGP/PWfLuqQFZAsC00GSGcITc8xOi?=
 =?us-ascii?Q?51v29LDZQ74ngGnIdoIjtgGVIH0KxowKd7ekLH8nUPqqN3PxtzxzhifMaHfw?=
 =?us-ascii?Q?yta9zSPfaSv1dmbZ8+zfzfjkqLshzBpF/Mx63zF+vj2Dsd7sNMKWRBzVZm5h?=
 =?us-ascii?Q?yxSVEjquctL2Apo1j82Ntcu9AtzI3tCMjcc7M3ruSrdd/blyUMCHl0e8/342?=
 =?us-ascii?Q?kOsDLphRcJyudYnvAwlLNfUIS+v/HmVkrJSxmCrVB+4KsrYEAo7pjG9LHX3k?=
 =?us-ascii?Q?9viuJLZunm58s7IKW+bd9R+ButQ7GsiQ8PPVHwXXgj/jvmfJFGLuxoz6Bhh1?=
 =?us-ascii?Q?w6qFnv+e3h2CwA8jTswoRyWxhUUj9OlzXkPkS6C2Lo95sLyjTOnuo8+wNqoq?=
 =?us-ascii?Q?KM0HRk8IJlVd8fuDxlZJKbkeR/jro3IbZvRhhaDHa0qEgTkuLoDJdCXb2bYw?=
 =?us-ascii?Q?tjHzoL9ZJR8izaHtQEcAIUqwfL5ap3GA3ygOSfk+JYzyp6APs/Tj0daSaLPv?=
 =?us-ascii?Q?t/RyHb2j95fnlKbXv16mc1lY1FAcIZYZzFXFxF6OwpjPtm4xxJyhlB/nO6ZS?=
 =?us-ascii?Q?wEtk5Li3urk+h5/55wuffWx1XVj+YBitOlFALQqhGyOu7ahrJRj+DV7Zvsma?=
 =?us-ascii?Q?oX3VYgQ5M9o0B/9WfL51/WRoqaCkjkI5Ll/X2UztE6LnhFPXBeNSMuzOb15s?=
 =?us-ascii?Q?13ZxJR52PER9blPL0aMGmRM4WTvmt/YH8Ag8WGx8DM1vmY9D/zYnw0r/yJbG?=
 =?us-ascii?Q?dqsFoPGdp4cpTadfY4a2jIi1KXIYxuBlGOnjIsiK276fnBd1hiYmkjJZ42kP?=
 =?us-ascii?Q?iiTsvcEPXGcu/MJi6AWU01TDX81yDOjhXQOP9bzwfFC6SyF5jnxe9WXZ+fyW?=
 =?us-ascii?Q?3ulwd5Rj2q83SYxMjZd/X5+nrmb06xZpM1HcnH+HWmjuCYo6o1VhD+v4NQoS?=
 =?us-ascii?Q?dCCCSTD1td3ODgVF1MNgroF11N4RLy2ebhaONNQGlIyAgoQ0xrmMHKVm+SLH?=
 =?us-ascii?Q?5IBPRrW2MJiwkOhFdfUCTe0Ytnk7o2dv0xBOZ+Sm9sbVZ7NQ2af2ej5u/8FF?=
 =?us-ascii?Q?rGEJB65/fMX9o+mHaV51nsE7I/C6yuZoaL41a9yCHZ0R0Ua9wisL2IIUtkkE?=
 =?us-ascii?Q?VaDhJFhMIVD6bEsy0BeLy9GmGnonxHD+LgUQ77k3XCXljxE6//xMzdt1zaHa?=
 =?us-ascii?Q?6WJ9FvZaYqw+GauAJJyHIZef+Xh2AmVVapa17TVKgAlbKVowdT0TP1kZhSJD?=
 =?us-ascii?Q?z/oAeaghg5e0KlsLbyQrK5wz1ksfTI1NgILBvF208/C9jsUNO4wWNFdR7325?=
 =?us-ascii?Q?W7dLqEZ73KxjmbSObxg9H4LF1dlPY4BI8/z40zQ02+6AjoWcwyumsy8a1CJG?=
 =?us-ascii?Q?kzX6ljPL8mmM3MYAfQnVWCW3YtSrekHRBjo5Y1IKgGc+JW3rBTblpmMJ6Cwq?=
 =?us-ascii?Q?csYtof0wOMX8rjwxmhyfAini6kxXothSrZlal7qz5k1tN+h4h5edCeYkpCrN?=
 =?us-ascii?Q?ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1j9d6R8nY/RSZSejdSH1bhPFXMTQZXebx+/IeLhEK4u08hSayzavIbxs5f88ipQNESoFWJUPTbl7CKnEqCenVXT2p9zLXLnz/NSuKvHDnOFRO5dDueuUKf8g6YDbUGGU7TiBn/t6szfCuiRWbw1WKeJmSc3agJnjOcU1Wjskd4/TitJRdcVDDG0UBXmDvXQ53XkFGT+Ayq1CG4W8zkVf0YUnHgID7sGhJDmqkHNYuZPIJLcaKwXS9+F23L1+gDcykB29505kj7Q/AwUjQFNSfE9eHXSHl/EILbg48Bvfr55iSSkOHLP7G0y86O873MkE+7AHm499TOP6NWIcotGmEaYljPY869p6M7dK9kzYyR21H8MnMqt4akRR98yovxJRHrPg8B0Ril1B4mMqVCvgiy11A1zxt85hCuk4XRwhxyDR0her4eKUZSp9dAzWoBiFJaUsxv2h22HENguXhwott0GP+iq45EEOJt5jzvnvq104+22DAekGJV+Nkrj3Qg9OSF04FqmyE7g6Ex/Jm+N7+2dnH9nFOS4oSyxmQxPT9+Ovf0YETVcEcIUkTnbjE+AeDSETdGC9tmTbS0pYXhfZkiJP+LUx5BMxak8zLm5WSQxfPTN2U5eRNUfcWWA7bQZF1LejjReKm69VbMmZVEL+tZUIxxkXkA8KQ/PF2VJjb3Rrz2KmR6DP29zfphvUZCZcqeLAsCZsf6PPmf/798rn8e7/ieI5NhrTG13AW/TBwkyCMksZL+FvDE4p2KswjQA1dvvaFHIDByaCWeR8cbAq4vF9Rdrb81aAT6PwUmsr/pHAk7zETStwC0XRpbGz3VIi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2349417-0297-4e81-098f-08db0d77a931
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 04:06:19.6701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cG9ZfsZw1uynqMulABf6dZ+cCy2l5cLTns7KbxbAxloDv2W76NNbsj/pCxcD9Hyjq/pODdwaOZ2gvWxpouIdTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_12,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130036
X-Proofpoint-GUID: Ey656evpp1ZMtSnbIhtANi0-koEuHI_3
X-Proofpoint-ORIG-GUID: Ey656evpp1ZMtSnbIhtANi0-koEuHI_3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit e6fff81e487089e47358a028526a9f63cdbcd503 upstream.

When we replay unfinished intent items that have been recovered from the
log, it's possible that the replay will cause the creation of more
deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
recovery should replay deferred ops in order"), later work items have an
implicit ordering dependency on earlier work items.  Therefore, recovery
must replay the items (both recovered and created) in the same order
that they would have been during normal operation.

For log recovery, we enforce this ordering by using an empty transaction
to collect deferred ops that get created in the process of recovering a
log intent item to prevent them from being committed before the rest of
the recovered intent items.  After we finish committing all the
recovered log items, we allocate a transaction with an enormous block
reservation, splice our huge list of created deferred ops into that
transaction, and commit it, thereby finishing all those ops.

This is /really/ hokey -- it's the one place in XFS where we allow
nested transactions; the splicing of the defer ops list is is inelegant
and has to be done twice per recovery function; and the broken way we
handle inode pointers and block reservations cause subtle use-after-free
and allocator problems that will be fixed by this patch and the two
patches after it.

Therefore, replace the hokey empty transaction with a structure designed
to capture each chain of deferred ops that are created as part of
recovering a single unfinished log intent.  Finally, refactor the loop
that replays those chains to do so using one transaction per chain.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_defer.c  |  89 ++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h  |  19 ++++-
 fs/xfs/xfs_bmap_item.c     |  18 ++---
 fs/xfs/xfs_bmap_item.h     |   3 +-
 fs/xfs/xfs_extfree_item.c  |   9 ++-
 fs/xfs/xfs_extfree_item.h  |   4 +-
 fs/xfs/xfs_log_recover.c   | 151 +++++++++++++++++++++----------------
 fs/xfs/xfs_refcount_item.c |  18 ++---
 fs/xfs/xfs_refcount_item.h |   3 +-
 fs/xfs/xfs_rmap_item.c     |   8 +-
 fs/xfs/xfs_rmap_item.h     |   3 +-
 11 files changed, 213 insertions(+), 112 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 4991b02f4993..0448197d3b71 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -563,14 +563,89 @@ xfs_defer_move(
  *
  * Create and log intent items for all the work that we're capturing so that we
  * can be assured that the items will get replayed if the system goes down
- * before log recovery gets a chance to finish the work it put off.  Then we
- * move the chain from stp to dtp.
+ * before log recovery gets a chance to finish the work it put off.  The entire
+ * deferred ops state is transferred to the capture structure and the
+ * transaction is then ready for the caller to commit it.  If there are no
+ * intent items to capture, this function returns NULL.
  */
+static struct xfs_defer_capture *
+xfs_defer_ops_capture(
+	struct xfs_trans		*tp)
+{
+	struct xfs_defer_capture	*dfc;
+
+	if (list_empty(&tp->t_dfops))
+		return NULL;
+
+	/* Create an object to capture the defer ops. */
+	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
+	INIT_LIST_HEAD(&dfc->dfc_list);
+	INIT_LIST_HEAD(&dfc->dfc_dfops);
+
+	xfs_defer_create_intents(tp);
+
+	/* Move the dfops chain and transaction state to the capture struct. */
+	list_splice_init(&tp->t_dfops, &dfc->dfc_dfops);
+	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
+	tp->t_flags &= ~XFS_TRANS_LOWMODE;
+
+	return dfc;
+}
+
+/* Release all resources that we used to capture deferred ops. */
 void
-xfs_defer_capture(
-	struct xfs_trans	*dtp,
-	struct xfs_trans	*stp)
+xfs_defer_ops_release(
+	struct xfs_mount		*mp,
+	struct xfs_defer_capture	*dfc)
 {
-	xfs_defer_create_intents(stp);
-	xfs_defer_move(dtp, stp);
+	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
+	kmem_free(dfc);
+}
+
+/*
+ * Capture any deferred ops and commit the transaction.  This is the last step
+ * needed to finish a log intent item that we recovered from the log.
+ */
+int
+xfs_defer_ops_capture_and_commit(
+	struct xfs_trans		*tp,
+	struct list_head		*capture_list)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_defer_capture	*dfc;
+	int				error;
+
+	/* If we don't capture anything, commit transaction and exit. */
+	dfc = xfs_defer_ops_capture(tp);
+	if (!dfc)
+		return xfs_trans_commit(tp);
+
+	/* Commit the transaction and add the capture structure to the list. */
+	error = xfs_trans_commit(tp);
+	if (error) {
+		xfs_defer_ops_release(mp, dfc);
+		return error;
+	}
+
+	list_add_tail(&dfc->dfc_list, capture_list);
+	return 0;
+}
+
+/*
+ * Attach a chain of captured deferred ops to a new transaction and free the
+ * capture structure.
+ */
+void
+xfs_defer_ops_continue(
+	struct xfs_defer_capture	*dfc,
+	struct xfs_trans		*tp)
+{
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
+
+	/* Move captured dfops chain and state to the transaction. */
+	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
+	tp->t_flags |= dfc->dfc_tpflags;
+
+	kmem_free(dfc);
 }
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index bc3098044c41..2c27f439298d 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -7,6 +7,7 @@
 #define	__XFS_DEFER_H__
 
 struct xfs_defer_op_type;
+struct xfs_defer_capture;
 
 /*
  * Header for deferred operation list.
@@ -61,10 +62,26 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 
+/*
+ * This structure enables a dfops user to detach the chain of deferred
+ * operations from a transaction so that they can be continued later.
+ */
+struct xfs_defer_capture {
+	/* List of other capture structures. */
+	struct list_head	dfc_list;
+
+	/* Deferred ops state saved from the transaction. */
+	struct list_head	dfc_dfops;
+	unsigned int		dfc_tpflags;
+};
+
 /*
  * Functions to capture a chain of deferred operations and continue them later.
  * This doesn't normally happen except log recovery.
  */
-void xfs_defer_capture(struct xfs_trans *dtp, struct xfs_trans *stp);
+int xfs_defer_ops_capture_and_commit(struct xfs_trans *tp,
+		struct list_head *capture_list);
+void xfs_defer_ops_continue(struct xfs_defer_capture *d, struct xfs_trans *tp);
+void xfs_defer_ops_release(struct xfs_mount *mp, struct xfs_defer_capture *d);
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 8cbee34b5eaa..e83729bf4997 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -425,8 +425,8 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
  */
 int
 xfs_bui_recover(
-	struct xfs_trans		*parent_tp,
-	struct xfs_bui_log_item		*buip)
+	struct xfs_bui_log_item		*buip,
+	struct list_head		*capture_list)
 {
 	int				error = 0;
 	unsigned int			bui_type;
@@ -442,7 +442,7 @@ xfs_bui_recover(
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
 	struct xfs_bmbt_irec		irec;
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = buip->bui_item.li_mountp;
 
 	ASSERT(!test_bit(XFS_BUI_RECOVERED, &buip->bui_flags));
 
@@ -491,12 +491,7 @@ xfs_bui_recover(
 			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
 	if (error)
 		return error;
-	/*
-	 * Recovery stashes all deferred ops during intent processing and
-	 * finishes them on completion. Transfer current dfops state to this
-	 * transaction and transfer the result back before we return.
-	 */
-	xfs_defer_move(tp, parent_tp);
+
 	budp = xfs_trans_get_bud(tp, buip);
 
 	/* Grab the inode. */
@@ -541,15 +536,12 @@ xfs_bui_recover(
 	}
 
 	set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
-	xfs_defer_capture(parent_tp, tp);
-	error = xfs_trans_commit(tp);
+	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
-
 	return error;
 
 err_inode:
-	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	if (ip) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index ad479cc73de8..a95e99c26979 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -77,6 +77,7 @@ extern struct kmem_zone	*xfs_bud_zone;
 struct xfs_bui_log_item *xfs_bui_init(struct xfs_mount *);
 void xfs_bui_item_free(struct xfs_bui_log_item *);
 void xfs_bui_release(struct xfs_bui_log_item *);
-int xfs_bui_recover(struct xfs_trans *parent_tp, struct xfs_bui_log_item *buip);
+int xfs_bui_recover(struct xfs_bui_log_item *buip,
+		struct list_head *capture_list);
 
 #endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a9316fdb3bb4..2db85c2c6d99 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -586,9 +586,10 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
  */
 int
 xfs_efi_recover(
-	struct xfs_mount	*mp,
-	struct xfs_efi_log_item	*efip)
+	struct xfs_efi_log_item	*efip,
+	struct list_head	*capture_list)
 {
+	struct xfs_mount	*mp = efip->efi_item.li_mountp;
 	struct xfs_efd_log_item	*efdp;
 	struct xfs_trans	*tp;
 	int			i;
@@ -637,8 +638,8 @@ xfs_efi_recover(
 	}
 
 	set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
-	error = xfs_trans_commit(tp);
-	return error;
+
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_trans_cancel(tp);
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index a2a736a77fa9..883f0f1d8989 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -84,7 +84,7 @@ int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
 void			xfs_efi_item_free(struct xfs_efi_log_item *);
 void			xfs_efi_release(struct xfs_efi_log_item *);
 
-int			xfs_efi_recover(struct xfs_mount *mp,
-					struct xfs_efi_log_item *efip);
+int			xfs_efi_recover(struct xfs_efi_log_item *efip,
+					struct list_head *capture_list);
 
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0d920c363939..388a2ec2d879 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4587,9 +4587,9 @@ xlog_recover_process_data(
 /* Recover the EFI if necessary. */
 STATIC int
 xlog_recover_process_efi(
-	struct xfs_mount		*mp,
 	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
 {
 	struct xfs_efi_log_item		*efip;
 	int				error;
@@ -4602,7 +4602,7 @@ xlog_recover_process_efi(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_efi_recover(mp, efip);
+	error = xfs_efi_recover(efip, capture_list);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4627,9 +4627,9 @@ xlog_recover_cancel_efi(
 /* Recover the RUI if necessary. */
 STATIC int
 xlog_recover_process_rui(
-	struct xfs_mount		*mp,
 	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
 {
 	struct xfs_rui_log_item		*ruip;
 	int				error;
@@ -4642,7 +4642,7 @@ xlog_recover_process_rui(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_rui_recover(mp, ruip);
+	error = xfs_rui_recover(ruip, capture_list);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4667,9 +4667,9 @@ xlog_recover_cancel_rui(
 /* Recover the CUI if necessary. */
 STATIC int
 xlog_recover_process_cui(
-	struct xfs_trans		*parent_tp,
 	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
 {
 	struct xfs_cui_log_item		*cuip;
 	int				error;
@@ -4682,7 +4682,7 @@ xlog_recover_process_cui(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_cui_recover(parent_tp, cuip);
+	error = xfs_cui_recover(cuip, capture_list);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4707,9 +4707,9 @@ xlog_recover_cancel_cui(
 /* Recover the BUI if necessary. */
 STATIC int
 xlog_recover_process_bui(
-	struct xfs_trans		*parent_tp,
 	struct xfs_ail			*ailp,
-	struct xfs_log_item		*lip)
+	struct xfs_log_item		*lip,
+	struct list_head		*capture_list)
 {
 	struct xfs_bui_log_item		*buip;
 	int				error;
@@ -4722,7 +4722,7 @@ xlog_recover_process_bui(
 		return 0;
 
 	spin_unlock(&ailp->ail_lock);
-	error = xfs_bui_recover(parent_tp, buip);
+	error = xfs_bui_recover(buip, capture_list);
 	spin_lock(&ailp->ail_lock);
 
 	return error;
@@ -4761,37 +4761,65 @@ static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
 /* Take all the collected deferred ops and finish them in order. */
 static int
 xlog_finish_defer_ops(
-	struct xfs_trans	*parent_tp)
+	struct xfs_mount	*mp,
+	struct list_head	*capture_list)
 {
-	struct xfs_mount	*mp = parent_tp->t_mountp;
+	struct xfs_defer_capture *dfc, *next;
 	struct xfs_trans	*tp;
 	int64_t			freeblks;
-	uint			resblks;
-	int			error;
+	uint64_t		resblks;
+	int			error = 0;
 
-	/*
-	 * We're finishing the defer_ops that accumulated as a result of
-	 * recovering unfinished intent items during log recovery.  We
-	 * reserve an itruncate transaction because it is the largest
-	 * permanent transaction type.  Since we're the only user of the fs
-	 * right now, take 93% (15/16) of the available free blocks.  Use
-	 * weird math to avoid a 64-bit division.
-	 */
-	freeblks = percpu_counter_sum(&mp->m_fdblocks);
-	if (freeblks <= 0)
-		return -ENOSPC;
-	resblks = min_t(int64_t, UINT_MAX, freeblks);
-	resblks = (resblks * 15) >> 4;
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
-			0, XFS_TRANS_RESERVE, &tp);
-	if (error)
-		return error;
-	/* transfer all collected dfops to this transaction */
-	xfs_defer_move(tp, parent_tp);
+	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
+		/*
+		 * We're finishing the defer_ops that accumulated as a result
+		 * of recovering unfinished intent items during log recovery.
+		 * We reserve an itruncate transaction because it is the
+		 * largest permanent transaction type.  Since we're the only
+		 * user of the fs right now, take 93% (15/16) of the available
+		 * free blocks.  Use weird math to avoid a 64-bit division.
+		 */
+		freeblks = percpu_counter_sum(&mp->m_fdblocks);
+		if (freeblks <= 0)
+			return -ENOSPC;
+
+		resblks = min_t(uint64_t, UINT_MAX, freeblks);
+		resblks = (resblks * 15) >> 4;
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
+				0, XFS_TRANS_RESERVE, &tp);
+		if (error)
+			return error;
+
+		/*
+		 * Transfer to this new transaction all the dfops we captured
+		 * from recovering a single intent item.
+		 */
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_ops_continue(dfc, tp);
+
+		error = xfs_trans_commit(tp);
+		if (error)
+			return error;
+	}
 
-	return xfs_trans_commit(tp);
+	ASSERT(list_empty(capture_list));
+	return 0;
 }
 
+/* Release all the captured defer ops and capture structures in this list. */
+static void
+xlog_abort_defer_ops(
+	struct xfs_mount		*mp,
+	struct list_head		*capture_list)
+{
+	struct xfs_defer_capture	*dfc;
+	struct xfs_defer_capture	*next;
+
+	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
+		list_del_init(&dfc->dfc_list);
+		xfs_defer_ops_release(mp, dfc);
+	}
+}
 /*
  * When this is called, all of the log intent items which did not have
  * corresponding log done items should be in the AIL.  What we do now
@@ -4812,35 +4840,23 @@ STATIC int
 xlog_recover_process_intents(
 	struct xlog		*log)
 {
-	struct xfs_trans	*parent_tp;
+	LIST_HEAD(capture_list);
 	struct xfs_ail_cursor	cur;
 	struct xfs_log_item	*lip;
 	struct xfs_ail		*ailp;
-	int			error;
+	int			error = 0;
 #if defined(DEBUG) || defined(XFS_WARN)
 	xfs_lsn_t		last_lsn;
 #endif
 
-	/*
-	 * The intent recovery handlers commit transactions to complete recovery
-	 * for individual intents, but any new deferred operations that are
-	 * queued during that process are held off until the very end. The
-	 * purpose of this transaction is to serve as a container for deferred
-	 * operations. Each intent recovery handler must transfer dfops here
-	 * before its local transaction commits, and we'll finish the entire
-	 * list below.
-	 */
-	error = xfs_trans_alloc_empty(log->l_mp, &parent_tp);
-	if (error)
-		return error;
-
 	ailp = log->l_ailp;
 	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 #if defined(DEBUG) || defined(XFS_WARN)
 	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
 #endif
-	while (lip != NULL) {
+	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
+	     lip != NULL;
+	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
 		/*
 		 * We're done when we see something other than an intent.
 		 * There should be no intents left in the AIL now.
@@ -4862,35 +4878,40 @@ xlog_recover_process_intents(
 
 		/*
 		 * NOTE: If your intent processing routine can create more
-		 * deferred ops, you /must/ attach them to the dfops in this
-		 * routine or else those subsequent intents will get
+		 * deferred ops, you /must/ attach them to the capture list in
+		 * the recover routine or else those subsequent intents will be
 		 * replayed in the wrong order!
 		 */
 		switch (lip->li_type) {
 		case XFS_LI_EFI:
-			error = xlog_recover_process_efi(log->l_mp, ailp, lip);
+			error = xlog_recover_process_efi(ailp, lip, &capture_list);
 			break;
 		case XFS_LI_RUI:
-			error = xlog_recover_process_rui(log->l_mp, ailp, lip);
+			error = xlog_recover_process_rui(ailp, lip, &capture_list);
 			break;
 		case XFS_LI_CUI:
-			error = xlog_recover_process_cui(parent_tp, ailp, lip);
+			error = xlog_recover_process_cui(ailp, lip, &capture_list);
 			break;
 		case XFS_LI_BUI:
-			error = xlog_recover_process_bui(parent_tp, ailp, lip);
+			error = xlog_recover_process_bui(ailp, lip, &capture_list);
 			break;
 		}
 		if (error)
-			goto out;
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+			break;
 	}
-out:
+
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
-	if (!error)
-		error = xlog_finish_defer_ops(parent_tp);
-	xfs_trans_cancel(parent_tp);
+	if (error)
+		goto err;
 
+	error = xlog_finish_defer_ops(log->l_mp, &capture_list);
+	if (error)
+		goto err;
+
+	return 0;
+err:
+	xlog_abort_defer_ops(log->l_mp, &capture_list);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 7c674bc7ddf6..c071f8600e8e 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -439,8 +439,8 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
  */
 int
 xfs_cui_recover(
-	struct xfs_trans		*parent_tp,
-	struct xfs_cui_log_item		*cuip)
+	struct xfs_cui_log_item		*cuip,
+	struct list_head		*capture_list)
 {
 	int				i;
 	int				error = 0;
@@ -456,7 +456,7 @@ xfs_cui_recover(
 	xfs_extlen_t			new_len;
 	struct xfs_bmbt_irec		irec;
 	bool				requeue_only = false;
-	struct xfs_mount		*mp = parent_tp->t_mountp;
+	struct xfs_mount		*mp = cuip->cui_item.li_mountp;
 
 	ASSERT(!test_bit(XFS_CUI_RECOVERED, &cuip->cui_flags));
 
@@ -511,12 +511,7 @@ xfs_cui_recover(
 			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
-	/*
-	 * Recovery stashes all deferred ops during intent processing and
-	 * finishes them on completion. Transfer current dfops state to this
-	 * transaction and transfer the result back before we return.
-	 */
-	xfs_defer_move(tp, parent_tp);
+
 	cudp = xfs_trans_get_cud(tp, cuip);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
@@ -574,13 +569,10 @@ xfs_cui_recover(
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
-	xfs_defer_capture(parent_tp, tp);
-	error = xfs_trans_commit(tp);
-	return error;
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_move(parent_tp, tp);
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index e47530f30489..de5f48ff4f74 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -80,6 +80,7 @@ extern struct kmem_zone	*xfs_cud_zone;
 struct xfs_cui_log_item *xfs_cui_init(struct xfs_mount *, uint);
 void xfs_cui_item_free(struct xfs_cui_log_item *);
 void xfs_cui_release(struct xfs_cui_log_item *);
-int xfs_cui_recover(struct xfs_trans *parent_tp, struct xfs_cui_log_item *cuip);
+int xfs_cui_recover(struct xfs_cui_log_item *cuip,
+		struct list_head *capture_list);
 
 #endif	/* __XFS_REFCOUNT_ITEM_H__ */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 70d58557d779..5bdf1f5e51b8 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -483,9 +483,10 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
  */
 int
 xfs_rui_recover(
-	struct xfs_mount		*mp,
-	struct xfs_rui_log_item		*ruip)
+	struct xfs_rui_log_item		*ruip,
+	struct list_head		*capture_list)
 {
+	struct xfs_mount		*mp = ruip->rui_item.li_mountp;
 	int				i;
 	int				error = 0;
 	struct xfs_map_extent		*rmap;
@@ -592,8 +593,7 @@ xfs_rui_recover(
 
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
 	set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
-	error = xfs_trans_commit(tp);
-	return error;
+	return xfs_defer_ops_capture_and_commit(tp, capture_list);
 
 abort_error:
 	xfs_rmap_finish_one_cleanup(tp, rcur, error);
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 8708e4a5aa5c..5cf4acb0e915 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -82,6 +82,7 @@ int xfs_rui_copy_format(struct xfs_log_iovec *buf,
 		struct xfs_rui_log_format *dst_rui_fmt);
 void xfs_rui_item_free(struct xfs_rui_log_item *);
 void xfs_rui_release(struct xfs_rui_log_item *);
-int xfs_rui_recover(struct xfs_mount *mp, struct xfs_rui_log_item *ruip);
+int xfs_rui_recover(struct xfs_rui_log_item *ruip,
+		struct list_head *capture_list);
 
 #endif	/* __XFS_RMAP_ITEM_H__ */
-- 
2.35.1

