Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F40EC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 19:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiF2TXR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 15:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiF2TXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 15:23:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6883193DE
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 12:23:15 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TJBs5J005991;
        Wed, 29 Jun 2022 19:23:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=UvsC96rdwbk2Rf43XW8g1ZxnOXqB282d+0rhrTyz3h4=;
 b=GfBlhZ/RLM0vRKc6TGztwUHu1iePtHHvyTxwe2LJKNBLWL+lNUgdBqE7MCJJ/Q8BDeDP
 BdPZDoKST/NdsYXNhJqRFBUBXHIkhkn/i5vnnsqOE0yQVChOgZq7/ehcXiw+/H67OYH4
 I9h4/vQ3Fns1OxojpMvXI5nETa/Z8dnKarorN/iS1TswQ3f+o6toLFB+QFdpQYoTPpQ8
 1zGlyQBGjY9WsHWYOKmwOMf38+y/pUbZ+9llyLTZ9ne5WHkDBvJXOtD1y52+UOPpEBOM
 wg23v9eEsSdByJOk8arJDC5kH1DUfQ1dpQoc8rOx9EVhF770m7wHllh1xhdSEI0xax6N Vg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwsysj4ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jun 2022 19:23:11 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25TJKwbX032643;
        Wed, 29 Jun 2022 19:23:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gwrt3kc5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jun 2022 19:23:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caw1lV32PfJT3a74bvVj/cxJ6dAwlH/x53kPuBmonqUE7yGEOTNzEI67JFqE7/z0SfDVSEdfNCcKa/s7vX2gkgZkZF0TjM/msyE9lMJg/tlP30eXjgwUtFDL70sUcqgMTj4yMp5S4eg7J0fVwaRuqDmLWTzlftBPrlNznOnynxT7aQyj0CC7Nzs3LlmzsAVdjiqFtcGWiCiucKLbt5aqjlTKTfIIzp8KB4ha2BFYOwO6pb6OvXCURZOM1BGqKlXJyM6KUfnAE3XulS/cKjpNO4cFTB7P/f18qJTa9Ze/8pF/8VlpWwmjEsLI8Sy+1FN3+QwfsyqVfSwCaAzG7OZq2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UvsC96rdwbk2Rf43XW8g1ZxnOXqB282d+0rhrTyz3h4=;
 b=grDVXIre/hHvkLJ2LKvm0fNkSgSDTswUe82iSxvbf04+Tn/9nmcbUHT8aW2SlePl516gXjbmtIaSBG1vgi10z/miovMsMCVXFjvfuDovhCZdJi/yC32uFbmOnWSUkWkebkhaas8dvQVphZrpcuIsr26wJVBJt+XR7o4AN4/oa39tvH9gCiE9XgArwk6apLGKb1IilWBAMmCPAenkXMR9yaNvaWo/BGEQL2UAiBJYSDuf7rRelAyWQRJO/CWGnY9CVlEciCgfNqXcXm8achBoN7VEw1jATOICU5f6hLyw/iECMJfRwcKzUOmbs6iwIajYAr7dbw6IUQQ+M9Y9/4KoGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvsC96rdwbk2Rf43XW8g1ZxnOXqB282d+0rhrTyz3h4=;
 b=BvVgnTuPjdWGV+CDaa9i4H8rSmPJj5KZ9djdKpbTAadVdtRYH7/JvLtfmQvgRvgQAjWQ0woqSOQSNn+O6mBmDVT1vO40Yz7DZUCYtL2JV8ES/i3o3f7T1b7PDVzL8JgBm1VcPRuo4ELXHJz4p2yIV8nCNTKC3kkZaaDUlteQIgo=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4370.namprd10.prod.outlook.com (2603:10b6:a03:20b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Wed, 29 Jun
 2022 19:23:08 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%8]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 19:23:08 +0000
Message-ID: <f9dba9882988e90a72b4e3a938f68f3da7698db7.camel@oracle.com>
Subject: Re: [PATCH v1 09/17] xfs: extent transaction reservations for
 parent attributes
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Jun 2022 12:23:07 -0700
In-Reply-To: <Yryb4TYRKm+g0iBv@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-10-allison.henderson@oracle.com>
         <Yryb4TYRKm+g0iBv@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::25) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c14269d-bcad-43ca-e19e-08da5a04cc88
X-MS-TrafficTypeDiagnostic: BY5PR10MB4370:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nm1eihLqde40z9l2GAXbrJEqsPIZD2E8DcfgRsJDUEkG0l1P5uvkL7apRifd8H0woYKhcFajhey1fOcOAXCBDLigGeBychxT7BsRCacHKXyv2SVRJe8mrDa+oSzbPOblEynp8KEMgL+rFQU4WJ2KWns7m/IOdo4Tn7A/lM+TgVHfGs26lHLzh5Ky6bbHoaMG0lyC0JwrQOH39iSF11K0XkMaGkBwTGVQuhlFcywo+2AjHdl1wry/NZFmMoaPhBX1sjUM5iXLZGpynSaC9p1f6evX0kVVeRhT40PdFd0G+ndSRijIxzgdwlH9TSfZF9AB2uZZbWzNWcnXrt/IKumr2UrgktiJv2AujtrwBto/ST7HeHfldx3lnYgMOBjS7oPLwDylRaXjg2mgvsGgKh+N7weRV/ggx1l7kbMI+/xp7ajqI0KSEdFb92wUtm/DOXlJbJbx0ZvnGe+oCq9FVi1uuG8vu1yn8YAlg4XNW+xTi3lHzxy5iXGqLO0ISIO5gza5syFPp8GaZEzet5w6MClRS+fpLhe9i+xOJu/M0tlKadI5lZZJvDucijPZ3YYA6uNjCHL9aZaDe08nATeAkceDPA1f4fdExEIDBFaMD8N/sqvVlj9SbbqYEkIKnOvkY07skVl0Sy709608Eqg6BaZHwVzexJGpZRs+TJbET14rHmWZuI5rpBepZi46V3SAOnF5dYkp5ML95UdCI5dLgxUsYvB/SfBUr9Agx5z9Op9BliAWzJp6SeiyWREfiUPvDmjJhxR7hwMqGejlVXdRzaGeEpuFDgXboJtWaKQVwEAtA0o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(136003)(366004)(396003)(376002)(8936002)(6486002)(478600001)(6506007)(6512007)(41300700001)(2906002)(52116002)(26005)(5660300002)(86362001)(38350700002)(8676002)(38100700002)(2616005)(186003)(6916009)(83380400001)(66946007)(36756003)(316002)(66556008)(66476007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDEwTnBwamhKcTQ5Rm9DdXZuTjkvK2ZWYmRlZlQrS0g5S1pFUmFhVXIzRVBB?=
 =?utf-8?B?L0FzeldrZ0NpeDVyWTY5UFVEQytEVTFiaDBjdFEyNVlRQkc4Qks5ZjBzeFBi?=
 =?utf-8?B?UGt3VWxvY1VnOUpYRjJXOEtDMENsSGpZUUEyL0UvRFRMRlBnT215UFpRR2hr?=
 =?utf-8?B?VW9vT3JzREVBMFJuN2hyL2huL0VKc3YrVGVzT3o2SFMwYnRNdDR0Y2lVVFhj?=
 =?utf-8?B?TDIvbGFnNmdMN2Frekp0TVFNYTdTSWppU3ZiblM5SkpSMlVFb3RXaWtNbjFk?=
 =?utf-8?B?OEFpQW85THVqK2RVdERhZUlNTk1GREIzZ0FjZG56bXRmbzlLZ09KWXVWUTNO?=
 =?utf-8?B?a054dUNKUXlMUmZmQmNOWk80WEVkT085eTBsaHFmL2taL3lPSENIRHNuR01L?=
 =?utf-8?B?cHhTQ0hNYk9PK3RVVnJLcHFUYkJIOGNJWTJ6QmVoWC9rcUpvOGhEbDVYcjdO?=
 =?utf-8?B?b0pJdFRXMkk4bzI2akUzREM4OExkNkFub1dPaS9uZkN6aGVXQnAwSlU2VVZY?=
 =?utf-8?B?dUhsMGNHN09GNDQ2Z2RNQVQ4aHBSY0JRM3VBcW1YNnJ0VGlUL1I0QUpKb3RR?=
 =?utf-8?B?ckpHMDVNZENoblR0eTF3cHJ3L0hHL1BJYXY3bFBQakpTdExOdVRXUmtRVFNm?=
 =?utf-8?B?eUk4Tnd3TFgzMFpybjBoLzNNZ01Yd0dNUk5Lblh3eEdzTjhZNWdSUUU1TGlu?=
 =?utf-8?B?SGE0ZHByM1FKWWNJb3Z4VkdjN05rMlZndFBCRkluendJbUY1MXhuV2VpMTRY?=
 =?utf-8?B?MVpGMlR0NEp0c3RGYkJkWDFWdG5YMDRzRDYwOUJHTmZNZjF3WENMNjh0Rkc4?=
 =?utf-8?B?ODBrbVBvLzJXM2QvdGxNd211KzBBa3VHdjNnTCsyNmtZRGIwcVkvS3pnR2p3?=
 =?utf-8?B?dWZka1B3REZZNmJwSVl6bG85eC9VTnlobCt3Q1hCeU56cUVwZ3o2NndkYWVp?=
 =?utf-8?B?RTdkL3RndzNMYjZLV3pkMC9ZZmZKbzBOUVFuekhSdThXbUg3N0F3YXBoNFQr?=
 =?utf-8?B?bDV3MkV5aFdDTzlZcW1MWlYxMUM3a3JSTWlrRmVyRmNoVCtRQm5XU2tMRVl3?=
 =?utf-8?B?RTE2dklCdElvN1YwU3lEeXRMNy9qcDdPQjhHTVE5c21TZlI3djNadVg0VytX?=
 =?utf-8?B?MW55ZDJ1dlljc1lWKzQwOFdQc3JxVmJjWTVRV0E1Y0pZT0xNUG1KSGdzcSs1?=
 =?utf-8?B?TUdrTVQ5NTc3N1JDb0RVb3AwL1BWV1ZuQ2NBSFdvb3JlUnVVdzhXV2I0blhV?=
 =?utf-8?B?eE4zdDRxdzVkYzJVeEhMSW1ENHN4TEQ5RytjWVpGS1ZKNkhVaXV5N1FHRGRZ?=
 =?utf-8?B?NHd5bHpPOUVjWng4aTJVMWdFbW1WUjB0VVo4YTZDZTU0Tk5VKytjTE9XOXFa?=
 =?utf-8?B?NE16NlRraGxsZG9qZlJEWUNoaTR6S0FKRXFIZ2daT1A0TXkzVnJvN2xILzVO?=
 =?utf-8?B?VkloU2lHTzFKZ0FCenl5RkNQQ1UzeDArazEvdGdCbnFGQ29OdTROV0FMZDVW?=
 =?utf-8?B?UlJydm1NRG9Fd3JIYTIvSFB4QjhKaERtc0NJWUt5YU5LcWNaamd0VkJOYzBx?=
 =?utf-8?B?NGw2c0Vka1BKR25NdThzc2s4WG1nQmEwcTMvVTlEVkdNamNyTXBTT0F0QzRF?=
 =?utf-8?B?YldGTURNckxiTGNFd1JpNjV5U2J0Z1pxbzBickg3NEczMTlzclBuYmZQNGtx?=
 =?utf-8?B?NzBxRjAxSzV1OTY0WHo1ZzJZWHBRSVUxRjkxMjhYMHJkNG9mM3hTOG9ySVht?=
 =?utf-8?B?bW9SWTlYZFhJYUlVT2pOQUpvWm8zRHNJNGFmYmwzclcxWGJ4YXBPSWcvL2lD?=
 =?utf-8?B?elJWdjZqTzhmK1RxczA0eUN1WWZnRDh6dTZPaXdDVFJEN2l4WEVEK1l1ei9X?=
 =?utf-8?B?dG1YUDdUbXZWUDRzenpuYW50cGVQSVc4YzN3L3cwRVA3dmY4aWF3NGFnZmNr?=
 =?utf-8?B?V2dlRGFJQWVtS0tzOWpYem5NR0VjY00wWTd5Z29oMFRSSjIrTTJ6VlQ2QTJv?=
 =?utf-8?B?UHBHbUZBcVZodForUVZKKy9ncEJWZWUxOUpuaXVBSDdBRnUyUVV6UVRzNmJF?=
 =?utf-8?B?enZzWlJQelViVDNlQ29DNEZraWorVTRROGxUYXo0cVhRRis3Nzh5QU1WakV1?=
 =?utf-8?B?a1Y5L2EzWDN0MTNuZlBHZnNWUWt5aCtOaGRWMjRsWlpGK3pYYkJyeEZoSFd0?=
 =?utf-8?B?UlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c14269d-bcad-43ca-e19e-08da5a04cc88
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 19:23:08.5800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9JmYRT1SoKSyZp5v/Niu0suWfw8oSNmZQVBmTRdxcO8oaDbDeQW3Cjn2/W4JGJ5Kanr0cFWrSPUB557bii90GjTy5+2AtG3jtDhacUfyl28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4370
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-29_20:2022-06-28,2022-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206290068
X-Proofpoint-ORIG-GUID: 138SvgrdKx7HBQvnhD3h5j2Eg3_aL5lg
X-Proofpoint-GUID: 138SvgrdKx7HBQvnhD3h5j2Eg3_aL5lg
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-06-29 at 11:37 -0700, Darrick J. Wong wrote:
> > Subject: xfs: extent transaction reservations for parent
> > attributeso
> 
> s/extent/extend/?
Yes, will fix

> 
> 
> On Sat, Jun 11, 2022 at 02:41:52AM -0700, Allison Henderson wrote:
> > We need to add, remove or modify parent pointer attributes during
> > create/link/unlink/rename operations atomically with the dirents in
> > the
> > parent directories being modified. This means they need to be
> > modified
> > in the same transaction as the parent directories, and so we need
> > to add
> > the required space for the attribute modifications to the
> > transaction
> > reservations.
> > 
> > [achender: rebased, added xfs_sb_version_hasparent stub]
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h     |   5 ++
> >  fs/xfs/libxfs/xfs_trans_resv.c | 103 +++++++++++++++++++++++++++
> > ------
> >  fs/xfs/libxfs/xfs_trans_resv.h |   1 +
> >  3 files changed, 90 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h
> > b/fs/xfs/libxfs/xfs_format.h
> > index afdfc8108c5f..96976497306c 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -390,6 +390,11 @@ xfs_sb_has_incompat_feature(
> >  	return (sbp->sb_features_incompat & feature) != 0;
> >  }
> >  
> > +static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
> > +{
> > +	return false; /* We'll enable this at the end of the set */
> > +}
> > +
> >  #define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed
> > Attributes */
> >  #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
> >  	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.c
> > b/fs/xfs/libxfs/xfs_trans_resv.c
> > index e9913c2c5a24..fbe46fd3b722 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.c
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> > @@ -909,24 +909,30 @@ xfs_calc_sb_reservation(
> >  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
> >  }
> >  
> > -void
> > -xfs_trans_resv_calc(
> > +/*
> > + * Namespace reservations.
> > + *
> > + * These get tricky when parent pointers are enabled as we have
> > attribute
> > + * modifications occurring from within these transactions. Rather
> > than confuse
> > + * each of these reservation calculations with the conditional
> > attribute
> > + * reservations, add them here in a clear and concise manner. This
> > assumes that
> > + * the attribute reservations have already been calculated.
> > + *
> > + * Note that we only include the static attribute reservation
> > here; the runtime
> > + * reservation will have to be modified by the size of the
> > attributes being
> > + * added/removed/modified. See the comments on the attribute
> > reservation
> > + * calculations for more details.
> > + *
> > + * Note for rename: rename will vastly overestimate requirements.
> > This will be
> > + * addressed later when modifications are made to ensure parent
> > attribute
> > + * modifications can be done atomically with the rename operation.
> > + */
> > +STATIC void
> > +xfs_calc_namespace_reservations(
> >  	struct xfs_mount	*mp,
> >  	struct xfs_trans_resv	*resp)
> >  {
> > -	int			logcount_adj = 0;
> > -
> > -	/*
> > -	 * The following transactions are logged in physical format and
> > -	 * require a permanent reservation on space.
> > -	 */
> > -	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp,
> > false);
> > -	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> > -	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > -
> > -	resp->tr_itruncate.tr_logres =
> > xfs_calc_itruncate_reservation(mp, false);
> > -	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> > -	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > +	ASSERT(resp->tr_attrsetm.tr_logres > 0);
> >  
> >  	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
> >  	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
> > @@ -948,15 +954,72 @@ xfs_trans_resv_calc(
> >  	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
> >  	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> >  
> > +	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
> > +	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
> > +	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > +
> > +	xfs_calc_parent_ptr_reservations(mp);
> > +}
> > +
> > +void xfs_calc_parent_ptr_reservations(struct xfs_mount     *mp)
> 
> Indenting, etc.
> 
> Also vaguely wondering if this should be static inline?  Or does
> something else call this?

Yes, I think it can be made static, nothing else needs to call it.  Thx
for the review!

Allison

> 
> --D
> 
> > +{
> > +	struct xfs_trans_resv   *resp = M_RES(mp);
> > +
> > +	/* Calculate extra space needed for parent pointer attributes
> > */
> > +	if (!xfs_sb_version_hasparent(&mp->m_sb))
> > +		return;
> > +
> > +	/* rename can add/remove/modify 4 parent attributes */
> > +	resp->tr_rename.tr_logres += 4 * max(resp-
> > >tr_attrsetm.tr_logres,
> > +					 resp->tr_attrrm.tr_logres);
> > +	resp->tr_rename.tr_logcount += 4 * max(resp-
> > >tr_attrsetm.tr_logcount,
> > +					   resp-
> > >tr_attrrm.tr_logcount);
> > +
> > +	/* create will add 1 parent attribute */
> > +	resp->tr_create.tr_logres += resp->tr_attrsetm.tr_logres;
> > +	resp->tr_create.tr_logcount += resp->tr_attrsetm.tr_logcount;
> > +
> > +	/* mkdir will add 1 parent attribute */
> > +	resp->tr_mkdir.tr_logres += resp->tr_attrsetm.tr_logres;
> > +	resp->tr_mkdir.tr_logcount += resp->tr_attrsetm.tr_logcount;
> > +
> > +	/* link will add 1 parent attribute */
> > +	resp->tr_link.tr_logres += resp->tr_attrsetm.tr_logres;
> > +	resp->tr_link.tr_logcount += resp->tr_attrsetm.tr_logcount;
> > +
> > +	/* symlink will add 1 parent attribute */
> > +	resp->tr_symlink.tr_logres += resp->tr_attrsetm.tr_logres;
> > +	resp->tr_symlink.tr_logcount += resp->tr_attrsetm.tr_logcount;
> > +
> > +	/* remove will remove 1 parent attribute */
> > +	resp->tr_remove.tr_logres += resp->tr_attrrm.tr_logres;
> > +	resp->tr_remove.tr_logcount += resp->tr_attrrm.tr_logcount;
> > +}
> > +
> > +void
> > +xfs_trans_resv_calc(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans_resv	*resp)
> > +{
> > +	int			logcount_adj = 0;
> > +
> > +	/*
> > +	 * The following transactions are logged in physical format and
> > +	 * require a permanent reservation on space.
> > +	 */
> > +	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp,
> > false);
> > +	resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
> > +	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > +
> > +	resp->tr_itruncate.tr_logres =
> > xfs_calc_itruncate_reservation(mp, false);
> > +	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
> > +	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > +
> >  	resp->tr_create_tmpfile.tr_logres =
> >  			xfs_calc_create_tmpfile_reservation(mp);
> >  	resp->tr_create_tmpfile.tr_logcount =
> > XFS_CREATE_TMPFILE_LOG_COUNT;
> >  	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> >  
> > -	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
> > -	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
> > -	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > -
> >  	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
> >  	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
> >  	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> > @@ -986,6 +1049,8 @@ xfs_trans_resv_calc(
> >  	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
> >  	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
> >  
> > +	xfs_calc_namespace_reservations(mp, resp);
> > +
> >  	/*
> >  	 * The following transactions are logged in logical format with
> >  	 * a default log count.
> > diff --git a/fs/xfs/libxfs/xfs_trans_resv.h
> > b/fs/xfs/libxfs/xfs_trans_resv.h
> > index 0554b9d775d2..cab8084a84d6 100644
> > --- a/fs/xfs/libxfs/xfs_trans_resv.h
> > +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> > @@ -101,5 +101,6 @@ uint xfs_allocfree_block_count(struct xfs_mount
> > *mp, uint num_ops);
> >  unsigned int xfs_calc_itruncate_reservation_minlogsize(struct
> > xfs_mount *mp);
> >  unsigned int xfs_calc_write_reservation_minlogsize(struct
> > xfs_mount *mp);
> >  unsigned int xfs_calc_qm_dqalloc_reservation_minlogsize(struct
> > xfs_mount *mp);
> > +void xfs_calc_parent_ptr_reservations(struct xfs_mount *mp);
> >  
> >  #endif	/* __XFS_TRANS_RESV_H__ */
> > -- 
> > 2.25.1
> > 

