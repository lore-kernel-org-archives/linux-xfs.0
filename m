Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3950C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 22:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239725AbiFOWcL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 18:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236349AbiFOWcJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 18:32:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A132249258
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 15:32:08 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FLvLOV029767;
        Wed, 15 Jun 2022 22:32:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=LN/4+X+2CJTAMB04KYQW81zJbxIJl5EjWgEaGw9qPsA=;
 b=UZrnRYE8Ro6WFVXXHh/jutCVC7BSX0Gl+naBQomaFmp03khGjG7XpRY1+gvUcPW4UoyX
 DwZMMQmdlMRGAjKycp87mg2nDok796uL/12mXKxBHgcstqABJGwC9nLeFUFOpfydonc0
 Zwh+zlWdOwFvztxwK+M4k6UTueJj+5R0+FUaqFfOSDkkoq8vFuK/jm8b+u3tN7qDkS6B
 FCcU5YjkFb09QvaXWbY5RA82gZmvesmB3dfwKHY72hVsVJ3YKWcpW1eZVvIB+1b/2C+I
 hYTk0sqtfHOMw++M7GigO6yLeEVV7wpzYlkcWPWDH29Ovhp+QzaJAZsqbaTzKiEw95fg Ww== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx9hjqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 22:32:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25FMFfb3022050;
        Wed, 15 Jun 2022 22:32:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpqwbet00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 22:32:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hq4ylGparWq33gN8KcnWw664j+QR7i460YrxbtIp+yfpYTsJ3rLzcHewTqThZXFTo7zuIOy9pbb0xNZ1RgU4Kc+bIXBv5c8A1T26LSRu2oAf9cLtuTYjE356fLA67b2YI3hSDWCzKCLhZQu7N+qmKhf7q4vsFAxeMGt+xM4iDWbEnUPOTrUtE9LDZ0GrlIJYzkjFPxqukG7zX98/J6O9kNqsQ9iflxOywFYTmptNgPVKZPeyqctxQ7rKdhXBoRLcQU0yBWZWD+yUeTSfmSfs1Q4FE/iPCq0Zv5O24lDwbw9FrG6YBUdBjavn6y8oszX0SdSYTuFfHWOSTTvax2kJPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LN/4+X+2CJTAMB04KYQW81zJbxIJl5EjWgEaGw9qPsA=;
 b=GNkn/660C2niW/uViZh+x0HgYQWW/1saaIN92bqfJq6H07niR1tIUXy1zN/MeWoYyRq/+414+TJSfgNOY59/ZfGNnz5NfMiWCe34itkwtfX5N6CDIIsBEMcNGE1/fyWwBO1e8C6wXrPDz9kGVhq5akbNRRHKyHzahjwjwdeae/mTd8aDHh3pAhFT6oxfEEXQfn74MasDrTxClONi00QhbidamGpKgKZy/kKrbkDvpm5pYNnwjWNu4IaXkXITWjJJ1qor7MS8ZwyBGvO1nzT81+jy9MPpmhRd546R/Vi9hazp7swQHJPau4InsXm3KYwYNAt6NWJ5PSZDUE3gIuWKPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LN/4+X+2CJTAMB04KYQW81zJbxIJl5EjWgEaGw9qPsA=;
 b=ajRgHUZBqxXWvJscIIpT3U/m7kK4tVUZgMAKJHiShlPSUgZALmJ9ztp3meUhnXsKyMNFyr0BNblJ3vRQ0RU43R/K5o1m10Wf5Ee+h4cT5JVjtS2IIjwA4182Tc/LZwwQiZ16DXrl4GbUVO0gGow2Hyb0hptdb5cVL6Mx8RvjEkY=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BN0PR10MB5141.namprd10.prod.outlook.com (2603:10b6:408:125::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Wed, 15 Jun
 2022 22:32:00 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%9]) with mapi id 15.20.5353.015; Wed, 15 Jun 2022
 22:32:00 +0000
Message-ID: <ec6a8b46f07f3a14c111360e7975cdfbfa43bf3a.camel@oracle.com>
Subject: Re: [PATCH 1/3] xfs: fix TOCTOU race involving the new logged
 xattrs control knob
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan.babu@oracle.com
Date:   Wed, 15 Jun 2022 15:31:58 -0700
In-Reply-To: <165463578858.417102.15324992106006793982.stgit@magnolia>
References: <165463578282.417102.208108580175553342.stgit@magnolia>
         <165463578858.417102.15324992106006793982.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0117.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::32) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf1a6d43-1751-4fc3-1fce-08da4f1edcf9
X-MS-TrafficTypeDiagnostic: BN0PR10MB5141:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB5141AEE72F712E60E65B5F7395AD9@BN0PR10MB5141.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oLEiM8HQKYfzXFHRc8wrAlKhztSBbGFtTlPLIZ+Ug+3aSuGNJdPRGXHiATzYdsdPY9RhexQ5iqbzL8UlcfPZc7hWM+Nmn7o8XEhJyZ0lLDr7Ev9vBp+rVA/dYUUpquej7QdheCotPhIv1xlOR1fk/9j+MdjIT6YFrx9HHeMkzfhnDYXwm+lOecelYi4fJj4g21A+3bBvSKfaD+jrxWO0UfPAydmvOFzLsvc3i6LmmDUPLbi1YWa2uNDJ0a1OOMY5JdSuieEUVjm52f4PbSOOpEMfphK2fIBvtubpI4bh7fvRID6PlegrZTDWbvY0wT8QIdhp8aBKWh6lQ9fvRA+M6xdjobI3xsmjqtvyyvg6HT2A4ffASwKh9P3RTPHrRna6GPkK5PCC4X+/SHwxbVOh+v6goV3VLK6zuHHdIWpwBy7caMKPFeniv2LhOhs3sdDVMopNUOpxfgY5ohIF0odSmUJRM9b7x48Cwq+oi2itgzmoKmb2IVXzs2umcqNhNOruVHj7rbtJO8r8ntfR1lD+dUIU7DgNuv4pBfuVInpjZyhuIk5mYH926l5FeQov0/01octe6cRoBa4SWx3IB9Y41rJJ87lFBrDsZ12HstAlqm8MZ8Rn8MG6WLpAZyOmNTfBTMcaRzvfqAtF7aSK9hjlcXqMMj49MP0+x31Ff1+A1+rrM8W7XhZh/HY9WqZvoeLFrRKKpgrhIUeMjuPBmdc7XQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(66476007)(508600001)(66556008)(8676002)(4326008)(8936002)(66946007)(5660300002)(107886003)(36756003)(316002)(6486002)(2906002)(6916009)(2616005)(6512007)(186003)(52116002)(86362001)(6506007)(83380400001)(38100700002)(38350700002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDBBVVBSODFBd3ZjeWo1WkdsSi9lM3U2dkRMTlJTdDRzOVQ2WmNWU2JXeHc2?=
 =?utf-8?B?QW9hTVpoK2dTZVV2STRsSTdmTUZTQzRTcmlTWDRSTWxvaDhDbWs5cmxRemRX?=
 =?utf-8?B?TkJSOS91eDV6UUZNRmc4TDd3Z3JyZXg1ZitUSDBJb3J5RW5ld1BWdE9GNVBI?=
 =?utf-8?B?TnBlcFcrYzhXcURkRFVmZW5MbnNha1RDMWFWNk9TOUZSMTBtdTJCY2VGdFZE?=
 =?utf-8?B?c2p6Q3FlZEFKSjBuM2t4MklidTBoTjV1M1RzcWdFK0VUL1EvUU1vTnRrV1Ns?=
 =?utf-8?B?UktsY0V1UitTSklDcjFaOVF6TmJaNklpcDdSajVBY3l4dTZZZm9jVWpXSU9M?=
 =?utf-8?B?VFB3ZkludFNxUzZqVDllc2YvV2F6ZHE5d1NMMVFwYmpxbS9VMFlWMldobXY5?=
 =?utf-8?B?T1Y1cGZkVjNiL3dMTmhhM1p6VGhHOTBOL1laUnJtUmN3enZ1dStQNnJteFNk?=
 =?utf-8?B?ekg2cGZKWkVrSitaUmdES2tqVSt0NGJqZ2lOTm1ueVpGaVBubTlMdUk0dUl1?=
 =?utf-8?B?RTN1MVkrMDF1OGh4RWJpeXh6eUZ6K2VZZmU1MW4wTFpOaEoxQnVhQVR1S2Jq?=
 =?utf-8?B?S25SVTRzRUhkWHhQVk43Y1hHdE4vbUhESDNuTW9nVWV0VlhiaXFUQ0J2cUsr?=
 =?utf-8?B?ZkF0Q0t4WDFNWks2TWkzN3Z5UlFkQ002TmRrSTVXZm9iYzN1a3Zla3lIcEVK?=
 =?utf-8?B?TU11cTZYUFJISldua0Y3blc5amUyclNYTVMrblJlQ2FQY2Q4a1BrUWU2ckNW?=
 =?utf-8?B?RFplSFNrUGIzcU12bGJQeUU3SmI0ZXlKUlo0ci9ic1VSR0J5a1JQS0lUeDh0?=
 =?utf-8?B?aWhwM2FwRnZIZkgySk5sbEhqbWlIMGdncHpTd3lrY2s0ajcwSmhNNXdCNW91?=
 =?utf-8?B?ZzhuWExaYnNkRjFhSWZVMVRtck1LRXUvWFFDZmdXMUpGRGtPYzMwY1ROQmhH?=
 =?utf-8?B?Y2ljTzFUbVVDaUJaT2xrTU5jc2sreFN5QXZFNkZuM1NQU0YvQ0hEVEJhc0Zh?=
 =?utf-8?B?am5PejBGYkltRHRXYWQvampBOTRrdnRQa05ob0lsSTdDZW55MFBGWlY4QjFo?=
 =?utf-8?B?aW00QnczNWhTQ1dNUUVaTmppNitQTldzYjhyZVVaZ0hWS1ZMaTBVQ2hBajh6?=
 =?utf-8?B?Z0NZeHBpcHBHbnlCSE8vaTZZOFRKMmZJVFlmQ09oS1hKZWRNd0JVSTM0NkRi?=
 =?utf-8?B?VTlNazRSL0duWGN3cHdKY1pUTW9ZTUI5L1EwbFhvN0xWQWJoQzIrd0FFamVs?=
 =?utf-8?B?Z290ekJURmNvdzZFUEk1ZHhBNnNjNXRvNnZzQUtWcXc3YWE2MHRCMnpEcnNy?=
 =?utf-8?B?d3ZaQzJ6RDJld1JKcXRDZ1B5YUZDWHJjTklPaElLcHhnMHB5djA2Y2FSdlhF?=
 =?utf-8?B?UjlxY2RnVkxoWnYzVVdzeWFvcGhVYkhKNFFFSVF0OHdwQ1I5MFAvTjR4ajU2?=
 =?utf-8?B?TUgyNzhYNXhGOEhVbmRUbVVWcDdHaWpUN09zc20vSDRXSFNTRm5SMldTMUg5?=
 =?utf-8?B?ZUJsLzE2cjAyOUhMWEdPRGoybVNxSVR4MmVrWU5vK3VzZ3J3OWQvSGJiLyt6?=
 =?utf-8?B?M0c4OUs1TnMybzlGaGVwZndvSVV6VGc2d3dpZDUvZDFuN0JNMHVWM3grdDRp?=
 =?utf-8?B?M1FKYytFUFppVjFtRE5heW9tM0ZjTy9wVkdMVnRmS1MwTVp5N1ltOTYvM3Vl?=
 =?utf-8?B?VkRFN2lMU2FZbFlPdXJuSjNYcGkvbEFBUElQMVR5empBc0gvNzM2VHppK0FX?=
 =?utf-8?B?NHQ0RWVnUVFDcGN5TWF6TzhOSVZGRUIrRjJCRldwTm5jWUdSYXBlZk0zT2RY?=
 =?utf-8?B?ZUF6aDFrS1c3dUVQc1ZkaGxyT1pLZExLaXpMYXVlazJ4a3FUaFluMHlHUGMx?=
 =?utf-8?B?NUsveENKL3ZKS0RYbFdLa3VHSnQvaDBvaVZzTFMrd1ZDeEFmY25oWVNJaSth?=
 =?utf-8?B?Sk1ZMVVycWVWUUt0STFVYXVEeWlEY24rKy9iS25yV0JDRWJPNldTNHpaY2JY?=
 =?utf-8?B?aGprejVBaHNvZmZCbXJONm52VzhLVlluYjdnbFNTODMwTC9aMEsyR2swaDdI?=
 =?utf-8?B?TFJiRk1URHR1WVJJZlNLK1NJWFJuWTMxemh2bzNNeTNSK2hPZC9KanJkdzRO?=
 =?utf-8?B?VlU2ZithRTlEa0xIMjlCZFUwcngwSUVPd1RoVGM2Z3NMckxNVmo0di9zS2V3?=
 =?utf-8?B?NjVNQ2RyUDVpVmRWTU5DVGlqOTdiUTc4bllaNUdwVDR5Q0YzdDVQVFJaOHFm?=
 =?utf-8?B?Z2lXNVlTVlQwbFhzMkF0T1V1ZHZZcFZPK3ZpOU56Qkpvb1NKb3k3T3pkcXRW?=
 =?utf-8?B?ZlhtZmVUL0djTWVheTdoNUhkdDVQdGRMMlRrcGVuc2hPSy9lbWh3ZEhKT3Nv?=
 =?utf-8?Q?kmHTT5E0XROdvZmw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf1a6d43-1751-4fc3-1fce-08da4f1edcf9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 22:32:00.3148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4CCHKloE53lcSjBSXZFUg9isXvr+E87atW3Gw3AS6mu/FXQzyb06Tm+SG9kNYzAKhgQgDdnreWPJFUNvqtlfCO+8cPp3JB7nXmz72lOLwog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5141
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-15_07:2022-06-15,2022-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206150082
X-Proofpoint-ORIG-GUID: -d9lkLQdsCOhrNIgQUB9Ob2sKYlRvA0W
X-Proofpoint-GUID: -d9lkLQdsCOhrNIgQUB9Ob2sKYlRvA0W
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-06-07 at 14:03 -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I found a race involving the larp control knob, aka the debugging
> knob
> that lets developers enable logging of extended attribute updates:
> 
> Thread 1			Thread 2
> 
> echo 0 > /sys/fs/xfs/debug/larp
> 				setxattr(REPLACE)
> 				xfs_has_larp (returns false)
> 				xfs_attr_set
> 
> echo 1 > /sys/fs/xfs/debug/larp
> 
> 				xfs_attr_defer_replace
> 				xfs_attr_init_replace_state
> 				xfs_has_larp (returns true)
> 				xfs_attr_init_remove_state
> 
> 				<oops, wrong DAS state!>
> 
> This isn't a particularly severe problem right now because xattr
> logging
> is only enabled when CONFIG_XFS_DEBUG=y, and developers *should* know
> what they're doing.
> 
> However, the eventual intent is that callers should be able to ask
> for
> the assistance of the log in persisting xattr updates.  This
> capability
> might not be required for /all/ callers, which means that dynamic
> control must work correctly.  Once an xattr update has decided
> whether
> or not to use logged xattrs, it needs to stay in that mode until the
> end
> of the operation regardless of what subsequent parallel operations
> might
> do.
> 
> Therefore, it is an error to continue sampling xfs_globals.larp once
> xfs_attr_change has made a decision about larp, and it was not
> correct
> for me to have told Allison that ->create_intent functions can sample
> the global log incompat feature bitfield to decide to elide a log
> item.
> 
> Instead, create a new op flag for the xfs_da_args structure, and
> convert
> all other callers of xfs_has_larp and xfs_sb_version_haslogxattrs
> within
> the attr update state machine to look for the operations flag.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Looks ok to me
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_attr.c      |    6 ++++--
>  fs/xfs/libxfs/xfs_attr.h      |   12 +-----------
>  fs/xfs/libxfs/xfs_attr_leaf.c |    2 +-
>  fs/xfs/libxfs/xfs_da_btree.h  |    4 +++-
>  fs/xfs/xfs_attr_item.c        |   15 +++++++++------
>  fs/xfs/xfs_xattr.c            |   17 ++++++++++++++++-
>  6 files changed, 34 insertions(+), 22 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 836ab1b8ed7b..0847b4e16237 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -997,9 +997,11 @@ xfs_attr_set(
>  	/*
>  	 * We have no control over the attribute names that userspace
> passes us
>  	 * to remove, so we have to allow the name lookup prior to
> attribute
> -	 * removal to fail as well.
> +	 * removal to fail as well.  Preserve the logged flag, since we
> need
> +	 * to pass that through to the logging code.
>  	 */
> -	args->op_flags = XFS_DA_OP_OKNOENT;
> +	args->op_flags = XFS_DA_OP_OKNOENT |
> +					(args->op_flags &
> XFS_DA_OP_LOGGED);
>  
>  	if (args->value) {
>  		XFS_STATS_INC(mp, xs_attr_set);
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index e329da3e7afa..b4a2fc77017e 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -28,16 +28,6 @@ struct xfs_attr_list_context;
>   */
>  #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a
> value */
>  
> -static inline bool xfs_has_larp(struct xfs_mount *mp)
> -{
> -#ifdef DEBUG
> -	/* Logged xattrs require a V5 super for log_incompat */
> -	return xfs_has_crc(mp) && xfs_globals.larp;
> -#else
> -	return false;
> -#endif
> -}
> -
>  /*
>   * Kernel-internal version of the attrlist cursor.
>   */
> @@ -624,7 +614,7 @@ static inline enum xfs_delattr_state
>  xfs_attr_init_replace_state(struct xfs_da_args *args)
>  {
>  	args->op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
> -	if (xfs_has_larp(args->dp->i_mount))
> +	if (args->op_flags & XFS_DA_OP_LOGGED)
>  		return xfs_attr_init_remove_state(args);
>  	return xfs_attr_init_add_state(args);
>  }
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c
> b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 15a990409463..37e7c33f6283 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1530,7 +1530,7 @@ xfs_attr3_leaf_add_work(
>  	if (tmp)
>  		entry->flags |= XFS_ATTR_LOCAL;
>  	if (args->op_flags & XFS_DA_OP_REPLACE) {
> -		if (!xfs_has_larp(mp))
> +		if (!(args->op_flags & XFS_DA_OP_LOGGED))
>  			entry->flags |= XFS_ATTR_INCOMPLETE;
>  		if ((args->blkno2 == args->blkno) &&
>  		    (args->index2 <= args->index)) {
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h
> b/fs/xfs/libxfs/xfs_da_btree.h
> index d33b7686a0b3..ffa3df5b2893 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -92,6 +92,7 @@ typedef struct xfs_da_args {
>  #define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode
> timestamps */
>  #define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation
> */
>  #define XFS_DA_OP_RECOVERY	(1u << 7) /* Log recovery operation */
> +#define XFS_DA_OP_LOGGED	(1u << 8) /* Use intent items to track
> op */
>  
>  #define XFS_DA_OP_FLAGS \
>  	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
> @@ -101,7 +102,8 @@ typedef struct xfs_da_args {
>  	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
>  	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
>  	{ XFS_DA_OP_REMOVE,	"REMOVE" }, \
> -	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }
> +	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
> +	{ XFS_DA_OP_LOGGED,	"LOGGED" }
>  
>  /*
>   * Storage for holding state during Btree searches and split/join
> ops.
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 4a28c2d77070..135d44133477 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -413,18 +413,20 @@ xfs_attr_create_intent(
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	struct xfs_attri_log_item	*attrip;
>  	struct xfs_attr_intent		*attr;
> +	struct xfs_da_args		*args;
>  
>  	ASSERT(count == 1);
>  
> -	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
> -		return NULL;
> -
>  	/*
>  	 * Each attr item only performs one attribute operation at a
> time, so
>  	 * this is a list of one
>  	 */
>  	attr = list_first_entry_or_null(items, struct xfs_attr_intent,
>  			xattri_list);
> +	args = attr->xattri_da_args;
> +
> +	if (!(args->op_flags & XFS_DA_OP_LOGGED))
> +		return NULL;
>  
>  	/*
>  	 * Create a buffer to store the attribute name and value.  This
> buffer
> @@ -432,8 +434,6 @@ xfs_attr_create_intent(
>  	 * and the lower level xattr log items.
>  	 */
>  	if (!attr->xattri_nameval) {
> -		struct xfs_da_args	*args = attr->xattri_da_args;
> -
>  		/*
>  		 * Transfer our reference to the name/value buffer to
> the
>  		 * deferred work state structure.
> @@ -617,7 +617,10 @@ xfs_attri_item_recover(
>  	args->namelen = nv->name.i_len;
>  	args->hashval = xfs_da_hashname(args->name, args->namelen);
>  	args->attr_filter = attrp->alfi_attr_filter &
> XFS_ATTRI_FILTER_MASK;
> -	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
> +	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
> +			 XFS_DA_OP_LOGGED;
> +
> +	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
>  
>  	switch (attr->xattri_op_flags) {
>  	case XFS_ATTRI_OP_FLAGS_SET:
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index 35e13e125ec6..c325a28b89a8 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -68,6 +68,18 @@ xfs_attr_rele_log_assist(
>  	xlog_drop_incompat_feat(mp->m_log);
>  }
>  
> +static inline bool
> +xfs_attr_want_log_assist(
> +	struct xfs_mount	*mp)
> +{
> +#ifdef DEBUG
> +	/* Logged xattrs require a V5 super for log_incompat */
> +	return xfs_has_crc(mp) && xfs_globals.larp;
> +#else
> +	return false;
> +#endif
> +}
> +
>  /*
>   * Set or remove an xattr, having grabbed the appropriate logging
> resources
>   * prior to calling libxfs.
> @@ -80,11 +92,14 @@ xfs_attr_change(
>  	bool			use_logging = false;
>  	int			error;
>  
> -	if (xfs_has_larp(mp)) {
> +	ASSERT(!(args->op_flags & XFS_DA_OP_LOGGED));
> +
> +	if (xfs_attr_want_log_assist(mp)) {
>  		error = xfs_attr_grab_log_assist(mp);
>  		if (error)
>  			return error;
>  
> +		args->op_flags |= XFS_DA_OP_LOGGED;
>  		use_logging = true;
>  	}
>  
> 

