Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8F2AE7F60
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 17:20:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B38A8F8039
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 15:20:49 -0700 (PDT)
Received: from mail-ig0-f178.google.com (mail-ig0-f178.google.com
	[209.85.213.178]) by cuda.sgi.com with ESMTP id
	YQsLHUIDE2jRLbbB (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 15:20:48 -0700 (PDT)
Received: by igbqf9 with SMTP id qf9so3950489igb.1
	for <xfs@oss.sgi.com>; Thu, 09 Apr 2015 15:20:40 -0700 (PDT)
Message-ID: <5526FB2A.8060704@gmail.com>
Date: Thu, 09 Apr 2015 18:20:26 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: interesting MD-xfs bug
References: <5526E8E9.3030805@gmail.com> <20150409221846.GG13731@dastard>
In-Reply-To: <20150409221846.GG13731@dastard>
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
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs <xfs@oss.sgi.com>



On 04/09/2015 06:18 PM, Dave Chinner wrote:
> On Thu, Apr 09, 2015 at 05:02:33PM -0400, Joe Landman wrote:
>> If I build an MD raid0 with a non power of 2 chunk size, it appears
>> that I can mkfs.xfs a file system, but it doesn't show up in blkid
>> and is not mountable.  Yet, using a power of 2 chunk size, this does
>> work correctly.   This is kernel 3.18.9.
>>

[...]

> That looks more like a blkid or udev problem. try using blkid -p so
> that it doesn't look up the cache but directly probes devices for
> the signatures. strace might tell you a bit more, too. And if the
> filesystem mounts, then it definitely isn't an XFS problem ;)

Thats the thing, it didn't mount, even when I used the device name 
directly.

Good point on stracing though.  I'll do that tomorrow and report back.   
Thanks!

Joe

>
> Cheers,
>
> Dave.

-- 
Joe Landman
e: joe.landman@gmail.com
t: @sijoe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
