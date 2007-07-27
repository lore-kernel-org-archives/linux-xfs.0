Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jul 2007 18:25:03 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6R1Otbm027224
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2007 18:24:57 -0700
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id l6R1OX1J003921
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2007 18:24:35 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id l6R1OS3T005155
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2007 18:24:28 -0700
Message-ID: <46A94963.7000103@agami.com>
Date: Thu, 26 Jul 2007 18:24:51 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Re: RFC: log record CRC validation
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com> <46A8DF7E.4090006@agami.com> <20070726233129.GM12413810@sgi.com>
In-Reply-To: <20070726233129.GM12413810@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: markgw@sgi.com, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

The log checksum code has not been used since the
development phase of xfs.  It did work at one point because I
remember using it and then decided to disable it and use just
the current cycle stamping technique.  The checksum code was
just advisory, so I could see if it ever occurred during
development.

When a CRC error is found, your suggestion is correct.  Recovery
should backup and process only completely good log records.  The code
backs up in this same fashion when it encounters a region of
missing sector updates because of the async nature of log
writes and disk caches.

At this point, I'm not convinced that xfs needs to do CRCs on
the xfs log because the size of an xfs log is relatively small.

    Michael

> Date: Wed, 25 Jul 2007 19:24:45 +1000
> From: David Chinner <dgc@sgi.com>
> To: xfs-dev <xfs-dev@sgi.com>
> Cc: xfs-oss <xfs@oss.sgi.com>
> Subject: RFC: log record CRC validation
> 
> Folks,
> 
> I've just fixed up the never-used-debug log record checksumming
> code with an eye to permanently enabling it for production
> filesystems.
> 
> Firstly, I updated the simple 32 bit wide XOR checksum to use the
> crc32c module. This places an new dependency on XFS - it will now
> depends on CONFIG_LIBCRC32C. I'm also not sure what the best
> method to use is - the little endian or big endian CRC algorithm
> so I just went for the default (crc32c()).
> 
> This then resulted in recovery failing to verify the checksums,
> and it turns out that is because xfs_pack_data() gets passed a
> padded buffer and size to checksum (padded to 512 bytes), whereas
> the unpacking (recovery) only checksummed the unpadded record
> length. Hence this code probably never worked reliably if anyone
> ever enabled it.
> 
> This does bring up a question - probably for Tim - do we only get
> rounded to BBs or do we get rounded to the log stripe unit when
> packing the log records before writeout? It seems froma quick test
> that it is only BBs, but confirmation would be good....
> 
> The next question is the hard one. What do we do when we detect
> a log record CRC error? Right now it just warns and sets a flag
> in the log. I think it should probably prevent log replay from
> replaying past this point (i.e. trim the head back to the last
> good log record) but I'm not sure what the best thing to do here.
> 
> Comments?
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
