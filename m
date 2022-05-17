Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79ABFC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 17 May 2022 18:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbiEQSUl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 May 2022 14:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiEQSUi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 May 2022 14:20:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C13506EA
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 11:20:36 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HHSq0e019293;
        Tue, 17 May 2022 18:20:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=v7N1f0plAQgJQ3x/iqzN3u+WCLDPK0Gk5o2aQnVhoFo=;
 b=WVCUuPJN3+MadbzbwNaxdfXjjR914kPSpm19phm5P2OIXOmiyy83XKC4ilp3geVSUiK+
 KtkhO2SfXdv8UYgIipZtn/JRzPC2I5rXZubdiePwQmCRmYJdv+woc+2gquK0aBLhCfoe
 2air39nWd8VWM7h6ah8kqYyJSjct8rZjhA271T0JxN75qE9oiveE5bVEEww6XmZctZu2
 M/CSCNdZySXAcJARACErMzH7T/09SAx09rm0VdMFOMmrSNS/b2wMPLJc9CdgthcCOdMZ
 oB9LQ9AWzApOfUmz6OTJGDuERvnBX3Aon+qnct8dx06J8aJSCS9TDYdftdI19H7IaT5R wQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2371y824-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 18:20:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HI52Vg037344;
        Tue, 17 May 2022 18:20:26 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3dv8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 18:20:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M04rPXeFBe/jiyafYf3tgK5pctiLvBbfMn+RYPLfGZqU+QNYn4SRN0/Z5XhlHDhrws21N6etY/SgKclq9OqqQc4XCq/KlofO9ht2U3KPkY9ZGu27vXERQvwX/OKnK1/xUwA/rSpj9dEieNCiODJPRTMzRh0Odq7ip4aB9RKN5OwdNhQGyQfO2sl+v57N++QvmZhIaMIgZWCIRYBuqSJ22mQ7inM+57EHIPeYaPXyx/FwVVCqRoWvn6tUs6GOpAfP3CHNQzJErKYmz36hmq/YFUCem6ZjRYT2ifl1Nr7RIffG4ur7tH79fgFXjgxicFBHyL1wVVT3Xm9m+tcyPK54dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7N1f0plAQgJQ3x/iqzN3u+WCLDPK0Gk5o2aQnVhoFo=;
 b=QHjm2dChMh7+QIp+LqVrl9OiU7hfQ8a9gqMBE9JbRiU3WhxLZKJ+Z4gYE1EfOclqri6vktoI/FvMbxwfhRRuVRVEh74yS1OmQFzAc3t1NWZgH1iZIx1s6gBpQf5vyfH/6FwE+ohyGa/ZlHypAFlJ2CPvk6+xYonoSa9fA4Eo6Gt8Smjg9ZD0DquheqxgzsALHtNqm6eROoWgj+cVI+XHBo1zNo2WEw70UPnrB79E8qazDLsq8Vmp58gpr64zdOcsurcDTYI3CJlpHjYCx4aH1wCfRjdwFGYlD1s0t/qP3WBAfsIu7FVKrfvlU33qEv7jU3X3fdAOqcu8XPGMNDuudg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7N1f0plAQgJQ3x/iqzN3u+WCLDPK0Gk5o2aQnVhoFo=;
 b=N2E6k9gZEWvvS7sn+6Rs96jhnGT4OYxeh/8QHJ0qEn6pGZATTlL08rjEH9dPiZB2YV+aoAkDx9opGQmbkkmMXiezt/Vx03MpT9LR4gdSOU/Jc0784k5q7Un9MbfqT+ab6js0EuNYIOssRmeqhQ+ekmlIDIrcwu/gK4gmWvBPUV4=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by DM6PR10MB3786.namprd10.prod.outlook.com (2603:10b6:5:1fe::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 18:20:23 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::54dc:43a5:ea4e:22e]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::54dc:43a5:ea4e:22e%6]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 18:20:23 +0000
Message-ID: <a70dda45672d10dcfad37b5dd4bacff696c89523.camel@oracle.com>
Subject: Re: [PATCH 1/6] xfs: clean up xfs_attr_node_hasname
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 17 May 2022 11:20:20 -0700
In-Reply-To: <165267194404.626272.6376601308403239319.stgit@magnolia>
References: <165267193834.626272.10112290406449975166.stgit@magnolia>
         <165267194404.626272.6376601308403239319.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0023.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::36) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 274ec2c2-af16-4616-2d40-08da3831e896
X-MS-TrafficTypeDiagnostic: DM6PR10MB3786:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB378671423D9CC5E50B17E01695CE9@DM6PR10MB3786.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qsez43vYpSHHvBVFfxTt/hwo9LO35EQfP7P/la9ZpaxAbFNkpZnHrtasJ70gUNBcT943jV5pcXilzOzi+zsn7JmzJzpb3BZU/SuzooazAVNHahJWOqtqzqUNNJfjB7CppXbbVKPA8ffdG1i2JIktup5dlWe4j/S3eG0CK8rONpbGk7c8obVf+F9KcXPd6IPIEIKlIyLL98fKumUziQkREAttmIEfkE54CcpwKybskJj2HPYKYrSL02S8/rknayA3OwPQ+yJkwBTvrJaqw1DuzFn2zVYu+jy2g63Pzv66Eb4lbIBcLRg2HKE8ZMBo3mUinvg5AcRuE1fDQEBlWcjDyFBO6Mq07r9Vw1T4UhnndYQhbQUXH0q4i3gwR5JOGw5JC4k/tUtT+n4DbnfppCoocmsJyI5j7f5h9ySzSYI2PSzTot8wz4K8UC+dcYrFVHdBkSV/UwlYYecZ4yXmA74JIaTHxZ3aaN+6wgj86EkhaDb2mLhiVVLhDP72QNLvSIwKBIZCG3rYEa0Mg1SEDDz1TD5RLpx336LdtTvSSYQkJs3ADp6j+3Stp12kIwBj6llGWoYETfyiXcyAX7tpmNMl5bc/iwrVvZ7xZfgxR6lFlus7MXFUrK8NM97uLidCHFU24JuSnJAPLuZD+krHeZmEpmxC1aootWaPVxkqKq8SLbFmPY5fJBv1Tdx2/l/Z7NgMZES/ElcFHruHqV0t4nT6Yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(6512007)(6486002)(38350700002)(38100700002)(6506007)(52116002)(26005)(8936002)(316002)(86362001)(83380400001)(36756003)(8676002)(4326008)(2616005)(66476007)(66556008)(66946007)(5660300002)(2906002)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFFTTDRBNVJYUmFyaUN3VjczcEE2cTlvNWpITlU3bHBIZFBvaFl4UHM4b1JD?=
 =?utf-8?B?TlphNU5EVHhLNFMrYituNEdRSzVvY3EzUVpuam03cUgrdWNVSGt1dXUvTHRF?=
 =?utf-8?B?SWdIbU5SejRhV3ZxNjlSZk5GNlB4eXdtUC84TjBjWU01eERKMUNSUGNhWC8v?=
 =?utf-8?B?dldoS3RubytVTG41TndxNWpLV08rNmtNOHNxZG1kNUZ1d0twQW5GckoxZVhE?=
 =?utf-8?B?K1VMRzk3VUV1TllhTS8yZzA2aXRaWDhYdTNXUHZkUkd1OEczZmI2dnBKVFRI?=
 =?utf-8?B?MHU3YnByVGtwTVhJV20wZ3dRbXVuN0lSY2dRcFdYKzZEeWVGVFlCck5BM25m?=
 =?utf-8?B?MVRUV2g4dmJpRzZ0UlpTNmJ1S0JsNDkzUDNNWnVUdFA3UGo2ZWlHbWM4MXpJ?=
 =?utf-8?B?TWNQQWJpZFdROWpkRldrN1R4UGlVdlcvZEtsVFd4WVlFdTI2ZHA2aUh3cUs1?=
 =?utf-8?B?YzhDaDZzMlJ0T3UyTE9zdGEwY2xmYlg0OFlmRGxkNHdjRm5ZYzVxQm1ZYzFY?=
 =?utf-8?B?TzFBblh1TXBXZmNQQUsyVUFtVlJyR2ZiRWZRbTJDNDZiRTZTbGhKdUdBS0dv?=
 =?utf-8?B?MnJvNkpvRGZkSDZuaGt5a1JkbzBxeXpHY2pBSFp0UVRDL0g3L2R1eFIxUzJw?=
 =?utf-8?B?SHFJMEI2SytoQ1dCSFpXNVdBZFlVVW5FaXNieTJQWmdVdkoxVHp3aHFjSS9U?=
 =?utf-8?B?bU8zRXdXOTZRRlJPZjFJTTh0TGcxOU9VRnpnejczWC9zSlR5STUwTHFjZzl5?=
 =?utf-8?B?bmpzd0lDYUNGQndUWTJqVGY5bSs0ZEl2TC9ZN0JaeHRFSS9rUVVzd09ZZm0z?=
 =?utf-8?B?VHdoblVrNVoydTloTTBTUjZzNSsrU0VVZmRCaHF0bk04QkhKSE05TkxyOS8v?=
 =?utf-8?B?NEZLM1BncFlZOW8wVDNWL2tVdHlsSmYwR1JCS0tsRSsvNy9GRzVIWXZNSCsz?=
 =?utf-8?B?TVZTQ3d3MDNWaEZTUGRxOVdmMnBkRHorSDVwRU9CeWFzckpWK3g5ZkVvZmpW?=
 =?utf-8?B?eHc5NWZnc1lwZzJ6Nk1yMW9nTU9RdTZ6ZzdYenBQSVRXS20zVmc0UHBqK29i?=
 =?utf-8?B?Zml2RlBjaXo4ek5zT2c3Z3NndUsrcm5ka21JU09ZZDZQWTRXM3ZWQlhZNmlC?=
 =?utf-8?B?OC84QWo4ZkxJSUtzZFlKTlFldUREV2Zoa0ZYTFUrSno1amRkZnFGTFhIZ0wr?=
 =?utf-8?B?ZDR0YWJ0cmdoMlVhYmpGMmplak81WVgxVmFIcUhLYjZYS0YwdFIvK1hkRVly?=
 =?utf-8?B?Y3FWaDNpTGNHenRQNjhOWjBQblZUZ3hFSEF5NFJvMFZsakpQWUtyVSsxVSt6?=
 =?utf-8?B?S3dISTlJeFlkcVVheDZ4d0s1MGxpUzBRSFhmeHcxWWFaTWZBNTBoZHhUQTR2?=
 =?utf-8?B?RGFKbFpaK2xSYTRwamoxdFpSdXhRSkRyK1RYTE5UYzRvalNVOWs3aDVvVEJZ?=
 =?utf-8?B?WUt4MDdJSHQrMDMrdHlLazh3ZXNhejhMWnBHTFFlY01pUHVZSjIzZW9aNHJo?=
 =?utf-8?B?WEIxRDB5NTU2NEVnbys0UCtuZjlLYnlkWHdnVEpJV1JGWWRFbDVPelNKb0Yz?=
 =?utf-8?B?L0EwMmpad1N6NzF0NFh6TmoyZXJ5R2JmYStmL1NYNkN1M1F6eTl0ZjJ2aHJW?=
 =?utf-8?B?TEhWTGxJVjh0cHM5NldPalVnSklwVDdpUGpiMVhHU0pHQXFSN2Y2ekZLcDR5?=
 =?utf-8?B?NkNRaFhpYnZsVXNQSCsrOWM4ckNnUmZwbHNydnBIVDk1Q2ZnYWNzd0M4djRK?=
 =?utf-8?B?ZWpmUzZSV3NvbEJtUVFFMGZVWlFqZ3dvd2U4a3RwdHhoUmpVTlRFd04zU2hH?=
 =?utf-8?B?eDJLSWUyM08vaElaZ29VVUptc2FuRSsvZGh5K2l3Vk9BTi9QL1p6eVR4QTdL?=
 =?utf-8?B?N1c5a2VxTVNrUXNhQWJackVUZzBvL2laQXFQZ1k0djd1ZFY3MktoZDN6OE1v?=
 =?utf-8?B?T2hOclpDcW5RZXRub2FoZDh1MEwydEptbEFxK0pXV0JuY3JQQmVndmNqcGE5?=
 =?utf-8?B?Q3ZTSFBwc3hHb2JZTUZmRGg1VUxmbi9qNVNlTFBOY1JlQUZPSlVSRlk0c3Z3?=
 =?utf-8?B?U3JzUWk4T1lCMFdFRUlnUlU5T1Fic3VheUpDRDJiRnkwaW0zMkFLK2MvcGY4?=
 =?utf-8?B?aWNGU0g3TXROVExCL2EyN0JjdVpFdHhHTjdWa3dKQ3J2eko3YXlSSDgwc2dC?=
 =?utf-8?B?aDZqeEJpekRyZng3TXVLRGd5VHQwOUw0Y0F3bDRJdmU5Tm9XN0R1OUpSVWNv?=
 =?utf-8?B?d1AxdzRJdnNWNnJWOEhOdDlWVUo3SWp6SFczdlcxRTBkMlFnaTJrK3EyS2JR?=
 =?utf-8?B?RWtpdHdpSDNpSHZ2Sk1ucG04cklud2xiTEdFR0x0SzBFUlNxay9JYnFwMUtu?=
 =?utf-8?Q?WT4runD9HkexNWhM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 274ec2c2-af16-4616-2d40-08da3831e896
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 18:20:23.4930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JdA8+2eZvQ3jKoS4U2DJj64Vmlv0P1VUqfUEd6tz2H76StP30hLZXn222l5Z6sjEye/f3Dwp3vSVTkO3tEOgvtaT5tRFXLCfSbLhWSiKUlc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3786
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170107
X-Proofpoint-GUID: 4MqJlYtMyAYw2EjzubYTT4voH2mNr17m
X-Proofpoint-ORIG-GUID: 4MqJlYtMyAYw2EjzubYTT4voH2mNr17m
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 2022-05-15 at 20:32 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The calling conventions of this function are a mess -- callers /can/
> provide a pointer to a pointer to a state structure, but it's not
> required, and as evidenced by the last two patches, the callers that
> do
> weren't be careful enough about how to deal with an existing da
> state.
> 
> Push the allocation and freeing responsibilty to the callers, which
> means that callers from the xattr node state machine steps now have
> the
> visibility to allocate or free the da state structure as they please.
> As a bonus, the node remove/add paths for larp-mode replaces can
> reset
> the da state structure instead of freeing and immediately
> reallocating
> it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, I think it looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c     |   63 +++++++++++++++++++++-----------
> ----------
>  fs/xfs/libxfs/xfs_da_btree.c |   11 +++++++
>  fs/xfs/libxfs/xfs_da_btree.h |    1 +
>  3 files changed, 44 insertions(+), 31 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 499a15480b57..381b8d46529a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -61,8 +61,8 @@ STATIC void xfs_attr_restore_rmt_blk(struct
> xfs_da_args *args);
>  static int xfs_attr_node_try_addname(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item
> *attr);
>  STATIC int xfs_attr_node_remove_attr(struct xfs_attr_item *attr);
> -STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> -				 struct xfs_da_state **state);
> +STATIC int xfs_attr_node_lookup(struct xfs_da_args *args,
> +		struct xfs_da_state *state);
>  
>  int
>  xfs_inode_hasattr(
> @@ -594,6 +594,19 @@ xfs_attr_leaf_mark_incomplete(
>  	return xfs_attr3_leaf_setflag(args);
>  }
>  
> +/* Ensure the da state of an xattr deferred work item is ready to
> go. */
> +static inline void
> +xfs_attr_item_ensure_da_state(
> +	struct xfs_attr_item	*attr)
> +{
> +	struct xfs_da_args	*args = attr->xattri_da_args;
> +
> +	if (!attr->xattri_da_state)
> +		attr->xattri_da_state = xfs_da_state_alloc(args);
> +	else
> +		xfs_da_state_reset(attr->xattri_da_state, args);
> +}
> +
>  /*
>   * Initial setup for xfs_attr_node_removename.  Make sure the attr
> is there and
>   * the blocks are valid.  Attr keys with remote blocks will be
> marked
> @@ -607,7 +620,8 @@ int xfs_attr_node_removename_setup(
>  	struct xfs_da_state		*state;
>  	int				error;
>  
> -	error = xfs_attr_node_hasname(args, &attr->xattri_da_state);
> +	xfs_attr_item_ensure_da_state(attr);
> +	error = xfs_attr_node_lookup(args, attr->xattri_da_state);
>  	if (error != -EEXIST)
>  		goto out;
>  	error = 0;
> @@ -855,6 +869,7 @@ xfs_attr_lookup(
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_buf		*bp = NULL;
> +	struct xfs_da_state	*state;
>  	int			error;
>  
>  	if (!xfs_inode_hasattr(dp))
> @@ -872,7 +887,10 @@ xfs_attr_lookup(
>  		return error;
>  	}
>  
> -	return xfs_attr_node_hasname(args, NULL);
> +	state = xfs_da_state_alloc(args);
> +	error = xfs_attr_node_lookup(args, state);
> +	xfs_da_state_free(state);
> +	return error;
>  }
>  
>  static int
> @@ -1387,34 +1405,20 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  	return error;
>  }
>  
> -/*
> - * Return EEXIST if attr is found, or ENOATTR if not
> - * statep: If not null is set to point at the found state.  Caller
> will
> - *         be responsible for freeing the state in this case.
> - */
> +/* Return EEXIST if attr is found, or ENOATTR if not. */
>  STATIC int
> -xfs_attr_node_hasname(
> +xfs_attr_node_lookup(
>  	struct xfs_da_args	*args,
> -	struct xfs_da_state	**statep)
> +	struct xfs_da_state	*state)
>  {
> -	struct xfs_da_state	*state;
>  	int			retval, error;
>  
> -	state = xfs_da_state_alloc(args);
> -	if (statep != NULL) {
> -		ASSERT(*statep == NULL);
> -		*statep = state;
> -	}
> -
>  	/*
>  	 * Search to see if name exists, and get back a pointer to it.
>  	 */
>  	error = xfs_da3_node_lookup_int(state, &retval);
>  	if (error)
> -		retval = error;
> -
> -	if (!statep)
> -		xfs_da_state_free(state);
> +		return error;
>  
>  	return retval;
>  }
> @@ -1430,15 +1434,12 @@ xfs_attr_node_addname_find_attr(
>  	struct xfs_da_args	*args = attr->xattri_da_args;
>  	int			error;
>  
> -	if (attr->xattri_da_state)
> -		xfs_da_state_free(attr->xattri_da_state);
> -	attr->xattri_da_state = NULL;
> -
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
>  	 */
> -	error = xfs_attr_node_hasname(args, &attr->xattri_da_state);
> +	xfs_attr_item_ensure_da_state(attr);
> +	error = xfs_attr_node_lookup(args, attr->xattri_da_state);
>  	switch (error) {
>  	case -ENOATTR:
>  		if (args->op_flags & XFS_DA_OP_REPLACE)
> @@ -1599,7 +1600,7 @@ STATIC int
>  xfs_attr_node_get(
>  	struct xfs_da_args	*args)
>  {
> -	struct xfs_da_state	*state = NULL;
> +	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
>  	int			i;
>  	int			error;
> @@ -1609,7 +1610,8 @@ xfs_attr_node_get(
>  	/*
>  	 * Search to see if name exists, and get back a pointer to it.
>  	 */
> -	error = xfs_attr_node_hasname(args, &state);
> +	state = xfs_da_state_alloc(args);
> +	error = xfs_attr_node_lookup(args, state);
>  	if (error != -EEXIST)
>  		goto out_release;
>  
> @@ -1628,8 +1630,7 @@ xfs_attr_node_get(
>  		state->path.blk[i].bp = NULL;
>  	}
>  
> -	if (state)
> -		xfs_da_state_free(state);
> +	xfs_da_state_free(state);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c
> b/fs/xfs/libxfs/xfs_da_btree.c
> index aa74f3fdb571..e7201dc68f43 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -117,6 +117,17 @@ xfs_da_state_free(xfs_da_state_t *state)
>  	kmem_cache_free(xfs_da_state_cache, state);
>  }
>  
> +void
> +xfs_da_state_reset(
> +	struct xfs_da_state	*state,
> +	struct xfs_da_args	*args)
> +{
> +	xfs_da_state_kill_altpath(state);
> +	memset(state, 0, sizeof(struct xfs_da_state));
> +	state->args = args;
> +	state->mp = state->args->dp->i_mount;
> +}
> +
>  static inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int
> whichfork)
>  {
>  	if (whichfork == XFS_DATA_FORK)
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h
> b/fs/xfs/libxfs/xfs_da_btree.h
> index ed2303e4d46a..d33b7686a0b3 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -225,6 +225,7 @@ enum xfs_dacmp xfs_da_compname(struct xfs_da_args
> *args,
>  
>  struct xfs_da_state *xfs_da_state_alloc(struct xfs_da_args *args);
>  void xfs_da_state_free(xfs_da_state_t *state);
> +void xfs_da_state_reset(struct xfs_da_state *state, struct
> xfs_da_args *args);
>  
>  void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
>  		struct xfs_da3_icnode_hdr *to, struct xfs_da_intnode
> *from);
> 

