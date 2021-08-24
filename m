Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B71BC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4838F6128A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 22:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhHXWpb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 18:45:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24470 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229521AbhHXWpb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 18:45:31 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OJtIwk001072
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=miuZaGiogB2oD38QvBDfFB1UvZaUdOwqv2u/7LFD2hc=;
 b=mzkfyCUSPcriD4RUq5gku9r8XwbHa2X4RH0LvsrGdum/Kl4G+XuKYs/OPFF/UVq3qw7X
 x2wVkTfzDe2xnsESW2n1hVxMT1EC7U7r+UXS2YhUnHZGWodZ02jlbXFs7WKTByfe96G4
 /YFI0MB2Z54x48cu2h8vC3lgfwlcEPCwpejm7kM2voJG/z08UeswJIdTgU/S3TAO4IoG
 Khtw/uynzo0OUqPeYoDPq4MJUT2PiftBQvMFJ9SQjs6z1xC2JuAtoavKmUKNZ8c70be5
 LKLkjSY9hcUcV6mhkWwu78InQTqdkQLrKGlIzq3ssI4ZAxSyiSkkrM1cV2IvyRE9g0aP TQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=miuZaGiogB2oD38QvBDfFB1UvZaUdOwqv2u/7LFD2hc=;
 b=rEIIiXuyt25JnYFTRPa/ImOX6GgUsQaoWzrZCqepKKuMOySZdjbTF2N7pymkDwKNqKpq
 KsLMnkmYc3hIltoMyV5yyXTFTXpzZ8jtB0+2mwzuDg18s2rOcyVX0//uAe4x+pSdLTx/
 RdBHxdOwdlX8JWBwJPvPZKYDS7tTxQVjT0tr70h6MELEO5QqSoOAjeawpZTxkJtppjuG
 rdFCVh4vfyqt0uLVIIJF6RgAk8EGMEkuePPJ9pq9DAj3ZS2XSyBkl1IFyG0Q7LoJo7+Z
 Glwyn02QZ6QVTGOv3W8ULxsWFeeBxWSLQdPtn+agIfQHpuColqOY3oLmIhf4iFWG48wj Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3amvtvt4uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OMfLTD138047
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3030.oracle.com with ESMTP id 3ajqhfehfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 22:44:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkntmOIjY2IK0mWWLgppPV8YaadYH/yEMOYruRsP/aoy75weiCkhPmL7rJJNsL3faLznPaN0hl39O5lqR0qUZdPgfK373/OefF8GSdebnkke7Sk8Qtf3xTXib7oI06hGm/v20aTx6Iw/N5EqvIQgJpdStx8VXXcwUeZZ9B0zHcdmHkMOhbnZTIkM2HJ345OrBnaCZBoDXKGBNl/6aMleh3CTnF70h45yGeAXWBWr/wb1+sV0QJtZKWeZ5Rckq+Z0yU5KVevM0721yB3sr+MW7sYdQ4dLHuDaMPVX3eYZ6Po2FLForDERPgSN/Zkpe952nGnmngbCPO2QX69kUnLrig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miuZaGiogB2oD38QvBDfFB1UvZaUdOwqv2u/7LFD2hc=;
 b=XL12PG6xJt/26Vp+7bCqo0pz5Ba8Ln4KJX3VqCEga8lF7Kk7O/8U9JWYlto2gq3hjQTcS56QlMh3eND6E6op/jacPXwmviSSPdvDRCggWiBWwUi+LX21HjuMLP86twZEXbMAepzkikX7OpMejEuC+GZUTCxumKoxEZTqysFbicN3gY6WA4FQHu9Yn2KtCY4xEJUKaoW38qWF33sdbrXHbgp0U6dTYE4c5WFhLwYNp9YHrISny9Wt+GW2GG1X2UqL3V63slDogxINtrICEWhqNkONQYwtztq2U/TPgbizmYIenhDCjhG6+Cm8+p4AzqQSqq+9PxvtkD6p0Zi5T8AZPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miuZaGiogB2oD38QvBDfFB1UvZaUdOwqv2u/7LFD2hc=;
 b=zCYyLV63RHCX8ULp1qfpxy02q1d9s1E5LXdH0NA0hYtuwQ5XPTNdkkq4kY8ORoadVie3FBXOiL+2yN2rvB4kYHkXhvCSrCJA1f3jBVTAhA6HcaLIRlNuv2JNWIIcoKWT5yKjtARlU8/GrUmAeO6t/eBvl5PitehghBSV8lN+/Yc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4653.namprd10.prod.outlook.com (2603:10b6:a03:2d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 22:44:41 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 22:44:41 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v24 00/11] Log Attribute Replay
Date:   Tue, 24 Aug 2021 15:44:23 -0700
Message-Id: <20210824224434.968720-1-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0012.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 22:44:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f96b2d06-dfe2-4b04-4aaa-08d96750c2a3
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4653:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB46536873FB28B2AB8B3CE01995C59@SJ0PR10MB4653.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Q2eW8sKcR3RSVCIcw8LonwHazTtmgGUC/0HjwlrqsFgyvDXHNz/lcc4iJE82I2GfzG5CgS7x8hFExzHsLMjYqOYVLlZx3HieeaZg+4wbv4xBsfAfl4dlmNLUHYKvPlomYf8IpiJuKTCRjKC7bBCv1ksS9Ctz1iSQVUeZ9j+PYZta1nZ2CLGrRc5WguvpdI01LnWyR+yB7DXypA6NpHuw9mC3IuTx31CMwDvTElRiLmLXKdk9fqGvaKn0yQ3P/JX6cW0ty8bYRMbVOvLN4bsJX5Kkq7zLZAxmMgl3hPVPyNTVLxwmKxNFSW8utvn+HGI4EAXPodO7CvAb4Q9D+PYDY8Y6n8F/G25uPRsoN/lKLzTCHrB2LGkcgdtVJobLDrDCtmmk9f2HrJdiOB2xRoBnbM1zuIeBGClzqDfSM1UfMwliffYr0xAuZ+jmhn6XX6dS5X1DvL0w0/joIhviR1z8r2J/1X84+hto6JJLLyG7t1br7CC1vbU/Ys2vT/Ai71W3aJG/TliZHa70prH6eHvXVe/LYM5BIlbGTHvL51IODAZNM3VRTXvRTvSkliQqwgSL6rGecMy61HUZ26iOKmmRB/HjXAPQE6dnulTFwfnoNX2JhEYT/7WDC/JMC1bo6QfnjgQuPn3ONeVXqyFb+ch0Z8kh8dFhi/Nq2s7SQLEgza76Fm58uAf4afXgE5nPEp9YcAEG1GF3hfH21X0oyfUlOZJ7uxJr5O21qrUu3AvkB2q3pVGb/8F7oLkF3+xWTTHtiTSr475dBsW0ip3as26jOE/H+6rDjKKYnExi9SrpXn9lo1W5hFsJ5CNbxn4OJNX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(66476007)(86362001)(66946007)(83380400001)(6486002)(6512007)(2906002)(52116002)(186003)(6506007)(66556008)(508600001)(8676002)(316002)(956004)(966005)(8936002)(36756003)(26005)(44832011)(5660300002)(2616005)(38100700002)(38350700002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rqWkxp+7Ntd1011ztzNNXrBQJD6kpaUWz3nIQa49JqzznpLOrgM2vx1xmJhp?=
 =?us-ascii?Q?fMdRethsAvtkqD8/F7VkHfg6SVKjHcvf8bybAoo9LwXQKSwcCbXnUFolBzms?=
 =?us-ascii?Q?is0Y+J8vPSqETWuVFuyuKv0Eun2MMVGkXYCcKk7a7FdLbbFj9vsB1OUZ9lZ8?=
 =?us-ascii?Q?2OrMxEUiV2b5ZieCJuDUMqPYR0r6BP1K781rXBIULGfphMwEykDptqNUo4tG?=
 =?us-ascii?Q?7kX9gwNQSuQDn3EhGnhRUD/ppsyWF8R60bTSZ54uAla6fI0Gj4c4BNhuEA0J?=
 =?us-ascii?Q?NrhBgj1OFOvX9u0C4uzu4eYvsprD+pfI//D0J177Yck0tf3Adq+MkKmwefGm?=
 =?us-ascii?Q?5ddycQleDObD0pNqJDwO1a1pLWREKlfmnVxPr/T+1SID+ohni2PJtrnYxhd9?=
 =?us-ascii?Q?Zz1nn7LtLwJfDNgPhoCTGdnTgMpSvkqEfaOAVjee7RB7FwE+iyAxAHeOd5jd?=
 =?us-ascii?Q?vzZf5Jr3S244rjqylpwwWsNTZrGZ/Y4tD+woIxQLo6OrripUGzTEEJwgd8L6?=
 =?us-ascii?Q?fhyhULG2q1olzraJIErq09EM39Zx3rT4Je/YlA676xVc8d5vOhKH4MrCLEsh?=
 =?us-ascii?Q?KWrQ9W37ZTUnzqsRruujKqS7t7bzyk6Yu+z3uQ+2J03YxBSdFSL92NGWUxLJ?=
 =?us-ascii?Q?9zzynPS3vxOE1Te90iQJZ07pk1GIPS1lSggDc+hyNBfjAIiCbs5Qzc2wRzMu?=
 =?us-ascii?Q?FcUBImWh/A2hEZzjA+eW7lXFXCWmb03yW3616NVsej19CbrrLfvLwfG4KL6Q?=
 =?us-ascii?Q?Ou2hfkO1jstR3nO4OErbpNwZl5owpUixx/k6sKEwidK3jG+M38KoUpvVqVn8?=
 =?us-ascii?Q?fbGVn6czmRv0eUtFVKPv6YSrDWA7SYKZBbU/Y+fY/Og1SwyD/KCX82ngMuaE?=
 =?us-ascii?Q?m+qP358PzMx/SWhsqK5xhUcGk87tazQmVDVMWHCszVvqW4VJMJOMvQifZipx?=
 =?us-ascii?Q?eoEVYzN3Qup4xpMPKmjcrWgEM6u8UAhRe+QUB0srOLHvSftPK+JK9usujQDI?=
 =?us-ascii?Q?8Cw7fjZDtBUUcAWAejPcfxE8LsfTRC+a8pAaDb4Xgz8Uk7wwQGdcZWMYn3rf?=
 =?us-ascii?Q?0iJaTr9j6dqP1NJdnPVu0II1K71Ile353Q4owjlRTa/IoWycN0d5F9wbTHR4?=
 =?us-ascii?Q?/KNWjOTvOw9aSZGapScuqKKT2hREUT2TCiiCQbFSv36JglV3BhVhEEk3DiHc?=
 =?us-ascii?Q?pNhu8S+L0Lvq48NezGIE0p+i7fi6+IM0gO05Ao+5d5TzBxnB5yGV3MDXiRKR?=
 =?us-ascii?Q?sEfuxFOq0LlqGZgGb9xKysFmlbaJkylGZDy07HCQ9/dmUfWobtWjLmOU0uaZ?=
 =?us-ascii?Q?e0RSgDYXDWyKo/A00v7UtasX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f96b2d06-dfe2-4b04-4aaa-08d96750c2a3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 22:44:41.1914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xiYmW/afX+WtTU70TS9XbdUh2Uw4jhBtEMAD1TQarSdo2wD9cAmBcAXxOlhH8q+uhjffTnTMsigv0sS2PdpYNEPjbF106diISLN3oEArCrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4653
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10086 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240141
X-Proofpoint-ORIG-GUID: 5K7IMGVj6A8LKQ7CuuQbdYfsAdvgLS0l
X-Proofpoint-GUID: 5K7IMGVj6A8LKQ7CuuQbdYfsAdvgLS0l
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

Updates since v23:

xfs: Return from xfs_attr_set_iter if there are no more rmtblks to process
   Fixed xfs/125 fail

xfs: Capture buffers for delayed ops
   NEW

xfs: Set up infrastructure for deferred attribute operations
   Commit message updated with new name
   Removed hasdelattr() from xfs_attri_validate

xfs: Implement attr logging and replay
   Fixed xfs_sb_version_hasdelattr to use sb_features_log_incompat
   Removed redundant flag set in xfs_trans_attr_finish_update
   Renamed XFS_SB_FEAT_INCOMPAT_LOG_DELATTR to XFS_SB_FEAT_INCOMPAT_LOG_XATTRS
   Renamed xfs_sb_version_hasdelattr sb_version_haslogxattrs
   Removed unneeded xfs_qm_dqattach_locked in xfs_trans_attr_finish_update
   Changed xfs_hasdelattr to sb_version_haslogxattrs in xfs_attr_create_intent
   Simplified args pointer in xfs_attri_item_recover
   Removed uneeded buffer rejoin logic

RFC xfs: Skip flip flags for delayed attrs
   Fixed xfs/125 fail

 xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
   added delayed sample to avoid potential race when enabling feature 
   moved warn_once to after error check

xfs: Remove unused xfs_attr_*_args
   Removed local variable leaf_bp

xfs: Add log attribute error tag
   Renamed error tag to ERRTAG_LARP

xfs: Add larp debug option
   NEW

xfs: Merge xfs_delattr_context into xfs_attr_item
   Rebase adjustments

xfs: Add helper function xfs_attr_leaf_addname
    Rebase adjustments

This series can be viewed on github here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v24

As well as the extended delayed attribute and parent pointer series:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_v24_extended

And the test cases:
https://github.com/allisonhenderson/xfs_work/tree/pptr_xfstestsv4
In order to run the test cases, you will need have the corresponding xfsprogs
changes as well.  Which can be found here:
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v24
https://github.com/allisonhenderson/xfs_work/tree/delayed_attrs_xfsprogs_v24_extended

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

Allison Collins (1):
  xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred

Allison Henderson (10):
  xfs: Return from xfs_attr_set_iter if there are no more rmtblks to
    process
  xfs: Capture buffers for delayed ops
  xfs: Set up infrastructure for log atrribute replay
  xfs: Implement attr logging and replay
  RFC xfs: Skip flip flags for delayed attrs
  xfs: Remove unused xfs_attr_*_args
  xfs: Add log attribute error tag
  xfs: Add larp debug option
  xfs: Merge xfs_delattr_context into xfs_attr_item
  xfs: Add helper function xfs_attr_leaf_addname

 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        | 454 +++++++++---------
 fs/xfs/libxfs/xfs_attr.h        |  57 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c   |   3 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  37 +-
 fs/xfs/libxfs/xfs_attr_remote.h |   6 +-
 fs/xfs/libxfs/xfs_defer.c       |   8 +-
 fs/xfs/libxfs/xfs_defer.h       |   7 +-
 fs/xfs/libxfs/xfs_errortag.h    |   4 +-
 fs/xfs/libxfs/xfs_format.h      |  10 +-
 fs/xfs/libxfs/xfs_log_format.h  |  44 +-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_attr_item.c          | 814 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  52 ++
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_bmap_item.c          |   2 +-
 fs/xfs/xfs_buf.c                |   1 +
 fs/xfs/xfs_buf.h                |   1 +
 fs/xfs/xfs_error.c              |   3 +
 fs/xfs/xfs_extfree_item.c       |   2 +-
 fs/xfs/xfs_globals.c            |   1 +
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   2 +
 fs/xfs/xfs_log.c                |  45 ++
 fs/xfs/xfs_log.h                |   1 +
 fs/xfs/xfs_log_recover.c        |   9 +
 fs/xfs/xfs_ondisk.h             |   2 +
 fs/xfs/xfs_refcount_item.c      |   2 +-
 fs/xfs/xfs_rmap_item.c          |   2 +-
 fs/xfs/xfs_sysctl.h             |   1 +
 fs/xfs/xfs_sysfs.c              |  24 +
 fs/xfs/xfs_trace.h              |   1 +
 33 files changed, 1333 insertions(+), 270 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_item.c
 create mode 100644 fs/xfs/xfs_attr_item.h

-- 
2.25.1

