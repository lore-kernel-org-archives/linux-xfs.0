Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CDDEqS257434 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 07:13:15 -0600
Date: Thu, 12 Jan 2012 08:13:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 278: Ensure lost+found is not created with
	wrong link count (V3)
Message-ID: <20120112131308.GA24842@infradead.org>
References: <1326288901-8171-1-git-send-email-cmaiolino@redhat.com>
	<4F0E0A19.6020305@sgi.com>
	<20120112110523.GA1798@andromeda.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120112110523.GA1798@andromeda.usersys.redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Thu, Jan 12, 2012 at 09:05:23AM -0200, Carlos Maiolino wrote:
> > >+xfs_repair  $SCRATCH_DEV&>>  $seq.full
> > 
> > Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> > 
> > As mentioned before, &>> does not work on bash 3.x, the test looks good.
> > 
> Yes, Mark and I discussed about it, but, since the patch is going upstream, I
> thought would be better to leave it as-is, once most newer distros are using
> bash 4, but, I have no concerns in change it if needed.

xfstests should work on all sorts of distros.  Please resend it without
that operator.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
