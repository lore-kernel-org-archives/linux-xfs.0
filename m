Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 11:46:29 -0700 (PDT)
Received: from mail34.messagelabs.com (mail34.messagelabs.com [216.82.241.35])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5DIkOWt027931
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 11:46:25 -0700
Subject: Re: sunit not working
From: "Salmon, Rene" <Rene.Salmon@bp.com>
In-Reply-To: <1181690478.3758.108.camel@edge.yarra.acx>
References: <1181606134.7873.72.camel@holwrs01>
	 <1181608444.3758.73.camel@edge.yarra.acx>
	 <902286657-1181653953-cardhu_decombobulator_blackberry.rim.net-1527539029-@bxe120.bisx.prod.on.blackberry>
	 <1181690478.3758.108.camel@edge.yarra.acx>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 13 Jun 2007 13:46:20 -0500
Message-Id: <1181760380.8754.53.camel@holwrs01>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com, David Chinner <dgc@sgi.com>
Cc: salmr0@bp.com, xfs@oss.sgi.com


Hi,

More details on this:

Using dd with various block sizes to measure write performance only for
now.

This is using two options to dd. The direct I/O option for direct i/o
and the fsync option for buffered i/o.

Using direct:
/usr/bin/time -p dd of=/mnt/testfile if=/dev/zero oflag=direct 

Using fsync:
/usr/bin/time -p dd of=/mnt/testfile if=/dev/zero conv=fsync

Using a 2Gbit/sec fiber channel card my theoretical max is 256
MBytes/sec.  If we allow a bit of overhead for the card driver and
things the manufacturer claims the card should be able to max out at
around 200 MBytes/sec.

The block sizes I used range from 128KBytes - 1024000Kbytes and all the
writes generate a 1.0GB file.

Some of the results I got:

Buffered I/O(fsync):
--------------------
Linux seems to do a good job at buffering this. Regardless of the block
size I choose I always get write speeds of around 150MBytes/sec

Direct I/O(direct):
-------------------
The speeds I get here of course are very dependent on the block size I
choose and how well they align with the stripe size of the storage array
underneath. For the appropriate block sizes I get really good
performance about 200MBytes/sec.   


>From your feedback is sounds like these are reasonable numbers.
Most of our user apps do not use direct I/O but rather buffered I/O.  Is
150MBytes/sec as good as it gets for buffered I/O or is there something
I can tune to get a bit more out of buffered I/O?

Thanks 
Rene




> > 
> > Thanks that helps.  Now that I know I have the right sunit and swidth
> > I have a performace related question.
> > 
> > If I do a dd on the raw device or to the lun directy I get speeds of
> > around 190-200 MBytes/sec.
> > 
> > As soon as I add xfs on top of the lun my speeds go to around 150
> > MBytes/sec. This is for a single stream write using various block
> > sizes on a 2 Gbit/sec fiber channel card.
> > 
> 
> Reads or writes?
> What are your I/O sizes?
> Buffered or direct IO?
> Including fsync time in there or not?  etc, etc.
> 
> (Actual dd commands used and their output results would be best)
> xfs_io is pretty good for this kind of analysis, as it gives very
> fine grained control of operations performed, has integrated bmap
> command, etc - use the -F flag for the raw device comparisons).
> 
> > Is this overhead more or less what you would expect from xfs? Or is
> > there some tunning I need to do? 
> 
> You should be able to get very close to raw device speeds esp. for a
> single stream reader/writer, with some tuning.
> 
> cheers.
> 
