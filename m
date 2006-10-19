Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Oct 2006 21:22:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9J4MNaG020153
	for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 21:22:26 -0700
Date: Thu, 19 Oct 2006 14:21:43 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: Xfsdump error
Message-ID: <80F9EC9DBCD1D89054F253DC@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <200610180935.k9I9ZKYD014552@smartpet.ph.liv.ac.uk>
References: <200610180935.k9I9ZKYD014552@smartpet.ph.liv.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: John Cresswell <jrc@ns.ph.liv.ac.uk>, xfs@oss.sgi.com

Hi John,

--On 18 October 2006 10:35:20 AM +0100 John Cresswell <jrc@ns.ph.liv.ac.uk> wrote:

> I hope sombody can help me with this problem.
> I have had to physically move our server, and
> though connections and tape drives are the same, backups no longer work.

OOI, Did you change anything else? The kernel or st driver?
What version of xfsdump?

> The tape drive can be written and read OK using tar, for example,
> but not using xfsdump. A truncated example follows ...
>
> xfsdump: using scsi tape (drive_scsitape) strategy
...
> xfsdump: estimated dump size: 81317119424 bytes
> xfsdump: estimated dump header size: 19318112 bytes
> xfsdump: estimated component sizes: global hdr: 1337006139379712 bytes, inomap: 81616060935045120
> bytes,  dir entries: 734544548415406080 bytes, file hdrs: 16395459996558557184 bytes, datasz:
> 578909639576387602 bytes xfsdump: drive op: init

hmmm, ridiculous size numbers but this wouldn't effect you
I don't believe.

> xfsdump: drive op: sync
> xfsdump: Media op: begin media file
> xfsdump: drive op: begin read
> xfsdump: preparing drive
> xfsdump: tape op: opening drive
> xfsdump: tape op: get status
> xfsdump: tape status = bot onl
> xfsdump: tape op: get block size info
> xfsdump: max=1048576 cur=0
> xfsdump: variable block size tape drive at /dev/st0
> xfsdump: tape op: get block size info
> xfsdump: max=1048576 cur=0
> xfsdump: recommended tape media file size set to 0x7fffffffffffffff bytes
> xfsdump: recommended tape media mark separation set to 0x1000000 bytes
> xfsdump: determining tape record size: trying 1048576 (0x100000) bytes
> xfsdump: tape op: get status
> xfsdump: tape status = bot onl
> xfsdump: tape positioned at BOT: doing redundant rewind
> xfsdump: tape op: rewind 0
> xfsdump: tape op: get status
> xfsdump: tape status = bot onl
> xfsdump: tape op: reading 1048576 bytes
> xfsdump: tape op read of 1048576 bytes failed: errno == 16 (Device or resource busy)
> xfsdump: tape op: get status
> xfsdump: tape status = onl
> xfsdump: ERROR: unexpected tape error: errno 16 nread -1 blksz 1048576 recsz 1048576 isvar 1
> wasatbot 1 eod 0 fmk 0 eot 0 onl 1 wprot 0 ew 0  xfsdump: ERROR: unexpected error from
> do_begin_read: 10

Looks like it is just doing a read of 1,048,576 bytes and failing with error 16.
Although, after the read the tape is no longer at the start (BOT).
IIRC, tar uses fairly small record sizes for I/O - 10K or so.
Perhaps you could try dd'ing various size blocks from the tape and see what works.
IIRC, Kai Makisara (scsi tape driver guy) later recommended using a block size
of 256K (262144 bytes) - reckoned that was big enough for streaming.
So you might like to try running with "-b 262144" for dump and restore.
It may not be the size of the read that is the issue, particularly since
the error code is for device busy, but it is one difference that I can think
of why tar might work but dump not here. Why it was working before, however,
is a good question then.

--Tim
