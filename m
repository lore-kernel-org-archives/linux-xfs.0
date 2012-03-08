Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28NfImx097965 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 17:41:18 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 7lKBJiNmJieL2l10 for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 15:41:17 -0800 (PST)
Message-ID: <4F59439C.5040804@sandeen.net>
Date: Thu, 08 Mar 2012 17:41:16 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] default to 64 bit inodes & add feature flag
References: <4F5798F9.2050809@redhat.com> <20120308013413.GL3592@dastard>
	<4F5813D8.8070305@sandeen.net> <20120308153721.GS7762@sgi.com>
	<4F58D35D.7080504@sandeen.net> <20120308163832.GV8545@sgi.com>
	<20120308233953.GP5091@dastard>
In-Reply-To: <20120308233953.GP5091@dastard>
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
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, Ben Myers <bpm@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On 3/8/12 5:39 PM, Dave Chinner wrote:
> On Thu, Mar 08, 2012 at 10:38:32AM -0600, Ben Myers wrote:
>> On Thu, Mar 08, 2012 at 09:42:21AM -0600, Eric Sandeen wrote:
>>> So, after thinking about this (and talking on irc) some more, I'm
>>> not convinced that a feature flag is the way to go.
>>>
>>> If we set a feature flag, suddenly old filesystems with 64-bit
>>> inodes will grow a new feature, and this will force a userspace
>>> upgrade - but there is no real new feature.  This seems like a bad
>>> idea.  My original patch (which Dave responded to with this one)
>>> simply made inode64 default, with no feature flags.
>>>
>>> Unless someone has a really compelling argument for the flag,
>>> I'm thinking this is the wrong approach after all.
>>>
>>> Perhaps I should resend the just-make-it-default patch.
>>>
>>> Comments?
>>
>> Ew!  Forcing a userspace upgrade is not desireable.  Since we would only
>> want to set the feature bit if userspace were already upgraded, and only
>> if there are 64 bit inos...  How about two bits:  one is set by mkfs and
>> checked by the kernel to see if it is ok to set the other.  ;)
>>
>> The first bit could also act as 'now its ok to default to inode64'.
> 
> Too complex, IMO. Just add an xfs_admin command to set the inode64
> feature bit. That then overrides the inode64/inode32 mount option,
> and guarantees that the user has already upgraded userspace.
> 
> i.e. the mount options are only valid if the feature bit it not set,
> and the feature bit can only be set via xfs_admin after a userspace
> upgrade. Kernels that don't understand the feature bit will refuse
> to mount, keeping in line with the current practise of requiring
> both kernel and userspace upgrades to occur in step to use new
> features....

Yep, I think that's the right path forward (had been thinking along
these lines too, today).

Thanks,
-Eric

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
