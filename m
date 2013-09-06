Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 143167F55
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 06:43:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8567AC00A
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 04:42:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CHqr3HE78yely1Ei for
	<xfs@oss.sgi.com>; Fri, 06 Sep 2013 04:42:58 -0700 (PDT)
Message-ID: <5229BEE6.3060407@redhat.com>
Date: Fri, 06 Sep 2013 07:39:18 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 10/11] xfs: update the finobt on inode free
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-11-git-send-email-bfoster@redhat.com>
	<20130905025421.GX23571@dastard> <5228AF00.7080700@redhat.com>
	<20130906002847.GR12779@dastard>
In-Reply-To: <20130906002847.GR12779@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/05/2013 08:28 PM, Dave Chinner wrote:
> On Thu, Sep 05, 2013 at 12:19:12PM -0400, Brian Foster wrote:
>> On 09/04/2013 10:54 PM, Dave Chinner wrote:
>>> On Tue, Sep 03, 2013 at 02:25:07PM -0400, Brian Foster wrote:
...
>>
>> I think I'm parsing you after having another look at the code.
>> xfs_inobt_lookup() remains as is and is potentially used from
>> xfs_inobt_insert(). xfs_inobt_insert_rec() is introduced to set the
>> cursor fields and do the insert and is used here and from
>> xfs_inobt_insert().
> 
> Effectively. xfs_inobt_insert() becomes:
> 
> 	for (each inode chunk) {
> 		xfs_inobt_lookup(cur, startino)
> 		xfs_inobt_insert_rec(cur, startino, free, free_count)
> 	}
> 
> And this code becomes:
> 
> 	xfs_inobt_lookup(cur, startino);
> 	if (!found) {
> 		if (free_count == 1)
> 			xfs_inobt_insert_rec(cur, startino, free, free_count)
> 		else
> 			CORRUPTION
> 		goto out;
> 	}
> 
>> At that point, this looks close to xfs_inobt_insert(), but I think using
>> that here would introduce a duplicate lookup.
> 
> Yes, it would. I think just using helpers like this is sufficient
> for the two different cases, especially as xfs_inobt_insert() needs
> to be able to handle multiple chunk insertion and we don't have that
> here...
> 

Ok, that was my thinking as well.

>> Regardless, we'll see what
>> the whole thing looks like at that point. Thanks for the reviews. :)
> 
> No worries. BTW, can you post your rudimentary userspace support so
> we can run tests that use this code, too?
> 

Sure. My xfsprogs branch currently is the application of a slightly
older version of this set (pre-cleanups I made to make this post-worthy)
with some hacks to make it apply/compile and a few other patches on top
of that for mkfs, xfs_db and xfs_repair to work through some basic
things I ran into when running xfstests.

Would you prefer I drop the whole thing on the list?

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
