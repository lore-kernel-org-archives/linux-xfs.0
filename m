Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C0B27F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 16:40:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8BF2F304053
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 14:40:09 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id K5cF392yordEnfh7 for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2016 14:40:07 -0800 (PST)
Received: from Liberator.local (70-90-76-85-BusName-mn.hfc.comcastbusiness.net
	[70.90.76.85])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5814A60003C3
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 16:40:07 -0600 (CST)
Subject: Re: [PATCH 0/4] quota: add new quotactl Q_XGETQUOTA2
References: <568FEA2C.6080708@redhat.com>
	<20160109072600.GA21636@infradead.org>
	<20160111132617.GD6262@quack.suse.cz>
	<5693D33A.5090307@sandeen.net> <20160111162807.GK6262@quack.suse.cz>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5696D247.30809@sandeen.net>
Date: Wed, 13 Jan 2016 16:40:07 -0600
MIME-Version: 1.0
In-Reply-To: <20160111162807.GK6262@quack.suse.cz>
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
To: xfs@oss.sgi.com



On 1/11/16 10:28 AM, Jan Kara wrote:
> On Mon 11-01-16 10:07:22, Eric Sandeen wrote:
>> On 1/11/16 7:26 AM, Jan Kara wrote:
>>> On Fri 08-01-16 23:26:00, Christoph Hellwig wrote:
>>>> On Fri, Jan 08, 2016 at 10:56:12AM -0600, Eric Sandeen wrote:
>>>>> This adds a new quotactl, Q_XGETQUOTA2.
>>>>>
>>>>> Q_XGETQUOTA2 is exactly like Q_XGETQUOTA, except that it will
>>>>> return quota information for the id equal to or greater than
>>>>> the id requested.  In other words, if the specified id has
>>>>> no quota, the command will return quota information for the
>>>>> next higher id which does have a quota set.  If no higher id
>>>>> has an active quota, -ESRCH is returned.
>>>>
>>>> Please add a flags argument to Q_XGETQUOTA2, and then make the
>>>> new behavior the first flag.  Keep Q_XGETQUOTA behavior for the
>>>> flag-less case.  That way we get future etensibility for free.
>>>
>>> So this is what I wanted to suggest at first as well. What I somewhat
>>> dislike is that 'addr' must now point to something like:
>>>
>>> struct getquota_args {
>>> 	__u64 flags;
>>> 	struct fs_disk_quota ret;
>>> };
>>
>> Ok...
>>
>>> which is not as nice as passing pointer to fs_disk_quota directly. But
>>> probably still OK. So I agree with the flags idea.
>>
>> I understand that flags are for future-proofing, for possibly-not-yet-imagined
>> scenarios, but on the other hand, I wonder how many different flavors of
>> "get me a disk quota" we really expect to have?
>>
>>> Another issue is that OCFS2 and ext4 with quota in hidden inodes would need
>>> call with these capabilities as well (they have the same problem as xfs).
>>> For reporting VFS quota we use bytes for space (since some filesystems need
>>> it) and we don't need RT fields (easy so zero-fill) and warning fields
>>> (there zeros may be confusing). So we would need something like struct
>>> qc_dqblk (currently only internal) extended with ID and maybe flags field
>>> XFS is using to return quota type which can contain all the information and
>>> tell which info is actually valid as return structure.
>>
>> Hohum, yeah - I forgot that ext4 has (can have?) a hidden quota inode.
>> And I didn't know about OCFS2.
>>
>> And TBH I did the xfs-specific one because it was trivial to extend, with the
>> id already in the returned quota struct.
>>
>> So ok, it sounds like this needs a more significant overhaul at the vfs
>> quota level...
> 
> Actually, what I want from you is just an interface which is usable for VFS
> quotas as well since I'd like to avoid adding GETQUOTA2 quotactl shortly
> after XGETQUOTA2 :).

Actually, that's exactly what I thought would *need* to happen ... we already
have this weird 15-year-old split-brain quota interface, so if xfs and ext4
both need the same functionality, then we'd probably add both GETQUOTA2 and
XGETQUOTA2.  If we were doing this all from scratch, sure, but adding a new
handles-both-quota-types interface when every other operation is already split
between the two almost seems to make matters worse.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
