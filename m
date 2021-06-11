Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B222BC48BDF
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 00:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8388461009
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 00:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFKA7R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 20:59:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44658 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhFKA7R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 20:59:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15B0nxiW029762;
        Fri, 11 Jun 2021 00:57:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=pRWd1+ktbF0qi079cg3iptvtClg15aczex1JR8nQYRQ=;
 b=HzZxyY1B96s1fPXMqnXroTGN1IP7akMVRIehq22GmuOlfeKZwlIXKfoX1vn6gWHQZKsm
 1Z9uhUwLkAAbol4dXLbwSOFuXJa9NPQ9CKR19oeyXTuQSLUXd9er/TiqJJQ6UMmvImxG
 L9/gMVzgFUPfwl3/p/z1xAcOJ0ULjGMqIhpczDpzdkgt7+awkZ9nycQTGgc2qjmiL87m
 Xh2ZPk6z28v0qVCR9lb0L8w3ZbghNwSs9fHH7C108Ojs457bqrRcmeVpLndU9qMKxFP0
 c5rD41Q0/QWe9/XAt3DBDcsgrvHkkbdFfrAHOoOm1sGwaE5yVcejxAOj7Uz9f+JerCzp tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 39017nnbac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 00:57:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15B0oWb5174482;
        Fri, 11 Jun 2021 00:57:17 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
        by userp3030.oracle.com with ESMTP id 38yxcx38yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 00:57:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJPysHp03p1QMEtyOG/PsEw4WSCohtqHNzRlNEPqpegvJG8Rox/qMPyXRlpDusQ/H+8EYGRdkkPBfgetbBfUfSPNpyWcNC2xuzub01EanCuhs4DM26WptGCWr0LyuF+GDShaqANeN8pxRM5kQXmczQ/ISayJHkVM8v540fwgQ617aJ4VCwN9i1rg8yvgL47cBheqE1dxAqwJ7+MNVxCh0A3ote2sJuvuDZtXDXgI/m+6Y+QMyBLVzcLrcubkVMVVnLf55+z22hVeDHGemAP0We6WShcudiFXjalRZZct2VMXofS2sp8XWQ+J0hlP6sRpg0n8e2XEQi9ykjg2XJ4yHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRWd1+ktbF0qi079cg3iptvtClg15aczex1JR8nQYRQ=;
 b=hkm1+6elgyvksVgPxLQSVhGWmZGQckKNOofp2lB0gUubOTsHiotA/08jOC06auwboTDahwHjOZ5g+PDTHcAhVwyDXVVVkazAvjWGMFUsGf0j2kjFmeSokEY9YJSaubOB67fkLn80WIg6pBHoMzgkiIodHE541lFNs/b4PYdg0LMhL1WS8fn0rUGIVGUZaFKZ65K3kEnExRRhoOdc/0d8xYLUV4ZFwmoV0A6NsdWQftClKdxbL99C6IQi7lhQjN6RKRUS1wUqpQ6hvdxbU+D+xsEDCmrGVtraYaJyfuBdjDWijwO+QoiIH30pcHtd0H+SzH6/5FS7MuzaMxcxXHAkzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRWd1+ktbF0qi079cg3iptvtClg15aczex1JR8nQYRQ=;
 b=kd+8uluWkyAa+9En2vmUovyQQ88A+JK+5eLqzO543kGS0q5bDLwjJvC8TMBnbzfT4RxOxrjaDrBHatrIjSg2xc4zSOsnwdI5fpvk/TrnVRedfFA/0x3pF4tLey4GStqrRlOUET65uNh2NLTUoF2eMykzXLOdmppD7RVvHD5BXHA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4800.namprd10.prod.outlook.com (2603:10b6:a03:2da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 11 Jun
 2021 00:57:15 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.032; Fri, 11 Jun 2021
 00:57:15 +0000
Subject: Re: [PATCH] xfs: perag may be null in xfs_imap()
To:     Dave Chinner <david@fromorbit.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
References: <YMGuMliXClE/dz5y@mwanda>
 <20210610223747.GR664593@dread.disaster.area>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e375e2c9-5ebd-4430-e60a-11669f72da73@oracle.com>
Date:   Thu, 10 Jun 2021 17:57:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210610223747.GR664593@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR11CA0077.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::18) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BYAPR11CA0077.namprd11.prod.outlook.com (2603:10b6:a03:f4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Fri, 11 Jun 2021 00:57:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6adba7d-8342-4674-2fac-08d92c73da70
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4800:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB480039B76F68F358EB3D20C695349@SJ0PR10MB4800.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ma6LoVWhVbjW04JRjBFx1hu49gDEjPEex+qX0m7TaHFmnNzaQ9UMXqbcoWtpH2fQcCSZI2Yg7LVD0qPH1CdOn9rC61g6pFuEfbRwoDKuK7vk+b0pF8ldfKzbn9AzhwEunF7E+cUTO62g3q/f+dhv4K7xT21WzmKRQ0Xkq5iHQ6sm/GzF6bbs+31q32ah6zbrvVkxDa9rWswJNe2F+cVGMBUlfS6ZswilcDQaOF8F6/wt0vA8PuKkCexuLd6/F3pOtWZJdbjbHS0Cgbs+thmffvUXFhYQy2ZPdQyPGOfPGcuF7lRw9Q79ltp8vpZ2tQGlhsQgz2aQWiU83EncbTAdct07DUW8TPs39Ty1ACptxolReHwnEbYIMAlFWDgrkqsT/JajSs5S1NRcp8ZlNVxH6r/v8Rs+Cdtk+x2e/APLyIvpdQKlXQTuZaKzEpMNXze0KVDBOPctEC0q5e6QPyyAV0WudUbNN53GzPtvzW0dpwk0Ek5kCa83yClRYp7cMAo5/1P6O4l6FuHF5HT4LN4vvh0da+3uVU3jCxR2xtbJAm+TI6Tf8b0KRFba9AMH356oXm12VYzPC+NQZkx0zzRjUS9dKMxoSQnNCaS4p1kqLFxtzbJdJWqqZiBjQIGHICQ1z0D4sx+KOX30ZrJdbK+FbnPyrio4ddDdsOidR7F7HLLFRvj9NP497+c5+dlt+Fr1bsf73BQxzfgDN1Xs6M7BVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39860400002)(136003)(366004)(478600001)(956004)(8676002)(31686004)(66476007)(66556008)(44832011)(2616005)(5660300002)(83380400001)(8936002)(66946007)(38350700002)(53546011)(16526019)(31696002)(26005)(110136005)(38100700002)(86362001)(16576012)(186003)(316002)(4326008)(36756003)(6486002)(6636002)(52116002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bld1eUx3ck4zRUh4V3Z2QnFwbTE3RXE2ODZpaUdER2djV2VDSzIxVkxlNVBm?=
 =?utf-8?B?MnRBSDhKMGtnbDlmdXo3RUV2bXp2YVlscVkrVitRSmkrSGoyRzM1b1MvV0ZK?=
 =?utf-8?B?dnBUOGh0RTN6VTArQmZJUTJOcHBtS2U5aEpXN2F4WmhBZWd3L0VvSDlORGUr?=
 =?utf-8?B?d3VJWTJ4YmI1a3BiTi9YdXpyYlUvcmI0L1RzRDlveVBFckRxc3dYK3JhRkRR?=
 =?utf-8?B?dXFrc1crUXREeTYyWmRMWm5xVTBzZWlGTkNUUUJ4T1VndmsyR3dVVjQxM2x5?=
 =?utf-8?B?Q1ZRZzFaR1N0L2JKY2N3OWpZbXBVZkNHZXRxZUI3RW15eGJlLzB4MXlGZ21M?=
 =?utf-8?B?M1dNWWo1Y0oxcFI1ZTlKNVVvRldkZ3U0ZVVjTjU5cTFEbk9mVGpFLzU1aFVK?=
 =?utf-8?B?OVhHTjA5MHgzUzlwaGZIcTV3c2hyUGZtdVZLY2NWRVhVVHB5UHlMRW1uUEZZ?=
 =?utf-8?B?Z01yZXBESEsvdnRRMnpiU3BvNDZaQ1lITUxaWjVOcElWcHZTVVp0QSs3MWZo?=
 =?utf-8?B?YW4yTHUyRnJEZnN3TWMwSGd0L2lJSHUyQ1VSSlA5L1VHUmFJd01tZi9kNGs3?=
 =?utf-8?B?TlRIUGNPVXRrcFprRzA2WENpQ3VKbXFtbTc0ZlMrQjVlOWVSd3pPbC9TZG9n?=
 =?utf-8?B?QXY0b0lFRVFFeTB2SXpGR29PbFUwN0tvUnpPWDdyai9qRUlQUWVheFlIUStU?=
 =?utf-8?B?WWtzQ3YxV1g4aUFTU0ZkaUc5d0NhRHA0TTNEeGJHZkV6MVFvN2M5TTZqbjEz?=
 =?utf-8?B?UjA1UUd5emVzYm0wREVxUDdMWXZOQjZQbUp3Y1dTSkVPTjN2UXN1amVnbEU5?=
 =?utf-8?B?MlhaT04xUFR1ODJQSXBHNFV4RkR2MzZER1Nrb1RxMDIyUk9uWUZDNDNxdTNw?=
 =?utf-8?B?NklpOVdSWkh0SzlrL2d2UTlGaWY1OFU3MzZ6ekxvOHBmN0tFK1E5YTRnZ0tt?=
 =?utf-8?B?SjBJY2RxTS8zbnZVMTVZaFRRK0pQUFN3eW5OWTVuS0JCYUx6Szhrd3FDeXNT?=
 =?utf-8?B?ajdRWWxtTVRVditPK3BuaWZFcGFQeFpJV2NPMnYwUjNLWjFOZStDR1JpU1Ju?=
 =?utf-8?B?bGdkMnlJVVdNL0NXUkVVQUthd0pSZTI0cU96ZzhBck1RR1FwMzJMK3dKbUhV?=
 =?utf-8?B?Y1NiWm4veXVaUWE4eVQxSXJOb1JTZlhyS1ArUGRGU2MzaG8raGI5WWVrMW4y?=
 =?utf-8?B?RWJzNm9kcXMvSU8xVk9QUS9tdVA3L1RFRXl1enphZ3BvaEQzYVFxY2JVSTkx?=
 =?utf-8?B?RUQwWk81SUVneWkvRGxEeC9RSjloZURTck03Z1hmZzVnbHc2YktXa09xS0h4?=
 =?utf-8?B?NjZ2TnlWMkVJdWh4MEw5emN0Y3lWamRWQUkzZnB5Qkw5RDIrYXNKdjE4Yk5R?=
 =?utf-8?B?T0hpR3RJUThPeVhjSzZaRFNWWE4zck56RXBsbmlNT1BUSW12V2UxcURsS0RZ?=
 =?utf-8?B?UUxSaGdiRGFuSzFiVUJkOUliaDBtS2xuY1h2T1ltV1RWOFFPYTluWnZ1eWZx?=
 =?utf-8?B?ZURWVU1EVkwzeEdvRG1VaWFzWHBNaFdLODJsbk51TnoxNVI0TXZZL0lDdDJP?=
 =?utf-8?B?TUZWMWU0dmtzekZONUg3alR6YkRlL2tWWGszd1dhcmRYTDUwdit5ZFZuTFRK?=
 =?utf-8?B?WFZXRG1ELzQvMUR2cmZkZHExQkZoeThXNzc4dDNwck9kd2tDQUVUalVHbUdY?=
 =?utf-8?B?ZlUwWlRPVEdUL0JyL1pNOXhUelJuRHg4ZDRWVSt1UUdqTjE1RzQ5OEhua3hx?=
 =?utf-8?Q?TdG8YPSNCwyZyLuFCv2CFP0/9riI1uuZfPJep/z?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6adba7d-8342-4674-2fac-08d92c73da70
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 00:57:14.8467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FgBaymUCSy2Yu0S8G9enXz8a5UDL9ULV6nNaTJOWV4YS6Yr4iv2kLutJEnGPz/piCJvWiQEuky5YRdOsc92dfUt5QIuCcibUSx7HPjTW+xY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4800
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10011 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110003
X-Proofpoint-GUID: i6Lwghd4qSQUfVBl7zsmy3TDHcfMbsXm
X-Proofpoint-ORIG-GUID: i6Lwghd4qSQUfVBl7zsmy3TDHcfMbsXm
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10011 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106110003
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/10/21 3:37 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Dan Carpenter's static checker reported:
> 
> The patch 7b13c5155182: "xfs: use perag for ialloc btree cursors"
> from Jun 2, 2021, leads to the following Smatch complaint:
> 
>      fs/xfs/libxfs/xfs_ialloc.c:2403 xfs_imap()
>      error: we previously assumed 'pag' could be null (see line 2294)
> 
> And it's right. Fix it.
> 
> Fixes: 7b13c5155182 ("xfs: use perag for ialloc btree cursors")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
Looks ok
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_ialloc.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 654a8d9681e1..57d9cb632983 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2398,7 +2398,8 @@ xfs_imap(
>   	}
>   	error = 0;
>   out_drop:
> -	xfs_perag_put(pag);
> +	if (pag)
> +		xfs_perag_put(pag);
>   	return error;
>   }
>   
> 
