Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B35297F3F
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 13:01:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A2A238F809C
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 11:01:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RORTqv9DAU84RN50 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 May 2015 11:01:09 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id C922EBDD79
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 18:01:08 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t4FI17SU026113
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 15 May 2015 14:01:08 -0400
Message-ID: <55563463.1030107@redhat.com>
Date: Fri, 15 May 2015 13:01:07 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Script to cross-apply libxfs changes
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
To: xfs-oss <xfs@oss.sgi.com>

I'm terrible at bash, so don't laugh.  But this more or less works for me ...

This script takes either a patch name or a commit ID in the current
tree, and massages that change into a libxfs patch for the other tree;
i.e. it applies a kernel libxfs patch to xfsprogs, or vice versa.
It'll create a guilt patch if it looks like a guilt dir, or just smack
it in with "patch" if not.

It can surely be improved, but it's a start.

Example below, and script at the end.  Requires filterdiff.

[root@bp-05 xfsprogs]# git log
commit 9681b791929795cd7dc6c7a79c3a69354f34e0b0
...
[root@bp-05 xfsprogs]# libxfs-apply /mnt/test2/git/linux-xfs/ 9681b791929795cd7dc6c7a79c3a69354f34e0b0
Filtered patch for /mnt/test2/git/linux-xfs/ contains:
a/fs/xfs/libxfs/xfs_alloc.c
a/fs/xfs/libxfs/xfs_alloc_btree.c
a/fs/xfs/libxfs/xfs_attr_leaf.c
a/fs/xfs/libxfs/xfs_attr_remote.c
a/fs/xfs/libxfs/xfs_bmap_btree.c
a/fs/xfs/libxfs/xfs_btree.c
a/fs/xfs/libxfs/xfs_da_btree.c
a/fs/xfs/libxfs/xfs_dir2_block.c
a/fs/xfs/libxfs/xfs_dir2_data.c
a/fs/xfs/libxfs/xfs_dir2_leaf.c
a/fs/xfs/libxfs/xfs_dir2_node.c
a/fs/xfs/libxfs/xfs_dquot_buf.c
a/fs/xfs/libxfs/xfs_format.h
a/fs/xfs/libxfs/xfs_ialloc.c
a/fs/xfs/libxfs/xfs_ialloc_btree.c
a/fs/xfs/libxfs/xfs_inode_buf.c
a/fs/xfs/libxfs/xfs_sb.c
a/fs/xfs/libxfs/xfs_symlink_remote.c
/mnt/test2/git/linux-xfs/ looks like a guilt directory.
Top patch is: percpu-2
Create new Guilt patch? (Enter patch name or return to skip) new-uuid
Applying patch..new-uuid
Patch applied.
Patch was applied in /mnt/test2/git/linux-xfs/; check for rejects, guilt push -f, etc
[root@bp-05 xfsprogs]#

==========

#!/bin/bash

# 2 args:
#	libxfs-apply <repo> <commit ID or patchfile>

usage()
{
	echo "libxfs-apply repodir [patchfile|commitid]"
	exit
}

cleanup()
{
	rm -f $PATCH $LIBXFS_FILES $NEWPATCH
}

fail()
{
	cleanup
	cd $ORIG_DIR
	exit
}

if [ "$#" -eq 2 -a -d "$1" -a -f "$2" ]; then
	REPO=$1
	PATCH=$2
elif [ "$#" -eq 2 -a -d "$1" ]; then
	REPO=$1
	PATCH=`mktemp`
	git show $2 > $PATCH || usage
else
	usage
fi


ORIG_DIR=`pwd`
LIBXFS_FILES=`mktemp`
NEWPATCH=`mktemp`

cd $REPO

# Are we using guilt? This works even if no patch is applied.
guilt top &> /dev/null
if [ $? -eq 0 ]; then
	GUILT=1
else
	GUILT=0
fi

# Filter the patch into the right format & files for the other tree

if   [ -d "fs/xfs/libxfs" ]; then	# We are applying a progs patch to the kernel tree
	lsdiff $PATCH | grep -q "a/libxfs/"
	if [ $? -ne 0 ]; then
		echo "Doesn't look like an xfsprogs patch with libxfs changes"
		fail
	fi

	# The files we will try to apply to
	ls -1 fs/xfs/libxfs/*.[ch] | sed -e "s%.*/\(.*\)%*\1%" > $LIBXFS_FILES

	# Create the new patch
	filterdiff \
		-I $LIBXFS_FILES \
		--strip=1 \
		--addoldprefix=a/fs/xfs/ \
		--addnewprefix=b/fs/xfs/ \
		$PATCH > $NEWPATCH 

elif [ -d "libxfs" -a -d "libxlog" ]; then	# We are applying a kernel patch to the xfsprogs tree
	lsdiff $PATCH | grep -q "a/fs/xfs/libxfs/"
	if [ $? -ne 0 ]; then
		echo "Doesn't look like a kernel patch with libxfs changes"
		fail
	fi

	# The files we will try to apply to
	ls -1 libxfs/*.[ch] | sed -e "s%.*/\(.*\)%*\1%" > $LIBXFS_FILES

	# Create the new patch
	filterdiff \
		-I $LIBXFS_FILES \
		--strip=3 \
		--addoldprefix=a/ \
		--addnewprefix=b/ \
		$PATCH > $NEWPATCH 
else
	echo "Sorry, I don't recognize repo $REPO"
	fail
fi

echo "Filtered patch for $REPO contains:"
lsdiff $NEWPATCH


# Ok, now apply with guilt or patch; either may fail and require a force
# and/or a manual reject fixup
if [ $GUILT -eq 1 ]; then
	echo "$REPO looks like a guilt directory."
	PATCHES=`guilt applied | wc -l`
	if [ $PATCHES -gt 0 ]; then
		echo -n "Top patch is: "
		guilt top
	fi
	read -r -p "Create new Guilt patch? (Enter patch name or return to skip) " response
	[ -z "$response" ] && guilt refresh; guilt import -P $response $NEWPATCH; guilt push
else
	echo "Applying with patch utility:"
	patch -p1 < $NEWPATCH
fi

echo "Patch was applied in $REPO; check for rejects, guilt push -f, etc"

cleanup

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
