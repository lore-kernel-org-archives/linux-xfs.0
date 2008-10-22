Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 22:47:34 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9M5lUUl025618
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 22:47:30 -0700
Message-ID: <48FEBEDA.2040209@sgi.com>
Date: Wed, 22 Oct 2008 16:49:14 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] use XFS_I and VFS_I in xfs_dm.c
References: <20080822014205.GA10805@lst.de> <20080929092135.GA27608@lst.de>
In-Reply-To: <20080929092135.GA27608@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> ping?

A similar patch has already been checked into the tree (which hopefully
should be working again). I can apply the 3 remaining changes, just
mentioning it here for transparency.

> 
> On Fri, Aug 22, 2008 at 03:42:05AM +0200, Christoph Hellwig wrote:
>> Convert xfs_dm.c to use the XFS_I and VFI_I helper, or in some cases
>> IHOLD/IRELE so that it still compiles with Dave's inode unification
>> patch.  It's only really required for the latter, but also a nice
>> cleanup without it, so it should probably go in before that patch
>> series.
>>
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
>> ===================================================================
>> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-08-19 22:42:31.000000000 -0300
>> +++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-08-19 22:45:17.000000000 -0300
>> @@ -140,7 +140,7 @@ xfs_dm_send_data_event(
>>  	int		flags,
>>  	int		*lock_flags)
>>  {
>> -	struct inode	*inode = ip->i_vnode;
>> +	struct inode	*inode = VFS_I(ip);
>>  	int		error;
>>  	uint16_t	dmstate;
>>  

Already in

>> @@ -468,7 +468,7 @@ xfs_dm_bulkall_iget_one(
>>  		return error;
>>  
>>  	xfs_ip_to_stat(mp, ino, ip, &xbuf->dx_statinfo);
>> -	dm_ip_to_handle(ip->i_vnode, &handle);
>> +	dm_ip_to_handle(VFS_I(ip), &handle);
>>  	xfs_dm_handle_to_xstat(xbuf, xstat_sz, &handle, sizeof(handle));
>>  
>>  	/* Drop ILOCK_SHARED for call to xfs_attr_get */

Already in

>> @@ -476,7 +476,7 @@ xfs_dm_bulkall_iget_one(
>>  
>>  	memset(&xbuf->dx_attrdata, 0, sizeof(dm_vardata_t));
>>  	error = xfs_attr_get(ip, attr_name, attr_buf, &value_len, ATTR_ROOT);
>> -	iput(ip->i_vnode);
>> +	IRELE(ip);
>>  
>>  	DM_EA_XLATE_ERR(error);
>>  	if (error && (error != ENOATTR)) {

Fixed as
-	iput(ip->i_vnode);
+	iput(VFS_I(ip));


>> @@ -726,7 +726,7 @@ xfs_dm_bulkattr_iget_one(
>>  		return error;
>>  
>>  	xfs_ip_to_stat(mp, ino, ip, sbuf);
>> -	dm_ip_to_handle(ip->i_vnode, &handle);
>> +	dm_ip_to_handle(VFS_I(ip), &handle);
>>  	xfs_dm_handle_to_stat(sbuf, stat_sz, &handle, sizeof(handle));
>>  
>>  	xfs_iput(ip, XFS_ILOCK_SHARED);

Already in

>> @@ -907,7 +907,7 @@ xfs_dm_f_set_eventlist(
>>  	ip->i_d.di_dmevmask = (eventset & max_mask) | (ip->i_d.di_dmevmask & ~max_mask);
>>  
>>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
>> -	igrab(ip->i_vnode);
>> +	IHOLD(ip);
>>  	xfs_trans_commit(tp, 0);
>>  
>>  	return(0);

Fixed as
+	igrab(VFS_I(ip))

>> @@ -2731,7 +2731,7 @@ xfs_dm_send_destroy_event(
>>  	dm_right_t	vp_right)	/* always DM_RIGHT_NULL */
>>  {
>>  	/* Returns positive errors to XFS */
>> -	return -dm_send_destroy_event(ip->i_vnode, vp_right);
>> +	return -dm_send_destroy_event(VFS_I(ip), vp_right);
>>  }

Already in

>>  
>> @@ -2751,8 +2751,8 @@ xfs_dm_send_namesp_event(
>>  {
>>  	/* Returns positive errors to XFS */
>>  	return -dm_send_namesp_event(event, mp ? mp->m_super : NULL,
>> -				    ip1->i_vnode, vp1_right,
>> -				    ip2 ? ip2->i_vnode : NULL, vp2_right,
>> +				    VFS_I(ip1), vp1_right,
>> +				    ip2 ? VFS_I(ip2) : NULL, vp2_right,
>>  				    name1, name2,
>>  				    mode, retcode, flags);
>>  }

Already in

>> @@ -2779,7 +2779,7 @@ xfs_dm_send_unmount_event(
>>  	int		retcode,	/* errno, if unmount failed */
>>  	int		flags)
>>  {
>> -	dm_send_unmount_event(mp->m_super, ip ? ip->i_vnode : NULL,
>> +	dm_send_unmount_event(mp->m_super, ip ? VFS_I(ip) : NULL,
>>  			      vfsp_right, mode, retcode, flags);
>>  }
>>  

Already in

>> @@ -2822,9 +2822,8 @@ xfs_dm_fh_to_inode(
>>  
>>  	if (!dmfid->dm_fid_len) {
>>  		/* filesystem handle */
>> -		*inode = igrab(mp->m_rootip->i_vnode);
>> -		if (!*inode)
>> -			return -ENOENT;
>> +		IHOLD(mp->m_rootip);
>> +		*inode = VFS_I(mp->m_rootip);
>>  		return 0;
>>  	}
>>  

Fixed As
+		*inode = igrab(VFS_I(mp->m_rootip));

>> @@ -2849,7 +2848,7 @@ xfs_dm_fh_to_inode(
>>  		return -ENOENT;
>>  	}
>>  
>> -	*inode = ip->i_vnode;
>> +	*inode = VFS_I(ip);
>>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
>>  	return 0;
>>  }

Already in

> ---end quoted text---
> 
