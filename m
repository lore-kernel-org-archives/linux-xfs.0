Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DC0C00140
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Aug 2022 18:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbiHXSra (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Aug 2022 14:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiHXSrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Aug 2022 14:47:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2D97AC2E
        for <linux-xfs@vger.kernel.org>; Wed, 24 Aug 2022 11:47:23 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27OI41SD009399;
        Wed, 24 Aug 2022 18:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=583hNH2Myf/UxLsXTmRbGIyJBIBqYWgqvZXTBtP9QlU=;
 b=xxMod4kBuiBM6ixL7ei7uAK9WYK7QdagFAIwBNI9WoXCvHF46cTAqFbaH9o8pN6gbI55
 B0dDkcRK2zfQNhoUb7I+uhcFUN6/EVj8jmkbyl4YytE/Tefqv2xXHVw7bLCTTLi6Eplt
 fszyDunHfzNt2dUZcWWR2E1CcsLX1Ytas9/nWP69qeUwnMiRdfYlGEq2kjQT7AhFcELa
 qAOp1PIIOk54crp6xdgxVds95YllQfTrkxtJi73KJ22jA20hV3nZJijcNn8yYIdS/3Hg
 KS/6IcXwoQL7R/VcR/1HbV0Wc9x/1r8EAOn3Dg5YPgmoUz/iLBiIunzZqrZ4HZHl+yem jw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j5aww25d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 18:47:13 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27OH59XR028501;
        Wed, 24 Aug 2022 18:47:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n4kd62q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 18:47:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpmCbsr3nQcKSnXXBJqdM1sA5VL7ysgED7Y9BHR5AWdsoAEcP0HcpZLXNuaqgec+oAhXk1tkN7j64c9bz06wNU7IcF+PUzZNfC+xPtPs1+qT/ewew1u+zdGYUs1VAPHoN3PJcaPkE27Pr0rpwbV/61ibdWW9Su+bByP3Gwx4Bp/S3ulsAS/rtpZNfNd1MB7oN1LexcEiF1FyYW2W2X+xA484Tl0AN9DlaEbvR5VN2yYKS+ik/8AMrU748hCScF1m1wvKtxIQmRgN2BiEvyfJdYk2lBLW39vi0LPGap7dfumMu8980FJvjKpxW6ke/kdYTGF4uztFYDHZ0QsxqCYTJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=583hNH2Myf/UxLsXTmRbGIyJBIBqYWgqvZXTBtP9QlU=;
 b=ZzE6raalSRL6y6C5N7/ZD7ZshhOt67fHa9FQP2xr7rG7O3Bb8RB93+Lnpwx6Cy3wqcE0ysz6xd5LMxlzGPYEZ3B4EMJauUQAnvsK9GqOtv4jajG2XOl/84t6OKdqZ9IaiWjxfTWexSumG6N1YEldRbVYkOK2DBDJT6DvyP5hthRWdpceJTnUH+Dx/btBmsvVsQfzPzrWl1bxp4NwSweTSlBs3UhkQ3Hez2znQLh4qinoGTDZNlGBNJVCuOI7H0NfHIGZCMhKjqvwH0TXu7AT/or17NURxlF3pzByyA3gbnKoYky/RV1ttTxj385JNzZg2Hmqf/aVdtLphIOLOWcImg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=583hNH2Myf/UxLsXTmRbGIyJBIBqYWgqvZXTBtP9QlU=;
 b=XbVXpzBZ1IVk2YWayWDebDDzhYriG3c5nAijC6AvFlfKhh3JZc0noHXNUsacYp0NVREswh2EGSdNTaEaFwNYrrj7VkE2m1Zo8zaYKOz0GG7iSAYZGCaFiN8Taaa2CobgfvZEZ4ngB54mglv3F0DgmyVIYxERnMLtxwf8A/oB9D0=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by BYAPR10MB3126.namprd10.prod.outlook.com (2603:10b6:a03:15c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Wed, 24 Aug
 2022 18:47:10 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::e87f:b754:2666:d1c8]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::e87f:b754:2666:d1c8%9]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 18:47:10 +0000
Message-ID: <62dbf59f41634e2c75537c3f499d2aa98c64f1b7.camel@oracle.com>
Subject: Re: [PATCH RESEND v2 01/18] xfs: Fix multi-transaction larp replay
From:   Alli <allison.henderson@oracle.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Wed, 24 Aug 2022 11:47:07 -0700
In-Reply-To: <YwTtMqOCtkxyox3x@magnolia>
References: <20220804194013.99237-2-allison.henderson@oracle.com>
         <YvKQ5+XotiXFDpTA@magnolia> <20220810015809.GK3600936@dread.disaster.area>
         <373809e97f15e14d181fea6e170bfd8e37a9c9e4.camel@oracle.com>
         <20220810061258.GL3600936@dread.disaster.area>
         <f85ae9d8425aaff455301b28af32ba0d813f733b.camel@oracle.com>
         <20220816005438.GT3600936@dread.disaster.area> <YvsmAgj348tlKfCL@magnolia>
         <9acef43634b41baba8711dc47aaa7bd0cf46874d.camel@oracle.com>
         <82cc6ff775832d34f32cdbfe9bd125487ec22226.camel@oracle.com>
         <YwTtMqOCtkxyox3x@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::34) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1b216d3-ce14-4d9b-e976-08da86010d22
X-MS-TrafficTypeDiagnostic: BYAPR10MB3126:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I6EgGU76pwuQjjEGjYA0xCO9py407NVVIk1HJO/oymCx7pbu6Rkme1bREuiGRZ0zNjitRL5mruZMpuptdcFiooLV/6NcL86VpOGmaCv4+gkeho7Q+HXo3hi4GUhnyhcZTqoBb/UvFa67GA8uWde5Q1T67lkZ5R1uBShBGZyVUYIgrpD/utWbiMj8m2S7j9pCXBWJc4K/Lc4X2uYjKZfdbPdkxcFcf+0nseFN5l2ee1lAIIYpYVZtFMJChvBb5BZMNoaPzGX56VqBLKIKQs5w2Smf2XtYI0xl1Mh4W3EJ4CJXdHxqaM2imUMVAmhUUjVdyZmKMwcggoB8skWZksL1QzLMr4jN0abUxS/r/9UDyFL6r1CNK+1pisuLhldihe8vi9VVhSeWdXzqlB00J7p10Y72hzbpL4umaVhECtgKiJ4RXJzmtSqe+LD+pNYuodG9duU0mOZ+KXlvytAFpvzfJFouqSFmRHLJu3GK6/uXyzQg8dwoICfXRMBnIrb0fc3Zj6+i2lIVmpNp8Mr40WFT/nb2xFS5WMtt+87lv5rk0KdZgjwWRQKNw0FCWPddAaLABwT/fZdV+SFiro4KMaA0blRALvTzA4AFd29r4W1iqmOW4+jcjBISaW+8zdlWt6BWR3kflb3nPr9yYl5t+FGhSziQiy/xMwJFKg8b2Id7JdvF3mILOvyilUNW1E5k5R0l2GeNZFAtbh2xtjOGuBfL2HdWcMT0hqP9qhhvpSoBC5T9txdRpyA5t1Y48vv/YaQi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(346002)(376002)(366004)(136003)(86362001)(38100700002)(38350700002)(8936002)(2906002)(41300700001)(8676002)(6916009)(66476007)(66556008)(66946007)(316002)(30864003)(6486002)(2616005)(186003)(83380400001)(5660300002)(478600001)(6506007)(6512007)(26005)(6666004)(52116002)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUsvTTZMTnIweG81ekp3Q21CNHhPOVdBTzQrUlBvdVlPaktnUFVMWFFyRHJN?=
 =?utf-8?B?TThsOWNXS1E3U2JkUlNYaEJiY1RKN2dMbmg1UnFNVlRVK0NmSnVyczNJTkNK?=
 =?utf-8?B?VHk2SDR1d0YyYTJqU1RDaW1pWU9lek1tVUZHd0Ntb1l6TjkvSFRPNXdmcUxS?=
 =?utf-8?B?OGZlSmo3cm56RWxaVjNyQTlNRmJwOCtyVU5Ra1hpclRXaUU5V29kanNtbVMr?=
 =?utf-8?B?cjFNazFhV2d1SW5qUStGVTIrcnczMEtXU2NaMmhEODdqclhud3ZRNElhZzVt?=
 =?utf-8?B?UVRkSkNCTXd1allSTlRvd2lxa1QxT01VWW1JeC82aXI5bUtWM1U4Z01wUEpK?=
 =?utf-8?B?Y0t1eTVpaTUrOENpbFUwQVYwUXRaUkIrbjJvTnI5QWtraHZMakYweWhEWXk3?=
 =?utf-8?B?aUF6UitsWXJuQzB5YjNRanR6WjNJZ2psZEJIMDFoMzB5TkdFbEE5YmVMQkhi?=
 =?utf-8?B?ZGxiTWxaamtyZjl3SVVrbWJ4UUtXR2FqMGlwSHE5UUZqUXZ3NTk4Mmc5QzBj?=
 =?utf-8?B?NXZFYVpaSUNWT1hNRDBoMFJEa1Y3aDdpSUtINUtKU092cTN0Um5tRkNlQk1W?=
 =?utf-8?B?SCs2K2JPYW44VlVqTnMyT0FNREJ3UGZadUEyajh4aHo3TkJpa0xiZjVreWxy?=
 =?utf-8?B?YVpoUUNTcTErenlzeWZaWml4RXJFUHduMnlUcDRnd0k1N0t6YVMzTEhQQ1pW?=
 =?utf-8?B?RTdVeTJJYVpsbFVZQWYwYS84ZzFpWEY3OU0xclQ2Qk1UT2IzLy9tZjlZT0ZL?=
 =?utf-8?B?ZjZ4R1NXUVZWWG0zZy9Nbld3cGlYV0w4TkFFdnk3SlRlc29hSDltQzR2S3Nk?=
 =?utf-8?B?ME80TDFVWlNRaGUxallUYmdkUnpNU0YzUW9lTWkvcDBBMmwxYzhFeHNtdnNr?=
 =?utf-8?B?K0dDYi90V1BOVWI1V0VodlZlMkpJdEtpZGRTaDNQay9lSUVWcG1kdXk1N0Ew?=
 =?utf-8?B?ajlENktOeC9xdlcxcjFyeWQzMTgvUWhuRjhQRTZWcndzTVFtZ0ZWdDVQM2tZ?=
 =?utf-8?B?b0pLMW9UZ0JBWFNsT0VvUTVpbUJDc0NZUXpoR2lLMmZsa2ozNko4TDZnb3Zp?=
 =?utf-8?B?NU03M1grN1l1M3B0M2FEM0lPSXNjQS9IOE56b3ltZmVhL09MR3FiQ0tGYmVr?=
 =?utf-8?B?Nk1pRUJOT3JZOCszNzRNMXErUXpQUllDaDJpaHJKbGJnbmlodkVxajZTbkJj?=
 =?utf-8?B?QUZnYWc5aE9XYld0Z1Y4K2ZvaWdnNzFNZTJJTHpQZkZnMVZ1YVdkN0tmdDd3?=
 =?utf-8?B?RGdxMStCWm9ITy8rSXNYWHdseHRkMXBoaUxIdFkvWkZnUURPci9qcW94L2s3?=
 =?utf-8?B?L21EbTlvMFhsOVJaeGhLZ1hFOEM3R2Y3UW1WdWE2bTRlU040NngyakdMamx1?=
 =?utf-8?B?TVgyOXJ6c2FCVlNHanBRMVBmVGdTSHVJVG9KOGhtT0ZJcVh4akl1K1I1MEpZ?=
 =?utf-8?B?Tmhsek9NaHhhZWR2bWs1Yk5DdFJZaUFoU1lWSzJYMk9RZFV5OWZHTXRNV09I?=
 =?utf-8?B?ZFVZOHhDK1ltdFJkWjQ4dy9UU2tyZThtd1J5bWV0S2ZHVWdld3NUMWUxWTdw?=
 =?utf-8?B?LzBhUUhjTFo2TFVieUdFcDJnL05saExWUlNGL3R3d2swZklBNERVaXd0WkZq?=
 =?utf-8?B?Rk84QUlGeDcwTkFvK0JlaWtnUmhhSDhUMFhlR3RCSDNETkkwNVY2QVV4L3A5?=
 =?utf-8?B?SEQ4Q0JxUWpMdGFOUmhINTZMTG95VDNwak5ubzhlNXZYYllSRUoyZ1hwQUhY?=
 =?utf-8?B?OW1xRzJ3T0NQbWJ5V2l5WjJQZWIzdE1PMjkrNHRRU2lMbW1vS01meVNiUjBl?=
 =?utf-8?B?SC82bXYxZ296MUxlSzNXTkFMdkdib2thWERzRDJEaTNpdDFvUTlYL3pGNkcr?=
 =?utf-8?B?b1JqQ0RnWkxDWCtSeUwzelNmYUR3RFdoaWJ0bngrVkRveXdVUjBNT3dHNUl3?=
 =?utf-8?B?NTlYZEE1MFhqdTZ6Z2xIeHQ0UEpjenBKRnJWMWJkbW9KbWlmc0xzTk9tdzNV?=
 =?utf-8?B?RU9BZDkwSWxrMkVYbFRtSFNwbU9xc24ycngrZzlyZGl3cFFoNXZGL2VFSWdP?=
 =?utf-8?B?akZvWFBpZmhUOEFZTkVEQkx0RzBMQjltdW1zL3JyQTllNmtCeEhsVHVhaGRW?=
 =?utf-8?B?c2g3L0JjS2ZWS2lLb3V3OFlSRDdiUHNhRnpWcUlsVUlkemViQ1RPVjk2cHN2?=
 =?utf-8?B?SEE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b216d3-ce14-4d9b-e976-08da86010d22
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 18:47:10.2327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GawoHhtGnGaAaCDsZhw8Zlxc85NkSHIYEo2bPFdnsiu8OLSR5F7YWCcL/oRPF1Xupp6Uh+0Az0OmImJLEZOi8iz4TZfvD1ZDfLhCV7wbwqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3126
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_11,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=545 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208240069
X-Proofpoint-GUID: zpmrfmXU7Y0Hj_57joZ4CAEEGpykJl3u
X-Proofpoint-ORIG-GUID: zpmrfmXU7Y0Hj_57joZ4CAEEGpykJl3u
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2022-08-23 at 08:07 -0700, Darrick J. Wong wrote:
> On Thu, Aug 18, 2022 at 06:05:54PM -0700, Alli wrote:
> > On Tue, 2022-08-16 at 13:41 -0700, Alli wrote:
> > > On Mon, 2022-08-15 at 22:07 -0700, Darrick J. Wong wrote:
> > > > On Tue, Aug 16, 2022 at 10:54:38AM +1000, Dave Chinner wrote:
> > > > > On Thu, Aug 11, 2022 at 06:55:16PM -0700, Alli wrote:
> > > > > > On Wed, 2022-08-10 at 16:12 +1000, Dave Chinner wrote:
> > > > > > > On Tue, Aug 09, 2022 at 10:01:49PM -0700, Alli wrote:
> > > > > > > > On Wed, 2022-08-10 at 11:58 +1000, Dave Chinner wrote:
> > > > > > > > > On Tue, Aug 09, 2022 at 09:52:55AM -0700, Darrick J.
> > > > > > > > > Wong
> > > > > > > > > wrote:
> > > > > > > > > > On Thu, Aug 04, 2022 at 12:39:56PM -0700, Allison
> > > > > > > > > > Henderson
> > > > > > > > > > wrote:
> > > > > > > > > > > Recent parent pointer testing has exposed a bug
> > > > > > > > > > > in
> > > > > > > > > > > the
> > > > > > > > > > > underlying
> > > > > > > > > > > attr replay.  A multi transaction replay
> > > > > > > > > > > currently
> > > > > > > > > > > performs a
> > > > > > > > > > > single step of the replay, then deferrs the rest
> > > > > > > > > > > if
> > > > > > > > > > > there is
> > > > > > > > > > > more
> > > > > > > > > > > to do.
> > > > > > > > > 
> > > > > > > > > Yup.
> > > > > > > > > 
> > > > > > > > > > > This causes race conditions with other attr
> > > > > > > > > > > replays
> > > > > > > > > > > that
> > > > > > > > > > > might be recovered before the remaining deferred
> > > > > > > > > > > work
> > > > > > > > > > > has had
> > > > > > > > > > > a
> > > > > > > > > > > chance to finish.
> > > > > > > > > 
> > > > > > > > > What other attr replays are we racing against?  There
> > > > > > > > > can
> > > > > > > > > only be
> > > > > > > > > one incomplete attr item intent/done chain per inode
> > > > > > > > > present in
> > > > > > > > > log
> > > > > > > > > recovery, right?
> > > > > > > > No, a rename queues up a set and remove before
> > > > > > > > committing
> > > > > > > > the
> > > > > > > > transaction.  One for the new parent pointer, and
> > > > > > > > another
> > > > > > > > to
> > > > > > > > remove
> > > > > > > > the
> > > > > > > > old one.
> > > > > > > 
> > > > > > > Ah. That really needs to be described in the commit
> > > > > > > message -
> > > > > > > changing from "single intent chain per object" to
> > > > > > > "multiple
> > > > > > > concurrent independent and unserialised intent chains per
> > > > > > > object" is
> > > > > > > a pretty important design rule change...
> > > > > > > 
> > > > > > > The whole point of intents is to allow complex, multi-
> > > > > > > stage
> > > > > > > operations on a single object to be sequenced in a
> > > > > > > tightly
> > > > > > > controlled manner. They weren't intended to be run as
> > > > > > > concurrent
> > > > > > > lines of modification on single items; if you need to do
> > > > > > > two
> > > > > > > modifications on an object, the intent chain ties the two
> > > > > > > modifications together into a single whole.
> > > > > > > 
> > > > > > > One of the reasons I rewrote the attr state machine for
> > > > > > > LARP
> > > > > > > was to
> > > > > > > enable new multiple attr operation chains to be easily
> > > > > > > build
> > > > > > > from
> > > > > > > the entry points the state machien provides. Parent attr
> > > > > > > rename
> > > > > > > needs a new intent chain to be built, not run multiple
> > > > > > > independent
> > > > > > > intent chains for each modification.
> > > > > > > 
> > > > > > > > It cant be an attr replace because technically the
> > > > > > > > names
> > > > > > > > are
> > > > > > > > different.
> > > > > > > 
> > > > > > > I disagree - we have all the pieces we need in the state
> > > > > > > machine
> > > > > > > already, we just need to define separate attr names for
> > > > > > > the
> > > > > > > remove and insert steps in the attr intent.
> > > > > > > 
> > > > > > > That is, the "replace" operation we execute when an attr
> > > > > > > set
> > > > > > > overwrites the value is "technically" a "replace value"
> > > > > > > operation,
> > > > > > > but we actually implement it as a "replace entire
> > > > > > > attribute"
> > > > > > > operation.
> > > > > > > 
> > > > > > > Without LARP, we do that overwrite in independent steps
> > > > > > > via
> > > > > > > an
> > > > > > > intermediate INCOMPLETE state to allow two xattrs of the
> > > > > > > same
> > > > > > > name
> > > > > > > to exist in the attr tree at the same time. IOWs, the
> > > > > > > attr
> > > > > > > value
> > > > > > > overwrite is effectively a "set-swap-remove" operation on
> > > > > > > two
> > > > > > > entirely independent xattrs, ensuring that if we crash we
> > > > > > > always
> > > > > > > have either the old or new xattr visible.
> > > > > > > 
> > > > > > > With LARP, we can remove the original attr first, thereby
> > > > > > > avoiding
> > > > > > > the need for two versions of the xattr to exist in the
> > > > > > > tree
> > > > > > > in
> > > > > > > the
> > > > > > > first place. However, we have to do these two operations
> > > > > > > as a
> > > > > > > pair
> > > > > > > of linked independent operations. The intent chain
> > > > > > > provides
> > > > > > > the
> > > > > > > linking, and requires us to log the name and the value of
> > > > > > > the
> > > > > > > attr
> > > > > > > that we are overwriting in the intent. Hence we can
> > > > > > > always
> > > > > > > recover
> > > > > > > the modification to completion no matter where in the
> > > > > > > operation
> > > > > > > we
> > > > > > > fail.
> > > > > > > 
> > > > > > > When it comes to a parent attr rename operation, we are
> > > > > > > effectively
> > > > > > > doing two linked operations - remove the old attr, set
> > > > > > > the
> > > > > > > new
> > > > > > > attr
> > > > > > > - on different attributes. Implementation wise, it is
> > > > > > > exactly
> > > > > > > the
> > > > > > > same sequence as a "replace value" operation, except for
> > > > > > > the
> > > > > > > fact
> > > > > > > that the new attr we add has a different name.
> > > > > > > 
> > > > > > > Hence the only real difference between the existing "attr
> > > > > > > replace"
> > > > > > > and the intent chain we need for "parent attr rename" is
> > > > > > > that
> > > > > > > we
> > > > > > > have to log two attr names instead of one. 
> > > > > > 
> > > > > > To be clear, this would imply expanding
> > > > > > xfs_attri_log_format to
> > > > > > have
> > > > > > another alfi_new_name_len feild and another iovec for the
> > > > > > attr
> > > > > > intent
> > > > > > right?  Does that cause issues to change the on disk log
> > > > > > layout
> > > > > > after
> > > > > > the original has merged?  Or is that ok for things that are
> > > > > > still
> > > > > > experimental? Thanks!
> > > > > 
> > > > > I think we can get away with this quite easily without
> > > > > breaking
> > > > > the
> > > > > existing experimental code.
> > > > > 
> > > > > struct xfs_attri_log_format {
> > > > >         uint16_t        alfi_type;      /* attri log item
> > > > > type */
> > > > >         uint16_t        alfi_size;      /* size of this item
> > > > > */
> > > > >         uint32_t        __pad;          /* pad to 64 bit
> > > > > aligned
> > > > > */
> > > > >         uint64_t        alfi_id;        /* attri identifier
> > > > > */
> > > > >         uint64_t        alfi_ino;       /* the inode for this
> > > > > attr
> > > > > operation */
> > > > >         uint32_t        alfi_op_flags;  /* marks the op as a
> > > > > set
> > > > > or
> > > > > remove */
> > > > >         uint32_t        alfi_name_len;  /* attr name length
> > > > > */
> > > > >         uint32_t        alfi_value_len; /* attr value length
> > > > > */
> > > > >         uint32_t        alfi_attr_filter;/* attr filter flags
> > > > > */
> > > > > };
> > > > > 
> > > > > We have a padding field in there that is currently all zeros.
> > > > > Let's
> > > > > make that a count of the number of {name, value} tuples that
> > > > > are
> > > > > appended to the format. i.e.
> > > > > 
> > > > > struct xfs_attri_log_name {
> > > > >         uint32_t        alfi_op_flags;  /* marks the op as a
> > > > > set
> > > > > or
> > > > > remove */
> > > > >         uint32_t        alfi_name_len;  /* attr name length
> > > > > */
> > > > >         uint32_t        alfi_value_len; /* attr value length
> > > > > */
> > > > >         uint32_t        alfi_attr_filter;/* attr filter flags
> > > > > */
> > > > > };
> > > > > 
> > > > > struct xfs_attri_log_format {
> > > > >         uint16_t        alfi_type;      /* attri log item
> > > > > type */
> > > > >         uint16_t        alfi_size;      /* size of this item
> > > > > */
> > > > > 	uint8_t		alfi_attr_cnt;	/* count of name/val
> > > > > pairs
> > > > > */
> > > > >         uint8_t		__pad1;          /* pad to 64
> > > > > bit
> > > > > aligned */
> > > > >         uint16_t	__pad2;          /* pad to 64 bit
> > > > > aligned */
> > > > >         uint64_t        alfi_id;        /* attri identifier
> > > > > */
> > > > >         uint64_t        alfi_ino;       /* the inode for this
> > > > > attr
> > > > > operation */
> > > > > 	struct xfs_attri_log_name alfi_attr[]; /* attrs to
> > > > > operate on
> > > > > */
> > > > > };
> > > > > 
> > > > > Basically, the size and shape of the structure has not
> > > > > changed,
> > > > > and
> > > > > if alfi_attr_cnt == 0 we just treat it as if alfi_attr_cnt ==
> > > > > 1
> > > > > as
> > > > > the backwards compat code for the existing code.
> > > > > 
> > > > > And then we just have as many followup regions for name/val
> > > > > pairs
> > > > > as are defined by the alfi_attr_cnt and alfi_attr[] parts of
> > > > > the
> > > > > structure. Each attr can have a different operation performed
> > > > > on
> > > > > them, and they can have different filters applied so they can
> > > > > exist
> > > > > in different namespaces, too.
> > > > > 
> > > > > SO I don't think we need a new on-disk feature bit for this
> > > > > enhancement - it definitely comes under the heading of "this
> > > > > stuff
> > > > > is experimental, this is the sort of early structure revision
> > > > > that
> > > > > EXPERIMENTAL is supposed to cover....
> > > > 
> > > > You might even callit "alfi_extra_names" to avoid the "0 means
> > > > 1"
> > > > stuff.
> > > > ;)
> > > > 
> > > > --D
> > > 
> > > Oh, I just noticed these comments this morning when I sent out
> > > the
> > > new
> > > attri/d patch.  I'll add this changes to v2.  Please let me know
> > > if
> > > there's anything else you'd like me to change from the v1.  Thx!
> > > 
> > > Allison
> > 
> > Ok, so I am part way through coding this up, and I'm getting this
> > feeling like this is not going to work out very well due to the
> > size
> > checks for the log formats:
> > 
> > root@garnet:/home/achender/work_area/xfs-linux# git diff
> > fs/xfs/libxfs/xfs_log_format.h fs/xfs/xfs_ondisk.h
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h
> > b/fs/xfs/libxfs/xfs_log_format.h
> > index f1ff52ebb982..5a4e700f32fc 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > @@ -922,6 +922,13 @@ struct xfs_icreate_log {
> >                                          XFS_ATTR_PARENT | \
> >                                          XFS_ATTR_INCOMPLETE)
> >  
> > +struct xfs_attri_log_name {
> > +       uint32_t        alfi_op_flags;  /* marks the op as a set or
> > remove */
> > +       uint32_t        alfi_name_len;  /* attr name length */
> > +       uint32_t        alfi_value_len; /* attr value length */
> > +       uint32_t        alfi_attr_filter;/* attr filter flags */
> > +};
> > +
> >  /*
> >   * This is the structure used to lay out an attr log item in the
> >   * log.
> > @@ -929,14 +936,12 @@ struct xfs_icreate_log {
> >  struct xfs_attri_log_format {
> >         uint16_t        alfi_type;      /* attri log item type */
> >         uint16_t        alfi_size;      /* size of this item */
> > -       uint32_t        __pad;          /* pad to 64 bit aligned */
> > +       uint8_t         alfi_extra_names;/* count of name/val pairs
> > */
> > +       uint8_t         __pad1;         /* pad to 64 bit aligned */
> > +       uint16_t        __pad2;         /* pad to 64 bit aligned */
> >         uint64_t        alfi_id;        /* attri identifier */
> >         uint64_t        alfi_ino;       /* the inode for this attr
> > operation */
> > -       uint32_t        alfi_op_flags;  /* marks the op as a set or
> > remove */
> > -       uint32_t        alfi_name_len;  /* attr name length */
> > -       uint32_t        alfi_value_len; /* attr value length */
> > -       uint32_t        alfi_attr_filter;/* attr filter flags */
> > +       struct xfs_attri_log_name alfi_attr[]; /* attrs to operate
> > on
> 
> What's the length of this VLA?  1 for a normal SET or REPLACE
> operation, and 2 for the "rename and replace value" operation?
> 
> If so, why do we need two xfs_attri_log_name structures?  The old
> value
> is unimportant, so we only need one alfi_value_len per
> operation.  Each
> xfs_attri_log_format only describes one change, so it only needs one
> alfi_op_flags per op.
> 
> For now I also don't think attributes should be able to jump
> namespaces,
> so we'd only need one alfi_attr_filter per op as well.
> 
> *lightbulb comes on*  Oops, I think I led you astray with my
> unfortunate
> comment. :(
> 
> IOWs, the only change to struct xfs_attri_log_format is:
> 
> -       uint32_t        __pad;          /* pad to 64 bit aligned */
> +       uint32_t        alfi_new_namelen;/* new attr name length */
> 
> and the rest of the changes in "[PATCH] xfs: Add new name to attri/d"
> are more or less fine as is.
> 
> I'll go reply to that before I get back to Dave's log accounting
> stuff.
> 
> --D
Alrighty, I think thats the simplest solution for now.  Will switch to
that thread....

> 
> > */
> >  };
> >  
> >  struct xfs_attrd_log_format {
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index 3e7f7eaa5b96..c040eeb88def 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -132,7 +132,7 @@ xfs_check_ondisk_structs(void)
> >         XFS_CHECK_STRUCT_SIZE(struct
> > xfs_inode_log_format,      56);
> >         XFS_CHECK_STRUCT_SIZE(struct
> > xfs_qoff_logformat,        20);
> >         XFS_CHECK_STRUCT_SIZE(struct
> > xfs_trans_header,          16);
> > -       XFS_CHECK_STRUCT_SIZE(struct
> > xfs_attri_log_format,      48);
> > +       XFS_CHECK_STRUCT_SIZE(struct
> > xfs_attri_log_format,      24);
> >         XFS_CHECK_STRUCT_SIZE(struct
> > xfs_attrd_log_format,      16);
> >  
> >         /* parent pointer ioctls */
> > root@garnet:/home/achender/work_area/xfs-linux# 
> > 
> > 
> > 
> > If the on disk size check thinks the format is 24 bytes, and then
> > we
> > surprise pack an array of structs after it, isnt that going to run
> > over
> > the next item?  I think anything dynamic like this has to be an
> > nvec.
> >  Maybe we leave the existing alfi_* as they are so the size doesnt
> > change, and then if we have a value in alfi_extra_names, then we
> > have
> > an extra nvec that has the array in it.  I think that would work.
> > 
> > FWIW, an alternate solution would be to use the pad for a second
> > name
> > length, and then we get a patch that's very similar to the one I
> > sent
> > out last Tues, but backward compatible.  Though it does eat the
> > remaining pad and wouldn't be as flexible, I cant think of an attr
> > op
> > that would need more than two names either?
> > 
> > Let me know what people think.  Thanks!
> > Allison
> > 
> > 
> > > > > Cheers,
> > > > > 
> > > > > Dave.
> > > > > -- 
> > > > > Dave Chinner
> > > > > david@fromorbit.com

