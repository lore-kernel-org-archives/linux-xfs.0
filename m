Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753865AbdEQKlP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 May 2017 06:41:15 -0400
Date: Wed, 17 May 2017 12:41:11 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170517104111.aziwbvqpfcbgxnxa@eorzea.usersys.redhat.com>
References: <20170511135733.21765-1-cmaiolino@redhat.com>
 <20170511135733.21765-3-cmaiolino@redhat.com>
 <20170517005749.GO17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170517005749.GO17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave,

On Wed, May 17, 2017 at 10:57:49AM +1000, Dave Chinner wrote:
> On Thu, May 11, 2017 at 03:57:33PM +0200, Carlos Maiolino wrote:
> > +xfs_inode_item_error(
> > +	struct xfs_log_item	*lip,
> > +	unsigned int		bflags)
> > +{
> > +
> > +	/*
> > +	 * The buffer writeback containing this inode has been failed
> > +	 * mark it as failed and unlock the flush lock, so it can be retried
> > +	 * again
> > +	 */
> > +	if (bflags & XBF_WRITE_FAIL)
> > +		lip->li_flags |= XFS_LI_FAILED;
> > +}
> 
> I'm pretty sure we can't modify the log item state like this in
> IO context because the parent object is not locked by this context.
> We can modify the state during IO submission because we hold the
> parent object lock, but we don't hold it here.
> 
> i.e. we can race with other log item state changes done during a
> concurrent transaction (e.g. marking the log item dirty in
> xfs_trans_log_inode()).
> 
> > +
> > +				if (lip->li_flags & XFS_LI_FAILED)
> > +					lip->li_flags &= XFS_LI_FAILED;
> > +				lip = next;
> > +			}
> 
> Same race here - we hold the lock for this inode, but not all the
> other inodes linked to the buffer.
> 
> This implies that lip->li_flags needs to use atomic bit updates so
> there are no RMW update races like this.
> 

I believe refers to both cases above, while setting and removing the flag?

I can simply use set_bit() and clear_bit() here, if this is enough, although, to
use them I'll need to change lip->li_flags size to `unsigned long` if people are
ok with that.

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
