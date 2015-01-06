Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 931DF7FB7
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 13:42:18 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7FCEF304048
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:42:18 -0800 (PST)
Received: from mail-pd0-f181.google.com (mail-pd0-f181.google.com
	[209.85.192.181]) by cuda.sgi.com with ESMTP id
	n5s7RFV13yda2k5B (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 11:42:17 -0800 (PST)
Received: by mail-pd0-f181.google.com with SMTP id v10so30607467pde.26
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 11:42:16 -0800 (PST)
From: Jeff Layton <jeff.layton@primarydata.com>
Date: Tue, 6 Jan 2015 11:42:05 -0800
Subject: Re: [PATCH 14/18] nfsd: pNFS block layout driver
Message-ID: <20150106114205.4151269c@synchrony.poochiereds.net>
In-Reply-To: <20150106193949.GD28003@fieldses.org>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-15-git-send-email-hch@lst.de>
	<20150106171658.GD12067@fieldses.org>
	<20150106173957.GA16200@lst.de>
	<20150106193949.GD28003@fieldses.org>
MIME-Version: 1.0
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, 6 Jan 2015 14:39:49 -0500
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Tue, Jan 06, 2015 at 06:39:57PM +0100, Christoph Hellwig wrote:
> > On Tue, Jan 06, 2015 at 12:16:58PM -0500, J. Bruce Fields wrote:
> > > > +file system must sit on shared storage (typically iSCSI) that is accessible
> > > > +to the clients as well as the server.  The file system needs to either sit
> > > > +directly on the exported volume, or on a RAID 0 using the MD software RAID
> > > > +driver with the version 1 superblock format.  If the filesystem uses sits
> > > > +on a RAID 0 device the clients will automatically stripe their I/O over
> > > > +multiple LUNs.
> > > > +
> > > > +On the server pNFS block volume support is automatically if the file system
> > > 
> > > s/automatically/automatically enabled/.
> > > 
> > > So there's no server-side configuration required at all?
> > 
> > The only required configuration is the fencing helper script if you
> > want to be able to fence a non-responding client.  For simple test setups
> > everything will just work out of the box.
> 
> I think we want at a minimum some kind of server-side "off" switch.
> 
> If nothing else it'd be handy for troubleshooting.  ("Server crashing?
> Could you turn off pnfs blocks and try again?")
> 
> --b.

Or maybe an "on" switch?

We have some patches (not posted currently) that add a "pnfs" export
option. Maybe we should add that and only enable pnfs on exports that
have that option present?

-- 
Jeff Layton <jlayton@primarydata.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
