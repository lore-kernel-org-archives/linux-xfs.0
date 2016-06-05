Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF8DD7CA4
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 16:23:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C138B8F8037
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:23:03 -0700 (PDT)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id XGSmY7XcGD8bP8Sd for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 14:23:02 -0700 (PDT)
Date: Mon, 6 Jun 2016 05:22:09 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 01/45] block/fs/drivers: remove rw argument from submit_bio
Message-ID: <201606060538.MXS5FrrY%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1465155145-10812-2-git-send-email-mchristi@redhat.com>
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
To: mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, osd-dev@open-osd.org, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

Hi,

[auto build test WARNING on v4.7-rc1]
[cannot apply to dm/for-next md/for-next next-20160603]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/mchristi-redhat-com/v8-separate-operations-from-flags-in-the-bio-request-structs/20160606-040240
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:232:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> fs/ext4/crypto.c:442:38: sparse: too many arguments for function submit_bio_wait
   In file included from include/linux/fs.h:31:0,
                    from include/linux/seq_file.h:10,
                    from include/linux/pinctrl/consumer.h:17,
                    from include/linux/pinctrl/devinfo.h:21,
                    from include/linux/device.h:24,
                    from include/linux/genhd.h:64,
                    from include/linux/blkdev.h:9,
                    from fs/ext4/ext4.h:20,
                    from fs/ext4/ext4_extents.h:22,
                    from fs/ext4/crypto.c:37:
   fs/ext4/crypto.c: In function 'ext4_encrypted_zeroout':
   include/linux/blk_types.h:194:20: warning: passing argument 1 of 'submit_bio_wait' makes pointer from integer without a cast [-Wint-conversion]
    #define REQ_WRITE  (1ULL << __REQ_WRITE)
                       ^
   include/linux/fs.h:196:19: note: in expansion of macro 'REQ_WRITE'
    #define RW_MASK   REQ_WRITE
                      ^~~~~~~~~
   include/linux/fs.h:200:17: note: in expansion of macro 'RW_MASK'
    #define WRITE   RW_MASK
                    ^~~~~~~
   fs/ext4/crypto.c:442:25: note: in expansion of macro 'WRITE'
      err = submit_bio_wait(WRITE, bio);
                            ^~~~~
   In file included from include/linux/blkdev.h:19:0,
                    from fs/ext4/ext4.h:20,
                    from fs/ext4/ext4_extents.h:22,
                    from fs/ext4/crypto.c:37:
   include/linux/bio.h:476:12: note: expected 'struct bio *' but argument is of type 'long long unsigned int'
    extern int submit_bio_wait(struct bio *bio);
               ^~~~~~~~~~~~~~~
   fs/ext4/crypto.c:442:9: error: too many arguments to function 'submit_bio_wait'
      err = submit_bio_wait(WRITE, bio);
            ^~~~~~~~~~~~~~~
   In file included from include/linux/blkdev.h:19:0,
                    from fs/ext4/ext4.h:20,
                    from fs/ext4/ext4_extents.h:22,
                    from fs/ext4/crypto.c:37:
   include/linux/bio.h:476:12: note: declared here
    extern int submit_bio_wait(struct bio *bio);
               ^~~~~~~~~~~~~~~

vim +442 fs/ext4/crypto.c

b30ab0e0 Michael Halcrow 2015-04-12  426  			goto errout;
b30ab0e0 Michael Halcrow 2015-04-12  427  		}
b30ab0e0 Michael Halcrow 2015-04-12  428  		bio->bi_bdev = inode->i_sb->s_bdev;
36086d43 Theodore Ts'o   2015-10-03  429  		bio->bi_iter.bi_sector =
36086d43 Theodore Ts'o   2015-10-03  430  			pblk << (inode->i_sb->s_blocksize_bits - 9);
36086d43 Theodore Ts'o   2015-10-03  431  		ret = bio_add_page(bio, ciphertext_page,
b30ab0e0 Michael Halcrow 2015-04-12  432  				   inode->i_sb->s_blocksize, 0);
36086d43 Theodore Ts'o   2015-10-03  433  		if (ret != inode->i_sb->s_blocksize) {
36086d43 Theodore Ts'o   2015-10-03  434  			/* should never happen! */
36086d43 Theodore Ts'o   2015-10-03  435  			ext4_msg(inode->i_sb, KERN_ERR,
36086d43 Theodore Ts'o   2015-10-03  436  				 "bio_add_page failed: %d", ret);
36086d43 Theodore Ts'o   2015-10-03  437  			WARN_ON(1);
b30ab0e0 Michael Halcrow 2015-04-12  438  			bio_put(bio);
36086d43 Theodore Ts'o   2015-10-03  439  			err = -EIO;
b30ab0e0 Michael Halcrow 2015-04-12  440  			goto errout;
b30ab0e0 Michael Halcrow 2015-04-12  441  		}
b30ab0e0 Michael Halcrow 2015-04-12 @442  		err = submit_bio_wait(WRITE, bio);
36086d43 Theodore Ts'o   2015-10-03  443  		if ((err == 0) && bio->bi_error)
36086d43 Theodore Ts'o   2015-10-03  444  			err = -EIO;
95ea68b4 Theodore Ts'o   2015-05-31  445  		bio_put(bio);
b30ab0e0 Michael Halcrow 2015-04-12  446  		if (err)
b30ab0e0 Michael Halcrow 2015-04-12  447  			goto errout;
36086d43 Theodore Ts'o   2015-10-03  448  		lblk++; pblk++;
b30ab0e0 Michael Halcrow 2015-04-12  449  	}
b30ab0e0 Michael Halcrow 2015-04-12  450  	err = 0;

:::::: The code at line 442 was first introduced by commit
:::::: b30ab0e03407d2aa2d9316cba199c757e4bfc8ad ext4 crypto: add ext4 encryption facilities

:::::: TO: Michael Halcrow <mhalcrow@google.com>
:::::: CC: Theodore Ts'o <tytso@mit.edu>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
