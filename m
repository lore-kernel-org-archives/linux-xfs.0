Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1A7587F89
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 19:16:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9F144AC004
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 17:16:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AVyyIET4Xz4FcFYQ for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 17:16:05 -0800 (PST)
Message-ID: <5282D2D3.3040601@sandeen.net>
Date: Tue, 12 Nov 2013 19:16:03 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 0/5] xfs: more patches for 3.13
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>	<20131106230133.GX1935@sgi.com>
	<20131107015706.GM6188@dastard>
In-Reply-To: <20131107015706.GM6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 11/6/13, 7:57 PM, Dave Chinner wrote:
> On Wed, Nov 06, 2013 at 05:01:33PM -0600, Ben Myers wrote:
>> On Fri, Nov 01, 2013 at 03:27:15PM +1100, Dave Chinner wrote:
>>> Hi folks,
>>>
>>> The following series follows up the recently committed series of
>>> patches for 3.13. The first two patches are the remaining
>>> uncommitted patches from the previous series.
>>>
>>> The next two patches are tracing patches, one for AIL manipulations
>>> and the other for AGF and AGI read operations. Both of these were
>>> written during recent debugging sessions, and both proved useful so
>>> should be added to the menagerie of tracepoints we already have
>>> avaialble.
>>>
>>> The final patch is the increasing of the inode cluster size for v5
>>> filesystems. I'd like to get this into v5 filesystems for 3.13 so we
>>> get wider exposure of it ASAP so we have more data available to be
>>> able to make informed decisions about how to bring this back to v4
>>> filesystems in a safe and controlled manner.
>>
>> Applied 3 and 4.  I still don't understand why the locking on patch 2 is
>> correct.  Seems like the readers of i_version hold different locks than we do
>> when we log the inode.  Maybe Christoph can help me with that.
> 
> Readers don't need to hold a spinlock, and many don't. The spinlock
> is only there to prevent concurrent updates from "losing" an update
> due to races.  All modifications to XFS inodes occur via
> transactions, inodes are locked exclusively in transactions and
> hence we will never lose i_version updates due to races. Hence we
> don't need the spinlock during the update, either.

I'm not completely convinced that readers don't need to.  What happens when
we read in the middle of an update?  Especially when a 32-bit box reads the
64-bit value in the middle of an update?

NFS is the only reader we care about (right?)

I see a several paths to i_version reads in nfs; so far I'm finding locked reads:

<2 callers of nfs_refresh_inode_locked>
	spin_lock(&inode->i_lock);
	nfs_refresh_inode_locked
		nfs_update_inode
			nfs_wcc_update_inode
				(... && inode->i_version == fattr->pre_change_attr)
		...
		if (inode->i_version != fattr->change_attr) {
		...
		nfs_check_inode_attributes
			(... && inode->i_version != fattr->change_attr)

---

update_changeattr
	spin_lock(&dir->i_lock);
	if (!cinfo->atomic || cinfo->before != dir->i_version)

---

nfs_post_op_update_inode_force_wcc
	 spin_lock(&inode->i_lock);
	 fattr->pre_change_attr = inode->i_version;

---

I haven't audited everything but do you have an example of an unlocked
reader (which is relevant to xfs)?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
