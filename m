Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 32C3D7F51
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 01:29:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 21EAB8F804C
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 23:29:23 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id oCACGo0p1PPcuF7L for
	<xfs@oss.sgi.com>; Tue, 30 Jul 2013 23:29:21 -0700 (PDT)
Message-ID: <51F8AF0E.3020409@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 14:30:38 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7 0/7] userns: Convert xfs to use kuid_t/kgid_t where
	appropriate
References: <20130729230633.725a282e@oracle.com>
In-Reply-To: <20130729230633.725a282e@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@gmail.com>, Brian Foster <bfoster@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, xfs@oss.sgi.com

Hi Dwight,

On 07/30/2013 11:06 AM, Dwight Engen wrote:
> Hi All,
> 
> This updated patchset is on top of ad81f054 of xfs git (3.11-rc1). The
> patches do not convert the id's returned from bulkstat, since bulkstat
> cannot be called from inside a userns right now anyway since the caller
> must be CAP_SYS_ADMIN in init_user_ns.


As I method in another mail thread, I found the changing projid of file in container
hasn't been disallowed. it means the user in container can change file's projid.
so the project quota won't take effect.

the project quota info before I change file's projid in container:

Project quota on /media/lw (/dev/sdc1)
                        Blocks
Project ID   Used   Soft   Hard Warn/Grace
---------- ---------------------------------
testproj      64K   100M   110M  00 [------]


and after I use a simple program which execs the below code.

fa.fsx_projid = 21; // different projid from testproj
fa.fsx_xflags &= ~XFS_XFLAG_IMMUTABLE;
ret = xfsctl("/mount_point_of_xfs", fd, XFS_IOC_FSSETXATTR, &fa);

the project quota becomes to:

Project quota on /media/lw (/dev/sdc1)
                        Blocks
Project ID   Used   Soft   Hard Warn/Grace
---------- ---------------------------------
testproj      60K   100M   110M  00 [------]


So I think we still need a patch to reduce the changing-project-id
rights of un-init user namespace.

Thanks


> 
> Changes since v6 patchset (addressing Dave's comments)
> - 0006 just do a capable(CAP_SYS_ADMIN) check for XFS_IOC_FREE_EOFBLOCKS
> 
> Changes since v5 patchset (addressing Brian's comments,
> only 0005 and 0006 are changed):
>  - 0005 put all eofblocks validation in xfs_fs_eofblocks_from_user()
>  - 0006 don't export internal flag, add K to internal flag name,
>    start internal flags bits at msb (with the intention that other internal
>    flags would be in descending order) and ensure that it doesn't accidentally
>    collide with external flags
> 
> Changes since v4 patchset (addressing Dave's comments):
>  - add parenthesis in if with binary and logical and (EOFBLOCKS flags)
>  - rename xfs_fs_eofblocks_to_internal -> xfs_fs_eofblocks_from_user and
>    move conversion validation into it
>  - fix negative error returns from XFS_IOC_FREE_EOFBLOCKS
>  - add check for read-only filesystem to XFS_IOC_FREE_EOFBLOCKS
> 
> Changes since v3 patchset:
>  - export inode_capable() for building xfs as a module
>  - implement Brian's proposal for an internal flag to indicate to
>    xfs_inode_free_eofblocks() that it should do a permission check.
>    ioctl callers will always set this flag, which is simpler than
>    making them specify XFS_EOF_FLAGS_UID or XFS_EOF_FLAGS_GID,
>    internal callers can leave it unset so no permission checking is
>    done
>  - take Brian's suggestion on moving the policy from the conversion
>    function into the ioctl code, and moving stuff to xfs_icache.h
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
