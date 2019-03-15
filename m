Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43222 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfCOCq2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Mar 2019 22:46:28 -0400
Subject: Re: [PATCH 10/36] xfs_scrub_all: walk the lsblk device/fs hierarchy
 correctly
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259749135.31886.17642733861513368966.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <08cb3064-6fd1-db42-444d-17d2a018825a@sandeen.net>
Date: Thu, 14 Mar 2019 21:46:26 -0500
MIME-Version: 1.0
In-Reply-To: <155259749135.31886.17642733861513368966.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:04 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Back when I was designing xfs_scrub_all, I naïvely assumed that the
> emitted output would always list physical storage before the virtual
> devices stacked atop it.  However, this is not actually true when one
> omits the "NAME" column,

I think I asked this on IRC but for the record, is this incidental
or guaranteed by lsblk?  I don't see this distinction in the manpage.

I worry about depending on undocumented behavior...

Looking back through IRC, I think we shrugged over this, I asked kzak
but didn't get a reply, will try to find him again.

(also FWIW, older lsblk rejects -J, do we care?)

-Eric

> which is crucial to forcing the output (json or
> otherwise) to capture the block device hierarchy.  If the assumption is
> violated, the program crashes with a python exception.
> 
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
