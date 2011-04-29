Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3T1pLwu033970 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 20:51:21 -0500
Received: from nospam1.slac.stanford.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 374411A3DC13
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 18:54:54 -0700 (PDT)
Received: from nospam1.slac.stanford.edu (nospam1.slac.stanford.edu
	[134.79.18.81]) by cuda.sgi.com with ESMTP id MzYmNOGpToSGEJ6B
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 18:54:54 -0700 (PDT)
Message-ID: <4DBA1A60.7050400@slac.stanford.edu>
Date: Thu, 28 Apr 2011 18:54:40 -0700
From: "Ling C. Ho" <ling@slac.stanford.edu>
MIME-Version: 1.0
Subject: Re: convert External Log to Internal Log
References: <4DB9FC37.8080904@slac.stanford.edu>
	<20110429003231.GS12436@dastard>
In-Reply-To: <20110429003231.GS12436@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Ok. I will go the safe route, recreate the file system, and restore the 
data.

Thanks,
...
ling

On 4/28/11 5:32 PM, Dave Chinner wrote:
> On Thu, Apr 28, 2011 at 04:45:59PM -0700, Ling Ho wrote:
>> Is there any way to convert from external log to internal log on RHEL 5.6?
> Try dump-mkfs-restore - there's no simple way of converting an
> existing filesystem.  At least, not without highly dangerous offline
> manual xfs_db surgery that could corrupt the fs....
>
>> I tried running xfs_growfs -i but it complains saying
>>
>> xfs_growfs: failed to access external log for /dev/sdc
>>
>> and the man page says -i is not implemented. I am using xfsprogs
>> version 3.1.5.
> Yup, not implemented and as such not supported.
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
