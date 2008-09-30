Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Sep 2008 02:32:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8U9W9tJ029769
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2008 02:32:11 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD9A2497432
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2008 02:33:44 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id pZBIkbjZ0kPcjS3G for <xfs@oss.sgi.com>; Tue, 30 Sep 2008 02:33:44 -0700 (PDT)
Date: Tue, 30 Sep 2008 11:33:43 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] Remove restricted_chown parameter
Message-ID: <20080930093343.GA22444@lst.de>
References: <20080929215325.GB30363@lst.de> <48E15869.6080506@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E15869.6080506@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Sep 29, 2008 at 05:36:25PM -0500, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > From: Tim Shimmin <tes@sgi.com>
> > 
> > On Linux all filesystems are supposed to be operating under
> > Posix' restricted chown. Restricted chown means it restricts
> > chown to the owner unless you have CAP_FOWNER.
> > 
> > [hch: forward-ported to the current tree]
> > 
> > Signed-off-by: Tim Shimmin <tes@sgi.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks fine to me, but you should also update
> Documentation/filesystems/xfs.txt too, and remove the docs for the knob
> (or maybe mark it obsolete, w/ the above explanation?)

Makes sense, I'll update it.
