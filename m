Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3243FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Feb 2022 13:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiBONQq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 08:16:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiBONQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 08:16:45 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C85A45AED
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 05:16:32 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FCO3Zv024982;
        Tue, 15 Feb 2022 13:16:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mV+hC1YD5f1omgDmLN1UKZlp9+Wa6zl6RC0f4ZDxI8s=;
 b=BYLm/DpbVcSj2gYjbPtikretQBrhSSDbXWfam1rkufKYd0uxjxEH5MvW5tk9euSCFLiY
 KXgeHSjZYDBk4CLOu0TFl115e8YP5TdypsEz/GN9iy6slQo0aqMmLbHVnUcak/9ShQGW
 Yi9Pu9aB2tNNYtRWEu1s7+xXlwsFYl1B+SZ2oJr18/P92YCIfnDtLhNp91xdPjBpoJg2
 P+HATthclx6KzlPusVNvEbj8TdfPeXk25xM8ICwAKIfHpe89PjVOUuHW+mXUw5I+UCxN
 NwgWKJpr/ZNej5UcEsa1uqeUJX5DGqNYC16leO7OQPh+t4v/r1WwSsFPRv9bFRz0cy6t +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e871ps1qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 13:16:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21FD6eHd191789;
        Tue, 15 Feb 2022 13:16:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by userp3020.oracle.com with ESMTP id 3e66bnjct3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 13:16:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0kFuCX/I5Qt3GKXJcHIlG5t2WVdRHtrPbjvaZm8VWssRmmdqhQvEaFEQu2Svl4jqmY5Iqixsx6vBKqxeZzSBp/UdNmwJ11xq/9/AyVfheQDEw/8Mm8PBc64Q4XR9ohf4G/nDc02uziP/GPMyWjD4+Y5Sp/nvZZPywgHm5hyfvIdk1PoEJcqqjQI/9/MYmdwsCu5pOyMaoJelHvslOFudyNqLsNJBCcE5UDpKKxBCw9EO4zEme4haA8k+0WxBQYIQhU9YE7t6dH64pfzBwVd+yaHdKrTWc+mFof6GWb6lB0w+rWckuATqmUS9GC3JeP5w5pybXhpEXvJjeZJEZ9u8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mV+hC1YD5f1omgDmLN1UKZlp9+Wa6zl6RC0f4ZDxI8s=;
 b=fHQFJaTFuG9WUSbMsD9CrPIaXe36vOEvKeiyZvfqFkI57FLSxzuMPoTj36LxTqsWtCiILjUbiN2t++EfdwyzPpgOYEEXkhlPhW3jhl5o/tZIDxH8rHdEkYI4vxA8JsnoWvzWipvYAT/J7qxeEyrsBWCtu+K0XV21e/4FfimOI/AZ+d8vnXe76Hd1/S1dWjpPSBf29K4m2JT4RwJDmsBuQIq5+LXdrz7zWA7oysqtvY5sytTVnWdpAGaMFTltAaQoe14qCIzd/eIbWCFzg9htKvCWyZgbzhgJhpWhfz5UUvTsKrSve7bgIJRcN/X5aaoJpsaXLSQCAVilKrp1EkWFSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mV+hC1YD5f1omgDmLN1UKZlp9+Wa6zl6RC0f4ZDxI8s=;
 b=hCA7z1IFBfHYDu0Ss8L3DnQdNzx32Lz81bXUUDjRJGvc3llWE4R9cYp0OIkGxtnXjOjKlNvH1uKVA1+Wf6myaaCTCVuyixPmu1lbyN2ugB2ynKiW7Y4uYSBx341g7rrAXLPaee8RHEXaBJUyvBUnB59s/nGYma+yeWuOvMnS52I=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB3125.namprd10.prod.outlook.com (2603:10b6:a03:14c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 13:16:25 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%5]) with mapi id 15.20.4975.018; Tue, 15 Feb 2022
 13:16:25 +0000
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-14-chandan.babu@oracle.com>
 <20220201200125.GN8313@magnolia>
 <87v8xs9dpr.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220207171106.GB8313@magnolia>
 <87bkzda9jd.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220214170728.GI8313@magnolia>
 <87v8xglj59.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220215093301.GZ59715@dread.disaster.area>
 <87sfskl5z6.fsf@debian-BULLSEYE-live-builder-AMD64>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 13/16] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
In-reply-to: <87sfskl5z6.fsf@debian-BULLSEYE-live-builder-AMD64>
Message-ID: <87pmnol17j.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 15 Feb 2022 18:46:16 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0089.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::29) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da64291f-3d57-415d-b11a-08d9f0855dff
X-MS-TrafficTypeDiagnostic: BYAPR10MB3125:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB31256EF432CE735B5EC42A9AF6349@BYAPR10MB3125.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nZivLmq9iNPQxxTJntoMX3FcE7SX8qDbCYxnKEXMC5JsoPWhTLAUN+XZ0yXuU/XHH74l70gJj+S9nlRnxxjmLjk1eSJYehfusE5bvSUubjIJqpEo+/zJOlkhqAreYG1UISmOjUQJbIkRfgaS1uzRV+JT1Oesn4y/evyPnzWdMYbizEKMxyfwk/n6ZwEoU+c72yRSO6p4CFXoJa5jF3o1SczmhFsLe14Nki6AnPtQk3QXNtWzh4ujShDifQ65MSBhhtf3r8gDsfhrUnceWJH6sbRLCiY8Ke79AbtV1W5bxpKcT1t3Jo5rHMabOF/OOEK8ebDgrQGACQO28tLBWfHYfHMCxwlQVwhROqHnReSU8dN9zfTnLABa48DpBKCrIkjwZszaYRzjUgv1deJHeD47KXl8aDI5Xwpt0GEKSyOwgu5Y+U8QcswPWbm5Vsk2Ds4jQhOGSrlBcFb9wMez2ZYSkcvHVsIrAjYUeze4X9OLRWNa0ce5xL8wjq1nzkHk+6Oz/torSOf5MrwtvZoZeQogKStq2Jh8943UkmC6ashqgoWKlYl34Xctpkw2f9R/gyg4SNPLf8iG1mLP2Z1dWKI4+weZCzBsRiVPMdQtvbU4q2hKtxK6yUeKGEK8OtFLGZgZeTmVTVjjqod2/3ZP481QTnoAxvGJ5fUxnOfmtEGpfvMl3oxMgJXEQHGEmBxKK6Mez9XMbGe1/Pza25Kkom7ARQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66476007)(66556008)(8676002)(66946007)(6666004)(186003)(4326008)(6512007)(86362001)(53546011)(52116002)(6506007)(6486002)(508600001)(26005)(33716001)(83380400001)(6916009)(9686003)(316002)(38350700002)(2906002)(5660300002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dCM/VrFPen7YsOazILxo1SIpk5Ae8aXVZ4WxkiM+1URSbkDO0F1kp5Ib+vyy?=
 =?us-ascii?Q?VlUWvADtTTFssEMoVgCtVbfQP4su8ltmjnwZpfGFdFydJrV3u4FmafEKjm11?=
 =?us-ascii?Q?p3BWiYXLI+FHdgi7pJiPUGuCyA5huEp1bJuAJIpO+v99pzmBPwytwFhjaQy4?=
 =?us-ascii?Q?trl3vbEK75QhbgbP8eP+r4hlREhcdahoHPE5MK6itMUWZ1gkOsy33t5Zdyus?=
 =?us-ascii?Q?gXr6WEKBjdwbe3TNq6ITbfvrmdMiUAcQKmOhO8MloMqtEtisQyMXAqD1nUKf?=
 =?us-ascii?Q?2zgF7KlvPasB8cFFa0KurY3H+vAZ1xF4bvLhvJLOGPcueIXUtGdCPFztZZeT?=
 =?us-ascii?Q?1em59Yd7mXAmadHMJQGSmns48dWbKXFpIF+pXOVmsbXzo3kXIEPnvNmspw9V?=
 =?us-ascii?Q?VppI14NijZlFC+jiCSQG3IeRDHYfWyoC3/D/wOR7O4gS7CAxXBnGbZMXHPi7?=
 =?us-ascii?Q?UVnu6XMEiulr4ZdayWRFyUhLsUl7AKlIOCrrhabFx/DxeBKpUFl8KDT4mP+x?=
 =?us-ascii?Q?2OcCxXqfwxxtW0TLEwgFfI93Q7BOG9DmUc0Z/+N0hV0uDh9vdD+uoUA8CZXL?=
 =?us-ascii?Q?8PFiwXxIcHyspdbzrFAtt9dqzyLnndQFfqv2OBQBEfN7JSTNO40Eoke1oX/9?=
 =?us-ascii?Q?BNYHu9kzxVqogMtg1lh83QrUovPfmG9xaTbk6IvWwgrlnNgmVxONTT7AReiM?=
 =?us-ascii?Q?AJlLfUZoYyYiyPMGByRIf/129Zd5+9HsSD1Ci1vjU4EtZX5BhNpWFzYE55xi?=
 =?us-ascii?Q?omNkFr9nf9ZU9QUtkyBeAKYNILz5mAuWRDjmGjyO6wAaxAukAixKuAIf2nzb?=
 =?us-ascii?Q?XdGv4PLB8h+sIbEh1zOROWLo1M2WwxkDhG2hfQb7CTuJQhTdbkeqyNIrRDTZ?=
 =?us-ascii?Q?E2E5K44o3nmMaDVPNzSiraGGQIEU5te7hvnDGTVmoHhxE5DqJBtX/hG8hj/e?=
 =?us-ascii?Q?6733wHXodlVtuVGcuwRtoz4AYNWUsvlnFupQOhgx9ma6LHX6uXTUNQ1Wcify?=
 =?us-ascii?Q?7TXL/dk4VOAOhfhrJX0Ob2HHQGSoX60VMCPiz3jKthIsdxv8jnNv7w4m5MXT?=
 =?us-ascii?Q?A3rHL2wSvpFmDowDYPDAvGqFrDNdwDvCiIPz+Fj5GeBCQTKEGA2kMTwOC1GO?=
 =?us-ascii?Q?sE9WBYFGGdbKzIMeEr5HqeM5TgXLWz2OC8eL+rGALa3Sg+kP0/NsL5KHx0RK?=
 =?us-ascii?Q?EQcPSTjEAyt1xtsQMeXlMJvnBnORpd5V+Vl/EbcR7nqpDQ/L/355wPI86qEj?=
 =?us-ascii?Q?bYn+4sOY0BzVpKH9ZrJGgPvW5LkI3Bcxg6LcOYqg7Tcr0CN3BiDR9RbxMvxu?=
 =?us-ascii?Q?CRIyljGkzgkiMobN47hTa2UfOq8mobiIDxAnqUILjt/jP2dOBqWerFfWFquU?=
 =?us-ascii?Q?t51cGarObdFLUjpOhxut236EMOnucm96CjyzmsO5e01rpuCk4psboYQ8qLLn?=
 =?us-ascii?Q?hb4qBAztZDNp+SK0ijrJw+2FqoKhiFiRoGj/2DIwQL9X6SV3Y0WGvUW/2JFj?=
 =?us-ascii?Q?PqksLNknOP0dYwhfk6MbL27HFX94Kb72mwIZUKHq0gMYB17yL1coofGgsC99?=
 =?us-ascii?Q?N3pUD2zK/i5ugRKuX6oHW6KZsJhtnf2S37rqQC2JD/2odF/u8YCfAyCw4W3r?=
 =?us-ascii?Q?6nlU+4NIxkaBcAOBpLda5TU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da64291f-3d57-415d-b11a-08d9f0855dff
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 13:16:25.2064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SAuJc1zQ07NVwZKVMHTrZ2GCdRaLc7G79JqYImdEorcPE3ci5Z3RgPaGXY8SN1cVcQM+q3P19TJxX5kVMfjc+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3125
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150076
X-Proofpoint-GUID: 84MDHm-h34m4ePeLpBFpGHQ82K6Dk-ox
X-Proofpoint-ORIG-GUID: 84MDHm-h34m4ePeLpBFpGHQ82K6Dk-ox
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 15 Feb 2022 at 17:03, Chandan Babu R wrote:
> On 15 Feb 2022 at 15:03, Dave Chinner wrote:
>> On Tue, Feb 15, 2022 at 12:18:50PM +0530, Chandan Babu R wrote:
>>> On 14 Feb 2022 at 22:37, Darrick J. Wong wrote:
>>> > On Fri, Feb 11, 2022 at 05:40:30PM +0530, Chandan Babu R wrote:
>>> >> On 07 Feb 2022 at 22:41, Darrick J. Wong wrote:
>>> >> > On Mon, Feb 07, 2022 at 10:25:19AM +0530, Chandan Babu R wrote:
>>> >> >> On 02 Feb 2022 at 01:31, Darrick J. Wong wrote:
>>> >> >> > On Fri, Jan 21, 2022 at 10:48:54AM +0530, Chandan Babu R wrote:
>>> >> >> I went through all the call sites of xfs_iext_count_may_overflow() and I think
>>> >> >> that your suggestion can be implemented.
>>> >> 
>>> >> Sorry, I missed/overlooked the usage of xfs_iext_count_may_overflow() in
>>> >> xfs_symlink().
>>> >> 
>>> >> Just after invoking xfs_iext_count_may_overflow(), we execute the following
>>> >> steps,
>>> >> 
>>> >> 1. Allocate inode chunk
>>> >> 2. Initialize inode chunk.
>>> >> 3. Insert record into inobt/finobt.
>>> >> 4. Roll the transaction.
>>> >> 5. Allocate ondisk inode.
>>> >> 6. Add directory inode to transaction.
>>> >> 7. Allocate blocks to store symbolic link path name.
>>> >> 8. Log symlink's inode (data fork contains block mappings).
>>> >> 9. Log data blocks containing symbolic link path name.
>>> >> 10. Add name to directory and log directory's blocks.
>>> >> 11. Log directory inode.
>>> >> 12. Commit transaction.
>>> >> 
>>> >> xfs_trans_roll() invoked in step 4 would mean that we cannot move step 6 to
>>> >> occur before step 1 since xfs_trans_roll would unlock the inode by executing
>>> >> xfs_inode_item_committing().
>>> >> 
>>> >> xfs_create() has a similar flow.
>>> >> 
>>> >> Hence, I think we should retain the current logic of setting
>>> >> XFS_DIFLAG2_NREXT64 just after reading the inode from the disk.
>>> >
>>> > File creation shouldn't ever run into problems with
>>> > xfs_iext_count_may_overflow because (a) only symlinks get created with
>>> > mapped blocks, and never more than two; and (b) we always set NREXT64
>>> > (the inode flag) on new files if NREXT64 (the superblock feature bit) is
>>> > enabled, so a newly created file will never require upgrading.
>>> 
>>> The inode representing the symbolic link being created cannot overflow its
>>> data fork extent count field. However, the inode representing the directory
>>> inside which the symbolic link entry is being created, might overflow its data
>>> fork extent count field.
>>
>> I dont' think that can happen. A directory is limited in size to 3
>> segments of 32GB each. In reality, only the data segment can ever
>> reach 32GB as both the dabtree and free space segments are just
>> compact indexes of the contents of the 32GB data segment.
>>
>> Hence a directory is never likely to reach more than about 40GB of
>> blocks which is nowhere near large enough to overflowing a 32 bit
>> extent count field.
>
> I think you are right.
>
> The maximum file size that can be represented by the data fork extent counter
> in the worst case occurs when all extents are 1 block in size and each block
> is 1k in size.
>
> With 1k byte sized blocks, a file can reach upto,
> 1k * (2^31) = 2048 GB
>
> This is much larger than the asymptotic maximum size of a directory i.e.
> 32GB * 3 = 96GB.

Also, I think I should remove extent count overflow checks performed in the
following functions,

xfs_create()
xfs_rename()
xfs_link()
xfs_symlink()
xfs_bmap_del_extent_real()

... Since they do not accomplish anything.

Please let me know your views on this.

-- 
chandan
