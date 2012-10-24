Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9ON2Wmj060380 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 18:02:32 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ycxv3ETwN6mlFDM4 for
	<xfs@oss.sgi.com>; Wed, 24 Oct 2012 16:04:17 -0700 (PDT)
Message-ID: <50887389.5020102@redhat.com>
Date: Wed, 24 Oct 2012 19:02:33 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 08/10] xfs: add quota id filtering to eofblocks scan
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-9-git-send-email-bfoster@redhat.com>
	<20121023014222.GL4291@dastard> <508814F2.3060409@redhat.com>
	<20121024194124.GW4291@dastard>
In-Reply-To: <20121024194124.GW4291@dastard>
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
Cc: xfs@oss.sgi.com

On 10/24/2012 03:41 PM, Dave Chinner wrote:
> On Wed, Oct 24, 2012 at 12:18:58PM -0400, Brian Foster wrote:
>> On 10/22/2012 09:42 PM, Dave Chinner wrote:
>>> On Fri, Oct 05, 2012 at 10:17:14AM -0400, Brian Foster wrote:
>>>> Support quota ID filtering in the eofblocks scan. The caller must
>>>> set the XFS_EOF_FLAGS_QUOTA flags bit, quota ID and quota type. The
>>>> associated quota type must be enabled on the mounted filesystem.
>>>
>>> I'm wondering if this even needs quota enabled to filter based on a
>>> uid, gid, or prid?
>>>
>>
>> Not really...
>>
>>> The quota part of it seem irrelevant to the filtering that is being
>>> executed - we are only matching against the inode uid/gid/prid, not
>>> against dquots - and I can see situations where just being able to
>>> filter on a given uid/gid might be useful in a multi-user
>>> environment regardless of whether quotas are being used.
>>>
>>
>> This is how my rfc version was implemented (with a comment to the same
>> effect). I added the explicit checking in response to:
>>
>> http://oss.sgi.com/archives/xfs/2012-09/msg00024.html
> 
> Ok, that was in the context of "we need to be specific about what
> the ID is". Now the question is "is quota ID the right ID to use?".
> Different question. ;)
> 

Fair enough. :) I just want to make sure we're on the same page. I'll
take this as an Ok to remove the quota enabled checks. The resulting
behavior will now be that quota ID filtering is supported regardless of
whether quotas are enabled on the targeted mount.

>>> Indeed, even testing is made much easier if we don't have to
>>> juggle quota mount options to test the filtering....
>>>
>>
>> I agree. I suppose the check can make a bit of sense if the current
>> group/proj mode of the mount conflicts with the eofb request, but as
>> you've outlined above, we're checking against the inode values so I
>> don't think it introduces a functional problem.
> 
> Right, and if we even get the separate project quota inode patches
> merged, then all three can be valid at once. Indeed, that makes me
> ask the question - should we be able to filter on multiple IDs in a
> single pass (e.g. walk Jim's files in the jasper project)?
> 

That sounds vaguely familiar, perhaps I've skimmed over such a patchset,
but it's not immediately clear to me. Interesting idea nonetheless and I
see no idea why we couldn't support such a mechanism if the id's are
independent...

> Seeing as it is just a filter, enabling the above (even though it
> would be rarely used) might make sense. i.e. separate field for each
> id. It's not like we have to keep the size of the structure to a
> minimum...
> 

... but that is also starting to further complicate the filtering and
testing required. I'm also not quite sure how we would currently specify
a union of id's in the flags given that we migrated towards the use of
the real quota type field (eof_q_type) rather than my original approach
of specifying the quota id type as a flag.

Would we be sufficiently prepared for the future if we broke the id into
three fields, i.e.:

struct xfs_eofblocks {
	...
	__u32	eof_uquota_id;
	__u32	eof_gquota_id;
	__u32	eof_pquota_id;
	__u32	eof_q_type;
	...
};

... but the in kernel implementation remains as is by using the
associated field based on the quota type? To be honest, even if we had a
way to specify multiple id's, I think I would prefer to leave the
implementation as is and do the enhanced filtering in future patches
(e.g., get the data structure right, but EINVAL for now if multiple id's
are flagged), if for nothing else than the testing I've already done
against this implementation. But I suspect if there isn't currently a
standard way to specify multiple quota types, we're fated to have to
update the structure with a new version anyways..?

Perhaps I need to take a look at this project quota inode patchset you
refer to...

> Cheers,
> 
> Dave.

Heh... almost stopped reading here.. ;)

>>> Why do you need xfs_quota_type() here? why not just:
>>>
>>> 	switch (type) {
>>> 	case XQM_USRQUOTA:
>>> 		return ip->i_d.di_uid == eofb->eof_q_id;
>>> 	case XQM_GRPQUOTA:
>>> 		return ip->i_d.di_gid == eofb->eof_q_id;
>>> 	case XQM_PRJQUOTA:
>>> 		return xfs_get_projid(ip) == eofb->eof_q_id;
>>> 	default:
>>> 		break;
>>> 	}
>>>
>>> 	return 0;
>>>
>>
>> Technically we don't really need xfs_quota_type(). I just thought it
>> cleaner to use the same mapping we use throughout XFS (i.e., I don't see
>> those definitions used elsewhere in XFS)...
> 
> XQM_* are the userspace XFS quota interface definitions. They are
> what xfs_quota uses. They just so happen to be the same as the
> generic quota definitions except the generic quotas don't define
> project quota types (hence the need for mapping).  See
> include/uapi/linux/dqblk_xfs.h.
> 
> I just figured that rather than mapping something unknown to
> something known, just using something known in the first place is
> much simpler...
> 

Right, at the time I think I dug through the various quota type
definitions, saw that we provided this mapping function and got the
impression we should be consistent throughout the filesystem. But I
think your point here is that the expected input should be the
definitions we already define for userspace whereas I was thinking the
generic definitions were ubiquitous from userspace.

Now that I have a quick look, I don't see the XQM_* definitions used
anywhere in xfsprogs or the kernel. I see XFS_{USER,GROUP,PROJ}_QUOTA
defined and mapped to USRQUOTA/GRPQUOTA/PRJQUOTA in xfsprogs, but then
the former not defined in the kernel. :/

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
