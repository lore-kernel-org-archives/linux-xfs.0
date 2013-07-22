Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A5897F37
	for <xfs@oss.sgi.com>; Mon, 22 Jul 2013 09:40:49 -0500 (CDT)
Message-ID: <51ED4471.7050708@sgi.com>
Date: Mon, 22 Jul 2013 09:40:49 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: di_flushiter considered harmful
References: <1374488304-13044-1-git-send-email-david@fromorbit.com>
	<20130722110732.GA365@x4>
In-Reply-To: <20130722110732.GA365@x4>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On 07/22/13 06:07, Markus Trippelsdorf wrote:
> On 2013.07.22 at 20:18 +1000, Dave Chinner wrote:
>> From: Dave Chinner<dchinner@redhat.com>
>>
>> When we made all inode updates transactional, we no longer needed
>> the log recovery detection for inodes being newer on disk than the
>> transaction being replayed - it was redundant as replay of the log
>> would always result in the latest version of the inode woul dbe on
>> disk. It was redundant, but left in place because it wasn't
>> considered to be a problem.
>>
>> However, with the new "don't read inodes on create" optimisation,
>> flushiter has come back to bite us. Essentially, the optimisation
>> made always initialises flushiter to zero in the create transaction,
>> and so if we then crash and run recovery and the inode already on
>> disk has a non-zero flushiter it will skip recovery of that inode.
>> As a result, log recovery does the wrong thing and we end up with a
>> corrupt filesystem.
>>
>> Because we have to support old kernel to new kernl upgrades, we
>> can't just get rid of the flushiter support in log recovery as we
>> might be upgrading from a kernel that doesn't have fully transaction
>> inode updates.  Unfortunately, for v4 superblocks there is no way to
>> guarantee that log recovery knows about this fact.
>>
>> We cannot add a new inode format flag to say it's a "special inode
>> create" because it won't be understood by older kernels and so
>> recovery could do the wrong thing on downgrade. We cannot specially
>> detect the combination of zero mode/non-zero flushiter on disk to
>> non-zero mode, zero flushiter in the log item during recovery
>> because wrapping of the flushiter can result in false detection.
>>
>> Hence that makes this "don't use flushiter" optimisation limited to
>> a disk format that guarantees that we don't need it. And that means
>> the only fix here is to limit the "no read IO on create"
>> optimisation to version 5 superblocks....
>
> I think your patch misses the following part:
>

Hi Markus.

Dave's patch is limited to the new v5 (crc) superblock. The constraints 
that has to be dealt with are in the commit message as to why it is 
limited to the new v5 superblock.

Going back to your 07/10/2013 message, your filesystem is:

/dev/root on / type xfs  (rw,relatime,attr2,inode64,logbsize=256k,noquota)

or the non-crc v4 superblock with inode 2 that is probably why it is 
still failing for you.

It seems to me that since we cannot fix this for inode 1/2, then besides 
this patch we have to revert patch cca9f93a52d and make it inode 3+ / 
superblock 5+ (crc) dependent.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
