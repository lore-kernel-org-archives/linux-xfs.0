Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2431A7CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 13:17:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA4EC304039
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 11:17:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1VD9MeNuDJplP8oI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 11:17:45 -0700 (PDT)
Date: Mon, 29 Aug 2016 14:17:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/5] xfs: don't warn on buffers not being recovered due
	to LSN
Message-ID: <20160829181743.GB54904@bfoster.bfoster>
References: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
	<1470935467-52772-4-git-send-email-bfoster@redhat.com>
	<20160829012514.GL19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160829012514.GL19025@dastard>
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

On Mon, Aug 29, 2016 at 11:25:14AM +1000, Dave Chinner wrote:
> On Thu, Aug 11, 2016 at 01:11:05PM -0400, Brian Foster wrote:
> > The log recovery buffer validation function is invoked in cases where a
> > buffer update may be skipped due to LSN ordering. If the validation
> > function happens to come across directory conversion situations (e.g., a
> > dir3 block to data conversion), it may warn about seeing a buffer log
> > format of one type and a buffer with a magic number of another.
> > 
> > This warning is not valid as the buffer update is ultimately skipped.
> > This is indicated by a current_lsn of NULLCOMMITLSN provided by the
> > caller. As such, update xlog_recover_validate_buf_type() to only warn in
> > such cases when a buffer update is expected.
> > 
> > XXX: other issues here? better to not validate in such cases?
> 
> I think this is OK - we really want to ensure that buffers that are
> in cache always have the correct verifier attached to them. Hence if
> we've read the buffer in, even if we are not modifying it because
> it's more recent that what is being replayed we should still attach
> the verifiers to it.
> 
> If it changes type due to later recovery replay, we'll change the
> verifier appropriately at that point.
> 

Sounds good, thanks for commenting on this.

> > @@ -2557,6 +2542,16 @@ xlog_recover_validate_buf_type(
> >  			 xfs_blft_from_flags(buf_f));
> >  		break;
> >  	}
> > +
> > +	/*
> > +	 * A NULL current LSN indicates the buffer update is skipped due to LSN
> > +	 * ordering. Don't warn in such cases, we skip the update for a reason
> > +	 * (it's no longer valid)!
> > +	 */
> 
> I read that the first time as "we skip the update for a reason that
> is no longer valid" :P
> 

Heh, Ok.

> perhaps rework this to make it clear what is being referred to here.
> e.g. No need to warn if the the buffer contents are more recent
> that this recovery item and hence recovery did not modify the
> buffer.
> 

Yeah, I'll try to make that more clear.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
