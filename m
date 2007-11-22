Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 16:49:28 -0800 (PST)
Received: from mx1.suse.de (ns1.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAM0nInH016510
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 16:49:23 -0800
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
From: Andi Kleen <andi@firstfloor.org>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com>
Date: Thu, 22 Nov 2007 01:49:25 +0100
In-Reply-To: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> (David Chinner's message of "Thu\, 22 Nov 2007 11\:33\:39 +1100")
Message-ID: <p73oddnhzoq.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

David Chinner <dgc@sgi.com> writes:

> To ensure that log I/O is issued as the highest priority I/O, set
> the I/O priority of the log I/O to the highest possible. This will
> ensure that log I/O is not held up behind bulk data or other
> metadata I/O as delaying log I/O can pause the entire transaction
> subsystem. Introduce a new buffer flag to allow us to tag the log
> buffers so we can discrimiate when issuing the I/O.

Won't that possible disturb other RT priority users that do not need 
log IO (e.g. working on preallocated files)? Seems a little
dangerous.

I suspect you want a "higher than bulk but lower than RT" priority
for this really unless there is any block RT priority task waiting
for log IO (but keeping track of the later might be tricky) 

-Andi
