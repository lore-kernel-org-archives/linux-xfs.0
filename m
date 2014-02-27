Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 51AAD29DF7
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 08:08:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 26D4A30408A
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 06:08:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QsgFUKfEOv2Shxmn for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 06:08:46 -0800 (PST)
Message-ID: <530F46ED.9010006@sandeen.net>
Date: Thu, 27 Feb 2014 08:08:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: clean up xfs_set_maxicount & use in growfs
References: <530C29C7.90001@redhat.com> <20140226021114.GA26022@infradead.org>
	<530E3282.7000703@sandeen.net> <20140227071154.GK29907@dastard>
In-Reply-To: <20140227071154.GK29907@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 2/27/14, 1:11 AM, Dave Chinner wrote:
> On Wed, Feb 26, 2014 at 12:29:22PM -0600, Eric Sandeen wrote:
>> On 2/25/14, 8:11 PM, Christoph Hellwig wrote:
>>> On Mon, Feb 24, 2014 at 11:27:35PM -0600, Eric Sandeen wrote:
>>>> xfs_set_maxicount() overflowed fairly easily for large filesystems
>>>> and large maxicount; we started out by multiplying dblocks by
>>>> the percentage, *then* dividing by 100, and never checked for
>>>> an overflow.  The calculations were also, IMHO, a little hard
>>>> to follow.
>>>
>>> Would be useful to get this test case into xfstests..
>>
>> Ok so I was going on Dave's assertion about that.  ;)
>>
>> To overflow, we'd need dblocks * 100 to be > 2^64-1:
>>
>> so dblocks would need to be > (2^64-1)/100
>>
>> for 4k blocks that's 655 exabytes.  Maybe not so possible after all ;)
> 
> Until the block count is corrupted by fsfuzzer? ;)
> 
>> Dave, maybe just removing the open-code is enough here.
> 
> Sure, but I still like the conversion to use mult_frac....

Ok, I do too.  Just a bit resistant to fixing what ain't
broke.  I'll see if I can write up a test to be sure we're
doing sane things statfs/growfs with the change.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
