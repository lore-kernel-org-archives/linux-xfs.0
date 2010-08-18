Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IEQD00116890 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 09:26:13 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0836B14D4EAE
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 07:36:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AqDUF2CSjC1pLOVs for
	<xfs@oss.sgi.com>; Wed, 18 Aug 2010 07:36:02 -0700 (PDT)
Message-ID: <4C6BED98.10203@redhat.com>
Date: Wed, 18 Aug 2010 09:26:32 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 241: run parallel dbench
References: <4C6AE57D.7090807@redhat.com> <20100818114507.GS10429@dastard>
In-Reply-To: <20100818114507.GS10429@dastard>
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
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Tue, Aug 17, 2010 at 02:39:41PM -0500, Eric Sandeen wrote:
>> ext4 was corrupting inode table bitmaps due to a mishmash of
>> atomic & nonatomic bitops.  This got broken twice and fixed
>> twice; let's add a test.
>>
>> On a 4-way box this reliably ends up with a corrupted filesystem
>> if we get it wrong (upstream as of 2.6.35 at least is fine again)
>>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Looks good, except it's missing a 241.out file for the golden
> output.

grr "guilt add" :)

Thanks, will add that to the commit.

-Eric
 
> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
