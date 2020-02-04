Return-Path: <SRS0=4Qc2=3Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86B0C2D0B1
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 09:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93EDE217BA
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Feb 2020 09:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgBDJQs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 04:16:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726196AbgBDJQr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 04:16:47 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0149AKWu178199
        for <linux-xfs@vger.kernel.org>; Tue, 4 Feb 2020 04:16:46 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xx936whp2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2020 04:16:46 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.ibm.com>;
        Tue, 4 Feb 2020 09:16:44 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Feb 2020 09:16:41 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0149GfWE1311194
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Feb 2020 09:16:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E779A4057;
        Tue,  4 Feb 2020 09:16:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 313F3A4040;
        Tue,  4 Feb 2020 09:16:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.102.21.204])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Feb 2020 09:16:39 +0000 (GMT)
From:   Chandan Rajendra <chandan@linux.ibm.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix invalid pointer dereference in xfs_attr3_node_inactive
Date:   Tue, 04 Feb 2020 14:49:23 +0530
Organization: IBM
In-Reply-To: <20200204070636.25572-1-zlang@redhat.com>
References: <20200204070636.25572-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-TM-AS-GCONF: 00
x-cbid: 20020409-0020-0000-0000-000003A6D1E8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20020409-0021-0000-0000-000021FE9695
Message-Id: <68736876.BgoadosnfD@localhost.localdomain>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-04_02:2020-02-04,2020-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=5
 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015 adultscore=0
 bulkscore=0 phishscore=0 spamscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002040069
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday, February 4, 2020 12:36 PM Zorro Lang wrote: 



> This patch fixes below KASAN report. The xfs_attr3_node_inactive()
> gets 'child_bp' at there:
>   error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
>                             child_blkno,
>                             XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
>                             &child_bp);
>   if (error)
>           return error;
>   error = bp->b_error;
> 
> But it turns to use 'bp', not 'child_bp'. And the 'bp' has been freed by:
>   xfs_trans_brelse(*trans, bp);

May be add a Fixes tag. The bug was introduced by the commit
2911edb653b9c64e0aad461f308cae8ce030eb7b (xfs: remove the mappedbno argument
to xfs_da_get_buf).

Apart from that, I don't see any other issue with your patch.

Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

> 
> [75626.212549] ==================================================================
> [75626.245606] BUG: KASAN: use-after-free in xfs_attr3_node_inactive+0x61e/0x8a0 [xfs]
> [75626.280164] Read of size 4 at addr ffff88881ffab004 by task rm/30390
> 
> [75626.315595] CPU: 13 PID: 30390 Comm: rm Tainted: G        W         5.5.0+ #1
> [75626.347856] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 08/02/2014
> [75626.377864] Call Trace:
> [75626.388868]  dump_stack+0x96/0xe0
> [75626.403778]  print_address_description.constprop.4+0x1f/0x300
> [75626.429656]  __kasan_report.cold.8+0x76/0xb0
> [75626.448950]  ? xfs_trans_ordered_buf+0x410/0x440 [xfs]
> [75626.472393]  ? xfs_attr3_node_inactive+0x61e/0x8a0 [xfs]
> [75626.496705]  kasan_report+0xe/0x20
> [75626.512134]  xfs_attr3_node_inactive+0x61e/0x8a0 [xfs]
> [75626.535328]  ? xfs_da_read_buf+0x235/0x2c0 [xfs]
> [75626.557270]  ? xfs_attr3_leaf_inactive+0x470/0x470 [xfs]
> [75626.583199]  ? xfs_da3_root_split+0x1050/0x1050 [xfs]
> [75626.607952]  ? lock_contended+0xd20/0xd20
> [75626.626615]  ? xfs_ilock+0x149/0x4c0 [xfs]
> [75626.644661]  ? down_write_nested+0x187/0x3c0
> [75626.663892]  ? down_write_trylock+0x2f0/0x2f0
> [75626.683496]  ? __sb_start_write+0x1c4/0x310
> [75626.702389]  ? down_read_trylock+0x360/0x360
> [75626.721669]  ? xfs_trans_buf_set_type+0x90/0x1e0 [xfs]
> [75626.745171]  xfs_attr_inactive+0x3e5/0x7b0 [xfs]
> [75626.766097]  ? xfs_attr3_node_inactive+0x8a0/0x8a0 [xfs]
> [75626.790101]  ? lock_downgrade+0x6d0/0x6d0
> [75626.808122]  ? do_raw_spin_trylock+0xb2/0x180
> [75626.827859]  ? lock_contended+0xd20/0xd20
> [75626.846154]  xfs_inactive+0x4b8/0x5b0 [xfs]
> [75626.865504]  xfs_fs_destroy_inode+0x3dc/0xb80 [xfs]
> [75626.887615]  destroy_inode+0xbc/0x1a0
> [75626.904172]  do_unlinkat+0x451/0x5d0
> [75626.920325]  ? __ia32_sys_rmdir+0x40/0x40
> [75626.938485]  ? __check_object_size+0x275/0x324
> [75626.958819]  ? strncpy_from_user+0x7d/0x350
> [75626.977848]  do_syscall_64+0x9f/0x4f0
> [75626.994333]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [75627.017173] RIP: 0033:0x7f968239567b
> [75627.033260] Code: 73 01 c3 48 8b 0d 0d d8 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 07 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d dd d7 2c 00 f7 d8 64 89 01 48
> [75627.123796] RSP: 002b:00007ffcdf66ad38 EFLAGS: 00000246 ORIG_RAX: 0000000000000107
> [75627.158521] RAX: ffffffffffffffda RBX: 0000562cd8b5d5b0 RCX: 00007f968239567b
> [75627.190764] RDX: 0000000000000000 RSI: 0000562cd8b5c380 RDI: 00000000ffffff9c
> [75627.222921] RBP: 0000562cd8b5c2f0 R08: 0000000000000003 R09: 0000000000000000
> [75627.255236] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffcdf66af20
> [75627.287435] R13: 0000000000000000 R14: 0000562cd8b5d5b0 R15: 0000000000000000
> 
> [75627.326616] Allocated by task 30390:
> [75627.342780]  save_stack+0x19/0x80
> [75627.357980]  __kasan_kmalloc.constprop.7+0xc1/0xd0
> [75627.379553]  kmem_cache_alloc+0xc8/0x300
> [75627.397288]  kmem_zone_alloc+0x10a/0x3f0 [xfs]
> [75627.417376]  _xfs_buf_alloc+0x56/0x1140 [xfs]
> [75627.437051]  xfs_buf_get_map+0x126/0x7c0 [xfs]
> [75627.457103]  xfs_buf_read_map+0xb2/0xaa0 [xfs]
> [75627.477180]  xfs_trans_read_buf_map+0x6c8/0x12d0 [xfs]
> [75627.500420]  xfs_da_read_buf+0x1d9/0x2c0 [xfs]
> [75627.520579]  xfs_da3_node_read+0x23/0x80 [xfs]
> [75627.540620]  xfs_attr_inactive+0x5c5/0x7b0 [xfs]
> [75627.561609]  xfs_inactive+0x4b8/0x5b0 [xfs]
> [75627.581541]  xfs_fs_destroy_inode+0x3dc/0xb80 [xfs]
> [75627.605628]  destroy_inode+0xbc/0x1a0
> [75627.624025]  do_unlinkat+0x451/0x5d0
> [75627.641629]  do_syscall_64+0x9f/0x4f0
> [75627.658156]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> [75627.687232] Freed by task 30390:
> [75627.701882]  save_stack+0x19/0x80
> [75627.716821]  __kasan_slab_free+0x125/0x170
> [75627.735329]  kmem_cache_free+0xcd/0x400
> [75627.752745]  xfs_buf_rele+0x30a/0xcb0 [xfs]
> [75627.772731]  xfs_attr3_node_inactive+0x1c7/0x8a0 [xfs]
> [75627.797384]  xfs_attr_inactive+0x3e5/0x7b0 [xfs]
> [75627.818450]  xfs_inactive+0x4b8/0x5b0 [xfs]
> [75627.837455]  xfs_fs_destroy_inode+0x3dc/0xb80 [xfs]
> [75627.859765]  destroy_inode+0xbc/0x1a0
> [75627.876296]  do_unlinkat+0x451/0x5d0
> [75627.892466]  do_syscall_64+0x9f/0x4f0
> [75627.909015]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> [75627.938572] The buggy address belongs to the object at ffff88881ffaad80
>                 which belongs to the cache xfs_buf of size 680
> [75627.994075] The buggy address is located 644 bytes inside of
>                 680-byte region [ffff88881ffaad80, ffff88881ffab028)
> [75628.047015] The buggy address belongs to the page:
> [75628.069056] page:ffffea00207fea00 refcount:1 mapcount:0 mapping:ffff888098515400 index:0xffff88881ffa9d40 compound_mapcount: 0
> [75628.124539] raw: 0057ffffc0010200 dead000000000100 dead000000000122 ffff888098515400
> [75628.162598] raw: ffff88881ffa9d40 0000000080270025 00000001ffffffff 0000000000000000
> [75628.197491] page dumped because: kasan: bad access detected
> 
> [75628.230389] Memory state around the buggy address:
> [75628.252072]  ffff88881ffaaf00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [75628.284801]  ffff88881ffaaf80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [75628.317587] >ffff88881ffab000: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
> [75628.350592]                    ^
> [75628.364746]  ffff88881ffab080: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
> [75628.397289]  ffff88881ffab100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [75628.429955] ==================================================================
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  fs/xfs/xfs_attr_inactive.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index bbfa6ba84dcd..26230d150bf2 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -211,7 +211,7 @@ xfs_attr3_node_inactive(
>  				&child_bp);
>  		if (error)
>  			return error;
> -		error = bp->b_error;
> +		error = child_bp->b_error;
>  		if (error) {
>  			xfs_trans_brelse(*trans, child_bp);
>  			return error;
> 


-- 
chandan



