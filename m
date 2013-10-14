Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F1C7C7F37
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 15:46:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88EEBAC003
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 13:46:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JW6vlWhGYLVz94sk for <xfs@oss.sgi.com>;
	Mon, 14 Oct 2013 13:46:19 -0700 (PDT)
Date: Tue, 15 Oct 2013 07:46:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: handle symlinks etc in
	fs_table_initialise_mounts()
Message-ID: <20131014204617.GG5663@dastard>
References: <5249AE5F.30305@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5249AE5F.30305@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 30, 2013 at 12:01:19PM -0500, Eric Sandeen wrote:
> Commit:
> 
> 6a23747d xfs_quota: support relative path as `path' arguments
> 
> used realpath() on the supplied pathname to handle things like
> relative pathnames and pathnames ending in "/" which otherwise
> caused the getmntent scanning to fail.
> 
> However, this regressed cases where a path in mtab was a symlink;
> realpath() resolves this to the target, and so no match is found.
> 
> This causes i.e.:
> 
> # xfs_quota -x -c report /dev/mapper/testvg-testlv
> 
> to fail with:
> 
> xfs_quota: cannot setup path for mount /dev/mapper/testvg-testlv: No such device or address
> 
> because the scanning looks for /dev/dm-3, but the long symlink
> name is what exists in mtab, and no match is found.
> 
> Fix this, but keep the intended enhancements, by testing *both* the
> user-specified path (which might be relative, or contain a trailing
> slash on a mountpoint) and the realpath-resolved path (which turns
> a relative mountpoint into a full path, and removes trailing slashes),
> to determine whether the user-specified path is an xfs mountpoint or
> device.
> 
> While we're at it, add a few comments, and go back to the testing
> of "path" not "rpath"; whether or not path is passed to the function
> is what determines control flow.  If path is specified, and realpath
> succeeds, we're guaranteed to have rpath as well, so there is no need
> to retest that.  rpath is initialized to NULL, so an unconditional
> free(rpath) is safe as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks good. There's a bunch of minor cleanups that could be done to
this code, but save that for a rainy day...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
