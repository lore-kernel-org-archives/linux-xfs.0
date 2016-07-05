Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E49527CB5
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 23:31:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B64128F8033
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 21:31:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hBo5P0nUkeM1Iyzu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jul 2016 21:31:32 -0700 (PDT)
Date: Tue, 5 Jul 2016 12:31:30 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v6 00/20] xfstests: minor fixes for the reflink/dedupe
	tests
Message-ID: <20160705043130.GF23649@eguan.usersys.redhat.com>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Hi Darrick,

On Thu, Jun 16, 2016 at 06:46:02PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This is the sixth revision of a patchset that adds to xfstests
> support for testing reverse-mappings of physical blocks to file and
> metadata (rmap); support for testing multiple file logical blocks to
> the same physical block (reflink); and implements the beginnings of
> online metadata scrubbing.
> 
> The first eight patches are in Eryu Guan's pull request on 2016-06-15.
> Those patches haven't changed, but they're not yet in the upstream
> repo.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
> There are also updates for xfs-docs[4].  The kernel patches should
> apply to dchinner's for-next; xfsprogs patches to for-next; and
> xfstest to master.  The kernel git tree already has for-next included.
> 
> The patches have been xfstested with x64, i386, and armv7l--arm64,
> ppc64, and ppc64le no longer boot in qemu.  All three architectures
> pass all 'clone' group tests except xfs/128 (which is the swapext
> test), and AFAICT don't cause any new failures for the 'auto' group.
> 
> This is an extraordinary way to eat your data.  Enjoy! 
> Comments and questions are, as always, welcome.

I tested your xfstests patches with your kernel(HEAD f0b34b6 xfs: add
btree scrub tracepoints) and xfsprogs(HEAD 34bd754 xfs_scrub: create
online filesystem scrub program), with x86_64 host & 4k block size XFS.

A './check -g auto' run looked fine overall. Besides the comments I
replied to some patches, other common minor issues are:
- space indention in _cleanup not tab
- bare 'umount $SCRATCH_MNT' not _scratch_unmount
- whitespace issues in _test|scratch_inject_error

(I can fix all these minor issues at commit time, if you don't have
other major updates to these patches).

And the review of changes to xfs/122 needs help from other XFS
developers :) (09/20 and 10/20)

And besides the first 8 patches, 15/20 has been in upstream as well.

Thanks,
Eryu

P.S.
The failed tests I saw when testing with reflink-enabled kernel &
xfsprogs:

Failures: generic/054 generic/055 generic/108 generic/204 generic/356 generic/357 xfs/004 xfs/096 xfs/122 xfs/293

generic/108 generic/204 and xfs/004 are new failures compared to stock
kernel and xfsprogs (kernel 4.7-rc5, xfsprogs 4.7-rc1).

Just FYI.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
