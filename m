Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F1EE7F92
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 08:54:20 -0500 (CDT)
Message-ID: <5166C08C.8000200@sgi.com>
Date: Thu, 11 Apr 2013 08:54:20 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: reserve fields in inode for parent ptr and alloc
	policy
References: <20130410182438.268267840@sgi.com> <20130411030057.GF10481@dastard>
In-Reply-To: <20130411030057.GF10481@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/10/13 22:00, Dave Chinner wrote:
> On Wed, Apr 10, 2013 at 01:24:24PM -0500, Mark Tinguely wrote:
>> Reserve fields in new inode layout for parent pointer and
>> allocation policy.
>
> Not without a design review - there is no way we are going to
> blindly reserve space in any on-disk structure without first having
> a solid design, published proof-of-concept code and agreement that
> the format changes being proposed are the right way to proceed.
>
> Where are the design docs/code for these features?

Then you might want to bump the pad size.

>
>> 		----
>> The inode will hold the parent information for the first
>> link to a file. Information for the other links will be
>> held in extended attribute entries.
>>
>> The "di_parino" is the inode of the parent directory. The
>> directory information for this entry is located the parent
>> directory with "di_paroff" offset.
>>
>> The di_parino/di_paroff concept code is running.
>
> How does it handle hard links? (i.e. multiple parents)

As I stated, the hard links will use extended attribute entries.

>
> Also, inode number is not enough for unique identification of the
> parent - generation number is also required.

Per the 2005 XFS features meeting, the inode and directory offset will 
uniquely describe a link - (thank-you to Glen Overby for that 
observation). The concept code just using one link verifies this fact. 
Using the inode/offset as the identifier is compact and also gives 
information to the file name.

>
> FWIW, lets go back to the (was almost finished) parent pointer
> code from 2009:
>
> http://oss.sgi.com/archives/xfs/2009-01/msg01068.html

yep, read it, studied it, plan to use parts of it but only where needed.

>
> That uses xattrs to store parent information - inode #, generation
> #, and a counter - for each parent. It requires a counter because
> you can have the same inode hard linked into the same parent
> directory multiple times:
>
> typedef struct xfs_parent_eaname_rec {
>         __be64  p_ino;
>         __be32  p_gen;
>         __be32  p_cnt;
> } xfs_parent_eaname_rec_t;
>
> And a transaction appended to the the inode create, link, rename and
> remove operations to manage the xattrs so all cases involving hard
> links work just fine.
>
> Indeed, the single di_parino/di_paroff concept was one of the
> original designs considered because of it's simplicity, but it was
> rejected because of that very simplicity - it cannot handle common
> use cases involving hardlinks.

According to Geoffrey's notes, the hybrid approach was discussed too. 
The single link case will save all the EA operations for the majority of 
the inodes.
>
> Release early, release often?

No, trust but verify.


>
>> 		----
>> The "di_allocpolicy" will be used to remember the allocation
>> policy associated with this inode.
>
> This is exactly what we have padding in the inode for - so that
> future additions to the on-disk inode can be added via feature bits
> to indicate the fields are present.
>
> Cheers,
>
> Dave.


--Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
