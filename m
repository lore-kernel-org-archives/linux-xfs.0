Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E3BC43216
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5935D6112D
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 06:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbhG0GTt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:19:49 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47236 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235103AbhG0GTr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 02:19:47 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R6GEfd024383
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kiDyIO2fQL1a+p6wS4Mq4fwmpcxMFkzeeIfEbOhnLsA=;
 b=pE+Yydjd2FPXDqTSOKIC9aC9UzSEKOY6ydYdEEIlqR7ZIBtwU+0FynFGgVVxDJeSIdPp
 6A15J5OaRhYwROpZw/GIDlH86ioD/cTJFgk51LQIzmOPX3p3dJL2b9HlTqUBCZbQWsCS
 nZGO9so/VuLsswC7nI7o+SiR8mNbpayE9vBIPoqOuU9N94Kd0fSqmfQ21S4siQEO/rAz
 YEerXVGmfGH2uEMPoc2FSpAFsH2Qelrvif5RZAn+cQ4kucgDqreIGivJNzWtQXqTdGVK
 7gQDyABgZlucWBY3BG3/A62h4nlGRynL1ZiT8Mph3mwr23jWGEqVDrto1NcsjRNbVFbk BQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=kiDyIO2fQL1a+p6wS4Mq4fwmpcxMFkzeeIfEbOhnLsA=;
 b=pKLjnX7EytuTTlpJoPFyMfbQu4aNidmzlM0VQiWVKaZ01y9C4ODufMKv2Hjzdy7LsQrp
 co4SZ3PA3maomH3pLmfEYraRlfyvZ4Kg6xp43xCyfeqhZrwsKgysqIQkiIIw+c5g7WgJ
 99NkpgbzlnYXk+L8uC32+SrwTRwgPdZ9ljxw4uZHK9xSD7E808B9M7/b0wuftFgPR4A6
 tR/OMXBCQ9uqzA0g8wQNcZzEF8dx6MJVbtGWtdnFA5fdrdRZ5RDaI6Ev2a26EuGhhKV7
 iejF70hR/T2rALCWwxtRDk+13mEvt5CppnhuDoDScLoMiDOJoKhBo1X4aFrlonXpz5h7 pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235drun2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R6FUJ4019917
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3020.oracle.com with ESMTP id 3a2347jxeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 06:19:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3wzUY06RY8ngjBuXQpG9zXC83p0gvJstv1mL4zS8245dUeY0a/Ab8u0FAVgOE9fT4zkolMG7RdjJhqgdHeKhzl5xmREr76yz4KtAI3IK0asSITVRW2+hMyY1uGb2Y56ZH1dJw3gVIUXaOnmoLjEVkmS1cMUoWmhBvabkjIMOTf6jpplH0V1PwnR0DF5N0UwNQ1Td+53gcrH+vwiPUI5Pqk5kKf4nEQ7iScCJg6oHzDGBzpAL01hKudgRYW2eBaYDtzuNPN+Ta0oAypl8ByoYNd9lmU/tedXizH48ZSpJE6bYgBTEoO1Ms+O+pDrauJ3WMMafYX4QwVQiDaPPBQBSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiDyIO2fQL1a+p6wS4Mq4fwmpcxMFkzeeIfEbOhnLsA=;
 b=X40BCQ/gs9Y6TYHw7R0uCjLrM/R23R5EEu25Xdf14MvwKoGmQKMB4VxoM44H1/6Xb3s08oVuLjz2QYROhPdv4TDXgLnzNTIf2IjtcAMOGh15XKH3W3iOWnlxsZESxnQ2m4xRQaqmv/5mcwgaP3PzNmQ23AtdygqlcqA7tt4mMVlfobbXd45pE0PjeSBjcwnMZqGyrD7+qUgfxDSPjCd6MS7SxEUhN+O6LY04+IswtlqN1te7glTXtkLlfO0hfJOlxYOAeAtb3jc2/2e+Bx3hhLvhiNRHZe4vJxmGbZV7GgTKb7j6R0S9JfgLQFEtk79X0RNaxAVcIjyIs67rNelVEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiDyIO2fQL1a+p6wS4Mq4fwmpcxMFkzeeIfEbOhnLsA=;
 b=gZUYL0VZguwy4F1/LkXMfut+oefd3zOBjCcuBxkAwkIX+NMocGgtpzkKBmuvwgqhpPcJCHjTr+p5mW4Jq+vE4ncEumMijwQDKfvdQ8+mQ/IcXwAz/2zrBkYsCucSEqz1AYZ0tDMlxCE7TksXiB6pOENq5r/dzulBkj0OZHr39Tk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2791.namprd10.prod.outlook.com (2603:10b6:a03:83::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 06:19:44 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 06:19:44 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v22 13/27] xfsprogs: Fix default ASSERT in xfs_attr_set_iter
Date:   Mon, 26 Jul 2021 23:18:50 -0700
Message-Id: <20210727061904.11084-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727061904.11084-1-allison.henderson@oracle.com>
References: <20210727061904.11084-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:332::19) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR05CA0074.namprd05.prod.outlook.com (2603:10b6:a03:332::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Tue, 27 Jul 2021 06:19:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35c0a500-c384-46af-fb9b-08d950c68682
X-MS-TrafficTypeDiagnostic: BYAPR10MB2791:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27910D579A3261A70B20541595E99@BYAPR10MB2791.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lQogbXCzJ6NFs6y9WeI3gs2TLABtdAUFXzKflIMR3ovejTZyw3zNGTkFe+UZqnCoObDBd19G4QzNBOY684zL8Cmw97wPXxg7kbPCP9rcBjVnDcMdGL1WY4VhNy3W27CvYM6k1melgWiizJFXBpUsTw9YP/2nBSk7q3TwRz6+jWzSjF/O65LcgvkcdP0ZySgcbH6zD26VJ3vYZQP0WZCG9wNjsIqfg13yckUjvYhGD4Q+DNdLh2h5BlhCKXrMniwCstZlV205GC+ZzdmBWDfw8v9KXQG+zwZjWf68ihkzjTmXGpb05mRqUcQAbmi7TaN2zaa78Hi9DZYdIq/RlQKUK5Tnr8GdWMJ2GTmKDezFdKqLY3RdmMOS05uXaWHrg4kxTmq5JpivdbEOIjl4Jtf5Y8IkleT04x8B3CG6eCXW3x8EOCDR9S2b+zJD2McYc5vzPFTTw9RBb6ehfap3mEG81Ca53HziYLE2CCcmmBNFTiqHZs3SjQ75E8xXc/s55CwtSyuebzQai7FDu0aRqAVPZglcn1IvzXywwpyWK11xgBdU+kacCrWRbx0C4hZwqmvYbJVB+uUUdZXGRcr9aXJ7RRXYepIspj55PoC7xkO5KnWT6WI9RiCQAbddbzsnq4uVj3NwQQwLkWslAp86h55vkIUyl8YxLCjSQF3CG9wKgneoh7O77iEDvBG6PaHW5M9zCKYQO9F170b6TrRCddAUWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(44832011)(2906002)(36756003)(52116002)(4744005)(86362001)(6916009)(83380400001)(8936002)(478600001)(956004)(1076003)(38350700002)(66476007)(6512007)(66946007)(38100700002)(66556008)(316002)(6506007)(6666004)(6486002)(26005)(5660300002)(8676002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Af+xzd85iXK3hcLe4Psugdy60qMOfIEvItgy1MrJSk6udNVZvXp9ZmjXbnaO?=
 =?us-ascii?Q?9sI/0BNjlroSORvAc04qEv03qzE1d90cu3QjH+VzBdl52OwWXJ2ujEQqbuuT?=
 =?us-ascii?Q?WSMMKaxZcugdaPD0H5DWgaJhT6xAuYcfxFxzE2ibI/bRsiraXO6R0hWPyplz?=
 =?us-ascii?Q?6sbWY3fNioiaZnlsNlmXzdJuyifaz4g3FUGAT1WjyTaVy9bHNaIYgKscW0Ok?=
 =?us-ascii?Q?t3yjVyQNPqsJAPrzRCcW9mQ/t4JwmEOjIq99uZBzvENQU1ZOsfsEv48IubHj?=
 =?us-ascii?Q?OnioiKnJXHq6TMsvQ61od11Ge8SLeGKzeyBXF1TCu54nI7wyX/DH0GW1EtZK?=
 =?us-ascii?Q?4+36lya1+4iwsEeM31Nm/MTzgpUub4fFkay5jqFOoaNpfcYsZz1ParvijOVu?=
 =?us-ascii?Q?bvUcw3J7bLRTqDtwiWc8ae9n+0Q1YN3Bv0gD1Xp+sx0KGMt9Stsn5c1w0oTP?=
 =?us-ascii?Q?TbDf6bIyAGjo8XgejPswr7RHDXZsGw81qf0yDw5p3Nn9j/SZ+aHJ3drS0Et7?=
 =?us-ascii?Q?cRVvhzM/Ab15sMKDK43y//5GkPDl8BSiNqPQJB5zKAvS1vrZcXk0ylUtBPmo?=
 =?us-ascii?Q?CrTTA+QUEBZFq5kBDYJjeJ0o2g+TA5xRbsnCtPXD+Uh4JrOc7y6D5mUr4PLd?=
 =?us-ascii?Q?bwInthcCRJKRdLlt9jY/vIVOveAQQ0M9RKNNCbdSGaCpTe8Jyz3LxXbP0iFZ?=
 =?us-ascii?Q?nP6jbJJkV27eKeIntd5qTwRod1TJtC81k6t5mEUNowYUTeLbfXRI+Vhd90SG?=
 =?us-ascii?Q?ptddRSoC4MfQnAmXSwQIXwE3INcky6xlFnyU8qgn6YB4FkDvdHF6ZRSn6D07?=
 =?us-ascii?Q?2vlMNoeJC36L/A8FPik7qEQA64UIIAaZVknp3FUMSZBXjcciBM377FfnK6Eh?=
 =?us-ascii?Q?W9BYSE93YPK0KRtJpzp1U/T50nQSR2qxjPWSPcQ4yx97GG1ZxF/rfrcJUOsG?=
 =?us-ascii?Q?1J5okRv2WyMomxWEb9xJGtlR7qI0116VSdbSPeWclC+uzPaqzQsGyl5vSlDo?=
 =?us-ascii?Q?7cCISl8QiuPDCqqfcReITb+kSne6fFQi2dMlz83He9o2LJ8jChsjPBHuCLDO?=
 =?us-ascii?Q?6ncU4l7AicEEqw3lNvIT0ki5mB6SGeV23CVwEFZsdh3uofR/rKK9sZYrRQ+J?=
 =?us-ascii?Q?j8915jv2BsMZ+NrDOfLcsuoq9BKfF0Tx73YWYucTEBYxirhRQn1lcsXrGVEG?=
 =?us-ascii?Q?Jhz4DNmg8cWLK7ivh4TUa7I7ACnK3jKGZPkQNCkaqL5SvUCx+B9VqgfRP8MR?=
 =?us-ascii?Q?DU7jhW3AHFKwnffbFkGsuJ+My3Fk76WBE1/ntgSIdFoL2hSIqyl2hG3/eXHX?=
 =?us-ascii?Q?5UHpX8s6WrWnbNeMG9tM/b49?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35c0a500-c384-46af-fb9b-08d950c68682
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 06:19:44.1895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ao73fJ3P6VAbU4/mX3nq8giDXs47CDMqNN4ZuoL1yynL0L4SmdZ//SNGtpuklft0IfhQdZrpECNAjaSgyxbhsdL0eUXMaymLlZZSFNz6vs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2791
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107270037
X-Proofpoint-GUID: D-2QWT0rdtVaC2v74FclUNjkSkWbWwaA
X-Proofpoint-ORIG-GUID: D-2QWT0rdtVaC2v74FclUNjkSkWbWwaA
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This ASSERT checks for the state value of RM_SHRINK in the set path
which should never happen.  Change to ASSERT(0);

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index edc19de..cbac761 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -612,7 +612,7 @@ xfs_attr_set_iter(
 		error = xfs_attr_node_addname_clear_incomplete(dac);
 		break;
 	default:
-		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
+		ASSERT(0);
 		break;
 	}
 out:
-- 
2.7.4

