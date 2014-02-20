Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EAA6D7FBA
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 15:15:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D491C304064
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 13:15:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id z2ZUmZOP0jp8yv8C (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 13:14:59 -0800 (PST)
Date: Thu, 20 Feb 2014 13:14:57 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 04/11] xfs: update inode allocation/free transaction
	reservations for finobt
Message-ID: <20140220211457.GA8476@infradead.org>
References: <1391536182-9048-1-git-send-email-bfoster@redhat.com>
	<1391536182-9048-5-git-send-email-bfoster@redhat.com>
	<20140211064609.GE13647@dastard> <530393F8.4070106@redhat.com>
	<20140220020101.GL4916@dastard> <53064E26.2050607@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53064E26.2050607@redhat.com>
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
Cc: xfs@oss.sgi.com

On Thu, Feb 20, 2014 at 01:49:10PM -0500, Brian Foster wrote:
> > Right, that can happen. But my question is this: how realistic is it
> > that we have someone who has ENOSPC because of enough zero length
> > files to trigger this? I've never seen an application or user try to
> > store any significant number of zero length files, so I suspect this
> > is a theoretical problem, not a practical one.
> > 
> 
> Probably not very realistic. ;) The only thing I know that does rely on
> some zero-length files is gluster distribution to represent "link files"
> when one a file that hashes to one server ends up stored on another.
> Even then, I don't see how we would ever have a situation where those
> link files exist in such massive numbers and are removed in bulk. So
> it's likely a pathological scenario.

Zero data blocks are the only case for device nodes or fifos, very
common for symlinks that can be stored inline, and not unusual for
directories.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
