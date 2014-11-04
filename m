Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D345F7F6B
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 06:15:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C02708F8037
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 04:15:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 28kCVG7XAlFVeUkH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 04:15:19 -0800 (PST)
Date: Tue, 4 Nov 2014 07:15:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 05/17] xfs: create macros/helpers for dealing with
	sparse inode chunks
Message-ID: <20141104121507.GB55611@bfoster.bfoster>
References: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
	<1415031146-9107-6-git-send-email-bfoster@redhat.com>
	<CA+o=1OWm3XWUgNXR1_CravnEBL8fD8dwyMvY4CN9rbAsw0Q4Sw@mail.gmail.com>
	<20141103223407.GA14732@bfoster.bfoster>
	<CA+o=1OWy=VSo3XYMd9LuxiqzRp=p+5iJ909uoJzgKYdOOyVcvg@mail.gmail.com>
	<20141104013308.GC23575@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141104013308.GC23575@dastard>
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
Cc: Fanael Linithien <fanael4@gmail.com>, xfs@oss.sgi.com

On Tue, Nov 04, 2014 at 12:33:08PM +1100, Dave Chinner wrote:
> On Tue, Nov 04, 2014 at 12:56:17AM +0100, Fanael Linithien wrote:
> > 2014-11-03 23:34 GMT+01:00 Brian Foster <bfoster@redhat.com>:
> > > On Mon, Nov 03, 2014 at 11:12:12PM +0100, Fanael Linithien wrote:
> > >> 2014-11-03 17:12 GMT+01:00 Brian Foster <bfoster@redhat.com>:
> > >> >
> > >> > +static inline bool xfs_inobt_issparse(uint16_t holemask)
> > >> > +{
> > >> > +       return holemask == 0 ? false : true;
> > >> > +}
> > >>
> > >> Surely that should be "return holemask != 0;"?
> > >>
> > >
> > > ir_holemask bits are set for holes in the inode chunk and unset for
> > > allocated regions. This means that ir_holemask == 0 for a normal,
> > > fully-allocated chunk and != 0 otherwise (some bits are set to indicate
> > > the chunk has a hole). Check out the commit log for patch 4 for
> > > reasoning.
> > 
> > Oh, I don't comment on the logic, as I don't really know much about
> > XFS code. It's purely a stylistic suggestion: "holemask == 0 ? false :
> > true" looks entirely equivalent to "holemask != 0".
> 
> Even that is unnecessary. booleans are handled by the
> compiler quite nicely - just casting a bool
> type will give the same result. i.e. (bool)holemask results in a
> value of "false" if holemask is zero, "true" if holemask has any
> value other than zero.
> 
> static inline bool xfs_inobt_issparse(uint16_t holemask)
> {
>        return holemask;
> }
> 
> Will give the desired result as there is an implicit typecast to
> bool in that return statement.....
> 

Indeed, thanks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
