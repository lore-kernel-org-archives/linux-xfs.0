Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ABB4C433DB
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A60AE64EDB
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Feb 2021 00:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhB0A5l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 19:57:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46066 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhB0A5j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Feb 2021 19:57:39 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0iuJG120122;
        Sat, 27 Feb 2021 00:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KegxbkCHnFy/sfLO1wxAspaQ8hDPDDpLa/nTakMHPRk=;
 b=goRkl6f8n7zz1z/B8pIG5VGnMHkpeiJ/Cic1mV4J6WCfP+MixLucAQsPYc7IbHlnMyP1
 iP56xvke8I3tg0dTLD3d+AUvFFEXgDtQI4vLJrHvpZr+cotLVHUNRkomB6Q3k80Ei35U
 nPMS2uR9mjTXgEXDcA4ZJV7fjd/pHBZhFxVL/4hRN9xXx/9WhrjSjq1Sm6NvE4+p/0tT
 tEtTGBNfY7Nk43xpbUGqu+1AkGPCX5FtNzZBIxgjLyJGQw9N6HLnUQXenzuuMZ1DRlWx
 1Zjy1H7j+D/8pBJdYUeWLKuDp4cyCMu8tooYaArDL2Q+iyXAvgJXOCVtCnvHy/xqip3z Lw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36xqkfb6ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:56:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11R0isX9174921;
        Sat, 27 Feb 2021 00:56:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3030.oracle.com with ESMTP id 36yb6rs2fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Feb 2021 00:56:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U37mzWVjoVK+HUSV8ujJoUOMItgD/frelm3e+U2P7D+rDxdmww7l5TFwwKuu+Kqg7vc5R7Af6kD4qAFpy7QBLJxVyXv8XC73S9xWHIx/K1T6HDlXkbZgzP8sFNPAemtieZBOEv21+iLCac5R8GGR6dG8YhSU4Vt8bYqGqx8IJsA96F5g9Q60vERnCdCKFiQC8YXrNGW3LPN5RzrIyPEcF6UKxuOdxN4/8xtRq4F5/2JdRvnU9P7iyH+psuf+w21eWzGAmvvt0nBf9WsRyoi5Q8oCVxwo2dxwBUbzO+tzvkZRCk1LKcmpHGh2/7uytgP9ffxecxCYM/UDPAowi3YEcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KegxbkCHnFy/sfLO1wxAspaQ8hDPDDpLa/nTakMHPRk=;
 b=P8uqATR6vZe5mekznn6nbZJh0tg8owvRBZVwijqFn6erp7s0E64yfntyerwLyyex22HMExFxKtY2/vCdM5vjQM6nNfrevp/8hTeGx+XUJ+qJmbUV4BOvgEW5RGqsuxx1z0a2gcaCg6/qFB/7ME5uFak9YrpaxcKSGrVB9xnP//vFM9p5Stm2CUlwPFkde8QqWFpGe2aiiHJrtEdoZQgqU3hAsBKIwrTe/H+bVm5ClOHfRxC6oXtIW6Ndf5DFMe7gcDaD4SpG1X0g/ZOqBbrx+R2+9ZIJ5PQtP5+w0IuqvrZ1lp4omDa66cgG08Ah0/sBt+Jcg5a4vG4SmaXJtjOJ7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KegxbkCHnFy/sfLO1wxAspaQ8hDPDDpLa/nTakMHPRk=;
 b=d22pl0Qz0aRzo2NiJknmEKLx6EL6x7orBKFo4Ku3DKvrICOIZKeRjoBBF57WQpibfOnHDkaqd2NMdM4N/+1qc8R4RPXJDVT9RpdQT14RWjggMPQFnk1NslRUzn3mPqxYhhcvX9IeijMbLc/kCNd19BRdDe6RrY069PbeHwejGPU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB3858.namprd10.prod.outlook.com (2603:10b6:a03:1b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Sat, 27 Feb
 2021 00:56:53 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.020; Sat, 27 Feb 2021
 00:56:53 +0000
Subject: Re: [PATCH v15 17/22] xfs: Skip flip flags for delayed attrs
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-18-allison.henderson@oracle.com>
 <20210226050241.GZ7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <1a02f8a4-f6fd-de0e-c044-367f819abcce@oracle.com>
Date:   Fri, 26 Feb 2021 17:56:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210226050241.GZ7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR05CA0209.namprd05.prod.outlook.com
 (2603:10b6:a03:330::34) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR05CA0209.namprd05.prod.outlook.com (2603:10b6:a03:330::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Sat, 27 Feb 2021 00:56:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebb66e9c-9811-4c5b-5720-08d8daba92c2
X-MS-TrafficTypeDiagnostic: BY5PR10MB3858:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3858C738F71EF2358AC70C48959C9@BY5PR10MB3858.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lvb+pEv2F+TxSz99D6icg9nh7k/GAS8A08PZSOM+B9b/idOSVjhL3A1Z/clSQVeNCMIZdIHp1Gm6umHEznYONnC0d8S695FctsxLoqKS1Wxs0dOnmiqEb4tvypjHrW6O2kpU/CVBOJV1CWsUlQqrqFPnQgDAKLcFbie8rL1FrNdTLvpA5uTJqVOBeFF/evJ4HUbb/Jr+CYj0qe25n6F6KSPCW6g0Qug6IVqYD0tweQ0JnyfXKQQoKM78coDBJ945wcgufB4T9QEZ8hrDk5tN4f22JdRCFJcwJ/sWXzUOxIelRCfuIRxIHokjjU0sCFcPQ5et5V0mZFIKPTnrkOC1aAASmhSDZipte26NNW0/kmiP4d8O7GonB52WZIU39vb2x4+ESWpScC0NzyP4X5KI3HiPSv4W6swQlbzvkrMy3cJshuPoQWSGH+Wqi0O411Q9FPRlwdsh2XK/N37oGsgfPNBBSWdNfbsg0tHmxZfCWAr9k58tcPzFvb1du7HYMyFsL1PKUOeYx8nqLhVtxjjIwBdSoWC09G2Dgix870ojiOKQ+39CeN2Qtt+L2EpKAdqr7NHmfZ46Wht1ePwjKqtzt7qz7PVT+krAqIIkz+lDCqw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(52116002)(478600001)(6916009)(86362001)(4326008)(2906002)(31696002)(83380400001)(5660300002)(6486002)(316002)(66556008)(66476007)(36756003)(16576012)(186003)(8676002)(26005)(16526019)(956004)(2616005)(44832011)(31686004)(53546011)(8936002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?emdOMWhDeXIyZUlsUXpGMFUrVXRkM2M3anJndm5WT2lnMkI5TGxBVkd4MlRR?=
 =?utf-8?B?eFY1dVJVeFE5STUrMWdpZytmVENnaUFaVEZKZnZaVGEvMmNYdEVWVTEwNnQw?=
 =?utf-8?B?aXBHM0xqWUJjMUlPbnc0NVhIMXdLOEVSZGFhRkdYdTdvRUxSdk9KWmJnNXBM?=
 =?utf-8?B?Skx3SlVvZVF3aSs3aHdxNDN0aVljaDNGQ2xLOUdOKzh6RHcvc0MzcW93alJD?=
 =?utf-8?B?Z1BZVEpsbHEyOS9pOWI2cEFnWHQ3ODcwVkJzNkFjdjI1akcxLzRoV1ZBL0FX?=
 =?utf-8?B?RzZsUk1aZmgrZ0FFbklwbHVBbDJOdU9uT3pGZW5aeXNlRlp1WVlROTJQM0ZE?=
 =?utf-8?B?d1lycmU2dmgydlRBM2dvT0NVU284TXF1T1Q2RTEydmNzdmQzTUUzTkt6bVBN?=
 =?utf-8?B?Y3RpT1M4bTZLTzIvZDdSS3BRVlhLRFF6QlpJcGlvOThhT2dVbjRCb2NsVjU3?=
 =?utf-8?B?MTcrWnBzQlJiWHlNNmh3UDFtb1V0NkNTSElidkxYZW1pSXdkbUQ2MHdYWjNQ?=
 =?utf-8?B?Wi9XMkpqK2dBNGtrWUJZZlg3OXJWaVE5dythQnFucTJRaWZtN1gvSy9PeE4z?=
 =?utf-8?B?VE5kUHRuSUtzK28wamJQTWRhc0dSdTFUa3R5SGhsZ2pGemROSFR2Skw2N0pm?=
 =?utf-8?B?QzVOeXJ3RENHRUcwcmNRZFBPbDVGa1NkK0VrWE1ZM0RxR3ZTeHFrZlFmT29O?=
 =?utf-8?B?aDlWUVA5WUJGdnprYnM0aXYzRkpvWktsZXdsazhjRmRXdGJCV2pTanBGaEhY?=
 =?utf-8?B?OUdWcWdMVHpUT3pNTmZQWWYweW1MdzRmRVJmeERsYzNqdmJKSll5dlZlREJs?=
 =?utf-8?B?dFVFWXZVTktsbG9RZC9jVDU2dWEweDYyYlIrOEtCMjFMSUdSZTA5aHJid2I3?=
 =?utf-8?B?Ym5ZQ1BsT21CWHNzZTFHU2p2ay9SbTUxQ2FUaHNyMWkwMHQ5VzhVWVlQMDQ4?=
 =?utf-8?B?ekhyWVoxY1FXd29XcWFzWEp4ZzJNd3hKeEp6dzBCYWRVN2F2QVpKc1JtOWtL?=
 =?utf-8?B?a2JNbXFCVUdYRHJWTW1zWStOU3VSeWZsYk42WkkvNGJDTmdyajZNMklnR1lO?=
 =?utf-8?B?bVZiT25lTVNRb3JsdVdCbHZsZXFXZ3RNbitYYzVkcG1vdU9iYjR0STV1aFdo?=
 =?utf-8?B?SDZIam5mSnlBR0Izb0pnbEhuU2F2TWx5UEZIa3p6aE04bnJZNStFODhNS3R5?=
 =?utf-8?B?cUphRWZEbUZaZDN0VFhLN2dGN3RsREI4VHlCdmpRaVJyOHRJaUwzUjVvcGtN?=
 =?utf-8?B?QllobjFwUmhyQ2tKelBYMERac1JqeFIrR0hKeXlPbWdYOVN5WGJieVNxTU9Y?=
 =?utf-8?B?bW9qYTV4dW82M09tOXdKYlN1V1JDM24yTkZwVHdEWVpwUVlGNkswVFR0b3lm?=
 =?utf-8?B?Nm9jL2t5M3duTndSMnFsUi9HcFhoYmw1dUprQW42SXd3K3VFeWlDeG54UGNF?=
 =?utf-8?B?aG9JeEJMSktNMlhJZEJ5ZWNXZUhWbW45enBPVUoxaHRqR3lQTWc0alRNVzJQ?=
 =?utf-8?B?REZ4eW1EYlFkTUZaSFVZak1wZ1g3ZXJNU0JWa1BXMTN3MDlxN09zTjJpZFRv?=
 =?utf-8?B?V0FQanBvN2t6RXVneFBrNDVMZ0JqbGFvODdDTEdURVFXMzUxUmVOVXEyTkI2?=
 =?utf-8?B?WFVrbWxnVnJBa0FEUHZlc0FTMjFlQ2ZJNTRNRDF5eTZ0QXZJdU9jM1hRZTlE?=
 =?utf-8?B?MzNPNXRIOGRjcUZ4Zk1vZVlwcWVmMm5MRFVMckRUb2hVeWdPWlJYMFlxVEZJ?=
 =?utf-8?Q?DjwgIIThiJ3OLwHWw/CFSnyO9I7By5y7NCDrcZb?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb66e9c-9811-4c5b-5720-08d8daba92c2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2021 00:56:53.4644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0KjMGLa8lwGlELL83sHu+3v8sgvT4BFHKB5ZKKLzMBt/DfKuipfvID04Rgb0R6RxfIZCuDe9LxKZQPnfg49RPfT4HHMPD1pO/RTHD4FPeWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3858
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102270001
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102270001
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/25/21 10:02 PM, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 09:53:43AM -0700, Allison Henderson wrote:
>> This is a clean up patch that skips the flip flag logic for delayed attr
>> renames.  Since the log replay keeps the inode locked, we do not need to
>> worry about race windows with attr lookups.  So we can skip over
>> flipping the flag and the extra transaction roll for it
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> I wonder, have you done much performance analysis of the old vs. new
> xattr code paths?  Does skipping the extra step + roll make attr
> operations faster?
I dont have any analysis right now, but maybe I could put some together. 
  I'm sure there's some impact, but not sure how much.  If it does, I 
suspect it will become of more interest when we bring in pptrs since the 
code path with be in heavier use then.

> 
> This looks pretty straightforward though:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Thank you!

Allison

> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 51 +++++++++++++++++++++++++------------------
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  3 ++-
>>   2 files changed, 32 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index e4c1b4b..666cc69 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -337,6 +337,7 @@ xfs_attr_set_iter(
>>   	struct xfs_da_state		*state = NULL;
>>   	int				forkoff, error = 0;
>>   	int				retval = 0;
>> +	struct xfs_mount		*mp = args->dp->i_mount;
>>   
>>   	/* State machine switch */
>>   	switch (dac->dela_state) {
>> @@ -470,16 +471,21 @@ xfs_attr_set_iter(
>>   		 * "old" attr and clear the incomplete flag on the "new" attr.
>>   		 */
>>   
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			return error;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series.
>> -		 */
>> -		dac->dela_state = XFS_DAS_FLIP_LFLAG;
>> -		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>> -		return -EAGAIN;
>> +		if (!xfs_hasdelattr(mp)) {
>> +			error = xfs_attr3_leaf_flipflags(args);
>> +			if (error)
>> +				return error;
>> +			/*
>> +			 * Commit the flag value change and start the next trans
>> +			 * in series.
>> +			 */
>> +			dac->dela_state = XFS_DAS_FLIP_LFLAG;
>> +			trace_xfs_attr_set_iter_return(dac->dela_state,
>> +						       args->dp);
>> +			return -EAGAIN;
>> +		}
>> +
>> +		/* fallthrough */
>>   	case XFS_DAS_FLIP_LFLAG:
>>   		/*
>>   		 * Dismantle the "old" attribute/value pair by removing a
>> @@ -588,17 +594,21 @@ xfs_attr_set_iter(
>>   		 * In a separate transaction, set the incomplete flag on the
>>   		 * "old" attr and clear the incomplete flag on the "new" attr.
>>   		 */
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			goto out;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series
>> -		 */
>> -		dac->dela_state = XFS_DAS_FLIP_NFLAG;
>> -		trace_xfs_attr_set_iter_return(dac->dela_state, args->dp);
>> -		return -EAGAIN;
>> +		if (!xfs_hasdelattr(mp)) {
>> +			error = xfs_attr3_leaf_flipflags(args);
>> +			if (error)
>> +				goto out;
>> +			/*
>> +			 * Commit the flag value change and start the next trans
>> +			 * in series
>> +			 */
>> +			dac->dela_state = XFS_DAS_FLIP_NFLAG;
>> +			trace_xfs_attr_set_iter_return(dac->dela_state,
>> +						       args->dp);
>> +			return -EAGAIN;
>> +		}
>>   
>> +		/* fallthrough */
>>   	case XFS_DAS_FLIP_NFLAG:
>>   		/*
>>   		 * Dismantle the "old" attribute/value pair by removing a
>> @@ -1277,7 +1287,6 @@ int xfs_attr_node_addname_work(
>>   	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>>   	 * flag means that we will find the "old" attr, not the "new" one.
>>   	 */
>> -	args->attr_filter |= XFS_ATTR_INCOMPLETE;
>>   	state = xfs_da_state_alloc(args);
>>   	state->inleaf = 0;
>>   	error = xfs_da3_node_lookup_int(state, &retval);
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index 3780141..ec707bd 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -1486,7 +1486,8 @@ xfs_attr3_leaf_add_work(
>>   	if (tmp)
>>   		entry->flags |= XFS_ATTR_LOCAL;
>>   	if (args->op_flags & XFS_DA_OP_RENAME) {
>> -		entry->flags |= XFS_ATTR_INCOMPLETE;
>> +		if (!xfs_hasdelattr(mp))
>> +			entry->flags |= XFS_ATTR_INCOMPLETE;
>>   		if ((args->blkno2 == args->blkno) &&
>>   		    (args->index2 <= args->index)) {
>>   			args->index2++;
>> -- 
>> 2.7.4
>>
