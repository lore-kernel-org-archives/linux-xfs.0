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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1F4C433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDF88610A0
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 09:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbhDBJmg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 05:42:36 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55746 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhDBJmf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 05:42:35 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329Sreu009209;
        Fri, 2 Apr 2021 09:42:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=F+U06yWgagBsW763bFM+wUmVrUPC8vpIEFblYUU6jMA=;
 b=mcBRUYSJoqSnXZQZYFFwhc4MUsmK/JVN2qSgiydsTROLCYvoDpqxbRGtLe2P+/Bbeqky
 rwyfVrcpGiO2FeCcwGQMweD/i3uU21A77r/tlP1w4ZHWWwIZX+96tyAbCn+f3Agfep8z
 t+irRY0kFJrWlyyRdjIs+nieLyXzwje3cb/AqK+Z3y8IeaGjpjGZEzR2ujMXJocj+e4/
 2M3tJkQ3aLKvtYDmCPtaBfb5Z9We13E7scSUu4nx8cTizT3w6YXV0hWIOyijfLsADcuj
 exLW7rZHEjbnWAijCNO4aFhAv+9IGQMAffHkFRe2sd9jyLMYNHj7I6wvpLTY7DW5vyTM Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37n33dv87k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:42:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1329V1vT033840;
        Fri, 2 Apr 2021 09:42:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by aserp3020.oracle.com with ESMTP id 37n2acaaaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 09:42:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyWToMZ+7mx9wg9Te62Yn3gkS4OkBLeGowxtNlGOKZYuFEQCduwowMxhibkg1GR9wV8igatBo7pd41ebUoP+VbANddMdcQpC6Q8aPBSniM84LzjP1dfVNCSrfLpeWG64g64N5ZzZYFjIhKZ8LxGu7adNsb9Z7Hu6LZuKF3vTzqGTkNZg1fDY7Iko4RfmsJrlhv7fDFywvqQMaJlXmmqJd1W69Sw0a4ZIVQsBj38vjJPJyb8bjtC0nV5dCB8PgQwbwmtiC239StlVzRyGeDc3GCDkuzXO7ZhAiqN09ZFqNRC33UyDr/+rzpjCM+Lgz013hIkjY+RTcWzLhnzcjnJV9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+U06yWgagBsW763bFM+wUmVrUPC8vpIEFblYUU6jMA=;
 b=Hqa6UawtGVSqdByLFdW7TjgwYSazoLnKLIaj1avMdWCs7dHL0tkSijM8vEZseqTrzhYcgB0LeeNxxIQhCKJxfwj3xz/t5vr/P9PJNVXvyq5o7cfEkvlULYQlQrHXxK7pBIJ2ZfAXK/K2gZgYTifbbsrfZ9Mrnfz8wjC6EdNx3jMj0u8uBNuP4keeswiNydU68xhdzoKmr3hoXdh0ZKbbsuEf+/GncGlHxI0K8pQWMoC3KGKnQAqKrKTLnQFkCWzhkEXFs3MHyRLTFCUkh9HD5n2c7LapP+p2w/WWnwMTne6OWV0jSjAzyxMe2OhtpCpqq7FlEGqAXfG9YpnAPhSCQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+U06yWgagBsW763bFM+wUmVrUPC8vpIEFblYUU6jMA=;
 b=sXcyaSXHLwL9QeUj3XCzsecPA+jZqsmdwHbx+K4I/nhH7NV08OpKl/b5pHbsIlH6VG94OCqod3b6W+tuYVmCjlPVmwTVCrzT2Sw0rzUqi9tz3yMvnDuJFE+MTrMnYbgym5Fn1z4Z2NGDT3NehiTslZFCpVJiQGGeJn8OrQqWJvY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4813.namprd10.prod.outlook.com (2603:10b6:a03:2d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Fri, 2 Apr
 2021 09:42:30 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.3999.032; Fri, 2 Apr 2021
 09:42:30 +0000
Subject: Re: [PATCH v16 10/11] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-11-allison.henderson@oracle.com>
 <YGX7FxrMvV01xEzZ@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <b01f7ab5-3752-f19d-7280-e11ede30e613@oracle.com>
Date:   Fri, 2 Apr 2021 02:42:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YGX7FxrMvV01xEzZ@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: BYAPR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:a03:117::37) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.223.248) by BYAPR08CA0060.namprd08.prod.outlook.com (2603:10b6:a03:117::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29 via Frontend Transport; Fri, 2 Apr 2021 09:42:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9954bb5c-7911-4a11-116b-08d8f5bba1df
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4813:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB48139A5002C468488CE669EC957A9@SJ0PR10MB4813.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hg8s1VoCKY0qH8xRZFGNeVtlBWxRsYimCKvcQh3QjQtl0ymKtm5iIuaCnXVr/FwgUkJ1an+BfR+OaKyISqKjFgOXn2LgOzIW23n365h8mhZb/wJw3uvfeDrcqR9uNcZjKYHhcwMutCg4rAziZa5991EP/Ziq7CbnHJI2XQ8hlq0IkrN9WZwtX2IikGidZdVZ/BU4a/CVhkWKuePI/nh5Elhr3Nx9P8n4w8Jd0loZ8RDIcW7HOOLK4uSQx8RCjvhM1rDYm9xa/+PwkRbtU9lrH6C/LtiXZiPThME4LYwB9dG8ThOiOPCm3V+7alCcAJ0qDm0SA88gEr4fEarl2h7gyZn+b6U8sGQZeMCeilEpTzQ2xRshJ8uxzQRPW51a8Ul9DqwTgS7anNncG8BNHX4+LdulzJ5pHCIjbY1LQeXmJAbfrDQvgUl5FRBz0TVbI0lCnc69zMRIWZt0JwnjGdXc3z/rmdC6eKCIav9DbztjMMqBsIdqXp8dA/PNEZ1hVkHZI0FljZNqjlST/BzLeA7/dvOGiwr+10IIxqPgbxYpHYkhMfGR5v2WsZn8NnYMc/9i43nB4jf2kst67ikIBUsBEIaNYkkICf+8SMhXScLBp/4wesFWG7SHlT4UNhmmH6fRBjsZMsEhfyOzR9ij+iR2sh3jjjdo9EMdYikQiWFqAx5cL+JOFVg28G3T3Pyo16LC3YBRHhMv+nB9hY/vpuV0WA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(366004)(346002)(38100700001)(86362001)(956004)(2616005)(16526019)(8936002)(26005)(2906002)(31686004)(186003)(8676002)(31696002)(36756003)(83380400001)(44832011)(53546011)(316002)(6916009)(478600001)(16576012)(5660300002)(4326008)(66476007)(66556008)(66946007)(52116002)(30864003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L016TkVWT2NFWmpVK1JwM1pHK2ovL1lDLy9NM0xITVUvL1ZpanlEZzFXd1o4?=
 =?utf-8?B?SHhjY3NqQklHTVRzYS9wMkdPNzBLMWVFREhHdkQ1SXJNNXFUaEc5U3M3L3dR?=
 =?utf-8?B?a05URGw1WFR1VlRTMFFxUTBCc0RqcWcvb2lrOEp3V2ZCcW5ZdnQ4ZERkajRr?=
 =?utf-8?B?YmdFemI1SnNISzBrb3JzUVN0MitIQTlIS2hxbkt4Z2NrZXJPMjRRWGpSUU5r?=
 =?utf-8?B?ZkZXRjM3c2NlOVlpWGdFTXU1Ujdqai8zMC92NG5UOGp4bHJXSjIxWmxZTGNw?=
 =?utf-8?B?a2w2YktQL3g3WWVDQ0Jpc3BqYVJzQ1BzeG5hVUNMVmJuMWlPSXI2bXdNaFlj?=
 =?utf-8?B?ZXArcWlTeW0rQlF1M2ViY2JpQVcySEhCSzVtbk9JUFpPY2N1V3hJOU9mT3d3?=
 =?utf-8?B?YjA1SEtITVdIMEtLWk9Md1RsbWVFSktmMGV5RzFyTHVGblFydWhvWExKdGR4?=
 =?utf-8?B?c3Y1YWVCV0Z5S2pDYXFlYXkvTThWaE5XbzJkM016NGh5Qi9oSXBQanRXSDFw?=
 =?utf-8?B?M1ArVEVqNVV2bHR4MkZVRGtpZkx2Q3g4cm5DMHRUTmZlWm11SkljK2NlQ0l1?=
 =?utf-8?B?Z2NCcys0WEE1djhlS0J4Z2h2Y3E1Q2FTS00ycG5Xb1BybHFxdTB3MU10QWVo?=
 =?utf-8?B?bk5yS25BTWd4SUVURjk0V2hDZGEwZFFnUmxmQ25kU1A5TCtBc1E5R2JtbmQ3?=
 =?utf-8?B?V1k1TWdXRVYydGM1OVNoN2hRNkxwV2JRc2JEQXV6K2ZYNDhVdUdMbGFaWklY?=
 =?utf-8?B?NFlVNldvYXRhblNMbFpBZWRHV3pTOS91b1pNQ1BkUzBwMnNySml4ZWVDdVJP?=
 =?utf-8?B?TXBha3FPS1EwbjY3NVV4ZFlkNzNkNHI2NEg4d2xhZVJqUkEwYzZOa0xyQTNU?=
 =?utf-8?B?Q1d3Wi96eUVXck00KzBQZzl6WUhqeDhJM1N4NVpLS1VGYkQxdFlIbS81RmZL?=
 =?utf-8?B?d2FmOFhqak9BTVZUb0ZXV3RQNVJOWTFmSDNXOEkycW5FZ0RqZ3FmRTFSZDNX?=
 =?utf-8?B?OGVjdGlBVnFmWk95K2ZnMjRHaldBdjF4VjlUaEQ0UjYxbzVjeWlQd2RaRXZO?=
 =?utf-8?B?WUZjYXBHd09teWlHOW9DSXNKb0ZuenBJMzJaUVAyc0J5cnB0VjdXeXQ1QUQr?=
 =?utf-8?B?TDhTR3VFbWpoM3JyNlNjbE5hUmhvdmM4WjN5L0dwVUl3RjNscHVlWFhMRjBv?=
 =?utf-8?B?d3JkRUpLZXNRN0hRTmhXeE9mbi8rMDNLditZa2RwMzlheTdYbENsR1BDeUlw?=
 =?utf-8?B?d25nV3lGMmIrMFlVYy8wTG5WQ3dIeXNBU2F5Tm0yNjdtdm9kRkhoamZ5emUr?=
 =?utf-8?B?NE0xZmkxMGdFYlM3QmNnakJsa0FFYU9hNElzd1VhMEt5WFVIU1RHSEpKS0dG?=
 =?utf-8?B?cHlhNEg3Q1ZsMG5aUzZrZWdnaHZtS29EMEdwaldON2NTZVY2VVVZdDNYc3Nn?=
 =?utf-8?B?TjhqRkFEREY4bXp2bmdFWWs1VThUR0tPNTBBdDk3dkg0V3pMQ2JOaStOTGI2?=
 =?utf-8?B?Y2JsdjFYa1dIMS9MNzFSYm41UHo5eVN3ODVjKzZob1c2elZlclFBZEF2TVpW?=
 =?utf-8?B?VmJySGl1SWNYZ2FKN3ZqWXhYNnd5eE5abHI3bnBkS0tLSTUwY3lsMjByTFE1?=
 =?utf-8?B?Y2ozTVZFeldyeldScE9sSTlUclZLb1JhTEhLNGkrVEtSSUV6V1Z1R0pYTXNy?=
 =?utf-8?B?S0NsUjZqenZadWRDVGF0K2kxKzJuMUEwcjNHbzBLdkpnb1J1K24zK2ZveWNU?=
 =?utf-8?Q?ZGY2RER06uJdP3sHGpAFJTh5WaMKcXrbFL09D2A?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9954bb5c-7911-4a11-116b-08d8f5bba1df
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 09:42:29.7769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1WzyYGIh+VmREkJohkNSsuWQSLJpicJcpbhMx9fjW5fw5cVBOrGsxA0HGgS8OrXjsDkvDM5veSNeywb0VmhWpbGw8xRYUDPu7Bsbo6TgORk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4813
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020067
X-Proofpoint-GUID: U_aqK333cOYnIzbP_Gens-i-U2A-hhSZ
X-Proofpoint-ORIG-GUID: U_aqK333cOYnIzbP_Gens-i-U2A-hhSZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020067
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/1/21 9:55 AM, Brian Foster wrote:
> On Thu, Mar 25, 2021 at 05:33:07PM -0700, Allison Henderson wrote:
>> This patch modifies the attr remove routines to be delay ready. This
>> means they no longer roll or commit transactions, but instead return
>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>> this series, xfs_attr_remove_args is merged with
>> xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
>> This new version uses a sort of state machine like switch to keep track
>> of where it was when EAGAIN was returned. A new version of
>> xfs_attr_remove_args consists of a simple loop to refresh the
>> transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
>> flag is used to finish the transaction where ever the existing code used
>> to.
>>
>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>> version __xfs_attr_rmtval_remove. We will rename
>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>> done.
>>
>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>> during a rename).  For reasons of preserving existing function, we
>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>> used and will be removed.
>>
>> This patch also adds a new struct xfs_delattr_context, which we will use
>> to keep track of the current state of an attribute operation. The new
>> xfs_delattr_state enum is used to track various operations that are in
>> progress so that we know not to repeat them, and resume where we left
>> off before EAGAIN was returned to cycle out the transaction. Other
>> members take the place of local variables that need to retain their
>> values across multiple function recalls.  See xfs_attr.h for a more
>> detailed diagram of the states.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 206 +++++++++++++++++++++++++++-------------
>>   fs/xfs/libxfs/xfs_attr.h        | 125 ++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>   fs/xfs/libxfs/xfs_attr_remote.c |  48 ++++++----
>>   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>>   fs/xfs/xfs_attr_inactive.c      |   2 +-
>>   6 files changed, 297 insertions(+), 88 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 41accd5..4a73691 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -221,6 +220,32 @@ xfs_attr_is_shortform(
>>   		ip->i_afp->if_nextents == 0);
>>   }
>>   
>> +/*
>> + * Checks to see if a delayed attribute transaction should be rolled.  If so,
>> + * also checks for a defer finish.  Transaction is finished and rolled as
>> + * needed, and returns true of false if the delayed operation should continue.
>> + */
> 
> Outdated comment wrt to the return value.
Ok, will drop last line here

> 
>> +int
>> +xfs_attr_trans_roll(
>> +	struct xfs_delattr_context	*dac)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error;
>> +
>> +	if (dac->flags & XFS_DAC_DEFER_FINISH) {
>> +		/*
>> +		 * The caller wants us to finish all the deferred ops so that we
>> +		 * avoid pinning the log tail with a large number of deferred
>> +		 * ops.
>> +		 */
>> +		dac->flags &= ~XFS_DAC_DEFER_FINISH;
>> +		error = xfs_defer_finish(&args->trans);
>> +	} else
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +
>> +	return error;
>> +}
>> +
>>   STATIC int
>>   xfs_attr_set_fmt(
>>   	struct xfs_da_args	*args)
> ...
>> @@ -1232,70 +1264,114 @@ xfs_attr_node_remove_cleanup(
>>   }
>>   
>>   /*
>> - * Remove a name from a B-tree attribute list.
>> + * Remove the attribute specified in @args.
>>    *
>>    * This will involve walking down the Btree, and may involve joining
>>    * leaf nodes and even joining intermediate nodes up to and including
>>    * the root node (a special case of an intermediate node).
>> + *
>> + * This routine is meant to function as either an in-line or delayed operation,
>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>> + * functions will need to handle this, and recall the function until a
>> + * successful error code is returned.
>>    */
>> -STATIC int
>> -xfs_attr_node_removename(
>> -	struct xfs_da_args	*args)
>> +int
>> +xfs_attr_remove_iter(
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	struct xfs_da_state	*state;
>> -	int			retval, error;
>> -	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		*state = dac->da_state;
>> +	int				retval, error;
>> +	struct xfs_inode		*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>>   
>> -	error = xfs_attr_node_removename_setup(args, &state);
>> -	if (error)
>> -		goto out;
>> +	switch (dac->dela_state) {
>> +	case XFS_DAS_UNINIT:
>> +		if (!xfs_inode_hasattr(dp))
>> +			return -ENOATTR;
>>   
>> -	/*
>> -	 * If there is an out-of-line value, de-allocate the blocks.
>> -	 * This is done before we remove the attribute so that we don't
>> -	 * overflow the maximum size of a transaction and/or hit a deadlock.
>> -	 */
>> -	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_remove(args);
>> -		if (error)
>> -			goto out;
>> +		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>> +			ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> +			return xfs_attr_shortform_remove(args);
>> +		}
>> +
>> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +			return xfs_attr_leaf_removename(args);
>> +
>> +	/* fallthrough */
>> +	case XFS_DAS_RMTBLK:
>> +		dac->dela_state = XFS_DAS_RMTBLK;
>> +
>> +		if (!dac->da_state) {
>> +			error = xfs_attr_node_removename_setup(dac);
>> +			if (error)
>> +				goto out;
> 
> Do we need the goto here if _removename_setup() frees state on error (or
> is the latter change necessary)?
I think we can safely return here.  Will update

> 
>> +		}
>> +		state = dac->da_state;
> 
> Also, can this fold into the above if (!da_state) branch? Or maybe the
> whole setup branch pulled up into the UNINIT state? Not a big deal, but
> it does look a little out of place in the RMTBLK state.
Sure, it should be ok, there isnt any EAGAINs here, so it shouldnt make 
a difference

> 
>>   
>>   		/*
>> -		 * Refill the state structure with buffers, the prior calls
>> -		 * released our buffers.
>> +		 * If there is an out-of-line value, de-allocate the blocks.
>> +		 * This is done before we remove the attribute so that we don't
>> +		 * overflow the maximum size of a transaction and/or hit a
>> +		 * deadlock.
>>   		 */
>> -		error = xfs_attr_refillstate(state);
>> -		if (error)
>> -			goto out;
>> -	}
>> -	retval = xfs_attr_node_remove_cleanup(args, state);
>> +		if (args->rmtblkno > 0) {
>> +			/*
>> +			 * May return -EAGAIN. Remove blocks until
>> +			 * args->rmtblkno == 0
>> +			 */
>> +			error = __xfs_attr_rmtval_remove(dac);
>> +			if (error)
>> +				break;
> 
> I feel that the difference between a break and goto out might confuse
> some of the error handling. Right now, it looks like the exit path
> handles either scenario, so we could presumably do something like the
> following at the end of the function:
> 
> 	if (error != -EAGAIN && state)
> 		xfs_da_state_free(state);
> 	return error;
> 
> ... and just ditch the label. Alternatively we could retain the label above
> the state check, but just use it consistently throughout the function.
> 
Either will work?  I think I'd prefer the gotos over the breaks though, 
I just think it reads easier.  The switch is sort of big, so I think the 
gotos make it a little more clear in that we're exiting the function 
without having to skim all the way to the bottom.

> Other than those few nits, this one looks pretty good to me.
Great, will update.  Thanks!

Allison

> 
> Brian
> 
>> +
>> +			/*
>> +			 * Refill the state structure with buffers, the prior
>> +			 * calls released our buffers.
>> +			 */
>> +			ASSERT(args->rmtblkno == 0);
>> +			error = xfs_attr_refillstate(state);
>> +			if (error)
>> +				goto out;
>> +
>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		retval = xfs_attr_node_remove_cleanup(args, state);
>>   
>> -	/*
>> -	 * Check to see if the tree needs to be collapsed.
>> -	 */
>> -	if (retval && (state->path.active > 1)) {
>> -		error = xfs_da3_join(state);
>> -		if (error)
>> -			goto out;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			goto out;
>>   		/*
>> -		 * Commit the Btree join operation and start a new trans.
>> +		 * Check to see if the tree needs to be collapsed. Set the flag
>> +		 * to indicate that the calling function needs to move the
>> +		 * shrink operation
>>   		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			goto out;
>> -	}
>> +		if (retval && (state->path.active > 1)) {
>> +			error = xfs_da3_join(state);
>> +			if (error)
>> +				goto out;
>>   
>> -	/*
>> -	 * If the result is small enough, push it all into the inode.
>> -	 */
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> -		error = xfs_attr_node_shrink(args, state);
>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			dac->dela_state = XFS_DAS_RM_SHRINK;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		/* fallthrough */
>> +	case XFS_DAS_RM_SHRINK:
>> +		/*
>> +		 * If the result is small enough, push it all into the inode.
>> +		 */
>> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +			error = xfs_attr_node_shrink(args, state);
>> +
>> +		break;
>> +	default:
>> +		ASSERT(0);
>> +		error = -EINVAL;
>> +		goto out;
>> +	}
>>   
>> +	if (error == -EAGAIN)
>> +		return error;
>>   out:
>>   	if (state)
>>   		xfs_da_state_free(state);
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 3e97a93..92a6a50 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -74,6 +74,127 @@ struct xfs_attr_list_context {
>>   };
>>   
>>   
>> +/*
>> + * ========================================================================
>> + * Structure used to pass context around among the delayed routines.
>> + * ========================================================================
>> + */
>> +
>> +/*
>> + * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
>> + * states indicate places where the function would return -EAGAIN, and then
>> + * immediately resume from after being recalled by the calling function. States
>> + * marked as a "subroutine state" indicate that they belong to a subroutine, and
>> + * so the calling function needs to pass them back to that subroutine to allow
>> + * it to finish where it left off. But they otherwise do not have a role in the
>> + * calling function other than just passing through.
>> + *
>> + * xfs_attr_remove_iter()
>> + *              │
>> + *              v
>> + *        have attr to remove? ──n──> done
>> + *              │
>> + *              y
>> + *              │
>> + *              v
>> + *        are we short form? ──y──> xfs_attr_shortform_remove ──> done
>> + *              │
>> + *              n
>> + *              │
>> + *              V
>> + *        are we leaf form? ──y──> xfs_attr_leaf_removename ──> done
>> + *              │
>> + *              n
>> + *              │
>> + *              V
>> + *   ┌── need to setup state?
>> + *   │          │
>> + *   n          y
>> + *   │          │
>> + *   │          v
>> + *   │ find attr and get state
>> + *   │    attr has blks? ───n────???
>> + *   │          │                v
>> + *   │          │         find and invalidate
>> + *   │          y         the blocks. mark
>> + *   │          │         attr incomplete
>> + *   │          ├────────────────┘
>> + *   └──────────┤
>> + *              │
>> + *              v
>> + *      Have blks to remove? ─────y────???
>> + *              │       ^      remove the blks
>> + *              │       │              │
>> + *              │       │              v
>> + *              │       │        refill the state
>> + *              n       │              │
>> + *              │       │              v
>> + *              │       │         XFS_DAS_RMTBLK
>> + *              │       └─────  re-enter with one
>> + *              │               less blk to remove
>> + *              │
>> + *              v
>> + *       remove leaf and
>> + *       update hash with
>> + *   xfs_attr_node_remove_cleanup
>> + *              │
>> + *              v
>> + *           need to
>> + *        shrink tree? ─n─???
>> + *              │         │
>> + *              y         │
>> + *              │         │
>> + *              v         │
>> + *          join leaf     │
>> + *              │         │
>> + *              v         │
>> + *      XFS_DAS_RM_SHRINK │
>> + *              │         │
>> + *              v         │
>> + *       do the shrink    │
>> + *              │         │
>> + *              v         │
>> + *          free state <──┘
>> + *              │
>> + *              v
>> + *            done
>> + *
>> + */
>> +
>> +/*
>> + * Enum values for xfs_delattr_context.da_state
>> + *
>> + * These values are used by delayed attribute operations to keep track  of where
>> + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
>> + * calling function to roll the transaction, and then recall the subroutine to
>> + * finish the operation.  The enum is then used by the subroutine to jump back
>> + * to where it was and resume executing where it left off.
>> + */
>> +enum xfs_delattr_state {
>> +	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
>> +	XFS_DAS_RMTBLK,		      /* Removing remote blks */
>> +	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
>> +};
>> +
>> +/*
>> + * Defines for xfs_delattr_context.flags
>> + */
>> +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>> +
>> +/*
>> + * Context used for keeping track of delayed attribute operations
>> + */
>> +struct xfs_delattr_context {
>> +	struct xfs_da_args      *da_args;
>> +
>> +	/* Used in xfs_attr_node_removename to roll through removing blocks */
>> +	struct xfs_da_state     *da_state;
>> +
>> +	/* Used to keep track of current state of delayed operation */
>> +	unsigned int            flags;
>> +	enum xfs_delattr_state  dela_state;
>> +};
>> +
>>   /*========================================================================
>>    * Function prototypes for the kernel.
>>    *========================================================================*/
>> @@ -91,6 +212,10 @@ int xfs_attr_set(struct xfs_da_args *args);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>> +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>> +int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>> +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>> +			      struct xfs_da_args *args);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index d6ef69a..3780141 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -19,8 +19,8 @@
>>   #include "xfs_bmap_btree.h"
>>   #include "xfs_bmap.h"
>>   #include "xfs_attr_sf.h"
>> -#include "xfs_attr_remote.h"
>>   #include "xfs_attr.h"
>> +#include "xfs_attr_remote.h"
>>   #include "xfs_attr_leaf.h"
>>   #include "xfs_error.h"
>>   #include "xfs_trace.h"
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 48d8e9c..908521e7 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
>>    */
>>   int
>>   xfs_attr_rmtval_remove(
>> -	struct xfs_da_args      *args)
>> +	struct xfs_da_args		*args)
>>   {
>> -	int			error;
>> -	int			retval;
>> +	int				error;
>> +	struct xfs_delattr_context	dac  = {
>> +		.da_args	= args,
>> +	};
>>   
>>   	trace_xfs_attr_rmtval_remove(args);
>>   
>> @@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
>>   	 * Keep de-allocating extents until the remote-value region is gone.
>>   	 */
>>   	do {
>> -		retval = __xfs_attr_rmtval_remove(args);
>> -		if (retval && retval != -EAGAIN)
>> -			return retval;
>> +		error = __xfs_attr_rmtval_remove(&dac);
>> +		if (error != -EAGAIN)
>> +			break;
>>   
>> -		/*
>> -		 * Close out trans and start the next one in the chain.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		error = xfs_attr_trans_roll(&dac);
>>   		if (error)
>>   			return error;
>> -	} while (retval == -EAGAIN);
>> +	} while (true);
>>   
>> -	return 0;
>> +	return error;
>>   }
>>   
>>   /*
>>    * Remove the value associated with an attribute by deleting the out-of-line
>> - * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>> + * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
>>    * transaction and re-call the function
>>    */
>>   int
>>   __xfs_attr_rmtval_remove(
>> -	struct xfs_da_args	*args)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	int			error, done;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error, done;
>>   
>>   	/*
>>   	 * Unmap value blocks for this attr.
>> @@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
>>   	if (error)
>>   		return error;
>>   
>> -	error = xfs_defer_finish(&args->trans);
>> -	if (error)
>> -		return error;
>> -
>> -	if (!done)
>> +	/*
>> +	 * We don't need an explicit state here to pick up where we left off. We
>> +	 * can figure it out using the !done return code. Calling function only
>> +	 * needs to keep recalling this routine until we indicate to stop by
>> +	 * returning anything other than -EAGAIN. The actual value of
>> +	 * attr->xattri_dela_state may be some value reminiscent of the calling
>> +	 * function, but it's value is irrelevant with in the context of this
>> +	 * function. Once we are done here, the next state is set as needed
>> +	 * by the parent
>> +	 */
>> +	if (!done) {
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   		return -EAGAIN;
>> +	}
>>   
>>   	return error;
>>   }
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 9eee615..002fd30 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>   		xfs_buf_flags_t incore_flags);
>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
>> index bfad669..aaa7e66 100644
>> --- a/fs/xfs/xfs_attr_inactive.c
>> +++ b/fs/xfs/xfs_attr_inactive.c
>> @@ -15,10 +15,10 @@
>>   #include "xfs_da_format.h"
>>   #include "xfs_da_btree.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_attr.h"
>>   #include "xfs_attr_remote.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_bmap.h"
>> -#include "xfs_attr.h"
>>   #include "xfs_attr_leaf.h"
>>   #include "xfs_quota.h"
>>   #include "xfs_dir2.h"
>> -- 
>> 2.7.4
>>
> 
