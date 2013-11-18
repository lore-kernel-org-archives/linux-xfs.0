Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A952429E04
	for <xfs@oss.sgi.com>; Mon, 18 Nov 2013 09:41:12 -0600 (CST)
Message-ID: <528A3533.3080607@sgi.com>
Date: Mon, 18 Nov 2013 09:41:39 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 1/1] xfsprogs: update version for 3.2.0-alpha2
References: <20131118150313.940966335@sgi.com>
	<20131118150313.940966335@sgi.com>
	<20131118151117.GA4459@infradead.org>
In-Reply-To: <20131118151117.GA4459@infradead.org>
Content-Type: multipart/mixed; boundary="------------010101060708010503040404"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

--------------010101060708010503040404
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/2013 09:11 AM, Christoph Hellwig wrote:
> On Mon, Nov 18, 2013 at 09:03:13AM -0600, rjohnston@sgi.com wrote:
>> +xfsprogs-3.2.0-alpha2 (18 November 2013)
>> +	- Alpha release for the purpose of testing the CRC feature during the
>> +	  v3.12 kernel -rc series.
>
> Please list the actual changes here, and also update the list for
> -alpha1 which was missing all the usual information as well.
>
I will send a new V2 with the requested information after others have 
chimed in.

Attached are the commits so far:



--------------010101060708010503040404
Content-Type: text/plain; charset="UTF-8"; name="alpha2_commits.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="alpha2_commits.txt"

commit 64eb960fb0d95bab9aa0c28f8c809bcaaeac564f
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Nov 14 20:54:02 2013 +0000

    xfsprogs: Fix stray semicolon in libxfs/rdwr.c
--
commit 79e106f05f0fbffb89ab5401fb97af5391c6291f
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Nov 14 20:38:08 2013 +0000

    xfs_repair: correct docs for "-t" units
--
commit 1adfe5c6296d3ea6c182f31a6728fc94af9146f7
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Oct 18 22:30:18 2013 +0000

    xfs_fsr: fix SWAPEXT failures under selinux
--
commit 275077754611e5a15672624e674265b54f1cb7ed
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Oct 18 22:09:07 2013 +0000

    xfs_fsr: extra debugging info
--
commit 9b981421f503ba679097f8cd749af37cc42f5fd7
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:41:00 2013 +0000

    repair: fix leaf node directory data check
--
commit 0cce4aa198f0470817bedb3781ea5b6955e43076
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:59 2013 +0000

    repair: Increase default repair parallelism on large filesystems
--
commit 61510437c627b529feb95ebffddd73df5ed5b104
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:58 2013 +0000

    repair: prefetching is turned off unnecessarily
--
commit ba3615fc784f03d9cb25fb7cc9240ea56b4b7a4b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:57 2013 +0000

    xfsprogs: kill experimental warnings for v5 filesystems
--
commit 7b5f9801f4d569ab9fdbdd1e39aa59585d296872
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:56 2013 +0000

    xfs: support larger inode clusters on v5 filesystems
--
commit 8ab75c4d9176d8831fd137cf0e7916032d8216da
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:55 2013 +0000

    db: enable metadump on CRC filesystems
--
commit 839dac7f06d54600b3092a7ad9cb903315a27f97
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:54 2013 +0000

    libxfs: work around do_div() not handling 32 bit numerators
--
commit ba9ecd40b3792961f12102af55c759d0432a6486
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:53 2013 +0000

    xfs_db: avoid libxfs buffer lookup warnings
--
commit 06d80a7c09287581002c275fd21cfecdbdefcc15
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:52 2013 +0000

    xfs_db: use inode cluster buffers for inode IO
--
commit d14bf4dda7f5a59ba3fbaed38cd829db5f68a105
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:51 2013 +0000

    db: re-enable write support for v5 filesystems.
--
commit 2847273f74b3b14ba3cb9ab876b910da12ed2dbe
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:50 2013 +0000

    db: add a special attribute buffer verifier
--
commit fc068a1902148eaaad7a7e5e9972155dd68a647c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:49 2013 +0000

    db: add a special directory buffer verifier
--
commit 66a40d020d7abb6fe09693f4392b6af2b30aa3b3
Author: Dave Chinner <david@fromorbit.com>
Date:   Wed Nov 13 06:40:48 2013 +0000

    db: verify and calculate dquot CRCs
--
commit a73b88f29a82a21ef6f50298d2d14ae1d91b321d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:47 2013 +0000

    db: verify and calculate inode CRCs
--
commit 0522f1cc3ab1638e18a636b6a8cf6db8b1d277f6
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:46 2013 +0000

    db: indicate if the CRC on a buffer is correct or not
--
commit 6fea8f830a6cc04d5429de31f40d15b94d0fe8da
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:45 2013 +0000

    db: introduce verifier support into set_cur
--
commit 72298d16b17776f7a57a5244776591653387846b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:44 2013 +0000

    db: rewrite IO engine to use libxfs
--
commit 800db1c1581d68cc3e44980b0be9c5ff7b7fd6d9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:43 2013 +0000

    libxfs: refactor libxfs_buf_read_map for xfs_db
--
commit 48e32b40a611384836e593251cbe9d840db00ac9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:42 2013 +0000

    db: rewrite bbmap to use xfs_buf_map
--
commit 2a8b3fdf37d30bd4e0bec834168dd4fd9d8b4f58
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:41 2013 +0000

    db: separate out straight buffer IO from map based IO.
--
commit 3a19fb7dce9d570e78deaf5c26c0ab8a4a5bef67
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Nov 13 06:40:40 2013 +0000

    libxfs: stop caching inode structures
--
commit 9aa5711629b47642bb5b688a6a1410d223456fc8
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:39 2013 +0000

    libxfs: fix root inode handling inconsistencies
--
commit 6aa3d87bc45348dc0948ae0cea57bf3033d64694
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:38 2013 +0000

    xfs: don't emit corruption noise on fs probes
--
commit c9522f4d8790ecd61c4e74746b607787485f2027
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:37 2013 +0000

    xfs: fix node forward in xfs_node_toosmall
--
commit 3e23516ae60421652fd41354307a6a5181d401eb
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:36 2013 +0000

    xfs: fix the wrong new_size/rnew_size at xfs_iext_realloc_direct()
--
commit 12864fd992dd5d6bc3c089aeb6422c8d235a28f0
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:35 2013 +0000

    xfs: remove newlines from strings passed to __xfs_printk
--
commit e6d77a21f263ea403bef0940a524212e6fa03d04
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:34 2013 +0000

    libxfs: Minor cleanup and bug fix sync
--
commit f85fc6220f1c7fdb467a4d5b43e9bfbd2fb36c1d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:33 2013 +0000

    libxfs: bring across inode buffer readahead verifier changes
--
commit 2ceff9cee1f513ff633aa0d6997374da313c8c55
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:32 2013 +0000

    libxfs: xfs_rtalloc.c becomes xfs_rtbitmap.c
--
commit 9c6ebc42e2f1cf4b114c5cecbf373b8922959e69
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:31 2013 +0000

    libxfs: bmap btree owner swap support
--
commit 10851b189f50f357eab3ce787533e505babd00d2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:30 2013 +0000

    libxfs: unify xfs_btree.c with kernel code
--
commit 34b8c759723757e5b4a4c9da6c3a790eb405000f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:29 2013 +0000

    xfs: decouple inode and bmap btree header files
--
commit 32390f05a6a2c1a30b5f05141d705fb7c686079c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:28 2013 +0000

    xfs: split dquot buffer operations out
--
commit 4b1bcf9627153a77acbb2b0e6f0eb3d5b5102ceb
Author: Dave Chinner <david@fromorbit.com>
Date:   Wed Nov 13 06:40:27 2013 +0000

    xfs: create a shared header file for format-related information
--
commit 389b3b078ccc03da48d3cc0387fb5c5508e15d0f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:26 2013 +0000

    xfs: fix some minor sparse warnings
--
commit 270c31284f7d05557a31ef1304d582897bf4ffcc
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Nov 13 06:40:25 2013 +0000

    xfsprogs: fix automatic dependency generation
--
commit 12a48f5d8a06a8ca21b6221e94318e4922f0316c
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue Nov 12 16:31:12 2013 +0000

    xfsprogs: remove xfs_check references from fsck.xfs script & manpage
--
commit 659fb8470be7e21f8f24a0a2cf69216542ad39c8
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Nov 6 10:25:39 2013 +0000

    xfsprogs: add generated crc files to .gitignore
--
commit 4eb02d95b7e081b510a7015609f01385aab229a9
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Thu Oct 17 15:28:08 2013 +0000

    xfsprog: add mkfs.xfs sb v4 support for dirent filetype field
--
commit 42737f1ad16213a3dab1756c9fffb494db8ef27e
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Thu Oct 17 15:28:07 2013 +0000

    xfs_progs: add dirent filetype to xfs_db version
--
commit 6f700630b06a2ce15aebe8608b2c5877002299d6
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Thu Oct 17 15:28:06 2013 +0000

    xfsprog: add dirent filetype information for xfs_info
--
commit 87e343bd0937e5bb75dd8bc46ba388b6f8c6552b
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Thu Oct 17 15:28:05 2013 +0000

    xfsprog: add xfs sb v4 support for dirent filetype field
--
commit 77d8143bd059f6da43b46cadaa6a96c3d4573d9c
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Tue Oct 22 13:04:53 2013 -0500

    Revert "xfs: create a shared header file for format-related information"
--
commit 19e73c9d220728617816c47a1671cc931c40e45b
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Tue Oct 22 10:15:20 2013 -0500

    Revert "[RESEND, 4/7] xfsprogs: xfsio: add support FALLOC_FL_COLLAPSE_RANGE for fallocate"
--
commit ddd5a16201db90a255952f61c34aeaab67d0a845
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 30 03:15:21 2013 +0000

    xfs: unify directory/attribute format definitions
--
commit 14e36e34ed975b1ffbbcbc18a7743a3a4859be3d
Author: Li Zhong <zhong@linux.vnet.ibm.com>
Date:   Tue Oct 15 02:55:31 2013 +0000

    xfsprogs: fix resource leak in longform_dir2_rebuild()
--
commit 2cca1dbd1c3e12d270a9baa5f85e548e8a5a2125
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Oct 18 17:59:36 2013 +0000

    xfs_repair: add d_type when moving files to lost+found
--
commit dd536e1212d9008a182627b6333d69b2f8c1c393
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Oct 18 17:57:37 2013 +0000

    xfsprogs: Note projid32bit default change in mkfs.xfs manpage
--
commit 44dae5e6804408b4123a916a2738b73e21d8c61e
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Sep 12 20:56:36 2013 +0000

    xfs_repair: test for bad level in dir2 node
--
commit 68774b900e0c8368342cb12f649572a86ef2f6e4
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Sep 17 17:07:45 2013 +0000

    xfsprogs: initialize filetype for lost+found creation
--
commit 7f2d6b811755b6b91f18aa5bd9d5980848a81267
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Oct 17 17:50:16 2013 +0000

    xfs_repair: avoid segfault if reporting progress early in repair
--
commit 5b962abcbb952e5409e2b2a1ecbc71b5d370cdea
Author: Nathan Scott <nathans@debian.org>
Date:   Thu Oct 10 23:56:19 2013 +0000

    xfsprogs: fix a warning in the deb build
--
commit 773d6f6e3800dce5d27af687ebd3ff323dcdfd72
Author: Colin Watson <cjwatson@ubuntu.com>
Date:   Thu Oct 17 15:27:02 2013 -0500

    Sent: Friday, October 11, 2013 12:38:11 AM
--
commit fcd6fa7f6a29188a756ff8b071a152bc9d62baf4
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue Oct 8 15:17:50 2013 +0000

    xfsprogs: restrict platform_test_xfs_fd to regular files
--
commit 5425725c56bccb9a91847cb74cfdadc8b44fecf7
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Oct 7 17:35:16 2013 +0000

    xfsprogs: remove incorrect l_sectBBsize assignment in xfs_repair
--
commit e64190f8440286a815060524777b435e06a7b364
Author: Namjae Jeon <namjae.jeon@samsung.com>
Date:   Sun Oct 6 20:13:38 2013 +0000

    [RESEND, 4/7] xfsprogs: xfsio: add support FALLOC_FL_COLLAPSE_RANGE for fallocate
--
commit b2dbd6a9a2df5099882bdfc068caa76cf334c99a
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sat Oct 5 02:20:03 2013 +0000

    xfsprogs: fix crc32 build on big endian
--
commit 050a7f1f79314470c18e9d11c28daf75dd959830
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Sep 30 17:01:19 2013 +0000

    xfsprogs: handle symlinks etc in fs_table_initialise_mounts()
--
commit dd297fd6d366f62ca2f579e510e6287699d0bd5d
Author: Dave Chinner <david@fromorbit.com>
Date:   Mon Sep 30 03:15:20 2013 +0000

    xfs: create a shared header file for format-related information
--
commit 41315687d9db9b50876401e7b0ee20dd77cfc712
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 30 03:15:19 2013 +0000

    xfs: dirent dtype presence is dependent on directory magic numbers
--
commit ea6a00d47a01bc1df218742784712a12929ab77e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 30 03:15:18 2013 +0000

    xfs: don't assert fail on bad inode numbers
--
commit e26915ee1e90908a686dd8aa5f7b88de903e9da2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 30 03:15:17 2013 +0000

    xfs: ensure we copy buffer type in da btree root splits
--
commit 36bca8993f52be84f31c476449ca1527d62e16e1
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 30 03:15:16 2013 +0000

    xfs: check magic numbers in dir3 leaf verifier first
--
commit f7e01baf653a566c1772929629791fc65ef4b120
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 30 03:15:14 2013 +0000

    libxfs: fix missing filetype updates to xfs_dir2.c
--
commit ae181820d03e19f145dbd058c0f8fa59fa18468c
Author: Li Zhong <zhong@linux.vnet.ibm.com>
Date:   Thu Sep 26 06:48:12 2013 +0000

    xfsprogs: fix return value of verify_set_primary_sb()
--
commit 548c2e3e5b123266b4b89cc81bedd113442570b8
Author: Li Zhong <zhong@linux.vnet.ibm.com>
Date:   Thu Sep 26 06:45:32 2013 +0000

    [v3, 1/2] xfsprogs: fix potential memory leak in verify_set_primary_sb()
--
commit 70ee4153f4c998774adcee1e576d3c1f305b92d0
Author: Li Zhong <zhong@linux.vnet.ibm.com>
Date:   Wed Sep 18 09:40:42 2013 +0000

    xfsprogs: fix potential memory leak in repare/sb.c
--
commit 1acc538540ce22e16bb55ca573691070a8d375db
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue Sep 17 16:56:59 2013 +0000

    xfsprogs: initialize filetype for xfs_name_dot
--
commit 91e684d140c000c074b9ca13821b6ec00146da36
Author: Carlos Maiolino <cmaiolino@redhat.com>
Date:   Fri Aug 30 17:09:50 2013 +0000

    mkfs: add noalign option to usage()
--
commit e49f30a76f5e910092bd285ebef3f7641a09ec2e
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Aug 30 03:55:16 2013 +0000

    xfsprogs: avoid array overflow in pf_batch_read()
--
commit e6efb967e61a366dbe877f34e220e32866e7db42
Author: Li Zhong <zhong@linux.vnet.ibm.com>
Date:   Tue Aug 27 01:58:34 2013 +0000

    xfsprogs: fix Out-of-bounds access in repair/dinode.c
--
commit 1d3b7dfd3a877a9d370ed355cd4968307f3d1e06
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Thu Sep 26 12:42:53 2013 -0500


--------------010101060708010503040404
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------010101060708010503040404--
