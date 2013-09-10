Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C63097F53
	for <xfs@oss.sgi.com>; Tue, 10 Sep 2013 17:29:50 -0500 (CDT)
Message-ID: <522F9D5D.1090005@sgi.com>
Date: Tue, 10 Sep 2013 17:29:49 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: change the immutable in xfs_open_by_handle
References: <20130910184724.726933044@sgi.com> <20130910212002.GB19103@dastard>
In-Reply-To: <20130910212002.GB19103@dastard>
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
Cc: Greg Banks <gbanks@sgi.com>, xfs@oss.sgi.com

On 09/10/13 16:20, Dave Chinner wrote:
> On Tue, Sep 10, 2013 at 01:47:20PM -0500, Mark Tinguely wrote:
>> This patch allows clients like DMF to modify an immutable file
>> without changing the immutable capability on the file, which
>> would expose the file to change.
>>
>> This patch is restricted to holders of the CAP_LINUX_IMMUTABLE,
>> so no addition security risk has been introduced.
>>
>> Signed-off-by: Greg Banks <gbanks@sgi.com>
>> Singed-off-by: Mark Tinguely <tinguely@sgi.com>
>> ---
>>   fs/xfs/xfs_ioctl.c |    4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> Index: b/fs/xfs/xfs_ioctl.c
>> ===================================================================
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -237,7 +237,9 @@ xfs_open_by_handle(
>>   		goto out_dput;
>>   	}
>>
>> -	if ((fmode & FMODE_WRITE) && IS_IMMUTABLE(inode)) {
>> +	if ((permflag & FMODE_WRITE)&&
>
> Why the conversion from fmode to permflag? At minimum, this will
> probably throw sparse warnings for comparing a FMODE_* flag against
> a variable that is not a fmode_t....
>
> Cheers,
>
> Dave.

Yes, my mistake - a case of posting a Linux 3.0.X based patch.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
