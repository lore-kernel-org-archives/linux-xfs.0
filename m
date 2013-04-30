Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0D0FD7F50
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 02:38:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1DCBAC002
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 00:38:36 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AduImKgZcCzNDmnR for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 00:38:34 -0700 (PDT)
Date: Tue, 30 Apr 2013 17:38:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
Message-ID: <20130430073833.GI23072@dastard>
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Apr 26, 2013 at 03:13:59PM -0400, Josef Bacik wrote:
> This test sets up a dm flakey target and then runs my fsync tester I've been
> using to verify btrfs's fsync() is working properly.  It will create a dm flakey
> device, mount it, run my test, make the flakey device start dropping writes, and
> then unmount the fs.  Then we mount it back up and make sure the md5sums match
> and then run fsck on the device to make sure we got a consistent fs.  I used the
> output from a run on BTRFS since it's the only one that passes this test
> properly.  I verified each test manually to make sure they were in fact valid
> files.  XFS and Ext4 both fail this test in one way or another.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V2->V3:
> -encorporate all of Dave Chinners feedback
> -expand the testing to run the tests with normal dmsetup suspend and with
>  --nolockfs

I haven't tested the new version yet, but all the changes I asked
for look good now.

Acked-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
