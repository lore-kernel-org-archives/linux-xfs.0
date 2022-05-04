Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49323C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  4 May 2022 01:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiEDBeH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 21:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiEDBeG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 21:34:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DE915FE7
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 18:30:31 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 243KsJcn018676;
        Wed, 4 May 2022 01:30:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=M+ET9M0WE+dibggEi3vJk9sc3SKT5h/WWfpOfvg7eTc=;
 b=JwJoaCfIyVC65JSrjtWpvRqi9paQrWMpng2+HL5RLcJTeOsBxud4oJhecViOFBgochVJ
 Oy+H+mdg31BV0SA9KNj+jrmRLRs+Jn8DHXvlqyX+9wiiE0whaQFuqseGaLyF+zQl3AHu
 y1KIb/fJDscbhjOBgPhkCKC1w9kMo1DYsFI1UsIS8lG5TguGZn9K7Gy3jpb/kC7cOFQZ
 oosP16DpHgIVuxFXvU3o0kFc3vulAvf9WKwQZUY6DSxvXH53r3f1/EC1eHHUB1USOxEP
 GqWRFfSjEYr9wQMWH3WX1JVHGNViyAv15wF6sHo3a8uUZc7+7taVRz9mHfv/K9RRCqT+ XA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwnt74yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 01:30:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2441B1Gn020218;
        Wed, 4 May 2022 01:30:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj929p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 01:30:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jAdi2jrWhwje0rm8WcqY1wAztCwAvhTxvuqszea7KfRcKRGb4mM4M8ohjwfOxnHiu7mH+tDiHJ1ZsWpt6K9psg9LycdybkuDcPC6TyPTRcEGQY7oGO9Q7fqu62d1q2Z6cyoUet5xMkQ0/DZPbX192CNaahGvL+3NMKJdbA1dQCzJe6nz1ChqVbRXU1ewZyWZ/GU6tseJDZV6ZoLEtCsE+dRbm+ze+JtrIADS2Qk9liPxYxEmYkmXtwsCyWn7Lim/tl0XhpYDPR/qxxnwB9dC4I1/oapMO2SSL169V2WxOmy+5jMDS/ee5t61pL0kbYnBJO+TQpImnGmnC+IoTE7urA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+ET9M0WE+dibggEi3vJk9sc3SKT5h/WWfpOfvg7eTc=;
 b=HC9WBzIugwRkJNXYZ8FZg+GygZBkNXdUL7FI+f9JwptMHMgfdIoHVfDfCIQ56dwlNaTvs8OOAmidxlzgzopP/YftNTXEFleZ7dII/lbrF1WgO0Aak08k/HmddoWd6F5E+GqgjLWbj0kgVrIV38nsWpRBqUPIQCSquv3RTDBbYTVQW9gnmE8OQ7C+OYvDqBnYp86BN17FXVVeAT7hqpG9imf6UMRCsmA8RvRHP1/sMP++XpyyumposJMJjU7WmZxX/qDh3emgtNnhg0x8dH7TiXRm1RnPNiBZJ7ukU6yjTZgcJQcTXrrQ3x4UcrIwGMODbWf3SWthSxSP9fX7nubGJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+ET9M0WE+dibggEi3vJk9sc3SKT5h/WWfpOfvg7eTc=;
 b=KSVOUF1OVstrpLIE8xNQFRn1einrmrlEw02Fq8sDgTUoUH2NnMgbLIg0Ntux8Wh9uJTqXqfYtpCeqlKtFK1oWYfp0daPqr51mmX39zVVorF+0jnRcX1CMXr9zDOcjlEl7Sk9UDaRQAY3zvNAV5fcjJHjep0KRDY/5JreIQb2M1A=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by CH2PR10MB3928.namprd10.prod.outlook.com (2603:10b6:610:6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 01:30:26 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a0d7:21c9:1b7e:455f%8]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 01:30:26 +0000
Message-ID: <cd6282aa1e51edf417759084a9aabd68d50f9551.camel@oracle.com>
Subject: Re: [PATCH 16/16] xfs: ATTR_REPLACE algorithm with LARP enabled
 needs rework
From:   Alli <allison.henderson@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 03 May 2022 18:30:23 -0700
In-Reply-To: <20220503074045.GZ1098723@dread.disaster.area>
References: <20220414094434.2508781-1-david@fromorbit.com>
         <20220414094434.2508781-17-david@fromorbit.com>
         <e2f4ecdf730bda05f4b6dfc04945f206ddc3f450.camel@oracle.com>
         <20220503074045.GZ1098723@dread.disaster.area>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::24) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 535ee9da-ae9d-4a73-ad5d-08da2d6daa91
X-MS-TrafficTypeDiagnostic: CH2PR10MB3928:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3928DB0DA8FB5CE00F0A21E895C39@CH2PR10MB3928.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HbifWq78WUbZHibq0pBydA4YScmB4QrKZNM1+cSRxaLOuRmqjDu1fMXUh4RZWvpi7h/pO5TZC/WIlCih810/qE0Wzh1hHSoF/neka/rImB0F+oDNHvm7R1C6b5ktuvINTWXykOLVSv9yYsSP0L5E8u3UdpMjphGPZQbWr3sSvmQUZ0fBCpOkvupNJSd4PseNBD4+E2b5H9B+7QFXG11ETEP2qIQD50TKTZn0vOxR26xL2+I6/mfCpyYMdlSmE1FY4gT7GHkSv73SKodxFhj0+CRBe3rpnANcm/ID1Qh5XkuemiJ7sjz7+pZTRDnjCT6ygPK7lhJopwVfTJpXXO7uxZLKBI16gnxYw4fDySw5OSr+WKN8yYTA0C+p5LG3Wvp7E4WZD5Z461KhHKWI3Bod85E9J9is8iSDzRc83wS2CIXoYrU4JbnoDlrrhXJGF+9G+cHwOlnQK4GhPD6xt1mwR6MKRZpJuW8fQt8lyOuUVY/o9CsCvMsvJ5N2dO9br85O7/+uewT+Z8YyZsAFeBjQUlcW78uu4vL8v3C/2tWCVoLz7fSQ88RFe6iuPICnXgncZbNV8B/J7pZANpzRv1D83FCuK4oooqbC65/RljKYswytZgKx2U2jhk33uDrUMdRTc9I6BbF+oMshqc/ihZbUgHGlsyyR+tyEWlUzxwVqQCf0/AH6xdRktLpzchzbPa3Tgp2mxyT5jli7Hywth+rNdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(5660300002)(508600001)(4326008)(66946007)(66476007)(66556008)(8676002)(8936002)(6506007)(6916009)(316002)(38100700002)(6666004)(2906002)(6486002)(38350700002)(26005)(2616005)(83380400001)(6512007)(36756003)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3RKcDBVK29zUTBsRjZKKzhKa2I4cTgvK2NvNXlLSEs5OENxbFg0T1M2RnNP?=
 =?utf-8?B?d2xwSUNXOWsvK3gwdGNvRzJzNktsT0l0bUhoWC9aSzRtOUFvMGRaeDByRW9J?=
 =?utf-8?B?Qm5jWlVPMG9Zdmx4dkVDS0JFa0QyN1JSMXVBRzlmMVZoNDFraHdueXo5UitX?=
 =?utf-8?B?Qyt2dnJ6U3g4c1VqbnVnVnZmeU85UWppR3paTDNoQlQrOU9tMUdwRzRHUGZD?=
 =?utf-8?B?RFJ4KzdmOHhON1o5QzZTNCtRcmp1WVpIYkhuSnptMWFCcThMWVZEeWtaL3d5?=
 =?utf-8?B?WUhsZ0FzR01sMW5xNmQxRHp1Y3lUME1XNGJPOUwzU2ZwTG9JaTBxZ3FRZVJu?=
 =?utf-8?B?RVpBcHdMZWwxQjU1VnYyRnNoOGp2MHpPbHZBOE9BZE1WZHB3UlQrcVppZlgy?=
 =?utf-8?B?dnd1ck16MlZXME1obmRmNklQSiszREFBaktuMWFGMHRCQWJOQ2JZejQ4UHND?=
 =?utf-8?B?cUlmemV1ekJBckZuRzJ3Sy9kaTdpSlJ2bmpMUm84V01TTHUrQzBuNXpQa0Iy?=
 =?utf-8?B?OGYxd003bDkvTkVOeGw4ck9tbUVsbzVNaXkyNFBrWnJKNGZjOTE2U1luTWF5?=
 =?utf-8?B?ZithMTdXSVJwY01saDhVQTgrRFhCMzhZSWFSaDRZZVU2aFdSRVVmbW83c3dK?=
 =?utf-8?B?R2FHeVJ2UE00WDkzVnQ5Ky9jSU03dlNsaXd3UmtEQnNGMVovVEZyRFc1clNJ?=
 =?utf-8?B?Z2FyTnlxejJNSFNkWksrNWoyckxmVHUyM3dIZzZqNWQ3K2IrNkUxdFVtYkJx?=
 =?utf-8?B?cEdEdU53elh6SndQODJiaG5pbS9aTjNiSVR1dDlON2luSS9HRFcxUFUxdzVE?=
 =?utf-8?B?NVNUbnhWN3NKcEd2alJDemliT0FOTUFaZ2RFaitQSFJYbk44Z1pHdHFnOXVn?=
 =?utf-8?B?RG1CdktRWVByNThKcUhFWVRVbVM4R0VkdGdHK0N4Y3J4ZUNpTzhza2Rjb2lm?=
 =?utf-8?B?WlRxVzlwU1llanBzWEljRlZJK09tL3J0WVcxelhBQ1k0WXJqOFJYTm5hcGZV?=
 =?utf-8?B?TytRdFlJTmdlNmFZbVlQS3V5b2ZJd3ZQTXFkbnJlcGlvdktNUE8xYWlEQ2Vm?=
 =?utf-8?B?V05DUXBaTVRxN1RpUU51ZW55Y3ZXMTdFYTBaUnlDZG5leEpGbXpXbkYxVVBj?=
 =?utf-8?B?cTRnRHhoR2ZOTzhoV0Z2blN4NFVoZm9Tc0pDMjRUekRUOTc1UFY5YkVUaGM0?=
 =?utf-8?B?eDNmSjNtRHc1NEJQSGtBNEQwdG13WFB4RG40SGR3QnZIQUM0eDVCcGdYdEJL?=
 =?utf-8?B?RFcrN1NpT1VqYWZqUDd1VGdsOEM5WHU2V0VMdlB4S2dPQXBPbXdFY0pUQUcv?=
 =?utf-8?B?UG95b1I2aUp4MndyL2xjL2VUVFNqcEUwaTlkM1RYUUNnM0lQZHM3bzZyOFVR?=
 =?utf-8?B?MmR4clU1cWN1UnJZeExSVHVpUTQ0RzZ0U2Ewd0NsdGgxUDYra3BEYkw5cTEv?=
 =?utf-8?B?YU1hWUhTQkZYdnlHQVdvR3JkUlRuRERQT1NsckZ2amplNi9NVi9OM0Nva0M0?=
 =?utf-8?B?ZitIQUs5Z2RlOTRlVTlKZmpyMUlCQVpUeHlRbU5FUVRsZGFSdXhTUVA0SmhG?=
 =?utf-8?B?ZEtwemRjcEc0cTI3QzJIZm5yWUtJQUJwdU9LbkpBN0xaTDhqTzQreUdiQW5s?=
 =?utf-8?B?ZVh0UzFHdk5tZUNRWndiQ1NrVTFCRkFBZElTZTBCNm1DZnZSYlJzWVpibFVF?=
 =?utf-8?B?NzR5clc3N2tCYVFUR0gwZ0lqWGhaMlhPSUtGeUd1d005MkxkZUhmV1dhOFpk?=
 =?utf-8?B?M0Y2RVNYVTdTQ3RSd0ZWK0p0bFMyNmhQTisxMXdwZEVhOG8xUW04N283UEMy?=
 =?utf-8?B?M2lpZzd6WEpGZVhIOVNzeGdWcXNiV201YmdSczRXQUhMVDFHSzA4U2FaWmh5?=
 =?utf-8?B?K1FPLzIvdUR4cVdkb3FvMEcyRUd5ckt5TXNuZHdiSnJDdE1qWG5RYTZnU0Ur?=
 =?utf-8?B?YmVabU5vc0Fvbi9nZXg0QTlNZy9zZFhUVXVhcWVxUmZEZGVuSHNqKzloWVUy?=
 =?utf-8?B?TVlMRHJueXdGQmVYMk50b3BJOTFmdEdhV0I4NXRKZXl6bWZRNldGeHVKcEFP?=
 =?utf-8?B?Nm1yT0hHV2pRT0d5bWRLWlhFSXVhR3A2cU9rUXlwUDJjWEIxVVQ0a3BmZzVj?=
 =?utf-8?B?M3FkQmxFdmJzcEJoaXlTTGJuRm1IcmVWcUF6WS9qTHZBbGVYeE94YmtyZEtT?=
 =?utf-8?B?Y1FURlhHUWNQTHFXeGgwdExGNUdYSG1LUTU2RndzcXJjc0JWRVJ1cUNCbnRR?=
 =?utf-8?B?N0JlRU4zd3RmRUhYRmpzRzR2WjJROWhVRW1IOStWQ2ZVaGtHSkpqdmdLbzVm?=
 =?utf-8?B?RWpyd2xxa21Scklxb2phOHdJQ3orbmxWblpHaTlJUXlybzk5alJySlJBOVpr?=
 =?utf-8?Q?WJlOx3OwWEogVgT4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 535ee9da-ae9d-4a73-ad5d-08da2d6daa91
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 01:30:26.4580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqZPKnliuSDS51ZVqr8JQQ5UhZzyKN4DLGYz/Y0XEXUlsuhh4KFIsxQspS7IrFNv7F1IFuPp1xG9k82uRKyJQaxwqYD4+gFoQGynAu23AGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3928
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-03_10:2022-05-02,2022-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205040006
X-Proofpoint-ORIG-GUID: 5TwnzTVUJYCNOg2kLSxTlbAiAwSIfDMB
X-Proofpoint-GUID: 5TwnzTVUJYCNOg2kLSxTlbAiAwSIfDMB
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-05-03 at 17:40 +1000, Dave Chinner wrote:
> On Thu, Apr 28, 2022 at 12:02:17AM -0700, Alli wrote:
> > On Thu, 2022-04-14 at 19:44 +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > We can't use the same algorithm for replacing an existing
> > > attribute
> > > when logging attributes. The existing algorithm is essentially:
> > > 
> > > 1. create new attr w/ INCOMPLETE
> > > 2. atomically flip INCOMPLETE flags between old + new attribute
> > > 3. remove old attr which is marked w/ INCOMPLETE
> > > 
> > > This algorithm guarantees that we see either the old or new
> > > attribute, and if we fail after the atomic flag flip, we don't
> > > have
> > > to recover the removal of the old attr because we never see
> > > INCOMPLETE attributes in lookups.
> ....
> > > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > > index 39af681897a2..a46379a9e9df 100644
> > > --- a/fs/xfs/xfs_attr_item.c
> > > +++ b/fs/xfs/xfs_attr_item.c
> > > @@ -490,9 +490,14 @@ xfs_attri_validate(
> > >  	if (attrp->__pad != 0)
> > >  		return false;
> > >  
> > > -	/* alfi_op_flags should be either a set or remove */
> > > -	if (op != XFS_ATTR_OP_FLAGS_SET && op !=
> > > XFS_ATTR_OP_FLAGS_REMOVE)
> > > +	switch (op) {
> > > +	case XFS_ATTR_OP_FLAGS_SET:
> > > +	case XFS_ATTR_OP_FLAGS_REMOVE:
> > > +	case XFS_ATTR_OP_FLAGS_REPLACE:
> > > +		break;
> > > +	default:
> > >  		return false;
> > > +	}
> > >  
> > >  	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
> > >  		return false;
> > > @@ -553,11 +558,27 @@ xfs_attri_item_recover(
> > >  	args->namelen = attrp->alfi_name_len;
> > >  	args->hashval = xfs_da_hashname(args->name, args->namelen);
> > >  	args->attr_filter = attrp->alfi_attr_flags;
> > > +	args->op_flags = XFS_DA_OP_RECOVERY;
> > >  
> > > -	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
> > > +	switch (attr->xattri_op_flags) {
> > > +	case XFS_ATTR_OP_FLAGS_SET:
> > > +	case XFS_ATTR_OP_FLAGS_REPLACE:
> > >  		args->value = attrip->attri_value;
> > >  		args->valuelen = attrp->alfi_value_len;
> > >  		args->total = xfs_attr_calc_size(args, &local);
> > > +		if (xfs_inode_hasattr(args->dp))
> > I ran into a test failure and tracked it down to the above line.  I
> > suspect because xfs_inode_hasattr only checks to see if the inode
> > has
> > an attr fork, it doesnt actually check to see if it has the attr
> > we're
> > replacing.
> 
> Right, that was intentional. It is based on the fact that if we
> are recovering a set or a replace operation, we have to remove the
> INCOMPLETE xattr first. However, if the attr fork is empty, there's
> no INCOMPLETE xattr to remove, and so we can just go straight to the
> set operation to create the new value.
> 
> Hmmm - what was the failure? Was it a null pointer dereference
> on ip->i_afp? I wonder if you hit the corner case where attr removal
> can remove the attr fork, and that's when it crashed and we've tried
> to recover from?
No, the actual shutdown was from the error inject that the test case
uses.  The unexpected part was a set operation returning -ENODATA
because we incorrectly fell down the rename path.  I suspect the reason
the parent pointers exposed it was because the presence of the parent
pointer caused the attr fork to not be empty and so xfs_inode_hasattr
succeeds. 

> 
> Oh, I think I might have missed a case there. If you look at
> xfs_attr_sf_removename() I added a case to avoid removing the attr
> fork when XFS_DA_OP_RENAME is set because we don't want to remove it
> when we are about to add to it again. But I didn't add the same
> logic to xfs_attr3_leaf_to_shortform() which can also trash the attr
> fork if the last attr we remove from the attr fork is larger than
> would fit in a sf attr fork. Hence we go straight from leaf form to
> no attr fork at all.
> 
> Ok, that's definitely a bug, I'll need to fix that, and it could be
> the cause of this issue as removing the attr fork will set
> forkoff to 0 and so the inode will not have an attr fork
> instantiated when it is read into memory...
> 
> 
Ah, that could be it then.  The last failing test case is: expanding
the fork into node form, setting the inject, and attempting a rename.
 The correct result should be that it finds the attr correctly renamed,
but instead finds no attr.  So that sounds like what you've described.
 I will wait for your fix and then retest.  Thx for all your help here!

Allison

> > So we fall into the replace code path where it should have
> > been the set code path.  If I replace it with the below line, the
> > failure is resolved:
> > 
> > 	if (attr->xattri_op_flags == XFS_ATTR_OP_FLAGS_REPLACE)
> > 
> > I only encountered this bug after running with parent pointers
> > though
> > which generates a lot more activity, but I figure it's not a bad
> > idea
> > to catch things early.  There's one more test failure it's picking
> > up,
> > though I havnt figured out the cause just yet.
> 
> Yup, that's a good idea.
> 
> > The rest looks good though, I see the below lines address the issue
> > of
> > the states needing to be initialized in the replay paths, so that
> > addresses the concerns in patches 4 and 13.  Thanks for all the
> > larp
> > improvements!
> 
> I'm going to try to move them up into patches 4 and 13, so that
> recovery at least tries to function correctly as we move through the
> patch set.
> 
> Cheers,
> 
> Dave.

