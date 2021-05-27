Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049FCC4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 16:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCE99613C3
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 16:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbhE0Q4d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 12:56:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40856 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234487AbhE0Q4b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 12:56:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14RGiI7s046541;
        Thu, 27 May 2021 16:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SlfyQ52c3ljhfZZfS+BjUYLgicjqdJfDoGjagPAfs0A=;
 b=bcO4zk76btKLtTJPk6zJbqsnE+jjRA6qbVyR9/BUKtHbkJbXbJcdG+8Ng6rqVbI2D/ze
 ktB5TOLv2XU6oC54+MSLExn22iPacCxSsc8bSNQJZbCr1oqy2z37OSflGof0jXmMuXQW
 zNVxCwI4eoFPdXjfEjOIDUQu63dY6QtRNR8XgEysjU32gFpsx/NMHFCdfAD8phi83iWe
 eqf4NEK6Xs8RajTYruRVSpBFWyfIaHSVxsYm2wbzBoUtTbNcvWhYIpQunJz7O6/OZCzf
 mZtSxfOHGQqqAhZ6KHrf19S4rZbfEf1ZHBBSnWxm3NLC5oNM/Rn23TgOKD5YiB/lWILa Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38ptkpcrns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 16:54:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14RGoBEh193574;
        Thu, 27 May 2021 16:54:54 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by aserp3030.oracle.com with ESMTP id 38pr0drpur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 16:54:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dB/p0A0aL06pI5ZRNLxieQYL7W+cdXGtx9+KC85gmdaWtWlqYOcfQUzhnpusuc6xmSy08+vaswZyu4hLdoT5mt63kQSovtGtsFfsFAATK4b0f72+kKHServmsWS04Vq/SSy/pOvbaYjw+J1WNheo4K2l0sm5fMnD11KFC3d6haYCs+8dLjI7y7JQjb7Zkt62MjVS1TcIKozRdR9v+zpr6f08bqmhGNPKbdb87r6n1sdbSrUioNolRjk+7GRUtrbHN5dMQZC7ZurogZmkuYj3DfPY0x4ohok8C/8t3UpTQkyC23Ff797DmBN+fdCFQuK5/mjtGViRHRUR7SE+wHxflg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlfyQ52c3ljhfZZfS+BjUYLgicjqdJfDoGjagPAfs0A=;
 b=nupxN5XU5XrNzTQduOMlzI/u2yVabDWdnEjMMaJ4XVInlYcI1lST4QQVjtJ/JMgXuhSsuDCedgQ2rgZdxEGiCq8UuL6mjw5p3e9noGb8XNXaHgqouQ/pjKvWiTugmYsAQHzFZoB3Xz5qVxEilXBlLCQprwSUoNBz8QS8wHdy9zlcoYcf7FsgF1ymGKc35oX/Kqqe9IYNQlTxg33nn063NiNla5Ol+QaESdtsj5Tl5k9QPyHLQZNoCDFXQ/FJnMx1SsVuhnaI8fmSTEU71HU0Oe8craafikhCNPmc+jqoIYhF/G/4u21+Z1m2GkfUt6kg6IPw5aUtv7jdmyhoWi9gaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlfyQ52c3ljhfZZfS+BjUYLgicjqdJfDoGjagPAfs0A=;
 b=I7h/BhIt20WZxsnLS2EUgmoJ9vO8SUA13nHfJruP85aV/S/UnCpXUcEsAIjCed5kTZIIe6/ebQKyswK4U9zvGMAKK3/dGVut5bHX4C/mKmon3+0mMayuILvVZP+mQQiei8ULZK4SLcQRO3unF+QdDDN59ffRIxx9mY0Rtflj3mo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by SJ0PR10MB4495.namprd10.prod.outlook.com (2603:10b6:a03:2d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 27 May
 2021 16:54:52 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::55a0:c9fb:d00:cd88%3]) with mapi id 15.20.4173.022; Thu, 27 May 2021
 16:54:52 +0000
Subject: Re: [PATCH v19 00/14] Delay Ready Attributes
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210525195504.7332-1-allison.henderson@oracle.com>
 <20210526181933.GA202121@locust>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <67088fde-e95d-22ce-e4ef-b868500d7aee@oracle.com>
Date:   Thu, 27 May 2021 09:54:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210526181933.GA202121@locust>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.1.210.54]
X-ClientProxiedBy: SJ0PR03CA0247.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::12) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.226] (67.1.210.54) by SJ0PR03CA0247.namprd03.prod.outlook.com (2603:10b6:a03:3a0::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 16:54:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c480374-73a5-47ac-a7b5-08d921302550
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4495:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4495498C36782EADC5D510F095239@SJ0PR10MB4495.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:651;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHYaJF4jhhPh/4c+i2fI3VwUIOIzmo2LRHkIp0x93ZREwSHW/eL4y4Yal7Pr0II2IKkGT+4dUqOYjCHGp8s12rQ0BubqJiyfZ9RCIEg5gpu2s0eNmcZ20A73EXcVzMg7lYb5m4rLc/O6KEHjaCzrUSpE2TN7/OwrP8rRUQDm7xNGUKWtBJ7M2itW+9qjSArpVF0ClIBi3HQPbKMkh6WugPOzce++x7tO7UpFmUki/TsRoMkmK3461lpmJec6p+8seSE8nnyPFjJp0wkcj3zvZCxihuF/6s0waUPn8u+g8Rdl5p5xVTark+DwZwAAKScagTSyZQwuvsX0/737ETIP7q1ulPaVFTKJioBlUA63hI8PnExUUcFgVCSPyDh6o0NaLMn3t6AZPAyIpWQdWMcOhMfGwFab+7HC92D648mwvi7nWKysSdNr2W7nBaxas0HL/unU2oa/drt0TVL6YWVU7TYdfnE+4RpxeCqHcbGTM2vxTpxGAQ2IIf4nrmg/SFxdTIrr0WLYC5vEfH7kvFpfF5dpIzAotj5vf2xakU4RV8/BwPxNCPRwSr1SiK+I4qEdZk+k+omKb+dbw07L5erk5VxCl0ZYVu9nYQ+j6/cneA8tsz5PYx8fa+EHYvyrOQfm0Nu+0VS2qVBTifNnjut65YLPiUUbZ/yn/KdOSBlbjnVt7Dto2myXnFeZW84w6Ghojw9T6loK8BmXgOqCnJQz/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(366004)(396003)(30864003)(2616005)(86362001)(956004)(26005)(16526019)(52116002)(6486002)(44832011)(38350700002)(8676002)(38100700002)(186003)(36756003)(316002)(478600001)(16576012)(31696002)(6916009)(66476007)(66556008)(45080400002)(53546011)(66946007)(31686004)(4326008)(83380400001)(5660300002)(8936002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WUdyKzFIZXl6b1diNW8xWlZRUUF6YmJCcEc1ekRvTW1HVFN4RVZnT3JFK3lh?=
 =?utf-8?B?aGhHZTNSNXd3ZFRBdjJJYVdIdjBwaVpqME1QNE96S2c1U3lDUXJ5K2hSZnBZ?=
 =?utf-8?B?aVBoTUE0SytCSCtvS3NBWk9Pa3lBSEg0a0g0Z2lIVWZZYTFFRG1FSXRBQXpm?=
 =?utf-8?B?MlhGUTdMZ3ZaRGpWZGxUSGdrZ1ZxcU9LS0t1dzdyU3V0NktPdGszTWorVnMw?=
 =?utf-8?B?M3RzTVp4aXpvUW5UUUFLQ3hhVkJQNFZIUnVVaDIremp6RnowWFV5QU9FUlpj?=
 =?utf-8?B?T2x6UmNQakF2eHE2ZmZ1MnM3WFVqa05NSmMwVVdGYWlHeG5VcUhrMml5YjN6?=
 =?utf-8?B?WnI4eG1BTVpxaEhoNFMyTUJudVNoWk9PM0xsVm5NSFd5NGFKRVdNWWJ4ZHln?=
 =?utf-8?B?UnlZRVlRQkY2eVdjM2UzZ3JBbFZ0Nis1TTFEQmhDbkU4OEZmT0J5OWtPeUd4?=
 =?utf-8?B?L2dTNkozV2VoRFQvSjE5V0h0NkdncTNYeDFHTmE1WUYyaDVqck50OHdZazFy?=
 =?utf-8?B?Z1kvTXFPbUpYZCs0dGpmR1VBMjQ1azRmNElJQ05XN3JRL2gxWU9IYXIzRDJ6?=
 =?utf-8?B?bFVaM0Q3bjIxbnpScWplQ0N1eHRHTGhPaWRsek9kOWFGWjRTMVA5aTBXSyt2?=
 =?utf-8?B?ZmpXcG1hSlNlc1pPV1lHNWZaMGpjdUpKM3doRCtDSHllelZUZSswSWRRUEZP?=
 =?utf-8?B?bTlVVzh1ZFZ5SlBRWmZiTHpvZVRRd2JQTkVZUGwwTTJBejZyOWROd2cxNzln?=
 =?utf-8?B?bHpQVURyYi9ISjQ5akhQUWpheE5JOHR6OTBsSDlYeVppN1VkejJaTUwrSmxD?=
 =?utf-8?B?M2JXbWVSYkdCdXRjZCsvdGl5ZHhYTUFDTko4ZnZvdXRyZVFMdkg3L0VIWHVP?=
 =?utf-8?B?VDdhQVVwZnFHS3JFN3FxK2w0V2hkZmNqa3plWDVpejdZQ2VtQ2dBeFhoaHlz?=
 =?utf-8?B?dWhpZHN4WU10QTVWcTdjWjcvR0w4Z2FNN3RNUDVGcDh5UEJwREZYSFgyRExC?=
 =?utf-8?B?L1JiaUZGc1lHcXVGcXVCajhSQ3VjeUw2WUpkcUR4WDRxMUJIR1hEeGo3cXNk?=
 =?utf-8?B?TDRwdys2WkFtNS9lK056VU10SHc1UklYUHZ0RzhZZnNKd3R4ZnFCRHBNZFl1?=
 =?utf-8?B?RzNlT1JEakNseTRkaVc0bS9UNE1KdHVQWUFPQUxlYkRyVGYxNy8xdjV1VDZH?=
 =?utf-8?B?dDgveVhKUUVtUzYwMG50SVkycTd3L2hzYXUvaFQ3NEd1bmZmZFl1TFU4ZUhZ?=
 =?utf-8?B?a2pSUmFHNnE3QlpkZS9NdkhXaTFVMXVNY2tBSVRlaTM4bmZ6aDlkUXM4UU1L?=
 =?utf-8?B?WEptMWRYRFBvUmZKdGhtK3orRzBINkluRkJid0RnME1hQ0J4ZVEycGRpQ3Qz?=
 =?utf-8?B?bzhRcHpMWG1TYWxZRWpsbG5PVE5OR0RNSGpzckRVUkNQb2h4MFBuK0RZbDNy?=
 =?utf-8?B?dXQzN0dSeUJORXJObzhzWHpnNG1UTHNvZFJSVmpHQ0ZtUzBueHFZanBpa0l6?=
 =?utf-8?B?L2IwOEVIRjYzVmlWQ0RWSGNPcE1SejFjMTY3Yk1Mb29uQ2pIY2VnQ0VYZDRo?=
 =?utf-8?B?bGJuZ0lmNWx3enNtRHY5dVZFQjlkelB2RW8zWVlEVHhSOHk3bFZRQnRvOHRq?=
 =?utf-8?B?cXAwVHJjVXo1UzBJT1YxaWhhWjVNVE1hc1dzWDJTaERsa1o2NkdsWEJOQUhO?=
 =?utf-8?B?MHUweWxvN3F3TzN5bkl1NGF1UG5BOE55Z21GTGdZcHJqNDY1OTVvc2JNMkh1?=
 =?utf-8?Q?gQzAE7vc96fOBuQXJLeudYqVbp7Ij1hGjUe4Xlg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c480374-73a5-47ac-a7b5-08d921302550
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 16:54:52.0404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1/56zL8MKqMK0dEwbbASG+O77I3rKlFyXwopVyGMqazFL4SFEdnZpTR1z+n3M3F/CIhRTgRuO2hF2XKa1eGF9xhx/k++UHM/0EU4Yz5iyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4495
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270109
X-Proofpoint-GUID: vpJc3EUmEzZbpNrXn1nRPUs-S-hxc3iK
X-Proofpoint-ORIG-GUID: vpJc3EUmEzZbpNrXn1nRPUs-S-hxc3iK
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9997 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270108
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/26/21 11:19 AM, Darrick J. Wong wrote:
> On Tue, May 25, 2021 at 12:54:50PM -0700, Allison Henderson wrote:
>> Hi all,
>>
>> This set is a subset of a larger series for Dealyed Attributes. Which is a
>> subset of a yet larger series for parent pointers. Delayed attributes allow
>> attribute operations (set and remove) to be logged and committed in the same
>> way that other delayed operations do. This allows more complex operations (like
>> parent pointers) to be broken up into multiple smaller transactions. To do
>> this, the existing attr operations must be modified to operate as a delayed
>> operation.  This means that they cannot roll, commit, or finish transactions.
>> Instead, they return -EAGAIN to allow the calling function to handle the
>> transaction.  In this series, we focus on only the delayed attribute portion.
>> We will introduce parent pointers in a later set.
> 
> Somewhere in here, this introduced a regression that I can reproduce
> pretty easily when running:
> 
> # FSTYP=xfs ./check -overlay generic/020
Ok, I am able to reproduce with the same command.  Should be reguarly 
testing with these parameters?  Usually I just run ./check -g attr

> 
> [ 1093.136172] XFS: Assertion failed: args->rmtblkno == 0, file: fs/xfs/libxfs/xfs_attr.c, line: 1434
> [ 1093.139776] ------------[ cut here ]------------
> [ 1093.141590] WARNING: CPU: 3 PID: 12697 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
> [ 1093.144841] Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set ip_set_hash_mac ip_set nfnetlink bfq ip6table_filter ip6_tables iptable_filter pvpanic_mmio pvpanic sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet [last unloaded: xfs]
> [ 1093.153636] CPU: 3 PID: 12697 Comm: attr Tainted: G        W         5.13.0-rc2-djwx #rc2
> [ 1093.156094] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [ 1093.158530] RIP: 0010:assfail+0x3c/0x40 [xfs]
> [ 1093.159987] Code: 48 a2 3f a0 e8 81 f9 ff ff 8a 1d 7b e9 0b 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 a0 57 49 a0 e8 db c9 00 e1 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
> [ 1093.164680] RSP: 0018:ffffc90001a0fa90 EFLAGS: 00010246
> [ 1093.166021] RAX: 0000000000000000 RBX: ffffc90001a0fa00 RCX: 0000000000000000
> [ 1093.167761] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa03ea6d5
> [ 1093.169461] RBP: ffff88804b6c4d20 R08: 0000000000000000 R09: 000000000000000a
> [ 1093.171095] R10: 000000000000000a R11: f000000000000000 R12: 0000000000000000
> [ 1093.172687] R13: ffffc90001a0fb70 R14: ffff88800abe4c00 R15: 0000000000000000
> [ 1093.174267] FS:  00007f8c3494f740(0000) GS:ffff88807e100000(0000) knlGS:0000000000000000
> [ 1093.176031] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1093.177250] CR2: 00007f8c34a57710 CR3: 000000004b455005 CR4: 00000000001706a0
> [ 1093.178759] Call Trace:
> [ 1093.179328]  xfs_attr_remove_iter+0x25d/0x270 [xfs]
> [ 1093.180387]  xfs_attr_set+0x2ff/0x430 [xfs]
> [ 1093.181340]  xfs_xattr_set+0x89/0xd0 [xfs]
> [ 1093.182269]  __vfs_removexattr+0x52/0x70
> [ 1093.183062]  __vfs_removexattr_locked+0xb8/0x140
> [ 1093.183957]  vfs_removexattr+0x56/0x100
> [ 1093.184729]  ovl_xattr_set+0x131/0x1d0 [overlay]
> [ 1093.185654]  __vfs_removexattr+0x52/0x70
> [ 1093.186419]  __vfs_removexattr_locked+0xb8/0x140
> [ 1093.187300]  vfs_removexattr+0x56/0x100
> [ 1093.188028]  removexattr+0x58/0x90
> [ 1093.188672]  ? __check_object_size+0xc8/0x280
> [ 1093.189513]  ? strncpy_from_user+0x47/0x180
> [ 1093.190302]  ? preempt_count_add+0x50/0xa0
> [ 1093.191119]  ? __mnt_want_write+0x65/0x90
> [ 1093.191867]  path_removexattr+0x9e/0xc0
> [ 1093.192584]  __x64_sys_lremovexattr+0x14/0x20
> [ 1093.193395]  do_syscall_64+0x3a/0x70
> [ 1093.194067]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1093.195017] RIP: 0033:0x7f8c34a7207b
> [ 1093.195713] Code: 73 01 c3 48 8b 0d 15 ae 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 c6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e5 ad 0c 00 f7 d8 64 89 01 48
> [ 1093.199072] RSP: 002b:00007ffc9f3248f8 EFLAGS: 00000202 ORIG_RAX: 00000000000000c6
> [ 1093.200454] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f8c34a7207b
> [ 1093.201776] RDX: 0000000000000072 RSI: 00007ffc9f324910 RDI: 00007ffc9f3261a0
> [ 1093.203121] RBP: 00007ffc9f326196 R08: 0000000000000000 R09: 00007ffc9f324910
> [ 1093.204441] R10: 00007f8c34b3dbe0 R11: 0000000000000202 R12: 00007ffc9f3261a0
> [ 1093.205754] R13: 00007ffc9f324910 R14: 0000000000000000 R15: 0000000000000001
> [ 1093.207095] ---[ end trace d5f6b816d902441c ]---
> [ 1093.208039] XFS: Assertion failed: bp->b_transp == tp, file: fs/xfs/xfs_trans_buf.c, line: 450
> [ 1093.209609] ------------[ cut here ]------------
> [ 1093.210483] WARNING: CPU: 3 PID: 12697 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
> [ 1093.212095] Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set ip_set_hash_mac ip_set nfnetlink bfq ip6table_filter ip6_tables iptable_filter pvpanic_mmio pvpanic sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet [last unloaded: xfs]
> [ 1093.217174] CPU: 3 PID: 12697 Comm: attr Tainted: G        W         5.13.0-rc2-djwx #rc2
> [ 1093.218658] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [ 1093.220280] RIP: 0010:assfail+0x3c/0x40 [xfs]
> [ 1093.221204] Code: 48 a2 3f a0 e8 81 f9 ff ff 8a 1d 7b e9 0b 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 a0 57 49 a0 e8 db c9 00 e1 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
> [ 1093.224534] RSP: 0018:ffffc90001a0f988 EFLAGS: 00010246
> [ 1093.225502] RAX: 0000000000000000 RBX: ffff88804e004700 RCX: 0000000000000000
> [ 1093.226823] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa03ea6d5
> [ 1093.228106] RBP: ffff88804e9fee00 R08: 0000000000000000 R09: 000000000000000a
> [ 1093.228952] R10: 000000000000000a R11: f000000000000000 R12: ffff888042f11740
> [ 1093.229726] R13: 0000000000000fdc R14: ffff888042f11740 R15: ffff88804e004738
> [ 1093.230500] FS:  00007f8c3494f740(0000) GS:ffff88807e100000(0000) knlGS:0000000000000000
> [ 1093.231391] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1093.232033] CR2: 00007f8c34a57710 CR3: 000000004b455005 CR4: 00000000001706a0
> [ 1093.232811] Call Trace:
> [ 1093.233115]  xfs_trans_dirty_buf+0xbe/0x120 [xfs]
> [ 1093.233742]  xfs_trans_log_buf+0x4c/0x100 [xfs]
> [ 1093.234349]  xfs_attr3_leaf_remove+0x2b5/0xc30 [xfs]
> [ 1093.235001]  ? xfs_trans_add_item+0x6b/0x180 [xfs]
> [ 1093.235628]  xfs_attr_node_removename+0x3d/0x90 [xfs]
> [ 1093.236273]  xfs_attr_remove_iter+0x50/0x270 [xfs]
> [ 1093.236891]  xfs_attr_set+0x2ff/0x430 [xfs]
> [ 1093.237445]  xfs_xattr_set+0x89/0xd0 [xfs]
> [ 1093.238010]  __vfs_removexattr+0x52/0x70
> [ 1093.238460]  __vfs_removexattr_locked+0xb8/0x140
> [ 1093.239009]  vfs_removexattr+0x56/0x100
> [ 1093.239452]  ovl_xattr_set+0x131/0x1d0 [overlay]
> [ 1093.239979]  __vfs_removexattr+0x52/0x70
> [ 1093.240430]  __vfs_removexattr_locked+0xb8/0x140
> [ 1093.240949]  vfs_removexattr+0x56/0x100
> [ 1093.241389]  removexattr+0x58/0x90
> [ 1093.241786]  ? __check_object_size+0xc8/0x280
> [ 1093.242286]  ? strncpy_from_user+0x47/0x180
> [ 1093.242780]  ? preempt_count_add+0x50/0xa0
> [ 1093.243252]  ? __mnt_want_write+0x65/0x90
> [ 1093.243708]  path_removexattr+0x9e/0xc0
> [ 1093.244153]  __x64_sys_lremovexattr+0x14/0x20
> [ 1093.244647]  do_syscall_64+0x3a/0x70
> [ 1093.245064]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1093.245630] RIP: 0033:0x7f8c34a7207b
> [ 1093.246047] Code: 73 01 c3 48 8b 0d 15 ae 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 c6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e5 ad 0c 00 f7 d8 64 89 01 48
> [ 1093.248025] RSP: 002b:00007ffc9f3248f8 EFLAGS: 00000202 ORIG_RAX: 00000000000000c6
> [ 1093.248843] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f8c34a7207b
> [ 1093.249621] RDX: 0000000000000072 RSI: 00007ffc9f324910 RDI: 00007ffc9f3261a0
> [ 1093.250395] RBP: 00007ffc9f326196 R08: 0000000000000000 R09: 00007ffc9f324910
> [ 1093.251191] R10: 00007f8c34b3dbe0 R11: 0000000000000202 R12: 00007ffc9f3261a0
> [ 1093.251976] R13: 00007ffc9f324910 R14: 0000000000000000 R15: 0000000000000001
> [ 1093.252753] ---[ end trace d5f6b816d902441d ]---
> [ 1093.253282] XFS: Assertion failed: bp->b_transp == tp, file: fs/xfs/xfs_trans_buf.c, line: 450
> [ 1093.254223] ------------[ cut here ]------------
> [ 1093.254758] WARNING: CPU: 3 PID: 12697 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
> [ 1093.255762] Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set ip_set_hash_mac ip_set nfnetlink bfq ip6table_filter ip6_tables iptable_filter pvpanic_mmio pvpanic sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet [last unloaded: xfs]
> [ 1093.258748] CPU: 3 PID: 12697 Comm: attr Tainted: G        W         5.13.0-rc2-djwx #rc2
> [ 1093.259642] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [ 1093.260604] RIP: 0010:assfail+0x3c/0x40 [xfs]
> [ 1093.261200] Code: 48 a2 3f a0 e8 81 f9 ff ff 8a 1d 7b e9 0b 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 a0 57 49 a0 e8 db c9 00 e1 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
> [ 1093.263184] RSP: 0018:ffffc90001a0f988 EFLAGS: 00010246
> [ 1093.263763] RAX: 0000000000000000 RBX: ffff88804e004700 RCX: 0000000000000000
> [ 1093.264536] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa03ea6d5
> [ 1093.265315] RBP: ffff88804e9fee00 R08: 0000000000000000 R09: 000000000000000a
> [ 1093.266116] R10: 000000000000000a R11: f000000000000000 R12: ffff888042f11740
> [ 1093.266907] R13: 0000000000000058 R14: ffff888042f11740 R15: ffff88804e004738
> [ 1093.267675] FS:  00007f8c3494f740(0000) GS:ffff88807e100000(0000) knlGS:0000000000000000
> [ 1093.268544] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1093.269178] CR2: 00007f8c34a57710 CR3: 000000004b455005 CR4: 00000000001706a0
> [ 1093.269949] Call Trace:
> [ 1093.270244]  xfs_trans_dirty_buf+0xbe/0x120 [xfs]
> [ 1093.270888]  xfs_trans_log_buf+0x4c/0x100 [xfs]
> [ 1093.271490]  xfs_attr3_leaf_remove+0x2ef/0xc30 [xfs]
> [ 1093.272129]  ? xfs_trans_add_item+0x6b/0x180 [xfs]
> [ 1093.272759]  xfs_attr_node_removename+0x3d/0x90 [xfs]
> [ 1093.273400]  xfs_attr_remove_iter+0x50/0x270 [xfs]
> [ 1093.274015]  xfs_attr_set+0x2ff/0x430 [xfs]
> [ 1093.274562]  xfs_xattr_set+0x89/0xd0 [xfs]
> [ 1093.275139]  __vfs_removexattr+0x52/0x70
> [ 1093.275592]  __vfs_removexattr_locked+0xb8/0x140
> [ 1093.276117]  vfs_removexattr+0x56/0x100
> [ 1093.276558]  ovl_xattr_set+0x131/0x1d0 [overlay]
> [ 1093.277085]  __vfs_removexattr+0x52/0x70
> [ 1093.277534]  __vfs_removexattr_locked+0xb8/0x140
> [ 1093.278063]  vfs_removexattr+0x56/0x100
> [ 1093.278506]  removexattr+0x58/0x90
> [ 1093.278934]  ? __check_object_size+0xc8/0x280
> [ 1093.279435]  ? strncpy_from_user+0x47/0x180
> [ 1093.279919]  ? preempt_count_add+0x50/0xa0
> [ 1093.280384]  ? __mnt_want_write+0x65/0x90
> [ 1093.280843]  path_removexattr+0x9e/0xc0
> [ 1093.281290]  __x64_sys_lremovexattr+0x14/0x20
> [ 1093.281788]  do_syscall_64+0x3a/0x70
> [ 1093.282208]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1093.282792] RIP: 0033:0x7f8c34a7207b
> [ 1093.283216] Code: 73 01 c3 48 8b 0d 15 ae 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 c6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e5 ad 0c 00 f7 d8 64 89 01 48
> [ 1093.285191] RSP: 002b:00007ffc9f3248f8 EFLAGS: 00000202 ORIG_RAX: 00000000000000c6
> [ 1093.286027] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f8c34a7207b
> [ 1093.286822] RDX: 0000000000000072 RSI: 00007ffc9f324910 RDI: 00007ffc9f3261a0
> [ 1093.287614] RBP: 00007ffc9f326196 R08: 0000000000000000 R09: 00007ffc9f324910
> [ 1093.288396] R10: 00007f8c34b3dbe0 R11: 0000000000000202 R12: 00007ffc9f3261a0
> [ 1093.289174] R13: 00007ffc9f324910 R14: 0000000000000000 R15: 0000000000000001
> [ 1093.289956] ---[ end trace d5f6b816d902441e ]---
> [ 1093.290487] XFS: Assertion failed: bp->b_transp == tp, file: fs/xfs/xfs_trans_buf.c, line: 450
> [ 1093.291444] ------------[ cut here ]------------
> [ 1093.291980] WARNING: CPU: 3 PID: 12697 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
> [ 1093.292978] Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set ip_set_hash_mac ip_set nfnetlink bfq ip6table_filter ip6_tables iptable_filter pvpanic_mmio pvpanic sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet [last unloaded: xfs]
> [ 1093.295967] CPU: 3 PID: 12697 Comm: attr Tainted: G        W         5.13.0-rc2-djwx #rc2
> [ 1093.296855] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [ 1093.297814] RIP: 0010:assfail+0x3c/0x40 [xfs]
> [ 1093.298412] Code: 48 a2 3f a0 e8 81 f9 ff ff 8a 1d 7b e9 0b 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 a0 57 49 a0 e8 db c9 00 e1 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
> [ 1093.300398] RSP: 0018:ffffc90001a0f988 EFLAGS: 00010246
> [ 1093.300987] RAX: 0000000000000000 RBX: ffff88804e004700 RCX: 0000000000000000
> [ 1093.301761] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa03ea6d5
> [ 1093.302541] RBP: ffff88804e9fee00 R08: 0000000000000000 R09: 000000000000000a
> [ 1093.303328] R10: 000000000000000a R11: f000000000000000 R12: ffff888042f11740
> [ 1093.304107] R13: 0000000000000000 R14: ffff888042f11740 R15: ffff88804e004738
> [ 1093.304878] FS:  00007f8c3494f740(0000) GS:ffff88807e100000(0000) knlGS:0000000000000000
> [ 1093.305743] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1093.306377] CR2: 00007f8c34a57710 CR3: 000000004b455005 CR4: 00000000001706a0
> [ 1093.307172] Call Trace:
> [ 1093.307470]  xfs_trans_dirty_buf+0xbe/0x120 [xfs]
> [ 1093.308100]  xfs_trans_log_buf+0x4c/0x100 [xfs]
> [ 1093.308700]  xfs_attr3_leaf_remove+0x3b6/0xc30 [xfs]
> [ 1093.309333]  ? xfs_trans_add_item+0x6b/0x180 [xfs]
> [ 1093.309971]  xfs_attr_node_removename+0x3d/0x90 [xfs]
> [ 1093.310614]  xfs_attr_remove_iter+0x50/0x270 [xfs]
> [ 1093.311254]  xfs_attr_set+0x2ff/0x430 [xfs]
> [ 1093.311809]  xfs_xattr_set+0x89/0xd0 [xfs]
> [ 1093.312381]  __vfs_removexattr+0x52/0x70
> [ 1093.312836]  __vfs_removexattr_locked+0xb8/0x140
> [ 1093.313367]  vfs_removexattr+0x56/0x100
> [ 1093.313813]  ovl_xattr_set+0x131/0x1d0 [overlay]
> [ 1093.314350]  __vfs_removexattr+0x52/0x70
> [ 1093.314820]  __vfs_removexattr_locked+0xb8/0x140
> [ 1093.315352]  vfs_removexattr+0x56/0x100
> [ 1093.315799]  removexattr+0x58/0x90
> [ 1093.316204]  ? __check_object_size+0xc8/0x280
> [ 1093.316701]  ? strncpy_from_user+0x47/0x180
> [ 1093.317187]  ? preempt_count_add+0x50/0xa0
> [ 1093.317656]  ? __mnt_want_write+0x65/0x90
> [ 1093.318124]  path_removexattr+0x9e/0xc0
> [ 1093.318569]  __x64_sys_lremovexattr+0x14/0x20
> [ 1093.319083]  do_syscall_64+0x3a/0x70
> [ 1093.319502]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1093.320075] RIP: 0033:0x7f8c34a7207b
> [ 1093.320491] Code: 73 01 c3 48 8b 0d 15 ae 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 c6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e5 ad 0c 00 f7 d8 64 89 01 48
> [ 1093.322466] RSP: 002b:00007ffc9f3248f8 EFLAGS: 00000202 ORIG_RAX: 00000000000000c6
> [ 1093.323307] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f8c34a7207b
> [ 1093.324092] RDX: 0000000000000072 RSI: 00007ffc9f324910 RDI: 00007ffc9f3261a0
> [ 1093.324864] RBP: 00007ffc9f326196 R08: 0000000000000000 R09: 00007ffc9f324910
> [ 1093.325647] R10: 00007f8c34b3dbe0 R11: 0000000000000202 R12: 00007ffc9f3261a0
> [ 1093.326426] R13: 00007ffc9f324910 R14: 0000000000000000 R15: 0000000000000001
> [ 1093.327224] ---[ end trace d5f6b816d902441f ]---
> [ 1093.327751] XFS: Assertion failed: !(bip->bli_flags & XFS_BLI_LOGGED), file: fs/xfs/xfs_trans_buf.c, line: 79
> [ 1093.328827] ------------[ cut here ]------------
> [ 1093.329352] WARNING: CPU: 3 PID: 12697 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
> [ 1093.330350] Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set ip_set_hash_mac ip_set nfnetlink bfq ip6table_filter ip6_tables iptable_filter pvpanic_mmio pvpanic sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet [last unloaded: xfs]
> [ 1093.333309] CPU: 3 PID: 12697 Comm: attr Tainted: G        W         5.13.0-rc2-djwx #rc2
> [ 1093.334209] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [ 1093.335181] RIP: 0010:assfail+0x3c/0x40 [xfs]
> [ 1093.335774] Code: 48 a2 3f a0 e8 81 f9 ff ff 8a 1d 7b e9 0b 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 a0 57 49 a0 e8 db c9 00 e1 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
> [ 1093.337749] RSP: 0018:ffffc90001a0f930 EFLAGS: 00010246
> [ 1093.338337] RAX: 0000000000000000 RBX: ffff88804e9fee00 RCX: 0000000000000000
> [ 1093.339134] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa03ea6d5
> [ 1093.339920] RBP: ffff88804e004738 R08: 0000000000000000 R09: 000000000000000a
> [ 1093.340697] R10: 000000000000000a R11: f000000000000000 R12: ffff888042f11740
> [ 1093.341477] R13: 0000000000000001 R14: ffffc90001a0f9e0 R15: ffffffffa03daaa0
> [ 1093.342258] FS:  00007f8c3494f740(0000) GS:ffff88807e100000(0000) knlGS:0000000000000000
> [ 1093.343144] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1093.343779] CR2: 00007f8c34a57710 CR3: 000000004b455005 CR4: 00000000001706a0
> [ 1093.344561] Call Trace:
> [ 1093.344857]  _xfs_trans_bjoin+0x100/0x110 [xfs]
> [ 1093.345469]  xfs_trans_read_buf_map+0x22b/0x4a0 [xfs]
> [ 1093.346130]  xfs_da_read_buf+0xce/0x120 [xfs]
> [ 1093.346714]  xfs_attr3_leaf_read+0x26/0x60 [xfs]
> [ 1093.347313]  ? xfs_attr_is_leaf+0x76/0x90 [xfs]
> [ 1093.347901]  xfs_attr_node_shrink+0x54/0x100 [xfs]
> [ 1093.348514]  xfs_attr_remove_iter+0xa9/0x270 [xfs]
> [ 1093.349129]  xfs_attr_set+0x2ff/0x430 [xfs]
> [ 1093.349675]  xfs_xattr_set+0x89/0xd0 [xfs]
> [ 1093.350237]  __vfs_removexattr+0x52/0x70
> [ 1093.350684]  __vfs_removexattr_locked+0xb8/0x140
> [ 1093.351228]  vfs_removexattr+0x56/0x100
> [ 1093.351667]  ovl_xattr_set+0x131/0x1d0 [overlay]
> [ 1093.352194]  __vfs_removexattr+0x52/0x70
> [ 1093.352642]  __vfs_removexattr_locked+0xb8/0x140
> [ 1093.353165]  vfs_removexattr+0x56/0x100
> [ 1093.353603]  removexattr+0x58/0x90
> [ 1093.354003]  ? __check_object_size+0xc8/0x280
> [ 1093.354493]  ? strncpy_from_user+0x47/0x180
> [ 1093.354983]  ? preempt_count_add+0x50/0xa0
> [ 1093.355452]  ? __mnt_want_write+0x65/0x90
> [ 1093.355914]  path_removexattr+0x9e/0xc0
> [ 1093.356353]  __x64_sys_lremovexattr+0x14/0x20
> [ 1093.356840]  do_syscall_64+0x3a/0x70
> [ 1093.357258]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1093.357819] RIP: 0033:0x7f8c34a7207b
> [ 1093.358236] Code: 73 01 c3 48 8b 0d 15 ae 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 c6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e5 ad 0c 00 f7 d8 64 89 01 48
> [ 1093.360210] RSP: 002b:00007ffc9f3248f8 EFLAGS: 00000202 ORIG_RAX: 00000000000000c6
> [ 1093.361031] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f8c34a7207b
> [ 1093.361800] RDX: 0000000000000072 RSI: 00007ffc9f324910 RDI: 00007ffc9f3261a0
> [ 1093.362574] RBP: 00007ffc9f326196 R08: 0000000000000000 R09: 00007ffc9f324910
> [ 1093.363361] R10: 00007f8c34b3dbe0 R11: 0000000000000202 R12: 00007ffc9f3261a0
> [ 1093.364137] R13: 00007ffc9f324910 R14: 0000000000000000 R15: 0000000000000001
> [ 1093.364912] ---[ end trace d5f6b816d9024420 ]---
> [ 1093.365425] XFS: Assertion failed: !test_bit(XFS_LI_DIRTY, &lip->li_flags), file: fs/xfs/xfs_trans.c, line: 657
> [ 1093.366508] ------------[ cut here ]------------
> [ 1093.367045] WARNING: CPU: 3 PID: 12697 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
> [ 1093.368050] Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set ip_set_hash_mac ip_set nfnetlink bfq ip6table_filter ip6_tables iptable_filter pvpanic_mmio pvpanic sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet [last unloaded: xfs]
> [ 1093.371056] CPU: 3 PID: 12697 Comm: attr Tainted: G        W         5.13.0-rc2-djwx #rc2
> [ 1093.371941] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [ 1093.372891] RIP: 0010:assfail+0x3c/0x40 [xfs]
> [ 1093.373477] Code: 48 a2 3f a0 e8 81 f9 ff ff 8a 1d 7b e9 0b 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 a0 57 49 a0 e8 db c9 00 e1 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
> [ 1093.375457] RSP: 0018:ffffc90001a0f900 EFLAGS: 00010246
> [ 1093.376042] RAX: 0000000000000000 RBX: ffff88804e004700 RCX: 0000000000000000
> [ 1093.376811] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa03ea6d5
> [ 1093.377584] RBP: ffff888042f11740 R08: 0000000000000000 R09: 000000000000000a
> [ 1093.378361] R10: 000000000000000a R11: f000000000000000 R12: ffff88804e004748
> [ 1093.379147] R13: 0000000000000001 R14: ffffc90001a0f9e0 R15: ffffffffa03daaa0
> [ 1093.379926] FS:  00007f8c3494f740(0000) GS:ffff88807e100000(0000) knlGS:0000000000000000
> [ 1093.380796] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1093.381427] CR2: 00007f8c34a57710 CR3: 000000004b455005 CR4: 00000000001706a0
> [ 1093.382201] Call Trace:
> [ 1093.382497]  xfs_trans_add_item+0x171/0x180 [xfs]
> [ 1093.383137]  _xfs_trans_bjoin+0x72/0x110 [xfs]
> [ 1093.383732]  xfs_trans_read_buf_map+0x22b/0x4a0 [xfs]
> [ 1093.384395]  xfs_da_read_buf+0xce/0x120 [xfs]
> [ 1093.384973]  xfs_attr3_leaf_read+0x26/0x60 [xfs]
> [ 1093.385567]  ? xfs_attr_is_leaf+0x76/0x90 [xfs]
> [ 1093.386162]  xfs_attr_node_shrink+0x54/0x100 [xfs]
> [ 1093.386789]  xfs_attr_remove_iter+0xa9/0x270 [xfs]
> [ 1093.387402]  xfs_attr_set+0x2ff/0x430 [xfs]
> [ 1093.387953]  xfs_xattr_set+0x89/0xd0 [xfs]
> [ 1093.388507]  __vfs_removexattr+0x52/0x70
> [ 1093.388959]  __vfs_removexattr_locked+0xb8/0x140
> [ 1093.389476]  vfs_removexattr+0x56/0x100
> [ 1093.389919]  ovl_xattr_set+0x131/0x1d0 [overlay]
> [ 1093.390437]  __vfs_removexattr+0x52/0x70
> [ 1093.390902]  __vfs_removexattr_locked+0xb8/0x140
> [ 1093.391420]  vfs_removexattr+0x56/0x100
> [ 1093.391856]  removexattr+0x58/0x90
> [ 1093.392257]  ? __check_object_size+0xc8/0x280
> [ 1093.392747]  ? strncpy_from_user+0x47/0x180
> [ 1093.393223]  ? preempt_count_add+0x50/0xa0
> [ 1093.393684]  ? __mnt_want_write+0x65/0x90
> [ 1093.394145]  path_removexattr+0x9e/0xc0
> [ 1093.394582]  __x64_sys_lremovexattr+0x14/0x20
> [ 1093.395095]  do_syscall_64+0x3a/0x70
> [ 1093.395508]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 1093.396072] RIP: 0033:0x7f8c34a7207b
> [ 1093.396478] Code: 73 01 c3 48 8b 0d 15 ae 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 c6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e5 ad 0c 00 f7 d8 64 89 01 48
> [ 1093.398426] RSP: 002b:00007ffc9f3248f8 EFLAGS: 00000202 ORIG_RAX: 00000000000000c6
> [ 1093.399254] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f8c34a7207b
> [ 1093.400032] RDX: 0000000000000072 RSI: 00007ffc9f324910 RDI: 00007ffc9f3261a0
> [ 1093.400800] RBP: 00007ffc9f326196 R08: 0000000000000000 R09: 00007ffc9f324910
> [ 1093.401571] R10: 00007f8c34b3dbe0 R11: 0000000000000202 R12: 00007ffc9f3261a0
> [ 1093.402343] R13: 00007ffc9f324910 R14: 0000000000000000 R15: 0000000000000001
> [ 1093.403130] ---[ end trace d5f6b816d9024421 ]---
> [ 1093.565232] XFS (sdc): Unmounting Filesystem
> [ 1093.604852] [U] TEST FINISHED: -overlay generic/020 @ Wed May 26 10:34:41 PDT 2021
> 
> The first assertion, I think, is an accounting problem -- the ASSERT
> checks that args->rmtblkno should be zero after calling the function
> __xfs_attr_rmtval_remove to unmap the blocks backing the remote value
> from the attr fork.  I don't see anywhere in that function that actually
> updates the args fields, however.
> 
> AFAICT all this needs is a little bookkeeping update in
> __xfs_attr_rmtval_remove.
> 
> The second and subsequent assertions come from trying to log a buffer
> that isn't attached to the current transaction.  I think what's
> happening is:
> 
> 1. we're in state XFS_DAS_RMTBLK
> 2. call __xfs_attr_rmtval_remove to remove a remote block, which returns 0
> 3. call xfs_attr_refillstate to re-attach buffers to the da state
> 4. set state to XFS_DAS_RM_NAME
> 5. set XFS_DAC_DEFER_FINISH and return EAGAIN to finish deferred updates
> 6. <transaction roll releases buffers>
> 7. now we're in state XFS_DAS_RM_NAME
> 8. call xfs_attr_node_removename to remove the name
> 9. trip assert because the buffers in state->path.blk[] aren't joined to the
>     current transaction
> 
> I think the solution here is to call xfs_attr_refillstate to reattach
> all the buffers to the transaction, but only if we've freshly rolled the
> transaction.  If we fell through the UNINIT and RMTBLK cases into
> RM_NAME without rolling anything, then we're still on the same
> transaction that we used for the first lookup and don't need to refill
> the state.
> 
> Can you take a look at this patch?  It fixes the problems for that one
> test, but I haven't run it through QA yet.
Ok, it seems to be doing ok so far in other tests.  (at least for me!) 
Should I just add this to another patch at the end?  Thank you for the 
catch!

Allison

> 
> --D
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 20b1e3c6bdd0..7b3d0c3d2e65 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1442,6 +1442,17 @@ xfs_attr_remove_iter(
>   
>   		/* fallthrough */
>   	case XFS_DAS_RM_NAME:
> +
> +		/*
> +		 * If we came here fresh from a transaction roll, reattach all
> +		 * the buffers to the current transaction.
> +		 */
> +		if (dac->dela_state == XFS_DAS_RM_NAME) {
> +			error = xfs_attr_refillstate(state);
> +			if (error)
> +				goto out;
> +		}
> +
>   		retval = xfs_attr_node_removename(args, state);
>   
>   		/*
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index b5bc50cad9bf..d560b55abedb 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -699,5 +699,8 @@ __xfs_attr_rmtval_remove(
>   		return -EAGAIN;
>   	}
>   
> -	return error;
> +	/* We've unmapped the remote value blocks, so zero these out */
> +	args->rmtblkno = 0;
> +	args->rmtblkcnt = 0;
> +	return 0;
>   }
> 
