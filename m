Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47200 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbeLLQmZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Dec 2018 11:42:25 -0500
Date: Wed, 12 Dec 2018 08:42:15 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/11] vfs: add missing checks to copy_file_range
Message-ID: <20181212164215.GY24487@magnolia>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-5-david@fromorbit.com>
 <87a7lbrng4.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a7lbrng4.fsf@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Henriques <lhenriques@suse.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, olga.kornievskaia@gmail.com, linux-nfs@vger.kernel.org, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Wed, Dec 12, 2018 at 11:31:23AM +0000, Luis Henriques wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> <snip>
> 
> > +int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
> > +			 struct file *file_out, loff_t pos_out,
> > +			 size_t *req_count, unsigned int flags)
> > +{
> 
> <snip>
> 
> > +	/* Don't allow overlapped copying within the same file. */
> > +	if (inode_in == inode_out &&
> > +	    pos_out + count > pos_in &&
> > +	    pos_out < pos_in + count)
> > +		return -EINVAL;
> 
> I was wondering if, with the above check, it would make sense to also
> have an extra patch changing some filesystems (ceph, nfs and cifs) to
> simply return -EOPNOTSUPP (instead of -EINVAL) when inode_in ==
> inode_out.  Something like the diff below (not tested!).
> 
> This caught my attention when I was running the latest generic xfstests
> on ceph and realised that I had some new failures due to the recently
> added copy_file_range support in fsx by Darrick.  The failures were
> caused by the usage of the same fd both as source and destination.

Looks reasonable to /me/, since EOPNOTSUPP currently triggers the
splice fallback.

--D

> Cheers,
> -- 
> Luis
> 
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 189df668b6a0..c22ac60ec0ba 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1904,7 +1904,7 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  	bool do_final_copy = false;
>  
>  	if (src_inode == dst_inode)
> -		return -EINVAL;
> +		return -EOPNOTSUPP;
>  	if (ceph_snap(dst_inode) != CEPH_NOSNAP)
>  		return -EROFS;
>  
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 865706edb307..d4f63eae531e 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1068,7 +1068,7 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
>  	cifs_dbg(FYI, "copychunk range\n");
>  
>  	if (src_inode == target_inode) {
> -		rc = -EINVAL;
> +		rc = -EOPNOTSUPP;
>  		goto out;
>  	}
>  
> diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
> index 46d691ba04bc..910a2abade92 100644
> --- a/fs/nfs/nfs4file.c
> +++ b/fs/nfs/nfs4file.c
> @@ -136,7 +136,7 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
>  	ssize_t ret;
>  
>  	if (file_inode(file_in) == file_inode(file_out))
> -		return -EINVAL;
> +		return -EOPNOTSUPP;
>  retry:
>  	ret = nfs42_proc_copy(file_in, pos_in, file_out, pos_out, count);
>  	if (ret == -EAGAIN)
