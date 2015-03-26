Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D50C17F50
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 16:13:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BFCAC8F8037
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 14:13:31 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KhlBjFb0UzDMFY8A for <xfs@oss.sgi.com>;
	Thu, 26 Mar 2015 14:13:29 -0700 (PDT)
Message-ID: <55147678.1020704@sandeen.net>
Date: Thu, 26 Mar 2015 16:13:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: disallow ro->rw remount on norecovery mount
References: <55146612.1070306@redhat.com> <20150326205958.GD28129@dastard>
In-Reply-To: <20150326205958.GD28129@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 3/26/15 3:59 PM, Dave Chinner wrote:
> On Thu, Mar 26, 2015 at 03:03:30PM -0500, Eric Sandeen wrote:
>> There's a bit of a loophole in norecovery mount handling right
>> now: an initial mount must be readonly, but nothing prevents
>> a mount -o remount,rw from producing a writable, unrecovered
>> xfs filesystem.
>>
>> It might be possible to try to perform a log recovery when this
>> is requested, but I'm not sure it's worth the effort.  For now,
>> simply disallow this sort of transition.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> Good catch.
> 
> Shouldn't this also check for a ro block device, and disallow the
> rw remount if the block dev is ro?

Seems to be covered already:

# blockdev --setro /dev/sdb1 
# mount /dev/sdb1 /mnt/test
mount: block device /dev/sdb1 is write-protected, mounting read-only
# grep sdb1 /proc/mounts
/dev/sdb1 /mnt/test xfs ro,seclabel,relatime,attr2,inode64,noquota 0 0

# mount -o remount,rw /mnt/test
mount: cannot remount block device /dev/sdb1 read-write, is write-protected

from strace:

mount("/dev/sdb1", "/mnt/test", 0x7ff230271d90, MS_MGC_VAL|MS_REMOUNT, NULL) = -1 EACCES (Permission denied)

Ah, from fs/super.c:

do_remount_sb()

...

#ifdef CONFIG_BLOCK
        if (!(flags & MS_RDONLY) && bdev_read_only(sb->s_bdev))
                return -EACCES;
#endif

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
