Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B54EC433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Nov 2022 09:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiKGJDK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiKGJDH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 04:03:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF341658C
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 01:03:06 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75fMHL025318
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=EtmUEgS3QIf8cel/odhKm2nsx//jgEDbl8mBDhiCiJXwAZumNFVZUOF8R/+dGs1EYUFn
 R+7C/DQe6duSV4aLugNpuVj0saZOqMq0EsfvqyPp7eTRuxFzNdMXK1xBjsubj6fDBCoF
 hIwby8SspiDzto8K4mlTDsF5rvtq7MXf8KqvaiVoBqRokKB4Q9U6HUEy9kosx63CxLPL
 2ZmsmVYkydS/uoVbIUVj9drMHgmBKnl5AkJ9lYxShhocOYrV5Ar16L3X4AT5EvadNMZI
 O5H/hv25phDZO3F0rstM2gpXDibVqq8OLg65KWd5qt5j3/iV2g4Swh6js6LRSZTrrAFm ww== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngmj30j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A76im0I023134
        for <linux-xfs@vger.kernel.org>; Mon, 7 Nov 2022 09:03:05 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctj2kgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Nov 2022 09:03:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJtfqjaLWKBRHTFerksbG27dxmQxDyX/v5NS3YlZtXQeEWd+/WrZf53b4tqbUzZUX8s6xaFJ6jx9HvUcdAAe+CR1y6DfB7pb0rZ/aPIQcEg6JifzItCUjRe7nLMBOgulWEcxFM5m5I6XcbOb5E8hKGd0w4H6DqLA2fcUfB3lf6Txpm3K+4jX4OE+ZaqNuVFiDG3KcFDHs8rGfh9+ip0B2PbVD8SSWdo1pxatY5Wena7y8V28LWE1NWPhBTO2tqmeGkWqgXfVbI58vFTXkM8YcKOGGc+DyOSdA11by1bhZCbOTktG/qW8XsP2wWqpyxJjrU+F1LLDzIIFJequ3hFAVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=XkFasp5S+Tg9ZG/2lddXcfJrHMDtn3SENG8p1C6Griyb1REhkqIlnkjY+qzBD7GNlEMYbeab5fCkUbJVjuxp//TzrClDHNOUZCjfXPvxKMC0+iJFdyrl3gsG5U0wxMCznAIwP+p1EvbM9ceaL6ywsCZVi0sqKPxp8gYYjWt3w0z4Vrt8ugmUyVwTKMEWqmaLL/wE9HbxNXcGYjibkGAPZHEtVT0uFCOczXuJIm8eePHa57+Pp/J3s8esv1YJAfqppr7XV5j84udLONeJ6YwcWgqAnhP9kdZiqJMae6Hftc7OB8fkp4tHhrpLO2ZW39qif7s/08D6b7BNDElqPJJq1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8ANFXJemEPEl5G2uQUXpknnREMAMf1WLaiUz9lWhI8=;
 b=Rxs9l13AJ+e4l/v9kVLnCCmHsTUbSbKGh0ukkNgK6t8rrB4F60DGjl6sP8CGPA1qsmVRYu/43XUTUBBcSDN4618o4xrvqFAsccU/uTXAg8KlPxn6psNSo6HZsb4uqsW4bqBRelq2VQQVc1pTr/dOWimy8cgszSWR4QzeIf3Nssw=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by PH0PR10MB5848.namprd10.prod.outlook.com (2603:10b6:510:149::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:03:03 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::c3f2:bf22:a83d:beb3%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:03:03 +0000
From:   allison.henderson@oracle.com
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 11/26] xfs: define parent pointer xattr format
Date:   Mon,  7 Nov 2022 02:01:41 -0700
Message-Id: <20221107090156.299319-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107090156.299319-1-allison.henderson@oracle.com>
References: <20221107090156.299319-1-allison.henderson@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0066.namprd11.prod.outlook.com
 (2603:10b6:a03:80::43) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4306:EE_|PH0PR10MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: 85d8f7b8-a618-4c5f-a029-08dac09ee0c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8kc66a6Xfu3qi9Rq+aKjrWEZxI98GJQhEi+fU3ETNq/UEhr64c7dHdRaeP9rWMa1j+z+zPXonWV7ViXeL9fTWo7vdC1zYuCmm/FkUMNI38VjAciWPFuVPfpxcug9FXED+Hv14M6luwJE2WU2u+iAIvMKl6RzK/wq+XHBiLaMmUvRQKHn3U6eBzpCUu05xParOkT4veOaoIDPuNvADLoO8/dfU74csT5ydc0croGfeATrlWc4PwYeUqbVgTlpysu2BuyMInUT2R/gtnxZhu/sYzBRG2uVL9WmAzfC0w2ELHg0sbA++pUiHF9jgyU9JMsrrIKcs/K0o5TP9rrhCzeXRc8aUDvTw2E7L2WeP1dFWmJCYqeUblnV6+nLiNHg3cxqgftHQmKe/9hm1GHxrH6ccs61auRv1tw2CNaqw3YxOE/ParAckchSBB/UKqzYd1baloFqVgvvj/Ex480kgbHCMPPfeafGJP0VaV8wY4vfne9/8yYC+hk5w/MAIS3xZvHvOYXPm4SMWeWYnWbiniUnSgorJS0EYyNvVCgDOZbiDUgR8hOTfo/YYsEIpTKFQTXJdl7KtBgPXB1HDFdiAXm4oZf2RhrUSEfy6zHNy27pc3o6nKxq6EVhBkLl4GQuC4Usto6iND5w/5zoKRwdwPuCmWo2tOkjt/HrQxXG5fXLO8fyZvmy5M5Ed2h6XcB3DiqLQhNpFPa8GK9RiVE6O2t+2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199015)(36756003)(8676002)(66946007)(6916009)(66556008)(66476007)(83380400001)(2906002)(6486002)(41300700001)(5660300002)(8936002)(478600001)(6512007)(2616005)(186003)(1076003)(26005)(316002)(38100700002)(6666004)(86362001)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y9UqRqvPr0mqN/mqrT6bo2+5vCksZifBYT7Ia9UXWJsA2mzuGfDa2JJuHyT8?=
 =?us-ascii?Q?FJ7QS7o79bzDZSTXQ9XStYVGUgB54Rdu9ZMRnxPOQaE1SaJJkuyfQvb1q+4h?=
 =?us-ascii?Q?nijIvo8IadsOqNNrVs3Ph2RRsDroYDwDoqlX3a9uqIedm6AhM79eCbjkFJAY?=
 =?us-ascii?Q?kneHHlnL+gcmQMo9r/y77F9pC5jQxm315r4RZuJ1JRe1c06n1cNYD+T6G5E+?=
 =?us-ascii?Q?N143DMXO6BZ9vt0GbMj1w9QvmDcTLniz6vWXvW4aOwMipMa2rL2STX9nKTWh?=
 =?us-ascii?Q?U4uD+49XAvHb3BacM9s9sqkRG17ovqWLlxZiyXN9rqlLdNrOTAQ6FsA8Te7A?=
 =?us-ascii?Q?MaAVg3qvVGFSkuxMQws4pXvjqXftVYSrE08TflEG2Rm9uOutyH9Y3sX6drmo?=
 =?us-ascii?Q?5SqqLENoYHMkwErjN8LPJK4poqOijph9Clzlc1mKSkTvI1k7Q05ZEcI+Qe2e?=
 =?us-ascii?Q?U2D53+Y61O1IGIYj8mySjAOXr2mr67x9cCSmibWzOyELOa3mYQlhhWq+wC1b?=
 =?us-ascii?Q?UJzh+7XSxl8BoUks3jkJM0XSeGp/bqobQ57OfHgeK7QaYiXG+Ay0mPuudGjw?=
 =?us-ascii?Q?iqrR8bU0Gdh6d5d0oxw+r5CMvSr+BfeJ7aCwu6dvvSPIUbKPyqIKz2ANLOH7?=
 =?us-ascii?Q?EJ9HBQiy3jB1wIVlf+XO8qmHiJuhs+Ixs5TK8L9yswKCw1ws2nsIYsoIQ4KB?=
 =?us-ascii?Q?N5R6H716s2GCW/Vyjp6H7mfQykXhxsUYQRCkwrmPg4EK+8C86cltU1cisYZt?=
 =?us-ascii?Q?iZWVsVfn5Odb4kIzFa3sQR5dCtJWAvELvOc79EemUlQTmGTkn2+NpezddPxA?=
 =?us-ascii?Q?n+k0VvC5rveecvY59cCIKU0yQz7R0FUbDWkJuAfjq8AQUpdXCn/gq+jciL8/?=
 =?us-ascii?Q?v4jujebkaY6Gn9IvAgxF2EuaHobkPuAMcENNG2W2AeuoNQwC2u348X58DGfF?=
 =?us-ascii?Q?VBuSjIk22QlqRXkxRwNkITelYEIQtCCWHGjhjCkI3rt71A7QK9RpSMjJcVtV?=
 =?us-ascii?Q?V4LT52WqfyNklvb43EYCxvumLUcDuPipOwt0poEbcp8ac41HLVlQfr9y98ya?=
 =?us-ascii?Q?QOKTeh49MGkfxyrKoK2BGBytCa/QMPMB9zwuCZXExybWwgKfUfLHi8HxtOaD?=
 =?us-ascii?Q?RYorZJdl02YZTAFXSupWhJzuWLNRz8boMZSz6VyKdLf0zM3zASKAwbFVwWJn?=
 =?us-ascii?Q?UtwbxLCnZZtnsio2LqyLUTO81+PqrstUDH4qEjm1Xh335iZUVh8cRmn+th4R?=
 =?us-ascii?Q?dSjxl4eVqRGIaTW8WDQ8qzHZCR6N2tmLcm2mn+73YgFhLJmEr5+iWzXwZ/r8?=
 =?us-ascii?Q?M9lJyBlgygzufSFMfdtgjWMUjYw9mhonrfDp/mYRstrs+7d0BVtD5tsnDoqM?=
 =?us-ascii?Q?GD3NdtKdxSBaBBgl57HRbZu1KqLAyLspRYYS4xE7zIu7aPd61TxaV8TTL0Q1?=
 =?us-ascii?Q?Lbd5WMXDAO0fnM0O7NiBxZortbXIfm2p21HQ5L3HqvDNXdntSxO8gEnOqsDd?=
 =?us-ascii?Q?gXxdUKPbJUFd3cWDDKw2/jV0jtMfmwh39x47pGC9lxH9EMDjGpLKhY0ZJ2ut?=
 =?us-ascii?Q?gLZNNRIUmCFH9VudAQNlb4XCd8cAEvoHKU6GLWt0rG9c9+NkwhDuYDE9Ea4X?=
 =?us-ascii?Q?Jg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85d8f7b8-a618-4c5f-a029-08dac09ee0c6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:03:03.5607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uEXgwszy0aZHcJnMOyWMcVmkVarabkqfwml0xKvWLKu9n9G4MNuYWNVUjprG67CC+1T6iWLRX7Q80XKfZCxLG1wbcfSov975pXsO/8z/8UE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5848
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070076
X-Proofpoint-GUID: 0Bh6Wp46CFw8PJyCReGK5G8trmsME1h_
X-Proofpoint-ORIG-GUID: 0Bh6Wp46CFw8PJyCReGK5G8trmsME1h_
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

We need to define the parent pointer attribute format before we start
adding support for it into all the code that needs to use it. The EA
format we will use encodes the following information:

        name={parent inode #, parent inode generation, dirent offset}
        value={dirent filename}

The inode/gen gives all the information we need to reliably identify the
parent without requiring child->parent lock ordering, and allows
userspace to do pathname component level reconstruction without the
kernel ever needing to verify the parent itself as part of ioctl calls.

By using the dirent offset in the EA name, we have a method of knowing
the exact parent pointer EA we need to modify/remove in rename/unlink
without an unbound EA name search.

By keeping the dirent name in the value, we have enough information to
be able to validate and reconstruct damaged directory trees. While the
diroffset of a filename alone is not unique enough to identify the
child, the {diroffset,filename,child_inode} tuple is sufficient. That
is, if the diroffset gets reused and points to a different filename, we
can detect that from the contents of EA. If a link of the same name is
created, then we can check whether it points at the same inode as the
parent EA we current have.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 3dc03968bba6..b02b67f1999e 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -805,4 +805,29 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/*
+ * Parent pointer attribute format definition
+ *
+ * EA name encodes the parent inode number, generation and the offset of
+ * the dirent that points to the child inode. The EA value contains the
+ * same name as the dirent in the parent directory.
+ */
+struct xfs_parent_name_rec {
+	__be64  p_ino;
+	__be32  p_gen;
+	__be32  p_diroffset;
+};
+
+/*
+ * incore version of the above, also contains name pointers so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dir2_dataptr_t	p_diroffset;
+	const char		*p_name;
+	uint8_t			p_namelen;
+};
+
 #endif /* __XFS_DA_FORMAT_H__ */
-- 
2.25.1

