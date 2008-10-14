Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 21:32:47 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E4WiVt024717
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 21:32:44 -0700
Message-ID: <48F42F12.1010409@sgi.com>
Date: Tue, 14 Oct 2008 15:33:06 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: TAKE 988255 - fix instant oops with tracing enabled
References: <20081014011747.AC14E58FA1E9@chook.melbourne.sgi.com> <20081014020556.GH10716@disturbed>
In-Reply-To: <20081014020556.GH10716@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Tue, Oct 14, 2008 at 12:17:47PM +1100, Lachlan McIlroy wrote:
>> fix instant oops with tracing enabled
>>
>> We can only read inode->i_count if the inode is actually there and not
>> a NULL pointer.  This was introduced in one of the recent sync patches.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> BTW, this now means that other pending patches won't apply cleanly....
> 

Yeah this patch hunk didn't apply but was easy to hand merge.  It also
didn't compile because of a missing comma from the 4th last line.  Can
you please make sure each of your patch series compile on their own?

@@ -84,25 +84,12 @@ vn_ioerror(
 
 #ifdef	XFS_INODE_TRACE
 
-/*
- * Reference count of Linux inode if present, -1 if the xfs_inode
- * has no associated Linux inode.
- */
-static inline int xfs_icount(struct xfs_inode *ip)
-{
-	struct inode *inode = VFS_I(ip);
-
-	if (!inode)
-		return atomic_read(&inode->i_count);
-	return -1;
-}
-
 #define KTRACE_ENTER(ip, vk, s, line, ra)			\
 	ktrace_enter(	(ip)->i_trace,				\
 /*  0 */		(void *)(__psint_t)(vk),		\
 /*  1 */		(void *)(s),				\
 /*  2 */		(void *)(__psint_t) line,		\
-/*  3 */		(void *)(__psint_t)xfs_icount(ip),	\
+/*  3 */		(void *)(__psint_t)atomic_read(&VFS_I(ip)->i_count) \
 /*  4 */		(void *)(ra),				\
 /*  5 */		NULL,					\
 /*  6 */		(void *)(__psint_t)current_cpu(),	\
