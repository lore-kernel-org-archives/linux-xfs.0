Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p79C3rvZ093653 for <xfs@oss.sgi.com>; Tue, 9 Aug 2011 07:03:54 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E795C835A
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2011 05:03:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nQIKZvMTdyaKkEO6 for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2011 05:03:52 -0700 (PDT)
Message-ID: <4E41221A.1030608@redhat.com>
Date: Tue, 09 Aug 2011 08:03:38 -0400
From: Josef Bacik <josef@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fsx: fix fallocate logging
References: <1312818914-9950-1-git-send-email-josef@redhat.com>
	<20110809100658.GQ3162@dastard>
In-Reply-To: <20110809100658.GQ3162@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 08/09/2011 06:06 AM, Dave Chinner wrote:
> On Mon, Aug 08, 2011 at 11:55:14AM -0400, Josef Bacik wrote:
>> I've been getting segfaults on fsx tests with btrfs because we're using the
>> wrong values for the logging with fallocate.  We were using the numbers 1,2 and
>> 3 to indicate the type of preallocate we were doing, however we use these to
>> point to an array, so obviously array[3] for a 3 element array is wrong, so fix
>> these to do 0,1, and 2.  Also spit out of we're using KEEP_SIZE in the log to
>> make it easier to figure out what's going on.  Thanks,
>>
>> Signed-off-by: Josef Bacik <josef@redhat.com>
> 
> Already fixed.
> 
> http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=commit;h=77c06202484237e26774efbd1774c251b6bef0a9
> 

Damnit, this is what I get for not git pulling first.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
