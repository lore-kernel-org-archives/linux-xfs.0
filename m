Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Nov 2006 04:51:52 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kARCpcaG025830
	for <xfs@oss.sgi.com>; Mon, 27 Nov 2006 04:51:40 -0800
Message-ID: <456ADF08.4080002@sgi.com>
Date: Mon, 27 Nov 2006 23:50:16 +1100
From: Tim Shimmin <tes@sgi.com>
Reply-To: tes@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
References: <455CB54F.8080901@sandeen.net> <455CE1E3.7020703@sandeen.net>	 <45612621.5010404@sandeen.net>  <45627A4D.3020502@sandeen.net>	 <1164157336.19915.43.camel@xenon.msp.redhat.com>	 <5A1AC29043EE33BEB778198A@timothy-shimmins-power-mac-g5.local>	 <45647042.2040604@sandeen.net> <1164212695.19915.65.camel@xenon.msp.redhat.com> <45647CF8.8020104@sandeen.net> <26F2AE58A7D40E5170649BC2@timothy-shimmins-power-mac-g5.local> <4565DC6A.9080602@thebarn.com>
In-Reply-To: <4565DC6A.9080602@thebarn.com>
Content-Type: multipart/mixed;
 boundary="------------090006010607070904010804"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------090006010607070904010804
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Russell & Eric,

Basing on Russell's patch, I was thinking of something like the
attached patch.
However, I'm wondering if the xfs_attr_set_int() change to use
a req_size for non-fitting shortform EA's is worth it - as it is a bit
of a prediction (trying to codify what I was thinking).
Russell, perhaps I should just send in sf_size like you initially intended.
In fact, the more I think about it, I'm more inclined to just pass
in sf_size.

Haven't tested the patch out yet. Just wanted to discuss it a bit.

Cheers,
Tim.

Russell Cattelan wrote:
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
> Yes I agree worst cast scenario is that the inode has reverted to an 
> attr1 split and
> that space is being wasted in the attr portion. By the time an inode has 
> flipped to
> btree mode for di_u how much of a performance hit is really going to be 
> noticed?
> mapping the blocks for that inode is going to take multiple reads.
> Attr2 seems most effective at space optimization for the local and extent
> versions of di_u and probably not so much for btree.
> 
> At least by fixing the size calculation the shortforms that do fit  into 
> di_a will now
> be added inline.  What is happening now the btree is being re factored
> which is probably expensive and the attr is being added as extents since 
> the
> original size used for the btree refactoring wasn't enough.
> 
> So the change to add in the header size will at least make single case
> attrs more efficient since they will now be inline.
> If the attr does not fit inline then worst case the forkoff flips to attr1
> default  or a half and half split.
> 
> Given the cost of refactoring a btree it might be better to have attr1 
> behavior?
> Since di_a will have extra space additional attr adds won't  cause 
> forkoff to
> move and thus won't cause a rebalance of di_u.
> 
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
>>
>> Of course the setting of the forkoff is a bit of a guessing game since 
>> we can't
>> predict the future usage but I think the plan is to set it to the 
>> minimum to fit
>> on a first come first served basis.
>>
>> So I'm thinking that we should set it based on the size of shortform 
>> if that
>> is how it will be stored or to the size taken up by the EA extents -
>> I was initially thinking that this would be 1 extent but with a remote 
>> value
>> block of up to 64K this could in theory be an extent for each fsb of 
>> the value
>> I guess.
>> Have to think about this some more.
>>
>> --Tim
>>


--------------090006010607070904010804
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="attr2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="attr2.patch"

--- .pc/attr2_tes/fs/xfs/xfs_attr.c	2006-10-26 17:45:01.000000000 +1000
+++ fs/xfs/xfs_attr.c	2006-11-27 22:58:49.753629073 +1100
@@ -210,7 +210,19 @@ xfs_attr_set_int(xfs_inode_t *dp, const 
 	 * (inode must not be locked when we call this routine)
 	 */
 	if (XFS_IFORK_Q(dp) == 0) {
-		if ((error = xfs_bmap_add_attrfork(dp, size, rsvd)))
+		int req_size;
+		int sf_size = sizeof(xfs_attr_sf_hdr_t) + XFS_ATTR_SF_ENTSIZE_BYNAME(namelen, valuelen);
+
+		if (local && (sf_size <= (XFS_LITINO(mp) - xfs_ifork_dsize_used(dp))))
+			req_size = sf_size;
+		else
+			/*
+			 * We can't fit our SF EA inline, so leave space for 2 EA extents
+			 * which should cover most initial EAs and most EAs in general
+			 */
+			req_size = 2 * sizeof(xfs_bmbt_rec_t);
+
+		if ((error = xfs_bmap_add_attrfork(dp, req_size, rsvd)))
 			return(error);
 	}
 
--- .pc/attr2_tes/fs/xfs/xfs_attr_leaf.c	2006-10-26 17:45:01.000000000 +1000
+++ fs/xfs/xfs_attr_leaf.c	2006-11-27 22:59:07.295306537 +1100
@@ -170,18 +170,25 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 	}
 
 	/* data fork btree root can have at least this many key/ptr pairs */
-	minforkoff = MAX(dp->i_df.if_bytes, XFS_BMDR_SPACE_CALC(MINDBTPTRS));
+	minforkoff = MAX(xfs_ifork_dsize_used(dp), XFS_BMDR_SPACE_CALC(MINDBTPTRS));
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
 	maxforkoff = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */
 
-	if (offset >= minforkoff && offset < maxforkoff)
-		return offset;
+	/* we can't fit inline */
+	if (offset < minforkoff)
+		return 0;
+
+	/* don't move the forkoff for data btree */
+	if (dp->i_d.di_format == XFS_DINODE_FMT_BTREE && dp->i_d.di_forkoff)
+		return dp->i_d.di_forkoff << 3;
+
 	if (offset >= maxforkoff)
 		return maxforkoff;
-	return 0;
+	else
+		return offset;
 }
 
 /*
--- .pc/attr2_tes/fs/xfs/xfs_bmap.c	2006-11-17 14:35:46.000000000 +1100
+++ fs/xfs/xfs_bmap.c	2006-11-27 15:54:33.166590715 +1100
@@ -3543,6 +3543,7 @@ xfs_bmap_forkoff_reset(
 	if (whichfork == XFS_ATTR_FORK &&
 	    (ip->i_d.di_format != XFS_DINODE_FMT_DEV) &&
 	    (ip->i_d.di_format != XFS_DINODE_FMT_UUID) &&
+	    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
 	    ((mp->m_attroffset >> 3) > ip->i_d.di_forkoff)) {
 		ip->i_d.di_forkoff = mp->m_attroffset >> 3;
 		ip->i_df.if_ext_max = XFS_IFORK_DSIZE(ip) /
--- .pc/attr2_tes/fs/xfs/xfs_inode.c	2006-11-27 23:20:19.000000000 +1100
+++ fs/xfs/xfs_inode.c	2006-11-27 23:21:29.604958540 +1100
@@ -4747,3 +4747,34 @@ xfs_iext_irec_update_extoffs(
 		ifp->if_u1.if_ext_irec[i].er_extoff += ext_diff;
 	}
 }
+
+/*
+ * return how much space is used by the inode's data fork
+ */
+int
+xfs_ifork_dsize_used(xfs_inode_t *ip)
+{
+	switch (ip->i_d.di_format) {
+	case XFS_DINODE_FMT_DEV:
+		return sizeof(xfs_dev_t);
+	case XFS_DINODE_FMT_UUID:
+		return sizeof(uuid_t);
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_EXTENTS:
+		return ip->i_df.if_bytes;
+	case XFS_DINODE_FMT_BTREE:
+		if (ip->i_d.di_forkoff)
+			return ip->i_d.di_forkoff << 3;
+		else
+			/*
+			 * For new attr fork, data btree takes all the space,
+			 * so no room for any attrs with the current layout
+			 * but we can know how much space it really needs
+			 * i.e. the ptrs are half way along but we could compress to
+			 * preserve the num of records.
+			 */
+			return XFS_BMDR_SPACE_CALC(XFS_BMAP_BROOT_NUMRECS(ip->i_df.if_broot));
+	default:
+		return 0;
+	}
+}
--- .pc/attr2_tes/fs/xfs/xfs_inode.h	2006-11-17 14:35:46.000000000 +1100
+++ fs/xfs/xfs_inode.h	2006-11-27 23:24:09.376554289 +1100
@@ -535,6 +535,7 @@ void		xfs_iext_irec_compact(xfs_ifork_t 
 void		xfs_iext_irec_compact_pages(xfs_ifork_t *);
 void		xfs_iext_irec_compact_full(xfs_ifork_t *);
 void		xfs_iext_irec_update_extoffs(xfs_ifork_t *, int, int);
+int		xfs_ifork_dsize_used(xfs_inode_t *);
 
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 

--------------090006010607070904010804--
