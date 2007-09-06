Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Sep 2007 09:10:16 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l86GA94p026102
	for <xfs@oss.sgi.com>; Thu, 6 Sep 2007 09:10:12 -0700
Date: Thu, 6 Sep 2007 12:10:06 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: [xfs-masters] [Bug 768]  New: Move restrict_chown to
	mount-time option
Message-ID: <20070906161006.GA25035@filer.fsl.cs.sunysb.edu>
References: <200709051831.l85IVsTR016106@oss.sgi.com> <20070906153529.GA3062@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906153529.GA3062@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: nick.couchman@seakr.com, xfs@oss.sgi.com

On Thu, Sep 06, 2007 at 05:35:29PM +0200, Christoph Hellwig wrote:
> On Wed, Sep 05, 2007 at 11:31:54AM -0700, bugzilla-daemon@oss.sgi.com wrote:
> > We've run into a situation where it would be extremely advantageous to be able
> > to restrict_chown on certain volumes on a server but not on others.  I'm not
> > real familiar with kernel internals, programming, etc., but I'd like to suggest
> > that restrict_chown be made a mount option for an XFS filesystem instead of a
> > system-wide, sysctl/proc option.  This would allow finer control over which
> > filesystems restrict giving away files and which don't.
> 
> It's quite easily doable.  I don't have time for that right now, but if
> anyone wants to do it's just adding the option to the mount option
> parser and adding a flag to the mount structure.
 
Wouldn't making this a generic mount-option make sense? Or is it far too
low-level of a concept?

Josef 'Jeff' Sipek.

-- 
I already backed up the [server] once, I can do it again.
