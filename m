Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 15:25:59 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9TMPlmt019957
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 15:25:51 -0700
Date: Tue, 30 Oct 2007 09:25:33 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <20071029222533.GO995458@sgi.com>
References: <20070412110550.GM5967@schatzie.adilger.int> <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int> <20070419015426.GM48531920@melbourne.sgi.com> <20070430224401.GX5967@schatzie.adilger.int> <20070501042254.GD77450368@melbourne.sgi.com> <1FA8E92B-954D-4624-A089-80D4AA7399FD@cam.ac.uk> <20070502000654.GK77450368@melbourne.sgi.com> <8464EA47-03AC-4162-A2D0-683517568640@cam.ac.uk> <20071029194507.GA8578@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029194507.GA8578@webber.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, Anton Altaparmakov <aia21@cam.ac.uk>, Mike Waychison <mikew@google.com>

On Mon, Oct 29, 2007 at 01:45:07PM -0600, Andreas Dilger wrote:
> By request on #linuxfs, here is the FIEMAP spec that we used to implement
> the FIEMAP support for ext4.  There was an ext4 patch posted on August 29
> to linux-ext4 entitled "[PATCH] FIEMAP ioctl".

Link:

http://marc.info/?l=linux-ext4&m=118838241209683&w=2

That's a very ext4 specific ioctl interface. Can we get this made
generic like the FIBMAP interface so we don't have to replicate all
the copyin/copyout handling and interface definitions everywhere?
i.e. a ->extent_map aops callout to the filesystem in generic code
just like ->bmap?

> I've asked Kalpak to post
> an updated version of that patch along with the changes to the "filefrag"
> tool to use FIEMAP.

Where can I find the test program that validates the implementation?
Also, following the fallocate model, can we get the interface definition
turned into a man page before anything is submitted upstream?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
