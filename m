Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC1387F4E
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 19:29:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6F6B30408A
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 17:29:07 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	uZcIANjFiRn1tz7c for <xfs@oss.sgi.com>;
	Thu, 05 Sep 2013 17:28:52 -0700 (PDT)
Date: Fri, 6 Sep 2013 10:28:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 10/11] xfs: update the finobt on inode free
Message-ID: <20130906002847.GR12779@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-11-git-send-email-bfoster@redhat.com>
	<20130905025421.GX23571@dastard> <5228AF00.7080700@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5228AF00.7080700@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Sep 05, 2013 at 12:19:12PM -0400, Brian Foster wrote:
> On 09/04/2013 10:54 PM, Dave Chinner wrote:
> > On Tue, Sep 03, 2013 at 02:25:07PM -0400, Brian Foster wrote:
> >> An inode free operation can have several effects on the finobt. If
> >> all inodes have been freed and the chunk deallocated, we remove the
> >> finobt record. If the inode chunk was previously full, we must
> >> insert a new record based on the existing inobt record. Otherwise,
> >> we modify the record in place.
.....
> >> +	} else if ((i == 0) && (ibtrec->ir_freecount == 1)) {
> >> +		/*
> >> +		 * No existing finobt record and the inobt record has a single
> >> +		 * free inode. This means we've freed an inode in a previously
> >> +		 * fully allocated chunk. Insert a new record into the finobt
> >> +		 * based on the current inobt record.
> >> +		 */
> >> +		cur->bc_rec.i.ir_startino = ibtrec->ir_startino;
> >> +		cur->bc_rec.i.ir_free = ibtrec->ir_free;
> >> +		cur->bc_rec.i.ir_freecount = ibtrec->ir_freecount;
> >> +		error = xfs_btree_insert(cur, &i);
> >> +		if (error)
> >> +			goto error;
> >> +		ASSERT(i == 1);
> > 
> > That's rather similar to the code in xfs_inobt_insert(). Indeed,
> > is you write a helper - xfs_inobt_insert_rec() - for this, then rather than modifying
> > xfs_inobt_lookup() to take extra parameters like I wondered for the
> > previous patch, leave it alonge and pass the parameters to
> > xfs_inobt_insert_rec() instead.
> > 
> > Then this code is functionally identical to xfs_inobt_insert() done
> > during allocation....
> > 
> 
> I think I'm parsing you after having another look at the code.
> xfs_inobt_lookup() remains as is and is potentially used from
> xfs_inobt_insert(). xfs_inobt_insert_rec() is introduced to set the
> cursor fields and do the insert and is used here and from
> xfs_inobt_insert().

Effectively. xfs_inobt_insert() becomes:

	for (each inode chunk) {
		xfs_inobt_lookup(cur, startino)
		xfs_inobt_insert_rec(cur, startino, free, free_count)
	}

And this code becomes:

	xfs_inobt_lookup(cur, startino);
	if (!found) {
		if (free_count == 1)
			xfs_inobt_insert_rec(cur, startino, free, free_count)
		else
			CORRUPTION
		goto out;
	}

> At that point, this looks close to xfs_inobt_insert(), but I think using
> that here would introduce a duplicate lookup.

Yes, it would. I think just using helpers like this is sufficient
for the two different cases, especially as xfs_inobt_insert() needs
to be able to handle multiple chunk insertion and we don't have that
here...

> Regardless, we'll see what
> the whole thing looks like at that point. Thanks for the reviews. :)

No worries. BTW, can you post your rudimentary userspace support so
we can run tests that use this code, too?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
