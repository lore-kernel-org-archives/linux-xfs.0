Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9P0TkoY064550 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 19:29:46 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8A4KIZymi3mUd5mC for
	<xfs@oss.sgi.com>; Wed, 24 Oct 2012 17:31:29 -0700 (PDT)
Message-ID: <508887FA.9080004@redhat.com>
Date: Wed, 24 Oct 2012 20:29:46 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 08/10] xfs: add quota id filtering to eofblocks scan
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-9-git-send-email-bfoster@redhat.com>
	<20121023014222.GL4291@dastard> <508814F2.3060409@redhat.com>
	<20121024194124.GW4291@dastard> <50887389.5020102@redhat.com>
	<20121025000241.GB29378@dastard>
In-Reply-To: <20121025000241.GB29378@dastard>
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

On 10/24/2012 08:02 PM, Dave Chinner wrote:
> On Wed, Oct 24, 2012 at 07:02:33PM -0400, Brian Foster wrote:
>> On 10/24/2012 03:41 PM, Dave Chinner wrote:
>>> On Wed, Oct 24, 2012 at 12:18:58PM -0400, Brian Foster wrote:
>>>> On 10/22/2012 09:42 PM, Dave Chinner wrote:
...
>>> Seeing as it is just a filter, enabling the above (even though it
>>> would be rarely used) might make sense. i.e. separate field for each
>>> id. It's not like we have to keep the size of the structure to a
>>> minimum...
>>>
>>
>> ... but that is also starting to further complicate the filtering and
>> testing required. I'm also not quite sure how we would currently specify
>> a union of id's in the flags given that we migrated towards the use of
>> the real quota type field (eof_q_type) rather than my original approach
>> of specifying the quota id type as a flag.
> 
> Well, quota type just goes away completely - it's irrelevant.
> 
>> Would we be sufficiently prepared for the future if we broke the id into
>> three fields, i.e.:
>>
>> struct xfs_eofblocks {
>> 	...
>> 	__u32	eof_uquota_id;
>> 	__u32	eof_gquota_id;
>> 	__u32	eof_pquota_id;
>> 	__u32	eof_q_type;
>> 	...
> 
> I'd suggest uid, gid and prid as the types, dropping the quota type
> altogether. Then add specific flags to indicate each field is set
> rather than a flag to say "look at the q_type field for which id
> field to read"...
> 

Ah, I see your point now. The filter parameters basically become
inode-centric rather than quota-centric. This makes sense.

> i.e. the API is indepedent of quota configurations and quota IDs,
> but is still capable of expressing such control when required.
> 
>> ... but the in kernel implementation remains as is by using the
>> associated field based on the quota type? To be honest, even if we had a
>> way to specify multiple id's, I think I would prefer to leave the
>> implementation as is and do the enhanced filtering in future patches
>> (e.g., get the data structure right, but EINVAL for now if multiple id's
>> are flagged),
> 
> Sure, that's fine.
> 
>> if for nothing else than the testing I've already done
>> against this implementation. But I suspect if there isn't currently a
>> standard way to specify multiple quota types, we're fated to have to
>> update the structure with a new version anyways..?
> 
> There is a standard way of recording a *single* "quota ID" in kernel
> space now - see quota.h:
> 
> struct kqid {                   /* Type in which we store the quota identifier */
>         union {
>                 kuid_t uid;
>                 kgid_t gid;
>                 kprojid_t projid;
>         };
>         enum quota_type type;  /* USRQUOTA (uid) or GRPQUOTA (gid) or PRJQUOTA (projid) */
> }
> 
> and a bunch or wrappers for manipulating them. That's the sort of
> thing that we'd need to build internally for filtering so we end up
> with user namespace support. This is shiny and new, just merged in
> 3.7-rc1....
> 

Ok, I do remember taking a cursory look at this set. I didn't realize it
was merged. Thanks for the explanation.

Brian

>>> XQM_* are the userspace XFS quota interface definitions. They are
>>> what xfs_quota uses. They just so happen to be the same as the
>>> generic quota definitions except the generic quotas don't define
>>> project quota types (hence the need for mapping).  See
>>> include/uapi/linux/dqblk_xfs.h.
>>>
>>> I just figured that rather than mapping something unknown to
>>> something known, just using something known in the first place is
>>> much simpler...
>>>
>>
>> Right, at the time I think I dug through the various quota type
>> definitions, saw that we provided this mapping function and got the
>> impression we should be consistent throughout the filesystem. But I
>> think your point here is that the expected input should be the
>> definitions we already define for userspace whereas I was thinking the
>> generic definitions were ubiquitous from userspace.
> 
> Well, the generic definitions never defined project quota. If you
> look now in the 3.7 codebase you'll see that PRJQUOTA has been added
> to include/linux/quota.h, as has a kprojid_t type.  Hence project
> quota IDs are now considered a first class quota citizen by the
> generic quota *kernel* code.  However, include/uapi/linux/quota.h is
> completely unchanged, so the generic quota userspace interface still
> knows nothing about project IDs, which means the only actual user
> facing definition is still in include/uapi/linux/dqblks_xfs.h -
> XQM_PRJQUOTA. Hence we assume a quota ID that doesn't match anything
> the generic quota understands to be a project quota as that's the
> only way stuff works in a predictable, reliable manner...
> 
> The origin of this mess are historic as XFS brought along it's own
> quota implementation and API from Irix years ago because the linux
> quota subsystem was not robust or fully featured enough to even
> consider integration at the time (e.g. generic quotas didn't even
> support journalled quotas). So, yeah, a mess but one that is slowly
> getting cleaned up.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
