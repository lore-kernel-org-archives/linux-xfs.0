Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pATJZCpA094048 for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 13:35:12 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5949719E844F
	for <xfs@oss.sgi.com>; Tue, 29 Nov 2011 11:35:11 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7Emryq5LRJeBtL0H for <xfs@oss.sgi.com>;
	Tue, 29 Nov 2011 11:35:11 -0800 (PST)
Date: Tue, 29 Nov 2011 14:35:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: sync() in 2.6.38.5
Message-ID: <20111129193510.GA8848@infradead.org>
References: <CAOO4vO6sSFBxXXK1z018=ekEZpcpnZ5NT_xe3d503NjN3aHF5A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOO4vO6sSFBxXXK1z018=ekEZpcpnZ5NT_xe3d503NjN3aHF5A@mail.gmail.com>
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
To: Paul Anderson <pha@umich.edu>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Nov 29, 2011 at 02:17:26PM -0500, Paul Anderson wrote:
> Hi all,
> 
> 2.6.38.5 (x64 intel, in todays case a 40TiByte SAN volume) appears to
> have a bug whereby not all active metadata will be flushed even on a
> quiescent machine (one that has nonetheless in the past been under
> very high load).
> 
> We have tried several variations of clean shutdowns, combined with for
> example the "echo 3 >/proc/sys/vm/drop_caches" trick to no avail - we
> still get lost files (well, 0 length files).
> 
> We have several big servers scheduled to go down shortly, and I was
> wondering if there are other ideas besides just coping all recent data
> to another server.

I'd really love to debug this.  We had a few reports of this issue
before, but I've neber been able to pinpoint it.  Do you remember
anything specific to the workload touching these files?

To be save I'd rsync data off the first one going down.  Can you try
to do an explicit fsync for every file, like

	find | xargs /usr/sbin/xfs_io -c 'fsync'

and see if that helps?  Answering that question would help us greatly
to pinpoint down the issue.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
