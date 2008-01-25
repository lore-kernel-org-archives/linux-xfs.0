Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jan 2008 23:08:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0P77qZs000898
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 23:07:57 -0800
Date: Fri, 25 Jan 2008 18:08:00 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/1] XFS: Replace custom AIL linked-list code with struct list_head
Message-ID: <20080125070800.GH155407@sgi.com>
References: <1200875757-26598-1-git-send-email-jeffpc@josefsipek.net> <20080121040422.GA25541@infradead.org> <20080121040740.GA14938@josefsipek.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121040740.GA14938@josefsipek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sun, Jan 20, 2008 at 11:07:40PM -0500, Josef 'Jeff' Sipek wrote:
> On Mon, Jan 21, 2008 at 04:04:23AM +0000, Christoph Hellwig wrote:
> > On Sun, Jan 20, 2008 at 07:35:57PM -0500, Josef 'Jeff' Sipek wrote:
> > > Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> > > ---
> > > 
> > > I tested it with xfsqa, and things work as well as they do without it.
> > 
> > I like this a lot, but I think Dave has plans to replace the linked list
> > with a more efficient data structure soon, so it might not actually be
> > worth applying.
> 
> I've spoken with him about this, and he wants to have a tree where the
> leaves have linked lists (if I understood correctly). So this just makes it
> easier/cleaner for him.

Sort of.

Few things that really should be done in this first patch. Rather
than passing listheads to the xfs_ail_*() functions, it should
really be changed to pass the xfs_ail_t to those functions. The
structure of the list should be opaque to everything outside these
functions.

It also needs to build with XFS_DEBUG enabled - that means
xfs_ail_check needs updating, but I've already got a patch
for the other bit (xfsidbg.c) that works which is attached below.

Cheers,

Dave.

---
make xfsidbg.c compile and work with listhead based AIL.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfsidbg.c |   66 +++++++++++++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2008-01-21 16:23:35.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2008-01-21 18:16:11.450796254 +1100
@@ -6167,7 +6167,7 @@ xfsidbg_xlogitem(xfs_log_item_t *lip)
 	printflags((uint)(lip->li_flags), li_flags,"log");
 	kdb_printf("\n");
 	kdb_printf("ail forw 0x%p ail back 0x%p lsn %s\ndesc %p ops 0x%p",
-		lip->li_ail.ail_forw, lip->li_ail.ail_back,
+		lip->li_ail.next, lip->li_ail.next,
 		xfs_fmtlsn(&(lip->li_lsn)), lip->li_desc, lip->li_ops);
 	kdb_printf(" iodonefunc &0x%p\n", lip->li_cb);
 	if (lip->li_type == XFS_LI_BUF) {
@@ -6220,45 +6220,39 @@ xfsidbg_xaildump(xfs_mount_t *mp)
 		};
 	int count;
 
-	if ((mp->m_ail.xa_ail.ail_forw == NULL) ||
-	    (mp->m_ail.xa_ail.ail_forw == (xfs_log_item_t *)&mp->m_ail.xa_ail)) {
+	if (list_empty(&mp->m_ail.xa_ail)) {
 		kdb_printf("AIL is empty\n");
 		return;
 	}
 	kdb_printf("AIL for mp 0x%p, oldest first\n", mp);
-	lip = (xfs_log_item_t*)mp->m_ail.xa_ail.ail_forw;
-	for (count = 0; lip; count++) {
-		kdb_printf("[%d] type %s ", count, xfsidbg_item_type_str(lip));
-		printflags((uint)(lip->li_flags), li_flags, "flags:");
-		kdb_printf("  lsn %s\n   ", xfs_fmtlsn(&(lip->li_lsn)));
-		switch (lip->li_type) {
-		case XFS_LI_BUF:
-			xfs_buf_item_print((xfs_buf_log_item_t *)lip, 1);
-			break;
-		case XFS_LI_INODE:
-			xfs_inode_item_print((xfs_inode_log_item_t *)lip, 1);
-			break;
-		case XFS_LI_EFI:
-			xfs_efi_item_print((xfs_efi_log_item_t *)lip, 1);
-			break;
-		case XFS_LI_EFD:
-			xfs_efd_item_print((xfs_efd_log_item_t *)lip, 1);
-			break;
-		case XFS_LI_DQUOT:
-			xfs_dquot_item_print((xfs_dq_logitem_t *)lip, 1);
-			break;
-		case XFS_LI_QUOTAOFF:
-			xfs_qoff_item_print((xfs_qoff_logitem_t *)lip, 1);
-			break;
-		default:
-			kdb_printf("Unknown item type %d\n", lip->li_type);
-			break;
-		}
-
-		if (lip->li_ail.ail_forw == (xfs_log_item_t*)&mp->m_ail.xa_ail) {
-			lip = NULL;
-		} else {
-			lip = lip->li_ail.ail_forw;
+	list_for_each_entry(lip, &mp->m_ail.xa_ail, li_ail) {
+		for (count = 0; lip; count++) {
+			kdb_printf("[%d] type %s ", count, xfsidbg_item_type_str(lip));
+			printflags((uint)(lip->li_flags), li_flags, "flags:");
+			kdb_printf("  lsn %s\n   ", xfs_fmtlsn(&(lip->li_lsn)));
+			switch (lip->li_type) {
+			case XFS_LI_BUF:
+				xfs_buf_item_print((xfs_buf_log_item_t *)lip, 1);
+				break;
+			case XFS_LI_INODE:
+				xfs_inode_item_print((xfs_inode_log_item_t *)lip, 1);
+				break;
+			case XFS_LI_EFI:
+				xfs_efi_item_print((xfs_efi_log_item_t *)lip, 1);
+				break;
+			case XFS_LI_EFD:
+				xfs_efd_item_print((xfs_efd_log_item_t *)lip, 1);
+				break;
+			case XFS_LI_DQUOT:
+				xfs_dquot_item_print((xfs_dq_logitem_t *)lip, 1);
+				break;
+			case XFS_LI_QUOTAOFF:
+				xfs_qoff_item_print((xfs_qoff_logitem_t *)lip, 1);
+				break;
+			default:
+				kdb_printf("Unknown item type %d\n", lip->li_type);
+				break;
+			}
 		}
 	}
 }
