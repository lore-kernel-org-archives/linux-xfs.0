Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1893CC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Feb 2022 11:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiBOLeU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Feb 2022 06:34:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236483AbiBOLeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Feb 2022 06:34:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D751EAFE
        for <linux-xfs@vger.kernel.org>; Tue, 15 Feb 2022 03:33:40 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FBDJto032155;
        Tue, 15 Feb 2022 11:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Hkm+ZKCRhI0BLu4pvPuAhCXVSvMk18Uur759nH6EIxU=;
 b=tOPDqNXAIbEekSsCsiNFr38zyxmn/dcMOQ/ExzUlx4YhAJEyctsaRR4ZKYW+UxMGlDkx
 FEr0As2dvcyrt/I2tvFCTnvyavF+pIfSc7nkZk1CCjk6WIFKwG1Uj27ShiZgv6vMIBMT
 xlNmpqe1OCok5Urxtxt3HQLxVRbcUUBSxXv9N8RrxOHZ1d5yja9EUsr8eXvqyAO9LoXy
 B5dPDY/41ptUsOkc9Cc+3gSqqxSMtQznspYXwW15zyA5SrN+7PoPCYXNNc5Vyg8parnX
 7teWYhBfZRDYNay0U6mNtRl1r+/w22OVNk0Ojw6r2z3Iwkp3XArKzwcZZftEKHkPirAN gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e820nhe13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 11:33:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21FBUeL0113700;
        Tue, 15 Feb 2022 11:33:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 3e66bndmvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 11:33:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJ3fusPDxL/Dul2t9pR19ACtg4Kyfrel3Hj9OYasUHX6F0jqBfbvT0+CPiY+Y5mt2a2RKfrEhSMDKAsOkXzN4sCHz6QfZObrzD1V3IvVbzBACFydb0jRH8ZBubFBxyQkvohdXuceZeQ38DeH82vp2oWOesZCE5cIyYNhyIw0CQZnFgtPXscc6Zy6RvOptuu2WNnowO8y0uGwrzLAhJ/6+v5R/XQ1++dsIsq2z8tIqkJqpecaoPxw6CqZcTLW0Q//sVwbLbDwYZI1B1mK0xVCX8Z2O6nW7WpYOt1lsiQIpDLeIfPrIS1CmS+yx9zQOdWEdOy3Ht2f5Io5LPEzDFwMTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hkm+ZKCRhI0BLu4pvPuAhCXVSvMk18Uur759nH6EIxU=;
 b=KYnpmeyi7JJVUrdJlH/vC25jTNzyHFSVLHRw0PChnhr5VW4Ro/TKjVWgVNkbaOg4knb3/Z3AC0h2+qajoXmpRkAxarbCvsXkJL39GA15PdRso4O+VsNs7ZcBedUFPSS7QJ4n98dzUDszBWOFO0XMYimr3G81MLMslsKBhaI1I0PBzzUa4FVEVGmKtsPNj6kPlTsUY/2oKQDh85Zk+O42tyq1gUcX3SjWrX05vhkd1krPBcE5rKZ9T88hOowUJmYjrwbPd2YYogp6lbajDSGeRqtS73e8kYLzw6GUSIZc26TM6V8FEVyg9Lzs/D+bH/3xCpkc18FE8iL4uS6nb/qoDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hkm+ZKCRhI0BLu4pvPuAhCXVSvMk18Uur759nH6EIxU=;
 b=LzKy46HZe0HX9rOphRaikbDgNXZBekO05Jo5O9QmvJ5n0JzKIBW4/l20YUox6YBEW09lDgnUQBriIYAEs0M+QOwVryR5S60pCh8PjSxwSMKJF3VA/x0jDkawrvBWg/B0Ny74w/axYd3r8H2aSpcM1wGJDNa5zgl8t8MgIVbekW8=
Received: from SA2PR10MB4587.namprd10.prod.outlook.com (2603:10b6:806:114::12)
 by BYAPR10MB3271.namprd10.prod.outlook.com (2603:10b6:a03:152::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Tue, 15 Feb
 2022 11:33:27 +0000
Received: from SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552]) by SA2PR10MB4587.namprd10.prod.outlook.com
 ([fe80::46f:d52f:e31c:b552%5]) with mapi id 15.20.4975.018; Tue, 15 Feb 2022
 11:33:26 +0000
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-14-chandan.babu@oracle.com>
 <20220201200125.GN8313@magnolia>
 <87v8xs9dpr.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220207171106.GB8313@magnolia>
 <87bkzda9jd.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220214170728.GI8313@magnolia>
 <87v8xglj59.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220215093301.GZ59715@dread.disaster.area>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V5 13/16] xfs: Conditionally upgrade existing inodes to
 use 64-bit extent counters
In-reply-to: <20220215093301.GZ59715@dread.disaster.area>
Message-ID: <87sfskl5z6.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Tue, 15 Feb 2022 17:03:17 +0530
Content-Type: text/plain
X-ClientProxiedBy: TYBP286CA0046.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:404:10a::34) To SA2PR10MB4587.namprd10.prod.outlook.com
 (2603:10b6:806:114::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d5130da-b293-430c-dd06-08d9f076fb50
X-MS-TrafficTypeDiagnostic: BYAPR10MB3271:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3271BDE30218DB9301AE6F56F6349@BYAPR10MB3271.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hmSpAtF3a5uOSTaN7fyCD7sTyKEhQGHneWVWHwTtPZTl1S7hTLdAuDbBSaS5B5RROkjhIG8UrYExulS1JysSwVQK4ivuZb0x9RuFtvJ7BM6fbIXcqsvQWxBmAv8CB19+TpnydSqbhHscmYPddhMiJ4isa62fwsRWY8TFcP+i90Rax388gt+EI9++9MrroxaSEcNTBl0VBx5vzIxRNr3etz0oKUESWZWKVpdzAgdZ4JrPjwgz6Flxu4Zycw0jK0siWtuhZSl9aLMD6XImB6TNo71fqRspu7PMkq1NkzwURwWLTh7OL+NDp5t0bLpeAGB86InS2o8eDLvMH3E4HhNWQqnE1UYDymkS8kjoZoCntGELm3d1mNcys3COTTZh6Hs05OhCIGFhaJHf0zrzFb3yReU1ogHKV+5HNYv42ZpaiwOXq983tZSiCuyQUlS8+T696dJpkQ5xzbEbFvif7RZb2dDX1CJmBkh6yPEofZcHsAkhYUHrd6z7meiyjxmNMsVxSI7GF9nu8qA6iJLBvI9yStgSNm14wKjbJpUAo6JQ3UTIu6/dcWbDuXeFrZvWTp8xMwWR/0iT1rduNvI+fzZsABsDeuycYYNvZHJcj2P4RzeW5+hNVGEAzKbUB5/U93QcGk+FefI8km+vO5j+tODf7TG7ADm8oVaNjoP6dDyxRtuXQR5gezAlmODakGUNPFOlTPpw+ntZc5aUvUUCdIV+FQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4587.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(2906002)(5660300002)(83380400001)(9686003)(66556008)(66946007)(6512007)(8676002)(316002)(66476007)(6486002)(26005)(508600001)(4326008)(52116002)(186003)(53546011)(6506007)(33716001)(38100700002)(38350700002)(8936002)(86362001)(6916009)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?beOOgDKNU8AUS6S7P5l+A0oErPwma4O94U4Qu8We7xpFwZLKgws0WyW36TqN?=
 =?us-ascii?Q?NSwESaOJFAFswoLbr8vqWo/D8QOZzdEP8lbxqaZ5zP69IskWvjzaZWv3o2/Y?=
 =?us-ascii?Q?s8Xg+ttkSfhYhDhtpAAL+uucfNK2zbhZq+gFptZs+4QQfdYTGSSbsJylCFbA?=
 =?us-ascii?Q?B79Wc6l2ZSnT/QMDr2rz/6EMGINJDRY4Je34YORoja9WZH01VGwAAxgCFUlV?=
 =?us-ascii?Q?NdW6ovU6oMeJMRAxb/j6tZikYe4GWBfkarERZegGLnrobU0AVP1fcN0hZsIG?=
 =?us-ascii?Q?xfXGVjKO7aOBMVdcMnrmBny4N7Sy0fgLvVj3Yva7yLBpkcUft/dUiWzJC2Ys?=
 =?us-ascii?Q?ZP6zH5apWnpjuwGJn6MLuHf6acUw9/f1XYzPYKZXoXlBkRuoaQQB0T/Cjijf?=
 =?us-ascii?Q?jBgxpHR4PuEJrLFvZCkQyndnoCPGl+dNeyABNuJNDQA2zgaISJsMdSn/wudr?=
 =?us-ascii?Q?zZ2Oar9gGOoq5DIghL6NbfuuGq+/LN+8u4qAaCrfbrzvlT52U5+lVnuCNZDD?=
 =?us-ascii?Q?v+b/mSZ/ACfqJVkA/iwJmhU4FroRAAKkD3hFRFsmTb41WYTc9VhKciyasVUk?=
 =?us-ascii?Q?imQ2AgyT2nmKpGufvR3N1eJqZd6f1mUk/tPRdBPJFA/DBfFYnXrAnKCVACI6?=
 =?us-ascii?Q?8ozQg4Yy3ArdBcqiTrMACAo7AHH6sYLy3f9JZylHlgsu26932SDl+dI50XqF?=
 =?us-ascii?Q?geyK0PMIzcvfd2DHGMQy0W6JXC+ZoVyiVhsnVG1mDzJWONIRArXr2Z+QeE1W?=
 =?us-ascii?Q?HoNo9YQdoNZbMUsdxyy84mbbmySfs1JXkWBMeXuDicp/8MU+6J+qshgOuca1?=
 =?us-ascii?Q?3/pNddJiJUfFmC3wOGSyfCldQqKw0hkbNrGH4LmHpaN3KRJhw/2lAEK8pDIO?=
 =?us-ascii?Q?glnHsNn68BeXuKWsRQ1eWcjQ9OTJrTQ8ns448r7doOGdmdx+dNxWINYuRWZ6?=
 =?us-ascii?Q?+KZLUBY8MsGIf8PVCRPpkRw9IseSe+fVEapyK1641hrujsjxqCA7sP8WmRwT?=
 =?us-ascii?Q?QWva/W8X42stGHu+nZ/XBL+j/+tDsFI/t0DZWO673w1eYDOKdIJvwhDvr0sR?=
 =?us-ascii?Q?D5JTJgrHnFKQWoxGLIwOz6803S9qYX69W6ZvL8dl8qOkQegemSn5dPKZ5DSU?=
 =?us-ascii?Q?3TTcUdx2ok2bxyMVzBu+hId/qDwSDXWw+PPokxX8VQXFAfi+7ZKgfJcK4HJE?=
 =?us-ascii?Q?e+8tTqmRkuFPrIG2+mXHfAKwaHFJQknIpsdaP9lv+TXW/vrcWfpAoWYCBJ5C?=
 =?us-ascii?Q?UQdH1x5FdU5CXVIoIjy5/edraHpfriNGktf6h7t/R0bpYzJ+mIlU5lZdK4Rs?=
 =?us-ascii?Q?V9YQ7gG0J8gIgvJ6c5e2aFlOp/FyfkkTo2CvtLh9XmUe64kgPreMnsdz+TpB?=
 =?us-ascii?Q?lR3PMZxYIHI99pr3jAzAwPF0C1Y9HQf+vIxABq1r8xMJMdwQ4SFODlY524D1?=
 =?us-ascii?Q?Hzs4KKhaU0cBF6IAKo6IVtI4l18xk51uCA4jvTc3lfO49dd1KDNpEQdrR79q?=
 =?us-ascii?Q?iGFC+G9IrIoM6ci9aPoKmg9H7ciY4BfKljmP86AzdBb/eKVwdNfC7M8fPLbo?=
 =?us-ascii?Q?X4yw59iXIzdMpBG70RysL4eSi///irbr0ywS43yiL9G3vZN88mnDxkLMxgal?=
 =?us-ascii?Q?/iLuxreoWVH5UdHJhhHdLwU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d5130da-b293-430c-dd06-08d9f076fb50
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4587.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 11:33:26.6573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tmdt4u90SgmwVNYQq3YM2PtMugH+ZeucnX20K37sRg9kBxTQ6LREyqr9M2SxMtMxXvmtFxP4WUYFBivLc0rAPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3271
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150065
X-Proofpoint-ORIG-GUID: iySaOSIaszzJBdj6JS5utVVvvA8unyXP
X-Proofpoint-GUID: iySaOSIaszzJBdj6JS5utVVvvA8unyXP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 15 Feb 2022 at 15:03, Dave Chinner wrote:
> On Tue, Feb 15, 2022 at 12:18:50PM +0530, Chandan Babu R wrote:
>> On 14 Feb 2022 at 22:37, Darrick J. Wong wrote:
>> > On Fri, Feb 11, 2022 at 05:40:30PM +0530, Chandan Babu R wrote:
>> >> On 07 Feb 2022 at 22:41, Darrick J. Wong wrote:
>> >> > On Mon, Feb 07, 2022 at 10:25:19AM +0530, Chandan Babu R wrote:
>> >> >> On 02 Feb 2022 at 01:31, Darrick J. Wong wrote:
>> >> >> > On Fri, Jan 21, 2022 at 10:48:54AM +0530, Chandan Babu R wrote:
>> >> >> I went through all the call sites of xfs_iext_count_may_overflow() and I think
>> >> >> that your suggestion can be implemented.
>> >> 
>> >> Sorry, I missed/overlooked the usage of xfs_iext_count_may_overflow() in
>> >> xfs_symlink().
>> >> 
>> >> Just after invoking xfs_iext_count_may_overflow(), we execute the following
>> >> steps,
>> >> 
>> >> 1. Allocate inode chunk
>> >> 2. Initialize inode chunk.
>> >> 3. Insert record into inobt/finobt.
>> >> 4. Roll the transaction.
>> >> 5. Allocate ondisk inode.
>> >> 6. Add directory inode to transaction.
>> >> 7. Allocate blocks to store symbolic link path name.
>> >> 8. Log symlink's inode (data fork contains block mappings).
>> >> 9. Log data blocks containing symbolic link path name.
>> >> 10. Add name to directory and log directory's blocks.
>> >> 11. Log directory inode.
>> >> 12. Commit transaction.
>> >> 
>> >> xfs_trans_roll() invoked in step 4 would mean that we cannot move step 6 to
>> >> occur before step 1 since xfs_trans_roll would unlock the inode by executing
>> >> xfs_inode_item_committing().
>> >> 
>> >> xfs_create() has a similar flow.
>> >> 
>> >> Hence, I think we should retain the current logic of setting
>> >> XFS_DIFLAG2_NREXT64 just after reading the inode from the disk.
>> >
>> > File creation shouldn't ever run into problems with
>> > xfs_iext_count_may_overflow because (a) only symlinks get created with
>> > mapped blocks, and never more than two; and (b) we always set NREXT64
>> > (the inode flag) on new files if NREXT64 (the superblock feature bit) is
>> > enabled, so a newly created file will never require upgrading.
>> 
>> The inode representing the symbolic link being created cannot overflow its
>> data fork extent count field. However, the inode representing the directory
>> inside which the symbolic link entry is being created, might overflow its data
>> fork extent count field.
>
> I dont' think that can happen. A directory is limited in size to 3
> segments of 32GB each. In reality, only the data segment can ever
> reach 32GB as both the dabtree and free space segments are just
> compact indexes of the contents of the 32GB data segment.
>
> Hence a directory is never likely to reach more than about 40GB of
> blocks which is nowhere near large enough to overflowing a 32 bit
> extent count field.

I think you are right.

The maximum file size that can be represented by the data fork extent counter
in the worst case occurs when all extents are 1 block in size and each block
is 1k in size.

With 1k byte sized blocks, a file can reach upto,
1k * (2^31) = 2048 GB

This is much larger than the asymptotic maximum size of a directory i.e.
32GB * 3 = 96GB.

-- 
chandan
