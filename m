Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BG6gMq010962 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 11:06:42 -0500
Received: from mail.mnsu.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D084E1BD069
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 09:06:37 -0700 (PDT)
Received: from mail.mnsu.edu (Mail.MNSU.EDU [134.29.1.12]) by cuda.sgi.com
	with ESMTP id iKblBF9UMCLO1cJS for <xfs@oss.sgi.com>;
	Tue, 11 Oct 2011 09:06:37 -0700 (PDT)
Message-ID: <4E946980.4060702@mnsu.edu>
Date: Tue, 11 Oct 2011 11:06:24 -0500
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
MIME-Version: 1.0
Subject: Re: TRIM on XFS
References: <201110071352.20135@zmi.at> <20111007233450.GK3159@dastard>
	<201110100829.45823@zmi.at>
	<CAGpXXZJs8kjZaSp248rA+-d=gpwWe=oK0xtUUirv+zgE3Vq3kA@mail.gmail.com>
	<4E936BFB.5060907@mnsu.edu> <20111011020552.GY3159@dastard>
In-Reply-To: <20111011020552.GY3159@dastard>
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

Dave,

Thank you.  I suspected this may be the case.  It is awfully nice to 
have a definitive answer though.  It is especially nice to have a way to 
determine if it is possible.  Thank you!

I've created a an XFS Wiki page for this info:
     http://xfs.org/index.php/FITRIM/discard

-- 
Jeffrey Hundstad

On 10/10/2011 09:05 PM, Dave Chinner wrote:
> On Mon, Oct 10, 2011 at 05:04:43PM -0500, Jeffrey Hundstad wrote:
>> On 10/10/2011 03:28 PM, Greg Freemyer wrote:
>>> fitrim is the batch mode.
>>>
>>> To enable realtime discard, add --discard to your mount options.
>>>
>>> Documented athttp://lxr.linux.no/#linux+v3.0.4/Documentation/filesystems/xfs.txt
>>>
>>> To invoke batch mode, simply use fstrim from user space.
>> Hello,
>>
>> I'm also trying to use FITRIM on a simple XFS partition on a
>> spinning magnetic hard drive (remember those).  I haven't had much
>> luck.  I'm doing this just to get used to the commands when using
>> this against a thinly provisioned disk.  I have no idea if this
>> should work in this configuration.
>>
>> On a Debian system with Linux 3.0.0-2-amd64 when I issue:
>> # fstrim /
>>
>> I receive:
>> fstrim: /: FITRIM ioctl failed: Operation not supported
>>
>> With an strace this looks like:
>> open("/", O_RDONLY)                     = 3
>> ioctl(3, 0xc0185879, 0x7fff4ea851b0)    = -1 EOPNOTSUPP (Operation
>> not supported)
> It means the block device underneath the filesystem doesn't support
> the TRIM operation. Check /sys/block/<dev>/queue/discard_max_bytes -
> if the value is zero then your device doesn't support discard
> operations.
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
