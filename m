Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Jul 2008 23:10:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6S6AnEa031927
	for <xfs@oss.sgi.com>; Sun, 27 Jul 2008 23:10:51 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: TAKE 981875 - xfs_dm_rdwr() needs to pass a vfsmount to dentry_open()
References: <20080516045732.F12DC58C4C29@chook.melbourne.sgi.com>
	<20080516051048.GB5035@infradead.org>
	<20080520064356.GA8711@infradead.org>
	<20080726163044.GA11528@infradead.org>
Date: Mon, 28 Jul 2008 16:11:58 +1000
In-Reply-To: <20080726163044.GA11528@infradead.org> (Christoph Hellwig's
	message of "Sat, 26 Jul 2008 12:30:44 -0400")
Message-ID: <ncc3alu7d1t.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:

> Not only is this buggy stuff still there, but it also sneaked into
> linux-next were it shold be reverted ASAP.

Yep, shouldn't have gotten there, Lachlan and I are working on cleaning
the mess in the oss git tree, the pull should be made out of this one:


Cheers,
-- 
Niv Sardi
