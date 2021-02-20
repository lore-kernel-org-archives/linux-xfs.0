Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FFDFC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 03:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09A2464E38
	for <linux-xfs@archiver.kernel.org>; Sat, 20 Feb 2021 03:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBTDpg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Feb 2021 22:45:36 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39944 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhBTDpd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Feb 2021 22:45:33 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11K3ihVo122960;
        Sat, 20 Feb 2021 03:44:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tyEj7aJMHZZn1ImGbO/8CGvLGGAss8koe0U6rt1j5vA=;
 b=UrhGsjQvG8z8EpUfJyp8qlnhwCekvVbkapAfKWOo8ZXhRlAsoKvsMdUjfAkKAwTBdyjC
 bT33+6lYkRU0WJfvPF8dmDpsTZjSSlObvC7X3QY/tePi2YXPmmsfoiiGd14jk80VKtOm
 NaVaETNwVzakSWhoCxq9/fPS755xFlrzmiifAD8jfn3GHG4ILum8PNjtu3Wvejp+JcNl
 L8DZniRkXbOeZ8u/WKEd2VGXROfPZFj/d+WbnkwcamPYIrmKZwEE3aZ/IetG7ilomb+t
 3R4t5VRc+MPDytu3adYecBJs34o23ueT+oYfPAAdk7DpTWC+vGZBMdIaXEXdvQaGq7XV NA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36tqxb84t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Feb 2021 03:44:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11K3dnla169672;
        Sat, 20 Feb 2021 03:44:42 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2057.outbound.protection.outlook.com [104.47.37.57])
        by userp3020.oracle.com with ESMTP id 36tsrh16v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Feb 2021 03:44:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuAyjIaySL9jpsTWBxCIqMjaKnI0wqy4UGlu44BavoTYU8XealjuLf+5uELBN082VD43qw4Ndj78dgeJj06YNTfXBH396Wo1hYTUXh1sd9cPAk1HnUq82+TpPj8SdgPACFf+e1qXslzN1GwmeicEvJPkRyEY7xADpflqDCM2r+8D3/FOWvuWgyB/eMBwdSCbwuu9Vgo89CkWt2mtQ7H+94gL6KzyyiPM6a2o0N5y4Q3ykeXNP06wJ4uKXX5TlxCT6PcN/vyc+UQXHdpk6BwXgI4LiXE25dNFex2OHScZ5lZ5LJ+f+OFq4NUdTE4QdKP/wV1759kwSTNGA3ljWiCHKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tyEj7aJMHZZn1ImGbO/8CGvLGGAss8koe0U6rt1j5vA=;
 b=FlHzmRKsluZC/T7niCU1gACLIs2N0KJ/IAWCehR8ryBSB8JYijQYVrLT08roOWUMa9UacJiO1AkzG23hudCqW9wZmS75jpPUm2KOIffMZONl2sIJmNHXXZ95xP0FmSw8GhmllUsQZsGq/1dTgQVcUeRAjOMBX3Hpq1FpR/dPc9nv4VdjPqwwUfqm4pmiszo7Le1BUcNU8xJI9ofGs0/wiyxRzF95ogtL2FS8ePsaUB07NMjPnYfJeEmyC0dnddgdkqBXc8M6Dggwuo4C4Q3tPhg5nL2vDHNK+UDCN7rb3vyQPYT10lfxi6fNYojJ3AcYG4cq1wU9Hmbb5EuJRxsm6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tyEj7aJMHZZn1ImGbO/8CGvLGGAss8koe0U6rt1j5vA=;
 b=SNJeQA7L69hcW2kvQTWVIk33RjDVDxD9g0rExYfGVbRh2bKHzqgqr/lHbHIcdby9T3SCjLgDvgEwCILfyjC4x1W631MQpTZBndurFB6hax58Iip0aJwWaqWnptjpRPKBT5yfWPLqu8r0ZxxH3bBhy/FAiuJY807r+uuk4SZRw3Y=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4177.namprd10.prod.outlook.com (2603:10b6:a03:205::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Sat, 20 Feb
 2021 03:44:38 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::f4a1:6643:4c93:2a9f%3]) with mapi id 15.20.3846.042; Sat, 20 Feb 2021
 03:44:38 +0000
Subject: Re: [PATCH v2] xfs: don't nest transactions when scanning for
 eofblocks
To:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20210219042940.GB7193@magnolia> <20210219172341.GD7193@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <00949be3-a79b-46de-503f-c0a5b45f8a36@oracle.com>
Date:   Fri, 19 Feb 2021 20:44:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210219172341.GD7193@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.223.248]
X-ClientProxiedBy: SJ0PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::16) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.223] (67.1.223.248) by SJ0PR03CA0041.namprd03.prod.outlook.com (2603:10b6:a03:33e::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Sat, 20 Feb 2021 03:44:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9aa2e69-aa0d-4cd2-46a1-08d8d551d92a
X-MS-TrafficTypeDiagnostic: BY5PR10MB4177:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4177468296D2A1652D059C9E95839@BY5PR10MB4177.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:111;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zAs6PXtPNBE9tNYGDLue0046tJEwK4vyWy0FNoVNsWv/U10naeqrjreZoquTBT9QcbwmqxbWx7XWzvYhpW4JK9NUoxlgqW7GMShLdfHSISF35oIJ5quwtaK0M9YfQR/JTfCeLowM6op/Xu+1t6L7Ht+RNHVmo3rBSolIU3BuALLKUe34eHRyRessA0a3QW4qtdsB/jckZNxLZrhK4DGyZ8p68y7Ki5rWz46lcksq9oEkM7UUun5k3cT/Bd2y6ughEC2mLgOzZARfukyDEpGbIWDEWqPFtxBulfhuuyWJnlL4xYY+wMp7PeH+IJXKgZuYaforUM5MHAzL7p4XaZe+ylEzOuoLTlJh9GvQbWWs/NhadfPWX0Lq/z0Q7thG6FdPMhOscWpUN3Zt0ntDYn8+nD+DE9yYppyo7tsIfjdhLAL8fDmSEaCyHeOrAbJtQ8qnb81vtoSqQK/99mx0b92lpbCLMuVEYBCUcXmcMEgxFQFveFk//631hRA/tpI7JvIXrKlOwnLEsaV7D5oQu8zkMP7hCYkRO4EkQC4CdyT/UgcQc3OBD89hjIV/PpMXrDoYKUrzrgIUAbzuhVPTgMiFiPBqGceBG9cdD6quwQR/T8WN5nh9wkZh8kUbpp+pOWKpDfTwe9CyNnyWw3LEF3Fq6peGsxI3gm0C0I4i0aVreY8QOoAQaHSQ+LLl9IwDaHD4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(39860400002)(396003)(66556008)(16526019)(66476007)(956004)(478600001)(66946007)(86362001)(110136005)(44832011)(54906003)(2906002)(53546011)(4326008)(5660300002)(31696002)(16576012)(316002)(31686004)(2616005)(8936002)(966005)(52116002)(6486002)(36756003)(8676002)(186003)(83380400001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z0lzdnhYL243TmJwd1lFTEE3dTRhTjdLS0RVdDRCVEUrYnlUUXZhRjlLTnMy?=
 =?utf-8?B?MkRUd092SVNreGt5QW5IVTE3RlZHc0FUSmlJWjZQMlYyNHBqNndGNjFKRWx0?=
 =?utf-8?B?R2M5QzdLeWQrTDdkSVpudVFqbjljWnFRcmJrU200WGxxN0hndWwyazVxWklq?=
 =?utf-8?B?WENUeHZqLzFlUkxEMjRCSmIwWHU4a21kbkpkTFE0MTREa1RKUmxQYlNQYlZR?=
 =?utf-8?B?TktLWVB6NFhac0YxVERMekRVa1NteVVUZzUzN2VSZnJ6Z2ZsUXpYUFhYVWRC?=
 =?utf-8?B?NVgvNkZ4V20ya2N1cnl2dFpqMUUweGtya2RsWlBsUGI1N0ZESFg4c2RVMk9S?=
 =?utf-8?B?SUJLU0JWTUg2UkpYd0k2WGYwQlFuYUJUNGJDUjBsaStCRytqL0pnUlNnU1lx?=
 =?utf-8?B?R20rSmtHbmtTcDRQMVB6Q0xuNjJzVW5xQktyaWZad21qVm9wcVdmaExvZXNZ?=
 =?utf-8?B?Y2hpNG1wbi9jcjdKRGxPSjZXdFcrcjlTMXJRamp5bzJCOGQ3ZjMvaG1Jd1JN?=
 =?utf-8?B?Y2EweFBPMEV2cFN6cGJmendVdWVOMVRVQ2FpL0kvaE92bkVidUdOV3pqODBq?=
 =?utf-8?B?SFJSeDRvNzV4Q3JyYmhxdWJaZnhseEJjS1I4Rnhva1hBdlhmdmcycGY5Ukdl?=
 =?utf-8?B?a1BSK3dpMzhyWjZKa3B6aVU0NVhZTUZYM0IySEt1Ymh1b2JjSEp2TVVBaHRn?=
 =?utf-8?B?SndUU1B5aHlMSzFSTTJ4ZzUydmlRTU5lR21aVmlJbmtyK1czb0ZGZXF3Znky?=
 =?utf-8?B?QXpMSnU3eTM1cExub1pXVmpqWWVSeUpiSS9zWmE3dVBpMDJSQ3MyMGZTMHlV?=
 =?utf-8?B?TzZGaW9DQUNtNnNQMUsvTjQyYnYwQ3ZDKy83eVkrOENOZTJYR3RGQit1eWsw?=
 =?utf-8?B?NXgrSzY3SGdQN1FSZkdaWlJLaDB6OWlZV3dHdFI5TWw5SnZCY3JwdStuL0tq?=
 =?utf-8?B?WWxCc0tDSVdadnFIRnoyYUNaZDRqaGtGRkJJNlAwaGpZODg4NkhzZFVDSUF4?=
 =?utf-8?B?cVhxbUJKU0Nwc0I3OG92OFhseElMTnFmZ2J3cXB2OEwzS1VydFNtQUo4M09S?=
 =?utf-8?B?dksxbXh5Lyt4aWcvbzRUNlh6WFd4cE1FWDE1bnpyNUpETVJQRyt4NU8yK0pz?=
 =?utf-8?B?RExJTjdGR2tDSlZMTWllUkwxRDQ2V1lDbUZVTGFwVW02N3kyU3g5YWFSSkl3?=
 =?utf-8?B?RXg5akRlWFlUVTJEQ3pBcnh2TWVIRzBYSk1Ud3dTbHR3L0FmbWRrWVdHSzFq?=
 =?utf-8?B?MlhldUpKeGhuT21FNjhpd0hoWGYrNG42MTdaVlpBSmdEeDFLeHJmM1phWnRP?=
 =?utf-8?B?NGcyTXU1bXBnQTFpbHpmQW12dXFDa0wzYzZuSVltWVdxZ1RtWExzZEtKQ04w?=
 =?utf-8?B?d2ZMMDM1bENDck0xZGRwNXh2S1FXdW5WUUNYeFVIZzRaTElOMTR4MDlaS1k3?=
 =?utf-8?B?bVRzSkpGWHN1bmMwSWpoTVRlYzFmMlYzRW96VXdGZEtaaENoRDZPV2E4Z3dp?=
 =?utf-8?B?S0VoK3BFcUpidmVkSXhZbGo4b1c5NU91Y1pmWVQvSmltZWk5VHBoV1BlTlRM?=
 =?utf-8?B?YXpIdHdCbHJzU2xJUHRVd0F2Q2U2U1RIMEx1RTMzM2NoaC9TakREYUwvS3BO?=
 =?utf-8?B?Y0xpWklMcSs5bk0zc0ZzMWpWNDJSeUgxM09VMUFlZVVYdnBlQ3Y0UC9Yekl3?=
 =?utf-8?B?OXZ3REJPYjdicHhzTEQ4dEY5R2hmMFhNOHNPa1ZhUE5NVzVNelRoK0pEWms1?=
 =?utf-8?Q?dF6Zx5TXfRhpYMtPHKUqLUzY6Wg2S8cAlp1VOUp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9aa2e69-aa0d-4cd2-46a1-08d8d551d92a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2021 03:44:38.7340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ukrfbfEUqCMiu2gng5tK7J+eGqeSrafK7Y0zEmR4vtDHE47mp72LfNM1vgAobpBRL+hpLYC8vQZmJCHwCd9FST+yfqvalLv1FfeZAatub+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4177
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102200029
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9900 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102200029
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/19/21 10:23 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Brian Foster reported a lockdep warning on xfs/167:
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.11.0-rc4 #35 Tainted: G        W I
> --------------------------------------------
> fsstress/17733 is trying to acquire lock:
> ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_free_eofblocks+0x104/0x1d0 [xfs]
> 
> but task is already holding lock:
> ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_trans_alloc_inode+0x5f/0x160 [xfs]
> 
> stack backtrace:
> CPU: 38 PID: 17733 Comm: fsstress Tainted: G        W I       5.11.0-rc4 #35
> Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
> Call Trace:
>   dump_stack+0x8b/0xb0
>   __lock_acquire.cold+0x159/0x2ab
>   lock_acquire+0x116/0x370
>   xfs_trans_alloc+0x1ad/0x310 [xfs]
>   xfs_free_eofblocks+0x104/0x1d0 [xfs]
>   xfs_blockgc_scan_inode+0x24/0x60 [xfs]
>   xfs_inode_walk_ag+0x202/0x4b0 [xfs]
>   xfs_inode_walk+0x66/0xc0 [xfs]
>   xfs_trans_alloc+0x160/0x310 [xfs]
>   xfs_trans_alloc_inode+0x5f/0x160 [xfs]
>   xfs_alloc_file_space+0x105/0x300 [xfs]
>   xfs_file_fallocate+0x270/0x460 [xfs]
>   vfs_fallocate+0x14d/0x3d0
>   __x64_sys_fallocate+0x3e/0x70
>   do_syscall_64+0x33/0x40
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The cause of this is the new code that spurs a scan to garbage collect
> speculative preallocations if we fail to reserve enough blocks while
> allocating a transaction.  While the warning itself is a fairly benign
> lockdep complaint, it does expose a potential livelock if the rwsem
> behavior ever changes with regards to nesting read locks when someone's
> waiting for a write lock.
> 
> Fix this by freeing the transaction and jumping back to xfs_trans_alloc
> like this patch in the V4 submission[1].
> 
> [1] https://urldefense.com/v3/__https://lore.kernel.org/linux-xfs/161142798066.2171939.9311024588681972086.stgit@magnolia/__;!!GqivPVa7Brio!ONLN-B-M-uqN8aJAN8zMDHDQZ6wwDyF4BSpjkT9j3mV2Zxe5zVD0vgjTWvPFRO2tzEpN$
> 
> Fixes: a1a7d05a0576 ("xfs: flush speculative space allocations when we run out of space")
> Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Ok, makes sense
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
> v2: fix commit message
> ---
>   fs/xfs/xfs_trans.c |   13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 44f72c09c203..377f3961d7ed 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -260,6 +260,7 @@ xfs_trans_alloc(
>   	struct xfs_trans	**tpp)
>   {
>   	struct xfs_trans	*tp;
> +	bool			want_retry = true;
>   	int			error;
>   
>   	/*
> @@ -267,6 +268,7 @@ xfs_trans_alloc(
>   	 * GFP_NOFS allocation context so that we avoid lockdep false positives
>   	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
>   	 */
> +retry:
>   	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
>   	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
>   		sb_start_intwrite(mp->m_super);
> @@ -289,7 +291,9 @@ xfs_trans_alloc(
>   	tp->t_firstblock = NULLFSBLOCK;
>   
>   	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> -	if (error == -ENOSPC) {
> +	if (error == -ENOSPC && want_retry) {
> +		xfs_trans_cancel(tp);
> +
>   		/*
>   		 * We weren't able to reserve enough space for the transaction.
>   		 * Flush the other speculative space allocations to free space.
> @@ -297,8 +301,11 @@ xfs_trans_alloc(
>   		 * other locks.
>   		 */
>   		error = xfs_blockgc_free_space(mp, NULL);
> -		if (!error)
> -			error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> +		if (error)
> +			return error;
> +
> +		want_retry = false;
> +		goto retry;
>   	}
>   	if (error) {
>   		xfs_trans_cancel(tp);
> 
