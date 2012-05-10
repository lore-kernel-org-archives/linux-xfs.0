Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4AK7RWN057867 for <xfs@oss.sgi.com>; Thu, 10 May 2012 15:07:27 -0500
Message-ID: <4FAC1FFC.1070507@sgi.com>
Date: Thu, 10 May 2012 15:07:24 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support v9
References: <4FABC2AD.2030609@oracle.com> <4FAC1C33.5050508@sgi.com>
	<20120510200832.GP16881@sgi.com>
In-Reply-To: <20120510200832.GP16881@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: jeff.liu@oracle.com, xfs@oss.sgi.com

On 05/10/12 15:08, Ben Myers wrote:
> On Thu, May 10, 2012 at 02:51:15PM -0500, Mark Tinguely wrote:
>> On 05/10/12 08:29, Jeff Liu wrote:
>>> Hello,
>>>
>>> This is the revised patch according to Mark's comments.
>>> Is it possible to get it to accept if there are no other issues,
>>> so that I can continue to work on the unwritten part based on that.
>>>
>>> Thanks,
>>> -Jeff
>>>
>>> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>>>
>>> ---
>>
>>> +
>>> +STATIC loff_t
>>> +xfs_seek_hole(
>>> +	struct file		*file,
>>> +	loff_t			start,
>>> +	u32			type)
>>> +{
>>> +	struct inode		*inode = file->f_mapping->host;
>>> +	struct xfs_inode	*ip = XFS_I(inode);
>>> +	struct xfs_mount	*mp = ip->i_mount;
>>> +	loff_t			uninitialized_var(offset);
>>> +	loff_t			holeoff;
>>> +	xfs_fsize_t		isize;
>>> +	xfs_fileoff_t		fsbno;
>>> +	uint			lock;
>>> +	int			error;
>>> +
>>> +	if (XFS_FORCED_SHUTDOWN(mp))
>>> +		return -XFS_ERROR(EIO);
>>
>> I think xfs_bmapi_read() returns just a XFS_ERROR(EIO), not negative.
>> Ben can fix up if you agree.
>
> Looks like error is negated at the bottom of the function and is not a problem.
>

Yes, but xfs_seek_data() also negates at the error at the end of the 
routine. They should be consistent.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
