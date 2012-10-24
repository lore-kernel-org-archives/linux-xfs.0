Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OGFQnO025717 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 11:15:26 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MjoqpLGd7zB8sBEq for
	<xfs@oss.sgi.com>; Wed, 24 Oct 2012 09:17:11 -0700 (PDT)
Message-ID: <508814F2.3060409@redhat.com>
Date: Wed, 24 Oct 2012 12:18:58 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 08/10] xfs: add quota id filtering to eofblocks scan
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-9-git-send-email-bfoster@redhat.com>
	<20121023014222.GL4291@dastard>
In-Reply-To: <20121023014222.GL4291@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/22/2012 09:42 PM, Dave Chinner wrote:
> On Fri, Oct 05, 2012 at 10:17:14AM -0400, Brian Foster wrote:
>> Support quota ID filtering in the eofblocks scan. The caller must
>> set the XFS_EOF_FLAGS_QUOTA flags bit, quota ID and quota type. The
>> associated quota type must be enabled on the mounted filesystem.
> 
> I'm wondering if this even needs quota enabled to filter based on a
> uid, gid, or prid?
> 

Not really...

> The quota part of it seem irrelevant to the filtering that is being
> executed - we are only matching against the inode uid/gid/prid, not
> against dquots - and I can see situations where just being able to
> filter on a given uid/gid might be useful in a multi-user
> environment regardless of whether quotas are being used.
> 

This is how my rfc version was implemented (with a comment to the same
effect). I added the explicit checking in response to:

http://oss.sgi.com/archives/xfs/2012-09/msg00024.html

> Indeed, even testing is made much easier if we don't have to
> juggle quota mount options to test the filtering....
> 

I agree. I suppose the check can make a bit of sense if the current
group/proj mode of the mount conflicts with the eofb request, but as
you've outlined above, we're checking against the inode values so I
don't think it introduces a functional problem.

Regardless, could you confirm your reasoning here with regard to the
previous comments before I go and make this change? ;)

>> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
>> index 35efdda..b39970b 100644
>> --- a/fs/xfs/xfs_icache.c
>> +++ b/fs/xfs/xfs_icache.c
>> @@ -1171,6 +1171,22 @@ xfs_reclaim_inodes_count(
>>  }
>>  
>>  STATIC int
>> +xfs_inode_match_quota_id(
>> +	struct xfs_inode	*ip,
>> +	struct xfs_eofblocks	*eofb)
>> +{
>> +	unsigned int type = xfs_quota_type(eofb->eof_q_type);
>> +	if (type == XFS_DQ_USER)
>> +		return ip->i_d.di_uid == eofb->eof_q_id;
>> +	else if (type == XFS_DQ_GROUP)
>> +		return ip->i_d.di_gid == eofb->eof_q_id;
>> +	else if (type == XFS_DQ_PROJ)
>> +		return xfs_get_projid(ip) == eofb->eof_q_id;
>> +
>> +	return 0;
>> +}
> 
> Why do you need xfs_quota_type() here? why not just:
> 
> 	switch (type) {
> 	case XQM_USRQUOTA:
> 		return ip->i_d.di_uid == eofb->eof_q_id;
> 	case XQM_GRPQUOTA:
> 		return ip->i_d.di_gid == eofb->eof_q_id;
> 	case XQM_PRJQUOTA:
> 		return xfs_get_projid(ip) == eofb->eof_q_id;
> 	default:
> 		break;
> 	}
> 
> 	return 0;
> 

Technically we don't really need xfs_quota_type(). I just thought it
cleaner to use the same mapping we use throughout XFS (i.e., I don't see
those definitions used elsewhere in XFS)...

>> @@ -1194,6 +1211,13 @@ xfs_inode_free_eofblocks(
>>  	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
>>  		return 0;
>>  
>> +	if (eofb) {
>> +		/* filter by quota id */
>> +		if (eofb->eof_flags & XFS_EOF_FLAGS_QUOTA &&
>> +		    !xfs_inode_match_quota_id(ip, eofb))
>> +			return 0;
>> +	}
>> +
>>  	ret = xfs_free_eofblocks(ip->i_mount, ip, true);
>>  
>>  	/* don't revisit the inode if we're not waiting */
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index ad4352f..547363b 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -1613,6 +1613,14 @@ xfs_file_ioctl(
>>  		if (eofb.eof_version != XFS_EOFBLOCKS_VERSION)
>>  			return -XFS_ERROR(EINVAL);
>>  
>> +		if (eofb.eof_flags & XFS_EOF_FLAGS_QUOTA) {
>> +			unsigned int type = xfs_quota_type(eofb.eof_q_type);
>> +			if ((type == XFS_DQ_USER && !XFS_IS_UQUOTA_ON(mp)) ||
>> +			    (type == XFS_DQ_GROUP && !XFS_IS_GQUOTA_ON(mp)) ||
>> +			    (type == XFS_DQ_PROJ && !XFS_IS_PQUOTA_ON(mp)))
>> +				return -XFS_ERROR(EINVAL);
>> +		}
> 
> Again, I don't really see the reason for needing xfs_quota_type()
> here, and whether the quota check is relevant at all...
> 

Same comment as above... would you prefer I just use the XQM_
definitions and lose the xfs_quota_type() patch?

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
