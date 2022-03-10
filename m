Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20275C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 06:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbiCJGOp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 01:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239717AbiCJGOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 01:14:44 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F5795A3C
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 22:13:41 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22A13xMB009103;
        Thu, 10 Mar 2022 06:13:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Z4pSutRcJ4Dk/lD38ntr35A0DqA3I3vY7plnUUqw990=;
 b=Zeal1ykCpbdZZ4M80GmjslWukRzMTTKzo3pNBO/SA2nAtDoYLsQ6/1DU5ei5Ks92eCjE
 gVfIS64Di4FfE8Ekp/nYEI6B6DC8SsrfZ0ZU5mrin5nI8O0Kob7l/H5Xq8myCZkLryFM
 MyN1TEoiw1QxXN9+Zwh7EEYyintW2Mk4qwGpXcGi6nnTLuB/H9h/nRKI/TM+jbCH68do
 0QW8Inl2ubX31foKWWs/46JBOSQrkvlyFQn2ImkKHsCc9NpCEEIWo4JgDKw+QLRYonae
 5XnrkjAvZGbtQ+VooHRrGrdBbGLhCCwiV5ntR7dzT8BN5U4FzP2SZWNznAzRzQVQHj3W jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2mbj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 06:13:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22A6AQB8142764;
        Thu, 10 Mar 2022 06:13:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by userp3020.oracle.com with ESMTP id 3envvn1n6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 06:13:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TiM1YHRTRK0U+mcr16zMFqUQicB5TJideJdBKrOPwPA5i9ftSq6Grn+JFfFrgj0gkzXQYfRruigtkNGKjxJ5JAYVimFqO5lUYpGnxc5TB/6WEDto7mbmoJ7DlRwJPS8eY+H2HO33+rfuKW7u9uge5ysEJT2U3JdWjiYM3GjaditWjveYvLgIVcFxKr/fs7UOVEnvcyXJaH+txwry3n2Vah7ZI0vdi4Jz86bj0gZv5YGcUevlOaJoaUE93y8WeQrf0bEZ/dcdmM9JzfmxENiLouGcJMMkuF+KeV3crV6oml8c8WEFtCJIln4em+ruSsooLsy8BPY/tAh1tEwd5F3Y+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z4pSutRcJ4Dk/lD38ntr35A0DqA3I3vY7plnUUqw990=;
 b=HVFQYWOJGsPlW0knerNVlfg/f6jym8yrExDa4Lf1Vc9HxkFzaNZpZS6TTNK/Feggx73xmnU0ZbUZyZqYP3bycsKVESwoTgHoNBzznhvDfJNK3oNs7L13rohQdb50bTIbr3UwTwcwrHl5+tKUEZ/edDO0JIfFV4nyctHM1knTq/pkhCST042n/v2P+x2+BliGW4yZLCx9jojWQ+6tg3LouWn5yLoe+HpECLaGKRfW/CLCiHMdtYXUUCh+2BNfvMz9YCd1yQ3sZ/TAKL6ym9JJdwadnJvQWVOFkPYQ/WYi7jW0qDV2fqYEwTgcsE5VUYqzXE+XPuS9DnbNOF5OxerZkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4pSutRcJ4Dk/lD38ntr35A0DqA3I3vY7plnUUqw990=;
 b=HKhbPMVAu/t+ep9O35b0y9l7Ktu/pS+UUoIR1bm/IdcSKtUChVIarSAuMSTwW4raE+IIj2Xi3S1qJaQ0VRLygOfXcLKWfj+MTMQZlR9tdWRrAJbpX/uEDj5Wo2WKGCJOKn1Z7d0CclGuLKHFz5WJ8AmlDkBRnxlipb23AiN8zrs=
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by MWHPR10MB1917.namprd10.prod.outlook.com (2603:10b6:300:107::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Thu, 10 Mar
 2022 06:13:32 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a91b:c130:5e3f:119%8]) with mapi id 15.20.5061.021; Thu, 10 Mar 2022
 06:13:32 +0000
Message-ID: <9d4d36677a375857fe4358059cba0a666d43a340.camel@oracle.com>
Subject: Re: [PATCH v28 00/15] xfs: Log Attribute Replay
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Mar 2022 23:13:29 -0700
In-Reply-To: <20220309035351.GA8224@magnolia>
References: <20220228195147.1913281-1-allison.henderson@oracle.com>
         <20220301022920.GC117732@magnolia>
         <d93c3a9a-126b-058b-81e2-bdf2e675ad0a@oracle.com>
         <20220309035351.GA8224@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:a03:100::41) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ec55e08-1c8d-4698-26e0-08da025d1a24
X-MS-TrafficTypeDiagnostic: MWHPR10MB1917:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1917B622CDC63DAEB5E5E92A950B9@MWHPR10MB1917.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9USQO+J4e7hRSwz2Sf682Hha9qmnRnc3G1L+0zi6jcQ5txKrHppDchguGhk0WfteHNqJomFWWAHCBYHy/OjLd8VRx029RCgK908J8fEKfn7A2Wm1Mb2teTtBqlOIl8z+IuJdNtVAlAM9czKalkAdpHWqlKhehvRU5ilYynrRyZ16G3QnYvnlLzTiBQ3POCwSh80EC4GEgsA1vSJhRZHMA1Xd4qhototXI94ag/e0LyD9shHdYXhW6Z8ZzkeYr57EWYBKX96LIcsV/O49hTD9z85ZP96bikuuPdXiiNo+fKmhVR516dbD7ziYYYEr7A3fpxWmbhz+7RsaCvYExtUnrU8nMFI1qeX3h0yMfTPr+yH3AEmYCmGi9gmgifj68oj4kBZuNmve0mSsz4TMUc3V/2gd5cALzK97S68iSTveqIaHWLw1hUYaq2HYSzuUTlfuQR3GZhwBQtXZJwi2Fncg+YksDw06hoCvDktQTgB17DW7CXh5ISiqWk8p8QT7WhNR703NHC+2XqeOMfVKQ1rCWAr5iOlUjOP4u9Bwldq1n1NE4ZxN74dsBN6R4I1WVVLdEsG22hYg/AhApHJo+lhl9MnDpfqW+SC5G/3vv7JxIN7SlojEmUN3TcGaSCuouvsJB2csjkJ22iHPc1rLxKE6UKPKcVRSzpdMp7s3FivJGmHGx5yl++Rf4XGNCko0wR0Rqj6hSXGqRwZuLJQih57r4TKuO8uGRPvBJeUn/Yf18io=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(2616005)(38100700002)(38350700002)(316002)(2906002)(508600001)(6666004)(6506007)(53546011)(52116002)(8676002)(66556008)(66946007)(66476007)(4326008)(6486002)(6512007)(30864003)(26005)(6916009)(8936002)(36756003)(86362001)(186003)(83380400001)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WURqM05mV214eVdZNnRMZDBtOU1mTGpWbmtyTWtMM2QvcUZZekprNjloRk1l?=
 =?utf-8?B?UDRabFk0R2ppQTM3RFZNNjA2QUp1QUNFcGxpdi9yNTFMUW5xazN6RWZBbytP?=
 =?utf-8?B?ZXlIK0lGSW9Zd2hYcGNQbHk2VjRhNjdYL0ltODk2SmgvOS9PbHA5QXRZUmlH?=
 =?utf-8?B?RGI4TU52R0l3angwbTlRMGl1VXV5emZuclZSeW03RWxMRzIvUlhjcDU1UGNM?=
 =?utf-8?B?QWpDNnFwakVzdWovRTl1K01nY3N5WFByYnlab1NyOVE2UFdtczFDRUs0OEl2?=
 =?utf-8?B?RHIydkx6UC9aS1UwaWIwSm1SVDB4a3RMdGVNU2FvUlZzS3FhcWxDN1NIZ0N0?=
 =?utf-8?B?anNTNk50RHBGR3VUQldrSHozZlgwSm01RUJySjlwNzA0MVI3aFJOc3VSY2Vl?=
 =?utf-8?B?bHBPYm0zU3AyRmVwV2VHaXo3czZSRCs1dTJqSjE3aFhZekxvTm1yWHoyaXpv?=
 =?utf-8?B?NnFiREdCNW0xOTA4R3BnM0ZiSnVoVWJZVVoxZjZFQzhSYzJTK0FRR0tPVHFY?=
 =?utf-8?B?Y3krS0RWbVQ1NlgyLzRPeW5uemh1N0NRQk1pVTA0WEJJcjhzbW9Qdk5PaE04?=
 =?utf-8?B?a1R0byswUTg0MkNlS2dxWGEyVTUzNmNvVW9rYVppU3NqN29Fem1KWkMxRUFN?=
 =?utf-8?B?MGlPd2cxb1FaelRmbC9icE91YWxlZ2tyMVlzbXZ6UFh5Rm1ab1hSeGIybEUw?=
 =?utf-8?B?TmNSSTJCQ0wyTlc5WnowZE9Sdm9Oc0pFK1c2aElxQU5VbVpWNHZ1WXlrb1Zh?=
 =?utf-8?B?VTlOajdZL1ZoaGZDb25ua2lQODFjTHV1K2h0L1M5SDlTYmlnelNQUDZNS3Iv?=
 =?utf-8?B?QkRaNjZ4bE56bGRoZGEvU0ZxZUU3ZlZSOW1nL0l1VUs4eEhyZjBnOUI4amo4?=
 =?utf-8?B?allPVU1HL3JlM21xVlpzWDkrajdZVXN0aGIzNXVtZ1R1OVp3RTNDSTFFWnF5?=
 =?utf-8?B?OWV1MkswR25IR0RLVTJZU2c1TE0valFLd2JDTEk2N05vaitOeEMxSW40SkFJ?=
 =?utf-8?B?NTVCcG5NZkpsSWNpc1VBOEM5UWZpNTA0Ti9STzk4eGtTVkV0amhrZlNzT2ZB?=
 =?utf-8?B?Z2REOUhibmhudTI2d0ZTRHJFUElvSTdhc1dmM2J5d2phQ25PUTVWdlEzZWdE?=
 =?utf-8?B?M0s2ejdsS0Vta2lxbEhYNk9ob1ptSjZVWHlneHdqa1hNUlVEUVVmODZmbVRJ?=
 =?utf-8?B?WktSRkZZNmdIY1F6T0dvMnZGdldsdWc1ZkpzcUJzVzZWUUpLY1lMUHRKVnhs?=
 =?utf-8?B?cW1SRTc2R3JtSldjRTFaSEo2Tm81aWx5VVM2OEd2d3F5K2dLLzl4STNFVjJU?=
 =?utf-8?B?dFdiNkd6K203MlFpMklHdTlyREwrSUVVMEpxT2JsbkY5M25DVnVpQU1NSmFM?=
 =?utf-8?B?MWRZSTV1OHkvTXFmWFIzS1pNMjlQQW1Nc1hXRnplUitOQk1TT2g5YllPOUx2?=
 =?utf-8?B?SzY5dXFRaTFCSEtxUitGemFXZEUwdERKM2l4WnJhQmlFOXk3N2dKaXl1eHhk?=
 =?utf-8?B?MGs0NWR6UTFOczIwRGt1ZSswTEgrTVJ3Y1JtM0U0cy9JeUJDM0FDRlJ0alBr?=
 =?utf-8?B?QW5hWXBubFRzZUpmTDJ2M3U2N1pKM0RhQXZ3aVJrOG9WejNuSENRa0VndzMz?=
 =?utf-8?B?bXZvRzRweERqbWlLZ2c5Z0xzdXhvdVpJK0tyV2Z4a29LZFMxTHpSZnorWWsr?=
 =?utf-8?B?aFRkMklucGRPTjdzY1ZzWVlDTDhoZm5UY3ZqTFhKVGJjRnFlU3gvK2ZkT0ZB?=
 =?utf-8?B?MnpDT21OU0RvT25qeDNJOEd5cXdlcHVzckZicWo2Wmo1c3lveWtXYVdCc3Vz?=
 =?utf-8?B?UnBwREFzdjRkMlMyZnA0dVRCY3RiVVhxTlBHV1NXOFBPUmNWSkpNTUJwV1pE?=
 =?utf-8?B?elJpNDZ2WDViR3FDNWZTTlhtV2R1N0VoYTh2WEtPZklrZE1ibWlibWNYTEhZ?=
 =?utf-8?B?THY4V3NwQVRKRVFnRWgwNFYzQmJ5bnZTR2QxT3VRbjlER3dWT1hpeU1ubXR4?=
 =?utf-8?B?ZTdQNGNERStkQjd3YVdtb1ZuZTcveVArdElSTFdDNlJiaVgvMDVaUUdQZnZE?=
 =?utf-8?B?QUV2NU1mNEFrOGNWRWJuUFg4dXYrdWlhUXF1VjNxckczYitnTjNzRTI3MG1W?=
 =?utf-8?B?bVNaZWtTS09EVUE3VWhpZlJHK3RuSXp0OC8xc0gwVWl6MVdOcTYxd2lSZjFl?=
 =?utf-8?B?b1diQk1HNjZPWFdNQTJDUTF1Z2dNalUwdmtsUmJzd08rTEozUWxYZEVNWlNs?=
 =?utf-8?B?cS91TjNueFpNYmV0aXZBb1dDcDZRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec55e08-1c8d-4698-26e0-08da025d1a24
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 06:13:32.1699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKK+v2t8pSXQZxtKYJsqNVCkKA5lG7epu2MAekNHK7BNnjBFLFClIkM/33IdBkFfme2eRyK4i959IpO+GMUIuJADwO7vClAeipSCjusAslI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1917
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203100030
X-Proofpoint-ORIG-GUID: wlQdNGaUDhlHvilzyS5k2rt18bHu-P-l
X-Proofpoint-GUID: wlQdNGaUDhlHvilzyS5k2rt18bHu-P-l
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-03-08 at 19:53 -0800, Darrick J. Wong wrote:
> On Tue, Mar 01, 2022 at 01:39:36PM -0700, Allison Henderson wrote:
> > 
> > On 2/28/22 7:29 PM, Darrick J. Wong wrote:
> > > On Mon, Feb 28, 2022 at 12:51:32PM -0700, Allison Henderson
> > > wrote:
> > > > Hi all,
> > > > 
> > > > This set is a subset of a larger series parent pointers.
> > > > Delayed attributes allow
> > > > attribute operations (set and remove) to be logged and
> > > > committed in the same
> > > > way that other delayed operations do. This allows more complex
> > > > operations (like
> > > > parent pointers) to be broken up into multiple smaller
> > > > transactions. To do
> > > > this, the existing attr operations must be modified to operate
> > > > as a delayed
> > > > operation.  This means that they cannot roll, commit, or finish
> > > > transactions.
> > > > Instead, they return -EAGAIN to allow the calling function to
> > > > handle the
> > > > transaction.  In this series, we focus on only the delayed
> > > > attribute portion.
> > > > We will introduce parent pointers in a later set.
> > > > 
> > > > The set as a whole is a bit much to digest at once, so I
> > > > usually send out the
> > > > smaller sub series to reduce reviewer burn out.  But the entire
> > > > extended series
> > > > is visible through the included github links.
> > > > 
> > > > Updates since v27:
> > > > xfs: don't commit the first deferred transaction without
> > > > intents
> > > >    Comment update
> > > 
> > > I applied this to 5.16-rc6, and turned on larp mode.  generic/476
> > > tripped over something, and this is what kasan had to say:
> > > 
> > > [  835.381655] run fstests generic/476 at 2022-02-28 18:22:04
> > > [  838.008485] XFS (sdb): Mounting V5 Filesystem
> > > [  838.035529] XFS (sdb): Ending clean mount
> > > [  838.040528] XFS (sdb): Quotacheck needed: Please wait.
> > > [  838.050866] XFS (sdb): Quotacheck: Done.
> > > [  838.092369] XFS (sdb): EXPERIMENTAL logged extended attributes
> > > feature added. Use at your own risk!
> > > [  838.092938] general protection fault, probably for non-
> > > canonical address 0xe012f573e6000046: 0000 [#1] PREEMPT SMP KASAN
> > > [  838.099085] KASAN: maybe wild-memory-access in range
> > > [0x0097cb9f30000230-0x0097cb9f30000237]
> > > [  838.101148] CPU: 2 PID: 4403 Comm: fsstress Not tainted
> > > 5.17.0-rc5-djwx #rc5 63f7e400b85b2245f2d4d3033e82ec8bc95c49fd
> > > [  838.103757] Hardware name: QEMU Standard PC (Q35 + ICH9,
> > > 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> > > [  838.105811] RIP: 0010:xlog_cil_commit+0x2f9/0x2800 [xfs]
> > > 
> > > 
> > > FWIW, gdb says this address is:
> > > 
> > > 0xffffffffa06e0739 is in xlog_cil_commit
> > > (fs/xfs/xfs_log_cil.c:237).
> > > 232
> > > 233                     /*
> > > 234                      * if we have no shadow buffer, or it is
> > > too small, we need to
> > > 235                      * reallocate it.
> > > 236                      */
> > > 237                     if (!lip->li_lv_shadow ||
> > > 238                         buf_size > lip->li_lv_shadow-
> > > >lv_size) {
> > > 239                             /*
> > > 240                              * We free and allocate here as a
> > > realloc would copy
> > > 241                              * unnecessary data. We don't use
> > > kvzalloc() for the
> > > 
> > > I don't know what this is about, but my guess is that we freed
> > > something
> > > we weren't supposed to...?
> > > 
> > > (An overnight fstests run with v27 and larp=0 ran fine,
> > > though...)
> > > 
> > > --D
> > 
> > Hmm, ok, I will dig into this then.  I dont see anything between
> > v27 and v28
> > that would have cause this though, so I'm thinking what ever it is
> > must by
> > intermittent.  I'll stick it in a loop and see if I can get a
> > recreate
> > today.  Thanks!
> 
> I think I've figured out two of the problems here --
> 
> The biggest problem is that xfs_attri_init isn't fully initializing
> the
> xattr log item structure, which is why the CIL would crash on my
> system
> when it tried to resize what it thought was the lv_shadow buffer
> attached to the log item.  I changed it to kmem_cache_zalloc and the
> problems went away; you might want to check if your kernel has some
> debugging kconfig feature enabled that auto-zeroes everything.
> 
Ah, ok.  When ever you get a moment, would you mind shooting me a copy
of your kernel config?  That might be an easy way to bring together
some of the differences between our testing environments.

> The other KASAN report has to do with the log iovec code -- it
> assumes
> that any buffer passed in has a size that is congruent with 4(?)
> bytes.
> This isn't necessarily true for the xattr name (and in principle also
> the value) buffer that we get from the VFS; if either is (say) 37
> bytes
> long, you'll get 37 bytes, and KASAN will expect you to stick to
> that.
> I think with the way the slab works this isn't a real memory
> corruption
> vector, but I wouldn't put it past slob or someone to actually pack
> things in tightly.
> 
> Also, I'm not sure what's going on with the name/value buffers in the
> relog function.  I patched it to try to track the buffer references,
> but
> maybe you have a better idea for why we allocate new name/value
> buffers
> for a log item relog?  I wasn't sure where those new buffers ever got
> freed, so I <cough> ran it over with a backhoe, and it shows. :/
> 
> The following shabby patch helps us to pass generic/475 and
> generic/624
> in LARP mode, though I have no idea if it's correct.  You might want
> to
> pay attention to the "XXX:" comments I added, since that's where I
> got
> stuck.
> 
> --D
> 

Ok, I'll dig through what you have here.  Most of what youre saying
makes sense, though you shouldnt have to go through all this leg work
with the iovec sizes.  That's supposed to be handled in
xfs_attri_item_format.  What ever arbitrary sized buffers are in the
xfs_attri_log_item are supposed to be adjusted there.

In most cases, the name/val buffers are owned by the calling function,
and in fact usually point back to the name/val pointers in the
xfs_da_args. So in that case, the larp code doesnt own that.  The idea
is that the calling function just passes the args struct into the
xfs_attr_(set/remove)_deferred which will then create a new
xfs_attr_item, and stores a refrence to the xfs_da_args there.  Once
the calling routine finishes up the transaction, it is the callers
responsibility clean up where ever the name/value pair comes from.

When the calling function invokes the defer finish routines, the defer
ops code creates the intent (via the xfs_defer_op_type) which calls
xfs_attr_create_intent. THis initializes and populates the
xfs_attri_log_item with the name/value pointers in the xfs_attr_item

Later the iop code creates the vectors using the xfs_attri_item_size
(referenced through the xfs_item_ops).  Once created, it then uses the
xfs_attri_item_format callback to appropriately populate those vectors.

So, it's complex, but mostly I'm just trying to adhere to what the
interfaces expect


NOW.... during a replay or relog this changes slightly.  These routines
need to recreate the log items, but unlike the calling function in the
above example, they dont span the transaction from creation to
completion.  THey just recreate one item and exit.  SO they cant just
use a xfs_da_args on the stack, nor will they be around to free
anything they allocate.  In this case, we simply allocate extra space
off the end of the xfs_attri_log_item, store the name/val buffers
there, and adjust the name/val pointers to point to this
location.  This is really the only reason why xfs_attri_init has an
extra buffsize parameter at all. So in this case, the name/val buffers
are released at the same time as the item through xfs_attri_item_free.

At least thats how it's supposed to work.  Clearly something isnt
following the theory, so I'll go through what you have here and maybe
shoot you back another patch.  Thanks for all your help here :-)

Allison

> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 41404d35c76c..7a00a43610d5 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -678,6 +678,9 @@ xfs_attr_set(
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_mount	*mp = dp->i_mount;
> +	void			*fakename = NULL, *fakeval = NULL;
> +	const void		*oldname = args->name;
> +	void			*oldval = args->value;
>  	struct xfs_trans_res	tres;
>  	bool			rsvd = (args->attr_filter &
> XFS_ATTR_ROOT);
>  	int			error, local;
> @@ -692,6 +695,34 @@ xfs_attr_set(
>  	if (error)
>  		return error;
>  
> +	/*
> +	 * XXX: the log iovec code requires that every buffer it's
> given has a
> +	 * size that's an even multiple of four.  If this isn't the
> case, create
> +	 * a shadow buffers so that we don't read past the end of the
> name and
> +	 * value buffers and trip KASAN.
> +	 */
> +	if (xfs_has_larp(mp) && (args->namelen & 3)) {
> +		fakename = kzalloc(roundup(args->namelen, 4),
> +				GFP_KERNEL | GFP_NOFS);
> +		if (!fakename)
> +			return -ENOMEM;
> +		memcpy(fakename, args->name, args->namelen);
> +		args->name = fakename;
> +	}
> +
> +	if (xfs_has_larp(mp) && (args->valuelen & 3)) {
> +		fakeval = kzalloc(roundup(args->valuelen, 4),
> +				GFP_KERNEL | GFP_NOFS);
> +		if (!fakeval) {
> +			if (fakename)
> +				kvfree(fakename);
> +			return -ENOMEM;
> +		}
> +		memcpy(fakeval, args->value, args->valuelen);
> +		args->value = fakeval;
> +	}
> +
> +	//trace_printk("start name 0x%px len 0x%x val 0x%px len 0x%x",
> args->name, args->namelen, args->value, args->valuelen);
>  	args->geo = mp->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
>  	args->hashval = xfs_da_hashname(args->name, args->namelen);
> @@ -797,6 +828,13 @@ xfs_attr_set(
>  drop_incompat:
>  	if (delayed)
>  		xlog_drop_incompat_feat(mp->m_log);
> +	//trace_printk("end name 0x%px val 0x%px", args->name, args-
> >value);
> +	if (fakename)
> +		kvfree(fakename);
> +	if (fakeval)
> +		kvfree(fakeval);
> +	args->value = oldval;
> +	args->name = oldname;
>  	return error;
>  
>  out_trans_cancel:
> @@ -852,6 +890,7 @@ xfs_attr_item_init(
>  	new->xattri_op_flags = op_flags;
>  	new->xattri_da_args = args;
>  
> +	//trace_printk("name 0x%px val 0x%px", args->name, args-
> >value);
>  	*attr = new;
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 5aa7a764d95e..8e365583e265 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -43,6 +43,12 @@ STATIC void
>  xfs_attri_item_free(
>  	struct xfs_attri_log_item	*attrip)
>  {
> +	if (attrip->attri_own_buffers) {
> +		kvfree(attrip->attri_name);
> +		if (attrip->attri_value)
> +			kvfree(attrip->attri_value);
> +		attrip->attri_own_buffers = false;
> +	}
>  	kmem_free(attrip->attri_item.li_lv_shadow);
>  	kmem_free(attrip);
>  }
> @@ -114,6 +120,8 @@ xfs_attri_item_format(
>  	if (attrip->attri_value_len > 0)
>  		attrip->attri_format.alfi_size++;
>  
> +	//trace_printk("fmt 0x%px name 0x%px val 0x%px", &attrip-
> >attri_format, attrip->attri_name, attrip->attri_value);
> +
>  	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
>  			&attrip->attri_format,
>  			sizeof(struct xfs_attri_log_format));
> @@ -158,19 +166,39 @@ xfs_attri_item_release(
>  STATIC struct xfs_attri_log_item *
>  xfs_attri_init(
>  	struct xfs_mount		*mp,
> -	int				buffer_size)
> +	unsigned int			namelen,
> +	unsigned int			valuelen)
>  
>  {
>  	struct xfs_attri_log_item	*attrip;
> +	unsigned int			buffer_size;
>  
> -	if (buffer_size) {
> -		attrip = kmem_alloc(sizeof(struct xfs_attri_log_item) +
> -				    buffer_size, KM_NOFS);
> -		if (attrip == NULL)
> +	attrip = kmem_cache_zalloc(xfs_attri_cache, GFP_NOFS |
> __GFP_NOFAIL);
> +
> +	if (valuelen)
> +		ASSERT(namelen != 0);
> +
> +	if (namelen) {
> +		buffer_size = roundup(namelen, 4);
> +		attrip->attri_name = kzalloc(buffer_size,
> +				GFP_KERNEL | GFP_NOFS |
> __GFP_RETRY_MAYFAIL);
> +		if (!attrip->attri_name) {
> +			kmem_cache_free(xfs_attri_cache, attrip);
> +			return NULL;
> +		}
> +		attrip->attri_own_buffers = true;
> +	}
> +
> +	if (valuelen) {
> +		buffer_size = roundup(valuelen, 4);
> +		attrip->attri_value = kzalloc(buffer_size,
> +				GFP_KERNEL | GFP_NOFS
> |__GFP_RETRY_MAYFAIL);
> +		if (!attrip->attri_value) {
> +			if (attrip->attri_name)
> +				kvfree(attrip->attri_name);
> +			kmem_cache_free(xfs_attri_cache, attrip);
>  			return NULL;
> -	} else {
> -		attrip = kmem_cache_alloc(xfs_attri_cache,
> -					  GFP_NOFS | __GFP_NOFAIL);
> +		}
>  	}
>  
>  	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
> @@ -343,6 +371,8 @@ xfs_attr_log_item(
>  	attrip->attri_value = attr->xattri_da_args->value;
>  	attrip->attri_name_len = attr->xattri_da_args->namelen;
>  	attrip->attri_value_len = attr->xattri_da_args->valuelen;
> +
> +	//trace_printk("lip 0x%px fmt 0x%px name 0x%px val 0x%px",
> &attrip->attri_item, &attrip->attri_format, attrip->attri_name,
> attrip->attri_value);
>  }
>  
>  /* Get an ATTRI. */
> @@ -362,7 +392,7 @@ xfs_attr_create_intent(
>  	if (!xfs_sb_version_haslogxattrs(&mp->m_sb))
>  		return NULL;
>  
> -	attrip = xfs_attri_init(mp, 0);
> +	attrip = xfs_attri_init(mp, 0, 0);
>  	if (attrip == NULL)
>  		return NULL;
>  
> @@ -434,6 +464,13 @@ xfs_attri_item_committed(
>  	 * committed so these fields are no longer accessed. Clear them
> out of
>  	 * caution since we're about to free the xfs_attr_item.
>  	 */
> +	//trace_printk("fmt 0x%px name 0x%px val 0x%px", &attrip-
> >attri_format, attrip->attri_name, attrip->attri_value);
> +	if (attrip->attri_own_buffers) {
> +		kvfree(attrip->attri_name);
> +		if (attrip->attri_value)
> +			kvfree(attrip->attri_value);
> +		attrip->attri_own_buffers = false;
> +	}
>  	attrip->attri_name = NULL;
>  	attrip->attri_value = NULL;
>  
> @@ -582,17 +619,15 @@ xfs_attri_item_relog(
>  	struct xfs_attri_log_item	*new_attrip;
>  	struct xfs_attri_log_format	*new_attrp;
>  	struct xfs_attri_log_format	*old_attrp;
> -	int				buffer_size;
>  
>  	old_attrip = ATTRI_ITEM(intent);
>  	old_attrp = &old_attrip->attri_format;
> -	buffer_size = old_attrp->alfi_value_len + old_attrp-
> >alfi_name_len;
>  
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	attrdp = xfs_trans_get_attrd(tp, old_attrip);
>  	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
>  
> -	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
> +	new_attrip = xfs_attri_init(tp->t_mountp, 0, 0);
>  	new_attrp = &new_attrip->attri_format;
>  
>  	new_attrp->alfi_ino = old_attrp->alfi_ino;
> @@ -602,19 +637,30 @@ xfs_attri_item_relog(
>  	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
>  
>  	new_attrip->attri_name_len = old_attrip->attri_name_len;
> -	new_attrip->attri_name = ((char *)new_attrip) +
> -				 sizeof(struct xfs_attri_log_item);
> -	memcpy(new_attrip->attri_name, old_attrip->attri_name,
> -		new_attrip->attri_name_len);
> +	new_attrip->attri_name = old_attrip->attri_name;
>  
>  	new_attrip->attri_value_len = old_attrip->attri_value_len;
> -	if (new_attrip->attri_value_len > 0) {
> -		new_attrip->attri_value = new_attrip->attri_name +
> -					  new_attrip->attri_name_len;
> +	if (new_attrip->attri_value_len > 0)
> +		new_attrip->attri_value = old_attrip->attri_value;
>  
> -		memcpy(new_attrip->attri_value, old_attrip-
> >attri_value,
> -		       new_attrip->attri_value_len);
> -	}
> +	/*
> +	 * XXX Err... so who owns the name/value buffer references,
> anyway?
> +	 * Is it safe to drop them during ->iop_commmitted?  Do we ever
> want to
> +	 * relog a log item after _committed, in which case we no
> longer have
> +	 * the buffer attached to the new log item.
> +	 *
> +	 * If we don't need the name and value after the first commit
> of the
> +	 * attrip then it's ok to drop the references in _committed...
> but that
> +	 * doesn't make sense, since most of the tx rolling is to
> prepare the
> +	 * xattr structure to receive the name and value.
> +	 *
> +	 * OTOH -- _committed is called to write things into the
> AIL.  By that
> +	 * time we are well past formatting things into buffers, right?
> +	 *
> +	 * <zzzz tired, brain dead>
> +	 */
> +	new_attrip->attri_own_buffers = old_attrip->attri_own_buffers;
> +	old_attrip->attri_own_buffers = false;
>  
>  	xfs_trans_add_item(tp, &new_attrip->attri_item);
>  	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
> @@ -633,10 +679,7 @@ xlog_recover_attri_commit_pass2(
>  	struct xfs_mount                *mp = log->l_mp;
>  	struct xfs_attri_log_item       *attrip;
>  	struct xfs_attri_log_format     *attri_formatp;
> -	char				*name = NULL;
> -	char				*value = NULL;
>  	int				region = 0;
> -	int				buffer_size;
>  
>  	attri_formatp = item->ri_buf[region].i_addr;
>  
> @@ -646,11 +689,9 @@ xlog_recover_attri_commit_pass2(
>  		return -EFSCORRUPTED;
>  	}
>  
> -	buffer_size = attri_formatp->alfi_name_len +
> -		      attri_formatp->alfi_value_len;
> -
>  	/* memory alloc failure will cause replay to abort */
> -	attrip = xfs_attri_init(mp, buffer_size);
> +	attrip = xfs_attri_init(mp, attri_formatp->alfi_name_len,
> +			attri_formatp->alfi_value_len);
>  	if (attrip == NULL)
>  		return -ENOMEM;
>  
> @@ -662,11 +703,10 @@ xlog_recover_attri_commit_pass2(
>  	attrip->attri_name_len = attri_formatp->alfi_name_len;
>  	attrip->attri_value_len = attri_formatp->alfi_value_len;
>  	region++;
> -	name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
> -	memcpy(name, item->ri_buf[region].i_addr, attrip-
> >attri_name_len);
> -	attrip->attri_name = name;
> +	memcpy(attrip->attri_name, item->ri_buf[region].i_addr,
> +			attrip->attri_name_len);
>  
> -	if (!xfs_attr_namecheck(name, attrip->attri_name_len)) {
> +	if (!xfs_attr_namecheck(attrip->attri_name, attrip-
> >attri_name_len)) {
>  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
>  		error = -EFSCORRUPTED;
>  		goto out;
> @@ -674,11 +714,8 @@ xlog_recover_attri_commit_pass2(
>  
>  	if (attrip->attri_value_len > 0) {
>  		region++;
> -		value = ((char *)attrip) + sizeof(struct
> xfs_attri_log_item) +
> -				attrip->attri_name_len;
> -		memcpy(value, item->ri_buf[region].i_addr,
> +		memcpy(attrip->attri_value, item-
> >ri_buf[region].i_addr,
>  				attrip->attri_value_len);
> -		attrip->attri_value = value;
>  	}
>  
>  	/*
> @@ -706,7 +743,7 @@ xfs_trans_get_attrd(struct xfs_trans		
> *tp,
>  
>  	ASSERT(tp != NULL);
>  
> -	attrdp = kmem_cache_alloc(xfs_attrd_cache, GFP_NOFS |
> __GFP_NOFAIL);
> +	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS |
> __GFP_NOFAIL);
>  
>  	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item,
> XFS_LI_ATTRD,
>  			  &xfs_attrd_item_ops);
> diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
> index c3b779f82adb..2b690b1d3228 100644
> --- a/fs/xfs/xfs_attr_item.h
> +++ b/fs/xfs/xfs_attr_item.h
> @@ -31,6 +31,9 @@ struct xfs_attri_log_item {
>  	void				*attri_name;
>  	void				*attri_value;
>  	struct xfs_attri_log_format	attri_format;
> +
> +	/* Do we actually own attri_name/value? */
> +	bool				attri_own_buffers;
>  };
>  
>  /*

