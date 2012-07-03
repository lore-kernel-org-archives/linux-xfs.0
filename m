Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63BluGj085943 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 06:47:56 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rpmdqa1kWSsgewZV for
	<xfs@oss.sgi.com>; Tue, 03 Jul 2012 04:47:55 -0700 (PDT)
Message-ID: <4FF2DBD3.4080800@redhat.com>
Date: Tue, 03 Jul 2012 13:47:31 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
MIME-Version: 1.0
Subject: Re: [dm-devel] [PATCH v2 2/3] block: reorganize rounding of
	max_discard_sectors
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
	<1341235225-27551-3-git-send-email-pbonzini@redhat.com>
	<20120703024910.GC3586@redhat.com>
In-Reply-To: <20120703024910.GC3586@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, snitzer@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de

Il 03/07/2012 04:49, Vivek Goyal ha scritto:
>> > +	/* Zero-sector (unknown) and one-sector granularities are the same.  */
>> > +	granularity = max(q->limits.discard_granularity >> 9, 1U);
>> > +
>> >  	/*
>> >  	 * Ensure that max_discard_sectors is of the proper
>> >  	 * granularity
>> >  	 */
>> >  	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
>> > +	max_discard_sectors = round_down(max_discard_sectors, granularity);
>> >  	if (unlikely(!max_discard_sectors)) {
>> >  		/* Avoid infinite loop below. Being cautious never hurts. */
>> >  		return -EOPNOTSUPP;
>> > -	} else if (q->limits.discard_granularity) {
>> > -		unsigned int disc_sects = q->limits.discard_granularity >> 9;
>> > -
>> > -		max_discard_sectors &= ~(disc_sects - 1);
> This is kind of odd. If discard_granularity is zero, we assume that
> discards are supported and granularity is 1. But if max_discard_sectors
> is zero, we assume discards are disabled. Not sure if we should treat
> max_discard_sectors and discard_granularity in same way or not.

Yes, this keeps the same behavior as before.  It is also the one that is
consistent with drivers/scsi/sd.c.  sd_config_discard always sets
limits.discard_granularity and then uses limits.max_discard_sectors to
disable discards.

Paolo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
