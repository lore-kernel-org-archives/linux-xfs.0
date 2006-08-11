Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Aug 2006 18:27:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7B1QeDW014007
	for <xfs@oss.sgi.com>; Thu, 10 Aug 2006 18:26:54 -0700
Message-Id: <200608110125.LAA18091@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: cache_purge: shake on cache 0x5880a0 left 8 nodes!?
Date: Fri, 11 Aug 2006 11:30:08 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20060810164222.GA16332@wurtel.net>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Paul Slootman' <paul@wurtel.net>, xfs@oss.sgi.com

Hi Paul,

What you are seeing is fine. The current libxfs cache with the directory update code is leaving some blocks referenced,
and the libxfs code is printing out these blocks with outstanding references. 

The actual data was written to disk (prior to 2.8.10 it may not have). 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Paul Slootman
> Sent: Friday, 11 August 2006 2:42 AM
> To: xfs@oss.sgi.com
> Subject: cache_purge: shake on cache 0x5880a0 left 8 nodes!?
> 
> Hi,
> 
> I had problems due to the well-known endian bug.
> I first ran xfs_repair on it from the standard Debian package,
> version 2.6.20.  That gave a lot of output (which can be found at
> http://www.xs4all.nl/~wurtel2/xfs_repair.out.4 ).
> 
> While that was running, I got today's CVS version and built that
> (it reports version 2.8.11).  I ran that version against the
> just-repaired filesystem, and got a number of additional errors,
> notably:
> 
> empty data block 10 in directory inode 1343747104: junking block
> empty data block 11 in directory inode 1343747104: junking block
> empty data block 12 in directory inode 1343747104: junking block
> free block 16777216 entry 10 for directory ino 1343747104 bad
> rebuilding directory inode 1343747104
> 
> This 7 times; additionally, this was mentioned a couple of times:
> 
> cache_purge: shake on cache 0x5880a0 left 8 nodes!?
> 
> In fact, twice before the final "done.".
> 
> The second repair output can be found at
> http://www.xs4all.nl/~wurtel2/xfs_repair.out.4b .
> 
> Should I be worried about that?  I tried a search for "shake on cache"
> and found zero hits...
> 
> Additionally, the hash hit rates seem pretty bad. Anything to be
> worried about, and could anything be done about it?
> 
> 
> thanks,
> Paul Slootman (please CC me on responses)
> 
> 
