Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C509E7CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 14:48:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 793288F8033
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 12:48:52 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id bAgkLo7rv9PEJgrH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 12:48:50 -0700 (PDT)
Date: Thu, 5 May 2016 12:47:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC 0/3] getfsmapx ioctl
Message-ID: <20160505194754.GA2785@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Mark Fasheh <mfasheh@suse.de>, Josef Bacik <jbacik@fb.com>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs <xfs@oss.sgi.com>

Hi,

Building on the discussion "Exposing Extent Information to Userspace"
at LSF, this patchset offers the userspace definition, implementation,
and manpages for a new FS_IOC_GETFSMAPX ioctl that enables userspace
to query the filesystem for a map of every extent in a given range of
physical block keyspace.

Note that prior to the existence of block sharing, I'd have said
"given range of physical blocks", but now that we can return multiple
owner:offset pairs for a given block, the block keyspace now has to
include extra fields to uniquely identify a reverse mapping record.

This ioctl behaves in a similar manner to XFS_IOC_GETBMAPX -- pass in
an array of struct getfsmapx with key and other control values in the
first two array elements, and the kernel passes back extent
information in the other array elements.  The particulars of how to do
this are documented in the manpage that goes along with this set (it
applies against man-pages.git) and example code in the other patches
is against xfsprogs.git#for-next.

Basically, set the lowest key for which you want records in the first
array element; the highest key in the second; and the kernel spits out
records in the rest of the elements.  That's similar to how GETBMAPX
does it, but different from FIEMAP.  I added a dummy 64-bit "device
id" per Josef's request, though I'm thinking that could be cut down to
a simple dev_t.  I also wonder if the kernel should rewrite the low
key with the last element returned so as to seed the next call, but
userspace can do that too.

The kernel-space implementation (for XFS) is buried inside the xfs
reverse mapping patchset which is treading water at github[1].  I
prefer not to patchbomb the whole kernel series until I've put the
mess through better testing, but this should be enough to get the
mailing list discussion started.

Questions?  Comments?  Bike sheds?

--D

[1] https://github.com/djwong/linux/tree/djwong-experimental

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
