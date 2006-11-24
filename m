Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Nov 2006 20:46:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAO4kFaG012394
	for <xfs@oss.sgi.com>; Thu, 23 Nov 2006 20:46:16 -0800
Date: Fri, 24 Nov 2006 15:47:41 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
Message-ID: <85F7BBFB66573AAC402078C9@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <4565DC6A.9080602@thebarn.com>
References: <455CB54F.8080901@sandeen.net> <455CE1E3.7020703@sandeen.net>	
 <45612621.5010404@sandeen.net>  <45627A4D.3020502@sandeen.net>	
 <1164157336.19915.43.camel@xenon.msp.redhat.com>	
 <5A1AC29043EE33BEB778198A@timothy-shimmins-power-mac-g5.local>	 <45647042.2040604@sandeen.net>
 <1164212695.19915.65.camel@xenon.msp.redhat.com> <45647CF8.8020104@sandeen.net>
 <26F2AE58A7D40E5170649BC2@timothy-shimmins-power-mac-g5.local> <4565DC6A.9080602@thebarn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--On 23 November 2006 11:37:46 AM -0600 Russell Cattelan <cattelan@thebarn.com> wrote:

> Timothy Shimmin wrote:
>
>> Hi Guys,
>>
>> So just looking at the first part, which as Eric suggested can be
>> considered
>> on its own.
>>
>> Index: work_gfs/fs/xfs/xfs_attr.c
>> ===================================================================
>> --- work_gfs.orig/fs/xfs/xfs_attr.c    2006-11-21 18:38:27.572949303
>> -0600
>> +++ work_gfs/fs/xfs/xfs_attr.c    2006-11-21 18:44:51.666033422 -0600
>> @@ -210,8 +210,20 @@ xfs_attr_set_int(xfs_inode_t *dp, const
>>      * (inode must not be locked when we call this routine)
>>      */
>>     if (XFS_IFORK_Q(dp) == 0) {
>> -        if ((error = xfs_bmap_add_attrfork(dp, size, rsvd)))
>> -            return(error);
>> +        if ((dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) ||
>> +            ((dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS) &&
>> +             (dp->i_d.di_anextents == 0))) {
>> +            /* xfs_bmap_add_attrfork will set the forkoffset based on
>> +             * the size needed, the local attr case needs the size
>> +             * attr plus the size of the hdr, if the size of
>> +             * header is not accounted for initially the forkoffset
>> +             * won't allow enough space, the actually attr add will
>> +             * then be forced out out line to extents
>> +             */
>> +            size += sizeof(xfs_attr_sf_hdr_t);
>> +            if ((error = xfs_bmap_add_attrfork(dp, size, rsvd)))
>> +                return(error);
>> +        }
>>     }
>>
>> --On 22 November 2006 10:38:16 AM -0600 Eric Sandeen
>> <sandeen@sandeen.net> wrote:
>>
>>>> By fixing the initial size calculation at least things like SElinux
>>>> which is adding one attr won't cause the attr segment to flip to
>>>> extents
>>>> immediately.
>>>> The second attr will cause the flip but not the first one.
>>>
>>>
>>> I'd say this part (fixing up proper space for the initial attr fork
>>> setup) should probably go in
>>> soon if it gets good reviews (with the removal of the extra tests, as
>>> we discussed on irc last
>>> night).  I think this proper change stands on its own just fine.
>>>
>>
>> So yeah, as you said in IRC, the brace is in the wrong spot and
>> the di_aformat tests don't make any sense here.
>> Basically, we know that fork offset is zero and therefore that the
>> di_aformat should be
>> set at XFS_DINODE_FMT_EXTENTS and di_anetents will be zero.
>> As this is the state before we add in an attribute fork.
>> Why we have this initial state as extents, I'm not too sure and
>> wondered in the
>> past. Maybe because this state is one which doesn't occupy any space
>> in the literal area.
>> A shortform EA has a header at least.
>>
>> My next concern is that the size that is calculated is presumably
>> trying to accomodate
>> the shortform EA. However, the calculation is for the sf header and
>> the space for a
>> a xfs_attr_leaf_name_local with given namelen and valuelen.
>> It would be better to base it on an xfs_attr_sf_entry type.
>> So I think we need to rework this calculation.
>>
>> Which leads me on to the next issue.
>> We don't know what EA form we are going to take,
>> so we can't really assume that it will be shortform.
>> If the EA name or value is big then the EA will go into extents and
>> could occupy very
>> little room in the inode.
>> With the current & proposed test this could make the bytesfit function
>> return 0
>> (the offset calculated in bytesfit could also go negative) and
>> then we would set the forkoff back at the old attr1 default.
>> So we might have 1 EA extent in the inode taking little space and yet
>> setting the forkoff
>> in the middle.
>
> Yes I agree worst cast scenario is that the inode has reverted to an attr1 split and
> that space is being wasted in the attr portion. By the time an inode has flipped to
> btree mode for di_u how much of a performance hit is really going to be noticed?
> mapping the blocks for that inode is going to take multiple reads.
> Attr2 seems most effective at space optimization for the local and extent
> versions of di_u and probably not so much for btree.
>
> At least by fixing the size calculation the shortforms that do fit  into di_a will now
> be added inline.  What is happening now the btree is being re factored
> which is probably expensive and the attr is being added as extents since the
> original size used for the btree refactoring wasn't enough.
>
> So the change to add in the header size will at least make single case
> attrs more efficient since they will now be inline.

No argument there, I just want to make sure the SF size calculation is correct.
I think we need a new macro here.
Currently we just accumulate the size using the totsize field in the header
and so on an EA add, just add in the space for 1 entry: i.e.
        newsize = XFS_ATTR_SF_TOTSIZE(args->dp);
        newsize += XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
We need a macro, at least, for the total size for 1 given EA.
xfs_attr_leaf_newentsize is not necessarily the space for a shortform (SF) EA -
the structs do have different field sizes.


> If the attr does not fit inline then worst case the forkoff flips to attr1
> default  or a half and half split.
>
> Given the cost of refactoring a btree it might be better to have attr1 behavior?
> Since di_a will have extra space additional attr adds won't  cause forkoff to
> move and thus won't cause a rebalance of di_u.
>
If the SF EA can't fit in the literal space, and goes to extents then adding
further EAs probably isn't going to move the forkoff at all either, since they'll
probably just go into the EA leaf block.

> So in thinking about this more does it make sense to actually not
> try to optimize the space needed for di_u when it is a btree?
> Maybe the first time an attr is added simply split the inode
> space doing the rebalance once?
> That would allow for more attrs to be added without rebalancing
> the data btree.
> The other scheme of space optimzation if the root btree node
> is sparse would say sure give more space to di_a but at
> the expense of a reblanace.
>
> So ya it's a bit of a guessing game.
>
Yeah I'm inclined not to worry about compressing the btree data root but
just working out where it really finishes in the literal area and not
pushing it.

(All this would be a lot easier to discuss in person with a whiteboard,
 as I think Eric was kind of suggesting in irc :)

Back to the 1st part.
I'm thinking that if I can't fit the SF EA in the available space,
then we might just assume that we should leave EA space for the
MAX(2 extents, min-root-size) i.e. try for 2 extents (bytesfit will make
sure we atleast have the min-root-size). The forkoff is just a good
guess after all - it's a tradeoff.

Okay, need to do some coding...

--Tim
