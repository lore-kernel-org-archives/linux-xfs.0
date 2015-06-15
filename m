Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C351E7F3F
	for <xfs@oss.sgi.com>; Sun, 14 Jun 2015 22:40:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5CF98AC002
	for <xfs@oss.sgi.com>; Sun, 14 Jun 2015 20:40:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id CAMC6LoDKyf1xp7n for <xfs@oss.sgi.com>;
	Sun, 14 Jun 2015 20:40:22 -0700 (PDT)
Mime-Version: 1.0 (1.0)
Subject: Re: Script to cross-apply libxfs changes
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <55563463.1030107@redhat.com>
Date: Sun, 14 Jun 2015 22:40:19 -0500
Message-Id: <64526CC8-3975-4668-9552-3D41F9295D32@sandeen.net>
References: <55563463.1030107@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Btw you can add: 

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

To this

> On May 15, 2015, at 1:01 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> 
> I'm terrible at bash, so don't laugh.  But this more or less works for me ...
> 
> This script takes either a patch name or a commit ID in the current
> tree, and massages that change into a libxfs patch for the other tree;
> i.e. it applies a kernel libxfs patch to xfsprogs, or vice versa.
> It'll create a guilt patch if it looks like a guilt dir, or just smack
> it in with "patch" if not.
> 
> It can surely be improved, but it's a start.
> 
> Example below, and script at the end.  Requires filterdiff.
> 
> [root@bp-05 xfsprogs]# git log
> commit 9681b791929795cd7dc6c7a79c3a69354f34e0b0
> ...
> [root@bp-05 xfsprogs]# libxfs-apply /mnt/test2/git/linux-xfs/ 9681b791929795cd7dc6c7a79c3a69354f34e0b0
> Filtered patch for /mnt/test2/git/linux-xfs/ contains:
> a/fs/xfs/libxfs/xfs_alloc.c
> a/fs/xfs/libxfs/xfs_alloc_btree.c
> a/fs/xfs/libxfs/xfs_attr_leaf.c
> a/fs/xfs/libxfs/xfs_attr_remote.c
> a/fs/xfs/libxfs/xfs_bmap_btree.c
> a/fs/xfs/libxfs/xfs_btree.c
> a/fs/xfs/libxfs/xfs_da_btree.c
> a/fs/xfs/libxfs/xfs_dir2_block.c
> a/fs/xfs/libxfs/xfs_dir2_data.c
> a/fs/xfs/libxfs/xfs_dir2_leaf.c
> a/fs/xfs/libxfs/xfs_dir2_node.c
> a/fs/xfs/libxfs/xfs_dquot_buf.c
> a/fs/xfs/libxfs/xfs_format.h
> a/fs/xfs/libxfs/xfs_ialloc.c
> a/fs/xfs/libxfs/xfs_ialloc_btree.c
> a/fs/xfs/libxfs/xfs_inode_buf.c
> a/fs/xfs/libxfs/xfs_sb.c
> a/fs/xfs/libxfs/xfs_symlink_remote.c
> /mnt/test2/git/linux-xfs/ looks like a guilt directory.
> Top patch is: percpu-2
> Create new Guilt patch? (Enter patch name or return to skip) new-uuid
> Applying patch..new-uuid
> Patch applied.
> Patch was applied in /mnt/test2/git/linux-xfs/; check for rejects, guilt push -f, etc
> [root@bp-05 xfsprogs]#
> 
> ==========
> 
> #!/bin/bash
> 
> # 2 args:
> #    libxfs-apply <repo> <commit ID or patchfile>
> 
> usage()
> {
>    echo "libxfs-apply repodir [patchfile|commitid]"
>    exit
> }
> 
> cleanup()
> {
>    rm -f $PATCH $LIBXFS_FILES $NEWPATCH
> }
> 
> fail()
> {
>    cleanup
>    cd $ORIG_DIR
>    exit
> }
> 
> if [ "$#" -eq 2 -a -d "$1" -a -f "$2" ]; then
>    REPO=$1
>    PATCH=$2
> elif [ "$#" -eq 2 -a -d "$1" ]; then
>    REPO=$1
>    PATCH=`mktemp`
>    git show $2 > $PATCH || usage
> else
>    usage
> fi
> 
> 
> ORIG_DIR=`pwd`
> LIBXFS_FILES=`mktemp`
> NEWPATCH=`mktemp`
> 
> cd $REPO
> 
> # Are we using guilt? This works even if no patch is applied.
> guilt top &> /dev/null
> if [ $? -eq 0 ]; then
>    GUILT=1
> else
>    GUILT=0
> fi
> 
> # Filter the patch into the right format & files for the other tree
> 
> if   [ -d "fs/xfs/libxfs" ]; then    # We are applying a progs patch to the kernel tree
>    lsdiff $PATCH | grep -q "a/libxfs/"
>    if [ $? -ne 0 ]; then
>        echo "Doesn't look like an xfsprogs patch with libxfs changes"
>        fail
>    fi
> 
>    # The files we will try to apply to
>    ls -1 fs/xfs/libxfs/*.[ch] | sed -e "s%.*/\(.*\)%*\1%" > $LIBXFS_FILES
> 
>    # Create the new patch
>    filterdiff \
>        -I $LIBXFS_FILES \
>        --strip=1 \
>        --addoldprefix=a/fs/xfs/ \
>        --addnewprefix=b/fs/xfs/ \
>        $PATCH > $NEWPATCH 
> 
> elif [ -d "libxfs" -a -d "libxlog" ]; then    # We are applying a kernel patch to the xfsprogs tree
>    lsdiff $PATCH | grep -q "a/fs/xfs/libxfs/"
>    if [ $? -ne 0 ]; then
>        echo "Doesn't look like a kernel patch with libxfs changes"
>        fail
>    fi
> 
>    # The files we will try to apply to
>    ls -1 libxfs/*.[ch] | sed -e "s%.*/\(.*\)%*\1%" > $LIBXFS_FILES
> 
>    # Create the new patch
>    filterdiff \
>        -I $LIBXFS_FILES \
>        --strip=3 \
>        --addoldprefix=a/ \
>        --addnewprefix=b/ \
>        $PATCH > $NEWPATCH 
> else
>    echo "Sorry, I don't recognize repo $REPO"
>    fail
> fi
> 
> echo "Filtered patch for $REPO contains:"
> lsdiff $NEWPATCH
> 
> 
> # Ok, now apply with guilt or patch; either may fail and require a force
> # and/or a manual reject fixup
> if [ $GUILT -eq 1 ]; then
>    echo "$REPO looks like a guilt directory."
>    PATCHES=`guilt applied | wc -l`
>    if [ $PATCHES -gt 0 ]; then
>        echo -n "Top patch is: "
>        guilt top
>    fi
>    read -r -p "Create new Guilt patch? (Enter patch name or return to skip) " response
>    [ -z "$response" ] && guilt refresh; guilt import -P $response $NEWPATCH; guilt push
> else
>    echo "Applying with patch utility:"
>    patch -p1 < $NEWPATCH
> fi
> 
> echo "Patch was applied in $REPO; check for rejects, guilt push -f, etc"
> 
> cleanup
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
