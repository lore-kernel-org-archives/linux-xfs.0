Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50538 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751506AbdFAJdQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Jun 2017 05:33:16 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 00/35 v1] pagevec API cleanups
Date: Thu,  1 Jun 2017 11:32:10 +0200
Message-Id: <20170601093245.29238-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, linux-nilfs@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu, linux-ext4@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>, "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Nadia Yvette Chambers <nyc@holomorphy.com>, Jan Kara <jack@suse.cz>

Hello,

This series cleans up pagevec API. The original motivation for the series is
the patch "fs: Fix performance regression in clean_bdev_aliases()" however it
has somewhat grown beyond that... The series is pretty large but most of the
patches are trivial in nature. What the series does is:

* Make all pagevec_lookup_ and find_get_ functions update index to where the
  search terminated. Currently tagged page lookup did update the index, other
  variants did not...

* Implement ranged variants for pagevec_lookup and find_get_ functions. Lot
  of callers actually want a ranged lookup and we unnecessarily opencode this
  in lot of them.

* Remove nr_pages argument from pagevec_ API since after implementing ranged
  lookups everyone just wants to pass PAGEVEC_SIZE there.

The conversion of the APIs for entries variants is not such a clear win as
for the other cases as callers tend to play more complex games with indices
etc. (hello THP). I still think the conversion is worth it for consistency
but I'm open to ideas (including just discarding that part) there.

The series also contains several fixes in the beginning to the bugs that I've
found during these cleanups. I've included them to have a clean base (4.12-rc3)
but those should get merged independently (e.g. ext4 fixes are already sitting
in ext4 tree). Also it is possible to split the series in smaller parts (like
convert one API at a time) however I wanted to post the full series so that
people can get the full picture.

The series can be also obtained from my git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git find_get_pages_range

Opinions and review welcome!

								Honza
