Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E6DD57CA2
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 05:40:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5D0E0AC001
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 03:39:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yEW6FYzs7hsnFZ22 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 01 Sep 2016 03:39:57 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id F33C31303
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 10:39:56 +0000 (UTC)
Received: from localhost (dhcp-13-153.nay.redhat.com [10.66.13.153])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u81AdtGk001207
	for <xfs@oss.sgi.com>; Thu, 1 Sep 2016 06:39:56 -0400
Date: Thu, 1 Sep 2016 18:39:55 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: BUG: Internal error xfs_trans_cancel at line 984 of file
	fs/xfs/xfs_trans.c
Message-ID: <20160901103955.GD27776@eguan.usersys.redhat.com>
References: <20160829103754.GH27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160829103754.GH27776@eguan.usersys.redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Mon, Aug 29, 2016 at 06:37:54PM +0800, Eryu Guan wrote:
> Hi,
> 
> I've hit an XFS internal error then filesystem shutdown with 4.8-rc3
> kernel but not with 4.8-rc2
> 
[snip]
>
> So it's likely a regression introduced in 4.8-rc3, and my bisect test
> pointed to commit 0af32fb468b4 ("xfs: fix bogus space reservation in
> xfs_iomap_write_allocate").

This might be buried in the report, I've bisected this down to

commit 0af32fb468b4a4434dd759d68611763658650b59
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Aug 17 08:30:28 2016 +1000

    xfs: fix bogus space reservation in xfs_iomap_write_allocate
    
    The space reservations was without an explaination in commit
    
        "Add error reporting calls in error paths that return EFSCORRUPTED"
    
    back in 2003.  There is no reason to reserve disk blocks in the
    transaction when allocating blocks for delalloc space as we already
    reserved the space when creating the delalloc extent.
    
    With this fix we stop running out of the reserved pool in
    generic/229, which has happened for long time with small blocksize
    file systems, and has increased in severity with the new buffered
    write path.
    
    [ dchinner: we still need to pass the block reservation into
      xfs_bmapi_write() to ensure we don't deadlock during AG selection.
      See commit dbd5c8c ("xfs: pass total block res. as total
      xfs_bmapi_write() parameter") for more details on why this is
      necessary. ]
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

Just make it more clear.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
