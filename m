Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A41717F37
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2014 20:04:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7F4B38F8040
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2014 18:04:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fJwsNMReQI2QNni7 for <xfs@oss.sgi.com>;
	Thu, 04 Sep 2014 18:04:51 -0700 (PDT)
Message-ID: <54090C33.2060102@sandeen.net>
Date: Thu, 04 Sep 2014 20:04:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsrestore: use utimensat() to provide atime/mtime with
	ns resolution
References: <1409848708-42666-1-git-send-email-bfoster@redhat.com>
	<20140905004501.GU20518@dastard>
In-Reply-To: <20140905004501.GU20518@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 9/4/14, 7:45 PM, Dave Chinner wrote:
> On Thu, Sep 04, 2014 at 12:38:28PM -0400, Brian Foster wrote:
>> xfsdump encodes and stores the full atime and mtime for each file with
>> nanosecond resolution. xfsrestore uses utime() to set the times of each
>> file that is restored. The latter supports resolution of 1 second, thus
>> sub-second timestamp data is lost on restore.
>
> That doesn't seem like a big deal. What sort of problems does this
> actually cause?
>
> FYI, many linux filesystems only have second resolution timestamps
> and hence applications can't rely on sub-second timestamp resolution
> to actually mean anything useful....

But why not restore the same resolution as is actually stored in the dump?
Throwing it away seems odd, and restoring it looks easy enough.

In any case, there was a user who noticed & complained.  Seems like a
very reasonable thing to fix, to me.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
