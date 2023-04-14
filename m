Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 977F1C77B6E
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Apr 2023 09:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjDNJfP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Apr 2023 05:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjDNJfN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Apr 2023 05:35:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1A44EFB
        for <linux-xfs@vger.kernel.org>; Fri, 14 Apr 2023 02:34:47 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33DLjNAx021479;
        Fri, 14 Apr 2023 09:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=nr/09qnuSDpS1zegjok64aKKd7uHvRf0h3cDHXk6Pk8=;
 b=ZeFlpUqzQLzAB6N9BeDtvMUxW6IMuSpN2mkIGu9y9j8fbG5i9F2IS36v1SU4X4CV4uQ/
 raab03EY3kN6iyLNFzvZKHf16mGMcn74ZVHmU+0WQZ/SgQJl9ZDCYEj44MolS86PHg6S
 pUQpF1n1YAQRY0p3pjnx8ttqwEi6Zy7xk0wNdDIRcJ932H1CD27ttWJnl7Tl8X45BPyc
 a99Ao6VtNCftMcc3Qkqvttevnva7odnpYVO/tkQS/6nKU6dgad3TjQ/+kzNQzQ2IaUgS
 tKZO4TfySwTUdoDFJHiHTT0qF6rpr2Hhwiul4YQ65/II2cMwDlTaBX8UNttWfKXSuvWo kg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0e7nfgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 09:34:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33E7Iabk020950;
        Fri, 14 Apr 2023 09:34:20 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2045.outbound.protection.outlook.com [104.47.73.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pwwgs85gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Apr 2023 09:34:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrfzpD9uLI+87LoqWl/hmmkp4XDWF8TKLKgcJ4ssYvXms9I3h7b+2LPmAokqGfpoHCLWOFp65tb0RV7gpxIxLd9ywbjQNTbkv78v96o79eWntcsI6TTWpQ5HSVlr1Y4+4vUq/OtNPIYzxaw+71A6JbmycDtwKc6Ggeqp3pLZ9IPWuK3nOegxriuMKwOglogHIMYxF24Rbeq6PpoMg2pwT5+KctyGTagbkewf/lW4w3OYRtxxBNqtH7ac4ewg7n9aircyxG3fK/doPnIbNDgCggra2nkyRj1QdNl+UqVvbUB7xrzX9hIzZz/vSgHDjT5tQcsU3QhOnJNDTxTdqMGD1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nr/09qnuSDpS1zegjok64aKKd7uHvRf0h3cDHXk6Pk8=;
 b=cjrLbbXxgH7bOvev08kwPseSLOlqkLw/ih2Z0QQwmyVi4Scpvtp4ND7vhoXVN4SfeRp/UMPIVgqizf0+uQlGQgXdvPBmSX0n10fnd6BDoa4FJ/UkMaL6V7NhZVDlvOQ+RiT3A4DIiHGnRNcR3yJAwiwfuSt7YA5QZ0cuZmbTE1m5r+IMgZuyGURQnRyUyWwoKLSHgvz5boaHCSXlLmCWAwQ7vKCRlu+bFzlUWIs8+FpTVfFM3C1IK863PvhrT65xc8HDdgH2gz7rrSv6w5t0trD5VSS7c6MMvO7zKHyeDJaSEglGNKr9Q66CYCtO0p44dFnMvO4W0wgVVmgmqP1ytw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nr/09qnuSDpS1zegjok64aKKd7uHvRf0h3cDHXk6Pk8=;
 b=rsP0QfIf2/2gLNhxLGLnrAstL436/FRWG9JVFk+Vy76y6yaKNAPTkDP1QrqdJOU4wWTidRunSXPXGgWfNJXndrSwUz3JrG7aTqbcPFNmcMJA0fKh8rpY6RTsQGctjGbnCTfzkPTmiibtGMRWPPV0B0Kh3U95cXK43vS6Rp/E6A4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by IA1PR10MB7487.namprd10.prod.outlook.com (2603:10b6:208:450::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 09:34:18 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 09:34:18 +0000
References: <20230330204610.23546-1-wen.gang.wang@oracle.com>
 <20230411020624.GY3223426@dread.disaster.area>
 <87mt3djwj9.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230412235915.GN3223426@dread.disaster.area>
 <87sfd4jcyn.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230413213857.GP3223426@dread.disaster.area>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix AGFL allocation dead lock
Date:   Fri, 14 Apr 2023 14:14:43 +0530
In-reply-to: <20230413213857.GP3223426@dread.disaster.area>
Message-ID: <87y1mun6y6.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:4:197::17) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|IA1PR10MB7487:EE_
X-MS-Office365-Filtering-Correlation-Id: ee5fa877-b318-413d-306e-08db3ccb6b50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fUvylBo7JqYsvVxPUCQfSIRyXjjgm5XLyczL5cQvJYTnJvTRDoGX7TMT6BpKkxg9mQZLBzsZVqJorW/P1lXsiIXbPwAGPsQIfGMhaTImp+8LwH+m8PpkJu6lotsVfdgq8B7RhXC/tmv4ziDGu3+RBGGs9tFW4JjCBjKYk8nd3GWDBXI+kipPeuX5cCdTK4rB6HMv2/6lwBtnzB/KUBd14MGzNnwzvz2sT9sSPEUysqjJha//zJnsLYpbfLKE4VvvxVyQLkmk/4J/kE6hRJ0H2d4W6CP+35vECfjZavrKK8jVbbUUS7U6FHAzBpDCMZZFeQsMmgkFwWSgqYGfX5Mh1e/uFnLMAQBiOYinWDBt1CjY8QVrLguyOW29tkSKX4w32XXsXgWORO3jtdkb7CWs/c86NSOeJjDw0HIKGNVoD3953Db0ruHlybxksGTWOm0Sfhm3mWZQ/exnJK2aEQ4KxauYPYCTlG7fdteCUpRuAsx6MHmGHN/Z9/EVFpD3EEnpY8nQatXorwyjbnBLi2/+ZFTk72/c7K4fLFnkHldjKqqqDqq2b7Z8qAW9XIclJsFJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(346002)(39860400002)(136003)(366004)(376002)(451199021)(6666004)(6486002)(6916009)(66476007)(66556008)(66946007)(4326008)(2906002)(33716001)(86362001)(38100700002)(41300700001)(5660300002)(8936002)(8676002)(316002)(478600001)(53546011)(9686003)(6512007)(6506007)(26005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4kjPPh4Czh81a4VIUd1EM3++5YcoRW2+T9g7ZUHovzG6b+jKAtVUUz2AiLP3?=
 =?us-ascii?Q?jQNwrw6DVFzjtejc1y87lAodqRNcyZpWQnRCeEVA9zF8weQXt2uxJRgI38jI?=
 =?us-ascii?Q?DV2h4WOF/3ahGXQSD0FwBQJIxPHk49aG4mEpJwMrfM+uL23p0dH12LlBOYj0?=
 =?us-ascii?Q?J5ha9opZ4qu9qUo8Pve8Wq9YmV0YWT45EihcML8CYAfsD95en+8gGf6ZY63/?=
 =?us-ascii?Q?6GIYzH5X7tEe7lgp0XkPDifV0sQqeZsHQvrMWcbesIh+W4gkzyRQnBSSvCJl?=
 =?us-ascii?Q?7pwr9Y/n6YYC2YSdtIvefW3sqBNXe0R6bJT6c+fVba8jnCWEmquyQiTq/2YJ?=
 =?us-ascii?Q?DcKJth18S5GWsBC1Qhl6Do/ZzRSjCwPdE7IphCTuok/v3M3Do7/iy5Nf+sIQ?=
 =?us-ascii?Q?UrUoVX4zZRqppXLsWuhLDUySF1Ua7SHloJ3xq1d70/U+fZFdcGW6PsDXySh+?=
 =?us-ascii?Q?3V0HZ01WqnfSGoaVufIlr2aT6M9/9fyCX06JuT7+NxBp7oz4YDQ6rTbzQhac?=
 =?us-ascii?Q?uwudAt768aaTXkchYD92gQbmJHMrfzFfWBc3eyk+FUvfBhToj8BKOKVMYSEz?=
 =?us-ascii?Q?gwxrYR+ocbiHNpTVH1Q0rOudvdif0Vn1X+gwQPPVznblWCRRo1czvSGw8qkX?=
 =?us-ascii?Q?5wMUGzSKILU6tJ3cEfxFtq+1ATtZloSogSLCC4zIed+WN2Qqe+5Kmqip371g?=
 =?us-ascii?Q?vcLq0Ue9CxWrOPaOvmP0RwhBdT1eiRbBTclzZd3F84hNhje93+zN+5kJE55g?=
 =?us-ascii?Q?siWAwtGQCJ5ih15LSx++vTk+08EudV2oviHrXu60Q0CJTmHER1MrqYxINhCo?=
 =?us-ascii?Q?hqnpOk8QCSmnFeh/D1jPE1BnrFZdrc22agspHUQSwGcfcJTmiAfBgPudjqPJ?=
 =?us-ascii?Q?bNIhDhwQwknNGeFiW+lCyOffHCiai0ZEemv/nLr8QIK904Uj/8k5FkYyxwcA?=
 =?us-ascii?Q?2nZsGuWFqP99MyiXahStjCi7okV4GcU05VMOLUb8PoiIMhfs6hYJ9r6AFRX8?=
 =?us-ascii?Q?0KL14W/HE061LLYwXs/WEvC5i3keVeI8IwycuWltsRyf6KFfeyslpN+4fHrW?=
 =?us-ascii?Q?6bxA5wgZUtIAnIRMRbryPxGujUCtWxc9ZLAAdiNG1IfJCvTNK81A13GL7o8x?=
 =?us-ascii?Q?Lv8zDwX/WO5WTxQNGirbJ0zDV4mhe88roT81OMrOeiC3nL3dLr8ubh6czdN/?=
 =?us-ascii?Q?+jpysRzzbzTDJwb+6pQ96QaFlO1ESpR1GVTAQhGuiydrSU2o3lTG4XHWQVbG?=
 =?us-ascii?Q?QBcN02F0AZDqW7KnZybw/77el+PhiGm/62B4pe/uJVEq4xcPYPQnYyFfpHph?=
 =?us-ascii?Q?WGD0w+Fqp+LoU0i3qA95uxDxu6W4+vpT1VAalVBUQF9ZCeW9Gc0O8MBJgtmC?=
 =?us-ascii?Q?JpElqwY7KVLSpD9n88LoqOsEy/aN4qCQIFzaVVueVhxvZdd5IApGpg/K00E7?=
 =?us-ascii?Q?tAGnsDfFhn+POLQxW4Zul/ewq6nD9lKSy1nuUZe1lBOpRfFDf8vIuOAZqYGI?=
 =?us-ascii?Q?c8VITBWW5/hyga3dEbrpOfzw8/8ghy33Q9YKuLS/mxmK6E7Ub63ud7PXNXdn?=
 =?us-ascii?Q?nu+oZQ/EjDyY0t9/KEZScLoa2hrFoVOX0SN+zoBv?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: trJEyXKqUs3TOBKgu7XBE97hnmcywc1g+1CKJn86pRTABQ3ZC5/O+Nyt3DX1nPzZMT/+lcqzpunXpzuP/xapbs4XlX3jgeVuz5EmrwKMsSHGI8mO7El1T8sBDsvameBVPn6e0nfNrCwT3hcI82RQcgqSvUyCnVWRujvrQGn23WI20FEjvwdqY4cbbOlNodceOJC3spVFzuJlhxNC9fYFhauIVae/zMKcq7TUWexIV6Mf02WZ/BRXFwziMP1LOrhyGAo8LrEUh9rVmRrjEtpKVW92v4ARmz+uQw8Ms/emOqaSlslA1DgEV5Q+LczTcacNCHjrGzAZfSJqeyoVPpd0ETHvOby7FP4+SVf3UWeKYKL42kF1gYipF+EZ/x8ApSDWa9dVb+EmN6YvdkF3EnmV4LhDtam5j8TiRXgDsYStLsac5gvVt6p2WQhaQmD3PC9xCccTL3B5EPZMVB5d988/Q6tQEn9xr+t0ECnd4nEjfsIQjyy0DsIF8JVdQyDMUkHK7eL1ViMWQZ6iD/5+eihqcpMrDW7fTR7Ek27ZHhYqy7bngkmQqSkPr+JHKKeeGFGMZmlA6r0jNZc0WllTsnE4XA6U6RO+pgdfTM7i1FWavrzfgSxKpVjg1n+MRCSPMrEU09A+crxlecqWRdg23MDiKYhTf73edg5EH+qop0DWOme+UzRlbrX4GF7GnPZE/y/K/HAJrFEJyEFDpqVatrN676Yzo1PQzAs+mRKK3brNcumxPb+27ohh3fd0yQZbZsSlAqM+fQ/+O/VGhMdSd2r7XL/32+Xw/riTbtAq9P4Fask=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5fa877-b318-413d-306e-08db3ccb6b50
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2023 09:34:18.3039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WNiv5Pd1xbxHkEhTXNI+9gAXYNeuKRfqTYnQ48pdfQDlAD40s/hYdstCl4i4ubE3BjIAPrmCqvWN0m0vByODvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7487
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-14_04,2023-04-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304140086
X-Proofpoint-ORIG-GUID: Eweo10PbJojT247wocC-SrTzuEtKeD82
X-Proofpoint-GUID: Eweo10PbJojT247wocC-SrTzuEtKeD82
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 14, 2023 at 07:38:57 AM +1000, Dave Chinner wrote:
> On Thu, Apr 13, 2023 at 03:46:38PM +0530, Chandan Babu R wrote:
>> On Thu, Apr 13, 2023 at 09:59:15 AM +1000, Dave Chinner wrote:
>> > On Wed, Apr 12, 2023 at 01:53:59PM +0530, Chandan Babu R wrote:
>> >> Processing each of the "struct xfs_refcount_intent" can cause two
>> >> refcount
>> >> btree blocks to be freed:
>> >> - A high level transacation will invoke
>> >> xfs_refcountbt_free_block() twice.
>> >> - The first invocation adds an extent entry to the transaction's
>> >> busy extent
>> >>   list. The second invocation can find the previously freed busy
>> >> extent and
>> >>   hence wait indefinitely for the busy extent to be flushed.
>> >> 
>> >> Also, processing a single "struct xfs_refcount_intent" can
>> >> require the leaf
>> >> block and its immediate parent block to be freed.  The leaf block
>> >> is added to
>> >> the transaction's busy list. Freeing the parent block can result
>> >> in the task
>> >> waiting for the busy extent (present in the high level transaction) to be
>> >> flushed.
>> >
>> > Yes, it probably can, but this is a different problem - this is an
>> > internal btree update issue, not a "free multiple user extents in a
>> > single transaction that may only have a reservation large enough
>> > for a single user extent modification".
>> >
>> > So, lets think about why the allocator might try to reuse a busy
>> > extent on the next extent internal btree free operation in the
>> > transaction.  The only way that I can see that happening is if the
>> > AGFL needs refilling, and the only way the allocator should get
>> > stuck in this way is if there are no other free extents in the AG.
>> 
>> If the first extent that was freed by the transaction (and hence also marked
>> busy) happens to be the first among several other non-busy free
>> extents found
>> during AGFL allocation, the task will get blocked waiting for the
>> busy extent
>> flush to complete. However, this can be solved if
>> xfs_alloc_ag_vextent_size()
>> is modified to traverse the rest of the free space btree to find other
>> non-busy extents. Busy extents can be flushed only as a last resort when
>> non-busy extents cannot be found.
>
> Yes, exactly my point: Don't block on busy extents if there are
> other free space candidates available to can be allocated without
> blocking.
>
>> 
>> >
>> > It then follows that if there are no other free extents in the AG,
>> > then we don't need to refill the AGFL, because freeing an extent in
>> > an empty AG will never cause the free space btrees to grow. In which
>> > case, we should not ever need to allocate from an extent that was
>> > previously freed in this specific transaction.
>> >
>> > We should also have XFS_ALLOC_FLAG_FREEING set, and this allows the
>> > AGFL refill to abort without error if there are no free blocks
>> > available because it's not necessary in this case.  If we can't find
>> > a non-busy extent after flushing on an AGFL fill for a
>> > XFS_ALLOC_FLAG_FREEING operation, we should just abort the freelist
>> > refill and allow the extent free operation to continue.
>> 
>> I tried in vain to figure out a correct way to perform non-blocking busy
>> extent flush. If it involves using a timeout mechanism, then I don't know as
>> to what constitues a good timeout value. Please let me know if you have any
>> suggestions to this end.
>
> Why would a non-blocking busy extent flush sleep? By definition,
> "non blocking" means "does not context switch away from the current
> task".
>
> IOWs, a non-blocking busy extent flush is effectively just log force
> operation. We may need to sample the generation number to determine
> if progress has been made next time we get back to the "all extents
> are busy so flush the busy extents" logic again, but otherwise I
> think all we need do here is elide the "wait for generation number
> to change" logic.
>
> Then, if we've retried the allocation after a log force, and we
> still haven't made progress and we are doing an AGFL allocation in
> XFS_ALLOC_FLAG_FREEING context, then we can simply abort the
> allocation attempt at this point. i.e. if we don't have extents we
> can allocate immediately, don't bother waiting for busy extents to
> be resolved...

The corresponding pseudocode for allocating blocks to AGFL during an extent
free operation would be the following,
1. Search all extents in the CNTBT for non-busy extents.
2. Return if extent is found; Otherwise,
3. Issue a log force.
4. Retry non-busy free extent allocation.
5. Return back regardless of whether non-busy extents were found or not.

I think I may have found one scenario where the above pseudocode would break.

Assume that an AG has very few blocks of free space left and that these blocks
fit within the root node of CNTBT.

Assume that we have a large file which is backed up by contiguous extents
belonging to the AG and that these extents have a refcount of 1.

fpunch operation is issued on alternating blocks of this large file and the
punched out extents are added to,
1. Per-ag RB tree that tracks busy extents
2. CNTBT causing the CNTBT to grow.

Step 2 can cause consumption of blocks in AGFL and we can end up with a CNTBT
having two fully filled leaf blocks and one root node.

At this instance, a fpunch operation on a file extent having a refcount of 2
can cause the leaf node of the refcount btree to be freed. The free operation
now tries to fill the AGFL. However, it only finds busy extents and issues a
log force. The operation can fail to find any non-busy free extents because
the busy extents probably have not yet been discarded.

The free extent operation fails to fill up the AGFL. Later, adding the free
extent (refcount btree's leaf node) to the CNTBT can require the CNTBT to be
expanded (E.g. Adding a new leaf node). However, this fails since AGFL doesn't
have any free blocks left.

-- 
chandan
