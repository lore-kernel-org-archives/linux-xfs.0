Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34265 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750793AbdGYGrn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 02:47:43 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: request for inclusion of 04197b341f23 ("xfs: don't BUG() on mixed
 direct and mapped I/O")
Message-ID: <5bcfc94b-ecb9-468b-78f3-ae5de53f62a0@suse.com>
Date: Tue, 25 Jul 2017 09:47:40 +0300
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------CF66E4C31C881A18A729F33E"
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

This is a multi-part message in MIME format.
--------------CF66E4C31C881A18A729F33E
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,

I'd like to request the aforementioned patch to be included into stable
kernels. I've attached the 4.4 backport, the patch got introduced in
4.10 so for 4.9 it will likely be able to apply cleanly, for 4.4 it
needed a bit of adjustment.

Regards,
Nikolay

--------------CF66E4C31C881A18A729F33E
Content-Type: text/x-patch;
 name="xfs-bug-on-backport.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xfs-bug-on-backport.patch"

From: Brian Foster <bfoster@redhat.com>                                         
Date: Tue, 8 Nov 2016 12:54:14 +1100                                            
Subject: xfs: don't BUG() on mixed direct and mapped I/O                        
                                                                                
We've had reports of generic/095 causing XFS to BUG() in                        
__xfs_get_blocks() due to the existence of delalloc blocks on a                 
direct I/O read. generic/095 issues a mix of various types of I/O,              
including direct and memory mapped I/O to a single file. This is                
clearly not supported behavior and is known to lead to such                     
problems. E.g., the lack of exclusion between the direct I/O and                
write fault paths means that a write fault can allocate delalloc                
blocks in a region of a file that was previously a hole after the               
direct read has attempted to flush/inval the file range, but before             
it actually reads the block mapping. In turn, the direct read                   
discovers a delalloc extent and cannot proceed.                                 
                                                                                
While the appropriate solution here is to not mix direct and memory             
mapped I/O to the same regions of the same file, the current                    
BUG_ON() behavior is probably overkill as it can crash the entire               
system.  Instead, localize the failure to the I/O in question by                
returning an error for a direct I/O that cannot be handled safely               
due to delalloc blocks. Be careful to allow the case of a direct                
write to post-eof delalloc blocks. This can occur due to speculative            
preallocation and is safe as post-eof blocks are not accompanied by             
dirty pages in pagecache (conversely, preallocation within eof must             
have been zeroed, and thus dirtied, before the inode size could have            
been increased beyond said blocks).                                             
                                                                                
Finally, provide an additional warning if a direct I/O write occurs             
while the file is memory mapped. This may not catch all problematic             
scenarios, but provides a hint that some known-to-be-problematic I/O            
methods are in use.                                       

Signed-off-by: Brian Foster <bfoster@redhat.com>                                
Reviewed-by: Dave Chinner <dchinner@redhat.com>                                 
Signed-off-by: Dave Chinner <david@fromorbit.com>                               
Signed-off-by: Nikolay Borisov <nborisov@suse.com> 
---
 fs/xfs/xfs_aops.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index d4752078b471..11fa73d8be78 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1439,6 +1439,26 @@ __xfs_get_blocks(
 	if (error)
 		goto out_unlock;
 
+	/*
+	 * The only time we can ever safely find delalloc blocks on direct I/O
+	 * is a dio write to post-eof speculative preallocation. All other
+	 * scenarios are indicative of a problem or misuse (such as mixing
+	 * direct and mapped I/O).
+	 *
+	 * The file may be unmapped by the time we get here so we cannot
+	 * reliably fail the I/O based on mapping. Instead, fail the I/O if this
+	 * is a read or a write within eof. Otherwise, carry on but warn as a
+	 * precuation if the file happens to be mapped.
+	 */
+	if (direct && imap.br_startblock == DELAYSTARTBLOCK) {
+	        if (!create || offset < i_size_read(VFS_I(ip))) {
+	                WARN_ON_ONCE(1);
+	                error = -EIO;
+	                goto out_unlock;
+	        }
+	        WARN_ON_ONCE(mapping_mapped(VFS_I(ip)->i_mapping));
+	}
+
 	/* for DAX, we convert unwritten extents directly */
 	if (create &&
 	    (!nimaps ||
@@ -1538,7 +1558,6 @@ __xfs_get_blocks(
 		set_buffer_new(bh_result);
 
 	if (imap.br_startblock == DELAYSTARTBLOCK) {
-		BUG_ON(direct);
 		if (create) {
 			set_buffer_uptodate(bh_result);
 			set_buffer_mapped(bh_result);
-- 
2.7.4


--------------CF66E4C31C881A18A729F33E--
