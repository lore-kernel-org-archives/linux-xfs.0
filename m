Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5EB7E7F7C
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 14:30:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34CA2304081
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 12:30:42 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CrgqJefXCi4HPJbL for
	<xfs@oss.sgi.com>; Thu, 30 Jan 2014 12:30:41 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0UKUemt031812
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 15:30:41 -0500
Message-ID: <52EAB66E.204@redhat.com>
Date: Thu, 30 Jan 2014 14:30:38 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: limit superblock corruption errors to probable
	corruption
References: <52E88D8B.90208@redhat.com> <52EAB56D.2050203@redhat.com>
In-Reply-To: <52EAB56D.2050203@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 1/30/14, 2:26 PM, Brian Foster wrote:
>> diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
>> > index 511cce9..b575317 100644
>> > --- a/fs/xfs/xfs_sb.c
>> > +++ b/fs/xfs/xfs_sb.c
>> > @@ -617,6 +617,8 @@ xfs_sb_read_verify(
>> >  			/* Only fail bad secondaries on a known V5 filesystem */
>> >  			if (bp->b_bn != XFS_SB_DADDR &&
>> >  			    xfs_sb_version_hascrc(&mp->m_sb)) {
>> > +				XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
>> > +						     mp, bp->b_addr);
>> >  				error = EFSCORRUPTED;
>> >  				goto out_error;
>> >  			}
>> > @@ -625,12 +627,8 @@ xfs_sb_read_verify(
>> >  	error = xfs_sb_verify(bp, true);
>> >  
>> >  out_error:
>> > -	if (error) {
>> > -		if (error != EWRONGFS)
>> > -			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
>> > -					     mp, bp->b_addr);
>> > +	if (error)
>> >  		xfs_buf_ioerror(bp, error);
>> > -	}
>> >  }
> ... but why not leave the corruption output here in out_error, change
> the check to (error == EFSCORRUPTED) and remove the now duplicate
> corruption message in xfs_mount_validate_sb() (or replace it with a
> warn/notice message)? This would catch the other EFSCORRUPTED returns in
> a consistent manner, including another potential duplicate in the write
> verifier. I guess we'd lose a little specificity between the crc failure
> and sb validation, but we could add a warn/notice for the former too.
> 
> Brian
> 

Well, I went back and forth on this.  It's probably philosophical. ;)

Should we emit the corruption error at the point of corruption detection,
or at a higher level?  I guess my concern was that while *this* caller
might catch the return & yell, if another caller got added it might not.

Putting it at the point of detection seemed foolproof in that regard.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
