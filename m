Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Oct 2007 16:03:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9UN3Ou4032416
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2007 16:03:25 -0700
Date: Wed, 31 Oct 2007 10:03:20 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Clean up sparse warnings
Message-ID: <20071030230320.GS66820511@sgi.com>
References: <20071029233442.GP995458@sgi.com> <20071030100523.GA23489@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030100523.GA23489@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Tue, Oct 30, 2007 at 10:05:23AM +0000, Christoph Hellwig wrote:
> On Tue, Oct 30, 2007 at 10:34:42AM +1100, David Chinner wrote:
> > 
> > Clean up most outstanding sparse warnings.
> > 
> > These are mostly locking annotations, marking things static,
> > casts where needed and declaring stuff in header files.
> 
> Nice.  Note that once we start on making things static there's also a lot
> of things not really used non-static but exported which we should cleanup
> aswell.  I'll look at that when I get some time.
> 
> Note that we'll also always get tons of sparse warnings for debug builds
> because STATIC is defined away..

Yeah, I noticed that - but given that we've done that on purpose to
aid debugging, I don't think it will change ;)

> > @@ -2733,21 +2733,13 @@ xlog_recover_do_efd_trans(
> >  				 * AIL lock.
> >  				 */
> >  				xfs_trans_delete_ail(mp, lip);
> > -				break;
> > +				xfs_efi_item_free(efip);
> > +				return;
> >  			}
> >  		}
> >  		lip = xfs_trans_next_ail(mp, lip, &gen, NULL);
> >  	}
> > -
> > -	/*
> > -	 * If we found it, then free it up.  If it wasn't there, it
> > -	 * must have been overwritten in the log.  Oh well.
> > -	 */
> > -	if (lip != NULL) {
> > -		xfs_efi_item_free(efip);
> > -	} else {
> > -		spin_unlock(&mp->m_ail_lock);
> > -	}
> > +	spin_unlock(&mp->m_ail_lock);
> 
> Imho non-trivial changes like this hunk always deserve beeing a patch of
> it's own where they're described in details.

Ok, I'll split that one out.

> Note that I also get warnings from the lock annotations prover in sparse
> about some conditional locking in xfs_mount.c.  I have patches I still need
> to run through testing for those which clean the code up quite nicely aswell.

Oh, yeah, I left a couple in the icsb code alone as they'd require more than
trivial annotation to fix. I just wanted to remove the majority of the
noise so I could see new problems easily. Patches to fix them would be great
;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
