Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36728 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727133AbeLMK3l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Dec 2018 05:29:41 -0500
From: Luis Henriques <lhenriques@suse.com>
Subject: Re: [PATCH 04/11] vfs: add missing checks to copy_file_range
References: <20181203083416.28978-1-david@fromorbit.com>
        <20181203083416.28978-5-david@fromorbit.com> <87a7lbrng4.fsf@suse.com>
        <CAN-5tyHNGtLxeFyEO6qX_+8=K4tpkgYjB11OkfCTdWfokfAyEg@mail.gmail.com>
        <20181212194258.GK6830@bombadil.infradead.org>
        <CAN-5tyGmdrbbiej_mMosYKrCzOEuKMKJALfOJxvbBqHwZFiUOw@mail.gmail.com>
Date: Thu, 13 Dec 2018 10:29:52 +0000
In-Reply-To: <CAN-5tyGmdrbbiej_mMosYKrCzOEuKMKJALfOJxvbBqHwZFiUOw@mail.gmail.com>
        (Olga Kornievskaia's message of "Wed, 12 Dec 2018 15:22:23 -0500")
Message-ID: <87bm5pra73.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: willy@infradead.org, david@fromorbit.com, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs <linux-nfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

Olga Kornievskaia <olga.kornievskaia@gmail.com> writes:

> On Wed, Dec 12, 2018 at 2:43 PM Matthew Wilcox <willy@infradead.org> wrote:
>>
>> On Wed, Dec 12, 2018 at 01:55:28PM -0500, Olga Kornievskaia wrote:
>> > On Wed, Dec 12, 2018 at 6:31 AM Luis Henriques <lhenriques@suse.com> wrote:
>> > > I was wondering if, with the above check, it would make sense to also
>> > > have an extra patch changing some filesystems (ceph, nfs and cifs) to
>> > > simply return -EOPNOTSUPP (instead of -EINVAL) when inode_in ==
>> > > inode_out.  Something like the diff below (not tested!).
>>
>> > > +++ b/fs/nfs/nfs4file.c
>> > > @@ -136,7 +136,7 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
>> > >         ssize_t ret;
>> > >
>> > >         if (file_inode(file_in) == file_inode(file_out))
>> > > -               return -EINVAL;
>> > > +               return -EOPNOTSUPP;
>> >
>> > Please don't change the NFS bits. This is against the NFS
>> > specifications. RFC 7862 15.2.3
>> >
>> > (snippet)
>> > SAVED_FH and CURRENT_FH must be different files.  If SAVED_FH and
>> >    CURRENT_FH refer to the same file, the operation MUST fail with
>> >    NFS4ERR_INVAL.
>>
>> I don't see how that applies.  That refers to a requirement _in the
>> protocol_ that determines what the server MUST do if the client sends
>> it two FHs which refer to the same file.
>>
>> What we're talking about here is how a Linux filesystem behaves when
>> receiving a copy_file_range() referring to the same file.  As long as
>> the Linux filesystem doesn't react by sending out one of these invalid
>> protocol messages, I don't see the problem.
>
> Ok then this should be changed to call generic_copy_file_range() not
> returning the EOPNOTSUPP since there is no longer fallback in vfs to
> call the generic_copy_file_range() and in turn responsibility of each
> file system.

Ah, I didn't look close enough and didn't realised the nfs code was
doing something slightly different from the other 2 FSs.  In that case
simply deleting that check seems to be enough to fallback to the vfs
generic_copy_file_range.

Anyway, please find below an updated patch (with proper changelog).

Cheers,
-- 
Luis

>From f66a07e22dc93827bdafc1666d4980edc986bce4 Mon Sep 17 00:00:00 2001
From: Luis Henriques <lhenriques@suse.com>
Date: Thu, 13 Dec 2018 10:19:54 +0000
Subject: [PATCH] vfs: fallback to generic_copy_file_range if copying within
 the same file

If source and destination inode are the same simply fallback to the VFS
generic_copy_file_range, as we've already checked overlapping areas in
generic_copy_file_checks.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/file.c    | 2 +-
 fs/cifs/cifsfs.c  | 2 +-
 fs/nfs/nfs4file.c | 3 ---
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index eb876e19c1dc..ff48dc52c30e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1904,7 +1904,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	bool do_final_copy = false;
 
 	if (src_inode == dst_inode)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	if (src_inode->i_sb != dst_inode->i_sb)
 		return -EXDEV;
 	if (ceph_snap(dst_inode) != CEPH_NOSNAP)
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 03e4b9eacbd1..3c66454c59b6 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1068,7 +1068,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	cifs_dbg(FYI, "copychunk range\n");
 
 	if (src_inode == target_inode) {
-		rc = -EINVAL;
+		rc = -EOPNOTSUPP;
 		goto out;
 	}
 
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 4783c0c1c49e..dc7f344849e9 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -135,9 +135,6 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
 {
 	ssize_t ret = -EXDEV;
 
-	if (file_inode(file_in) == file_inode(file_out))
-		return -EINVAL;
-
 	/* only offload copy if superblock is the same */
 	if (file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {
 		do {
