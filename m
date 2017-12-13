Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35489 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdLMGIu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 01:08:50 -0500
Date: Tue, 12 Dec 2017 22:05:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs/*/Kconfig: drop links to 404-compliant
 http://acl.bestbits.at
Message-ID: <20171213060546.GN19219@magnolia>
References: <20171213053825.10903-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213053825.10903-1-kilobyte@angband.pl>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Adam Borowski <kilobyte@angband.pl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>, Jonathan Corbet <corbet@lwn.net>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>, v9fs-developer@lists.sourceforge.net, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, linux-f2fs-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Dec 13, 2017 at 06:38:25AM +0100, Adam Borowski wrote:
> This link is replicated in most filesystems' config stanzas.  Referring
> to an archived version of that site is pointless as it mostly deals with
> patches; user documentation is available elsewhere.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
> Sending this as one piece; if you guys would instead prefer this chopped
> into tiny per-filesystem bits, please say so.
> 
> 
>  Documentation/filesystems/ext2.txt |  2 --
>  Documentation/filesystems/ext4.txt |  7 +++----
>  fs/9p/Kconfig                      |  3 ---
>  fs/Kconfig                         |  6 +-----
>  fs/btrfs/Kconfig                   |  3 ---
>  fs/ceph/Kconfig                    |  3 ---
>  fs/cifs/Kconfig                    | 15 +++++++--------
>  fs/ext2/Kconfig                    |  6 +-----
>  fs/ext4/Kconfig                    |  3 ---
>  fs/f2fs/Kconfig                    |  6 +-----
>  fs/hfsplus/Kconfig                 |  3 ---
>  fs/jffs2/Kconfig                   |  6 +-----
>  fs/jfs/Kconfig                     |  3 ---
>  fs/reiserfs/Kconfig                |  6 +-----
>  fs/xfs/Kconfig                     |  3 ---
>  15 files changed, 15 insertions(+), 60 deletions(-)
> 
> diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
> index 55755395d3dc..81c0becab225 100644
> --- a/Documentation/filesystems/ext2.txt
> +++ b/Documentation/filesystems/ext2.txt
> @@ -49,12 +49,10 @@ sb=n				Use alternate superblock at this location.
>  
>  user_xattr			Enable "user." POSIX Extended Attributes
>  				(requires CONFIG_EXT2_FS_XATTR).
> -				See also http://acl.bestbits.at
>  nouser_xattr			Don't support "user." extended attributes.
>  
>  acl				Enable POSIX Access Control Lists support
>  				(requires CONFIG_EXT2_FS_POSIX_ACL).
> -				See also http://acl.bestbits.at
>  noacl				Don't support POSIX ACLs.
>  
>  nobh				Do not attach buffer_heads to file pagecache.
> diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
> index 75236c0c2ac2..8cd63e16f171 100644
> --- a/Documentation/filesystems/ext4.txt
> +++ b/Documentation/filesystems/ext4.txt
> @@ -202,15 +202,14 @@ inode_readahead_blks=n	This tuning parameter controls the maximum
>  			the buffer cache.  The default value is 32 blocks.
>  
>  nouser_xattr		Disables Extended User Attributes.  See the
> -			attr(5) manual page and http://acl.bestbits.at/
> -			for more information about extended attributes.
> +			attr(5) manual page for more information about
> +			extended attributes.
>  
>  noacl			This option disables POSIX Access Control List
>  			support. If ACL support is enabled in the kernel
>  			configuration (CONFIG_EXT4_FS_POSIX_ACL), ACL is
>  			enabled by default on mount. See the acl(5) manual
> -			page and http://acl.bestbits.at/ for more information
> -			about acl.
> +			page for more information about acl.
>  
>  bsddf		(*)	Make 'df' act like BSD.
>  minixdf			Make 'df' act like Minix.
> diff --git a/fs/9p/Kconfig b/fs/9p/Kconfig
> index 6489e1fc1afd..11045d8e356a 100644
> --- a/fs/9p/Kconfig
> +++ b/fs/9p/Kconfig
> @@ -25,9 +25,6 @@ config 9P_FS_POSIX_ACL
>  	  POSIX Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
>  
> -	  To learn more about Access Control Lists, visit the POSIX ACLs for
> -	  Linux website <http://acl.bestbits.at/>.
> -
>  	  If you don't know what Access Control Lists are, say N
>  
>  endif
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 7aee6d699fd6..0ed56752f208 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -167,17 +167,13 @@ config TMPFS_POSIX_ACL
>  	  files for sound to work properly.  In short, if you're not sure,
>  	  say Y.
>  
> -	  To learn more about Access Control Lists, visit the POSIX ACLs for
> -	  Linux website <http://acl.bestbits.at/>.
> -
>  config TMPFS_XATTR
>  	bool "Tmpfs extended attributes"
>  	depends on TMPFS
>  	default n
>  	help
>  	  Extended attributes are name:value pairs associated with inodes by
> -	  the kernel or by users (see the attr(5) manual page, or visit
> -	  <http://acl.bestbits.at/> for details).
> +	  the kernel or by users (see the attr(5) manual page for details).
>  
>  	  Currently this enables support for the trusted.* and
>  	  security.* namespaces.
> diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
> index 2e558227931a..273351ee4c46 100644
> --- a/fs/btrfs/Kconfig
> +++ b/fs/btrfs/Kconfig
> @@ -38,9 +38,6 @@ config BTRFS_FS_POSIX_ACL
>  	  POSIX Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
>  
> -	  To learn more about Access Control Lists, visit the POSIX ACLs for
> -	  Linux website <http://acl.bestbits.at/>.
> -
>  	  If you don't know what Access Control Lists are, say N
>  
>  config BTRFS_FS_CHECK_INTEGRITY
> diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
> index 264e9bf83ff3..52095f473464 100644
> --- a/fs/ceph/Kconfig
> +++ b/fs/ceph/Kconfig
> @@ -34,7 +34,4 @@ config CEPH_FS_POSIX_ACL
>  	  POSIX Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
>  
> -	  To learn more about Access Control Lists, visit the POSIX ACLs for
> -	  Linux website <http://acl.bestbits.at/>.
> -
>  	  If you don't know what Access Control Lists are, say N
> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
> index d5b2e12b5d02..e73d25f4b97a 100644
> --- a/fs/cifs/Kconfig
> +++ b/fs/cifs/Kconfig
> @@ -108,14 +108,13 @@ config CIFS_XATTR
>          depends on CIFS
>          help
>            Extended attributes are name:value pairs associated with inodes by
> -          the kernel or by users (see the attr(5) manual page, or visit
> -          <http://acl.bestbits.at/> for details).  CIFS maps the name of
> -          extended attributes beginning with the user namespace prefix
> -          to SMB/CIFS EAs. EAs are stored on Windows servers without the
> -          user namespace prefix, but their names are seen by Linux cifs clients
> -          prefaced by the user namespace prefix. The system namespace
> -          (used by some filesystems to store ACLs) is not supported at
> -          this time.
> +          the kernel or by users (see the attr(5) manual page for details).
> +          CIFS maps the name of extended attributes beginning with the user
> +          namespace prefix to SMB/CIFS EAs.  EAs are stored on Windows
> +          servers without the user namespace prefix, but their names are
> +          seen by Linux cifs clients prefaced by the user namespace prefix.
> +          The system namespace (used by some filesystems to store ACLs) is
> +          not supported at this time.
>  
>            If unsure, say Y.
>  
> diff --git a/fs/ext2/Kconfig b/fs/ext2/Kconfig
> index c634874e12d9..894e4c53d1d2 100644
> --- a/fs/ext2/Kconfig
> +++ b/fs/ext2/Kconfig
> @@ -13,8 +13,7 @@ config EXT2_FS_XATTR
>  	depends on EXT2_FS
>  	help
>  	  Extended attributes are name:value pairs associated with inodes by
> -	  the kernel or by users (see the attr(5) manual page, or visit
> -	  <http://acl.bestbits.at/> for details).
> +	  the kernel or by users (see the attr(5) manual page for details).
>  
>  	  If unsure, say N.
>  
> @@ -26,9 +25,6 @@ config EXT2_FS_POSIX_ACL
>  	  Posix Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
>  
> -	  To learn more about Access Control Lists, visit the Posix ACLs for
> -	  Linux website <http://acl.bestbits.at/>.
> -
>  	  If you don't know what Access Control Lists are, say N
>  
>  config EXT2_FS_SECURITY
> diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
> index 73b850f5659c..a453cc87082b 100644
> --- a/fs/ext4/Kconfig
> +++ b/fs/ext4/Kconfig
> @@ -82,9 +82,6 @@ config EXT4_FS_POSIX_ACL
>  	  POSIX Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
>  
> -	  To learn more about Access Control Lists, visit the POSIX ACLs for
> -	  Linux website <http://acl.bestbits.at/>.
> -
>  	  If you don't know what Access Control Lists are, say N
>  
>  config EXT4_FS_SECURITY
> diff --git a/fs/f2fs/Kconfig b/fs/f2fs/Kconfig
> index 378c221d68a9..9a20ef42fadd 100644
> --- a/fs/f2fs/Kconfig
> +++ b/fs/f2fs/Kconfig
> @@ -35,8 +35,7 @@ config F2FS_FS_XATTR
>  	default y
>  	help
>  	  Extended attributes are name:value pairs associated with inodes by
> -	  the kernel or by users (see the attr(5) manual page, or visit
> -	  <http://acl.bestbits.at/> for details).
> +	  the kernel or by users (see the attr(5) manual page for details).
>  
>  	  If unsure, say N.
>  
> @@ -49,9 +48,6 @@ config F2FS_FS_POSIX_ACL
>  	  Posix Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
>  
> -	  To learn more about Access Control Lists, visit the POSIX ACLs for
> -	  Linux website <http://acl.bestbits.at/>.
> -
>  	  If you don't know what Access Control Lists are, say N
>  
>  config F2FS_FS_SECURITY
> diff --git a/fs/hfsplus/Kconfig b/fs/hfsplus/Kconfig
> index 24bc20fd42f7..7cc8b4acf66a 100644
> --- a/fs/hfsplus/Kconfig
> +++ b/fs/hfsplus/Kconfig
> @@ -20,9 +20,6 @@ config HFSPLUS_FS_POSIX_ACL
>  	  POSIX Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
>  
> -	  To learn more about Access Control Lists, visit the POSIX ACLs for
> -	  Linux website <http://acl.bestbits.at/>.
> -
>  	  It needs to understand that POSIX ACLs are treated only under
>  	  Linux. POSIX ACLs doesn't mean something under Mac OS X.
>  	  Mac OS X beginning with version 10.4 ("Tiger") support NFSv4 ACLs,
> diff --git a/fs/jffs2/Kconfig b/fs/jffs2/Kconfig
> index d8bb6c411e96..ad850c5bf2ca 100644
> --- a/fs/jffs2/Kconfig
> +++ b/fs/jffs2/Kconfig
> @@ -68,8 +68,7 @@ config JFFS2_FS_XATTR
>  	default n
>  	help
>  	  Extended attributes are name:value pairs associated with inodes by
> -	  the kernel or by users (see the attr(5) manual page, or visit
> -	  <http://acl.bestbits.at/> for details).
> +	  the kernel or by users (see the attr(5) manual page for details).
>  
>  	  If unsure, say N.
>  
> @@ -82,9 +81,6 @@ config JFFS2_FS_POSIX_ACL
>  	  Posix Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
>  
> -	  To learn more about Access Control Lists, visit the Posix ACLs for
> -	  Linux website <http://acl.bestbits.at/>.
> -
>  	  If you don't know what Access Control Lists are, say N
>  
>  config JFFS2_FS_SECURITY
> diff --git a/fs/jfs/Kconfig b/fs/jfs/Kconfig
> index 57cef19951db..851de78fdabb 100644
> --- a/fs/jfs/Kconfig
> +++ b/fs/jfs/Kconfig
> @@ -16,9 +16,6 @@ config JFS_POSIX_ACL
>  	  Posix Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
>  
> -	  To learn more about Access Control Lists, visit the Posix ACLs for
> -	  Linux website <http://acl.bestbits.at/>.
> -
>  	  If you don't know what Access Control Lists are, say N
>  
>  config JFS_SECURITY
> diff --git a/fs/reiserfs/Kconfig b/fs/reiserfs/Kconfig
> index 7cd46666ba2c..86e71c0caf48 100644
> --- a/fs/reiserfs/Kconfig
> +++ b/fs/reiserfs/Kconfig
> @@ -57,8 +57,7 @@ config REISERFS_FS_XATTR
>  	depends on REISERFS_FS
>  	help
>  	  Extended attributes are name:value pairs associated with inodes by
> -	  the kernel or by users (see the attr(5) manual page, or visit
> -	  <http://acl.bestbits.at/> for details).
> +	  the kernel or by users (see the attr(5) manual page for details).
>  
>  	  If unsure, say N.
>  
> @@ -70,9 +69,6 @@ config REISERFS_FS_POSIX_ACL
>  	  Posix Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
>  
> -	  To learn more about Access Control Lists, visit the Posix ACLs for
> -	  Linux website <http://acl.bestbits.at/>.
> -
>  	  If you don't know what Access Control Lists are, say N
>  
>  config REISERFS_FS_SECURITY
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index f42fcf1b5465..46bcf0e649f5 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -48,9 +48,6 @@ config XFS_POSIX_ACL
>  	  POSIX Access Control Lists (ACLs) support permissions for users and
>  	  groups beyond the owner/group/world scheme.
>  
> -	  To learn more about Access Control Lists, visit the POSIX ACLs for
> -	  Linux website <http://acl.bestbits.at/>.
> -

The XFS bits look ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	  If you don't know what Access Control Lists are, say N.
>  
>  config XFS_RT
> -- 
> 2.15.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
