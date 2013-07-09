Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 387FD7F4E
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 11:26:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D4768F8066
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 09:26:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JLNQeYnvENNlsTam for <xfs@oss.sgi.com>;
	Tue, 09 Jul 2013 09:26:21 -0700 (PDT)
Message-ID: <51DC39AC.4090003@sandeen.net>
Date: Tue, 09 Jul 2013 11:26:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: check on-disk (not incore) btree root size in dfrag.c
References: <4F7225BA.40200@redhat.com> <51C227ED.5010108@sandeen.net>
	<20130620170929.GY20932@sgi.com>
In-Reply-To: <20130620170929.GY20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 6/20/13 12:09 PM, Ben Myers wrote:
> On Wed, Jun 19, 2013 at 04:51:41PM -0500, Eric Sandeen wrote:
>> On 3/27/12 3:40 PM, Eric Sandeen wrote:
>>> xfs_swap_extents_check_format() contains checks to make sure that
>>> original and the temporary files during defrag are compatible;
>>> Gabriel VLASIU ran into a case where xfs_fsr returned EINVAL
>>> because the tests found the btree root to be of size 120,
>>> while the fork offset was only 104; IOW, they overlapped.
>>>
>>> However, this is just due to an error in the
>>> xfs_swap_extents_check_format() tests, because it is checking
>>> the in-memory btree root size against the on-disk fork offset.
>>> We should be checking the on-disk sizes in both cases.
>>>
>>> This patch adds a new macro to calculate this size, and uses
>>> it in the tests.
>>>
>>> With this change, the filesystem image provided by Gabriel
>>> allows for proper file degragmentation.
>>
>> I think this and the followup patch 2/1 got lost.
>>
>> Ben, any idea?
> 
> Yeah.  Sorry Eric.

I see the first patch is now merged.  Can you please also merge the
2nd patch?  It is also reviewed already.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
