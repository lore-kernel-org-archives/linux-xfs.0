Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 39B687F3F
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 06:51:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 28342304032
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 04:51:36 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hahxG4GmgcNfvgwQ for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2015 04:51:34 -0800 (PST)
Date: Tue, 24 Feb 2015 23:51:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: log unmount events on console
Message-ID: <20150224125120.GC4251@dastard>
References: <54EB7BDB.7080202@redhat.com> <54EB7C65.3000307@sandeen.net>
	<20150223204904.GC13522@infradead.org>
	<54EB9330.4080604@sandeen.net>
	<20150223210629.GA9370@infradead.org>
	<20150224115325.GA2356@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150224115325.GA2356@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 24, 2015 at 06:53:25AM -0500, Brian Foster wrote:
> On Mon, Feb 23, 2015 at 01:06:29PM -0800, Christoph Hellwig wrote:
> > On Mon, Feb 23, 2015 at 02:53:04PM -0600, Eric Sandeen wrote:
> > > On 2/23/15 2:49 PM, Christoph Hellwig wrote:
> > > > Oh well, even more spam during xfstest runs :)
> > > 
> > > Heh, but no review...?
> > > 
> > > I could be talked out of it, if people think it's not useful
> > > enough.
> > 
> > I can't really get excited enough either way to give a review or nak..
> > 
> 
> Heh, what verbosity is xfs_notice()? Maybe using debug level would be
> better?

The context Eric and I wanted to see this was when triaging bugs on
production systems. e.g. to know if someone unmounted a shut down
filesystem and tried to repair it before rebooting the system...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
