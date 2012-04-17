Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H5A5Zu018728 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 00:10:05 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id BpNs33rL5L2slZkc
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Apr 2012 22:10:04 -0700 (PDT)
Received: by pbcuo1 with SMTP id uo1so8273172pbc.26
	for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 22:10:03 -0700 (PDT)
Subject: Re: [PATCH 00/19 v5] Fix filesystem freezing deadlocks
Mime-Version: 1.0 (Apple Message framework v1084)
From: Andreas Dilger <adilger@whamcloud.com>
In-Reply-To: <20120417004329.GE6734@dastard>
Date: Mon, 16 Apr 2012 22:10:50 -0700
Message-Id: <141752A3-EDF1-4ABC-919D-4170B0455948@whamcloud.com>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
	<C9A0E2F0-ED57-40D6-9F75-5D72D45D21F0@dilger.ca>
	<20120417004329.GE6734@dastard>
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
Cc: Jan Kara <jack@suse.cz>, "J. Bruce Fields" <bfields@fieldses.org>, ocfs2-devel@oss.oracle.com, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-nilfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, cluster-devel@redhat.com, Anton Altaparmakov <anton@tuxera.com>, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Joel Becker <jlbec@evilplan.org>, dchinner@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, Chris Mason <chris.mason@oracle.com>, linux-nfs@vger.kernel.org, Alex Elder <elder@kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, linux-btrfs@vger.kernel.org

On 2012-04-16, at 5:43 PM, Dave Chinner wrote:
> On Mon, Apr 16, 2012 at 03:02:50PM -0700, Andreas Dilger wrote:
>> On 2012-04-16, at 9:13 AM, Jan Kara wrote:
>>> Another potential contention point might be patch 19. In that patch
>>> we make freeze_super() refuse to freeze the filesystem when there
>>> are open but unlinked files which may be impractical in some cases.
>>> The main reason for this is the problem with handling of file deletion from fput() called with mmap_sem held (e.g. from munmap(2)),
>>> and then there's the fact that we cannot really force such filesystem
>>> into a consistent state... But if people think that freezing with
>>> open but unlinked files should happen, then I have some possible
>>> solutions in mind (maybe as a separate patchset since this is
>>> large enough).
>> 
>> Looking at a desktop system, I think it is very typical that there
>> are open-unlinked files present, so I don't know if this is really
>> an acceptable solution.  It isn't clear from your comments whether
>> this is a blanket refusal for all open-unlinked files, or only in
>> some particular cases...
> 
> Unlinked-but-open files are the reason that XFS dirties the log
> after the freeze process is complete. This ensures that if the
> system crashes while the filesystem is frozen then log recovery
> during the next mount will process the unlinked (orphaned) inodes
> and free the correctly. i.e. you can still freeze a filesystem with
> inodes in this state successfully and have everythign behave as
> you'd expect.
> 
> I'm not sure how other filesystems handle this problem, but perhaps
> pushing this check down into filesystem specific code or adding a
> superblock feature flag might be a way to allow filesystems to
> handle this case in the way they think is best...

The ext3/4 code has long been able to handle open-unlinked files
properly after a crash (they are put into a singly-linked list from
the superblock on disk that is processed after journal recovery).

The issue here is that blocking freeze from succeeding with open-
unlinked files is an unreasonable assumption of this patch, and
I don't think it is acceptable to land this patchset (which IMHO
would prevent nearly every Gnome system from freezing unless these
apps have changed their behaviour in more recent releases).

Like you suggest, filesystems that handle this correctly should be
able to flag or otherwise indicate that this is OK, and allow the
freeze to continue.  For other filesystems that do not handle
open-unlinked file consistency during a filesystem freeze/snapshot
whether this should even be considered a new case, or is something
that has existed for ages already.

The other question is whether this is still a problem even for
filesystems handling the consistency issue, but from Jan's comment
above there is a new locking issue related to mmap_sem being added?

Cheers, Andreas
--
Andreas Dilger                       Whamcloud, Inc.
Principal Lustre Engineer            http://www.whamcloud.com/




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
