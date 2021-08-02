Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD86C432BE
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 07:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84B2E61029
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 07:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhHBHrk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 03:47:40 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28340 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232458AbhHBHrk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 03:47:40 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1727jiOX024602;
        Mon, 2 Aug 2021 07:47:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3PoAUizl2e4M2lMSfWhZ9pclrRBVWerozsvnvhYaDBE=;
 b=LTeLeWsTVZZoisadtEr/REN5dakDK/SD8vdYuKhTPiNCd8PO8f3ar7H4F6i3ljaYld28
 ReUHZD46tCnXORgVQ/QSTIfPcFVDI4nexEuOTixCewVA7qZKHb52RGWJ+fybz4JN+Wyy
 6XaUtubrXqPsLmFm/Pit4xzC4tafFqhOxmiEc6SV1kFS2PSSwwhpvV2BDqKEHcXMzmcK
 T276+/vrL19DxYjNJ/YqTh35zcQZ/12/mnSCTeUtW1GufRpP1ed3QmnT1ZDiq5KG6SxC
 xFbH+tPkwjf4hQpPLpEx/+JFzOk8dEveQCJqSCoS2YcDSi2WRt+gZU3nZRHwTe++4F/2 hA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3PoAUizl2e4M2lMSfWhZ9pclrRBVWerozsvnvhYaDBE=;
 b=uikLhrWnoe75pK60rfae7SO0t7TmrAUy3FPgH4hlAKvoRSUcTOM58RUYL9A5rQQakTsX
 9WXcEwf1b6BZCC1AsZ6hTU4TtQ7mHpkDIdUqRwGlrcHWtcT2V0Mmo36BZigtyrOSNOfQ
 gSSKpTQpP7BrRFTI76eBBn9HEcIT95vb2wfICx9lI7qzwSwiAoUZrOYHoai/sXAgGX0W
 p7GOuQbeI+G2RO9iC4AdFMAscA1yA0AXw0ANzlRrwa7kMDeclGBmx/r9hqzER84mFpoB
 m/haZfRmSnNedbj7X4uBw9GzmsUiDOwOTtA2wGbbZKBsehr/TSh2F5K+yElnQUZ9evIY RA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a5wy1gtsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 07:47:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1727jIvD098407;
        Mon, 2 Aug 2021 07:47:27 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3030.oracle.com with ESMTP id 3a4umw6ahw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Aug 2021 07:47:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCpwlQV/+Ps7xHvvzkza3OaB6LttQdXH5obaKsW5aQoxUTre/Os1wfGESqdAu2lWiOnFE7Aalvvtabfs7KNLK1x0fseBs8JU7h/LRHIW0xjFyeU1OE10t+ayIsAmGKa0IJEsqoKJEjhurOpDiVEbLv2/X+JZ+2ppWvXOAvkvXDT/tz52nnj3aB1TvhI6PTqXmtS/npH8QT0QvsK48kFG5I6GLfpDZdlp2qFTUPQdoToldJDVR7/BPTiG4ss0edx8lgYgAEeiIYvizIf1zvu1v81/3X74fReHF26PjrngyhILOC46x89LFdg8jiWlO9uAFbh79nCuFpw/B7yG2DX1lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PoAUizl2e4M2lMSfWhZ9pclrRBVWerozsvnvhYaDBE=;
 b=eWUCCT580H2FCldrNKlXSr8JfaUWiMXGW9yxkHoOUaO5cfqh3IEH8RRarItp+QBFwBEJVWoEc5bjIIAAS/6QUkxeUse38RvQbtceQkgBcHcH8qrSKju3OJQ7auNreNbNDhTsoB2njwMUtCaoxJSBZ+wdplQdY6o5AWy5QrDPeDXtVW5v6hXAdVpRPX0PMSWM+q6Ue25yXQHcQdikRXs2NLKZmMBWcB1gE01QfF8PgjoilIrqP6Nvhftm1y1u7rnOLgZk4neVDen0Ins5zbphXWcPO2QRY4KkanmyNZhCJvmlpm3MnmKPcfnQpkHAbw1/baxouytrJt0xucl8cfgU9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PoAUizl2e4M2lMSfWhZ9pclrRBVWerozsvnvhYaDBE=;
 b=huOmoGZPNTMijnYBhj5zfJgJqwzkAl+uogcpvBBUUX4isKRW8OUBZdn+PyVqNioEMxTKhYpSHU4DGVeOJPQRyz5lUx0lGxsdj+EX2Ibwsgk8iOrcLeKxU0ZPy25eQ6ommy4pwheAkGisFe0QDXx/n/IS263zxQYkKIKikJ0flZ0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB2693.namprd10.prod.outlook.com (2603:10b6:a02:b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Mon, 2 Aug
 2021 07:47:25 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 07:47:25 +0000
Subject: Re: [PATCH v22 10/16] RFC xfs: Skip flip flags for delayed attrs
From:   Allison Henderson <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210727062053.11129-1-allison.henderson@oracle.com>
 <20210727062053.11129-11-allison.henderson@oracle.com>
 <20210728191803.GD3601443@magnolia>
 <95b364d5-053a-45cc-1bcb-8a0346b5c324@oracle.com>
Message-ID: <f8cfd6ed-4cdb-2d68-e41e-e7964c4b5432@oracle.com>
Date:   Mon, 2 Aug 2021 00:47:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <95b364d5-053a-45cc-1bcb-8a0346b5c324@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.167] (67.1.112.125) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6 via Frontend Transport; Mon, 2 Aug 2021 07:47:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e270b88b-0503-4719-3bb8-08d95589c4df
X-MS-TrafficTypeDiagnostic: BYAPR10MB2693:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2693D09FA3D30B3C5C626FAA95EF9@BYAPR10MB2693.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fe4O1PmH0cwlEIhONESWfcGIOFCex3AFDdxumGsm2gvtW1tVADL2zfIhP1LpLXpt09BRkkIZEcG1Dek7VbdICRQdssrWV+gFK33UreYoTWcyLMkI+2FvDOgVx6NXKH768H1OQ3rlHvpvOTU88wULYttNFOINfknZWw9Z5+Kqyr2m2ppy4nLrbEx1kFM40G2+X2jzDgLs+xE5GOFfqNgH5BlagVXTjuPTvb8hg1iLTVf/aNmDWggkGXUsU3/CNvn6fxFYjWtFQUlUdplYWbjr7T1C21suexgLTSHTndlEb0jZPptYyTsUh1mEksp0iVDn6sx/hgrrfaAXrPcAQijaQW79lbuzLTFUkhNRnam1a9FysdddzKM365kuwVuyNqxuAsGHhQVaewhOm2i4qyju5XjCLphpadPGf7pPcrWFlFh7I3BE5GCABVpuI3URHfM7mKrWv97lG4HHbam/xew3lEYacCtM3PjwmY1w/4X0O+NcYfV9Bjg5tNwJNvNlaft5I3IahYzWF8DqwaOfyRaTS43f2jezRcx0aWTdwYLjWzdg5ODdmQL0J0xdZnEskiivm5FeG0HQi4U5AgXTLp/TKJIkz0zSCLp6hH+eE6WVg9GOtktw6ennDy1lhr7sY8q7Yv1OgMEg4BKyAal8/jh/fzL2g5YVSzPcF1b6hDCpD4DcK+PicVUYXOt4kJvnB+RYkCoZR7aRpuka29lHY4brumhPQNcKvZcUkdBIS+YEwuNSGmPUIWyh5XAcFgTsRvir
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(956004)(66946007)(66476007)(16576012)(44832011)(316002)(8936002)(52116002)(66556008)(2906002)(86362001)(31696002)(53546011)(5660300002)(36756003)(186003)(6916009)(8676002)(83380400001)(4326008)(31686004)(38350700002)(508600001)(6486002)(26005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHFXbEJPL0liMnNON00yVk94K2M2c0NVUUVHS3FQSVRUbXNWOEpoMkp0Q21w?=
 =?utf-8?B?dzBNcFlReGJEZ2xpZndUdU9NaDFDUytPMWExTE0reGRKKzNraFBWaGlIaEZT?=
 =?utf-8?B?VElEZG1ucXloWERUbXJoejZydUMvcVcwVDlUUXNiUEJCbXhGS0x4WDBVVGdl?=
 =?utf-8?B?dG9tUXovVnVzUTAxUDBsR01xYUZoYk1tcjlRU05tTEZYdlpGcUJyZmVXaW5l?=
 =?utf-8?B?UzM1MHMzdDF6bGM5Rk9taVFzSnJlR3ZGSGFmNzNmQ3owS2ZMMmVpQ3BCcldW?=
 =?utf-8?B?RlhobjJEa0I5bGdCNHFDNkdkMW9YNFBYU2FmMzBFQ21hYnlVRi9JellFSTRK?=
 =?utf-8?B?amFpdFVtekE2MXpMM2FKYmRWM0tlb0JaY1VUMWlHb0psT0d1ZGNMb2NVTEI5?=
 =?utf-8?B?enU2WTAzd2VtZkhYNDkwc0tNb0RBRTBnUjdkWmJCYVpnTy9BbmxxeVd2RUdl?=
 =?utf-8?B?Y1htNzUvZ0Nxdlg0L2xUbHNyWm5iTzNWN3VRWjkvMU1ud3p2dzBFeTB2ZnNi?=
 =?utf-8?B?TEQxUjFKTEIva1Z1elZENzQ2NE9idGI5Mm5zbU9YOHZNU0g1SVBhOUtVRE9W?=
 =?utf-8?B?YlhLaWNoZzhQL1R1c2tObDZuMHVST0dqSjg3ay8yTzBRSG9reUU3Zk50YnRp?=
 =?utf-8?B?eWJySHN1aDJuWEhXLzR1aXc0cHV2SS9lRWl1a1hLUHh2QlNEL0NobmRCeEkr?=
 =?utf-8?B?RzZGczl1bjFiRy9FY2txbXlEY1hFU1pwUFVzS2NiR0ZSNG9yVHlWcDFacHNM?=
 =?utf-8?B?S2l1dS9hUzk4MS8vN2hRc0tzeWFHeGlKbk1CK3B0MURBV3VCVit3L3RKVkdG?=
 =?utf-8?B?TDdEVS9nclRKMTdYYzBOQStJSG54d2NjbStaUnpoZmxOam1iUXYralQ2ZWJE?=
 =?utf-8?B?cDFmRGtwOW5mT3hITzVzTXFxN3RTeFpHTzdUMkFzNHo4ZjEvZktBSEpXRHlC?=
 =?utf-8?B?RUdSU3M0STdaNHJDYVJhdUdLNFdFZCtIUUg0Ujc4bHFuTHJZU3RwdUp6QUQx?=
 =?utf-8?B?aWY0ZHRxMXhwS3d4L0V5MFQzNEFSWDh1WUhDRUV1M25iUnRlUVA5ZkF4NmZz?=
 =?utf-8?B?Y1VwYVBuSnkrL3pFbUM4Tlp5T2dEeWc2dmlxTGhvWEt0enNjcVlwWmROZ2di?=
 =?utf-8?B?SXNodGMraEtRa1RsL2haenp1RW5ZMTZwVEMwYnB0bnBPZ1hqZTU2T1RaN1du?=
 =?utf-8?B?SThWMktRUEhEVEVCUkI5T0JTaFNrbHpxYnFzSmcvUnVXL1FRN2c0MEdvWVpj?=
 =?utf-8?B?WHpYMGZZYTNFMUNZaWdZNjBQVlBOand2R2VERTJGeHZ2Y3lyMlRmdzVRM080?=
 =?utf-8?B?YU1vNWpOZTVKamJIK2xxRHpIeTRpUmtmajJWcFJFaUpubTFHZHhqWnV5Uk1x?=
 =?utf-8?B?S3diZG12T0RhK1VnQ2t5M2JraGY2MHJVRyt6OHB1SDBIRkcySkhlajJXSWdW?=
 =?utf-8?B?c2VkY0NrbU4zUFlVT2xhL3h5aXU3SnhjbEE5QnJFTzdpOFpHei9Sb0ZycXBI?=
 =?utf-8?B?L2RneGt5SFFaTWpyKy9uY2R2VTBHZTVOWi96MTNXK01OWVJEYmZGd2lkbUls?=
 =?utf-8?B?YTc1V2ZucWd4RmhsOEJBaEhyQXdZb2lqQzZoVE15VnhJZTRkY0JIa3JYS2Ft?=
 =?utf-8?B?VjhaODN4bFI0amQ3bmsyVGRTTmwrdFFtRk9TWFZaSkpLZmhWRDBVRktDMXFm?=
 =?utf-8?B?L3hZSzA0STZpRmFEMjY3RzN5M1RlSE9QVVZ6Y01WTEo3MEMvYy9vYXZKd0xJ?=
 =?utf-8?Q?+ydAEgPEmrgRwPyYjSrWDnJirL/bRlS7DSG15Zo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e270b88b-0503-4719-3bb8-08d95589c4df
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2021 07:47:25.2954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y9gWEvi9dGNKyjZYPO8EI7kn7SYOzGngQCxUe2ClJTd7RY8kSsTsuSNnKdzO6M6myZt4lS8Q0A6JY4EqxjbO/VBxMxFHqySDjPS20qT7LfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2693
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10063 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108020055
X-Proofpoint-GUID: oejxchmAVzf0bEd4IShBiazL31XZWtUu
X-Proofpoint-ORIG-GUID: oejxchmAVzf0bEd4IShBiazL31XZWtUu
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/30/21 10:11 PM, Allison Henderson wrote:
> 
> 
> On 7/28/21 12:18 PM, Darrick J. Wong wrote:
>> On Mon, Jul 26, 2021 at 11:20:47PM -0700, Allison Henderson wrote:
>>> This is a clean up patch that skips the flip flag logic for delayed attr
>>> renames.  Since the log replay keeps the inode locked, we do not need to
>>> worry about race windows with attr lookups.  So we can skip over
>>> flipping the flag and the extra transaction roll for it
>>>
>>> RFC: In the last review, folks asked for some performance analysis, so I
>>> did a few perf captures with and with out this patch.  What I found was
>>> that there wasnt very much difference at all between having the patch or
>>> not having it.  Of the time we do spend in the affected code, the
>>> percentage is small.  Most of the time we spend about %0.03 of the time
>>> in this function, with or with out the patch.  Occasionally we get a
>>> 0.02%, though not often.  So I think this starts to challenge needing
>>> this patch at all. This patch was requested some number of reviews ago,
>>> be perhaps in light of the findings, it may no longer be of interest.
>>>
>>>       0.03%     0.00%  fsstress  [xfs]               [k] 
>>> xfs_attr_set_iter
>>>
>>> Keep it or drop it?
>>>
>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>>
>> /me hates it when he notices things after review... :/
>>
>>> ---
>>>   fs/xfs/libxfs/xfs_attr.c      | 51 
>>> +++++++++++++++++++++++++------------------
>>>   fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
>>>   2 files changed, 32 insertions(+), 22 deletions(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>> index 11d8081..eee219c6 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> @@ -355,6 +355,7 @@ xfs_attr_set_iter(
>>>       struct xfs_inode        *dp = args->dp;
>>>       struct xfs_buf            *bp = NULL;
>>>       int                forkoff, error = 0;
>>> +    struct xfs_mount        *mp = args->dp->i_mount;
>>>       /* State machine switch */
>>>       switch (dac->dela_state) {
>>> @@ -476,16 +477,21 @@ xfs_attr_set_iter(
>>>            * In a separate transaction, set the incomplete flag on the
>>>            * "old" attr and clear the incomplete flag on the "new" attr.
>>>            */
>>> -        error = xfs_attr3_leaf_flipflags(args);
>>> -        if (error)
>>> -            return error;
>>> -        /*
>>> -         * Commit the flag value change and start the next trans in
>>> -         * series.
>>> -         */
>>> -        dac->dela_state = XFS_DAS_FLIP_LFLAG;
>>> -        trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>>> -        return -EAGAIN;
>>> +        if (!xfs_hasdelattr(mp)) {
>>
>> More nitpicking: this should be gated directly on the log incompat
>> feature check, not the LARP knob...
> I think they're equivelent functionally right now.  Looking forward, if 
> we assume that the knob will one day disappear, it might be a good idea 
> to leave it wrapping any code that would disappear along with it.  Just 
> as a sort of reminder to clean it out.
> 
> So for example, if we ever decide that delayed attrs are just alway on, 
> this whole chunk could just go away with it.  OTOTH, if there is an 
> internal need to run attrs without the logging, it would make sense to 
> check the feature bit here, as this code would still be needed even when 
> the knob is gone.
> 
> So i guess this is a question of what we think we will need in the future?
> 
>>
>>         if (!xfs_sb_version_haslogxattrs(&mp->m_sb)) {
>>
>>> +            error = xfs_attr3_leaf_flipflags(args);
>>> +            if (error)
>>> +                return error;
>>> +            /*
>>> +             * Commit the flag value change and start the next trans
>>> +             * in series.
>>> +             */
>>> +            dac->dela_state = XFS_DAS_FLIP_LFLAG;
>>> +            trace_xfs_attr_set_iter_return(dac->dela_state,
>>> +                               args->dp);
>>> +            return -EAGAIN;
>>> +        }
>>> +
>>> +        /* fallthrough */
>>>       case XFS_DAS_FLIP_LFLAG:
>>>           /*
>>>            * Dismantle the "old" attribute/value pair by removing a
>>> @@ -587,17 +593,21 @@ xfs_attr_set_iter(
>>>            * In a separate transaction, set the incomplete flag on the
>>>            * "old" attr and clear the incomplete flag on the "new" attr.
>>>            */
>>> -        error = xfs_attr3_leaf_flipflags(args);
>>> -        if (error)
>>> -            goto out;
>>> -        /*
>>> -         * Commit the flag value change and start the next trans in
>>> -         * series
>>> -         */
>>> -        dac->dela_state = XFS_DAS_FLIP_NFLAG;
>>> -        trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>>> -        return -EAGAIN;
>>> +        if (!xfs_hasdelattr(mp)) {
>>
>> ...and here...
>>
>>> +            error = xfs_attr3_leaf_flipflags(args);
>>> +            if (error)
>>> +                goto out;
>>> +            /*
>>> +             * Commit the flag value change and start the next trans
>>> +             * in series
>>> +             */
>>> +            dac->dela_state = XFS_DAS_FLIP_NFLAG;
>>> +            trace_xfs_attr_set_iter_return(dac->dela_state,
>>> +                               args->dp);
>>> +            return -EAGAIN;
>>> +        }
>>> +        /* fallthrough */
>>>       case XFS_DAS_FLIP_NFLAG:
>>>           /*
>>>            * Dismantle the "old" attribute/value pair by removing a
>>> @@ -1241,7 +1251,6 @@ xfs_attr_node_addname_clear_incomplete(
>>>        * Re-find the "old" attribute entry after any split ops. The 
>>> INCOMPLETE
>>>        * flag means that we will find the "old" attr, not the "new" one.
>>>        */
>>> -    args->attr_filter |= XFS_ATTR_INCOMPLETE;
>>
>> Why is this removed from the query arguments?  If we're going to skip
>> the INCOMPLETE flag dance, I would have thought that you'd change the
>> XFS_DAS_CLR_FLAG case to omit xfs_attr_node_addname_clear_incomplete if
>> the logged xattr feature is set?

Sorry, i inadvertently hit send before I finished all the replies.  It 
took me a bit to remember why i ended doing this few months ago:

I don't think you can just skip the clear incomplete.  It does more than 
clear the flag, it calls xfs_attr_node_removename that actually does the 
remove in the case of nodes.  The reason the filter is removed is 
because we would no longer match the attributes we are looking for, and 
so the lookup fails.  Which turns into failures in xfs/067 and xfs/298.

Alternately, I tried simply omitting 
xfs_attr_node_addname_clear_incomplete instead, but I seem to get the 
same failures in the same two tests.

Allison

>>
>>>       state = xfs_da_state_alloc(args);
>>>       state->inleaf = 0;
>>>       error = xfs_da3_node_lookup_int(state, &retval);
>>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c 
>>> b/fs/xfs/libxfs/xfs_attr_leaf.c
>>> index b910bd2..a9116ee 100644
>>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>>> @@ -1482,7 +1482,8 @@ xfs_attr3_leaf_add_work(
>>>       if (tmp)
>>>           entry->flags |= XFS_ATTR_LOCAL;
>>>       if (args->op_flags & XFS_DA_OP_RENAME) {
>>> -        entry->flags |= XFS_ATTR_INCOMPLETE;
>>> +        if (!xfs_hasdelattr(mp))
>>
>> Same change here as above.
>>
>> --D
>>
>>> +            entry->flags |= XFS_ATTR_INCOMPLETE;
>>>           if ((args->blkno2 == args->blkno) &&
>>>               (args->index2 <= args->index)) {
>>>               args->index2++;
>>> -- 
>>> 2.7.4
>>>
