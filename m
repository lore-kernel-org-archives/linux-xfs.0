Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 575817F63
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 11:21:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24B9E304067
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 09:21:11 -0800 (PST)
Date: Tue, 19 Nov 2013 09:21:09 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfsprogs: update version for 3.2.0-alpha2
Message-ID: <20131119172109.GA27984@infradead.org>
References: <20131118150313.940966335@sgi.com>
	<20131119170148.675504461@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131119170148.675504461@sgi.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

> +	- xfsprogs: Fix stray semicolon in libxfs/rdwr.c

not interestiung for users

> +	- xfs_repair: correct docs for "-t" units

should mention this is the manpage?

> +	- xfs_fsr: extra debugging info

not useful

> +	- repair: fix leaf node directory data check

not useful.

> +	- libxfs: work around do_div() not handling 32 bit numerators
> +	- xfs_db: avoid libxfs buffer lookup warnings
> +	- xfs_db: use inode cluster buffers for inode IO

all not useful for the user.

> +	- db: add a special attribute buffer verifier
> +	- db: add a special directory buffer verifier
> +	- db: verify and calculate dquot CRCs
> +	- db: verify and calculate inode CRCs
> +	- db: indicate if the CRC on a buffer is correct or not
> +	- db: introduce verifier support into set_cur
> +	- db: rewrite IO engine to use libxfs
> +	- libxfs: refactor libxfs_buf_read_map for xfs_db
> +	- db: rewrite bbmap to use xfs_buf_map
> +	- db: separate out straight buffer IO from map based IO.
> +	- libxfs: stop caching inode structures
> +	- libxfs: fix root inode handling inconsistencies
> +	- xfs: don't emit corruption noise on fs probes
> +	- xfs: fix node forward in xfs_node_toosmall
> +	- xfs: fix the wrong new_size/rnew_size at xfs_iext_realloc_direct()
> +	- xfs: remove newlines from strings passed to __xfs_printk
> +	- libxfs: Minor cleanup and bug fix sync
> +	- libxfs: bring across inode buffer readahead verifier changes
> +	- libxfs: xfs_rtalloc.c becomes xfs_rtbitmap.c
> +	- libxfs: bmap btree owner swap support
> +	- libxfs: unify xfs_btree.c with kernel code
> +	- xfs: decouple inode and bmap btree header files
> +	- xfs: split dquot buffer operations out
> +	- xfs: create a shared header file for format-related information
> +	- xfs: fix some minor sparse warnings

All internal implementation details.

> +	- xfsprogs: add generated crc files to .gitignore

not useful to the user.

> +	- xfsprog: add mkfs.xfs sb v4 support for dirent filetype field
> +	- xfs_progs: add dirent filetype to xfs_db version
> +	- xfsprog: add dirent filetype information for xfs_info
> +	- xfsprog: add xfs sb v4 support for dirent filetype field

Should be single entry:

	- support the filetype feature flag for v4 filesystems.

> +	- Revert "xfs: create a shared header file for format-related
> +	  information"
> +	- Revert "[RESEND, 4/7] xfsprogs: xfsio: add support
> +	  FALLOC_FL_COLLAPSE_RANGE for fallocate"
> +	- xfs: unify directory/attribute format definitions

not useful.

> +	- xfsprogs: fix resource leak in longform_dir2_rebuild()

probably not that useful, too.

And a lot more.  Probably easier to rewrite it than point every item
out.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
