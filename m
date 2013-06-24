Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 496227F37
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 22:28:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0A3C38F8039
	for <xfs@oss.sgi.com>; Sun, 23 Jun 2013 20:28:10 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Xr2SUONrhbcc9tdz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Jun 2013 20:28:08 -0700 (PDT)
Message-ID: <51C7BCC0.8040006@oracle.com>
Date: Mon, 24 Jun 2013 11:28:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: lseek SEEK_DATA/SEEK_HOLE consolidation
References: <51C454DE.2010008@oracle.com> <20130623231320.GC29376@dastard>
In-Reply-To: <20130623231320.GC29376@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Dave,
On 06/24/2013 07:13 AM, Dave Chinner wrote:

> On Fri, Jun 21, 2013 at 09:27:58PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Consolidate lseek(2) SEEK_DATA/SEEK_HOLE according to the
>> implementation of VFS lseek_execute():
>> - if end up with a negative offset, return EINVAL if file
>>   is not huge.
>> - if end up with an offset larger than s_maxbytes, return
>>   EINVAL as well.
>> - reset file version to 0 if end up with an offset that is
>>   not equal to the current file offset.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>
>> ---
>>  fs/xfs/xfs_file.c |   26 ++++++++++++++++++++++++--
>>  1 file changed, 24 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index a5f2042..dc42751 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -1270,8 +1270,19 @@ xfs_seek_data(
>>  	}
>>  
>>  out:
>> -	if (offset != file->f_pos)
>> +	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
>> +		error = EINVAL;
>> +		goto out_unlock;
>> +	}
>> +	if (offset > inode->i_sb->s_maxbytes) {
>> +		error = EINVAL;
>> +		goto out_unlock;
>> +	}
>> +
>> +	if (offset != file->f_pos) {
>>  		file->f_pos = offset;
>> +		file->f_version = 0;
>> +	}
> 
> Hi Jeff, why are you copy-n-pasting this code from lseek_execute()
> rather than making lseek_execute() an exported function and calling
> that directly? 

I found other file systems are implemented in this way.  But I should
consider how to make it better rather than following others in this
situation.

> 
>>  
>>  out_unlock:
>>  	xfs_iunlock_map_shared(ip, lock);
>> @@ -1372,6 +1383,15 @@ xfs_seek_hole(
>>  	}
>>  
>>  out:
>> +	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
>> +		error = EINVAL;
>> +		goto out_unlock;
>> +	}
>> +	if (offset > inode->i_sb->s_maxbytes) {
>> +		error = EINVAL;
>> +		goto out_unlock;
>> +	}
> 
> These checks belong after we truncated offset to isize, don't they?

They do.

> And that would make both of these functions simply require a call to
> lseek_execute(), yes?

Yep, I'll post a patch set to export this call and propagate it to other
file systems as well.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
