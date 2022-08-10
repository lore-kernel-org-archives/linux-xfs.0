Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66837C00140
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Aug 2022 19:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbiHJT2t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Aug 2022 15:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiHJT2s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Aug 2022 15:28:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39B672873
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 12:28:46 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AIDt13000474;
        Wed, 10 Aug 2022 19:28:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ZofsR1SMPFDKxzIue2VQ/4hOJyTyO1QMtCD8o427Hn4=;
 b=NM0HXe3D7ttOGsewOruguyLBwAImtZC9vmWOPLLUeeakjpVkMJjtZ6OuCSdYc1lJ1Cqw
 cJZAoDCDR0mIEyiHSOFievfMQzQMC207mniIEsJox66RPbNZCqrJ3IAq4Bh5OSm9aetr
 IUFDoej+oG2wLcdtVZYFq61Ug/Lc9QlFZXAZUcPVj9Hoi6mX+FQqwWVnEeLlzKYdtfMh
 J+9uxnD2AiQ192BbFH9ST8WUphWvfnlWaiu3NKQA35yGIxOqZzrCy6QNlb+E1p9/DLAE
 B6HQuYdBW3mGr2gAE7ivcRS8F4O6I9anOup4i48TLP05yElPJ5CTBpX0ZF9X8Om8SEfq rQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqj2vnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 19:28:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27AGp6mZ034334;
        Wed, 10 Aug 2022 19:28:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqhyekr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 19:28:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=marLY+uDPkb7CS9rAV5+ViCKeYGhY9Xk2S5zUYlaSeXibmkvuZZfFT6ej00mZGsjEe7M1jdzNBI+AbknE9aMoBVg00zKCQ+AC/bbPrqV2pU6v3UjSAwSkLzj82OXOnlDa7VgtC9q60oWoQ8fsMdnH176bTBorPKGtp8ftCy/V7mcFHb4uLNlPs1aBlKNFQwfTM8IRhX0vndETx4owVuX/CuPdqGJ574LN2wZdBw8T185IkEmORoQhzO1+7zgIyTGP1g/+/t3T38bgmXiaTQgsaNAT8pODeIwFWZT6wT41UjexPen1Xl1TUfRPkL2iPmSSJf+Q0XGihkgVPhWJ0qNCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZofsR1SMPFDKxzIue2VQ/4hOJyTyO1QMtCD8o427Hn4=;
 b=iAmiweirFvz7qugTu3YInUkJj+ARgVc4A951XXWKlAZtPji0RG7QWAm+hj4cLgNJlHzGQAdEB64mgMdsw/B4Zwi0j3jAKDbv9P1G58LwaTF07RsExyJpFy6XzbuFTlLWC418ZOX3ci+vfCxSn1ctABPtEOGdyI0o8LUKE2lUt+JYGS+rTq4jzsRTVLrWth4nOP6GXC6gyY/KMf3JqGpfdsDUCtwLn4YC4IXhDhiA4p9vfivCugqmw2KOTw7S4ubTH8/35r/VzOvnG/MJmrLpLzVEfjUWy9uUN7nrmJtwfTBmjWLFpLTskoGDxavbxvbVkDW+69Pm++/CHqluFFInPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZofsR1SMPFDKxzIue2VQ/4hOJyTyO1QMtCD8o427Hn4=;
 b=xQwmZBQn28jC09Mj36fSahhLMzBMVbeHERFQp/2/m18ysB+NRVfHnQvzv99lu4+Vs/v9ffCzd6F9bmvERc1qNaBVxCyX6zMKxfXMo/AOwwaWSZUg7ZbBdCO28walXF2vEkG62xIiwgquufl8ZVzMzjKiy5FSbjR/AJZsT+qem/4=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by DM4PR10MB6014.namprd10.prod.outlook.com (2603:10b6:8:ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Wed, 10 Aug
 2022 19:28:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::65a4:3dc0:32a1:7519%4]) with mapi id 15.20.5525.011; Wed, 10 Aug 2022
 19:28:38 +0000
Message-ID: <f4cf309a3b8323a161ad118924ae595656e3f2bd.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Aug 2022 12:28:36 -0700
In-Reply-To: <YvPUNbyPWjr5yLVN@magnolia>
References: <20220804194013.99237-1-allison.henderson@oracle.com>
         <20220804194013.99237-2-allison.henderson@oracle.com>
         <YvKQ5+XotiXFDpTA@magnolia> <20220810015809.GK3600936@dread.disaster.area>
         <373809e97f15e14d181fea6e170bfd8e37a9c9e4.camel@oracle.com>
         <20220810061258.GL3600936@dread.disaster.area> <YvPUNbyPWjr5yLVN@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::21) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fed37974-4d49-4c57-8f50-08da7b06866e
X-MS-TrafficTypeDiagnostic: DM4PR10MB6014:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /G944isdngU8CnJXGM6fWO3VhcEgZXujwr7pDYidDZkRiA91uPVLWiERHEjKG8625wc2zQ/StxgA398ACsbAHae/lG02LmWvpCXZTOSjxHY7evYG3d5eVQzm0Nwxx/h2T8zbODorFvm4ImtaHOvDe9Lcibi+EAG9EKYU+gmEsc8N2GLob0+X/z2BOeo2juAXZjZ0z9U9NojSCASrnNPpn0acNhXkNH2HsIgJmO9W8ggn6qL2Zp288evQqHPW8W17GeldB6wf2X0VwhVUEGjJR71dR0alE+R2y6VglDq7bKgRZzLPAeT8Sd1ITDob5nHEM2/sYdtGSnmxc0A+Pz/hY9B/gCwQZqbQuxHuBYBnvF3LYMGdnfWrcHOiB/60CxwPMoCpWdsi26QyOWJzErXWD3raomj/R4BBjVwgQ1qCMfQHR9fuDop1RyKHhoIH5MrdP53qGGHmcN42+Z6R0G8v99DVpS3l9xpgAOBjL39LLIbLdnL0S46eKn19TaNdyhGQKsJVwkqzMawI3rEtohRBkd9hQ77e5ZjogPD7jsZ7bzfSCrP+GIEBK4PUZ1DBlUJ+a4B1F/nzfZxmL0OGgOacfvvsdFiBOSjPCB0XqXGrzMQHFyyY2uQdFcXRzTXJSTT4JB7W/pAxyTYQqyeZh4vOhNCS5cJXuR9dOAu7Q98p70z7mR10fWB+0Fb2zNS34Wwl2p8ZrtosrQ+CyNeeHgyw1a4XZ2obmqJ4y2uqWcboIXosngAthSGRdVULLY8qiUF+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(346002)(39860400002)(366004)(66946007)(966005)(8936002)(86362001)(6486002)(66476007)(66556008)(110136005)(4326008)(8676002)(83380400001)(186003)(6506007)(316002)(26005)(41300700001)(2906002)(478600001)(52116002)(2616005)(38100700002)(6512007)(38350700002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHNRZ1hLUUFzcGxkSEwvemc5a0pjbTR3YnZRajFwUW16dHNYNzFsQzY0REhN?=
 =?utf-8?B?SkR2TmdscGcydVJzRXN3QWhmY3BoRFJzT1lYa0svd0c5ZU90TG9vQ3lld3pu?=
 =?utf-8?B?Tm4yeWVNTEgyZXgyYk9wQ1BjWlhwUW1XUEFreVVpYVpVRWdJMXJjdlJQRDlq?=
 =?utf-8?B?YWw0Nk1ZMUJYUWcyaEs5VVFiTGZOeURZb05Eb0MwSzU5UjIxb1JsTnBXaFZ5?=
 =?utf-8?B?Y3hFdXdFNHlPa0RlenduSUF5Z0xrcS9MUHd3djRLZU5MYlZCL3RKVDJwK0dZ?=
 =?utf-8?B?YUhuczVRdnRsNU9GSDJvNUhlbWF0c3JQK3pSZUtvYXU3a1VoVE5BR0pIVGJ6?=
 =?utf-8?B?UzNsZDJNd243T2FiY2VGeTlxMlpWT3lzUGhsS2RnL1IyT21NaGEwZEJRL1Nz?=
 =?utf-8?B?OXpaWGlxOFRmS2xhdldpdHFPVzdzVmdBa0k1TE1CZ20wejBiSFhHazNNUCt2?=
 =?utf-8?B?S0F2WEM4Y2FSVVF1djRDejgyaFBsRmVMVFVrTWhDWGlnT3lPc21HMDI0bkht?=
 =?utf-8?B?Q2MvU0hNanJYZ01XSGRwOFBwd0lTNHBNY3NtZktxQ1FQaUpBNUloUmxIekNW?=
 =?utf-8?B?VUZwc2wyTkpBR1ZXTzg5dUl2dFRzcHRKa2NENmw3ZTBsWW90VThDZmxicmdF?=
 =?utf-8?B?LzkzOVEzVjJrWmIxc29wajFOaG1XUUt0cWxzenR3dDh3WE95ai9rRTIvSm9L?=
 =?utf-8?B?TXlmekZCRy9SVWQvRDF2dFQ3V2Y1MEhiRmlKNVJackZqN1hZN09TV2UzV0Vv?=
 =?utf-8?B?M1RBNGNiOFdlS3JIK1JuTmJzdHBHSkV6ZCsyc1pjdzFWVldnTHMwK21hOXVo?=
 =?utf-8?B?b1NZTG5xL1pXYlUrczEzZ0pLR054Qlh1VVgyUDlneXdKbVN6Y3EvYy9ma01x?=
 =?utf-8?B?YXhjYWpjZG9Dc0J0S1FLTkVLMm0xQ2RrS2RBeW1EUVNIOEdNd2pDYmhvY09X?=
 =?utf-8?B?c282N0JBVk5vZTMrR1BiWWhxR1llLytlczJIQnVWUk1XS0J2Um1wenZqTWhE?=
 =?utf-8?B?Y0ptTnZvOUxad2NZME5KeWxMTFZadkFUaERDNWhGL2RmOTJCUDdrRjNRNWFk?=
 =?utf-8?B?UFppMytnMVVmWTFnUjhhVGY5dmxRQlQ3M2Y2TEtjR3pXdUF4WHJXYXlqYkFU?=
 =?utf-8?B?Q3RNb2FUeExxUDNNYlp4UzBpRWVUWHNIVzhvOEhPTUt6UjZodVFKVTI2bFhs?=
 =?utf-8?B?YXcvR081VHJIOFdLK2FIZzdPUkxZOTg0V3YwTlROc3JWYlZBc3oxVHcvbTJR?=
 =?utf-8?B?Wlg5Q1J2a3hCT1gzOTN1TGsvekVMSjh4aFNkUXBjV1lucFcyVy92ZmhHOGk3?=
 =?utf-8?B?ZFZtdUcxWXltNm9ITGduc1VoZEhlUU9ZOHk3NzUwaklUR0Y5aklyZ1Iwd2tV?=
 =?utf-8?B?VUVkc21Ua09kYmkvTkxrbjBBWUxmdTdOTk5keFZSMWI1djE5N2JvR1N6NTUx?=
 =?utf-8?B?aGY3cGNqUjlSMGI2YnZ6V1FnUmVpQkdqV2Fia3hJQ0hnV0RORHRYSGJwRUs0?=
 =?utf-8?B?alBJdGhLeWNxMkxKMUxNbmZXSG13QzFhZ0JJMDQ1VHB2QVVNTUd6TEJuTUpw?=
 =?utf-8?B?TUJoREpGYjFhZ1FjN3dkRFZvV1ZsNGp5a0JmeXFocVpETGVUdG1xeGpjMVl6?=
 =?utf-8?B?RkhNbWdaZ3dzcjhrM2gwSHJaTlNnRzd3NHE3Mm9hTEl1NGRkaEU0YXB1ZHAr?=
 =?utf-8?B?V0tRWlRtaGc1TFRicWhTa1owa1FIdHJIL1pBMjljRWd1azlCdy9sU0o3VjVV?=
 =?utf-8?B?NG9EOFF1cHFEOFArSFBrZXlkbnlrZnRKTkhUSVhuRkJqNmJxN0tPVi9VRTV2?=
 =?utf-8?B?RHA4b0tITlVJV0RacHB4aUNIVzNDWUIrV0I5N3A4UW5lV0Z3TWFnVTZTVlRL?=
 =?utf-8?B?U1VIUHZSaEJPZDN6OFNVQ3JLQ09vMWtkdEJaQTBjOXdzcHZHMEp1empaQkV6?=
 =?utf-8?B?RFN6R0JpMHBUYWFDdlBBYmc3M094Tk1HS0cxY0dFVWYxdmdRY0QrSksrbDBB?=
 =?utf-8?B?WjdOSDc4R1dxOGFERGQxVHZwNjA3UzA3cmh1WXl5eTUzeFJyZzFOazFQY3d6?=
 =?utf-8?B?TzRQRXVIajVreHF4SXJMWHQ2QTVrY1pDeXgxckFRY0oyQUhRUHlQZEVWU1Vp?=
 =?utf-8?B?cW9BSVdhUGFNU2t2UkRucFEzWmNCWE94Z1FubEt6dXdmK3BoaC9uSXhmb0s5?=
 =?utf-8?B?Tnc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fed37974-4d49-4c57-8f50-08da7b06866e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 19:28:38.5665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t89eF8wvTH6XnTluOJVO6LfxHw40x3NXBufysPbVmwkfxU92SIP+bhsNGyj9Ym54BRfkDPaPjXbWpuVl4Qp1bGr51j4k5W8VKxwKREsQTbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6014
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_13,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100059
X-Proofpoint-ORIG-GUID: aQP96ykb6fV8XofsMziCncuftQPcqPoM
X-Proofpoint-GUID: aQP96ykb6fV8XofsMziCncuftQPcqPoM
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 2022-08-10 at 08:52 -0700, Darrick J. Wong wrote:
> On Wed, Aug 10, 2022 at 04:12:58PM +1000, Dave Chinner wrote:
> > On Tue, Aug 09, 2022 at 10:01:49PM -0700, Alli wrote:
> > > On Wed, 2022-08-10 at 11:58 +1000, Dave Chinner wrote:
> > > > On Tue, Aug 09, 2022 at 09:52:55AM -0700, Darrick J. Wong
> > > > wrote:
> > > > > On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison Henderson
> > > > > wrote:
> > > > > > Recent parent pointer testing has exposed a bug in the
> > > > > > underlying
> > > > > > attr replay.  A multi transaction replay currently performs
> > > > > > a
> > > > > > single step of the replay, then deferrs the rest if there
> > > > > > is more
> > > > > > to do.
> > > > 
> > > > Yup.
> > > > 
> > > > > > This causes race conditions with other attr replays that
> > > > > > might be recovered before the remaining deferred work has
> > > > > > had a
> > > > > > chance to finish.
> > > > 
> > > > What other attr replays are we racing against?  There can only
> > > > be
> > > > one incomplete attr item intent/done chain per inode present in
> > > > log
> > > > recovery, right?
> > > No, a rename queues up a set and remove before committing the
> > > transaction.  One for the new parent pointer, and another to
> > > remove the
> > > old one.
> > 
> > Ah. That really needs to be described in the commit message -
> > changing from "single intent chain per object" to "multiple
> > concurrent independent and unserialised intent chains per object"
> > is
> > a pretty important design rule change...
> > 
> > The whole point of intents is to allow complex, multi-stage
> > operations on a single object to be sequenced in a tightly
> > controlled manner. They weren't intended to be run as concurrent
> > lines of modification on single items; if you need to do two
> > modifications on an object, the intent chain ties the two
> > modifications together into a single whole.
> 
> Back when I made the suggestion that resulted in this patch, I was
> pondering why it is that (say) atomic swapext didn't suffer from
> these
> recovery problems, and I realized that for any given inode, you can
> only
> have one ongoing swapext operation at a time.  That's why recovery of
> swapext operations works fine, whereas pptr recovery has this quirk.
> 
> At the time, my thought process was more narrowly focused on making
> log
> recovery mimic runtime more closely.  I didn't make the connection
> between this problem and the other open question I had (see the
> bottom)
> about how to fix pptr attrs when rebuilding a directory.
> 
> > One of the reasons I rewrote the attr state machine for LARP was to
> > enable new multiple attr operation chains to be easily build from
> > the entry points the state machien provides. Parent attr rename
> > needs a new intent chain to be built, not run multiple independent
> > intent chains for each modification.
> > 
> > > It cant be an attr replace because technically the names are
> > > different.
> > 
> > I disagree - we have all the pieces we need in the state machine
> > already, we just need to define separate attr names for the
> > remove and insert steps in the attr intent.
> > 
> > That is, the "replace" operation we execute when an attr set
> > overwrites the value is "technically" a "replace value" operation,
> > but we actually implement it as a "replace entire attribute"
> > operation.
> 
> OH.  Right.  I forgot that ATTR_REPLACE=="replace entire attr".
> 
> If I'm understanding this right, that means that the xfs_rename patch
> ought to detect the situation where there's an existing dirent in the
> target directory, and do something along the lines of:
> 
> 	} else { /* target_ip != NULL */
> 		xfs_dir_replace(...);
> 
> 		xfs_parent_defer_replace(tp, new_parent_ptr, target_dp,
> 				old_diroffset, target_name,
> 				new_diroffset);
> 
> 		xfs_trans_ichgtime(...);
> 
> Where the xfs_parent_defer_replace operation does an ATTR_REPLACE to
> switch:
> 
> (target_dp_ino, target_gen, old_diroffset) == <dontcare>
> 
> to this:
> 
> (target_dp_ino, target_gen, new_diroffset) == target_name
> 
> except, I think we have to log the old name in addition to the new
> name,
> because userspace ATTR_REPLACE operations don't allow name changes?
> 
> I guess this also implies that xfs_dir_replace will pass out the
> offset
> of the old name, in addition to the offset of the new name.
> 
> > Without LARP, we do that overwrite in independent steps via an
> > intermediate INCOMPLETE state to allow two xattrs of the same name
> > to exist in the attr tree at the same time. IOWs, the attr value
> > overwrite is effectively a "set-swap-remove" operation on two
> > entirely independent xattrs, ensuring that if we crash we always
> > have either the old or new xattr visible.
> > 
> > With LARP, we can remove the original attr first, thereby avoiding
> > the need for two versions of the xattr to exist in the tree in the
> > first place. However, we have to do these two operations as a pair
> > of linked independent operations. The intent chain provides the
> > linking, and requires us to log the name and the value of the attr
> > that we are overwriting in the intent. Hence we can always recover
> > the modification to completion no matter where in the operation we
> > fail.
> > 
> > When it comes to a parent attr rename operation, we are effectively
> > doing two linked operations - remove the old attr, set the new attr
> > - on different attributes. Implementation wise, it is exactly the
> > same sequence as a "replace value" operation, except for the fact
> > that the new attr we add has a different name.
> > 
> > Hence the only real difference between the existing "attr replace"
> > and the intent chain we need for "parent attr rename" is that we
> > have to log two attr names instead of one. Basically, we have a new
> > XFS_ATTRI_OP_FLAGS... type for this, and that's what tells us that
> > we are operating on two different attributes instead of just one.
> 
> This answers my earlier question: Yes, and yes.

I see, alrighty then, I'll see if I can put together a new
XFS_ATTRI_OP_FLAGS type that carries both the old and new name.  That
sounds like it should work.  Thanks for all the feed back!

Allison


> 
> > The recovery operation becomes slightly different - we have to run
> > a
> > remove on the old, then a replace on the new - so there a little
> > bit
> > of new code needed to manage that in the state machine.
> > 
> > These, however, are just small tweaks on the existing replace attr
> > operation, and there should be little difference in performance or
> > overhead between a "replace value" and a "replace entire xattr"
> > operation as they are largely the same runtime operation for LARP.
> > 
> > > So the recovered set grows the leaf, and returns the egain, then
> > > rest
> > > gets capture committed.  Next up is the recovered remove which
> > > pulls
> > > out the fork, which causes problems when the rest of the set
> > > operation
> > > resumes as a deferred operation.
> > 
> > Yup, and all this goes away when we build the right intent chain
> > for
> > replacing a parent attr rename....
> 
> Funnily enough, just last week I had thought that online repair was
> going to require the ability to replace an entire xattr...
> 
> https://urldefense.com/v3/__https://djwong.org/docs/xfs-online-fsck-design/*parent-pointers__;Iw!!ACWV5N9M2RV99hQ!MA2KfxWZLMTj_fdJoFnvZhLIgOGsGlIclRVE39DFME755VnvyX4VqsQGM6GfBDnDXKkfAcFjdv2oENaXepic$ 
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com

