Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28FgLg6045353 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 09:42:21 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id KIaTfIKUbmhsaMtl for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 07:42:19 -0800 (PST)
Message-ID: <4F58D35D.7080504@sandeen.net>
Date: Thu, 08 Mar 2012 09:42:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] default to 64 bit inodes & add feature flag
References: <4F5798F9.2050809@redhat.com> <20120308013413.GL3592@dastard>
	<4F5813D8.8070305@sandeen.net> <20120308153721.GS7762@sgi.com>
In-Reply-To: <20120308153721.GS7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs-oss <xfs@oss.sgi.com>

On 3/8/12 9:37 AM, Ben Myers wrote:
> On Wed, Mar 07, 2012 at 08:05:12PM -0600, Eric Sandeen wrote:
>> On 3/7/12 7:34 PM, Dave Chinner wrote:
>>> On Wed, Mar 07, 2012 at 11:20:57AM -0600, Eric Sandeen wrote:
>>>> From: Dave Chinner <dchinner@redhat.com>
>>>>
>>>> Default to allowing 64-bit inodes on the filesystem.
>>>>
>>>> Add a feature bit to the the superblock to record whether 64 bit inodes have
>>>> been allocated on the filesystem or not. This allows us to reject mounting the
>>>> filesytem with inode32 if 64 bit inodes are present.
>>>>
>>>> Once a 64 bitinode is allocated, the inode64 superblock feature bit will be set.
>>>> Once the superblock feature bit is set, the filesystem will default to 64 bit
>>>> inodes regardless of whether inode64 is specified as a mount option.
>>>>
>>>> To ensure only 32 bit inodes are created, the inode32 mount option must be
>>>> used. If there are already 64 bit inodes as flagged by the superblock feature
>>>> bit, then the inode32 mount will be refused.
>>>>
>>>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>>>> ---
>>>>
>>>> Passing this along to revive the old discussion ... 
>>>
>>> I have no objections to do this. However, the kernel patch is just
>>> the tip of the iceberg when it comes to implementing this.
>>>
>>> Were there patches for userspace support of the feature bit? I don't
>>> recall if there were. I'm thinking that xfs_info needs to output
>>> whether this is set, which means the flag needs to be added to the
>>> xfs geometry ioctls in the kernel.
>>
>> Nope, you just put this patch out as a suggestion, and pointed out
>> that userspace needed updates too.
>>
>> If people are in agreement about this then we can proceed with the rest...
> 
> Please do.  I too have been burned by mounting a filesystem with big
> inos without the correct mount option.  This is a great idea.

So, after thinking about this (and talking on irc) some more, I'm
not convinced that a feature flag is the way to go.

If we set a feature flag, suddenly old filesystems with 64-bit
inodes will grow a new feature, and this will force a userspace
upgrade - but there is no real new feature.  This seems like a bad
idea.  My original patch (which Dave responded to with this one)
simply made inode64 default, with no feature flags.

Unless someone has a really compelling argument for the flag,
I'm thinking this is the wrong approach after all.

Perhaps I should resend the just-make-it-default patch.

Comments?

-Eric
 
> -Ben
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
