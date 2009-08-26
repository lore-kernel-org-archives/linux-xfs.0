Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7QHtCJr027885 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 12:55:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 475BB3FF54A
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 10:56:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Qp91SMsFwnCuVEOM for
	<xfs@oss.sgi.com>; Wed, 26 Aug 2009 10:56:05 -0700 (PDT)
Date: Wed, 26 Aug 2009 13:56:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: disk performance strange/low
Message-ID: <20090826175603.GA14019@infradead.org>
References: <200908172311.07660@zmi.at> <200908180408.10738@zmi.at>
	<20090818024350.GA3591@infradead.org> <200908261920.47054@zmi.at>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <200908261920.47054@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 26, 2009 at 07:20:36PM +0200, Michael Monnerie wrote:
> On Dienstag 18 August 2009 Christoph Hellwig wrote:
> > On Tue, Aug 18, 2009 at 04:08:05AM +0200, Michael Monnerie wrote:
> > > On Montag 17 August 2009 Christoph Hellwig wrote:
> > > > Yes, that sounds like the problem of the VM not feeding us enough
> > > > pages to write. ?What kernel is this on? ?Latest 2.6.31-rc has a
> > > > workaround for it.
> > >
> > > 2.6.27.23-0.1-xen from openSUSE 11.1
> > > I can't switch as I use it with the free Xen. Thanks for the info.
> >
> > Try backporting commit c8a4051c3731b6db224482218cfd535ab9393ff8 from
> > mainline - it should apply just fine to a 2.6.27-ish kernel.
> 
> Thank you. I'm not a patcher, could you tell me how to do that?

Just take the patch I attached and apply it using

	patch -p1 < xfs-nr-to-write.diff

if you want to make sure it applies cleanly do a

	patch -p1 --dry-run < xfs-nr-to-write.diff

beforee to check if it doesn't cause any reject.

After that rebuild your kernel.

--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfs-nr-to-write.diff"

commit c8a4051c3731b6db224482218cfd535ab9393ff8
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Fri Jul 31 00:02:17 2009 -0500

    xfs: bump up nr_to_write in xfs_vm_writepage
    
    VM calculation for nr_to_write seems off.  Bump it way
    up, this gets simple streaming writes zippy again.
    To be reviewed again after Jens' writeback changes.
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Cc: Chris Mason <chris.mason@oracle.com>
    Reviewed-by: Felix Blyakher <felixb@sgi.com>
    Signed-off-by: Felix Blyakher <felixb@sgi.com>

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 7ec89fc..aecf251 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1268,6 +1268,14 @@ xfs_vm_writepage(
 	if (!page_has_buffers(page))
 		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
 
+
+	/*
+	 *  VM calculation for nr_to_write seems off.  Bump it way
+	 *  up, this gets simple streaming writes zippy again.
+	 *  To be reviewed again after Jens' writeback changes.
+	 */
+	wbc->nr_to_write *= 4;
+
 	/*
 	 * Convert delayed allocate, unwritten or unmapped space
 	 * to real space and flush out to disk.

--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--a8Wt8u1KmwUX3Y2C--
