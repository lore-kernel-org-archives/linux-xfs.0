Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C72357F3F
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 15:00:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 974CE8F8039
	for <xfs@oss.sgi.com>; Fri, 25 Apr 2014 13:00:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ubinRIswUJwTRgPH for <xfs@oss.sgi.com>;
	Fri, 25 Apr 2014 13:00:50 -0700 (PDT)
Message-ID: <535ABEF2.80003@sandeen.net>
Date: Fri, 25 Apr 2014 15:00:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: add heuristic to flush on rename
References: <535ABA9D.2060305@redhat.com>
In-Reply-To: <535ABA9D.2060305@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 4/25/14, 2:42 PM, Eric Sandeen wrote:
> Add a heuristic to flush data to a file which looks like it's
> going through a tmpfile/rename dance, but not fsynced.
> 
> I had a report of a system with many 0-length files after
> package updates; as it turns out, the user had basically
> done 'yum update' and punched the power button when it was
> done.
> 
> Granted, the admin should not do this.  Granted, the package
> manager should ensure persistence of files it updated.
> 
> Ext4, however, added a heuristic like this for just this case;
> someone who writes file.tmp, then renames over file, but
> never issues an fsync.
> 
> Now, this does smack of O_PONIES, but I would hope that it's
> fairly benign.  If someone already synced the tmpfile, it's
> a no-op.
> 
> And it's not THAT far off our "flush on close if the file was
> truncated" heuristic.
> 
> Comments?  Flames?  Testing anyone would like to see?
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ef1ca01..5c95ef5 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -371,6 +371,19 @@ xfs_vn_rename(
>  	xfs_dentry_to_name(&oname, odentry, 0);
>  	xfs_dentry_to_name(&nname, ndentry, odentry->d_inode->i_mode);
>  
> +	/*
> +	 * If we are renaming a just-written file over an existing
> +	 * file, be pedantic and flush it out if it looks like somebody
> +	 * is doing a tmpfile dance, and didn't fsync.  Best effort;
> +	 * ignore errors.
> +	 */
> +	if (new_inode) {
> +		xfs_inode_t *ip = XFS_I(odentry->d_inode);
> +
> +		if (VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0)
> +			filemap_flush(new_inode->i_mapping);

Uhhh I flushed the wrong inode (thanks Brian!) but you get the idea ;)

should be:

+			filemap_flush(odentry->d_inode->i_mapping);

-Eric

> +	}
> +
>  	return -xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
>  			   XFS_I(ndir), &nname, new_inode ?
>  						XFS_I(new_inode) : NULL);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
