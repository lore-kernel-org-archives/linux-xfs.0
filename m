Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Sep 2007 11:33:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8HIWwuw006299
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2007 11:33:00 -0700
Message-ID: <46EEC855.7010101@sandeen.net>
Date: Mon, 17 Sep 2007 13:32:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V2] fix 32-bit compat ioctls for GETXFLAGS, SETXFLAGS,
 GETVERSION
References: <46EDDCA7.5030601@sandeen.net> <46EEBB02.9050507@sandeen.net> <20070917180851.GA26874@infradead.org>
In-Reply-To: <20070917180851.GA26874@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, Sep 17, 2007 at 12:36:02PM -0500, Eric Sandeen wrote:
>> Also, for both native and compat versions, just define them to
>> the values as defined in fs.h
> 
> Should we just kill the XFS_ variants?
> 
> Otherwise the patch looks good.
> 

perhaps.  It looks like ext3 tried to move GETVERSION, too, though
generic kernel variant still uses the "old" one.

-Eric
