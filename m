Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4761E7CA3
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 12:40:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 294588F8033
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 10:40:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zV6HT6m5YAg3hO7O (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jan 2016 10:40:02 -0800 (PST)
Subject: Re: [PATCH 2/7] quota: add new quotactl Q_XGETNEXTQUOTA
References: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
	<1453487136-12681-3-git-send-email-sandeen@redhat.com>
	<20160126125710.GA23820@quack.suse.cz> <56A78A09.5080307@redhat.com>
	<20160126175205.GA29388@quack.suse.cz>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <56A7BD7F.6010802@redhat.com>
Date: Tue, 26 Jan 2016 12:39:59 -0600
MIME-Version: 1.0
In-Reply-To: <20160126175205.GA29388@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 1/26/16 11:52 AM, Jan Kara wrote:

> Yeah, so VFS quotas use ESRCH when quota for particular fs is not enabled
> (while ENOENT means device you passed in doesn't exist).

And what does it return for "that ID has no quota?"  Anything?  Maybe not,
see below?

> So probably a
> solution that keeps XFS and VFS interfaces most selfconsistent is to return
> ENOENT from Q_XGETNEXTQUOTA and ESRCH from Q_GETNEXTQUOTA. I'll update your
> patches in this sense in the comments and changelogs. But XFS patches
> (which I don't carry) need updating the actual code...

Actually, ok, now I'm a little more confused.

Today, Q_XGETQUOTA and Q_GETQUOTA will both return -ENOENT on XFS if a
quota doesn't exist for that ID:

quotactl(Q_GETQUOTA|USRQUOTA, "/dev/sdb2", 123456789, 0x7ffdf2edbc80) = -1 ENOENT (No such file or directory)
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/sdb2", 123456789, 0x7ffdf2edbc10) = -1 ENOENT (No such file or directory)

It seems like the *NEXT* variants (on xfs at least?) may as well continue to do the same...

But on ext4, I see 0 returned for a nonexistent quota:

quotactl(Q_GETQUOTA|USRQUOTA, "/dev/sdb1", 123456789, {bhardlimit=0, bsoftlimit=0, curspace=0, ihardlimit=0, isoftlimit=0, curinodes=0, ...}) = 0
quotactl(Q_XGETQUOTA|USRQUOTA, "/dev/sdb1", 123456789, {version=1, flags=XFS_USER_QUOTA, fieldmask=0, id=123456789, blk_hardlimit=0, blk_softlimit=0, ino_hardlimit=0, ino_softlimit=0, bcount=0, icount=0, ...}) = 0

So the difference doesn't seem to be XGETQUOTA vs GETQUOTA, rather it's the filesystem handling the call?

Still, we do need a way to pass back "No more quotas to find" from Q_[X]GETNEXTQUOTA; XFS will do -ENOENT, but if -ENOENT and -ESRCH already have specific meanings on non-xfs filesystems, I'm not sure where we go from there.

Sorry for my confusion.  :(

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
