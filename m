Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3CFC47F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 07:03:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE31DAC005
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 05:03:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1n5wugP1kA7WcM3M (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2015 05:03:48 -0800 (PST)
Date: Tue, 24 Feb 2015 08:03:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: log unmount events on console
Message-ID: <20150224130321.GB2356@laptop.bfoster>
References: <54EB7BDB.7080202@redhat.com> <54EB7C65.3000307@sandeen.net>
	<20150223204904.GC13522@infradead.org>
	<54EB9330.4080604@sandeen.net>
	<20150223210629.GA9370@infradead.org>
	<20150224115325.GA2356@laptop.bfoster>
	<20150224125120.GC4251@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150224125120.GC4251@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 24, 2015 at 11:51:20PM +1100, Dave Chinner wrote:
> On Tue, Feb 24, 2015 at 06:53:25AM -0500, Brian Foster wrote:
> > On Mon, Feb 23, 2015 at 01:06:29PM -0800, Christoph Hellwig wrote:
> > > On Mon, Feb 23, 2015 at 02:53:04PM -0600, Eric Sandeen wrote:
> > > > On 2/23/15 2:49 PM, Christoph Hellwig wrote:
> > > > > Oh well, even more spam during xfstest runs :)
> > > > 
> > > > Heh, but no review...?
> > > > 
> > > > I could be talked out of it, if people think it's not useful
> > > > enough.
> > > 
> > > I can't really get excited enough either way to give a review or nak..
> > > 
> > 
> > Heh, what verbosity is xfs_notice()? Maybe using debug level would be
> > better?
> 
> The context Eric and I wanted to see this was when triaging bugs on
> production systems. e.g. to know if someone unmounted a shut down
> filesystem and tried to repair it before rebooting the system...
> 

I guess that makes sense on a clean reboot, less so if the shutdown is a
rootfs and leads to a panic or something of that sort (and what does a
umount matter once the fs is shutdown?).

Anyways, it's not a common operation and if the extra xfstests logging
is the most significant tradeoff then it seems harmless to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
