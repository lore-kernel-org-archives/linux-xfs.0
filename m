Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 28 Jun 2008 08:24:50 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5SFOmBw011331
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 08:24:48 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5433218472A3
	for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 08:25:49 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id ByOnIINMZeKeIgxE for <xfs@oss.sgi.com>; Sat, 28 Jun 2008 08:25:49 -0700 (PDT)
Date: Sat, 28 Jun 2008 17:25:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: rfc: kill ino64 mount option
Message-ID: <20080628152540.GB22484@lst.de>
References: <20080627153928.GA31384@lst.de> <20080628000914.GE29319@disturbed> <486589E7.9010705@sgi.com> <4865BEAB.4030108@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4865BEAB.4030108@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: markgw@sgi.com, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Jun 27, 2008 at 11:31:39PM -0500, Eric Sandeen wrote:
> I guess I'm ambivalent too, is it really that invasive?  Maybe 10, 15
> lines of code looks like?

Currently it's implemented by adding m_inoadd surrounded by an
#if XFS_BIG_INUMS.  This can be cleaned up by adding a helper ala

xfs_ino_t xfs_user_ino(struct xfs_mount *mp, xfs_ino_t ino);

but I don't really see the point as the option seems quite useless.  But
if others thing the option is worth keeping around I'll do the helper
instead.I'll do the helper
instead.
