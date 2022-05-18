Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F56C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 16:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240345AbiERQiS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 12:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240299AbiERQiQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 12:38:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CE61A29C5
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 09:38:13 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IEVsKc004916;
        Wed, 18 May 2022 16:38:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=cHB/bBvw8LaJO8fkf5NsET3/Jh6z7R8FpMnZ2A1tQUs=;
 b=KXEwpVtlHSt32TG1Wc1gYFOarPsos9BQP0Ysm8oH7vw38FVxiJReRZ2SKJKnF9eJihGi
 0G9d3Si/sJGBVoJUA9jokA+TWXYhY1xwCOqae88tfFqAtgp6NVBECdZYpPpNxBSLg9oL
 GEn0d5vPLI+epw46vQVPy52eoRYOS0KjiAiUXCvqHoaLKWP31iNCG8jlOaG2cinp8kCb
 qMRuR/Rp67UWr9BEWMHJ5XJhRym16O94LiCW/sVn7L0i9qIYWuY0+5VqTzgFtZrSZUqn
 V6WbccY4tqB/xUoZ2ilSiRxp/U4QABKbTsf/YisvOYjpeb3cVjfmpImSue0Zk4wXrrDe /g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2372222n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 16:38:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24IGV4O4025647;
        Wed, 18 May 2022 16:38:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4eqt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 May 2022 16:38:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRsxuScZwWOFCBdNC4QAALFQlIRTO+788lTAhSWqa9gJCazbBYgczcLH4A0jsEJZEr9p4y9Pz3VKpED/VxEiNtX65jRkyOxTcOelvcVNXhvbKjXyP9QtemqPqPD9+hmCqOVltBdWVWhuDJC/yam0a95jK+HbZBgTNsiZeQWJ/1hCkCJQdirGH5oo/ztLUHMkSkRAYiV3Ihj4iLZb8z0j6yhCW1nbrn7FvOByouyKdALmn/N+DYxQKeok6zKvfu6i96GsbwaoWGFHAUykSLLf7x2knb1b5R0oZ7LWzXPZ6ANM/u7FC3vW+W5bJI5iV3itH+qsqr+IxRDEmOGLKQm4vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHB/bBvw8LaJO8fkf5NsET3/Jh6z7R8FpMnZ2A1tQUs=;
 b=iQIN+QzicxrdT9ERLjSO62oFP2KEf7Dbajr5wxG2+uQeQ+YZqBG3WkZ+F1g5hk33IxcYl1eyGbxBxZwBE15iE/wMZJCIApVRtg3oECCl75UPeXaRhGPtpMrqfibMWMx+o7JMiH7DGm60UxfJ0wW/+KyylCE4iN+wz9Heti/B75T6JO5NW4fjm66nKKziu1VLPCTT439Cxikt5y5IfvXU9ziGo5VHK6GhJVoDV3+lDL+p3LxsOicXa42bui+MlH8zUbs9s1BFIy6eXHW2+Ubvno1ZcFDFhks8aSeL/z86PWuTlWGbdT7QZ/ifRSJybtjQTjb7ZCH4mPCDJKRsKq5s1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHB/bBvw8LaJO8fkf5NsET3/Jh6z7R8FpMnZ2A1tQUs=;
 b=XvCF9KNRwcZusONbOBSUYMUBUU8jQXnNcQ0M6xnKwHe84FRnIPQ0hMDFgItdNZq7Uh4ohf/j6VASgbiGdr5+J7CSbcUHwi19f71L5tu02seqNomqsx1i1/Q2+EUI3u6Xwn66e2+eGy7GHMidSWDQsS3SlJnlb2CCiD98OVnpRr0=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SN6PR10MB2864.namprd10.prod.outlook.com (2603:10b6:805:d6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 18 May
 2022 16:38:06 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::918:be3d:3964:a311%4]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 16:38:06 +0000
Message-ID: <b828d5ede2b3838ad578848c5cf34a00e8ba9fc5.camel@oracle.com>
Subject: Re: [PATCH 18/18] xfsprogs: Add log item printing for ATTRI and
 ATTRD
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 18 May 2022 09:38:05 -0700
In-Reply-To: <YoRFoewCIo+aV/ae@magnolia>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
         <20220518001227.1779324-19-allison.henderson@oracle.com>
         <YoRFoewCIo+aV/ae@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0035.namprd08.prod.outlook.com
 (2603:10b6:a03:100::48) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d82b7d2-3539-4d27-412e-08da38ecc90e
X-MS-TrafficTypeDiagnostic: SN6PR10MB2864:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2864DB40476027D5FC41BA1995D19@SN6PR10MB2864.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z1yvDue2Txd6JA4EN9ohdpCNR+xITqTaQloWbgMW5HYC1GaofK9oVJJkrT50TNlgMxjM2nUeFuJBOtAmKTzKKYLcPgrfXO8QnLEIXNeXBG4zErgz3E0B4PVOBiGDJKi3tC17JwAcOd8T8MJ4tR2kZ8w9heT1G1F7a6hOJ+54e/Re8AAoMK0V/98gosS6zBRnsEthYNL2+Sw0+HhtxKTGu7t7KInwayHcB6tT0RKQYhLS3GU2gNTW1fG1K09jCqmgpsko3syg07rNREzR4n7q7ovT4FfpaumKuNjIHnAJEFXrwl9Ykn8qFMk3KALtzX1PUUleAIgILQ/oQyrJRibJySDslObWnosiQW0fqcpfXiTAPvI/di5noar72Rm9sYdwgTZ3kn5dp+kmtFbV9kZln3J77HYw9xicdgCRyuEE5be6JNhOGmB5MuHm6mAq2TEAs4KBj7Ez583q9dRDS/ucxJzKGcsdDR7SAOoIK7DVujZGOpDdxk954JjIvxvgVX+aAYACPeCLqxXVgLxeasAxUZqizxTKqCnbcQ0RCywA5oINpmCG9ON+5joKMuVYTbLeaLrYRZ3d7st7kpo7NUwNtM2WuEmzJ18AmPShmi7dRhqVZW8FQjtyCYOE4xWigYQLRV/ecJ9qoBp+7xy88H9W5aXIA+TfwwCiSO++oBDdrWy0NYQeA4XHEUmUbqjPa/kSLbi3v4CGVKARvrjgfPp5qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(86362001)(5660300002)(6916009)(8676002)(4326008)(30864003)(66556008)(66476007)(508600001)(186003)(66946007)(316002)(38350700002)(2616005)(38100700002)(36756003)(2906002)(52116002)(6506007)(6486002)(26005)(8936002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXUrWmszY3NTdlBDeWJyYjBZSW44VkpRL2t3MmcrOUxldWE1ZGVqQ0pCMnQw?=
 =?utf-8?B?OGtDajV5bG04aXZIaFJuTTBhMTB0RTZqUFZML1Jhekt3dkJxa0w2cjNCemJO?=
 =?utf-8?B?M3oyL1dtVzNMYllMSjBrZEVqWTNQaXNrQnNGTTFKK01LN2hnRGZyelJINFBh?=
 =?utf-8?B?Q3E5bERncG93NDRUN2hxYzhFR3pjUUllUk1PMmUxZjEwcXg3TWk0bkZrZnRZ?=
 =?utf-8?B?ZUhhbHpOTU9BMDNxUXRaazhDWFRYdnlFWEpzQXdoSTRMYmxzaVZVbjh2Vkg4?=
 =?utf-8?B?OWNUNGlnTkgxcFQvcklVYXdXaEc2Mnp0MDJWdWVaNk1xblhWSW1HRnVUNUdD?=
 =?utf-8?B?UGgzNmx5d1JkVlg4NXdPWjZJakYxZFJhcTdpc3VqNHJTMW5CVkg0MHM5d2JO?=
 =?utf-8?B?MHMzOFhNNlZMbitOQjNFMjQ4elVPRlBHT1h4RTR2Q0k3N1hrL3JCajBtWldL?=
 =?utf-8?B?MlV6VzdRK0l2MEJlT0NMVkRjVXhTVWpFd05MWWc5QTBkQjBvaTF2UWl3bTBV?=
 =?utf-8?B?TUM5M2orSFpBaHI3NGpydXM4dXVNRzJYdjJ2TkhkeUczaVZQZmtHeHJtNEZT?=
 =?utf-8?B?ZWhWYngzMjNSVDlLS1k3VzhCWE92WEFZWlJQTUs0VTVzR0lLVytHNEp3OGVM?=
 =?utf-8?B?cG9FN1BzMXRLQ0hSbmw2SmZsSHJZTFdiYlBtQ2QxSnJ0ODcreFFjWFRpcXhH?=
 =?utf-8?B?eUNGZFB3S2pxUSsvbnB0amRRNVJIL0UySzFhbnJUMjg4ZFd6SWJyRFA1UDN2?=
 =?utf-8?B?MVFWbWVjRTcyOXJrbmxQcTFMUUNWUitTK1k4MVNWaXFVRk1ZQ2JXZGE5RzNh?=
 =?utf-8?B?bXE4NU81cFA3TmNrcUJGWVVERUorTFRsYklwNXhoeHgrSCtiSnBkUkx5Zzd6?=
 =?utf-8?B?WjBQUUhxYXNIWHlNQzJNMDl0bWUyM2luRXRGQzJHa1QzRWtJMFVuY0xNU1Q0?=
 =?utf-8?B?US9KSWhLa3BOWHFnRFYzYTJHaWZrU0RIcGt3NHMvOHQwRmJKb3dPR2lFaTlN?=
 =?utf-8?B?a0M3aUpOMVNxSWUvZmxydkdXQ2RYMUNPQ0dreEMzT1VBMUdBY1ZjYkp0SnpO?=
 =?utf-8?B?ZkRHY3g1a0pLTWYyMmc3TG9CTTRycWd1Q2Fic2RLVUJKa1IvdjJ5ZjNzUDZ5?=
 =?utf-8?B?dS9FSENsZ1QzcUFNaG5jdy8wSXFrc1I3S0FmN1NSTHI5WXp1T3RqVHNOVTZO?=
 =?utf-8?B?Z1RxM1lpR2dML0dwZEJNUXBjejRoQ3MzYll4RDVoSDdwck1FQVF1WHRZdlZY?=
 =?utf-8?B?YW8vOStGdm1vbG5nNGlPYjZRaUNUTHFpY1ZaTjBNbkplT2xiMEhld0dhc0Jq?=
 =?utf-8?B?Z2JKZVlabjdqMTNSVmxFWWVLR1JIenQ1cUFYRGhNYS9EYzF5NGdWOUNnSG5Q?=
 =?utf-8?B?OUJoTXpDU1luVVFhWityNjN2V1ZXd1krTDFEYndYbmI1T1FQUVljK2xacGdk?=
 =?utf-8?B?bWVOS09LNVl6ZjR0aXJ2ZnNsbEVKb0dTeXNva3FKeThMeHFSSjNFTlhIVkR6?=
 =?utf-8?B?c3J6WVZzSUNGSCtRYlErazV1N0NibE5hRHQxSGYvdGZCWndnNDZ1dGZKRTND?=
 =?utf-8?B?WGVGbEtnbHMxNEduMXNrUWgybzB3WHNwY25IWEVWdVkralBidk1wRGpRcjJO?=
 =?utf-8?B?UytlcHgrcmUwY1VCeFdsZmpzUWFCeFoyVGRGbWlObDBCQ3U5ZUtBRWFjc0s4?=
 =?utf-8?B?WlZZdTM3cmRMWVZZNG9MdnJVSUl0QmdDT1d5c0VUeHlZWnZEMS9LelpEaWM5?=
 =?utf-8?B?SkFzNnh3MVhNR05PTGhLNEczdUtoUUo5Q1F2dGRDL1MxV1hJMTRaMWpEU3BF?=
 =?utf-8?B?U2JuTjE5NVFNMTVhVHZWLzdOck40Y0V4TnJEOGRrdFdqRjNiaHI3LzdUMnVU?=
 =?utf-8?B?Q3Jpa0NoWjJ4WE1BclkzS2YwQ1lEOGlOS0toNG5QNWRBMUdjcUFxNHVwbGpK?=
 =?utf-8?B?RjMxb1psdW1EZmtROHU3R1JUQ2FqVDdReEVoSHpwTmswUG9BanBFNmtzcHMr?=
 =?utf-8?B?Slo4ejlEZG5WckhxU282Q1g1VDhhVVJ1d1BHVTZ2Tjh4Skc5SzVqOE52Y0RV?=
 =?utf-8?B?ekZsNUpUUWpoMXZiYlBySVVaNGlhV3dDQ01oZ2lWRVgxQlhMb2pLMnk3QThL?=
 =?utf-8?B?SVhnUWtPemFtZ2hRMm8xcWFudUxMQUVHWll4cWxUVnZhcTZweWVud0l0RUpK?=
 =?utf-8?B?TWpTY25SNFFWaTh3djRlc05nbk4wdW1uNEhvZTdJY2w0KzU3WTNSUkhyVmFD?=
 =?utf-8?B?RXpVTHNDNVYxOUdWckx5ZGptTDIydmVzOHR4Q29zYUVTbDZRWTB6U0hxZ0ls?=
 =?utf-8?B?cnhGL0IyRnVFM1h6a01GZjZFaTlqWlhPak1pQVhVdDhsTGdkVnkyN2xzSSt0?=
 =?utf-8?Q?H7tapn7fSA2Dgqrs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d82b7d2-3539-4d27-412e-08da38ecc90e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 16:38:06.4656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vDaFJHiYL9ynX4BzMVfixHrUnEq4s4fx1dYpzJilltRG+3tYuyAQ+x3SQWKtdA0P9eTqAxU70505s9SJeMHHUVG+xy1vjSkCqwBsMt3B5+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2864
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205180099
X-Proofpoint-GUID: tPWi2lH4xKmOZSUaHSYT-gJsB6uEn966
X-Proofpoint-ORIG-GUID: tPWi2lH4xKmOZSUaHSYT-gJsB6uEn966
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-05-17 at 18:02 -0700, Darrick J. Wong wrote:
> On Tue, May 17, 2022 at 05:12:27PM -0700, Allison Henderson wrote:
> > This patch implements a new set of log printing functions to print
> > the
> > ATTRI and ATTRD items and vectors in the log.  These will be used
> > during
> > log dump and log recover operations.
> > 
> > RFC: Though most attributes are strings, the attribute operations
> > accept
> > any binary payload, so we should not assume them printable.  This
> > was
> > done intentionally in preparation for parent pointers.  Until
> > parent
> > pointers get here, attributes have no discernible format.  So the
> > print
> > routines are just a simple print or hex dump for now.
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  logprint/log_misc.c      |  48 +++++++++-
> >  logprint/log_print_all.c |  12 +++
> >  logprint/log_redo.c      | 197
> > +++++++++++++++++++++++++++++++++++++++
> >  logprint/logprint.h      |  12 +++
> >  4 files changed, 268 insertions(+), 1 deletion(-)
> > 
> > diff --git a/logprint/log_misc.c b/logprint/log_misc.c
> > index 35e926a3baec..d8c60388375b 100644
> > --- a/logprint/log_misc.c
> > +++ b/logprint/log_misc.c
> > @@ -54,11 +54,46 @@ print_stars(void)
> >  	   "***********************************\n");
> >  }	/* print_stars */
> >  
> > +void
> > +print_hex_dump(char *ptr, int len) {
> > +	int i = 0;
> > +
> > +	for (i = 0; i < len; i++) {
> > +		if (i % 16 == 0)
> > +			printf("%08x ", i);
> > +
> > +		printf("%02x", ptr[i]);
> > +
> > +		if ((i+1)%16 == 0)
> > +			printf("\n");
> > +		else if ((i+1)%2 == 0)
> > +			printf(" ");
> > +	}
> > +	printf("\n");
> > +}
> > +
> > +bool
> > +is_printable(char *ptr, int len) {
> > +	int i = 0;
> > +
> > +	for (i = 0; i < len; i++)
> > +		if (!isprint(ptr[i]) )
> > +			return false;
> > +	return true;
> > +}
> > +
> > +void print_or_dump(char *ptr, int len) {
> 
> Nits: indentation and whatnot.
Ok, will add line return after the void
> 
> > +	if (is_printable(ptr, len))
> > +		printf("%.*s\n", len, ptr);
> > +	else
> > +		print_hex_dump(ptr, len);
> > +}
> > +
> >  /*
> >   * Given a pointer to a data segment, print out the data as if it
> > were
> >   * a log operation header.
> >   */
> > -static void
> > +void
> >  xlog_print_op_header(xlog_op_header_t	*op_head,
> >  		     int		i,
> >  		     char		**ptr)
> > @@ -961,6 +996,17 @@ xlog_print_record(
> >  					be32_to_cpu(op_head->oh_len));
> >  			break;
> >  		    }
> > +		    case XFS_LI_ATTRI: {
> > +			skip = xlog_print_trans_attri(&ptr,
> > +					be32_to_cpu(op_head->oh_len),
> > +					&i);
> > +			break;
> > +		    }
> > +		    case XFS_LI_ATTRD: {
> > +			skip = xlog_print_trans_attrd(&ptr,
> > +					be32_to_cpu(op_head->oh_len));
> > +			break;
> > +		    }
> >  		    case XFS_LI_RUI: {
> >  			skip = xlog_print_trans_rui(&ptr,
> >  					be32_to_cpu(op_head->oh_len),
> > diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> > index 182b9d53aaaa..79d37a2d28b7 100644
> > --- a/logprint/log_print_all.c
> > +++ b/logprint/log_print_all.c
> > @@ -404,6 +404,12 @@ xlog_recover_print_logitem(
> >  	case XFS_LI_EFI:
> >  		xlog_recover_print_efi(item);
> >  		break;
> > +	case XFS_LI_ATTRD:
> > +		xlog_recover_print_attrd(item);
> > +		break;
> > +	case XFS_LI_ATTRI:
> > +		xlog_recover_print_attri(item);
> > +		break;
> >  	case XFS_LI_RUD:
> >  		xlog_recover_print_rud(item);
> >  		break;
> > @@ -456,6 +462,12 @@ xlog_recover_print_item(
> >  	case XFS_LI_EFI:
> >  		printf("EFI");
> >  		break;
> > +	case XFS_LI_ATTRD:
> > +		printf("ATTRD");
> > +		break;
> > +	case XFS_LI_ATTRI:
> > +		printf("ATTRI");
> > +		break;
> >  	case XFS_LI_RUD:
> >  		printf("RUD");
> >  		break;
> > diff --git a/logprint/log_redo.c b/logprint/log_redo.c
> > index 297e203d0976..502345d1a842 100644
> > --- a/logprint/log_redo.c
> > +++ b/logprint/log_redo.c
> > @@ -653,3 +653,200 @@ xlog_recover_print_bud(
> >  	f = item->ri_buf[0].i_addr;
> >  	xlog_print_trans_bud(&f, sizeof(struct xfs_bud_log_format));
> >  }
> > +
> > +/* Attr Items */
> > +
> > +static int
> > +xfs_attri_copy_log_format(
> > +	char				*buf,
> > +	uint				len,
> > +	struct xfs_attri_log_format	*dst_attri_fmt)
> > +{
> > +	uint dst_len = sizeof(struct xfs_attri_log_format);
> > +
> > +	if (len == dst_len) {
> > +		memcpy((char *)dst_attri_fmt, buf, len);
> > +		return 0;
> > +	}
> > +
> > +	fprintf(stderr, _("%s: bad size of attri format: %u; expected
> > %u\n"),
> > +		progname, len, dst_len);
> > +	return 1;
> > +}
> > +
> > +int
> > +xlog_print_trans_attri(
> > +	char				**ptr,
> > +	uint				src_len,
> > +	int				*i)
> > +{
> > +	struct xfs_attri_log_format	*src_f = NULL;
> > +	xlog_op_header_t		*head = NULL;
> > +	uint				dst_len;
> > +	int				error = 0;
> > +
> > +	dst_len = sizeof(struct xfs_attri_log_format);
> > +	if (src_len != dst_len) {
> > +		fprintf(stderr, _("%s: bad size of attri format: %u;
> > expected %u\n"),
> > +				progname, src_len, dst_len);
> > +		return 1;
> > +	}
> > +
> > +	/*
> > +	 * memmove to ensure 8-byte alignment for the long longs in
> > +	 * xfs_attri_log_format_t structure
> > +	 */
> > +	src_f = malloc(src_len);
> > +	if (!src_f) {
> > +		fprintf(stderr, _("%s: xlog_print_trans_attri: malloc
> > failed\n"),
> > +				progname);
> > +		exit(1);
> > +	}
> > +	memmove((char*)src_f, *ptr, src_len);
> > +	*ptr += src_len;
> > +
> > +	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id:
> > 0x%llx\n"),
> > +		src_f->alfi_size, src_f->alfi_name_len, src_f-
> > >alfi_value_len,
> > +				(unsigned long long)src_f->alfi_id);
> > +
> > +	if (src_f->alfi_name_len > 0) {
> > +		printf(_("\n"));
> > +		(*i)++;
> > +		head = (xlog_op_header_t *)*ptr;
> > +		xlog_print_op_header(head, *i, ptr);
> > +		error = xlog_print_trans_attri_name(ptr,
> > be32_to_cpu(head->oh_len));
> > +		if (error)
> > +			goto error;
> > +	}
> > +
> > +	if (src_f->alfi_value_len > 0) {
> > +		printf(_("\n"));
> > +		(*i)++;
> > +		head = (xlog_op_header_t *)*ptr;
> > +		xlog_print_op_header(head, *i, ptr);
> > +		error = xlog_print_trans_attri_value(ptr,
> > be32_to_cpu(head->oh_len),
> > +				src_f->alfi_value_len);
> > +	}
> > +error:
> > +	free(src_f);
> > +
> > +	return error;
> > +}	/* xlog_print_trans_attri */
> > +
> > +int
> > +xlog_print_trans_attri_name(
> > +	char				**ptr,
> > +	uint				src_len)
> > +{
> > +	printf(_("ATTRI:  name len:%u\n"), src_len);
> > +	print_or_dump(*ptr, src_len);
> > +
> > +	*ptr += src_len;
> > +
> > +	return 0;
> > +}	/* xlog_print_trans_attri */
> > +
> > +int
> > +xlog_print_trans_attri_value(
> > +	char				**ptr,
> > +	uint				src_len,
> > +	int				value_len)
> > +{
> > +	int len = value_len;
> > +
> > +	if (len > MAX_ATTR_VAL_PRINT)
> > +		len = MAX_ATTR_VAL_PRINT;
> > +
> > +	printf(_("ATTRI:  value len:%u\n"), value_len);
> > +	print_or_dump(*ptr, len);
> > +
> > +	*ptr += src_len;
> > +
> > +	return 0;
> > +}	/* xlog_print_trans_attri_value */
> > +
> > +void
> > +xlog_recover_print_attri(
> > +	struct xlog_recover_item	*item)
> > +{
> > +	struct xfs_attri_log_format	*f, *src_f = NULL;
> > +	uint				src_len, dst_len;
> > +
> > +	int				region = 0;
> > +
> > +	src_f = (struct xfs_attri_log_format *)item->ri_buf[0].i_addr;
> > +	src_len = item->ri_buf[region].i_len;
> > +
> > +	/*
> > +	 * An xfs_attri_log_format structure contains a attribute name
> > and
> > +	 * variable length value  as the last field.
> > +	 */
> > +	dst_len = sizeof(struct xfs_attri_log_format);
> > +
> > +	if ((f = ((struct xfs_attri_log_format *)malloc(dst_len))) ==
> > NULL) {
> > +		fprintf(stderr, _("%s: xlog_recover_print_attri: malloc
> > failed\n"),
> > +			progname);
> > +		exit(1);
> > +	}
> > +	if (xfs_attri_copy_log_format((char*)src_f, src_len, f))
> > +		goto out;
> > +
> > +	printf(_("ATTRI:  #regs: %d	name_len: %d, value_len: %d  id:
> > 0x%llx\n"),
> > +		f->alfi_size, f->alfi_name_len, f->alfi_value_len,
> > (unsigned long long)f->alfi_id);
> > +
> > +	if (f->alfi_name_len > 0) {
> > +		region++;
> > +		printf(_("ATTRI:  name len:%u\n"), f->alfi_name_len);
> > +		print_or_dump((char *)item->ri_buf[region].i_addr,
> > +			       f->alfi_name_len);
> > +	}
> > +
> > +	if (f->alfi_value_len > 0) {
> > +		int len = f->alfi_value_len;
> > +
> > +		if (len > MAX_ATTR_VAL_PRINT)
> > +			len = MAX_ATTR_VAL_PRINT;
> 
> max()?
Ok, will add the max() call

> 
> Other than that, everything looks ok to me.
> 
> You might want to change the subject of this one with the name of the
> tool it modifies, e.g.
> 
> xfs_logprint: Add log item printing for ATTRI and ATTRD
> 
Alrighty, will add to subject line.  Thanks for the reviews!

Allison

> --D
> 
> > +
> > +		region++;
> > +		printf(_("ATTRI:  value len:%u\n"), f->alfi_value_len);
> > +		print_or_dump((char *)item->ri_buf[region].i_addr,
> > len);
> > +	}
> > +
> > +out:
> > +	free(f);
> > +
> > +}
> > +
> > +int
> > +xlog_print_trans_attrd(char **ptr, uint len)
> > +{
> > +	struct xfs_attrd_log_format *f;
> > +	struct xfs_attrd_log_format lbuf;
> > +	uint core_size = sizeof(struct xfs_attrd_log_format);
> > +
> > +	memcpy(&lbuf, *ptr, MIN(core_size, len));
> > +	f = &lbuf;
> > +	*ptr += len;
> > +	if (len >= core_size) {
> > +		printf(_("ATTRD:  #regs: %d	id: 0x%llx\n"),
> > +			f->alfd_size,
> > +			(unsigned long long)f->alfd_alf_id);
> > +		return 0;
> > +	} else {
> > +		printf(_("ATTRD: Not enough data to decode
> > further\n"));
> > +		return 1;
> > +	}
> > +}	/* xlog_print_trans_attrd */
> > +
> > +void
> > +xlog_recover_print_attrd(
> > +	struct xlog_recover_item		*item)
> > +{
> > +	struct xfs_attrd_log_format	*f;
> > +
> > +	f = (struct xfs_attrd_log_format *)item->ri_buf[0].i_addr;
> > +
> > +	printf(_("	ATTRD:  #regs: %d	id: 0x%llx\n"),
> > +		f->alfd_size,
> > +		(unsigned long long)f->alfd_alf_id);
> > +}
> > diff --git a/logprint/logprint.h b/logprint/logprint.h
> > index 38a7d3fa80a9..b4479c240d94 100644
> > --- a/logprint/logprint.h
> > +++ b/logprint/logprint.h
> > @@ -29,6 +29,9 @@ extern void xfs_log_print_trans(struct xlog *,
> > int);
> >  extern void print_xlog_record_line(void);
> >  extern void print_xlog_op_line(void);
> >  extern void print_stars(void);
> > +extern void print_hex_dump(char* ptr, int len);
> > +extern bool is_printable(char* ptr, int len);
> > +extern void print_or_dump(char* ptr, int len);
> >  
> >  extern struct xfs_inode_log_format *
> >  	xfs_inode_item_format_convert(char *, uint, struct
> > xfs_inode_log_format *);
> > @@ -53,4 +56,13 @@ extern void xlog_recover_print_bui(struct
> > xlog_recover_item *item);
> >  extern int xlog_print_trans_bud(char **ptr, uint len);
> >  extern void xlog_recover_print_bud(struct xlog_recover_item
> > *item);
> >  
> > +#define MAX_ATTR_VAL_PRINT	128
> > +
> > +extern int xlog_print_trans_attri(char **ptr, uint src_len, int
> > *i);
> > +extern int xlog_print_trans_attri_name(char **ptr, uint src_len);
> > +extern int xlog_print_trans_attri_value(char **ptr, uint src_len,
> > int value_len);
> > +extern void xlog_recover_print_attri(struct xlog_recover_item
> > *item);
> > +extern int xlog_print_trans_attrd(char **ptr, uint len);
> > +extern void xlog_recover_print_attrd(struct xlog_recover_item
> > *item);
> > +extern void xlog_print_op_header(xlog_op_header_t *op_head, int i,
> > char **ptr);
> >  #endif	/* LOGPRINT_H */
> > -- 
> > 2.25.1
> > 

