Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 04:00:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m38B0bMP002696
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 04:00:39 -0700
Date: Tue, 8 Apr 2008 12:41:53 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: new xfsqa mismatches
Message-ID: <20080408104152.GA23535@lst.de>
References: <20080407100140.GA11891@lst.de> <20080407215539.GC108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407215539.GC108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Apr 08, 2008 at 07:55:39AM +1000, David Chinner wrote:
> If other ppl sent xfsqa patches to the oss list, then you'd see that
> a patch to fix this was sent out for review yesterday....

Seen the commit now, but yes folks please send more patches to the list
for review!

> > 130 and 132 expetect Bytes in various places but get bytes from xfs_io
> > from CVS
> 
> What's the error output? I've not seen that one....


130     [   72.086853] XFS mounting filesystem hdd
 - output mismatch (see 130.out.bad)
20c20
< XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
---
> 3 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)
24c24
< XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
---
> 1000.000000 bytes, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)

and so one for lots of lines
