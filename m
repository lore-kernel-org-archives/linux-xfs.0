Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FD4C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 01:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiF3Ba2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 21:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiF3Ba1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 21:30:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F8B3138D
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 18:30:23 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25TM4BbA014124;
        Thu, 30 Jun 2022 01:30:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=VPPes2HxDyY5p11bCBckO/NRTpcKtHTAj1P1mFNjfss=;
 b=ADdw7X0FSU4+JbRM+p5s7LU3HC0bQNmFE4APyzuUsq0FtqYaDaZ4PuS8Y4jVl+D5f5/L
 9sIaC0+lBItRSnNR27Ouk1ZPcVBwxKeF5Ps+PyWtJkYDxN7dg9MsIDr6I7Pbi2naRT73
 FtDkjIVhZBq0NNihW/vzHEGBpqWflVVxg06FiD/4IRmdJC01HHvH/jwp+VXO2G5OcwV/
 Q6yblP9vKCJtvac9OqUmMLzN5XcPKQnRTiaaeQstQkFloBN1xw2gArWLWJ9dDNO7G7Uj
 gEwXiS0lrlm19OQ39kPXZz+nTctqzl2WwyTFbbuqU1uZWGc3mU3gZ80PwHaOTiEXy18+ yQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwsysjp02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 01:30:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25U1L08V001721;
        Thu, 30 Jun 2022 01:30:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gwrt4081u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jun 2022 01:30:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cyz8Chpr22nS4P7b/rIGM3jKOEVI4wj6tMkb7LlHZT9UkIX4Y2e3bPNdt+6Cg1EniZjA5/Rpb391lLU5ii/wqkzYdmZO4zULjBJxxELI93d1nrsxi645RRxdoLxo/K9LbalmLKaX7v/rLa9FnK+LfLFhIGNKoTLK26geb9DngQW3wsNRRbSVXGANDO/gPLWYA7jQVSYmavn8Xn/DbrT53el3K6PlgLAcf8FJtE3YRaJlwKvQDgYV8Rvtatakscc2CY+dPbvwAnofh9ct+/bzzRsubJccBBqYWRjWeBrw4Yrelb3LCU90b24ULhtonNkpvDMGDMtFvH4JokKup5h9ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VPPes2HxDyY5p11bCBckO/NRTpcKtHTAj1P1mFNjfss=;
 b=blYRv4mV6Y53jSyb+m/vJg6wJou0bLdU2k+tv+f/RnNIjFuc22J2RWMD39SsoeLzPmfe1SeNTDFAIGi+STFhfEvL68XJ2Cy5M8H6p+1aA0el6JrQFEso/hKrQa3lBOFH2lvXC8710nTwAb2xKGE5TWzdWL90xmFVucA4JkKsXvqEe72wFv+sA7MGBrJeTwAz7UXKQEv75t3n1/zxCm6SRU6hVj+h/9E1NaN4tMfp5J6fUbXYUjpmJ3O44oFSRM9OCoxXjL4HJe3ja20pUB+aKBstSe7BIpDB5CWFJXcmJZIg6nmeZUQEI73NDUUfwvMpzBIObTBDP8fRbiUkXiEhVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPPes2HxDyY5p11bCBckO/NRTpcKtHTAj1P1mFNjfss=;
 b=Gqnn3hYAIIop3SHeKjkqH0pfpB/aBhxgMZHUYdDqqiNQWuyEPWH7hg/a4ersIxVkiRocmJ72oNZHGZzkgC1+idX0BCwffKxZJPSewrqhogK7XCGDsjFa11w31diAkVs3Un50fuTVUQCx+gy9pq1MxkbGeBmk3yRNnFD6Xr2xH70=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by BN0PR10MB5502.namprd10.prod.outlook.com (2603:10b6:408:149::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 01:30:16 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::3402:abab:e2f5:33bc]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::3402:abab:e2f5:33bc%9]) with mapi id 15.20.5373.018; Thu, 30 Jun 2022
 01:30:16 +0000
Message-ID: <78c895e7da0700d5397e958d44990d16a354d3e8.camel@oracle.com>
Subject: Re: [PATCH v1 17/17] xfs: Add parent pointer ioctl
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Jun 2022 18:30:13 -0700
In-Reply-To: <YryfdCrBUyH6jOij@magnolia>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-18-allison.henderson@oracle.com>
         <YryfdCrBUyH6jOij@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0183.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::8) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb03e58f-1485-48f2-3af6-08da5a3815ea
X-MS-TrafficTypeDiagnostic: BN0PR10MB5502:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NRvi4PZnq+gezDjuHoqAxcrve1SdJrAD6R8OMGNbPoyMpULRBrFVJ5iouG9DdosYv58wdscW2coDTY8DYQdoSXyJch1gkNSKrHef2MdKRGtHWF794Q5yitJA3tR1Z2UxD3EPqJNFFHLu2IQSXZSTuSQI9tWyWDV6cmOreiZyhdlcfcmBWn+aBiIpshDNijmS/j9ZideWN2BJ5x7tlfrVQfMypHdvYM+oaE4mZKTDQ/oKPgTb1btc1z50yTGrpqA9LYI0rYBwYW/ljJNsaklveKO8mt9YQdjG62MxU6Et7kPJWJrD7NQvBj6zLJXe+aBxwpyrxOe+xfneCwwt+WX5EeKQKbFQjo0xrHRIfZFqUOVfgHNn7HVbhzoMTPVfHG72h+cwvu6sTZTEKZjJhbbae4kdk16mMUoQ9+aoVR7zI909NTeESmwsZIRLG+zVb7trFQrwaptZi8iqTy2fZC0HZp0S2B4Xj2mHl5wYaaWrNNhfguFdVPtq15YmAbxtLtpIjqUXH99OnWQo33k9ejBVJHpPcd0FS4BmJIqd9SjqykSo55Rh9Qeoeje+3TwNzBxCLEpq9mWsEJMOTB19K42IsU8D41i7hn9/vvozPiODXi/biNjO+va/BbbIAnexd9/MTHkrr8Fz72DEgFKk44+z9sGs1z5ms6lGGCyK82dP7Fp77fTHhbLj8PEgKFY1s29B3Np41RygJYHQpI2m3PsiuQk4tU4bQOC5cJ+DHt60Y9dB79obKscF+jeijB14lL5RF6EEm7rMPyXvxMBinm1l4/fcrs7kSpIppdnG1EzpHhI+Zczd5ki5snxoVZXx/PrT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(39860400002)(136003)(396003)(38350700002)(6486002)(86362001)(38100700002)(2906002)(8936002)(5660300002)(41300700001)(316002)(30864003)(478600001)(6666004)(8676002)(4326008)(66946007)(66556008)(66476007)(186003)(83380400001)(6506007)(52116002)(2616005)(26005)(6512007)(6916009)(36756003)(2004002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tm1XaTFGZXNUWHR2Kzc3bGtTTVVweCtrSFlHMDZTNnkrSEgrRnJuUzRNRnB2?=
 =?utf-8?B?dldwMmhpaCtuM2N5ZVh3TVpqNjJSNmpreXNVZmwxc1dsejNKRHVWL1FxVTN4?=
 =?utf-8?B?VUJYYWp6MXl5dlRQZXVkVm12TkFxeWJ2QkdwWkFUK1hhNXAzZjEzaUhHWS9n?=
 =?utf-8?B?dFpINi9aUXdWdE5OUURHVHlqTlpLNlUvRE5NR2JoOFVlWHhqanREN0xQa1JE?=
 =?utf-8?B?eWhTNnNZcXBqTE9EZnU5K3hIcTRjeU0xTjFNRk1oZlFPYnlSU2lKNmo4MDJS?=
 =?utf-8?B?N0NXczZPZTZ0Rit4TnpmYk42MEl3RXN6UDZ5RTBNVkxjQVpyWHMrTzFSSHl4?=
 =?utf-8?B?SjBSb1NqV0l5ZmluQk90bnZWZlUyWEFML0RTZXl2TzJPejhRTGt0UlRXTmJs?=
 =?utf-8?B?dXcwcmdKYkE5b2dwNm5WaG9RbzBZOXdwRmxpWXRIZm53VUdaRVkrMlVPNHVk?=
 =?utf-8?B?ZUtoZm4rRkxXdnpyM0piaTJnL3NQUS9WSVkrdWY3T2wxSjAzZnVrT1FXdWFr?=
 =?utf-8?B?b1A4emJsY1JJRnVNa0VoNXRCUGg0SG9GVjIrbjdoWjA1NkIvQ3pDN0NRRWNm?=
 =?utf-8?B?OHNXc2hKY1ZuTDZqaW1TUm80dXlaVWxOWUJ1a2pxNml4RGp0bkhnTFRBcCtQ?=
 =?utf-8?B?b09rT3VxNFI3RElISmF6STRQWkM1d3k0dmNvdFJJeWdJdjQ3TUxmUUJnMkRU?=
 =?utf-8?B?S0ozejZMRjFWOTBzeWJPYUZZalUrNE1zWDAwZTZURXYrQnZhRWo5clcwUWRm?=
 =?utf-8?B?Z2xuTXJ5OE9FT2xnVWQvZHY0aDQwSHpzWXpVUGtJUU91V1J6aStpWWJZek40?=
 =?utf-8?B?ZHkvbllLTWRwWUNZREJtVXJUMkVZMDBrQmpzOGxqYzBwa01uZ0w1UVhTK1hL?=
 =?utf-8?B?eWlEbFFJbHZOVmJsWWxTMTlLWWRLS3lVVGNTeWc4KzhxaW40ZGNZQjNkZkd0?=
 =?utf-8?B?L3hWTHZscTNTMDFtZ0NRZjVvWkpmWE83RHR3SEVXZ1NBMmhPcU1sRUcxTyt3?=
 =?utf-8?B?OS90SU03UnlUbFJIeGJzbmJ3eHRubUxGNmlVdGZSbUVHUmVxMUZNMDVVcFk3?=
 =?utf-8?B?TkZ0bldWenBwWHVNNnFUeDdQamFibjVLZ1FXMTN3b283eUw4Q09wcmJMdldH?=
 =?utf-8?B?NGtmbStlK1gyZmtQVTJra05XR2tVRjB3c0tYSWtDekthcXJ4TlNqNVhEaTRx?=
 =?utf-8?B?eHdkR1llVGN5N2dxWndFSDJvUElNdW5mdWk1T1kvd0JqSVZ0LzhNMnhsOWlE?=
 =?utf-8?B?S0gxVDV6T3M2UzgyeVNaWUtmYUUwS2hycGViZi92bGQxditZeForRy9ZQVlF?=
 =?utf-8?B?YkgwamM2eUx1RkhhY2FBb0dyMVJhU3JVOHpoZHp5QWdlKzh0aEF3cnNNd3h6?=
 =?utf-8?B?NEQwUXFKK2Erd3Y3RHFVa25GYmVubXBrcjd4SHdYTGZPT1pzRkNZUEFtQjJU?=
 =?utf-8?B?R0RGVDFXVWo1RVplKzBwaVFkQy8wYXdGUWdmMGZnSnlyNEgzSXRxekw0blRr?=
 =?utf-8?B?YkNQVEJiR0ZrbU1paDJKVld3c0VFcXNLWlpSUWJZN2pma29JRGdTRUJlOS9m?=
 =?utf-8?B?ZlZyV2xxQzByeWRSK2g2b0ZoRVlzOUYwbmp5ZzZmanRna1RVOGhMMXdnVnFI?=
 =?utf-8?B?MjkyS2lDd0IrTjNHbnM0Z1ArcGN6TE0yM09waGNoNkNRZVJZNVJIY0ZDTG1p?=
 =?utf-8?B?UVNMT1FmWGxBQWZaaU9UWmxKVWxlMmUrUSt3M2FHaTltckdQNmljN2xtTTdo?=
 =?utf-8?B?R0tFVGMyNy9Wb2ZjQUpiSG4wRE1vSU8rNm1venZUd0tEd2sxZ1EwK0lESG9R?=
 =?utf-8?B?bU85S1FQd3krU1Uzd2tBbXA5SnNLMUlZaWpBMm95ZHlYTFV6Uzl4Zmo5dG90?=
 =?utf-8?B?Nko2bEdGbEowUjRWNGNhaStLNDNwVWhSM2pWeEhRWEdWK2JEYmFaeVFVYTRJ?=
 =?utf-8?B?cEEvTmZkM1pIODgyVEJ1bThTdU16ckZ1bjVTdFNXSTNoR2o2MkdRZ3BZMXFt?=
 =?utf-8?B?L2ExMDRkTUx6R1VzQzVSZk9qN211YkhRYVMweXMxS0JKeFovVVJiNFVIVG5k?=
 =?utf-8?B?TkRGeE1lYTBseU1GNmFXejNaUzFyVkdxd09wWnhnUmdSOGwwS3NsMDcxUzls?=
 =?utf-8?B?N2N0UHJIeXB4UlRrOEk3VFlnc0VyYS9HYkEzZFRQOGpGMlBQcnZ4YUd5alRp?=
 =?utf-8?B?Umc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb03e58f-1485-48f2-3af6-08da5a3815ea
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 01:30:16.0561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CWE2GzJP2i2ufVTh0h58NOid86Q6mvONK8L+8fG3YCibMXuXFnXMLH379vOhnfmBrWnGGGuCsQGMVocpBWa6AhN+b8qo1qp6d1PXrofBHAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5502
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-29_24:2022-06-28,2022-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206300003
X-Proofpoint-ORIG-GUID: ULzj_ortBRS3Kbg6qG7dSuB_9FZUZMfq
X-Proofpoint-GUID: ULzj_ortBRS3Kbg6qG7dSuB_9FZUZMfq
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-06-29 at 11:52 -0700, Darrick J. Wong wrote:
> On Sat, Jun 11, 2022 at 02:42:00AM -0700, Allison Henderson wrote:
> > This patch adds a new file ioctl to retrieve the parent pointer of
> > a
> > given inode
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/Makefile            |   1 +
> >  fs/xfs/libxfs/xfs_fs.h     |  46 +++++++++++++
> >  fs/xfs/libxfs/xfs_parent.c |  10 +++
> >  fs/xfs/libxfs/xfs_parent.h |   2 +
> >  fs/xfs/xfs_ioctl.c         |  90 ++++++++++++++++++++++++-
> >  fs/xfs/xfs_ondisk.h        |   4 ++
> >  fs/xfs/xfs_parent_utils.c  | 133
> > +++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_parent_utils.h  |  22 ++++++
> >  8 files changed, 306 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index fc717dc3470c..da86f6231f2e 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
> >  				   xfs_mount.o \
> >  				   xfs_mru_cache.o \
> >  				   xfs_pwork.o \
> > +				   xfs_parent_utils.o \
> >  				   xfs_reflink.o \
> >  				   xfs_stats.o \
> >  				   xfs_super.o \
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index b0b4d7a3aa15..e6c8873cd234 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -574,6 +574,7 @@ typedef struct xfs_fsop_handlereq {
> >  #define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in
> > security namespace */
> >  #define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr
> > already exists */
> >  #define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr
> > does not exist */
> > +#define XFS_IOC_ATTR_PARENT	0x0040  /* use attrs in parent
> > namespace */
> >  
> >  typedef struct xfs_attrlist_cursor {
> >  	__u32		opaque[4];
> > @@ -752,6 +753,50 @@ struct xfs_scrub_metadata {
> >  				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
> >  #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN |
> > XFS_SCRUB_FLAGS_OUT)
> >  
> > +#define XFS_PPTR_MAXNAMELEN				256
> > +
> > +/* return parents of the handle, not the open fd */
> > +#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
> > +
> > +/* target was the root directory */
> > +#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
> > +
> > +/* Cursor is done iterating pptrs */
> > +#define XFS_PPTR_OFLAG_DONE    (1U << 2)
> > +
> > +/* Get an inode parent pointer through ioctl */
> > +struct xfs_parent_ptr {
> > +	__u64		xpp_ino;			/* Inode */
> > +	__u32		xpp_gen;			/* Inode
> > generation */
> > +	__u32		xpp_diroffset;			/*
> > Directory offset */
> > +	__u32		xpp_namelen;			/* File
> > name length */
> > +	__u32		xpp_pad;
> > +	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File
> > name */
> > +};
> > +
> > +/* Iterate through an inodes parent pointers */
> > +struct xfs_pptr_info {
> > +	struct xfs_handle		pi_handle;
> > +	struct xfs_attrlist_cursor	pi_cursor;
> > +	__u32				pi_flags;
> > +	__u32				pi_reserved;
> > +	__u32				pi_ptrs_size;
> > +	__u32				pi_ptrs_used;
> > +	__u64				pi_reserved2[6];
> > +
> > +	/*
> > +	 * An array of struct xfs_parent_ptr follows the header
> > +	 * information. Use XFS_PPINFO_TO_PP() to access the
> > +	 * parent pointer array entries.
> > +	 */
> 
> 	struct xfs_parent_ptr		pi_parents[];
> 
> Unless you want to conserve space in the userspace buffer by making
> the
> size of xfs_parent_ptr itself variable?  Userspace would have to walk
> the entire buffer by hand like it does for listxattr, but it saves a
> fair amount of space.
Oh i see, I can take a look at it.  Honestly I think the only thing in
user space that's interested in parent pointers might be the test case,
so I'm not too worried about it atm.  But let me see if I can cut down
the buffer usage a bit.

> 
> > +};
> > +
> > +#define XFS_PPTR_INFO_SIZEOF(nr_ptrs) sizeof (struct
> > xfs_pptr_info) + \
> > +				      nr_ptrs * sizeof(struct
> > xfs_parent_ptr)
> > +
> > +#define XFS_PPINFO_TO_PP(info, idx)    \
> > +	(&(((struct xfs_parent_ptr *)((char *)(info) +
> > sizeof(*(info))))[(idx)]))
> 
> Turn these into static inline functions so that client programs get
> some
> proper typechecking by the C compiler.
> 
Sure, will do

> > +
> >  /*
> >   * ioctl limits
> >   */
> > @@ -797,6 +842,7 @@ struct xfs_scrub_metadata {
> >  /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
> >  #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct
> > xfs_scrub_metadata)
> >  #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct
> > xfs_ag_geometry)
> > +#define XFS_IOC_GETPPOINTER	_IOR ('X', 62, struct
> > xfs_parent_ptr)
> >  
> >  /*
> >   * ioctl commands that replace IRIX syssgi()'s
> > diff --git a/fs/xfs/libxfs/xfs_parent.c
> > b/fs/xfs/libxfs/xfs_parent.c
> > index cb546652bde9..a5b99f30bc63 100644
> > --- a/fs/xfs/libxfs/xfs_parent.c
> > +++ b/fs/xfs/libxfs/xfs_parent.c
> > @@ -33,6 +33,16 @@
> >  #include "xfs_attr_sf.h"
> >  #include "xfs_bmap.h"
> >  
> > +/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
> > +void
> > +xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
> > +		     struct xfs_parent_name_rec	*rec)
> 
> Indenting...
> 
Will fix

> > +{
> > +	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
> > +	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
> > +	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
> > +}
> > +
> >  /*
> >   * Parent pointer attribute handling.
> >   *
> > diff --git a/fs/xfs/libxfs/xfs_parent.h
> > b/fs/xfs/libxfs/xfs_parent.h
> > index 10dc576ce693..fa50ada0d6a9 100644
> > --- a/fs/xfs/libxfs/xfs_parent.h
> > +++ b/fs/xfs/libxfs/xfs_parent.h
> > @@ -28,4 +28,6 @@ void xfs_init_parent_name_rec(struct
> > xfs_parent_name_rec *rec,
> >  			      uint32_t p_diroffset);
> >  void xfs_init_parent_name_irec(struct xfs_parent_name_irec *irec,
> >  			       struct xfs_parent_name_rec *rec);
> > +void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
> > +			 struct xfs_parent_name_rec *rec);
> >  #endif	/* __XFS_PARENT_H__ */
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index e1612e99e0c5..4cd1de3e9d0b 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -37,6 +37,7 @@
> >  #include "xfs_health.h"
> >  #include "xfs_reflink.h"
> >  #include "xfs_ioctl.h"
> > +#include "xfs_parent_utils.h"
> >  #include "xfs_xattr.h"
> >  
> >  #include <linux/mount.h>
> > @@ -355,6 +356,8 @@ xfs_attr_filter(
> >  		return XFS_ATTR_ROOT;
> >  	if (ioc_flags & XFS_IOC_ATTR_SECURE)
> >  		return XFS_ATTR_SECURE;
> > +	if (ioc_flags & XFS_IOC_ATTR_PARENT)
> > +		return XFS_ATTR_PARENT;
> >  	return 0;
> >  }
> >  
> > @@ -422,7 +425,8 @@ xfs_ioc_attr_list(
> >  	/*
> >  	 * Reject flags, only allow namespaces.
> >  	 */
> > -	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
> > +	if (flags & ~(XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE |
> > +		      XFS_IOC_ATTR_PARENT))
> >  		return -EINVAL;
> >  	if (flags == (XFS_IOC_ATTR_ROOT | XFS_IOC_ATTR_SECURE))
> >  		return -EINVAL;
> > @@ -1672,6 +1676,87 @@ xfs_ioc_scrub_metadata(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * IOCTL routine to get the parent pointers of an inode and return
> > it to user
> > + * space.  Caller must pass a buffer space containing a struct
> > xfs_pptr_info,
> > + * followed by a region large enough to contain an array of struct
> > + * xfs_parent_ptr of a size specified in pi_ptrs_size.  If the
> > inode contains
> > + * more parent pointers than can fit in the buffer space, caller
> > may re-call
> > + * the function using the returned pi_cursor to resume
> > iteration.  The
> > + * number of xfs_parent_ptr returned will be stored in
> > pi_ptrs_used.
> > + *
> > + * Returns 0 on success or non-zero on failure
> > + */
> > +STATIC int
> > +xfs_ioc_get_parent_pointer(
> > +	struct file			*filp,
> > +	void				__user *arg)
> > +{
> > +	struct xfs_pptr_info		*ppi = NULL;
> > +	int				error = 0;
> > +	struct xfs_inode		*ip = XFS_I(file_inode(filp));
> > +	struct xfs_mount		*mp = ip->i_mount;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	/* Allocate an xfs_pptr_info to put the user data */
> > +	ppi = kmem_alloc(sizeof(struct xfs_pptr_info), 0);
> > +	if (!ppi)
> > +		return -ENOMEM;
> > +
> > +	/* Copy the data from the user */
> > +	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
> > +	if (error)
> > +		goto out;
> > +
> > +	/* Check size of buffer requested by user */
> > +	if (XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size) >
> > XFS_XATTR_LIST_MAX) {
> > +		error = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	/*
> > +	 * Now that we know how big the trailing buffer is, expand
> > +	 * our kernel xfs_pptr_info to be the same size
> > +	 */
> > +	ppi = krealloc(ppi, XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size),
> > +		       GFP_NOFS | __GFP_NOFAIL);
> > +	if (!ppi)
> > +		return -ENOMEM;
> > +
> > +	if (ppi->pi_flags != 0 && ppi->pi_flags !=
> > XFS_PPTR_IFLAG_HANDLE) {
> 
> Flags validation should come before the big memory allocation.
> 
Alrighty, will scoot up

> > +		error = -EINVAL;
> > +		goto out;
> > +	}
> > +
> > +	if (ppi->pi_flags == XFS_PPTR_IFLAG_HANDLE) {
> > +		error = xfs_iget(mp, NULL, ppi-
> > >pi_handle.ha_fid.fid_ino,
> > +				0, 0, &ip);
> > +		if (error)
> > +			goto out;
> 
> This ought to be checking the generation number in the file handle.
Oh I see, sure I will add that in

> 
> > +	}
> > +
> > +	if (ip->i_ino == mp->m_sb.sb_rootino)
> > +		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
> > +
> > +	/* Get the parent pointers */
> > +	error = xfs_attr_get_parent_pointer(ip, ppi);
> > +
> > +	if (error)
> > +		goto out;
> > +
> > +	/* Copy the parent pointers back to the user */
> > +	error = copy_to_user(arg, ppi,
> > +			XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size));
> > +	if (error)
> > +		goto out;
> > +
> > +out:
> > +	kmem_free(ppi);
> > +	return error;
> > +}
> > +
> >  int
> >  xfs_ioc_swapext(
> >  	xfs_swapext_t	*sxp)
> > @@ -1961,7 +2046,8 @@ xfs_file_ioctl(
> >  
> >  	case XFS_IOC_FSGETXATTRA:
> >  		return xfs_ioc_fsgetxattra(ip, arg);
> > -
> > +	case XFS_IOC_GETPPOINTER:
> > +		return xfs_ioc_get_parent_pointer(filp, arg);
> >  	case XFS_IOC_GETBMAP:
> >  	case XFS_IOC_GETBMAPA:
> >  	case XFS_IOC_GETBMAPX:
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index 758702b9495f..765eb514a917 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -135,6 +135,10 @@ xfs_check_ondisk_structs(void)
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
> >  	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
> >  
> > +	/* parent pointer ioctls */
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            280);
> > +	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             104);
> > +
> >  	/*
> >  	 * The v5 superblock format extended several v4 header
> > structures with
> >  	 * additional data. While new fields are only accessible on v5
> > diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
> > new file mode 100644
> > index 000000000000..9880718395c6
> > --- /dev/null
> > +++ b/fs/xfs/xfs_parent_utils.c
> > @@ -0,0 +1,133 @@
> > +/*
> > + * Copyright (c) 2015 Red Hat, Inc.
> > + * All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be
> > useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
> > License
> > + * along with this program; if not, write the Free Software
> > Foundation
> > + */
> > +#include "xfs.h"
> > +#include "xfs_fs.h"
> > +#include "xfs_format.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_shared.h"
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_bmap_btree.h"
> > +#include "xfs_inode.h"
> > +#include "xfs_error.h"
> > +#include "xfs_trace.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_da_format.h"
> > +#include "xfs_da_btree.h"
> > +#include "xfs_attr.h"
> > +#include "xfs_ioctl.h"
> > +#include "xfs_parent.h"
> > +#include "xfs_da_btree.h"
> > +
> > +/*
> > + * Get the parent pointers for a given inode
> > + *
> > + * Returns 0 on success and non zero on error
> > + */
> > +int
> > +xfs_attr_get_parent_pointer(struct xfs_inode		*ip,
> > +			    struct xfs_pptr_info	*ppi)
> > +
> 
> Indenting.  Also, should this go in xfs_parent.c ?
> 
Will fix indenting.  I think the reason I put it here was to avoid
unnecessary porting to libxfs.  Since parent.c is in libxfs and utils
is not.

> > +{
> > +
> > +	struct xfs_attrlist		*alist;
> > +	struct xfs_attrlist_ent		*aent;
> > +	struct xfs_parent_ptr		*xpp;
> > +	struct xfs_parent_name_rec	*xpnr;
> > +	char				*namebuf;
> > +	unsigned int			namebuf_size;
> > +	int				name_len;
> > +	int				error = 0;
> > +	unsigned int			ioc_flags =
> > XFS_IOC_ATTR_PARENT;
> > +	unsigned int			flags = XFS_ATTR_PARENT;
> > +	int				i;
> > +	struct xfs_attr_list_context	context;
> > +	struct xfs_da_args		args;
> > +
> > +	/* Allocate a buffer to store the attribute names */
> > +	namebuf_size = sizeof(struct xfs_attrlist) +
> > +		       (ppi->pi_ptrs_size) * sizeof(struct
> > xfs_attrlist_ent);
> > +	namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
> > +	if (!namebuf)
> > +		return -ENOMEM;
> > +
> > +	memset(&context, 0, sizeof(struct xfs_attr_list_context));
> > +	error = xfs_ioc_attr_list_context_init(ip, namebuf,
> > namebuf_size,
> > +			ioc_flags, &context);
> > +
> > +	/* Copy the cursor provided by caller */
> > +	memcpy(&context.cursor, &ppi->pi_cursor,
> > +	       sizeof(struct xfs_attrlist_cursor));
> > +
> > +	if (error)
> > +		goto out_kfree;
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +
> > +	error = xfs_attr_list_ilocked(&context);
> > +	if (error)
> > +		goto out_kfree;
> > +
> > +	alist = (struct xfs_attrlist *)namebuf;
> > +	for (i = 0; i < alist->al_count; i++) {
> > +		xpp = XFS_PPINFO_TO_PP(ppi, i);
> > +		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
> > +		aent = (struct xfs_attrlist_ent *)
> > +			&namebuf[alist->al_offset[i]];
> > +		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
> > +
> > +		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
> > +			error = -ERANGE;
> > +			goto out_kfree;
> > +		}
> > +		name_len = aent->a_valuelen;
> > +
> > +		memset(&args, 0, sizeof(args));
> > +		args.geo = ip->i_mount->m_attr_geo;
> > +		args.whichfork = XFS_ATTR_FORK;
> > +		args.dp = ip;
> > +		args.name = (char *)xpnr;
> > +		args.namelen = sizeof(struct xfs_parent_name_rec);
> > +		args.attr_filter = flags;
> > +		args.hashval = xfs_da_hashname(args.name,
> > args.namelen);
> > +		args.value = (unsigned char *)(xpp->xpp_name);
> > +		args.valuelen = name_len;
> > +		args.op_flags = XFS_DA_OP_OKNOENT;
> 
> You might want to convert this to a C99 named initialization inside
> the
> loop body.
Ok, will do.
> 
> Otherwise looks ok.
> 
Great!  Thanks!
Allison

> --D
> 
> > +
> > +		error = xfs_attr_get_ilocked(&args);
> > +		error = (error == -EEXIST ? 0 : error);
> > +		if (error)
> > +			goto out_kfree;
> > +
> > +		xpp->xpp_namelen = name_len;
> > +		xfs_init_parent_ptr(xpp, xpnr);
> > +	}
> > +	ppi->pi_ptrs_used = alist->al_count;
> > +	if (!alist->al_more)
> > +		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
> > +
> > +	/* Update the caller with the current cursor position */
> > +	memcpy(&ppi->pi_cursor, &context.cursor,
> > +		sizeof(struct xfs_attrlist_cursor));
> > +
> > +out_kfree:
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	kmem_free(namebuf);
> > +
> > +	return error;
> > +}
> > +
> > diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
> > new file mode 100644
> > index 000000000000..0e952b2ebd4a
> > --- /dev/null
> > +++ b/fs/xfs/xfs_parent_utils.h
> > @@ -0,0 +1,22 @@
> > +/*
> > + * Copyright (c) 2017 Oracle, Inc.
> > + * All Rights Reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it would be
> > useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public
> > License
> > + * along with this program; if not, write the Free Software
> > Foundation Inc.
> > + */
> > +#ifndef	__XFS_PARENT_UTILS_H__
> > +#define	__XFS_PARENT_UTILS_H__
> > +
> > +int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
> > +				struct xfs_pptr_info *ppi);
> > +#endif	/* __XFS_PARENT_UTILS_H__ */
> > -- 
> > 2.25.1
> > 

