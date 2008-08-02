Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Aug 2008 08:30:22 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m72FUK3R011567
	for <xfs@oss.sgi.com>; Sat, 2 Aug 2008 08:30:21 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBD8C1972F01
	for <xfs@oss.sgi.com>; Sat,  2 Aug 2008 08:31:33 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id Tp0wGIyr9dOUxEEY for <xfs@oss.sgi.com>; Sat, 02 Aug 2008 08:31:33 -0700 (PDT)
Date: Sat, 2 Aug 2008 17:31:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/21] implement generic xfs_btree_rshift
Message-ID: <20080802153135.GD19689@lst.de>
References: <20080729193125.GP19104@lst.de> <20080730060808.GP13395@disturbed> <20080801194914.GI1263@lst.de> <20080802012042.GN6201@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802012042.GN6201@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Sat, Aug 02, 2008 at 11:20:42AM +1000, Dave Chinner wrote:
> > It's the only leakage of the detailed inode root implementation into
> > the generic code, so I'm still wondering whether a method would be
> > better.
> 
> Ah, right. yes, it probably would be cleaner to do it as a
> separate method, but ?? don't think it's that important right now.

That's why I left the XXX in, this is something to get right eventually,
just not now :)
