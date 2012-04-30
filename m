Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3U88Jvf224921 for <xfs@oss.sgi.com>; Mon, 30 Apr 2012 03:08:20 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id 9y1LiJ8C7PyMkhTD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Apr 2012 01:08:16 -0700 (PDT)
Message-ID: <4F9E4874.8050505@profihost.ag>
Date: Mon, 30 Apr 2012 10:08:20 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Kernel 3.0.30 hang in xfs_submit_ioend_bio
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, gregkh@linuxfoundation.org, stable@vger.kernel.org

Hi,

while running several systems with 3.0.30 i'm seeing this call trace 
pretty often. Is this problem known?

[925680.203973] Call Trace:
[925680.204038]  [<c02f1f82>] ? xfs_bmap_search_extents+0x52/0xf0
[925680.204118]  [<c0164e9a>] ? ktime_get_ts+0xba/0xf0
[925680.204170]  [<c0610ce0>] schedule+0x30/0x50
[925680.204221]  [<c0610d71>] io_schedule+0x71/0xb0
[925680.204273]  [<c0362420>] get_request_wait+0xa0/0x150
[925680.204326]  [<c015afd0>] ? wake_up_bit+0x60/0x60
[925680.204376]  [<c03625c6>] __make_request+0xf6/0x280
[925680.204427]  [<c036143d>] generic_make_request+0x3fd/0x610
[925680.204481]  [<c01d03ca>] ? kmem_cache_alloc+0xfa/0x110
[925680.204532]  [<c0336a46>] ? xfs_convert_page+0x166/0x310
[925680.204586]  [<c01a32fe>] ? mempool_alloc_slab+0xe/0x10
[925680.204639]  [<c01a32fe>] ? mempool_alloc_slab+0xe/0x10
[925680.204690]  [<c01a32fe>] ? mempool_alloc_slab+0xe/0x10
[925680.204741]  [<c03616ba>] submit_bio+0x6a/0x100
[925680.204792]  [<c01fec09>] ? bvec_alloc_bs+0x49/0xe0
[925680.204843]  [<c01fed21>] ? bio_alloc_bioset+0x81/0xb0
[925680.204894]  [<c03366a7>] xfs_submit_ioend_bio+0x47/0x70
[925680.204946]  [<c03367a4>] xfs_submit_ioend+0xd4/0xe0
[925680.204998]  [<c0337ba3>] xfs_vm_writepage+0x253/0x580
[925680.205056]  [<c01fa127>] ? free_buffer_head+0x17/0x30
[925680.205109]  [<c01ae8ca>] shrink_page_list+0x55a/0x750
[925680.205162]  [<c01aed60>] shrink_inactive_list+0x1a0/0x350
[925680.205214]  [<c01af321>] shrink_zone+0x411/0x570
[925680.205265]  [<c01af9fe>] kswapd+0x57e/0x9c0
[925680.205315]  [<c015afd0>] ? wake_up_bit+0x60/0x60
[925680.205365]  [<c01af480>] ? shrink_zone+0x570/0x570
[925680.205415]  [<c015ac14>] kthread+0x74/0x80
[925680.205464]  [<c015aba0>] ? kthread_worker_fn+0x140/0x140
[925680.205516]  [<c06137be>] kernel_thread_helper+0x6/0xd


Greets Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
