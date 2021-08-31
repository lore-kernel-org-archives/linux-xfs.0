Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A76C4320E
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5843060F6C
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbhHaSM5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:12:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:4428 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230200AbhHaSM5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Aug 2021 14:12:57 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17VFlF1E007616;
        Tue, 31 Aug 2021 18:12:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=TyAcQuFOTMiMVYJswMqJ5ILZYW9R6kB8w4nJ4Nz1Dn8=;
 b=G6cErwM0yxhCyFSoJXqiNK/GiaiRsUPGdL38JskawD25YyITK33vcfg+RkiqjJiaFwTT
 EyV4+omXyN3YOLvAASBM52CvLg/grkcZDHU2Ift/aKWXUaw437zVXFLGfOtkd4riVy9t
 hPhtVJL47beQZ2ZtsGdwLcXstzVwxNE/DPgeJto7d/WujQFZnWqFVALhZxc5FUpaPXSg
 CroHXlNmHeNiPr4cEthVK66wM4KKKIo+SORZPUmD520+D448EVYuPlTng5Lo+uxp+lL8
 WBKZLSKp54PU0tal1bZysuUlWfKq8/OfkE5iLY3+oo/rd6FVhp7+EmMnFz1dDTTT70BN Aw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=TyAcQuFOTMiMVYJswMqJ5ILZYW9R6kB8w4nJ4Nz1Dn8=;
 b=b1B+de6rF0xi1ufoK+Nge9U8AL4rNGqskRoj+X0N7/c2aqwj8IsI4dr2aRmnMx8CoER7
 m8BLej1dfLeyTEwDBofCha0RdV8Vg9AVYrfHNFkNWtE/9sh+40YkWJ02HPCFyOas7yTA
 24bqPGxxw2MSPFK0GW/a36c3qGCv5f25IpGIHWb1VOuWFbQokZIf2RcVr6vqt8Sr8TRx
 TOgafpCmxO6KZlSV904IYOZ8Hdh10zua8bvBdkxK9O+osmnQkJV8Yd1tjfYsdsZmR4Bn
 xCpW1CXi+itWGwvxgDiBq5/C/Jf3i4hH49+dFjKr4E2kQ/FmlOtTZfGyC144gazNknfP MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3asdn1t3gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:12:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17VIAJGp062333;
        Tue, 31 Aug 2021 18:11:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by userp3030.oracle.com with ESMTP id 3arpf4unud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 18:11:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RS/61xkSAMLIF31Ssy5dOGGnxcKdaK+oVwN/ra7nB0ZdBnpT0jca9qvuvtzVozykPKGxZ8K/6QWW5BjzcEgzVWjrHApK7jtDrxqYuTy5yFTG9iGmTMi7YW/HLyfawgnUkH9eQ1VsM8Jq5cjtDIxfikZg8AfxCECm6hZDjIywJ6ZMCrd3yJvLS13cHAU5uR5kq2kFcVVeB1FREfE7+7EGops3ICnnefMwf6zk+ihewcMe2kZOBsrYiUFh3a0Mqlns/8IWrxq114OiWLPjH7x6GmKlJAfvBkaFIQeAqs+an6xXcttjIlOo+Mvjwlgd1hy9XSAAaJ/9mRTqqkrc1dTrBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TyAcQuFOTMiMVYJswMqJ5ILZYW9R6kB8w4nJ4Nz1Dn8=;
 b=DsFyEuVskmKvudRO4Y2pjUWZ/bsIp8jPvCiwF3VylIJelGeseqY1qZCqNvMER21j5LxhljU/fQMHxILM3BPdUXnuQ3+q9IgAD0akKuD9ZTBomGo7vViJmcAqVIz9KkQ2cWsAwaqWdzjRG5zONR7ifSOTqb4ZE2t6+/aLTdcjGwAbxmxZwdZ4MAdEFQzLTjPxeVZnBEdqpwlK0nA9YAvdaOhuAQtvCfRPHpTyyPui49vwyzuXAzPSJLP15j0FbXffrp0pCVfq5s/ABCZHwLehy4w3FsrBWbKfDNBNBpbYvfyMvonP0cW8op4rJ4z3CgPSZj+VSwEem+GCpub80OnROw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TyAcQuFOTMiMVYJswMqJ5ILZYW9R6kB8w4nJ4Nz1Dn8=;
 b=zlaTbkVguoNwAubuPrZ82CehlNtX/wAgrjO/7AqUrXnXjLX+hv3+uf4r9W85aoQoax4QgeGrsNcPi75sRASbuAa5Y4SOEgnJK8ceQOw59bdNJCwnbra0DL165YtGdN9wHAcWaNL+yuNrTYNI0qnsqkV/flJuEa2FX9VOtgYFtWM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3509.namprd10.prod.outlook.com (2603:10b6:a03:11f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Tue, 31 Aug
 2021 18:11:57 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::7878:545b:f037:e6f%9]) with mapi id 15.20.4478.019; Tue, 31 Aug 2021
 18:11:57 +0000
Subject: Re: [PATCH v24 05/11] RFC xfs: Skip flip flags for delayed attrs
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-6-allison.henderson@oracle.com>
 <87bl5f9r28.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <0a5de6a9-0109-9555-41d2-491116caa8d4@oracle.com>
Date:   Tue, 31 Aug 2021 11:11:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <87bl5f9r28.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0142.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::27) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
Received: from [192.168.1.167] (67.1.112.125) by SJ0PR13CA0142.namprd13.prod.outlook.com (2603:10b6:a03:2c6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.10 via Frontend Transport; Tue, 31 Aug 2021 18:11:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77921bfc-05b8-4756-4fe6-08d96caad1e7
X-MS-TrafficTypeDiagnostic: BYAPR10MB3509:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3509C90EE782D265FB2D8E5795CC9@BYAPR10MB3509.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: syA8jjoRvU777Dfi6hvDhCaAPq41H3z7xE1KVcs5AL10Ngwcw6S+os/VqCaKZfR1wqmwsftj5MWbPeQ4SM+YxPhwhJ+PDRqtdOLyu7pWo0NZYgJkf8JkpUEa+SNfkFhF2muSGwgV51ie6CRoFW9EGDKdGumb8jipQf5GHsiWtytPvo1z4bEX87l+rWiNfEY4KQXXLd5ruXrI073YbV5XNoHVxXcibD70D4MT+zMPPc9IVeC9M13qeipD3hmH2xJXsBePgCgBxC9q22OqAq3c0FW2ETbcIAR9nUgtKQV3nDwhUbmzzfDLX1ZAYB/Qitin71I8tUwruHJqw9sjHYuq6DH5Y74AS02HiUGYj63nMlAppDkk0f+Oo6gBaoMxFPK4tAP/gdFlcMLw+mN6v8skrjkhn6W+yFYgr3hdXVdNSC3F//P8NaDi1ooELT9qRDqOVQir64NG4uQKDrteZmQwq1els5vyTKGt4WgUwMJtFodgawEnKao8Emy9/IXxtR6sFGn809AeuNaCT/s/VfKiu/77myDI8+vhzwdYXMOTqSnEvxnN7nobDf0U9resEfKrrroMuHYXHo6+kWRLClQdT1Rgq0Tpzkum6oGM69e+0bFXoKiwcnokMSbQVEFPW9fPMhIYO5z8fsD3jQ01QY9Rr7UYosQkQ5zzMQtMvEF5dluJXoxrUU95XMOlVAd2u07f8aXGvuU60PWJLV8CVE8Q7t7R9m2e0DQNqKgfEnI1UsF53xB1s2QLZUEuygF/Ovdv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(366004)(376002)(53546011)(2616005)(44832011)(66556008)(956004)(38100700002)(83380400001)(6486002)(6916009)(38350700002)(4326008)(478600001)(5660300002)(52116002)(66476007)(8676002)(2906002)(8936002)(86362001)(31686004)(316002)(26005)(16576012)(186003)(66946007)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2Q2SnU5cFRlb1FXNXZDOFFVMDVsZ3ZmTnRMS2FzNUFad1hPNGJZTzFiNjNB?=
 =?utf-8?B?RGo4RXVzcDROcStWTVRKVk9KMGp1YVpPdW4xaSszbnFCNUxvUWp3Z2VWdW8w?=
 =?utf-8?B?bFh1MU9tWlY4SmtxNFNHNU8rbFJEUDRUSVcxdm9ta3J0b0NmaDBOTUZ4NFBn?=
 =?utf-8?B?ejNYSGtBdERicXZObXFaeXY5YWxYakNBL09uWWtVbzJ6cU9Yc3QxWHdQeXFv?=
 =?utf-8?B?elBlS0twSUUrK25DOVY2S0RpZVF2NVNMc05Oa0hpN2lWLzVMY0xrR2sxTXJR?=
 =?utf-8?B?WTNNSjBXWlBISWNiYlJxWDlsaGZ3SHkrT3ZPR21KbXM0eG5KcExMZmRaaHk0?=
 =?utf-8?B?NENhdDFyRVExYnVNdHB3SUVEQUdQeWNkdHZwVFo0SmZZZlBIWEh5VVV1cWVW?=
 =?utf-8?B?aDVGQjlWaElVdHRlL1JtM3JBWmZVODlqa0NYOFVNOFRiZk9EQzM2NGU1RFRx?=
 =?utf-8?B?T2lSTjRsWW1CdTFpVjJBM3JuWUsvckJ6RG9yTm9CS0xqVUtaMDNhTSt3WXZu?=
 =?utf-8?B?cDlMMUxNVlVYLzZObU5rZVE1UlhxbW1ubmZrL05JVHRWZkFsWkQwUnFBQkl2?=
 =?utf-8?B?MHlFTnlOZzlNL2FvRlhWQk80SU1sS2VKamx0OFJlbFJCVE9hTFVWL1NWY2ZK?=
 =?utf-8?B?Q3NDdW04bktHR0pVK1h0eThGUmdGVDl5bDZWTlNJaXlqbCtqc0Z5ak84eTZF?=
 =?utf-8?B?a09LMURtTmh3TjZiVmh6dnUwRkVDbGlabkdoYzRwUjRmZlY0ZVcwaFJoYzkv?=
 =?utf-8?B?ZTlxblhuU1VNNE1zT2I4Qy93ZzNZZGhXbU9PRUV1eDk1TlBmenFoVDg1djZF?=
 =?utf-8?B?NmFjTFZGdzJPcVhqWGhjRjh3amJscEY2U0NvcUFoMHlUS1RVZW56STBtRDJp?=
 =?utf-8?B?SG5pT0xmZVlNWHVGT0R4d3JMMm9PbE13UHhmclJ5UjJSK0hIVFBZc1N2RXpx?=
 =?utf-8?B?Rm9tRkxmVmVscEZ1bmJ1UGt1UDIvanFZczFyV2dJWUNDNytMWjJ4RWNDZ1pu?=
 =?utf-8?B?a1QxNkZZZXNVNWg5dytaeUVpNk1hTkNMQVhLS0lCOW9CcGN1dXVqVEN3UGFV?=
 =?utf-8?B?WHdnRmJOVWxYWlFaZkpDVTBsTnBHdmlDWnBJUnl1UEUxN01OVHJaRWtNbWRL?=
 =?utf-8?B?OFVIeW9JSzRPNHhDRHJ4VjJ2dHhQams5TnN4LzFFek9TQll6dktYUGM1TU9F?=
 =?utf-8?B?RjlCMXFJQjAvZEhzTWgzZGx5Lzd2N0RvYmlWSERidG9YVEJWdytGWS9oTG13?=
 =?utf-8?B?ZWV5bU1lVXVmTmlzL29uRmx3T3FzQ3ZlOW95YjBjRmtwS1JpbmZGamFSOW1Q?=
 =?utf-8?B?amxPOEUvOXlMaHNwTUVVZ1pwbmdwV2NDTmFPVVJuck50MGh1aFVGZk53Nm9q?=
 =?utf-8?B?S2VPTzQ0YldtbkMyd2dRbW5DTStjZ2h4by9MaG1iZlU2QzNXeDBpRk83SXk4?=
 =?utf-8?B?NGd5b1A3NlpOc0l0R2YrZXdkMjZOK3ZEc2lkSEdKdWg2VDlBSU9IVEpwY1lx?=
 =?utf-8?B?ZllhV3pzQ3J6VSthRXZ6QnM5WWRPRnM2eDBjWnd3eFFWc0JEMVE2OW1hZXVv?=
 =?utf-8?B?RmdwY2NMUjV3U3RVVUNyamhJd092ZjBJdFRmc28wb0RRK1VBRXJWakhMdXRF?=
 =?utf-8?B?KzlZSzJIeW1HVnM0aFlBa0xFYkdaY1BFM1lZemovWnFrVzd0WHZuUDlPMElL?=
 =?utf-8?B?djNjTGNSeVhLd2tkTGxZQWRvbnNpQUxGSU93UnEyUS9DTnIvSnlKOE1kTTFu?=
 =?utf-8?Q?6J/uvXJVDVcjE4+s3QaAL921dxmdniuUhzFIe1y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77921bfc-05b8-4756-4fe6-08d96caad1e7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 18:11:57.3643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CPll7mO8qGQu8+QfRWu5cct14XGSmeJrPgIni3ZY7mdJuaDJls7xXAIqV6JPZSPfMItX0BKgL1Hz85K/UyAhKLJvWPeAjfgS1OEr1ftxmTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3509
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10093 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108310101
X-Proofpoint-ORIG-GUID: yK6H7gLFkjwr0VBzE_OEJpDCaODdwCxK
X-Proofpoint-GUID: yK6H7gLFkjwr0VBzE_OEJpDCaODdwCxK
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/30/21 3:15 AM, Chandan Babu R wrote:
> On 25 Aug 2021 at 04:14, Allison Henderson wrote:
>> This is a clean up patch that skips the flip flag logic for delayed attr
>> renames.  Since the log replay keeps the inode locked, we do not need to
>> worry about race windows with attr lookups.  So we can skip over
>> flipping the flag and the extra transaction roll for it
>>
>> RFC: In the last review, folks asked for some performance analysis, so I
>> did a few perf captures with and with out this patch.  What I found was
>> that there wasnt very much difference at all between having the patch or
>> not having it.  Of the time we do spend in the affected code, the
>> percentage is small.  Most of the time we spend about %0.03 of the time
>> in this function, with or with out the patch.  Occasionally we get a
>> 0.02%, though not often.  So I think this starts to challenge needing
>> this patch at all. This patch was requested some number of reviews ago,
>> be perhaps in light of the findings, it may no longer be of interest.
>>
>>       0.03%     0.00%  fsstress  [xfs]               [k] xfs_attr_set_iter
>>
>> Keep it or drop it?
> 
> Looks good to me.
> 
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Ok, thank you!
Allison

> 
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 54 +++++++++++++++++++++--------------
>>   fs/xfs/libxfs/xfs_attr_leaf.c |  3 +-
>>   2 files changed, 35 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index dfff81024e46..fce67c717be2 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -355,6 +355,7 @@ xfs_attr_set_iter(
>>   	struct xfs_inode		*dp = args->dp;
>>   	struct xfs_buf			*bp = NULL;
>>   	int				forkoff, error = 0;
>> +	struct xfs_mount		*mp = args->dp->i_mount;
>>   
>>   	/* State machine switch */
>>   	switch (dac->dela_state) {
>> @@ -477,16 +478,21 @@ xfs_attr_set_iter(
>>   		 * In a separate transaction, set the incomplete flag on the
>>   		 * "old" attr and clear the incomplete flag on the "new" attr.
>>   		 */
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
>> +		if (!xfs_has_larp(mp)) {
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
>> @@ -589,17 +595,21 @@ xfs_attr_set_iter(
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
>> +		if (!xfs_has_larp(mp)) {
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
>> @@ -1236,6 +1246,7 @@ xfs_attr_node_addname_clear_incomplete(
>>   {
>>   	struct xfs_da_args		*args = dac->da_args;
>>   	struct xfs_da_state		*state = NULL;
>> +	struct xfs_mount		*mp = args->dp->i_mount;
>>   	int				retval = 0;
>>   	int				error = 0;
>>   
>> @@ -1243,7 +1254,8 @@ xfs_attr_node_addname_clear_incomplete(
>>   	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>>   	 * flag means that we will find the "old" attr, not the "new" one.
>>   	 */
>> -	args->attr_filter |= XFS_ATTR_INCOMPLETE;
>> +	if (!xfs_has_larp(mp))
>> +		args->attr_filter |= XFS_ATTR_INCOMPLETE;
>>   	state = xfs_da_state_alloc(args);
>>   	state->inleaf = 0;
>>   	error = xfs_da3_node_lookup_int(state, &retval);
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index e1d11e314228..a0a352bdea59 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -1487,7 +1487,8 @@ xfs_attr3_leaf_add_work(
>>   	if (tmp)
>>   		entry->flags |= XFS_ATTR_LOCAL;
>>   	if (args->op_flags & XFS_DA_OP_RENAME) {
>> -		entry->flags |= XFS_ATTR_INCOMPLETE;
>> +		if (!xfs_has_larp(mp))
>> +			entry->flags |= XFS_ATTR_INCOMPLETE;
>>   		if ((args->blkno2 == args->blkno) &&
>>   		    (args->index2 <= args->index)) {
>>   			args->index2++;
> 
> 
