Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7KEg4dV100317 for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 09:42:14 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 764573E653A
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 07:42:46 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id Ecnydrodf947Q9By for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2009 07:42:46 -0700 (PDT)
Subject: Re: [PATCH, RFC] xfs: batched discard support
From: James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <4A8D5FDB.7080505@rtr.ca>
References: <20090816004705.GA7347@infradead.org>
	<20090819203916.GA25296@elte.hu> <4A8CA956.2060406@rtr.ca>
	<4A8D5442.1000302@redhat.com>  <4A8D5FDB.7080505@rtr.ca>
Date: Thu, 20 Aug 2009 08:42:36 -0600
Message-Id: <1250779356.5533.15.camel@mulgrave.site>
Mime-Version: 1.0
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
To: Mark Lord <liml@rtr.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, Neil Brown <neilb@suse.de>, Ric Wheeler <rwheeler@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Paul Mackerras <paulus@samba.org>, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>

On Thu, 2009-08-20 at 10:38 -0400, Mark Lord wrote:
> Would it still be okay to do the TRIMs when the entire parity stripe
> (across all members) is being discarded?  (As opposed to just partial
> data there being dropped)

Not really.  The problem is that array verification is done at the block
level not the fs level (although, I suppose, we could change that).  So
a fully discarded stripe still has to verify OK (as in what's read for
the parity must match what's read for the data).  All of this is the
reason for the TPRZ bit for SCSI UNMAP ... and why WRITE_SAME is also
under consideration for discards in T10.

James


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
