Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5D3017F52
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 12:30:15 -0500 (CDT)
Date: Fri, 26 Sep 2014 12:30:14 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140926173014.GK19952@sgi.com>
References: <20140918195650.GI19952@sgi.com> <20140922222611.GZ4322@dastard>
	<5422C540.1060007@sgi.com> <20140924231024.GA4758@dastard>
	<54257D3F.70302@sgi.com> <20140926165605.GA25274@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140926165605.GA25274@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, Olaf Weber <olaf@sgi.com>, xfs@oss.sgi.com

Hey Christoph,

On Fri, Sep 26, 2014 at 09:56:05AM -0700, Christoph Hellwig wrote:
> On Fri, Sep 26, 2014 at 04:50:39PM +0200, Olaf Weber wrote:
> > >It's a chicken and egg situation. I'd much prefer we enforce clean
> > >utf8 from the start, because if we don't we'll never be able to do
> > >that. And other filesystems (e.g. ZFS) allow you to do reject
> > >anything that is not clean utf8....
> > 
> > As I understand it, this is optional in ZFS. I wonder what people's
> > experiences are with this.
> 
> It is as optional as your utf8 support for XFS is.  But they do
> enforce valid utf8 if they use utf8 normalization for file name
> comparisms, be that case sensitive or insensitive.  Take a look at the
> zfs(8) man page.

The way I'm reading that man page, it seems like with ZFS you have one
option to choose whether to use normalization:

'nomalization = "none|FormD|FormKCf"'

And a separate option to choose whether to accept non-utf8 filenames:

'utf8only = "on|off".

The default setting appears to be that ZFS does allow non-utf8
filenames.

Whereas with Olaf's series you have one option that turns normalization
on or off, and he is not giving you a choice of whether non-utf8
filenames will be accepted (they will be accepted).

So IIUC there is a distinction:  The utf8 support for ZFS is "more
optional" than the utf8 support for XFS.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
