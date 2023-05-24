Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2846FC7EE2D
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 08:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242613AbjEZIs2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 May 2023 04:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242426AbjEZIsX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 May 2023 04:48:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490471A7
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:48:22 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q852E9008794;
        Fri, 26 May 2023 08:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=XuwdSgqufehhihDqmWYRgD7lC3K/RWOglF2fcBPCQ+w=;
 b=VSWGiyaticPuKaLimIdSOwXulbySyHNHa0byo12PhRcEJab1s11ZjCFm+MXE1PIy+h9S
 /twAduXGN5eI+ERF88uX/l+r1VzqjKzCDv6qzrYwhQKdhh50f8/MbeS1+qNdjzHDIZWD
 DjV1hutLZLcpidamnrXIR0DKxN2GE9LgTvhVoN8yWV9sICsNJJbuXcGfvQx0yYXUTg4U
 8/yDr5/G9iGkf0Z6cdAXIO9QtebqngijSCCP6/Pu3ouEqq/fwraFDF6NkKm5hn7MmNPg
 qFvEaQTGIAn6nHxHukrA3Lm+Qiit4/VGIKjck90NaRpKTAXehxgoUeqsWk0PL3zIdbX7 bQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qtrxfg3qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:48:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34Q6fljh027327;
        Fri, 26 May 2023 08:48:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2he5gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 May 2023 08:48:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1bmOokgHo/pr3H1HceI5PN5PWWamXieX9KvSMNcVD3U5GgmYBe2NDwgE1fwwWhAjiVCJvRO8YwkEzJ1OEaXYbP53J/kNW9pmHCGRSVnTKNvqsiHX3h7XciWay9v4RVtALaGu4keZfkOww3W9ZUE1ZDhDMqKmYx+9/yFxOKjOaOUIEK0/Gv8HcPEo5Xe9LESiAKFVXBoGIS8GpBZzGCdxbiDPKzaoK8m8vc1g+BmveNCTIRK44LFIH52xwEgiszFbYeK8/TA50uztgNgltwXZ710FjykwzTKoZEP1Ww+mFBOJ+vIz8c/QMDstaiN5TtosUdaDDfSa2yhMvCshHnoig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XuwdSgqufehhihDqmWYRgD7lC3K/RWOglF2fcBPCQ+w=;
 b=W0ozQvONuXLF0bPuQqTwqJEccm1cKCUpk9t1BJ+RyEqB/orFGQoJzhskfaA7CgChtpZtVhwDWx2j9E2NjDyer3DGsAEjugE5oSvES2d2lzitPaXsmHmSagG/8Qantr5sbGHteqQZsmxsISGhUv91u69RoCC0BzwSUAFKZRX9k0yMsJ38K4irRve9IdfZVhvpB0xHDu9NsFfT5/jGvwzNDOqvUfJq1xDpWvZloa6PwUrTvhzwz2WKpZHVjCKd6A15iPH4pijo6olPwsG9ESQ/JYXZaFMEBjOi6PdFAbFgQtNpuU1DGpU05iwqVsv6cRrtC/vq3pbaE6FPvCncb2idoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XuwdSgqufehhihDqmWYRgD7lC3K/RWOglF2fcBPCQ+w=;
 b=g2kR154sMdfyUKc1UtrKfQOIQYYjiydi3bHW0voHiXwRclJeB0y3AgdtG3AG/H7relP1BebF2kH++28U4+JTNScKICj4zMRubbI9cUInIx5sIgVKXpabo8hWvhVz0n6VzmGlZtIPX3sEuY1MtvQGcjog2lILb6eihzCkv24W1IA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW5PR10MB5713.namprd10.prod.outlook.com (2603:10b6:303:19a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Fri, 26 May
 2023 08:47:51 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::1827:534d:7d96:20f1%6]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:47:51 +0000
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-5-chandan.babu@oracle.com>
 <20230523163638.GK11620@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/24] metadump: Add initialization and release functions
Date:   Wed, 24 May 2023 10:33:34 +0530
In-reply-to: <20230523163638.GK11620@frogsfrogsfrogs>
Message-ID: <877csvlbrk.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0141.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::33) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW5PR10MB5713:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b965a51-8648-462d-d6b0-08db5dc5e392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rEQ6zyQMTMK4TGOElRGiSWQj7zqqvDo9ADlQMVR9YdbgT+O1QSOhL67HfqAysQQg27WoBB1E5u0QtqUi2fbIMaA4QZlNgyOUDyGuFVdumOXWZA+dRJ1fhR+Jrb/CGtcj2LiEEVL6FhVvUVJTssL/UF4cubt4U1RS0vzvZp2AsYw9Gkf+A3Oj/QF3LNm0X/E39+mPz+Y4Mo4lTlRvZPAIbp7CYVuewHGPM6/GlA5C6eXKf+R11KQX80Z4hx6w9ABhKaQLHdcs1IbDPmHULVNQL8PwhVKd/tmU0LrKo+BnP4EzKd6PO6w/uaERZvpPX9FKoeICw7tQPElWmz1VNF/7qH1n7hVZknFZS1ktQIo+wNpliMtlWHBahwFsfGgBKOVShGZg9eOIbGf7rpYdanuWoCGu+Z441dxy6Gp6QOSvsqDvcl/Z7YVmShF4PpCv7pDXxC09O+YQvOuauXBF+cEBPC+VLUTuC+xYg9yfiiqrgZyHG6y2ttgiB/O+Oo8a4Ed0i68lS103jLxgceW/qF6BJQLLYxLxuvEC5vR2gfD1XvdCk00JxoGxzYLighnA6EWh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199021)(5660300002)(478600001)(41300700001)(8936002)(8676002)(6486002)(6506007)(9686003)(6512007)(53546011)(26005)(66556008)(4326008)(66946007)(66476007)(6916009)(316002)(6666004)(186003)(2906002)(83380400001)(38100700002)(86362001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rXRP8DHiqjusGQHRAMF+gw0AL/E3LXsuFrCiAPdL8lRxl7yvzF6u+huWDNtk?=
 =?us-ascii?Q?6GLj4jYA5O4y7LN/UKpymWLI11Z0OA3+Lr8uHLQOzpbyEzWB5xoRVqQifYIc?=
 =?us-ascii?Q?bPpgDwW3g0N6l3QPBLTUjAQpI1wO/FH6oGPBifhzum/GsEr5r5LFx14irBBA?=
 =?us-ascii?Q?DFeHxqCUjyZAjzQwLrjqQeoib7/3DXurys9x6JcI5zjZ08CyUKyLdw1RIeUZ?=
 =?us-ascii?Q?4bPkEINbivCBztSSbDaJD21yCBqaKMHPnyqk1c0GsbEM26NyusMnArFNL4zS?=
 =?us-ascii?Q?RicseXOI6z2wnSAc9v96GCR+QsBgr83rsmhh0CDIYPyCXqo7QFeyLhNH/a5p?=
 =?us-ascii?Q?LWMs79GIIEWkjcv/+BKm58m8AO6nJ/hZ8VP6eLKl/kUpJNwawnACxVg6ZWiW?=
 =?us-ascii?Q?cYGPOwcp/2MjbK+jYmzv7nMIAJdysCgEDTDS0pZEMJitBRAszcSTenbJz8r6?=
 =?us-ascii?Q?6zdFfeOPPCzh9vCIPBkSxqUp/uHGhBR2cx7j8tW5j+4mJrnxkGN79m0yTUpp?=
 =?us-ascii?Q?F9SLkljEQcVK5q6WX88DUAVxDWj1RhPd8TPTw/CVH4OJvszm60N74+v9cv4P?=
 =?us-ascii?Q?8NjQvo88K/7fYyiYbbpxAIXTLHk8ypPLywe+KRj3bef3jja3dLEl1t9FVP5F?=
 =?us-ascii?Q?WDKlSKW9ZoB4gJyCQbdSULGZW9LVJjX7q/UhVZtEaaFCcl29X3VcU4uWeVRs?=
 =?us-ascii?Q?sy9FJuSux2uCJPcTBaflOnNnOVx5lGM6XX8jRDJuJoa4SMGU9cZT3BdFlICZ?=
 =?us-ascii?Q?t5wm2+2S9ybJMxzevx9PjjA/SkKXbeLNSWJAkOmBpRkrwzkPK47xB19od8RI?=
 =?us-ascii?Q?k5cIC1vrUBwQhg0xZDfs+pmj9FX4OGyADLBaa6hlO9YjTr7BRqWpq3fFJnF8?=
 =?us-ascii?Q?Hz7VbELA4pg2jxjb44KzO6mB7emqo2FUu5swLBUwvIQumPt0mR/2BGlUqIua?=
 =?us-ascii?Q?Es6Y9xFQO3AXdyFi2g9ZAgC8kQHKC29ZatNTX/XoxAHMZfra9NGkYhtlq8aD?=
 =?us-ascii?Q?TrXA4BlnwFBE7e1CcXBJJ0isb+ebi6Wvdjk0bBtCgsVn6vVD3XhPEk58hHSo?=
 =?us-ascii?Q?uHn5tPlQ8+9ddlbrBcB31A7za4BwiIwvRm60jAAQd63cJGbwRSgB+UHPvpkC?=
 =?us-ascii?Q?8XNOrypeECpKPhfbOCJ2ryZfAPfJY5GBtVGntsn3erJifdF/GsZ68TZ9Gyah?=
 =?us-ascii?Q?CIn32AShBW1aUZeBmr8JFg//N73A9tJEqakC/ubkYni9z9RNKeT8ev5X/qIa?=
 =?us-ascii?Q?dHmf7/++G49x5efqtJ4LX55ifP1rGp4ftDx97paP+bgmBCvbx4JciWNxe9IU?=
 =?us-ascii?Q?zBD4+xSULk6ttREpfk+bDyNyaNjgfcWjXbEdmPlhYbWjL1n8LX0xkhc7IMVc?=
 =?us-ascii?Q?mZEc8qgN6Ue7uBCFgwEyIbE3+gNM61Gisq8fmPsfvUecudCMHKMtS/H/n7F7?=
 =?us-ascii?Q?/oQCSmqHoKpD1vPGlRBIxhGz+1cellnBdbKJVyHHI9oHgt39mAWpqpyFfsu6?=
 =?us-ascii?Q?79QCoUlecrUYFjzVrvaxP7QnXjefSUmdjxzBFrw0sqUjswP4FJWdDxHp8E0g?=
 =?us-ascii?Q?BpXUxmBIgMDc6jFILJu3UmHT4Mat9PU3+Ejn7g1P?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YoneGuiUi2GRx39N9dKMDqqBnjaIc4G6H5+yvB+PJFGM4seFNjfIIzYH6FIs/83gOVJ3RC+r0mZ4zUi+IFwcC4QZh61Kany5pChaILZkYBv55iDLShLS4MmIq3XbKTc7ZkZjOkr/PrSYWwxkAuRDubXXWKVaGy1yxz6tddBoJBLvODId0PZ3xEk0Tao7kfejJWN2A8nWj9NCAj0/V+9Up3WdZ024dDjDmGRLBLK0TzG/wODMGiE/nBc/IaGfVdxOTRkLqgGyTm2RHEztmqlMPyYOT9mS99ndGoVlTH6S/SDhQOXB/UTZ1ry51lQ38htkoXzpG3HbqkvH3qO3E60vhtoR34e9+V24RQsGS3n5ixaozW2TfW5riyEAzoUJp/qM7T0cll5jJ6c85l7atIwOaDepaC0FSf2NENebu4yB8sLPc5tW/ADpaEuqUNaRtDWGBfGAWdcbQqrzjaVnyMWOxEZkXDVTxa49M+yjQ3PAC7ioXFwZLy2TUk3g8WTn6ri+2XbR76pmRrnVYea6ZFjGruEcGW4A7EcKtXpu6yzAkOdC802jXbCiCJvNu2FBnLyNkrTWR6gQ8Iz3Yyks/lOO2WpPJzGkgGzrbhqCOxmuGDhJsmRgj62VHdWeQCQFJ/Bk95MkHLgqz06XhgPsa1dg5Lki8TzoKJ9owI7gIs9D7qdfAHJVJql7rWc3OoW12pakwByBS9pg7Je7JXf4Kj76mGkYnhu61NwGqdk1H4LkPXJQpSuiE69yqSrYGF0pJ+FJPMK0QVLXAKZExkGMLRRSKdVjKk9Nw8KHslNR0tFJDi0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b965a51-8648-462d-d6b0-08db5dc5e392
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:47:51.3862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWssIucjb8PljsboIXlvs73ISOIHDY0iTZ1oTmbdSgQGwCr6Knu7WCJ2T5WtSwBWnkA9kMnF3KhZMVvcN+37eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5713
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-26_01,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305260075
X-Proofpoint-GUID: 3yR_oTwHEwmvJoVTi-1iEKp329nJYcbk
X-Proofpoint-ORIG-GUID: 3yR_oTwHEwmvJoVTi-1iEKp329nJYcbk
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 09:36:38 AM -0700, Darrick J. Wong wrote:
> On Tue, May 23, 2023 at 02:30:30PM +0530, Chandan Babu R wrote:
>> Move metadump initialization and release functionality into corresponding
>> functions.
>
> "No functional changes"?
>

Yes, No functional changes are introduced by this patch. I will add that as
part of the commit description.

>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>> ---
>>  db/metadump.c | 88 ++++++++++++++++++++++++++++++---------------------
>>  1 file changed, 52 insertions(+), 36 deletions(-)
>> 
>> diff --git a/db/metadump.c b/db/metadump.c
>> index 806cdfd68..e7a433c21 100644
>> --- a/db/metadump.c
>> +++ b/db/metadump.c
>> @@ -2984,6 +2984,54 @@ done:
>>  	return !write_buf(iocur_top);
>>  }
>>  
>> +static int
>> +init_metadump(void)
>> +{
>> +	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
>> +	if (metadump.metablock == NULL) {
>> +		print_warning("memory allocation failure");
>> +		return -1;
>> +	}
>> +	metadump.metablock->mb_blocklog = BBSHIFT;
>> +	metadump.metablock->mb_magic = cpu_to_be32(XFS_MD_MAGIC);
>> +
>> +	/* Set flags about state of metadump */
>> +	metadump.metablock->mb_info = XFS_METADUMP_INFO_FLAGS;
>> +	if (metadump.obfuscate)
>> +		metadump.metablock->mb_info |= XFS_METADUMP_OBFUSCATED;
>> +	if (!metadump.zero_stale_data)
>> +		metadump.metablock->mb_info |= XFS_METADUMP_FULLBLOCKS;
>> +	if (metadump.dirty_log)
>> +		metadump.metablock->mb_info |= XFS_METADUMP_DIRTYLOG;
>> +
>> +	metadump.block_index = (__be64 *)((char *)metadump.metablock +
>> +				sizeof(xfs_metablock_t));
>> +	metadump.block_buffer = (char *)(metadump.metablock) + BBSIZE;
>> +	metadump.num_indices = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
>> +
>> +	/*
>> +	 * A metadump block can hold at most num_indices of BBSIZE sectors;
>> +	 * do not try to dump a filesystem with a sector size which does not
>> +	 * fit within num_indices (i.e. within a single metablock).
>> +	 */
>> +	if (mp->m_sb.sb_sectsize > metadump.num_indices * BBSIZE) {
>> +		print_warning("Cannot dump filesystem with sector size %u",
>> +			      mp->m_sb.sb_sectsize);
>> +		free(metadump.metablock);
>> +		return -1;
>> +	}
>> +
>> +	metadump.cur_index = 0;
>> +
>> +        return 0;
>
> Tabs, not spaces.
>

I tried to include your .vimrc configuration equivalent to my .emacs. But
looks like I didn't cover all the cases. I will fix up the whitespace
problems.

> With that fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thank you.

-- 
chandan
