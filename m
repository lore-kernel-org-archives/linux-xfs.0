Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73JCpjA172971 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 14:12:51 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD25A531AA9
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 12:12:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AjTpBGUaiB0iN5N1 for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2011 12:12:50 -0700 (PDT)
Message-ID: <4E399DAB.3090507@redhat.com>
Date: Wed, 03 Aug 2011 14:12:43 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: skip over "rootfs" entry if mtab links to
	/proc/mounts
References: <4E399677.1010508@redhat.com>
	<20110803190216.GA31421@infradead.org>
In-Reply-To: <20110803190216.GA31421@infradead.org>
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

On 8/3/11 2:02 PM, Christoph Hellwig wrote:
> On Wed, Aug 03, 2011 at 01:41:59PM -0500, Eric Sandeen wrote:
>> This is for RH bug 727938, xfs_fsr regression for root file system
>>
>> Fedora has made /etc/mtab a symlink to /proc/mounts, but when
>> we issue "xfs_fsr /" and fsr's getmntany() goes looking for
>> the "/" entry, the first one it finds is
>>
>> rootfs / rootfs rw 0 0
>>
>> it says no way, that's a rootfs filesystem type, not xfs!
>> And it never finds this later:
>>
>> /dev/sda2 / xfs rw,relatime,attr2,noquota 0 0
>>
>> This patch to skip over the rootfs entry seems to fix it.
> 
> I don't like this.  rootfs is the symptom, but the underlying problem
> is that in Linux we're perfectly fine to have multiple filesystems
> mounted on a single mountpoint, and the getmntany can't deal with it.

But in this case, xfs_fsr has been told to "defrag mountpoint /bar"
and if /dev/X is mounted on /foo, /bar, and /baz, it'll do the
right thing, won't it? 

oh wait I'm thinking about multiple mountpoints for the same device,
not multiple devices on the same mountpoint.

Ok, duh, you're right of course.

Well, this patch certainly makes the current situation no worse,
and fixes the immediate problem with /proc/mounts... and we really
never do want to try to do something with "rootfs" do we?

Could the other behavioral change be done as a separate patch?

Well, maybe there's no point, what do you think?

> I think the right fix is to simply remove the break from the loop,
> and thus let a second match for our fs override the first.  This relies
> on getmntent returning entries in the order they were mounted, but
> without that I can't think of a reliable way for getmntent to work
> with the multiple mounts in Linux.

fair enough.

> It would also be nice to have a testcase for this behaviour in xfstests,
> creating two loop devices with different backing files and mounting them
> at the same mount point.

easy enough :)

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
