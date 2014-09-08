Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 18A697F4E
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 09:44:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0581C8F8033
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 07:44:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XHJqPa9EayFaU5y3 for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 07:44:09 -0700 (PDT)
Message-ID: <540DC0BA.1010802@sandeen.net>
Date: Mon, 08 Sep 2014 09:44:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] xfs_repair: fix dir refcount when '.' missing and
	dir is rebuilt
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>	<1410108065-18156-4-git-send-email-sandeen@redhat.com>	<20140908134524.GC52419@bfoster.bfoster>
	<20140908142529.GD52419@bfoster.bfoster>
In-Reply-To: <20140908142529.GD52419@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On 9/8/14 9:25 AM, Brian Foster wrote:
> On Mon, Sep 08, 2014 at 09:45:25AM -0400, Brian Foster wrote:
>> On Sun, Sep 07, 2014 at 11:41:03AM -0500, Eric Sandeen wrote:
>>> In phase 6's longform_dir2_entry_check, if we never
>>> find a '.' entry we never add a reference to that entry;
>>> if we subsequently rebuild it, '.' gets added, but
>>> no ref to it is ever made.  This leads to Phase 7 doing
>>> i.e.:
>>>
>>>    Phase 7 - verify and correct link counts...
>>>    resetting inode 5184 nlinks from 2 to 1
>>>
>>> and the next run will do:
>>>
>>>    Phase 7 - verify and correct link counts...
>>>    resetting inode 5184 nlinks from 1 to 2
>>>
>>> So if '.' was never found, but the directory got
>>> rebuilt, manually add the ref for it.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>   repair/phase6.c |    6 ++++++
>>>   1 files changed, 6 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/repair/phase6.c b/repair/phase6.c
>>> index f13069f..cc36a9c 100644
>>> --- a/repair/phase6.c
>>> +++ b/repair/phase6.c
>>> @@ -2288,6 +2288,12 @@ out_fix:
>>>   			if (bplist[i])
>>>   				libxfs_putbuf(bplist[i]);
>>>   		longform_dir2_rebuild(mp, ino, ip, irec, ino_offset, hashtab);
>>> +		/*
>>> +		 * If we didn't find a dot, we never added a ref for it;
>>> +		 * it's there now after the rebuild, so mark it as reached.
>>> +		 */
>>> +		if (*need_dot)
>>> +			add_inode_ref(irec, ino_offset);
>>
>> So if I follow this correctly, we iterate through the dir, add each name
>> to the hashtable and handle the inode reference count in the first
>> longform_dir2_entry_check() loop. If something is wrong, we call
>> longform_dir2_rebuild() to rebuild the dir from the hashtable of
>> names/inodes. We may or may not have added a reference for dot at that
>> point, and need_dot is set appropriately.
>>
>> This seems Ok, but where is the dot entry actually added? Hmm, I see
>> that we handle dot in the longform_dir2_rebuild() loop by just skipping
>> over it...
>>
>
> It looks like this happens in process_dir_inode() after this whole
> check/rebuild sequence, directory format permitting. There's also an
> add_inode_ref() there. Perhaps the bug here is that we clear need_dot
> when we shouldn't..?

If we do that, the first run says:

bad hash table for directory inode 5184 (no data entry): rebuilding
rebuilding directory inode 5184
creating missing "." entry in dir ino 5184

and then the 2nd run says:

multiple . entries in directory inode 5184: clearing entry

so, no.  ;)

The issue is that add_inode_ref() is keeping track (in repair)
of reached paths to the inode, in counted_nlinks.

If we didn't find '.' originally, we didn't add that ref.

When we do:


longform_dir2_rebuild
	xfs_dir_init()  // creates shortform
	<loop over names>
		xfs_dir_createname
			xfs_dir2_sf_to_block when it's big enough
				add '.' entry

and then we've added the '.' but haven't added the reference repair needs
internally.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
