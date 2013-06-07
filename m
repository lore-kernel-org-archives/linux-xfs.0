Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BBDFE7CBF
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 09:05:55 -0500 (CDT)
Message-ID: <51B1E8BF.4070306@sgi.com>
Date: Fri, 07 Jun 2013 09:05:51 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] xfs: fix the symbolic link assert in xfs_ifree
References: <20130606161032.753011157@sgi.com>
	<20130606161027.166439519@sgi.com> <20130607010615.GH29338@dastard>
In-Reply-To: <20130607010615.GH29338@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/06/13 20:06, Dave Chinner wrote:
> On Thu, Jun 06, 2013 at 11:10:33AM -0500, Mark Tinguely wrote:
>> Adding an extended attribute to a symbolic link can force that
>> link to an remote extent. xfs_inactive() incorrectly assumes
>> that any symbolic link small enough to be in the inode core
>> is incore, the remote extent is not cleaned and xfs_ifree()
>> asserts on presence the remote extent.
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> ---
>>   fs/xfs/xfs_vnodeops.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> Index: b/fs/xfs/xfs_vnodeops.c
>> ===================================================================
>> --- a/fs/xfs/xfs_vnodeops.c
>> +++ b/fs/xfs/xfs_vnodeops.c
>> @@ -325,7 +325,7 @@ xfs_inactive(
>>   		/*
>>   		 * Zero length symlinks _can_ exist.
>>   		 */
>> -		if (ip->i_d.di_size>  XFS_IFORK_DSIZE(ip)) {
>> +		if (ip->i_d.di_nextents) {
>>   			error = xfs_inactive_symlink_rmt(ip,&tp);
>>   			if (error)
>>   				goto out_cancel;
>
> This should match the check done in xfs_readlink. i.e. it should
> check against the fork format being in local or extent form, not
> check against the inode size.
>
> Also, I think that this symlink specific code should be factored out
> of xfs_inactive() and moved to fs/xfs/xfs_symlink.c as
> xfs_symlink_truncate() so that all the intricacies of the symlink
> truncation are in the one place. This would make
> xfs_symlink_truncate() look very similar to xfs_readlink()...
>


Sounds good.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
