Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757806AbeAHVj6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jan 2018 16:39:58 -0500
Message-ID: <1515447593.3486.54.camel@kernel.org>
Subject: Re: [PATCH v4 19/19] fs: handle inode->i_version more efficiently
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 08 Jan 2018 16:39:53 -0500
In-Reply-To: <20180108201713.rdfjn7j65cuqmwuo@kozik-lap>
References: <20171222120556.7435-1-jlayton@kernel.org>
         <20171222120556.7435-20-jlayton@kernel.org>
         <CAJKOXPd8ojTjiGF3nKQKWtVrEsjWfjvg6rLL+RGnbu_SZMDu7g@mail.gmail.com>
         <1515416208.3486.14.camel@kernel.org>
         <CAJKOXPfv4eSERDiUuZuJ7KdpyGU0=Eqt_A+J6knp-FEW9BZoSw@mail.gmail.com>
         <1515418164.3486.18.camel@kernel.org>
         <20180108172928.aqndozcpljb73uj6@kozik-lap>
         <1515434419.3486.41.camel@kernel.org>
         <20180108183353.emiwsd4aic4gmytr@kozik-lap>
         <1515438929.3486.48.camel@kernel.org>
         <20180108201713.rdfjn7j65cuqmwuo@kozik-lap>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com, linux-samsung-soc@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>, =?UTF-8?Q?Bart=C5=82omiej_?= =?UTF-8?Q?=C5=BBo=C5=82nierkiewicz?= <b.zolnierkie@samsung.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>

On Mon, 2018-01-08 at 21:17 +0100, Krzysztof Kozlowski wrote:
> On Mon, Jan 08, 2018 at 02:15:29PM -0500, Jeff Layton wrote:
> > On Mon, 2018-01-08 at 19:33 +0100, Krzysztof Kozlowski wrote:
> > > On Mon, Jan 08, 2018 at 01:00:19PM -0500, Jeff Layton wrote:
> > > > On Mon, 2018-01-08 at 18:29 +0100, Krzysztof Kozlowski wrote:
> > > 
> > > (...)
> > > 
> > > > > > Ok, thanks. If you're seeing hangs then that might imply that we have
> > > > > > some sort of excessive looping going on in the cmpxchg loops.
> > > > > > 
> > > > > > Could you apply the patch below and let me know if it causes either of
> > > > > > the warnings to pop? That might at least point us in the right
> > > > > > direction:
> > > > > 
> > > > > No new warnings with attached patch (except existing already lockdep:
> > > > > "INFO: trying to register non-static key.").
> > > > > 
> > > > 
> > > > Yeah, I saw that in the original logs and it looks unrelated (and
> > > > harmless).
> > > > 
> > > > > Systemd timeouts on mounting /home but after entering rescue shell there
> > > > > is no problem running mount /home:
> > > > > 	Give root password for maintenance
> > > > > 	(or press Control-D to continue): 
> > > > > 	root@odroidxu3:~# mount /home
> > > > > 	[  220.659331] EXT4-fs (mmcblk1p2): mounted filesystem with ordered data mode. Opts: (null)
> > > > > 
> > > > 
> > > > Ok, thanks for testing it. So I guess we can probably rule out excessive
> > > > looping in those functions as the issue.
> > > > 
> > > > To make sure I understand the problem: When systemd tries to do the
> > > > initial mount of /home (which is an ext4 filesystem), it hangs. But once
> > > > it drops to the shell, it works, if you do the mount by hand.
> > > > 
> > > > Is that correct?
> > > 
> > > Yes, although it also timeouts on setting up /dev/ttySAC2 (serial
> > > console).
> > > 
> > > > If so, then is it possible to trigger sysrq commands during the hanging
> > > > mount attempt? Maybe you could use e.g. sysrq-l, sysrq-w, etc. to
> > > > determine what it's blocking on?
> > 
> > (trimming the output)
> > 
> > Thanks. I don't really see anything obvious in that info,
> > unfortunately. What we really need to do is find the systemd task
> > performing the mount, and see what it's doing.
> 
> It's systemd 236.0-2 coming from Arch Linux for ARM. All packages are
> updated.
> 
> > We do have one questionable bug in the NFS changes though. Does this
> > patch help at all?
> 
> Patches do not change anything (I tried "SQUASH: nfs: fix i_version
> increment when adding a request" and "SQUASH: ext4: use raw API for
> xattr inode refcounts").
> 
> I tried again regular SDcard-root boot and it succeeded. Only nfsroot
> fails.
> 
> Best regards,
> Krzysztof
> 

Got it, that's helpful. Does this patch help (on top of the others) ?

------------------------8<--------------------------

SQUASH: nfs: compare raw iversion counter since that's what's
 being stored

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/nfs/inode.c           |  6 +++---
 include/linux/iversion.h | 13 +++++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 0b85cca1184b..93552c482992 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1289,7 +1289,7 @@ static unsigned long nfs_wcc_update_inode(struct inode *inode, struct nfs_fattr
 
 	if ((fattr->valid & NFS_ATTR_FATTR_PRECHANGE)
 			&& (fattr->valid & NFS_ATTR_FATTR_CHANGE)
-			&& !inode_cmp_iversion(inode, fattr->pre_change_attr)) {
+			&& !inode_cmp_iversion_raw(inode, fattr->pre_change_attr)) {
 		inode_set_iversion_raw(inode, fattr->change_attr);
 		if (S_ISDIR(inode->i_mode))
 			nfs_set_cache_invalid(inode, NFS_INO_INVALID_DATA);
@@ -1348,7 +1348,7 @@ static int nfs_check_inode_attributes(struct inode *inode, struct nfs_fattr *fat
 
 	if (!nfs_file_has_buffered_writers(nfsi)) {
 		/* Verify a few of the more important attributes */
-		if ((fattr->valid & NFS_ATTR_FATTR_CHANGE) != 0 && inode_cmp_iversion(inode, fattr->change_attr))
+		if ((fattr->valid & NFS_ATTR_FATTR_CHANGE) != 0 && inode_cmp_iversion_raw(inode, fattr->change_attr))
 			invalid |= NFS_INO_INVALID_ATTR | NFS_INO_REVAL_PAGECACHE;
 
 		if ((fattr->valid & NFS_ATTR_FATTR_MTIME) && !timespec_equal(&inode->i_mtime, &fattr->mtime))
@@ -1778,7 +1778,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 
 	/* More cache consistency checks */
 	if (fattr->valid & NFS_ATTR_FATTR_CHANGE) {
-		if (inode_cmp_iversion(inode, fattr->change_attr)) {
+		if (inode_cmp_iversion_raw(inode, fattr->change_attr)) {
 			dprintk("NFS: change_attr change on server for file %s/%ld\n",
 					inode->i_sb->s_id, inode->i_ino);
 			/* Could it be a race with writeback? */
diff --git a/include/linux/iversion.h b/include/linux/iversion.h
index 107fcb3ec809..8c97f67ffbbc 100644
--- a/include/linux/iversion.h
+++ b/include/linux/iversion.h
@@ -190,6 +190,19 @@ inode_query_iversion(struct inode *inode)
 	return inode_peek_iversion(inode);
 }
 
+/**
+ * inode_cmp_iversion_raw - check whether the raw i_version counter has changed
+ * @inode: inode to check
+ * @old: old value to check against its i_version
+ *
+ * Compare the current raw i_version counter with a previous one. Returns 0 if
+ * they are the same or non-zero if they are different.
+ */
+static inline s64
+inode_cmp_iversion_raw(const struct inode *inode, u64 old)
+{
+	return (s64)inode_peek_iversion(inode) - (s64)old;
+}
 /**
  * inode_cmp_iversion - check whether the i_version counter has changed
  * @inode: inode to check
-- 
2.14.3

