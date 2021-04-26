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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC65C433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Apr 2021 16:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25B9561076
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Apr 2021 16:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhDZQxq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Apr 2021 12:53:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbhDZQxp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Apr 2021 12:53:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13QGnHn3188982;
        Mon, 26 Apr 2021 16:52:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7rQg5rSkGA5Jv3iGSCkvxhnAV1yFI17dtOP2mSAYdv4=;
 b=gRyWtNbUG8bOhS9MzcbzfvBkXMplUTfoIEjAwnIDsQnR8UeGKBLMHyoHMG620eCan+t5
 CSG5/T1pA8Mc2HbLKCaMsD446+EEsmtGNDMLVDsJfe1HyLOC9iMfFHkIm2uRUdd5YXSi
 4O/YygIyqZmmAdfNovZheARpMnK9z42syDYsoWueoacHpVzlaDxfDxVsfGJ1HPZ4Fe60
 JJ8DaMvS28QMLb54+LGPVd5pA4MJaWranKbeB17b4+PBUAIYduLgXwtWcqYdK7D9itNJ
 r9tSa4ihI2Zb686iJZchu9syVVvY8uoelZKxecxWTlkzvPYXvBYVDvTJsLvpGaYAUhHf 9w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 385afstqvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Apr 2021 16:52:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13QGoLJq163093;
        Mon, 26 Apr 2021 16:52:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 384w3rts1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Apr 2021 16:52:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGrlSicleOXC7ILBgdfYBS8McIgY6t3u5M1xQWhumET/zfWiNcoYuMRBiV8jCFu4nXZX34kI7gwicSxQstnrzMNZpR/rVoEhv15WV5JyYfnq0ZwMFamLt700kbBUTmNpRSuQeOfNHCuhKaJN70cwHVX6Ww/IbI9KrACweVNw1782fy7dj/upKpRuP5oSE7r6GW3lj8/2LPtLMvQv5S8e/vq+lSrXuFd8mkRaCXnA2tPhL9qBnaa+da+lPjuJWM7EQCHMEhq3vc6wIO2Jm+PnKh1laEiWC5VD8ruoSwNvTiZLEOd0noJwENO3rG4aTeWXtU1OdzXETuYevj7j7rnYJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rQg5rSkGA5Jv3iGSCkvxhnAV1yFI17dtOP2mSAYdv4=;
 b=V8Iq5P42A/O5/hPHwyziWtt3Id+ckKtj41AkAwz5N2OinnqXGpJWEQKLng7MdPA4q22QgpxdTI01SmqNdHJfPpRz8vGdX4nT9us0BvAdgy+hrhjdquAyz1QAMsGjPyBMJ9tQsL0Dtn+0T2WJa/L8ZlxMO5gqVXpY3+jdHi4wyNqpQcyZMQw/tbslnmjhf5nXrUozOfVJaVObf68GiWi79Xq1NHIZ8na97OBttiTJai7Vz52OH2m6aMPFjP9qC7Ra9ZlpIL6pHMrQffcf/UQ8b/nvuacrQ4gmZfERAvVplrhpvSxhf/cpAsWN7mhLNIve5cbg8CAgDpOdRtzDqn41fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rQg5rSkGA5Jv3iGSCkvxhnAV1yFI17dtOP2mSAYdv4=;
 b=CxVR15cohPQb+O6GX+A+KBbG7K7s46I4731b/Wq/4AaFlN5O8qmZYtUPpUzgUtmJ8UgFoElF9aWiPLN6YBVctx990JK1JtlGUtSGoH5VplHJq3AXpuT5h9M1GSwsQC/+2OaYk/orAbjppSla+WKXAoCXvhOyVCKokwq4EzrZr+g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BYAPR10MB3559.namprd10.prod.outlook.com (2603:10b6:a03:11e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Mon, 26 Apr
 2021 16:52:56 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4042.024; Mon, 26 Apr 2021
 16:52:56 +0000
Subject: Re: [PATCH v17 10/11] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210416092045.2215-1-allison.henderson@oracle.com>
 <20210416092045.2215-11-allison.henderson@oracle.com>
 <YIL+j3BmnDOEqHrp@bfoster> <85c61f76-81e1-9c03-3171-0f01759c46de@oracle.com>
 <20210424155645.GX3122264@magnolia> <YIaouQ2cWRcitiev@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <1e1939e2-8ab6-b1fb-4884-16cca58b6ccd@oracle.com>
Date:   Mon, 26 Apr 2021 09:52:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <YIaouQ2cWRcitiev@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.222.141]
X-ClientProxiedBy: BYAPR02CA0066.namprd02.prod.outlook.com
 (2603:10b6:a03:54::43) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.222.141) by BYAPR02CA0066.namprd02.prod.outlook.com (2603:10b6:a03:54::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Mon, 26 Apr 2021 16:52:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9161661-7b79-49f8-29a7-08d908d3bdbd
X-MS-TrafficTypeDiagnostic: BYAPR10MB3559:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3559B2CFD6FD7BD39A90678C95429@BYAPR10MB3559.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/lpLhHfVB/HrZmMVUddXmm8IXAlQ06fGjq3gPIR6+My6ezJwPfz6kQ1EGCeUYxLbcmx1sQyCxRJeJgzDznO64//nLuqS2/JpTqZumG3CeoO3iPVuG0L3EKL++Nt8mLmzFAW2xu8SHnUsMWd7OWtw10+2Zr4T8MdQltYpVu4jaamIHAtjPFy2HgB6cK0IKbWmw1H50QlHiQxfEBWi7o3FDa4E31JadPY1WFlSfOZJseKdYVE85F/WFe/W870gQCSr0GraE0stB3ETx2FeG7ktTMR5HT1qUeNQyGGzgdWo00Lh2oWK/uUIBwFj/tkHarkq5SPpO8ukVKRqXNerYNFuy5ubgDYZ/1mTXG4NlSEkf8iqz61lowFn2hVwdvQ7JsNQvvfKxXQacLUxmKrOV8X5SMKIf68N/tX6F9iyja9MlJWIRpSpn3fs9ny4hhFmEwwDT5k0q8/WOoeMpzG/DMikC8uBVHrMgyNFJUsj2t2EQnZ+YdUu37j/nT4ejou0LGM5xZjv1rFVoOx3dbIarkNEodGhOLeheInSmyaWM/9EfaHgJcDG8CLyo3rxx1VPgouZcbx59FLxObjPn0xNuT+Lt+ifve5Fayw0lEGrxdBMQHAWOoYymAmAYgb1qf2cgbsoO0eVJ/GrK7C9jHN30IY6VgK6cQ73bnlV8rmKUMSX2TyG0UOn+ax5PzzVq1oU+jdZ9OeIlJoGuFUtKuQ5+yvqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(396003)(376002)(38350700002)(38100700002)(16526019)(36756003)(956004)(186003)(83380400001)(2616005)(8676002)(31696002)(478600001)(31686004)(26005)(44832011)(86362001)(53546011)(5660300002)(66476007)(66556008)(110136005)(66946007)(6486002)(52116002)(2906002)(316002)(16576012)(30864003)(4326008)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a0tTWFQrRHVLRkNZTjd0akhURXhZK0tTL2pWYjhDVnplNS9uL3p6czFHVTlE?=
 =?utf-8?B?WHdOVkczYTRrdXJ3aDFSSStKZEpFSGNNemFVaTJFekdCeWVyY1crQis1WENL?=
 =?utf-8?B?TmhBeEVFZWJjQUJSanJBMUZhQi9VaXJwMWY2WmRkajlwVmVjTlJYUE40Mnpo?=
 =?utf-8?B?Umt2d3JuNy9sNUhkbCtmM0h0TnJZNnhvbEh4eXI2K1Z1MEVoeXFyQ1daZDQ4?=
 =?utf-8?B?VWRYSHpvcmJiVzdsZXRlaVhya215QnRKOG1INWMrc1dqcmc5d0tKTG1aREwz?=
 =?utf-8?B?ZmRGb1F2RG93MzZvNmtrMU9ibnI5bUxQNUZMU2VYeFVIa0M2UnNXempqR2lt?=
 =?utf-8?B?WXZpbEdWZjhQVTFKWDlVcDgzMGFNY1BkWXA3S2U1UC9OTFkyL3djclY3NUFW?=
 =?utf-8?B?UG5hdDhESkt0NkZ3Q0U0VUV5Z2l5V0c3dXlGejhsRitUdUo2RDJiRjZ3VGZP?=
 =?utf-8?B?Um1XOUV6WkhzejQycHQ0aWRLODNJR2JMRS95UWxaT1B6WnUvQVM3dnlQL2E5?=
 =?utf-8?B?azc4ZW5VK1IzOC9Kb20zNEpxRytuU1BPSmVKK2N5VytrV3JnbjdSWEppN3NK?=
 =?utf-8?B?dHNVRFl6OG1jeGRRamJwemR1eEthUmZzWXNNWi9IQkM5cnZoMWRsV21mSERE?=
 =?utf-8?B?ZXRTVjNvWE1INGRwZWxJMU14bm9KcGNsRnIzZmJVeEFYemxjOUVPckIwU3Rx?=
 =?utf-8?B?Si8wdWs3NU0yYVJoMHdNWkZ1V0g2MzRRZ1owMWlqRXpuVFdBdnAyUWVFOWhC?=
 =?utf-8?B?VmxXMHpQd0Q0Y0RKUm0zTDNkKy83SllEY3FTK1F0OTBvd0ZKRGNpMWJxR3kz?=
 =?utf-8?B?RVM4emF1T0cveWpDc3NvTUFXWkovOVJSWG9aeUtVbVpZcVBicXkyU3FNKzZJ?=
 =?utf-8?B?MEZtSmxRODQzaVdYRGc0bTQrWUFwNXJxM0VQTG95S2VrckpzM0MrMUIrZVBZ?=
 =?utf-8?B?NE1zUkQ0UUNTcEExU2ZyV1lzb2FwakpuMFQ3Mjh5K0IwWGFYVzVmTVdYUDlt?=
 =?utf-8?B?OEhCUDU0dUVOZlpyeG10MGZxU2VjVXJFZkFzQkltSzBUQTR4aUtkbmEyelN6?=
 =?utf-8?B?Zm9WclY4WDZUVHdxZkxRaUhCaDVSWjVrQURadnV2bjBMTmdKM2R6NkZjQ0Zk?=
 =?utf-8?B?K0RpNzNrUW05Y1J0bXgxVjBpU0dPOG9kN1BJRlJZUUpmRjFlZHhtYUdEUWw1?=
 =?utf-8?B?czFoazNNUUpheStzUnRqSjVjSlcvcFRvb2lScXBGU0tGYXBvUGp5eXFobVdS?=
 =?utf-8?B?NFMrNndTamRXZXhiZ1BXclJsNWpRSW5TSk1wNzJsV0RDbGRCU3ZCbE9UTE1x?=
 =?utf-8?B?Y0xzeGN5dVNlOHFZSDhVa0FaVm50ajI4NkNmeWxnZDBtTEUvYjVBWVBhRkFq?=
 =?utf-8?B?YTVEN3d1ZU1RNjVnb2NJMWNwRVdXUDJrZ3dkMWpFQ0dMQXNaUnlEbEx0V2sw?=
 =?utf-8?B?RXJvNGloMnd5bHdIa1RJeSttajJaTWNpM1lBQ3d2R3BaNVBTVlh0TjVPWlBk?=
 =?utf-8?B?eW9HTEhEMlZiWTI5dVM4bU1MenRhelQwdjhoTlMzRkxvNEQzMlB3TFNJKzFM?=
 =?utf-8?B?bXR4L1ZkWlYzZld5a2Y1bXFudUptRkdUOTRLcDVORi9oK1ZjemszaFlxM3Ja?=
 =?utf-8?B?L2FGc3JMMkVpeHNBUTgrcGQ2aXJPb3czL09lZmlNMG8rVGJMZW1WaXJxd1Zn?=
 =?utf-8?B?SUVpR3VWSTh5enZ1MGEwRGZiR2xuQnVHNjllZEVBOWc3Y0pETnh1WHFVUHp3?=
 =?utf-8?Q?PM884neZjf+Ph3/Im7MQbci3SpRDqSgdPlmgRlJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9161661-7b79-49f8-29a7-08d908d3bdbd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 16:52:56.5631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3iBEV6VjQiJ+wusUsAEF6ozHlm8jqf2nFii0ZCFshJn/7r0cGoE0G1RBOyIxPkFxxVuqK1Xj0CoZmDqS9nOns+tX/8d5mmP7xOIdJBCCHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3559
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104260129
X-Proofpoint-GUID: V-Fm5PUuQcfBu81zJ_96KFNE0KXcaKRs
X-Proofpoint-ORIG-GUID: V-Fm5PUuQcfBu81zJ_96KFNE0KXcaKRs
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9966 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260129
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/26/21 4:49 AM, Brian Foster wrote:
> On Sat, Apr 24, 2021 at 08:56:45AM -0700, Darrick J. Wong wrote:
>> On Fri, Apr 23, 2021 at 08:27:28PM -0700, Allison Henderson wrote:
>>>
>>>
>>> On 4/23/21 10:06 AM, Brian Foster wrote:
>>>> On Fri, Apr 16, 2021 at 02:20:44AM -0700, Allison Henderson wrote:
>>>>> This patch modifies the attr remove routines to be delay ready. This
>>>>> means they no longer roll or commit transactions, but instead return
>>>>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>>>>> this series, xfs_attr_remove_args is merged with
>>>>> xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
>>>>> This new version uses a sort of state machine like switch to keep track
>>>>> of where it was when EAGAIN was returned. A new version of
>>>>> xfs_attr_remove_args consists of a simple loop to refresh the
>>>>> transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
>>>>> flag is used to finish the transaction where ever the existing code used
>>>>> to.
>>>>>
>>>>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>>>>> version __xfs_attr_rmtval_remove. We will rename
>>>>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>>>>> done.
>>>>>
>>>>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>>>>> during a rename).  For reasons of preserving existing function, we
>>>>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>>>>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>>>>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>>>>> used and will be removed.
>>>>>
>>>>> This patch also adds a new struct xfs_delattr_context, which we will use
>>>>> to keep track of the current state of an attribute operation. The new
>>>>> xfs_delattr_state enum is used to track various operations that are in
>>>>> progress so that we know not to repeat them, and resume where we left
>>>>> off before EAGAIN was returned to cycle out the transaction. Other
>>>>> members take the place of local variables that need to retain their
>>>>> values across multiple function recalls.  See xfs_attr.h for a more
>>>>> detailed diagram of the states.
>>>>>
>>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>>> ---
>>>>>    fs/xfs/libxfs/xfs_attr.c        | 208 +++++++++++++++++++++++++++-------------
>>>>>    fs/xfs/libxfs/xfs_attr.h        | 131 +++++++++++++++++++++++++
>>>>>    fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>>>>    fs/xfs/libxfs/xfs_attr_remote.c |  48 ++++++----
>>>>>    fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>>>>>    fs/xfs/xfs_attr_inactive.c      |   2 +-
>>>>>    6 files changed, 305 insertions(+), 88 deletions(-)
>>>>>
>>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>>> index ed06b60..0bea8dd 100644
>>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>>> ...
>>>>> @@ -1231,70 +1262,117 @@ xfs_attr_node_remove_cleanup(
>>>>>    }
>>>>>    /*
>>>>> - * Remove a name from a B-tree attribute list.
>>>>> + * Remove the attribute specified in @args.
>>>>>     *
>>>>>     * This will involve walking down the Btree, and may involve joining
>>>>>     * leaf nodes and even joining intermediate nodes up to and including
>>>>>     * the root node (a special case of an intermediate node).
>>>>> + *
>>>>> + * This routine is meant to function as either an in-line or delayed operation,
>>>>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>>>>> + * functions will need to handle this, and recall the function until a
>>>>> + * successful error code is returned.
>>>>>     */
>>>>> -STATIC int
>>>>> -xfs_attr_node_removename(
>>>>> -	struct xfs_da_args	*args)
>>>>> +int
>>>>> +xfs_attr_remove_iter(
>>>>> +	struct xfs_delattr_context	*dac)
>>>>>    {
>>>>> -	struct xfs_da_state	*state;
>>>>> -	int			retval, error;
>>>>> -	struct xfs_inode	*dp = args->dp;
>>>>> +	struct xfs_da_args		*args = dac->da_args;
>>>>> +	struct xfs_da_state		*state = dac->da_state;
>>>>> +	int				retval, error;
>>>>> +	struct xfs_inode		*dp = args->dp;
>>>>>    	trace_xfs_attr_node_removename(args);
>>>> ...
>>>>> +	case XFS_DAS_CLNUP:
>>>>> +		retval = xfs_attr_node_remove_cleanup(args, state);
>>>>
>>>> This is a nit, but when reading the code the "cleanup" name gives the
>>>> impression that this is a resource cleanup or something along those
>>>> lines, when this is actually a primary component of the operation where
>>>> we remove the attr name. That took me a second to find. Could we tweak
>>>> the state and rename the helper to something like DAS_RMNAME  /
>>>> _node_remove_name() so the naming is a bit more explicit?
>>> Sure, this helper is actually added in patch 2 of this set.  I can rename it
>>> there?  People have already added their rvb's, but I'm assuming people are
>>> not bothered by small tweeks like that?  That way this patch just sort of
>>> moves it and XFS_DAS_CLNUP can turn into XFS_DAS_RMNAME here.
>>
>> <bikeshed> "RMNAME" looks too similar to "RENAME" for my old eyes, can
>> we please pick something else?  Like "RM_NAME", or "REMOVE_NAME" ?
>>
> 
> Either of those seem fine to me, FWIW. I think anything that expresses
> removal of the name/entry over the more generic "cleanup" name is an
> improvement..
> 
> Brian
Alrighty, lets go with RM_NAME then.  Will update.  Thanks for the feedback.

Allison

> 
>> --D
>>
>>>
>>>>
>>>>> -	/*
>>>>> -	 * Check to see if the tree needs to be collapsed.
>>>>> -	 */
>>>>> -	if (retval && (state->path.active > 1)) {
>>>>> -		error = xfs_da3_join(state);
>>>>> -		if (error)
>>>>> -			goto out;
>>>>> -		error = xfs_defer_finish(&args->trans);
>>>>> -		if (error)
>>>>> -			goto out;
>>>>>    		/*
>>>>> -		 * Commit the Btree join operation and start a new trans.
>>>>> +		 * Check to see if the tree needs to be collapsed. Set the flag
>>>>> +		 * to indicate that the calling function needs to move the
>>>>> +		 * shrink operation
>>>>>    		 */
>>>>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>>>>> -		if (error)
>>>>> -			goto out;
>>>>> -	}
>>>>> +		if (retval && (state->path.active > 1)) {
>>>>> +			error = xfs_da3_join(state);
>>>>> +			if (error)
>>>>> +				goto out;
>>>>> -	/*
>>>>> -	 * If the result is small enough, push it all into the inode.
>>>>> -	 */
>>>>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>>>> -		error = xfs_attr_node_shrink(args, state);
>>>>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>>>>> +			dac->dela_state = XFS_DAS_RM_SHRINK;
>>>>> +			return -EAGAIN;
>>>>> +		}
>>>>> +
>>>>> +		/* fallthrough */
>>>>> +	case XFS_DAS_RM_SHRINK:
>>>>> +		/*
>>>>> +		 * If the result is small enough, push it all into the inode.
>>>>> +		 */
>>>>> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>>>> +			error = xfs_attr_node_shrink(args, state);
>>>>> +
>>>>> +		break;
>>>>> +	default:
>>>>> +		ASSERT(0);
>>>>> +		error = -EINVAL;
>>>>> +		goto out;
>>>>> +	}
>>>>> +	if (error == -EAGAIN)
>>>>> +		return error;
>>>>>    out:
>>>>>    	if (state)
>>>>>    		xfs_da_state_free(state);
>>>> ...
>>>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>>>>> index 48d8e9c..908521e7 100644
>>>>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>>>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>>>> ...
>>>>> @@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
>>>>>    	 * Keep de-allocating extents until the remote-value region is gone.
>>>>>    	 */
>>>>>    	do {
>>>>> -		retval = __xfs_attr_rmtval_remove(args);
>>>>> -		if (retval && retval != -EAGAIN)
>>>>> -			return retval;
>>>>> +		error = __xfs_attr_rmtval_remove(&dac);
>>>>> +		if (error != -EAGAIN)
>>>>> +			break;
>>>>
>>>> Shouldn't this retain the (error && error != -EAGAIN) logic to roll the
>>>> transaction after the final unmap? Even if this is transient, it's
>>>> probably best to preserve behavior if this is unintentional.
>>> Sure, I dont think it's intentional, I think back in v10 we had a different
>>> arangement here with a helper inside the while() expression that had
>>> equivelent error handling logic.  But that got nak'd in the next review and
>>> I think I likley forgot to put back this handling.  Will fix.
>>>
>>>>
>>>> Otherwise my only remaining feedback was to add/tweak some comments that
>>>> I think make the iteration function easier to follow. I've appended a
>>>> diff for that. If you agree with the changes feel free to just fold them
>>>> in and/or tweak as necessary. With those various nits and Chandan's
>>>> feedback addressed, I think this patch looks pretty good.
>>> Sure, those all look reasonable.  Will add.  Thanks for the reviews!
>>> Allison
>>>
>>>>
>>>> Brian
>>>>
>>>> --- 8< ---
>>>>
>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>> index 0bea8dd34902..ee885c649c26 100644
>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>>> @@ -1289,14 +1289,21 @@ xfs_attr_remove_iter(
>>>>    		if (!xfs_inode_hasattr(dp))
>>>>    			return -ENOATTR;
>>>> +		/*
>>>> +		 * Shortform or leaf formats don't require transaction rolls and
>>>> +		 * thus state transitions. Call the right helper and return.
>>>> +		 */
>>>>    		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>>>>    			ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>>>>    			return xfs_attr_shortform_remove(args);
>>>>    		}
>>>> -
>>>>    		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>>>    			return xfs_attr_leaf_removename(args);
>>>> +		/*
>>>> +		 * Node format may require transaction rolls. Set up the
>>>> +		 * state context and fall into the state machine.
>>>> +		 */
>>>>    		if (!dac->da_state) {
>>>>    			error = xfs_attr_node_removename_setup(dac);
>>>>    			if (error)
>>>> @@ -1304,7 +1311,7 @@ xfs_attr_remove_iter(
>>>>    			state = dac->da_state;
>>>>    		}
>>>> -	/* fallthrough */
>>>> +		/* fallthrough */
>>>>    	case XFS_DAS_RMTBLK:
>>>>    		dac->dela_state = XFS_DAS_RMTBLK;
>>>> @@ -1316,7 +1323,8 @@ xfs_attr_remove_iter(
>>>>    		 */
>>>>    		if (args->rmtblkno > 0) {
>>>>    			/*
>>>> -			 * May return -EAGAIN. Remove blocks until 0 is returned
>>>> +			 * May return -EAGAIN. Roll and repeat until all remote
>>>> +			 * blocks are removed.
>>>>    			 */
>>>>    			error = __xfs_attr_rmtval_remove(dac);
>>>>    			if (error == -EAGAIN)
>>>> @@ -1325,26 +1333,26 @@ xfs_attr_remove_iter(
>>>>    				goto out;
>>>>    			/*
>>>> -			 * Refill the state structure with buffers, the prior
>>>> -			 * calls released our buffers.
>>>> +			 * Refill the state structure with buffers (the prior
>>>> +			 * calls released our buffers) and close out this
>>>> +			 * transaction before proceeding.
>>>>    			 */
>>>>    			ASSERT(args->rmtblkno == 0);
>>>>    			error = xfs_attr_refillstate(state);
>>>>    			if (error)
>>>>    				goto out;
>>>> -
>>>>    			dac->dela_state = XFS_DAS_CLNUP;
>>>>    			dac->flags |= XFS_DAC_DEFER_FINISH;
>>>>    			return -EAGAIN;
>>>>    		}
>>>> +		/* fallthrough */
>>>>    	case XFS_DAS_CLNUP:
>>>>    		retval = xfs_attr_node_remove_cleanup(args, state);
>>>>    		/*
>>>> -		 * Check to see if the tree needs to be collapsed. Set the flag
>>>> -		 * to indicate that the calling function needs to move the
>>>> -		 * shrink operation
>>>> +		 * Check to see if the tree needs to be collapsed. If so, roll
>>>> +		 * the transacton and fall into the shrink state.
>>>>    		 */
>>>>    		if (retval && (state->path.active > 1)) {
>>>>    			error = xfs_da3_join(state);
>>>> @@ -1360,10 +1368,12 @@ xfs_attr_remove_iter(
>>>>    	case XFS_DAS_RM_SHRINK:
>>>>    		/*
>>>>    		 * If the result is small enough, push it all into the inode.
>>>> +		 * This is our final state so it's safe to return a dirty
>>>> +		 * transaction.
>>>>    		 */
>>>>    		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>>>    			error = xfs_attr_node_shrink(args, state);
>>>> -
>>>> +		ASSERT(error != -EAGAIN);
>>>>    		break;
>>>>    	default:
>>>>    		ASSERT(0);
>>>>
>>
> 
