Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A0A4C53210
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Jan 2023 00:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbjAEAh1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Jan 2023 19:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241151AbjAEAg2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2023 19:36:28 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31707BB4
        for <linux-xfs@vger.kernel.org>; Wed,  4 Jan 2023 16:36:27 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304ME18a004538
        for <linux-xfs@vger.kernel.org>; Thu, 5 Jan 2023 00:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=rciOqpHFBPOEXwmYiVHmEkyV21iA+ydaAqt2tLc8t6w=;
 b=vdIAdwI0O0MmUjXZiPdmcfHhlGv8qu/pJoD8B9lMnxvTiyzydrQYgIMdOXJlsqvyUg4U
 7+KY1C3is5nx5vuY28/SDwT7C4hQFBedL2Fh5CRycLGHAzc2Xctaw0Iugs5rYcRRMy+1
 72Hoyoh6MY8e8sHYHAe+Tlt7DDfouEsF+rsI/rik6UsVz0TX/c4XWWhbbKafxLlG8xzz
 jHGXryYnxOkSyB5LqfCstAcrss2YZ5j+qS0B0+a/o68EEC+9cEtf1NY+hMAVQgL9M9LC
 bSkBkxJ/aWFLvTHfyusYcO1j+0FWf52Lakb1Jg3gdekpB7Je/x7efjBGzasUAwGevOTc mw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtd4c7x39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jan 2023 00:36:26 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 304MFMm9031216
        for <linux-xfs@vger.kernel.org>; Thu, 5 Jan 2023 00:36:25 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2047.outbound.protection.outlook.com [104.47.74.47])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mwg377ym7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Jan 2023 00:36:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtZnHCDLvotzDEovIvzqVe9EW1dFcsAziA9QqxI9cNDn8un2OxhPl72bPG3MkavJfhni5TV3ZAFHmMrfcUx60EfUIoU36pcBRKB8w3X7JYrZhwTNe4uP6a9OQQEEtCUGrSdU7TZXggzjDxDWhj8EZ+4ulqGP0F3dlQgYN1XUDTJzNI/f/ixlMFT7pi6cPaxbIEPohNoUNHJPzYA85bDxmM/kn70CKdUFdGlc+iNhX6mBPpgcdyZsPf8nBSQEfHsFby2/f2DnvYVE9vYxxNEpv8L6F4ensLvJLmQYX1QeJKJwiTp2S4kzdAOn7eR0rpnhQosHN4X+Dy7jP2FJu0G+aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rciOqpHFBPOEXwmYiVHmEkyV21iA+ydaAqt2tLc8t6w=;
 b=k9pA8+xgqEhVSH6Sf0zOH2tQIQOXpiLneFfF6xOXuFqAD2RVoezBWBxwXw3ztR6g49e3C7/OCPzcIguBsF5lRlGTlpfzNsjhgg4znZDxAyN/MVllXIsQNxITq5m9a2tpifX56RnofB88BPhID2+bRPQjEqoCP3vnkzgfBPwZERH61rp7W6h7OSUANYUUgRXPseQWK5/dyeiw/8nBUq/eSyXBSheAny40dispZKAk+SDeVXac7Vv1gpUwxZwUWhKByI2PdXI8lA/lN9pTstLBJaC0nHc7s7qzvGzjStUYBvuMtZaufkT7/LquuVQcl3/szNtEWBSbrNVkaKWm0RQACw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rciOqpHFBPOEXwmYiVHmEkyV21iA+ydaAqt2tLc8t6w=;
 b=LvWHaqaBfcKUgJh51GBMRpDRA+g/CMelupce984+WY4T6EYfD20FTf2Fh0lt46W4NJ7Wnpud6cmecz/464LDn9OgZy2wzGMKJ4Ite8KEcFgkVB9tla1+JXat5k23dSMbv7JnjB16paNhItdqvcnvBHhCt0eRdGiv9cjlt5cKhY8=
Received: from BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6)
 by SJ0PR10MB4622.namprd10.prod.outlook.com (2603:10b6:a03:2d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 00:36:23 +0000
Received: from BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e]) by BLAPR10MB5316.namprd10.prod.outlook.com
 ([fe80::6916:547f:bdc5:181e%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 00:36:22 +0000
From:   Catherine Hoang <catherine.hoang@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 1/2] xfs_io: add fsuuid command
Date:   Wed,  4 Jan 2023 16:36:12 -0800
Message-Id: <20230105003613.29394-2-catherine.hoang@oracle.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20230105003613.29394-1-catherine.hoang@oracle.com>
References: <20230105003613.29394-1-catherine.hoang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0002.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::15) To BLAPR10MB5316.namprd10.prod.outlook.com
 (2603:10b6:208:326::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5316:EE_|SJ0PR10MB4622:EE_
X-MS-Office365-Filtering-Correlation-Id: 003b5108-5c6b-40c3-91e0-08daeeb4de3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nCeIodof25RH7ih7OFU+C1DLCTvSuVUDfqQaQNF7Ak6+Fu+0Zc6JD6+5XhpKmL+aoyx5sz++04i800agL4vfkSymqDBnLDBuDd4B9d/0Of7BDza2D0V7yT7agCxhNs7fSmqgBvRSdLPpur4fTMvDVXrAaag1GcibeCmIjbwwPqCkfFHp/ofTDacR3gPQUrAtwWtqPO04LECW3tP0KH3F7Y7het6CgSimMbKB0DbSNBonzdyVn624Xn/Ep8Y7bSazGy7Lpa7CQq9Xx6rZwm3d9l16LgtSfS0if5YXRpZ3G912G987CBIKdv6JM+pTGm9xd6otOQ5FPU2VmTHhZvPUQ3FW6gf6IlpDFEfs37I73RyN8MEVPWwfONayevx6yc3hteYU33xuHGdvjXI6+bIDgkE6HnRhQA/+vqyT4k+KJYdykN/O5fkonAklg/oDYOyKjtfCXayCGxMPymtAgF1sONphDWYmZgMiUvpelBuK91q9hUuXLt3pifWkgT00/p6kymp+NtBUmY3T+ix4QAgGU1FdVryunx6drnde6JWPFUgiwUxLzkiixxiRLiGeHgg/uvZjqxJQROXFlYsR4ulT8HPSHdPtqPBvQkbz2Ktfgs4XcpUOPm24LQMIT2Z/cLStqJrQ+Ug6QEsP3BDtf3I4Fw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5316.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(346002)(136003)(39860400002)(451199015)(6916009)(86362001)(6486002)(6506007)(316002)(36756003)(186003)(6512007)(83380400001)(2616005)(1076003)(6666004)(8936002)(478600001)(66556008)(38100700002)(2906002)(44832011)(5660300002)(41300700001)(8676002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x7a2jXp082LOxS17AoV8exXjRRvjylME38BGpQUIu2ZbcmRaN+WlwqfxoY/Z?=
 =?us-ascii?Q?wwIWsU7vlZnPpZ4EkZQcoKR4FKLOcXSHZThQhFjRpal0oVw4rJlIPYa/ryl+?=
 =?us-ascii?Q?uOCAvuNtJVeNcY2kZvZf4DQUxXGj1dakVqsLKQy96A0rVPsOOAfL2wzmkzKE?=
 =?us-ascii?Q?c1SZiPx9Qo0rOIGcRBsUPRMcJL8m1xSXbfFSwyl5FSsgIc6ktVZfDbHM6Slg?=
 =?us-ascii?Q?mSL1Vqes1RaSuHn2k9HytFRpsEwwwuGtPR6fJ3lMHub8KrCD8yuPjAEUjkyw?=
 =?us-ascii?Q?FIMFmi9dZRPoUrkLF8KTrxrOCD0kl0CJrqOIppvC4QWsxPScwpoBepDG351N?=
 =?us-ascii?Q?vgprNeILKKAF5QtCVNuuBe9O6VSs6rAirLJ5VhHBuIfYRtnZCzKc3AFM0pQ2?=
 =?us-ascii?Q?/jas0HWslUA4c6jOas/LEfQtUo9xPXiTqUE4oleBE9AY598eq7mCEGBxbrrL?=
 =?us-ascii?Q?4h12ZGaqJ8JAgSc6RAkxabLbVJVfgYm2fVA4i3ESS2RMSfH1RvX+8cxIHvB5?=
 =?us-ascii?Q?ANWv6NnsSeyRjU6H2d/yUqfML2qRKNe2bXXLnNbat7whUCbqVa7lVgT6VVG+?=
 =?us-ascii?Q?8wpmQgPT+FaCDSKCHThq3PQJXrHlOqBROb52cxdbgBzg8i9wQEZ4qgKAmg2Q?=
 =?us-ascii?Q?OsQ6JdDmtNBkX70/TlgXl/+S6clX8jQMPWoOalR3di6/2szbUXwXtWkstgxE?=
 =?us-ascii?Q?ECRX64Kjh1MS+GsFI11PL+aRNBj9SzzaC4IRD33fQi6Zr6duzIfB6CW1epwx?=
 =?us-ascii?Q?Zwp40RakImPUBVl6BJzS+l0BxF+rBoXGBjT34lOy8Fh4R8de4BErCeyzd/5r?=
 =?us-ascii?Q?ai+tVrTYLdczBSflcA2SbCC6j2wH43MAl8xwNeS9xtTYv13x47MXtrrIA/9A?=
 =?us-ascii?Q?HWc9H1YUNTojL3a7GsMFwDJ1cQyxNmkhKQyeP7uBXEV7ZeOtMFt0WV3aZHnV?=
 =?us-ascii?Q?6xCSBVpWWkpA+zwPY1T/8CkPTOmKuOjIauNwD8/XKyIUGiaDTatalcPMsojQ?=
 =?us-ascii?Q?lkvCEVSLfTY0QbuNVvU4FKO2WQnIN++qFTZSG/rUrnRD2Zd1aeRdoFcKSr6t?=
 =?us-ascii?Q?6LLRxi2Ri3Synh0u8h9dydY1ZPX23BhbipKMn+BFwv+RJKXbGsYEMOXNx8HP?=
 =?us-ascii?Q?L8ZU/N5YB0d4FWlAObq4Leci3TH+MKzT/ApaL7E42I0jRGrdT1mEKdc5qYIT?=
 =?us-ascii?Q?qlypdMyVlanyr92zcQBcVQmvZE1jrIEEIub8KCyIAteMtOuPT5w+59ivHukE?=
 =?us-ascii?Q?9tpQSarQVYvn+7Qri99FkyJiuU3BiWJ+tF/kv3Rt/UOaNcyEKmAo+Xe4MLC/?=
 =?us-ascii?Q?gnGzYGBioxeGOvd8oTF4WDrSzlGFDMzbgtSPIkd8RQOkTGoztTwlWtzs1j+1?=
 =?us-ascii?Q?/pdxuxtXvPL0H+/sY99B3j58tCSH7wS7CA92Ifa6x1qDqqMwim9xrx8MfB51?=
 =?us-ascii?Q?fM38hQjnnCf1Kwbq4LMp3E/+NGj8QmHLCH+NeTnn5NaVspMteUpEaeHHDvlx?=
 =?us-ascii?Q?4fSoHnjIz36Wq/0yJBtleJpODBP0tEj9U7rTMMa2Obpii7pl+ZRNFk4nQUkl?=
 =?us-ascii?Q?XbKQ+ulLXwpf95murRme7bUau+pzY/wjKilKkY8KW2B4lI7jLy3UCOu10udg?=
 =?us-ascii?Q?4E5UEp6hr+t+qAtmgQRorKtpXDKcteQKYQVcL7WycdMiSLZcsGSQQfx00P/f?=
 =?us-ascii?Q?opcF4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ROXacL8idd8OMEwHc9rQlpOR6kRIF/zHjZXMTCRT343a2Flot15hi9rX0kmxuUeSAiX0jafmHMZ5yIZugQo7njZpI5Cy9mIlQ/IH7rLEi8buR+VhLeDiswgtT8ibccVDn9Uv07CUkN+6e/Y0L9hCxyq4I8SU+z54nbkDNb8GB5ZPUZx/4rgYDMNF4U76h/BUBUA3F9auLNv5uILkv5gO2PrEm9fOnStZ/1Ejy7GaVDeCRme6FYNfqwFbRHE1cRcHP3iT/9/SibGTXj0qkUKOx1ztRgVdVRYe8ycc5VuED780jcr8hP1yB6/5ftq7lQHSsej2o6sxVuqeQFngMe9nnhYQPp4fuziVAWkeTVYbzEBI7BLHtQ6sDoQvR3QJLCuHq68WTDfYud9YGR4iGyAiw2svkxJupF21JF+2ONxo81i/7KE4hi78Rp4Se4LxIRVpqn55Tv/MN0TX/E4UPdc7K9dGbyCw/8ZsL3dm+pttINl08EBMR4ytJO0ZsRimafMxB61Zp/P1GVqbk9V+9yPOLaTvRVHgtcQ/nzTyl6xBEsk3n7QsvuOYrX8kD6StnAtyJmFLthUnRC52CIT4bQnSEPMHAobtc6AJPkwBNlLRDN0eMIZ09xZEgT8/4H6LqSSx14WMs9ysxdmq54hMv23el0bBKwOP+yu0CWYKUgD7bNLgxtAydG7VljJBsK1D014IMtZym7AsSqd4CmCOx03vmKJ1L/BgEiacES1ZuTBqcNu2mWsmT1Oa3auUyth9gYixgrdujsA/md0aUwAAVTjA5w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 003b5108-5c6b-40c3-91e0-08daeeb4de3f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5316.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 00:36:22.9245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tx2bH77ybdZL5yFaF2XHGGDyk9pgRAu1anG7FUp54ZfzOx7HQPaucuU+Y3FkVMo8Fw3RPV8fWXp7c2hPa4MdqidBZKceUAVk5x//u8/f5/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050002
X-Proofpoint-GUID: xGT9TwP81Rdrdz0-wpicEHoxvjeYZJ2e
X-Proofpoint-ORIG-GUID: xGT9TwP81Rdrdz0-wpicEHoxvjeYZJ2e
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add support for the fsuuid command to retrieve the UUID of a mounted
filesystem.

Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 io/Makefile       |  6 +++---
 io/fsuuid.c       | 49 +++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c         |  1 +
 io/io.h           |  1 +
 man/man8/xfs_io.8 |  3 +++
 5 files changed, 57 insertions(+), 3 deletions(-)
 create mode 100644 io/fsuuid.c

diff --git a/io/Makefile b/io/Makefile
index 498174cf..53fef09e 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -10,12 +10,12 @@ LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
 HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c bulkstat.c crc32cselftest.c cowextsize.c encrypt.c \
-	file.c freeze.c fsync.c getrusage.c imap.c inject.c label.c link.c \
-	mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
+	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
+	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
 	resblks.c scrub.c seek.c shutdown.c stat.c swapext.c sync.c \
 	truncate.c utimes.c
 
-LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
+LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD) $(LIBUUID)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/io/fsuuid.c b/io/fsuuid.c
new file mode 100644
index 00000000..af2f87a2
--- /dev/null
+++ b/io/fsuuid.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2023 Oracle.
+ * All Rights Reserved.
+ */
+
+#include "libxfs.h"
+#include "command.h"
+#include "init.h"
+#include "io.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/logging.h"
+
+static cmdinfo_t fsuuid_cmd;
+
+static int
+fsuuid_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_fsop_geom	fsgeo;
+	int			ret;
+	char			bp[40];
+
+	ret = -xfrog_geometry(file->fd, &fsgeo);
+
+	if (ret) {
+		xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
+		exitcode = 1;
+	} else {
+		platform_uuid_unparse((uuid_t *)fsgeo.uuid, bp);
+		printf("UUID = %s\n", bp);
+	}
+
+	return 0;
+}
+
+void
+fsuuid_init(void)
+{
+	fsuuid_cmd.name = "fsuuid";
+	fsuuid_cmd.cfunc = fsuuid_f;
+	fsuuid_cmd.argmin = 0;
+	fsuuid_cmd.argmax = 0;
+	fsuuid_cmd.flags = CMD_FLAG_ONESHOT | CMD_NOMAP_OK;
+	fsuuid_cmd.oneline = _("get mounted filesystem UUID");
+
+	add_command(&fsuuid_cmd);
+}
diff --git a/io/init.c b/io/init.c
index 033ed67d..104cd2c1 100644
--- a/io/init.c
+++ b/io/init.c
@@ -56,6 +56,7 @@ init_commands(void)
 	flink_init();
 	freeze_init();
 	fsmap_init();
+	fsuuid_init();
 	fsync_init();
 	getrusage_init();
 	help_init();
diff --git a/io/io.h b/io/io.h
index 64b7a663..fe474faf 100644
--- a/io/io.h
+++ b/io/io.h
@@ -94,6 +94,7 @@ extern void		encrypt_init(void);
 extern void		file_init(void);
 extern void		flink_init(void);
 extern void		freeze_init(void);
+extern void		fsuuid_init(void);
 extern void		fsync_init(void);
 extern void		getrusage_init(void);
 extern void		help_init(void);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 223b5152..ef7087b3 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1455,6 +1455,9 @@ This option is not compatible with the
 flag.
 .RE
 .PD
+.TP
+.B fsuuid
+Print the mounted filesystem UUID.
 
 
 .SH OTHER COMMANDS
-- 
2.25.1

