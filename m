Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p42JW5JW245613 for <xfs@oss.sgi.com>; Mon, 2 May 2011 14:32:06 -0500
Date: Mon, 2 May 2011 15:35:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: support post-udev device mapper nodes
Message-ID: <20110502193542.GA28530@infradead.org>
References: <20110502160232.GA14457@infradead.org>
	<1304364779.3077.41.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1304364779.3077.41.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, May 02, 2011 at 02:32:59PM -0500, Alex Elder wrote:
> I'm not 100% sure I'm parsing the above right.  What
> I read is that, although we want to use the "real"
> device (not the link), the utilities tend to report
> the /dev/mapper names.  Therefore we want to use
> /dev/mapper names and internally translate them to
> their real devices.

We as in xfstests want to use whatever everyone else uses to make
our life easier for parsing mount table output, df output, etc,
and that's normally the /dev/mapper/ name.  The only thing that
can't cope with the symlink there is the _is_block_dev helper.

> > +    _dev=$1
> > +    if [ -L ${_dev} ]; then
> > +        _dev=`readlink -f ${_dev}`
> 
> Although it typically shouldn't, if the "readlink -f" fails,
> it will make _dev have an empty value...
> 
> > +    fi
> > +
> > +    if [ -b ${_dev} ]; then
> 
> ...which will lead to some sort of shell "syntax error"
> message here, which is rather unhelpful.
> 
> At a minimum, I think putting quotes around it here
> would avoid that (but you should test), i.e.,
>     if [ -b "${_dev}" ]; then

Ok.

> This and the next one appear to be junk that should
> be removed.

Indeed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
