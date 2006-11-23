Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Nov 2006 23:08:08 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAN77waG032340
	for <xfs@oss.sgi.com>; Wed, 22 Nov 2006 23:07:59 -0800
Date: Thu, 23 Nov 2006 18:09:22 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
Message-ID: <26F2AE58A7D40E5170649BC2@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <45647CF8.8020104@sandeen.net>
References: <455CB54F.8080901@sandeen.net> <455CE1E3.7020703@sandeen.net>	
 <45612621.5010404@sandeen.net>  <45627A4D.3020502@sandeen.net>	
 <1164157336.19915.43.camel@xenon.msp.redhat.com>	
 <5A1AC29043EE33BEB778198A@timothy-shimmins-power-mac-g5.local>	 <45647042.2040604@sandeen.net>
 <1164212695.19915.65.camel@xenon.msp.redhat.com> <45647CF8.8020104@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com

Hi Guys,

So just looking at the first part, which as Eric suggested can be considered
on its own.

Index: work_gfs/fs/xfs/xfs_attr.c
===================================================================
--- work_gfs.orig/fs/xfs/xfs_attr.c	2006-11-21 18:38:27.572949303 -0600
+++ work_gfs/fs/xfs/xfs_attr.c	2006-11-21 18:44:51.666033422 -0600
@@ -210,8 +210,20 @@ xfs_attr_set_int(xfs_inode_t *dp, const
 	 * (inode must not be locked when we call this routine)
 	 */
 	if (XFS_IFORK_Q(dp) == 0) {
-		if ((error = xfs_bmap_add_attrfork(dp, size, rsvd)))
-			return(error);
+		if ((dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) ||
+		    ((dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS) &&
+		     (dp->i_d.di_anextents == 0))) {
+			/* xfs_bmap_add_attrfork will set the forkoffset based on
+			 * the size needed, the local attr case needs the size
+			 * attr plus the size of the hdr, if the size of
+			 * header is not accounted for initially the forkoffset
+			 * won't allow enough space, the actually attr add will
+			 * then be forced out out line to extents
+			 */
+			size += sizeof(xfs_attr_sf_hdr_t);
+			if ((error = xfs_bmap_add_attrfork(dp, size, rsvd)))
+				return(error);
+		}
 	}

--On 22 November 2006 10:38:16 AM -0600 Eric Sandeen <sandeen@sandeen.net> wrote:
>> By fixing the initial size calculation at least things like SElinux
>> which is adding one attr won't cause the attr segment to flip to extents
>> immediately.
>> The second attr will cause the flip but not the first one.
>
> I'd say this part (fixing up proper space for the initial attr fork setup) should probably go in
> soon if it gets good reviews (with the removal of the extra tests, as we discussed on irc last
> night).  I think this proper change stands on its own just fine.
>

So yeah, as you said in IRC, the brace is in the wrong spot and
the di_aformat tests don't make any sense here.
Basically, we know that fork offset is zero and therefore that the di_aformat should be
set at XFS_DINODE_FMT_EXTENTS and di_anetents will be zero.
As this is the state before we add in an attribute fork.
Why we have this initial state as extents, I'm not too sure and wondered in the
past. Maybe because this state is one which doesn't occupy any space in the literal area.
A shortform EA has a header at least.

My next concern is that the size that is calculated is presumably trying to accomodate
the shortform EA. However, the calculation is for the sf header and the space for a
a xfs_attr_leaf_name_local with given namelen and valuelen.
It would be better to base it on an xfs_attr_sf_entry type.
So I think we need to rework this calculation.

Which leads me on to the next issue.
We don't know what EA form we are going to take,
so we can't really assume that it will be shortform.
If the EA name or value is big then the EA will go into extents and could occupy very
little room in the inode.
With the current & proposed test this could make the bytesfit function return 0
(the offset calculated in bytesfit could also go negative) and
then we would set the forkoff back at the old attr1 default.
So we might have 1 EA extent in the inode taking little space and yet setting the forkoff
in the middle.

Of course the setting of the forkoff is a bit of a guessing game since we can't
predict the future usage but I think the plan is to set it to the minimum to fit
on a first come first served basis.

So I'm thinking that we should set it based on the size of shortform if that
is how it will be stored or to the size taken up by the EA extents -
I was initially thinking that this would be 1 extent but with a remote value
block of up to 64K this could in theory be an extent for each fsb of the value
I guess.
Have to think about this some more.

--Tim
