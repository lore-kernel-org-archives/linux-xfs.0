Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7CDA67F5D
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:01:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C4B28F8064
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 10:01:40 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gnvrq4zGCdQMSVF9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 10:01:39 -0800 (PST)
Date: Thu, 12 Dec 2013 10:01:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/10] xfstests: do not unmount tmpfs during remount.
Message-ID: <20131212180130.GA19422@infradead.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-6-git-send-email-jayr@google.com>
	<20131211074615.GE19248@infradead.org>
	<20131211224012.GJ10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131211224012.GJ10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: tytso@mit.edu, Junho Ryu <jayr@google.com>, hughd@google.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, branto@redhat.com

On Thu, Dec 12, 2013 at 09:40:12AM +1100, Dave Chinner wrote:
> IOWs, adding tmpfs changes the definition of a "generic" test.
> 
> i.e. instead of:
> 
> _supported_fs generic
> 
> these tests are now:
> 
> _supported_fs xfs ext2 ext3 ext4 ext4dev btrfs gfs2 nfs udf reiserfs
> 
> and by that definition should be in the tests/shared directory....
> 
> That's a bit of a pain, but I really don't like the idea of having
> "generic" tests that aren't actually generic by having to define
> exceptions for them...

We already have tons of these:

tests/generic/079:    _notrun "Setting immutable/append flag not supported"
tests/generic/192:      _notrun "this test makes no sense with noatime"
tests/generic/225:            _notrun "FIEMAP not supported by this filesystem type: $FSTYP"
tests/generic/251:_test_batched_discard $SCRATCH_MNT || _notrun "FITRIM not supported on $SCRATCH_DEV"
tests/generic/260:_test_batched_discard $SCRATCH_MNT || _notrun "FITRIM not supported on $SCRATCH_DEV"
tests/generic/288:_test_batched_discard $SCRATCH_MNT || _notrun "FITRIM
 not supported on $SCRATCH_DEV"


tests/generic/053:_require_acls
tests/generic/077:_require_acls
tests/generic/099:_require_acls
tests/generic/105:_require_acls
tests/generic/237:_require_acls
tests/generic/314:_require_acls
tests/generic/318:_require_acls
tests/generic/319:_require_acls

tests/generic/020:_require_attrs
tests/generic/062:_require_attrs
tests/generic/070:_require_attrs
tests/generic/077:_require_attrs
tests/generic/079:_require_attrs
tests/generic/093:_require_attrs
tests/generic/097:_require_attrs
tests/generic/117:_require_attrs

tests/generic/213:_require_xfs_io_falloc
tests/generic/214:_require_xfs_io_falloc
tests/generic/223:_require_xfs_io_falloc
tests/generic/228:_require_xfs_io_falloc
tests/generic/255:_require_xfs_io_falloc_punch
tests/generic/255:_require_xfs_io_falloc
tests/generic/256:_require_xfs_io_falloc_punch
tests/generic/274:_require_xfs_io_falloc
tests/generic/312:_require_xfs_io_falloc
tests/generic/316:_require_xfs_io_falloc_punch

tests/generic/068:_require_freeze
tests/generic/280:_require_freezeA

tests/generic/219:_require_quota
tests/generic/230:_require_quota
tests/generic/231:_require_quota
tests/generic/232:_require_quota
tests/generic/233:_require_quota
tests/generic/234:_require_quota
tests/generic/235:_require_quota
tests/generic/270:_require_quota
tests/generic/280:_require_quota

tests/generic/285:_require_seek_data_hole
tests/generic/286:_require_seek_data_hole

tests/generic/014:_require_sparse_files
tests/generic/129:_require_sparse_files
tests/generic/130:_require_sparse_files
tests/generic/239:_require_sparse_files
tests/generic/240:_require_sparse_files

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
