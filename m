Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3D4k9V018785 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 07:04:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3BDC1B92AB4
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 05:04:45 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VrvMtPJXXOhh6PgK for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2008 05:04:45 -0800 (PST)
Date: Wed, 3 Dec 2008 08:04:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: New XFS git tree on oss.sgi.com
Message-ID: <20081203130414.GB9681@infradead.org>
References: <492BA7AD.5080007@sgi.com> <20081125140553.GA16553@infradead.org>
	<492CA245.3000709@sgi.com> <20081126032710.GA19523@infradead.org>
	<ncctz9llxzq.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ncctz9llxzq.fsf@itchy.melbourne.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Niv Sardi <xaiki@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 03, 2008 at 02:48:57PM +1100, Niv Sardi wrote:
> > Also
> > http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=commitdiff;h=ca830fdf6231d0683f4ea4e9223e234c3a509063doesn't seem to be needed.  None of those symbols seems to be used by
> > either dmapi or xfsidbg, the only two modules using xfs symbols in the
> > tree.
> 
> That's exactly why it's there, the revertion is actually moving from
> what was in ptools to something sane.

??  The commit above adds tons of unused exports.  But hey, I'll just
submit a patch to sort it out when I get some time..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
