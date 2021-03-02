Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2F9C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BCD261494
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240092AbhCCDLG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:11:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53698 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382706AbhCBJwD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 04:52:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1228KblF173072;
        Tue, 2 Mar 2021 08:26:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hTJnwfGif4RLyStNpRmTki8lJ4CKvTXlzvWeUBEGiGQ=;
 b=n2SZo0do01d4VPEMbFIZHDkfi3cdX5MlTWLUCXTMi/5GDNRpcZQ1UpsVCT+NSWIEi3DS
 f49vKPQmtUYgC+fNSU6RuNTP1S6xv1sKpr95m0M/tRABZhVzIIeu9jrqmDWpc8ehJ/G+
 OpNPCA0VU12/WXRfGNyhIj/QLt5DFNzFKiKsY2xioiATP0gu0+AlaWBdknRfclokg7nc
 t7EmBbQUlYkGWjd2nr7eOaNhShDPwzzI1BIIGiVFlrOVDVrGRom+leMg82IsdyVeu3qF
 GDp6Nmv/PMz6YN+VXPsggMX1XC/7xKEjuOhEHCBqeQBI8GwjWHXmukvDy/vZupJOkMNZ og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36ye1m6kp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 08:26:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1228OxLj135029;
        Tue, 2 Mar 2021 08:26:15 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3020.oracle.com with ESMTP id 36yyyyj1yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 08:26:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6CRh4XSu2GfndOQLHV4rnWwg5OTvFr6ljv7gij8wbBmDtOiCjQE0KL7SL8UwlQdo4rhOi+0QKAqZFIEavM4MpV9go3nB4xoz2TkXwH8Jj7L+fi9drSk/WIIDgBYnyl/UgO62vIpbubYlxJQFrIHUhol3xcwPYyWhGxPG18uvoLc9hTDj08JDeIvEdJF2TqXWR4qTWK83rUAIqagI697E/YL9ThPSdWan9BOZmCSyQNrsIrjaAak54LTXLmWdk1MeikTsULcgozVNyC99qbtEn8MhEbMnYvy2sQsT0J4EkGZTXbSLj92rBdwZm9CYak+KCgNGB0Umpdcx76Z+Xug1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTJnwfGif4RLyStNpRmTki8lJ4CKvTXlzvWeUBEGiGQ=;
 b=MwrdYUUhKq928EWbLhiUJkX+3NnHup2KXuXYy0sy5aiVcueR2kzqUnPfXEv1+XSKnrm9GkUy/+WCRHZbiu8j5xPuNpCLglasjtU/s84sNkU/0xIRLEPZkNA/9vBqWObOXHuEQzy70fEfF0bavyehuYucPrprtZBtarXlmrSn8G0552R2uF5UJnfGcCIXv1nbKtguEJNcNISSvoWK6jekFCDLQo9xbhj71k1OJskmyL/WUtSUmMqCikp0Wet4G7Zep8+sxyosFFf+j1kn5Sivk3Y5JPkrmQhxig1iS4ddwO3qZiP1VUruYGs+EwcVA/q9fuMlK2ZQSMv3ByBRR7vjiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTJnwfGif4RLyStNpRmTki8lJ4CKvTXlzvWeUBEGiGQ=;
 b=XIXqy1FCtDJnWmhgx2cFXB+LZFp4kMNh7NPxVqqCnq+n31y2oYV9VJVOuLhX6ErHeBU8jKsqbfTucjw9+/Z6zy5XZ4yU7xvWKd7jIoGkMNRhvCY0bU8PS6mEp6f8lOaCTy4pC0QeEGtEdN2Lh6sC+44N8lgVbs3dtpC574lw1tY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3144.namprd10.prod.outlook.com (2603:10b6:a03:15c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Tue, 2 Mar
 2021 08:26:13 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3890.029; Tue, 2 Mar 2021
 08:26:13 +0000
Subject: Re: [PATCH v15 06/22] xfs: Separate xfs_attr_node_addname and
 xfs_attr_node_addname_work
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-7-allison.henderson@oracle.com>
 <20210226040201.GT7272@magnolia>
 <affae494-e7dd-4c27-aade-e640a731b096@oracle.com>
 <20210301180000.GG7272@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <51e80d98-e20f-2c0f-022a-10306fc127b2@oracle.com>
Date:   Tue, 2 Mar 2021 01:26:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210301180000.GG7272@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0302.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::7) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by SJ0PR03CA0302.namprd03.prod.outlook.com (2603:10b6:a03:39d::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 08:26:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ef761dc-87a5-4ca9-3e93-08d8dd54d71c
X-MS-TrafficTypeDiagnostic: BYAPR10MB3144:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3144BB4A295FF7002AED689F95999@BYAPR10MB3144.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +uVCUkzH2XxauUkmk1LTnDhyP9G9gKsIrUGSaLr1l8eIthcB86XG3G2/97pkmvX6l0GpvhZM8kNx/U02soh/M3nvTLpvtSZ66iMWkg5FlgXwcily5vSNbiyznlGUc9kr3HEGeLsFc1xx41a5qccex4dY5Lxi1ub52jjaSX5C46tA4cpnVzd/dGTuGLk6YiIt4WmbWk/VUixhRta08oljVXvEqgD6FdDLV4ix/dQWWxzXmlCOdN1xQrZKK+pGKkQuKNecbObyF85No/2OwHMZUuMobrOWOLiUpuWA88gqVHOvoENBqHGukLpMM75K6x8rEvMh8SxmpqjBl79Ze9ecYIQhT5HARfZb6O3LN6Cm6kA71eSyeE0NfyodFQ21DqdpCTXYoPqPPXnkVXCE60mLP+ZNZ8hjLpsviUhXGqtjlPccYeD2rwrc04k3tZ8LW+DUq0Dq8jnOqoNTMlEhfqMkfaqjfV9b8k/bnYERFX+gsBkL0N12W/aURoND1sAlFqIDWKYTsqUefYFPrMsgvOfUtzKoAIWQ0haPgKdlHh8FEm/920zPgZywghZc/+MXmY+uUnkNpCttZF7Ni1aJczmPGCuIQYi3Nib/njLYeg9putY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(66476007)(66556008)(52116002)(4326008)(66946007)(2616005)(6916009)(53546011)(44832011)(31696002)(16576012)(316002)(6486002)(956004)(86362001)(16526019)(8676002)(31686004)(8936002)(2906002)(478600001)(186003)(5660300002)(26005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SWM2NjArMmNVUWVKc3dnRGlGcjE3VEtTVGNzSUJYS0hTSnYvUjdacHdRSytk?=
 =?utf-8?B?Z25CTkUvTStoSVRON0trY2s1bzhCVTVXZTJYKzlwVGk3ZldpUDc2WVJUeTRE?=
 =?utf-8?B?MmpjWnB6VDBJMjdCNHl0eFo2cXNaMVhYK1NWWXUwcUNNd1FzR3NIc3MxaE41?=
 =?utf-8?B?YVVxdDk5UXh1WFc4QlYzUmtnQUZoU2xMQlc2TDR3bmJ6QlU1VWZMWmRicnBr?=
 =?utf-8?B?WFZtT3B1V0owbzIvcms0c1ZHZmMvdmRSTysyVnA5a3JNWlhTc0IrV1k0MlFO?=
 =?utf-8?B?RTVXYVRCVXFsRkh1bzNEMGpYS1lyK00zY2dMY055eVY5d2I2aXBFRzg5bnVF?=
 =?utf-8?B?b2QxZzFvNlJ6dGNQQzN2cTcvajRIcHliM0d2U2k5MUoxZGdYUDdTWGhzeUZr?=
 =?utf-8?B?T09tTHBGTURXY1FpaStmT2dUeVhwbnZ0TWxBSmtvSFlwZ25jbENCZllKbFhM?=
 =?utf-8?B?Z0VDMVFtR3EwSUJEVjN0ajNxMGpidytGMmc4dUg1NENrV2N2RjZqcmpjV1lS?=
 =?utf-8?B?Zi9CbEFBbFFLTzgrRHNsbmMyMWtSUHdVWGNPdXdZM0ZtbFVxbjNacFlHdkUr?=
 =?utf-8?B?alpvUE1oTyttWWUzT2c5bFNzMUwxdWd4dUplc1h0bEw5T3AwYjlrR05ZbEwz?=
 =?utf-8?B?NG1uV2xwQnpQM0ZxR2QzSm5JNlFwUlBnazZhbnpXMnFWNUVnajZSUG1YMVVG?=
 =?utf-8?B?UnJKSWFCOFoxd21NYUVOODZ6QlJocnRZT3kyYTdvWEMwcUtERGlsdWJtVHBW?=
 =?utf-8?B?eW9FVkJVZ0hrOWNPVXJFM0lyd25pWEM3L0xJZEkvTjZMWnpuTTAzVi9ycDZW?=
 =?utf-8?B?bWZPOWdsaXBDWkFITmUyRmtGbUdNb3ZnYjFkd1hMMkE3RUk0UG9zUXdoY2pT?=
 =?utf-8?B?YkJ2VmFmMTJMTkdjVVJOSjQzN2RYejN0R3FuU04yMitaWUllNENGVW95Mkp0?=
 =?utf-8?B?UnF0cStoZVZrenA5Z2xxMGlteEpDNTRMcGJOTGVsSW1UMTF2ODhZSzcvb1FB?=
 =?utf-8?B?MFhqQmE2dE1PaE01NFZwaG4wQWE3dXNZM0dlaUhkWEd3VWk5Mmd4Nk1LbHJv?=
 =?utf-8?B?QlNNMWJNVzBncEpiV1pTZnIrQ3N6Wlo0ZVM0WXRTKytPTmY3VVFXMHdRYTB4?=
 =?utf-8?B?bHpiZWJPbG5TaDhJbk1MZm9keEUvbWVvMThRdkQyd09IVGlWUDBjcGlOcWZh?=
 =?utf-8?B?NEtYQTJpMTlQWkE3U0hGWVh4NEd5QTBXb0tQcDB5TWcwb3REWXNxTlZtVmI5?=
 =?utf-8?B?LzVEdDNNMlhzTTlscElIeFhxWTdPMmNRSnpYZGtnaUlnaEdtbWZITFd1dzRr?=
 =?utf-8?B?dlJUQkxTM2tMVEdLd3FpdGYvUHkvbHIrVXduUmdyV3lwM3BRZ2pGemJXQVlZ?=
 =?utf-8?B?ZWM3d1c3YzIwQ1R6YnlXRWNYMHE2UTM5b1RjdS9YUHNCSkh5VnR3VlExamd2?=
 =?utf-8?B?V09wZ1AyVlNKWGpOS2szNUd4WE02TjlqT2pVSzBtY0xpaEt6UG02K0hhWjkw?=
 =?utf-8?B?WXpVUDFWVmdHc0JQdXAzbzFVOUNCQjBMNS9mZWRMeUVmdkFsb0orbVhRcmJO?=
 =?utf-8?B?aXR2d2p5Yzdab1hYVjNjNUJpTzZiT2tzaC80TUcra3dGRm1FMXdKSUpkQng3?=
 =?utf-8?B?T2cvQ1RmMnRPeUZtbExlTTlWU1lZRC9rNk12MnpVWGF6ZmpjdHgySGFKZTZq?=
 =?utf-8?B?c3IzRURBRlZKUjlhVTFVNWhkcEd2aHFPaWlOQ3VPUTN4aEFNNHgvdlMrUmFq?=
 =?utf-8?Q?WzR8MZ8jO8I6XNVhokip7QTQxLTv3kPVaqnFlgz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ef761dc-87a5-4ca9-3e93-08d8dd54d71c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 08:26:13.0372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I+VVekv/r+oylUC3n4UKsxDx8Np3RstvOWyrQ4bDM2ZEw1C2S+TbMMdwOhbATy0qFJs9I/aP6n6v0Fm1lXclnLOXadLVxhVxmjKDtozWkK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3144
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020070
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020069
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/1/21 11:00 AM, Darrick J. Wong wrote:
> On Fri, Feb 26, 2021 at 05:54:51PM -0700, Allison Henderson wrote:
>>
>>
>> On 2/25/21 9:02 PM, Darrick J. Wong wrote:
>>> On Thu, Feb 18, 2021 at 09:53:32AM -0700, Allison Henderson wrote:
>>>> This patch separate xfs_attr_node_addname into two functions.  This will
>>>> help to make it easier to hoist parts of xfs_attr_node_addname that need
>>>> state management
>>>>
>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>> ---
>>>>    fs/xfs/libxfs/xfs_attr.c | 20 ++++++++++++++++++++
>>>>    1 file changed, 20 insertions(+)
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>> index 205ad26..bee8d3fb 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>>> @@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>>>    STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>>>    STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>>>    STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>>>> +STATIC int xfs_attr_node_addname_work(struct xfs_da_args *args);
>>>>    STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>>>    				 struct xfs_da_state **state);
>>>>    STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>>> @@ -1059,6 +1060,25 @@ xfs_attr_node_addname(
>>>>    			return error;
>>>>    	}
>>>> +	error = xfs_attr_node_addname_work(args);
>>>> +out:
>>>> +	if (state)
>>>> +		xfs_da_state_free(state);
>>>> +	if (error)
>>>> +		return error;
>>>> +	return retval;
>>>> +}
>>>> +
>>>> +
>>>> +STATIC
>>>> +int xfs_attr_node_addname_work(
>>>
>>> What, erm, work does this function do?  Since it survives to the end of
>>> the patchset, I think this needs a better name (or at least needs a
>>> comment about what it's actually supposed to do).
>> To directly answer the question: it's here to help xfs_attr_set_iter not be
>> any bigger than it has to. I think we likely struggled with the name because
>> it's almost like it's just the "remainder" of the operation that doesnt need
>> state management
>>
>>>
>>> AFAICT you're splitting node_addname() into two functions because we're
>>> at a transaction roll point, and this "_work" function exists to remove
>>> the copy of the xattr key that has the "INCOMPLETE" bit set (aka the old
>>> one), right?
>> Thats about right. Maybe just a quick comment?
>> /*
>>   * Removes the old xattr key marked with the INCOMPLETE bit
>>   */
>>
>> I suppose we could consider something like
>> "xfs_attr_node_addname_remv_incomplete"?  Or xfs_attr_node_addname_cleanup?
>> Trying to cram it into the name maybe getting a bit wordy too.
> 
> xfs_attr_node_addname_clear_incomplete?
I'm fine with that as long as everyone else is :-)

Allison
> 
> --D
> 
>>
>> Allison
>>>
>>> --D
>>>
>>>> +	struct xfs_da_args		*args)
>>>> +{
>>>> +	struct xfs_da_state		*state = NULL;
>>>> +	struct xfs_da_state_blk		*blk;
>>>> +	int				retval = 0;
>>>> +	int				error = 0;
>>>> +
>>>>    	/*
>>>>    	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
>>>>    	 * flag means that we will find the "old" attr, not the "new" one.
>>>> -- 
>>>> 2.7.4
>>>>
