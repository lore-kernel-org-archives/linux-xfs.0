Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 95B7F7CBF
	for <xfs@oss.sgi.com>; Thu,  4 Apr 2013 00:05:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2E295AC005
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 22:05:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id S34VfUbWMpU7Exsv for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 22:05:15 -0700 (PDT)
Message-ID: <515D0A09.5030808@sandeen.net>
Date: Thu, 04 Apr 2013 00:05:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs: xfs: fallback to vmalloc for large buffers in
	xfs_attrlist_by_handle
References: <515CB2C1.1050109@tlinx.org> <20130404035237.GA12011@dastard>
In-Reply-To: <20130404035237.GA12011@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 4/3/13 10:52 PM, Dave Chinner wrote:
> On Wed, Apr 03, 2013 at 03:52:49PM -0700, Linda Walsh wrote:
>>
>> Note -- I might have more attributes than some as the disks are shared via samba
>> w/windows
>> and samba stores ACL and xattr info from windows in xfs's attrs...
>>
>>
>> xfsdump: WARNING: could not get list of root attributes for nondir ino
>> 3412893285: Cannot allocate memory (12)
> 
> ....
>> [1007383.689492] xfsdump: page allocation failure: order:4, mode:0x10c0d0
> ....
>> [1007383.689531]  [<ffffffff81143a54>] kmalloc_order_trace+0x34/0xe0
>> [1007383.689534]  [<ffffffff81146546>] __kmalloc+0x186/0x190
>> [1007383.689541]  [<ffffffff8124263c>] xfs_attrlist_by_handle+0x8c/0x110
>> [1007383.689544]  [<ffffffff81243487>] xfs_file_ioctl+0x437/0xb60
> 
> So it's the attribute handle interfaces that need the vmalloc
> treatment here, just like has been done for all the other attribute
> interfaces....

Like this?

From: Eric Sandeen <sandeen@redhat.com>

xfs: fallback to vmalloc for large buffers in xfs_attrlist_by_handle

Shamelessly copied from dchinner's:
ad650f5b xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get
    
xfsdump uses for a large buffer for extended attributes, which has a
kmalloc'd shadow buffer in the kernel. This can fail after the
system has been running for some time as it is a high order
allocation. Add a fallback to vmalloc so that it doesn't require
contiguous memory and so won't randomly fail while xfsdump is
running.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

built & tested by running through xfstests ./check -g dump

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d681e34..5e99968 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -422,9 +422,12 @@ xfs_attrlist_by_handle(
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	kbuf = kzalloc(al_hreq.buflen, GFP_KERNEL);
-	if (!kbuf)
-		goto out_dput;
+	kbuf = kmem_zalloc(al_hreq.buflen, KM_SLEEP | KM_MAYFAIL);
+	if (!kbuf) {
+		kbuf = kmem_zalloc_large(al_hreq.buflen);
+		if (!kbuf)
+			goto out_dput;
+	}
 
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
 	error = -xfs_attr_list(XFS_I(dentry->d_inode), kbuf, al_hreq.buflen,
@@ -436,7 +439,10 @@ xfs_attrlist_by_handle(
 		error = -EFAULT;
 
  out_kfree:
-	kfree(kbuf);
+	if (is_vmalloc_addr(kbuf))
+		kmem_free_large(kbuf);
+	else
+		kmem_free(kbuf);
  out_dput:
 	dput(dentry);
 	return error;



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
