Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AFD3329E2C
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 19:01:55 -0500 (CDT)
Date: Tue, 7 May 2013 19:01:52 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: xfs: fallback to vmalloc for large buffers in
	xfs_attrlist_by_handle
Message-ID: <20130508000152.GR29359@sgi.com>
References: <515CB2C1.1050109@tlinx.org> <20130404035237.GA12011@dastard>
	<515D0A09.5030808@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <515D0A09.5030808@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Apr 04, 2013 at 12:05:13AM -0500, Eric Sandeen wrote:
> On 4/3/13 10:52 PM, Dave Chinner wrote:
> > On Wed, Apr 03, 2013 at 03:52:49PM -0700, Linda Walsh wrote:
> >>
> >> Note -- I might have more attributes than some as the disks are shared via samba
> >> w/windows
> >> and samba stores ACL and xattr info from windows in xfs's attrs...
> >>
> >>
> >> xfsdump: WARNING: could not get list of root attributes for nondir ino
> >> 3412893285: Cannot allocate memory (12)
> > 
> > ....
> >> [1007383.689492] xfsdump: page allocation failure: order:4, mode:0x10c0d0
> > ....
> >> [1007383.689531]  [<ffffffff81143a54>] kmalloc_order_trace+0x34/0xe0
> >> [1007383.689534]  [<ffffffff81146546>] __kmalloc+0x186/0x190
> >> [1007383.689541]  [<ffffffff8124263c>] xfs_attrlist_by_handle+0x8c/0x110
> >> [1007383.689544]  [<ffffffff81243487>] xfs_file_ioctl+0x437/0xb60
> > 
> > So it's the attribute handle interfaces that need the vmalloc
> > treatment here, just like has been done for all the other attribute
> > interfaces....
> 
> Like this?
> 
> From: Eric Sandeen <sandeen@redhat.com>
> 
> xfs: fallback to vmalloc for large buffers in xfs_attrlist_by_handle
> 
> Shamelessly copied from dchinner's:
> ad650f5b xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get
>     
> xfsdump uses for a large buffer for extended attributes, which has a
> kmalloc'd shadow buffer in the kernel. This can fail after the
> system has been running for some time as it is a high order
> allocation. Add a fallback to vmalloc so that it doesn't require
> contiguous memory and so won't randomly fail while xfsdump is
> running.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
