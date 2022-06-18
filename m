Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93315C43334
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jun 2022 00:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383709AbiFRAcr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Jun 2022 20:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383725AbiFRAcn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 20:32:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6354BE33
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 17:32:41 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25HJYft0032718;
        Sat, 18 Jun 2022 00:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xk2M9AQHsXgRJ9zLJQEfJbJv1seTkZf/8FWVXqxwnjI=;
 b=p7aA7jnmnorvLerq0TtG1DArwpmGVjfDBKQjMD2Ah4yUVVXjuHUlI4eSodoZMq9c9fbr
 DqMPe3D6Sl7wfZ9ljWQtYeYnGxz4MRqv9FxQoCgu9rccFPDdr4rzFPmxRu+IHFx44wcy
 m+DzDYUG+2zSyCqHYApcwK1FlGi5VA1QVABqY2lI3cdvLdBq/UIIS1B1nZHXdsP0JURu
 P4Dpi+05pk91TKa/kJFlydMAziOEaaCxMHwLxDElD0B2XooGhaZlY8Rh4uVb8mr/Hbn9
 DdDMqrc92rK9aRipAeH6tH13sWC0rGFMxq5/vbDOoIN4zvGwxJVnAE02FyBx0dPHn+3Y Fw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhu2y3fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jun 2022 00:32:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25I0Q9ws036364;
        Sat, 18 Jun 2022 00:32:39 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr7s0yyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jun 2022 00:32:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cveNDcw8kvGCLbsh8pSwnnzxGzUs/VCOJWzY1UmLec99J4/URid2vs/hoWdMOqp8TJYcuy9ccGO7Hl8hTt6K0g3Jz9b7hEEHcWM4jGvo7Z2TYrogLF4QV/26QTViUeJjKKOOTiYSQHyRe228oKyoXegCH4W3MYSR9/LU7Hn6tZEBzCmkqtsLYHGeT/xkuJR5hgi1ddIFcX12oDpN51yEIXj2DT7BoRKCh457j3J81fnhc9qRMOfuiBE1IIH36f3B7IXQvGyRT9/2AEwcRoCSlFLXBCQWvIKVdsdHuJZchKURJWrgeD0m0MrhC3jfHW9j6gC/TVhkbFE9kHNIBurSyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xk2M9AQHsXgRJ9zLJQEfJbJv1seTkZf/8FWVXqxwnjI=;
 b=HuinBSlLYSz5zTf0uBlo/BFohPoeJ1utLzSP+SlpyY/Z4sA4zwYZdCMF4iKXROzWaASBdfapesQwthUoN2i3Pp3cpez+6VW+NcQB0Ylc0gb74uuUZ9xwkSnaObHVl/yFC5P+NtEn+bBIqWQBNNAiQjAk8/i4KX2bnAgtusuRyxzV2cg6n9b/uLbtQ8C++Hbbo92ahD0AP0I8zjU+ny9NxcLT0ZJcfkgqQkppCFKIQqvCF8uvzIREWETSLel4Iyjneorh4Nqmrsfhu/ILCJhVw6EZJ+W7QvuarpL3ZOMzaCJOjAKW5kWZUQZiN9tU+EXiiHOI5GdGNiD6OKaolOX3TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xk2M9AQHsXgRJ9zLJQEfJbJv1seTkZf/8FWVXqxwnjI=;
 b=0UQSy2Mo2WmXSeq/ggSTYv8DZSArysEPIc4Tl5E6Gcuhc3/7mxv7aBbTOjUvWnit4RMmLME2jK+9zMV5J7SgGoDf2t7kATJybn9wqtEs7AojXMWd0xAfYIVR565oOxWlkH1hdb9EI0B6s5qkLjG3QTsAeznIQ33yx8GdxproXrM=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MW5PR10MB5852.namprd10.prod.outlook.com (2603:10b6:303:19c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Sat, 18 Jun
 2022 00:32:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::30d4:9679:6a11:6f94%9]) with mapi id 15.20.5353.018; Sat, 18 Jun 2022
 00:32:37 +0000
Message-ID: <3d1cdf9bdf67954c457077a58b6520f609999b57.camel@oracle.com>
Subject: Re: [PATCH v1 14/17] xfs: Add the parent pointer support to the
 superblock version 5.
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Jun 2022 17:32:36 -0700
In-Reply-To: <20220616060310.GE227878@dread.disaster.area>
References: <20220611094200.129502-1-allison.henderson@oracle.com>
         <20220611094200.129502-15-allison.henderson@oracle.com>
         <20220616060310.GE227878@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0137.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::22) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f00066c-9ed4-407f-9f3a-08da50c20bb9
X-MS-TrafficTypeDiagnostic: MW5PR10MB5852:EE_
X-Microsoft-Antispam-PRVS: <MW5PR10MB585229E1010E9AB442C4EFB695AE9@MW5PR10MB5852.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4AA9LWh9SvbtInYT0+OGXRgADw7QrMVy/fvHHfcatJ64LuboBpM9ataBNHTADK+9DnoliCbDtHijBT9QMWXuZ+AXA6mctTjqYUTS/os3CkL9UDUD7JE6put0JEljkxBmkN7pvRsWaqhLgMKE47W+jfiqvtS0t9uQ/3WaTy2W1ezRBgsZneGmhXvFgBnnMeIlCuohpzHI8ivJBJSl9mWNxkrFwpz0kKi9mi8AuY+1OLkcsPNLK4nydPsjqH/V5IC/3uaC5Exx8sVpgG2uh/+jLgo9aVGXPM4lPtz4OFmjeomge7+ymRzIymz7F8au5Abrct5vr1m04tq0O51bB3ThHPfVg/ybQKwacCmBa1tZ954inb+CFHOz4ATxVJ1UHJOnje+Ard+lz5n+JSgujuyD3/I+eFWC9M5xdDBDld7CLh5y3tn45FIjqQZPVfmyzYsxQXNMmMhzEn3sAoZfFQaZYOXBkwFmOX0/Z1fbeM0UEEQprvnrU3E+vHHZ/r9mAmBscaoVBLpW0wJeKiylyN0qYRa4oqv117PUhtbCyEXH6YR7btaZcdGUGDNytFJKPf0/wpYazxDmCsUI/ZejjqC/zmfhyvu9/3+MScTrZ1DI/Nk9xGD04cPxgleB1Kv3RnykmVuPQGXGfZd3AxKYvIrndT+TJkQyKvdf0tOw6tQGyAgBl7Z39tVgZhBAXAmokrf0Mv/xGgHK2ze/8TfCyuz0CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(5660300002)(8936002)(86362001)(6506007)(6486002)(6512007)(52116002)(26005)(2616005)(498600001)(186003)(2906002)(36756003)(66946007)(4326008)(66556008)(66476007)(8676002)(38350700002)(6916009)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFVjaEpWMC9nYVFnMmtIam9jaitpS1oybkxlc2hlcldMWlpISXVQaytzWHpN?=
 =?utf-8?B?eDdsMXJpVFFiYllvSnJiSXJveno5Rnl0cHNOSDBzM2dVU0E0bFNIN0hWSThn?=
 =?utf-8?B?WXhIQUp1cGJhUUdyWTZ3TzJ6RDA1MHVJMS92TjhROW9Lalc2cEQrQ1llQnIx?=
 =?utf-8?B?WHkvK2hxU29LZzFkcWtIcjhrTHNaSWdWWDduVmpydWxOb1ZKMjJtdjJSL1Ir?=
 =?utf-8?B?cGJYKzA5bW1iNXhsT0VNOWRWN2FUQVo4bGNBekk3Z2JKSUdJeEo4cDFaWlN1?=
 =?utf-8?B?NWFvb09PN2VZZEVrd2sxYVVhdTQ4N0Y3MUdtdDk5UHJsZDlpK3Q0UlZFYXZX?=
 =?utf-8?B?aWJ3elJORkc2aWp4OC9jUWY0eTE4bVZDYzdXNDk0Nm12ODNSL0VCdUhxWG9L?=
 =?utf-8?B?eHhVY2RvRzNPYlZLd2xnVU1ybndJbDhSb0pUQUFxY1M1VGFMOTFMK2RlZWor?=
 =?utf-8?B?amcwdk5ka3c0ZXdKVUVkT0dtS0kxV2FMdjdvbWUxdjVxYk5SMVdtWThnQUlY?=
 =?utf-8?B?SWladUlMN2tQU1FRNXI2Z3pCbHluYk0rN2dkN1VDTVB6VWdPV1VsTXg2cFRL?=
 =?utf-8?B?VWpPb2wwRWFHSWVjb3hvUjl0UkpBWHJMWjRrOGwrWjJhTDhXN2UxSExmQWxr?=
 =?utf-8?B?dWs4b2xXUlpjdkZrT0IrRzQrSUZwNGVJbWloSkl1QlZEQmY1c0E5UGZ1U1F4?=
 =?utf-8?B?Qi9zSW8rQmlrZUorU2tpTnczZ2haeG96bzlNbmt4bFYvWWZaWHlYY0VLdE1r?=
 =?utf-8?B?dGZyTjF1clNzb1Q4d0lUditxdWt1Mk1jNlY5RGVnaXdFaG9rZkpIOVluRXY3?=
 =?utf-8?B?YlZjWElkdWVNdFdveEdFeVhEVlNaQ0N3RG9XVTJMaFBReC93Y3FIYkxYMmpn?=
 =?utf-8?B?TXBNaHorMTUvV3V5Z0ptd0tkSlE4djFpWjg4ODgwOVc3OTlPWVU3aU84ckwr?=
 =?utf-8?B?bWwyOXpucHhhTmRYejdITmJRaE43SEl2VTN4Tm9LT1cvSGN4cVkvdXRldGo0?=
 =?utf-8?B?eG1hVElKME1kQyt3RkZDSW1WaWhLTzRhZ3dFYXExamUzbFFsc3R0SjZ0L3JN?=
 =?utf-8?B?ZzdUSW81UEpvaVQrMlZHNjdqZWVyZmRsWWxMejdPSG9mSXIxYW9qQytHNDdl?=
 =?utf-8?B?YjcxZGs3TnpVN0ZpWlFVTENWdWZhMXFBM2o1ZUdHVUkzZzhxSXllekdjSmNu?=
 =?utf-8?B?bEhIWTNtZmVsNDFwZERpd054RHVpZlBxeGppWU1Wc2FrT1JCVHJJcy9pZVhx?=
 =?utf-8?B?Z1h1c1NBaXkzd0ZHYkpFa1pLSno1YmNFNTFLaENrNENGL3dCWCtHWkpseVVv?=
 =?utf-8?B?UWFpZm9WeWpZNjB0d2o1MlpaczlPM1o0eHRZMmE4SFNhR2NkbjlsdjhRb09E?=
 =?utf-8?B?MEFJSldDTkk2aHlpMStWVHVDRmF4SEN1RVJ1OGNEN0JRZ2o3R2dOdTJlSnJM?=
 =?utf-8?B?UUllbklIZFVIbGdGWWtIT2s1WEVNa25kODNRdGtONTFjaytIZlltNWYxQmdY?=
 =?utf-8?B?T1JmMVN4RVc5MEsrM2k3SHZmRDU2c1RrTTNTR1NyTzE4ZVlPSEhHRG5yWTB6?=
 =?utf-8?B?NitnT00wRCsyeWZjVnA4RU82SzViQWZDTStQQkVtWFVPMHNGVER5TjRuS0xF?=
 =?utf-8?B?elMvODlERzlSVmdtWFRMQ05CSDJkWHNQMktQRWt1YWFicUxxeWNZUnVhL1ZO?=
 =?utf-8?B?ZHpUUnp1VzdDL01aRTVJbmRJM3VGTEo3NFhmQldPNS9sZW1zS0JVTXlJTGlv?=
 =?utf-8?B?Nzg3YkprVlhVOEJtLzNtUDliaXEwVnppbGphOGtrZFMralRMRnRDK0dMN2c5?=
 =?utf-8?B?b3cvTkREZjczUVk1OFpoWFBVbFZobjVoODFRRm5WVGtMelh5N3NVdDAvUEVm?=
 =?utf-8?B?RFRIYkhDRTY1YnZRZ3NGRUFzN0pIWnMraXJLVnAxN21OVk5sMko3bWJydlND?=
 =?utf-8?B?ZTRsdGVjRDNlNEVnOWZ2enY0U2x4SmZHUnp5d0xYOHhUbEo3RGFOSHMyMDlj?=
 =?utf-8?B?VUJ0amc4ZS9KQ3YwVEk2NUUwS0JMOFF4ZFNrbHo3eHJyclJTRGZ3MXkza0Zn?=
 =?utf-8?B?LzIvL2R4cDRNcTc2aEh4Yzc3V3I5b0xWUHVWMWdYRzhudFpNZDNvK0E5WlFm?=
 =?utf-8?B?bTF3UVE5WXkvaDVLV1A5SGdrZjVSR0xsODJHZ0krdk5nWGVCdHNPekdlUFhi?=
 =?utf-8?B?SWhRMmwwc1ZpSDVRYUxhY2E4QW9DZ01NN3hUSzAwSFVNMWs4MEtrb2pOVXEr?=
 =?utf-8?B?RWF3MHcyMjNnTFRxRTlqaE1NbGpPV0RYNkFVRnB3dFUrWjh1ZHVINnA1b2Yx?=
 =?utf-8?B?VWtpa2k1bmFLY0VTbWVMMWdFMXB4QmRTUjNuNTBTY2tMSmtQNkp1L2Mrc01N?=
 =?utf-8?Q?pbGWRQFgEuTs0xHg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f00066c-9ed4-407f-9f3a-08da50c20bb9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2022 00:32:37.8188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJbccDd1YscnP1Agrz7iCaaZXAn/STpB0AQOyxseKMAzueFgEHMlStyBLYuUnMD1lw24BUHkZKTzgbKuPjmZ+OAcBLUIGEy+MGaQBrqheuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5852
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-17_13:2022-06-17,2022-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206180000
X-Proofpoint-GUID: rVP0RWNYCT96DLYLJjuKV-35dEh_jKsb
X-Proofpoint-ORIG-GUID: rVP0RWNYCT96DLYLJjuKV-35dEh_jKsb
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, 2022-06-16 at 16:03 +1000, Dave Chinner wrote:
> On Sat, Jun 11, 2022 at 02:41:57AM -0700, Allison Henderson wrote:
> > [dchinner: forward ported and cleaned up]
> > [achender: rebased and added parent pointer attribute to
> >            compatible attributes mask]
> > 
> > Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h | 14 +++++++++-----
> >  fs/xfs/libxfs/xfs_fs.h     |  1 +
> >  fs/xfs/libxfs/xfs_sb.c     |  2 ++
> >  fs/xfs/xfs_super.c         |  4 ++++
> >  4 files changed, 16 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h
> > b/fs/xfs/libxfs/xfs_format.h
> > index 96976497306c..e85d6b643622 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -83,6 +83,7 @@ struct xfs_ifork;
> >  #define	XFS_SB_VERSION2_OKBITS		\
> >  	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
> >  	 XFS_SB_VERSION2_ATTR2BIT	| \
> > +	 XFS_SB_VERSION2_PARENTBIT	| \
> >  	 XFS_SB_VERSION2_PROJID32BIT	| \
> >  	 XFS_SB_VERSION2_FTYPE)
> 
> No need for a v4 filesystem format feature bit - this is v4 only.
Ok, I ended up having to add this in the rebase or we get an "SB
validate failed".  I think it has to go over in
xfs_sb_validate_v5_features next to the manual crc bit check.  Will
move

> 
> >  
> > @@ -353,11 +354,13 @@ xfs_sb_has_compat_feature(
> >  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/*
> > reverse map btree */
> >  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/*
> > reflinked files */
> >  #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/*
> > inobt block counts */
> > +#define XFS_SB_FEAT_RO_COMPAT_PARENT	(1 << 4)		/*
> > parent inode ptr */
> >  #define XFS_SB_FEAT_RO_COMPAT_ALL \
> > -		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
> > -		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> > -		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
> > -		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
> > +		(XFS_SB_FEAT_RO_COMPAT_FINOBT  | \
> > +		 XFS_SB_FEAT_RO_COMPAT_RMAPBT  | \
> > +		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
> > +		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT| \
> > +		 XFS_SB_FEAT_RO_COMPAT_PARENT)
> 
> I'm not sure this is a RO Compat feature - we added an attribute
> namespace flag on disk, and the older kernels do not know about
> that (i.e. we changed XFS_ATTR_NSP_ONDISK_MASK). This may result in
> parent pointer attrs being exposed as user attrs rather than being
> hidden, or maybe parent pointer attrs being seen as corrupt because
> they have a flag that isn't defined set, etc.
> 
> Hence I'm not sure that this classification is correct.

Gosh, I'm sure there was a reason we did this, but what ever it was
goes all the way back in the first re-appearance of the set back in
2018 and I just cant remember the discussion at the time.  It may have
just been done to get mkfs working and we just never got to reviewing
it.

Should we drop it and just use XFS_SB_VERSION2_PARENTBIT?

> 
> >  #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_
> > ALL
> >  static inline bool
> >  xfs_sb_has_ro_compat_feature(
> > @@ -392,7 +395,8 @@ xfs_sb_has_incompat_feature(
> >  
> >  static inline bool xfs_sb_version_hasparent(struct xfs_sb *sbp)
> >  {
> > -	return false; /* We'll enable this at the end of the set */
> > +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > +		(sbp->sb_features_ro_compat &
> > XFS_SB_FEAT_RO_COMPAT_PARENT));
> >  }
> 
> This should go away and the feature bit in the mount get set by
> xfs_sb_version_to_features().
> 
Alrighty

> >  #define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/* Delayed
> > Attributes */
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 1cfd5bc6520a..b0b4d7a3aa15 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -237,6 +237,7 @@ typedef struct xfs_fsop_resblks {
> >  #define XFS_FSOP_GEOM_FLAGS_BIGTIME	(1 << 21) /* 64-bit
> > nsec timestamps */
> >  #define XFS_FSOP_GEOM_FLAGS_INOBTCNT	(1 << 22) /* inobt
> > btree counter */
> >  #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large
> > extent counters */
> > +#define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 24) /* parent pointers 	
> >     */
> >  
> >  /*
> >   * Minimum and maximum sizes need for growth checks.
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index a20cade590e9..d90b05456dba 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -1187,6 +1187,8 @@ xfs_fs_geometry(
> >  		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
> >  	if (xfs_has_inobtcounts(mp))
> >  		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
> > +	if(xfs_sb_version_hasparent(sbp))
> 
> 	if (xfs_has_parent_pointers(mp))
> 
Will update

> > +		geo->flags |= XFS_FSOP_GEOM_FLAGS_PARENT;
> >  	if (xfs_has_sector(mp)) {
> >  		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
> >  		geo->logsectsize = sbp->sb_logsectsize;
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index a6e7b4176faf..cbb492fea4a5 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1655,6 +1655,10 @@ xfs_fs_fill_super(
> >  		xfs_warn(mp,
> >  	"EXPERIMENTAL Large extent counts feature in use. Use at your
> > own risk!");
> >  
> > +	if (xfs_sb_version_hasparent(&mp->m_sb))
> 
> 	if (xfs_has_parent_pointers(mp))
> 
Will update

Thanks for the reviews!
Allison

> > +		xfs_alert(mp,
> > +	"EXPERIMENTAL parent pointer feature enabled. Use at your own
> > risk!");
> > +
> >  	error = xfs_mountfs(mp);
> >  	if (error)
> >  		goto out_filestream_unmount;
> > -- 
> > 2.25.1
> > 
> > 

