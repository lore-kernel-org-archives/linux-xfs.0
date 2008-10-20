Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 14:39:54 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9KLdmiv004861
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 14:39:51 -0700
Date: Mon, 20 Oct 2008 17:41:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Re: another problem with latest code drops
Message-ID: <20081020214133.GA20531@infradead.org>
References: <20081016222904.GA31761@disturbed> <48F7E7BA.4070209@sgi.com> <20081017012141.GJ25906@disturbed> <20081017020434.GD31761@disturbed> <20081017020718.GE31761@disturbed> <48FBEED9.30609@sgi.com> <20081020031757.GM31761@disturbed> <48FC0B16.9090102@sgi.com> <20081020052929.GN31761@disturbed> <20081020060522.GP31761@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020060522.GP31761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Oct 20, 2008 at 05:05:22PM +1100, Dave Chinner wrote:
> On second thoughts, the inode has not been set up properly
> by this stage, so we can't really even expect to be able to
> call iput() on it. Hmmmm - maybe the only thing we can do
> here is call security_inode_free() before xfs_idestroy.
> 
> Christoph - any opinions on what the best thing to do is?

Calling destroy_inode after exporting it seems most logical.  If we want
to undo init_inode_once we should have VFS functionality taking care
of that, too.

I've implemented this including some preparatory patches dealing with
the bulkstat issue.  It's half-way trough xfsqa so far.
