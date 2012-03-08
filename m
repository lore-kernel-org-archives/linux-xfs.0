Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28MT89Q089748 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 16:29:09 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id CfisqJBUHCFFY0Hu for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 14:29:08 -0800 (PST)
Message-ID: <4F5932B1.5040208@sandeen.net>
Date: Thu, 08 Mar 2012 16:29:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: before test execution, print test number
	to syslog
References: <1330968369-31779-1-git-send-email-sbehrens@giantdisaster.de>
	<20120305213512.GC3592@dastard>
In-Reply-To: <20120305213512.GC3592@dastard>
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
Cc: Stefan Behrens <sbehrens@giantdisaster.de>, xfs@oss.sgi.com

On 3/5/12 3:35 PM, Dave Chinner wrote:
> On Mon, Mar 05, 2012 at 06:26:09PM +0100, Stefan Behrens wrote:
>> When the xfstests are executed in a batch (like "check 001-299")
>> and produce syslog output, it is helpful to know which test was
>> causing the output. Therefore each time a test is started, a
>> syslog message is generated that contains the number of the
>> xfstest.
>>
>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> 
> Looks ok.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Thanks, I pushed this.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
