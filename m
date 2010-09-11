Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8B8OYK4192742 for <xfs@oss.sgi.com>; Sat, 11 Sep 2010 03:24:34 -0500
Received: from mail.kickstone.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD30A17D99DB
	for <xfs@oss.sgi.com>; Sat, 11 Sep 2010 01:25:19 -0700 (PDT)
Received: from mail.kickstone.com (87-194-183-70.dsl.cnl.uk.net
	[87.194.183.70]) by cuda.sgi.com with ESMTP id wlWhtltg7DplgGV2
	for <xfs@oss.sgi.com>; Sat, 11 Sep 2010 01:25:19 -0700 (PDT)
Message-ID: <4C8B3CEE.6070909@kickstone.com>
Date: Sat, 11 Sep 2010 09:25:18 +0100
From: John Lister <john.lister@kickstone.com>
MIME-Version: 1.0
Subject: Re: XFS defragmentation issue
References: <4C8A4395.5070702@kickstone.com> <4C8B27E4.2050102@kickstone.com>
	<20100911082330.GG705@dastard>
In-Reply-To: <20100911082330.GG705@dastard>
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
Cc: xfs@oss.sgi.com


On 11/09/2010 09:23, Dave Chinner wrote:
> On Sat, Sep 11, 2010 at 07:55:32AM +0100, John Lister wrote:
>>   Stan Hoeppner wrote on 9/10/2010 14:00
>>>> On 10/09/2010 15:41, John Lister wrote:
>>> Try unmounting and remounting the filesystem, and see if the various
>>> tools all report the same thing afterwards. This solved the exact same
>>> problem for me very recently, though I'm on kernel 2.6.34.1 and xfsprogs
>>> 2.9.8.
>> Cheers, that got rid of most of it, there is still a slight
>> discrepency  (50 extra fragments) which I can live with.
> xfs_db used buffered IO on the block device, which is not coherent
> with the filesystem. If you are using it on an active filesystem,
> then running "echo 1>  /proc/sys/vm/drop_caches" before you run
> xfs_db should make it read from disk at least once....
Ah, that makes more sense, I'll give it a go.

Thanks

John

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
