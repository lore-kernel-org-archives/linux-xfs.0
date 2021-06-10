Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7B1C47094
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 07:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75B2B613C9
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Jun 2021 07:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFJHWz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Jun 2021 03:22:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41528 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhFJHWy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Jun 2021 03:22:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A7EF9r174583;
        Thu, 10 Jun 2021 07:20:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2RPFhcmB3BqiUxjdKACEtGwslewxRa2nsYUZ5I3M5T4=;
 b=SHWCI0nAzVFq/m7YKTD4FtnzVaOnZpVwWFn0zfkL6J3+CVf0d+MCLhAtPSbmIV1b9w8C
 iNYoD3GlFT9uuoVVg/AZa8OeHeD6nYxRwf70xZjoXORgNGqv5a9r+wkRAMhRGZxdKHDz
 NDUOHnbHmKMkVXi3pCHcTymKLrFXyARHdhgcl3fTxU/i8qERXp6eQgnwTyyXZ70T5VPo
 D1Bv5lZqI3X2Nlt33Bj4JRTZKYTuc16knMbH9eS0Ol6hL4+SvWMIkMYXmwJIhT0KseGI
 PfAAzI9BUyNHeSYd0pyahrhTkUWQkKRTOwROPB8psDo4dK8KcB2n0vrd/AjwK7wkLFbJ 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3914qusmp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 07:20:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A7GSfV091171;
        Thu, 10 Jun 2021 07:20:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3030.oracle.com with ESMTP id 38yxcwcwcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 07:20:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ORrFxiomuiy9pCFHrpxGfz/pmGRhkSAYVlt5qiXk1Ndq6OQDpnkbTcJbyOHK2a50k3XbdzSAhi4U/wtHHMeK2Pzfo7TsDkC/7VdIes8KrwS7rQxRKh/TkrknlfSspCwfOZzkdyUan4ab6/rbXtcUeNMy5EIGhJFNlAPKliZ8YosO/lsAQoSVtFMCYsNSUdIT7ljE2ip9nhJD6qZdxYEs0sQi9Qu+I5qzQKfBVsEE6JWZIMSE/ehIxsv46uufh7611AMOWYcQjCMY3rQZ3k6hb/6a1Z/kuHv0GU0aiYUDPPrRN7jR3dbPaOmLo1JwGbGW/4llpFyBbV8tsH3dqqVF+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2RPFhcmB3BqiUxjdKACEtGwslewxRa2nsYUZ5I3M5T4=;
 b=CBoOe7PMkj6EgfUi6g2rNU8jSvcZDvTRLolE3FLIE8a0I71kobNmBAZSefkmHF7/HmBXK0cQFCmcA1i7TEuS4SyP8NehG6Vo/0mBf7JF7pbDU2MocjXy4ljIQNK/3BqyCs3qhx1OiOR3BXYW4HRi2DjrhX/QLZtu1IuaX9G/VRxlziK2DgQe8uUAhA6VcVJuV927SNQYcoc6mkE9UBp2SNlxjmh+O+Tb+V5ydbRAZF40wo9gHQWBVYDzMrCSGZbfxk5cdcOYAgVnj9rtUo+F/jnfxDuvVdcH1sLVgS3YIGArfgZH0YsYUrHByjFxzSG0JhTSLp5QmK+JFgvLY86SSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2RPFhcmB3BqiUxjdKACEtGwslewxRa2nsYUZ5I3M5T4=;
 b=p2S4Z85/cV/vIOeiXrVAVE/hjCOHJmFY1LjtXQrwy/YbgVi5oeQorvwjlP4vFr6KvwkoJlS+ny71jVKoo+Y3GICVCKy252cFW1Swvs9EtJvxeAjc0nQN8d9aD8100/moST2+ptOVdhHesGpwYpvzqEDdc5U4QDv85mNpiXZyt4A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4130.namprd10.prod.outlook.com (2603:10b6:a03:201::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 07:20:51 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::a9c4:d124:3473:1728%5]) with mapi id 15.20.4195.030; Thu, 10 Jun 2021
 07:20:51 +0000
Subject: Re: [GIT PULL] xfs: Delay Ready Attributes
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210609194447.10600-1-allison.henderson@oracle.com>
 <20210609220339.GO664593@dread.disaster.area>
 <20210610002806.GA2945738@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <25f2d812-7009-231f-3a31-b01cc6bce175@oracle.com>
Date:   Thu, 10 Jun 2021 00:20:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210610002806.GA2945738@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: BYAPR02CA0065.namprd02.prod.outlook.com
 (2603:10b6:a03:54::42) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by BYAPR02CA0065.namprd02.prod.outlook.com (2603:10b6:a03:54::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 07:20:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8adb00c5-6516-4ad2-47bd-08d92be04714
X-MS-TrafficTypeDiagnostic: BY5PR10MB4130:
X-Microsoft-Antispam-PRVS: <BY5PR10MB413045E0D5A4C73AF47D199795359@BY5PR10MB4130.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wK+kME2kEPiyGnFr7+wy8UYAn5tk2GzkXah293z7kRv0e1Tw0JLIsLcONB7URlBzaXJxw/L16odvoUHD3kNJf6ZkT2hZz7Kgx21cGJLGulfDUwqFebb6ZTdt+RrTqkpsdbBHf1/huAzdTjC+GNW+TtZhk4UoEUP+o+NsXWjr89ThXy9iDyOfLMX9ca55BgDnKdvjwnrjHosMW+mj7Y1OQZxc+/5dawvPeLuuxezWHFbjcbW0QjQJnDuEapLck+xqkrNFXFP58oU1cK/D5c7G5GfPMOc62HvYYd3EJQmQc93oPt8p0FabCM6SJNuXe+nc4j8FSGPr780vDRujLGAP9St6peB21BYc0/EGPk+/otYXIk0q5gx3pULO2We+HVEzZMyJsS+VB3If7kR+sr3FD0tC/0e3UgHZBfgVznsPV3/IGmJ6aM/Za4fBHUbBPfh85lBOigVp0jWvLsEVQ/F/a1uFkKj21JdWxqmXMEMOnBlLOIxyog/0JyaEDbWo6AjVmiawC9jyQiaCEC+YCt/TedKDxF7oE3ZJkro8wiEWcQh/iLBlIlSxlIhbTeiNwU3M8qU0WQbuKsdHIFJuU3xFnctmxLCbt8L5iyjyC18EgwY4HSVXwxUIuXZU2B8lWeJBLrWTEVN0O48KbOsmZktoLOsZlmJWkCmSYiBr/4oI6ncPSzxBTA/9YWvXGZLme+dBkbqG9do3gx6PgAqdRq4paw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(346002)(396003)(366004)(31696002)(16526019)(2906002)(110136005)(52116002)(478600001)(31686004)(53546011)(186003)(83380400001)(26005)(66556008)(66476007)(36756003)(38350700002)(86362001)(316002)(956004)(2616005)(4326008)(6486002)(16576012)(8676002)(8936002)(44832011)(38100700002)(66946007)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkpvSkJMeWh4TFdsS0pmU2MwNERGVXNMbU5maEVEdUtaVXcyTVNWNE1TbU5J?=
 =?utf-8?B?RE0wQmFqMHhxeExPak1MU05uYnZtcWhJSGtHWnlEdnVlRHlZSDFqZXhEaGlV?=
 =?utf-8?B?eFRxVFArTUhQTmtWekl3dTI4UHBsVEg2Nm9BTzhSY3BkVnk3a0JDRjM5Vmwx?=
 =?utf-8?B?SzVPNnlnb3ljQm9lOVMwM04wd3NsVFMxanBpLzMyckFQNktGamZkYTVzMTVW?=
 =?utf-8?B?c1dMcER1MWVybkVuM01scDlwS1ZIYnJoSEE0Ui9PR2c3VlNRVlo0ODVtQnlm?=
 =?utf-8?B?NjRvV3dPdVlFZHV6bWZic2V2LzJldmwzVjVIRDcvcXZpdC9GS2hDQmNYbVNX?=
 =?utf-8?B?OTBnQ3kzTVJoS2EvTHd1Q1lxRGJzL3c5RFJxQ2NSc3laVVpTWFAzd2dlcW9W?=
 =?utf-8?B?WitiNU05WjJsdVRXWENudFBJOTZCeXBCMzlrUlIyQTlxMEtObDNZSEwzNU1o?=
 =?utf-8?B?WElyVVZ3emxpMnNZMU1tYWU0ODlTdmpENzBGaXZ1RG5NVG1RUGhkWEFabGhO?=
 =?utf-8?B?N1p3ZmlzUkY3cWpPMW9NMVl4QzRHc0c2QWtycWVOVzRJcGFpUU9FN3dQdGFP?=
 =?utf-8?B?TVZCdlhOck1kN1lrZ0JBaGNXWXJPOW1KQWtFYkRtR0lFc2lWbkU5T1krUUMx?=
 =?utf-8?B?dUdmajF5UG9WUkJpLzBEVnAwK0ZiV2NPbDRhMDU0c2M2S2l0Z1l2dDRKVUQv?=
 =?utf-8?B?RmZMbkRkOHEvc1ovaStxa3o1WEFVZjhvcWY5VUV2TGtBRlVUd1cxd0c2Q1Bj?=
 =?utf-8?B?SllSeE9MVit2Z1RGNnZGQmRaZktFV0xxNEhpUWs2NVVRQmxCM3NtMnBPaCt5?=
 =?utf-8?B?ckRHM0NWQ0JOdWtUdisycElQdFRGMDBRaTMwVndCaVdTQzR5NkhYNzY1Y0xw?=
 =?utf-8?B?cVp0T0x1UWlBN0RqNEtYSkhxdDh6TGxYVllhWkc4UktySUFKWldpM01rd3Ar?=
 =?utf-8?B?Y2NzV0E3c0s4SnFIS29aeGdCRTJHMXYvWXhJL1BjTWptbWpKbUJiNWdGNjRL?=
 =?utf-8?B?K3NtZXl3ZnFlT2pLUHJ6b3RYdUhQRDRxUHA3S0lkVmJUMDFPb1lDdnlKRTY2?=
 =?utf-8?B?b1FuVGJ6QnFxQXFnVjVVbGIwa0NzQy9INGNlS3NRemNpSHFNempUSzgrWkJG?=
 =?utf-8?B?bmwrSWIzSE1CbHN1UzVwZ2ZXRVRFdGRuQzhUR2pBVHhuZ09qRXVtWSs3by91?=
 =?utf-8?B?L0NRdER2cm5PSklxSTAvTHVOa252STJqcWJIQmxwME9hWTNNRW15VEhxT3Iy?=
 =?utf-8?B?emVxMW1zNWdnYnd0L3hMdWE0UlUvOUVtcDNhdkh1MkdERStWRjU1ejVmZDVm?=
 =?utf-8?B?RUM1dGdnM05vYW8xUEI3ZFl3cVlTNEY2b2JXNkZpOTkvL0tqcmhUNGp1dzlz?=
 =?utf-8?B?Q3JzVnlIQTIrQ3RlSm51NTZHdnloQ3RxL3hISW1KaWVmZXRZRXlJZnJJNkdi?=
 =?utf-8?B?aHVtb1V3U3NlT29jV1FQREoyb2FOOHozdTlNZ2ZYTitmakJVQTlnSUdXb2hY?=
 =?utf-8?B?YytpN2VsckM3MzdDN2U3N0ROMlFGUHpUZC9GS1ZSaFNwaGZETm1GMU4rTFJQ?=
 =?utf-8?B?VmtUOG1OYlNqMnF3Y2paR2JnYU9ZOWd6V3RBNEhxSEdMMjQrSFpNZ01GQjMw?=
 =?utf-8?B?UHRsY1lmTlpFTFluc2wxbG5JcEpWaHliMjVRVTJrTnpuVTEvL0M0MlkxdkFJ?=
 =?utf-8?B?MnhKSElVQnRCN1VQVzd0Vmw5S0hoSGZ6MHdJaUtiZm00N0hGVHpHYVp5bVhU?=
 =?utf-8?Q?qerWiysfz+jvyWUJ1jXsKwQxryo5PjVoIDSaJwm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8adb00c5-6516-4ad2-47bd-08d92be04714
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 07:20:51.7076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vx8ZGrHNytgzObUThbftb7Z0247OP0nomUpLJjjXz5gpxSt0WPbF8CiLVwmKQhhwkCLZX45gD1ZZuw2ZO3wFH0kz5q4mUSuuFnYW3zNguRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4130
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100047
X-Proofpoint-ORIG-GUID: rRrqPU8uTgWRGZM3m0qj6kwd0HmvyTBt
X-Proofpoint-GUID: rRrqPU8uTgWRGZM3m0qj6kwd0HmvyTBt
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100047
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/9/21 5:28 PM, Darrick J. Wong wrote:
> On Thu, Jun 10, 2021 at 08:03:39AM +1000, Dave Chinner wrote:
>> On Wed, Jun 09, 2021 at 12:44:47PM -0700, Allison Henderson wrote:
>>> Hi Darrick,
>>>
>>> I've created a branch and tag for the delay ready attribute series.  I'ved
>>> added the rvbs since the last review, but otherwise it is unchanged since
>>> v20.
>>>
>>> Please pull from the tag decsribed below.
>>
>> Yay! At last! Good work, Allison. :)
> 
> Yes, indeed.  Pulled!
Great!  Very exciting, I think this chunk was probably the more complex 
of the sub series for parent pointers.

> 
>> Nothing to worry about here, but I thought I'd make an observation
>> on the construction branches for pull requests seeing as pull
>> request are becoming our way of saying "this code is ready to
>> merge".
>>
>>> Thanks!
>>> Allison
>>>
>>> The following changes since commit 0fe0bbe00a6fb77adf75085b7d06b71a830dd6f2:
>>>
>>>    xfs: bunmapi has unnecessary AG lock ordering issues (2021-05-27 08:11:24 -0700)
>>
>> This looks like it has been built on top of a specific commit in the
>> linux-xfs tree - perhaps a for-next branch before all the most
>> recent development branches have been merged in.
> 
> Yes, it's the xfs-5.13-fixes-3 tag at the end of the 5.13 fixes branch.
Yes, i try to stay on top of the announcements when i see them

> 
>> The problem with doing this is that the for-next tree can rebase,
>> which can leave your tree with orphaned commits that are no longer
>> in the main development branch or upstream. While these commits
>> are upstream now, this isn't an issue for this particular branch
>> and pull request.
>>
>> i.e. if the recent rebase of the for-next branch rewrote the above
>> commit, pulling this branch would cause all sorts of problems.
>>
>> So to avoid this sort of issue with pull requests, and to allow the
>> maintainer (darrick) to be able to easily reformulate the for-next
>> tree just by merging branches, pull requests should all come from a
>> known upstream base. In the case of pull requests for the xfs tree,
>> that known base is the master branch of the XFS tree.
> 
> This is a good point.  Branches should be based off of something that's
> stable, recent, and relatively close to the current development work.
> 
> Ideally that would be for-next, but I hadn't actually declared that
> stable yet since I just started accepting pull requests and wanted a
> couple of days to make sure nothing totally weird happened with Stephen
> Rothwell's integration merge.
> 
> With for-next in flux, basing your branch off the end of the fixes
> branch, or an upstream Linus release some time after that, are good
> enough choices... since I hadn't updated xfs-linux.git#master in a
> while.
> 
> For the past 4.5 years, the pattern has always been that the most recent
> fixes branch (xfs-5.X-fixes) gets merged into upstream before I create
> the xfs-5.(X+1)-merge branch.  This could get murky if I ever have
> enough bandwidth to be building a fixes branch and a merge branch at the
> same time, but TBH if xfs is so unstable that we /need/ fixes past -rc4
> then we really should concentrate on that at the expense of merging new
> code.
> 
> I guess that means I should be updating xfs-linux.git#master to point to
> the most recent -rc with any Xfs changes in it.
> 
>> The only time that you wouldn't do this is when your work is
>> dependent on some other set of fixes. Those fixes then need to be
>> in a stable upstream branch somewhere, which you then merge into
>> your own dev branch based on xfs/master and the put your own commits
>> on top of. IOWs, you start your own branch with a merge commit...
>>
>> If you do this, you should note in the pull request that there are
>> other branches merged into this pull request and where they came
>> from. THat way the maintainer can determine if the branch is
>> actually stable and will end up being merged upstream unchanged from
>> it's current state.
>>
>> It is also nice to tell the maintainer that you've based the branch
>> on a stable XFS commit ahead of the current master branch. This
>> might be necessary because there's a dependency between multiple
>> development branches that are being merged one at a time in seperate
>> pull requests.
> 
> Agreed.
> 
Got it.  Will do, I do sort of run into that from time to time.

>>
>> In terms of workflow, what this means is that development is done on
>> a xfs/master based branch. i.e. dev branches are built like this:
>>
>> $ git checkout -b dev-branch-1 xfs/master
>> $ git merge remote/stable-dev-branch
>> $ git merge local-dependent-dev-branch
>> $ <apply all your changes>
>> $ <build kernel and test>
>>
>> And for testing against the latest -rc (say 5.13-rc5) and for-next
>> kernels you do:
>>
>> $ git checkout -b testing v5.13-rc5
>> $ git merge xfs/for-next
>> $ git merge dev-branch-1
>> <resolve conflicts>
>> $ git merge dev-branch-2
>> <resolve conflicts>
>> ....
>> $ git merge dev-branch-N
>> <resolve conflicts>
>> $ <build kernel and test>
> 
> Whee, the modern era... :)

Sure, I will hang on to these instructions then

> 
>> This means that each dev branch has all the correct dependencies
>> built into it, and they can be pulled by anyone without perturbing
>> their local tree for testing and review because they are all working
>> on the same xfs/master branch as your branches are.
>>
>> This also means that the xfs/for-next tree can remain based on
>> xfs/master and be reformulated against xfs/master in a repeatable
>> manner. It just makes everything easier if all pull requests are
>> sent from the same stable base commit...
>>
>> Anyway, this isn't an issue for this pull-req because it is based on
>> a stable XFS commit in a branch based on xfs/master, but I thought
>> it's worth pointing out the pitfalls of using random stable commits
>> as the base for pull requests so everyone knows what they should be
>> doing as it's not really documented anywhere. :)
> 
> Agreed, though this isn't entirely a "random stable commit", it's the
> end of the most recent stable branch.
Right, i try to stay in top of the latest branch, but this way makes 
sense too.  I think it's good to establish a common procedure for people 
to use so that everyone knows what to expect. Thanks for the examples!

Allison

> 
> --D
> 
>>
>> Cheers,
>>
>> Dave.
>> -- 
>> Dave Chinner
>> david@fromorbit.com
