Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAUG6UG4189590 for <xfs@oss.sgi.com>; Fri, 30 Nov 2012 10:06:30 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IkkEHMDVOZvaX32c for
	<xfs@oss.sgi.com>; Fri, 30 Nov 2012 08:08:49 -0800 (PST)
Message-ID: <50B8DA0E.4000605@redhat.com>
Date: Fri, 30 Nov 2012 10:08:46 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fsck scratch device if it got used
References: <50B7B0AB.6040406@redhat.com> <20121130160616.GD5667@infradead.org>
In-Reply-To: <20121130160616.GD5667@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 11/30/12 10:06 AM, Christoph Hellwig wrote:
> On Thu, Nov 29, 2012 at 12:59:55PM -0600, Eric Sandeen wrote:
>> This will cause the $SCRATCH_DEV to be fscked if it
>> was used in the prior test.  Without this I don't
>> think it gets done unless specifically requested
>> by the test.
> 
> This one looks good.

Hm now that I think of it perhaps I should remove the explicit _check_scratch-es if they happen at the end of the run, just to try to speed things up.

>> Also recreate lost+found/ in one test so that e2fsck
>> doesn't complain.
> 
> This one I can't make any sense of.  Care to send it separately with a
> good explanation?
> 

Ok, sure.

Basically, test does an rm -rf of the scrach mnt, but e2fsck thinks that a missing lost+found/ is cause for complaint and a failure exit code, which then stops the tests :(

(hum, now that I think about it, maybe a broken scratch device shouldn't stop the test series, but should just log a test failure?  What do you think?)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
