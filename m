Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Sep 2007 10:42:23 -0700 (PDT)
Received: from filer.fsl.cs.sunysb.edu (filer.fsl.cs.sunysb.edu [130.245.126.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8CHgG4p024914
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2007 10:42:19 -0700
Date: Wed, 12 Sep 2007 13:42:16 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: compression
Message-ID: <20070912174216.GA5521@filer.fsl.cs.sunysb.edu>
References: <654e62180709111643k4700c2bdibec2a16eb5446e76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <654e62180709111643k4700c2bdibec2a16eb5446e76@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jordan Mendler <jmendler@ucla.edu>
Cc: xfs@oss.sgi.com

On Tue, Sep 11, 2007 at 04:43:20PM -0700, Jordan Mendler wrote:
> Hi all,
> 
> I searched the mailing list archive and could not find an answer. We are
> currently using XFS on Linux for a 17TB Volume used for backups. We are
> running out of space, so rather than order another array, I would like to
> try to implement filesystem-level compression. Does XFS support any type of
> compression? If not, are there any other ways to optimize for more space
> storage? We are doing extensive rsyncs as our method of backups, so gzipping
> on top of the filesystem is not really an option.
 
Implementation-wise, one major thing to keep in mind is that offsets into
the uncompressed copies of files in memory need to be mapped to the
compressed ones. This is rather painful if you want to do things right
(supporting writing as well as reading from files).

As Eric mentioned, you may want to try to eliminate copies of identical
files with symlinks or even hardlinks (just make sure your backup sw is
smart enough to break links when necessary).

Josef 'Jeff' Sipek.

-- 
The reasonable man adapts himself to the world; the unreasonable one
persists in trying to adapt the world to himself. Therefore all progress
depends on the unreasonable man.
		- George Bernard Shaw
