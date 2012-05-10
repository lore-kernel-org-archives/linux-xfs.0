Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4AGhOpa035193
	for <linux-xfs@oss.sgi.com>; Thu, 10 May 2012 11:43:25 -0500
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id Cr5E7YHpW2YPcD7V (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Thu, 10 May 2012 09:43:23 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1SSWSX-0007nk-On
	for linux-xfs@oss.sgi.com; Thu, 10 May 2012 18:43:21 +0200
Received: from tc-gate1.pci.uni-heidelberg.de ([129.206.21.241])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 10 May 2012 18:43:21 +0200
Received: from bernd.schubert by tc-gate1.pci.uni-heidelberg.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 10 May 2012 18:43:21 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: kernel panic / NULL pointer dereference
Date: Thu, 10 May 2012 18:43:10 +0200
Message-ID: <4FABF01E.7080303@itwm.fraunhofer.de>
References: <jognqm$o21$1@dough.gmane.org>
Mime-Version: 1.0
In-Reply-To: <jognqm$o21$1@dough.gmane.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On 05/10/2012 05:45 PM, Bernd Schubert wrote:
> Hi all,
> 
> I'm just playing with an SRP connected NetApp system and just got an XFS 
> related kernel panic. I guess it is due to large IO (32MiB). At least it 
> just came up after enabling 32MiB device max_sectors.
> As the tests are running in a RHEL6 image and as I needed at least 
> 2.6.39 to get a large srp_tablsize with SRP, I simply installed the 
> lasted oracle uek kernel. If needed I'm going to update to a vanilla 
> version.
> 
> 
>> May 10 17:31:49 sgi01 kernel: XFS (sdb): Mounting Filesystem
>> May 10 17:31:49 sgi01 kernel: XFS (sdb): Ending clean mount
>> May 10 17:33:00 sgi01 kernel: BUG: unable to handle kernel NULL 
>> pointer dereference at (null)
>> May 10 17:33:00 sgi01 kernel: IP: [<ffffffffa07f5483>] 
>> xfs_alloc_ioend_bio+0x33/0x50 [xfs]

Oh, there is a bio allocation path to return NULL:

bvec_alloc_bs(gfp_mask, nr_iovecs, ) => NULL when nr_iovecs  > BIO_MAX_PAGES
bio_alloc_bioset(gfp_mask, nr_iovecs, ...)
bio_alloc(GFP_NOIO, nvecs)
xfs_alloc_ioend_bio()

And nvecs/nr_iovecs is obtained by bio_get_nr_vecs(), which does not check for
BIO_MAX_PAGES. Of course, all of that only happens with large IO sizes, 
which is exactly what I'm doing.
As xfs_alloc_ioend_bio() is using GFP_NOIO it does not expect bio_alloc 
to fail, but as I'm trying to send large IOs I guess that is exactly what happens here.


>May 10 17:33:00 sgi01 kernel: [<ffffffffa07f561e>] xfs_submit_ioend+0xfe/0x110 [xfs]
>May 10 17:33:00 sgi01 kernel: [<ffffffffa07f696b>] xfs_vm_writepage+0x26b/0x510 [xfs]
>May 10 17:33:00 sgi01 kernel: [<ffffffff81112377>] __writepage+0x17/0x40
>May 10 17:33:00 sgi01 kernel: [<ffffffff81113696>] write_cache_pages+0x246/0x520
>May 10 17:33:00 sgi01 kernel: [<ffffffff81112360>] ? set_page_dirty+0x70/0x70
>May 10 17:33:00 sgi01 kernel: [<ffffffff811139c1>] generic_writepages+0x51/0x80
>May 10 17:33:00 sgi01 kernel: [<ffffffffa07f537d>] xfs_vm_writepages+0x5d/0x80 [xfs]
>May 10 17:33:00 sgi01 kernel: [<ffffffff81113a11>] do_writepages+0x21/0x40
>May 10 17:33:00 sgi01 kernel: [<ffffffff8118df2e>] writeback_single_inode+0x10e/0x270

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
