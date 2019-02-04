Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38074 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727917AbfBDSIu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 13:08:50 -0500
Subject: Re: [PATCH 1/8] xfs_scrub_all: walk the lsblk device/fs hierarchy
 correctly
References: <154524776457.28646.3004453037075812416.stgit@magnolia>
 <154524777080.28646.13859873012142786308.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d4cd6eba-2767-9fea-ea98-2416fe5c2ba4@sandeen.net>
Date: Mon, 4 Feb 2019 12:08:49 -0600
MIME-Version: 1.0
In-Reply-To: <154524777080.28646.13859873012142786308.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 12/19/18 1:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Back when I was designing xfs_scrub_all, I naïvely assumed that the
> emitted output would always list physical storage before the virtual
> devices stacked atop it.  However, this is not actually true when one
> omits the "NAME" column, which is crucial to forcing the output (json or
> otherwise) to capture the block device hierarchy.  If the assumption is
> violated, the program crashes with a python exception.

Is this a quirk or a documented feature of lsblk?
 
> To fix this, force the hierarchal json output and restructure the
> discovery routines to walk the json object that we receive, from the top
> (physical devices) downwards to wherever there are live xfs filesystems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/xfs_scrub_all.in |   28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/scrub/xfs_scrub_all.in b/scrub/xfs_scrub_all.in
> index c4e9899d..5b76b49a 100644
> --- a/scrub/xfs_scrub_all.in
> +++ b/scrub/xfs_scrub_all.in
> @@ -28,9 +28,21 @@ def DEVNULL():
>  
>  def find_mounts():
>  	'''Map mountpoints to physical disks.'''
> +	def find_xfs_mounts(bdev, fs, lastdisk):
> +		'''Attach lastdisk to each fs found under bdev.'''
> +		if bdev['fstype'] == 'xfs' and bdev['mountpoint'] is not None:
> +			mnt = bdev['mountpoint']
> +			if mnt in fs:
> +				fs[mnt].add(lastdisk)
> +			else:
> +				fs[mnt] = set([lastdisk])
> +		if 'children' not in bdev:
> +			return
> +		for child in bdev['children']:
> +			find_xfs_mounts(child, fs, lastdisk)
>  
>  	fs = {}
> -	cmd=['lsblk', '-o', 'KNAME,TYPE,FSTYPE,MOUNTPOINT', '-J']
> +	cmd=['lsblk', '-o', 'NAME,KNAME,TYPE,FSTYPE,MOUNTPOINT', '-J']

sorry for the ridonculously late review, and although '-J" isn't added
new in this patch, FYI at least RHEL7 does not allow it:

# lsblk -o KNAME -J
lsblk: invalid option -- 'J'

... thoughts?  Probably should be handled gracefully at least?

-Eric

>  	result = subprocess.Popen(cmd, stdout=subprocess.PIPE)
>  	result.wait()
>  	if result.returncode != 0:
> @@ -38,18 +50,12 @@ def find_mounts():
>  	sarray = [x.decode(sys.stdout.encoding) for x in result.stdout.readlines()]
>  	output = ' '.join(sarray)
>  	bdevdata = json.loads(output)
> +
>  	# The lsblk output had better be in disks-then-partitions order
>  	for bdev in bdevdata['blockdevices']:
> -		if bdev['type'] in ('disk', 'loop'):
> -			lastdisk = bdev['kname']
> -		if bdev['fstype'] == 'xfs':
> -			mnt = bdev['mountpoint']
> -			if mnt is None:
> -				continue
> -			if mnt in fs:
> -				fs[mnt].add(lastdisk)
> -			else:
> -				fs[mnt] = set([lastdisk])
> +		lastdisk = bdev['kname']
> +		find_xfs_mounts(bdev, fs, lastdisk)
> +
>  	return fs
>  
>  def kill_systemd(unit, proc):
> 
