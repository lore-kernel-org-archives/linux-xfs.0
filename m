Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 06:29:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m39DTCdj017000
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 06:29:14 -0700
Date: Wed, 9 Apr 2008 09:29:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Lost+found
Message-ID: <20080409132945.GA25114@infradead.org>
References: <1207632033.11530.10.camel@localhost.localdomain> <op.t9bm23aa3jf8g2@pc-bnaujok.melbourne.sgi.com> <alpine.DEB.1.10.0804090628080.322@p34.internal.lan> <47FCC071.40201@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FCC071.40201@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Barry Naujok <bnaujok@sgi.com>, Jeffrey Sandel <webmaster@javainbaja.com>, xfs@oss.sgi.com

On Wed, Apr 09, 2008 at 08:11:13AM -0500, Eric Sandeen wrote:
> The whole reason they're in lost+found is because they are "orphaned" -
> allocated & in use but not referenced by any directory... so the best
> xfs_repair can do is rename to lost+found with the inode number.

At least until we get parent pointers.  Niv, any updates?
