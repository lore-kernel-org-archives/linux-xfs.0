Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751637AbdEQLrH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 May 2017 07:47:07 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 48A0D8047C
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2017 11:47:06 +0000 (UTC)
Date: Wed, 17 May 2017 13:47:02 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: Properly retry failed inode items in case of
 error during buffer writeback
Message-ID: <20170517114702.gpp2rsk3e5giofbm@eorzea.usersys.redhat.com>
References: <20170511135733.21765-1-cmaiolino@redhat.com>
 <20170511135733.21765-3-cmaiolino@redhat.com>
 <20170511170805.GB14148@localhost.localdomain>
 <20170512082135.g6vd4vvxlctmtptq@eorzea.usersys.redhat.com>
 <20170512113727.GB15623@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170512113727.GB15623@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

> > > > +			}
> > > > +
> > > > +			if (!(bp->b_flags & XBF_WRITE_FAIL)) {
> > > > +				rval = XFS_ITEM_FLUSHING;
> > > > +				xfs_buf_relse(bp);
> > > > +				goto out_unlock;
> > > > +			}
> 
> I think I glossed over this on my first pass, but I don't think we need
> to (or should) check XBF_WRITE_FAIL here or in the error handler. It's a
> flag used to control the internal retry and that is kind of irrelevant
> to this mechanism. Unless I'm missing something.. I don't think this
> state can occur..?
> 

Yup, right, it is not required, I'll remove it for the next version,

thanks for the review

> Brian
> 
> > > > +
> > > > +			while (lip != NULL) {
> > > > +				next = lip->li_bio_list;
> > > > +
> > > > +				if (lip->li_flags & XFS_LI_FAILED)
> > > > +					lip->li_flags &= XFS_LI_FAILED;
> > > 
> > > Eric already pointed out that you probably intend to clear the flag
> > > here..?
> > > 
> > 
> > Yup, my bad.
> > 
> > > > +				lip = next;
> > > > +			}
> > > 
> > > This whole hunk might be better off in a helper function (with the
> > > comment Eric suggested as well).
> > >
> > 
> > Agreed, a helper function can be used here and in dquot code as well, so I agree
> > that a helper function can be useful, I'll try to make it a common code for both
> > dquot and inode items.
> >  
> > > Those points and the ->iop_error() thing aside, this otherwise seems Ok
> > > to me.
> > >
> > 
> >  
> > > Brian
> > > 
> > > > +
> > > > +			if (!xfs_buf_delwri_queue(bp, buffer_list))
> > > > +				rval = XFS_ITEM_FLUSHING;
> > > > +
> > > > +			xfs_buf_relse(bp);
> > > > +			goto out_unlock;
> > > > +		}
> > > > +
> > > >  		rval = XFS_ITEM_FLUSHING;
> > > >  		goto out_unlock;
> > > > +
> > > >  	}
> > > >  
> > > >  	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
> > > > @@ -622,7 +673,8 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
> > > >  	.iop_unlock	= xfs_inode_item_unlock,
> > > >  	.iop_committed	= xfs_inode_item_committed,
> > > >  	.iop_push	= xfs_inode_item_push,
> > > > -	.iop_committing = xfs_inode_item_committing
> > > > +	.iop_committing = xfs_inode_item_committing,
> > > > +	.iop_error	= xfs_inode_item_error
> > > >  };
> > > >  
> > > >  
> > > > -- 
> > > > 2.9.3
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > -- 
> > Carlos
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
