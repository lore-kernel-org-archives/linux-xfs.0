Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1DBCB7CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 18:28:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E4FFC304039
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 16:28:36 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jrWHfdriqsmwYab8 for <xfs@oss.sgi.com>;
	Thu, 12 May 2016 16:28:34 -0700 (PDT)
Date: Fri, 13 May 2016 09:28:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_db: allow recalculating CRCs on invalid metadata
Message-ID: <20160512232804.GC18496@dastard>
References: <1463092513-5462-1-git-send-email-david@fromorbit.com>
	<ee586739-e804-8174-8497-cc8a992b9752@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ee586739-e804-8174-8497-cc8a992b9752@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, May 12, 2016 at 06:03:15PM -0500, Eric Sandeen wrote:
> On 5/12/16 5:35 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently we can't write corrupt structures with valid CRCs on v5
> > filesystems via xfs_db. TO emulate certain types of corruption
> > result from software bugs in the kernel code, we need this
> > capability to set up the corrupted state. i.e. corrupt state with a
> > valid CRC needs to appear on disk.
> > 
> > This requires us to avoid running the verifier that would otherwise
> > prevent writing corrupt state to disk. To enable this, add the CRC
> > offset to the type table for different buffers and add a new flag to
> > the write command to trigger running a CRC calculation base don this
> > type table. We can then insert the calculated value into the correct
> > location in the buffer...
> > 
> > Because some objects are not directly buffer based, we can't easily
> > do this CRC trick. Those object types will be marked as
> > TYP_NO_CRC_OFF, and as a result will emit an error such as:
> 
> Using "TYP_NO_CRC_OFF" seems a little weird from a naming perspective;
> it's not really a  TYP_* is it?   Its opposite is things like
> XFS_AGI_CRC_OFF; NO_FIXED_CRC_OFF might be better to not confuse it
> with the TYP_ on-disk types?  Just a thought.

I just preficed it like that because it's something specific to the
type table. From that perspecitive, TYP_NO_CRC_RECALC might make
more sense. i.e. "this type cannot recalculate CRCs".

[...]
> >  	argc -= optind;
> >  	argv += optind;
> >  
> > -	if (iocur_top->bp->b_ops && corrupt) {
> > -		/* Temporarily remove write verifier to write bad data */
> > -		stashed_ops = iocur_top->bp->b_ops;
> > -		nowrite_ops.verify_read = stashed_ops->verify_read;
> > +	/* If we don't have to juggle verifiers, then just issue the write */
> 
> This is a little confusing - we know what juggling verifiers means but
> future readers may not have that fresh in mind.  ;)
> 
> /* No verifier, or standard verifier paths; just write it out and return */

Sure.

> > +	if (!iocur_top->bp->b_ops ||
> > +	    !(corrupt || invalid_data)) {
> > +		(*pf)(DB_WRITE, cur_typ->fields, argc, argv);
> > +		return 0;
> > +	}
> > +
> > +
> > +	/* Temporarily remove write verifier to write bad data */
> > +	stashed_ops = iocur_top->bp->b_ops;
> > +	nowrite_ops.verify_read = stashed_ops->verify_read;
> > +	iocur_top->bp->b_ops = &nowrite_ops;
> 
> I'm regretting my name choice of "nowrite_ops" ...

I can rename it to "local_ops"...

> > +
> > +	if (corrupt) {
> >  		nowrite_ops.verify_write = xfs_dummy_verify;
> > -		iocur_top->bp->b_ops = &nowrite_ops;
> > -		dbprintf(_("Allowing write of corrupted data\n"));
> > +		dbprintf(_("Allowing write of corrupted data and bad CRC\n"));
> > +	} else {
> 
> Maybe a helpful/redundant comment about /* invalid_data */ alongside } else { ?

I though the dbprintf() documented it well enough? maybe move that
to the top of each branch?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
