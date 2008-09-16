Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 16 Sep 2008 11:27:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8GIRuRS029411
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 11:27:56 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 430684459EA
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 11:29:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id BZpI1bO0cNWNGOgp for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 11:29:27 -0700 (PDT)
Date: Tue, 16 Sep 2008 14:29:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: read only remount not so happy
Message-ID: <20080916182927.GA13562@infradead.org>
References: <e03b90ae0809141904r47de6883k185174bb13df34b4@mail.gmail.com> <e03b90ae0809152103w5653bdbfrc1f060d9e41e7246@mail.gmail.com> <20080916055614.GX5811@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080916055614.GX5811@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeff Breidenbach <jeff@jab.org>, xfs@oss.sgi.com

On Tue, Sep 16, 2008 at 03:56:14PM +1000, Dave Chinner wrote:
> On Mon, Sep 15, 2008 at 09:03:41PM -0700, Jeff Breidenbach wrote:
> > This is starting to go downhill. Everything is still running, but some
> > processes that interact with the filesystem actions are performing
> > slowly.
> > 
> > ===
> > 
> > 
> > [9608310.848311] Assertion failed: atomic_read(&mp->m_active_trans) ==
> > 0, file: /build/buildd/linux-2.6.24/fs/xfs/xfs_vfsops.c, line: 708
> 
> Known problem. Race in the VFS code - fix is due in 2.6.28, I think.
> Details can be found by googling the error message.  Reboot the system.

I haven't seen anyone actually making progress on this in the VFS.  I'll
try to see if I can sort it out myself.
