Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAKDFPKR157024 for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 07:15:25 -0600
Message-ID: <4EC8FD55.6060902@oracle.com>
Date: Sun, 20 Nov 2011 21:15:01 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support to XFS V1
References: <4E887D7F.2010306@oracle.com>
	<20111114102444.GA27791@infradead.org>
	<4EC10DE8.6030607@oracle.com> <20111114125044.GA9802@infradead.org>
	<4EC768F5.4050904@oracle.com> <4EC76AB9.9030604@oracle.com>
	<20111119191138.GA24444@infradead.org>
In-Reply-To: <20111119191138.GA24444@infradead.org>
Reply-To: jeff.liu@oracle.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: aelder@sgi.com, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

Hi Christoph,

Thanks for your quick response!
On 11/20/2011 03:11 AM, Christoph Hellwig wrote:

> On Sat, Nov 19, 2011 at 04:37:13PM +0800, Jeff Liu wrote:
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> Thanks a lot Jeff.  A few comments below:
> 
>> +int
>> +xfs_seek_data_hole(
>> +	struct xfs_inode	*ip,
>> +	loff_t			*start,
>> +	u32			type)
>> +{
>> +	xfs_mount_t		*mp = ip->i_mount;
> 
> please use
> 
> 	struct xfs_mount	*mp = ip->i_mount;
> 
> for all new code.

> 
>> +	if (xfs_get_extsz_hint(ip) ||
>> +	    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
>> +		filelen = XFS_MAXIOFFSET(mp);
>> +	} else {
>> +		filelen = ip->i_size;
>> +	}
> 
> I don't understand this.  XFS_MAXIOFFSET is the maximum possible file
> size in an XFS filesystem - using it with an extent size hint or
> the prealloc or appen only flags doesn't make sense to me.

Sorry, I forgot why I using it to retrieve the file size before. :( but
it definitely don't needed here.

> 
>> +	if (type == SEEK_DATA) {
> 
> xfs_seek_data_hole shares almost no common code between the SEEK_DATA
> and SEEK_HOLE cases, which suggests it probably should be two different
> routines.

Yes, it's better to split SEEK_DATA/SEEK_HOLE into two different functions.

> 
> 
>> +STATIC loff_t
>> +xfs_file_llseek(
>> +	struct file *file,
>> +	loff_t offset,
>> +	int origin)
>> +{
>> +	struct inode *inode = file->f_mapping->host;
>> +	int ret;
>> +
>> +	if (origin != SEEK_DATA && origin != SEEK_HOLE)
>> +		return generic_file_llseek(file, offset, origin);
>> +
>> +	mutex_lock(&inode->i_mutex);
>> +	switch (origin) {
>> +	case SEEK_DATA:
>> +	case SEEK_HOLE:
> 
> Having the if above and then the switch here seems like and odd style.
> I'd do either an if, or a switch statement for all possible variants,
> but not both.

I'll fix it with switch statement then. :-)

> 
>> +		if (offset >= i_size_read(inode)) {
>> +			ret = -ENXIO;
>> +			goto error;
>> +		}
>> +
>> +		ret = xfs_find_desired_extent(inode, &offset, origin);
>> +		if (ret)
>> +			goto error;
>> +	}
>> +
>> +	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
>> +		ret = -EINVAL;
>> +		goto error;
>> +	}
> 
> I don't think this could ever happen on XFS.
> 
>> +	if (offset > inode->i_sb->s_maxbytes) {
>> +		ret = -EINVAL;
>> +		goto error;
>> +	}
> 
> This also shouldn't happen if the low-level code does the right
> thing.

> 
>> +	if (offset != file->f_pos) {
>> +		file->f_pos = offset;
>> +		file->f_version = 0;
>> +	}
> 
> XFS never uses f_version, no need to update it.


Thanks for pointing out my mistakes for above three issues,
I have not think carefully about them, just copy && paste the code block
from btrfs instead, they will be fixed in the next post.

> 
>> +int
>> +xfs_find_desired_extent(
>> +	struct inode		*inode,
>> +	loff_t			*start,
>> +	u32			type)
> 
> I think this would better be merged with the code currenly in
> xfs_file_llseek.  Maybe move all the SEEK_DATA/SEEK_HOLE specific
> code from there to this function?
> 
> Also please move this routine to be next to xfs_file_llseek in xfs_file.c,
> which also means that it can be marked static.

ok, I'll merge both find_desired_extent() and seek_data_hole() to a
single routine and place it there.

> 
>> +{
>> +	xfs_inode_t		*ip = XFS_I(inode);
>> +	xfs_mount_t		*mp = ip->i_mount;
> 
> Just as above please use the struct versions for new code.
> 
>> +	/*
>> +	 * Flush the delay alloc blocks. Even after flushing the inode,
>> +	 * there can still be delalloc blocks on the inode beyond EOF
>> +	 * due to speculative preallocation. These are not removed until
>> +	 * the release function is called or the inode is inactivated.
>> +	 * Hence we cannot assert here that ip->i_delayed_blks == 0.
>> +	 */
>> +	if (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size) {
>> +		error = xfs_flush_pages(ip, 0, -1, 0, FI_REMAPF);
>> +		if (error)
>> +			goto out_unlock_iolock;
>> +	}
> 
> For the final version we should get rid of this flush and instead look
> for pages having dirty unwritten extents in the pagecache and adjust
> the result based on it.  I'm fine with delaying this until all other
> issues are sorted out.

Per Dave's comments, we would get ride of pages flush if using
xfs_bmapi_read() to retrieve the delayed extents info from the initial
implementation.

Thanks,
-Jeff

> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
