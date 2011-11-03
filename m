Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3A6rid258113 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 05:06:53 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C86E1CDD60A
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 03:06:52 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	EIOvYUexDh2CzGLP for <xfs@oss.sgi.com>;
	Thu, 03 Nov 2011 03:06:52 -0700 (PDT)
Date: Thu, 3 Nov 2011 06:06:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] xfs: serialise unaligned direct IOs
Message-ID: <20111103100647.GA1002@infradead.org>
References: <CADDb1s0WUfvt8N+hMATboKxbMUZdk2N-R2e=KFH2JvGUjbigBg@mail.gmail.com>
	<20111103070246.GA10579@infradead.org>
	<CADDb1s3UN4HMKEA2kSEM0HsUCC7DE63B1oJAoL6QpqXBdDCEqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDb1s3UN4HMKEA2kSEM0HsUCC7DE63B1oJAoL6QpqXBdDCEqQ@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Nov 03, 2011 at 03:29:18PM +0530, Amit Sahrawat wrote:
> > You probably should keep the original Signoff and reviewed-by tags,
> > and add your editor note on the top into [ ] ?brackets.
> Ok, will do so in the final patch. Actually was unaware of information
> to keep in backported patches?

The standard procedure is to keep patches basically as-is.  This doesn't
quite apply for your case, so I think just adding a comment in 
[ ] brackets on the top is the best you can do.

> > You also need to make the i_mutex unlock and need_i_mutex update
> > conditional here, otherwise you still serialize all O_DIRECT writes.
> >
> you mean, keeping need_i_mutex=0 and mutex_unlock as part of 'else' statement.

Yes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
