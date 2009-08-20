Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7KHIvnv108841 for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 12:19:07 -0500
Received: from qw-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F1F93E71F4
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 10:19:24 -0700 (PDT)
Received: from qw-out-1920.google.com (qw-out-1920.google.com [74.125.92.146])
	by cuda.sgi.com with ESMTP id X9L7tD9oGLdf8A1J for
	<xfs@oss.sgi.com>; Thu, 20 Aug 2009 10:19:24 -0700 (PDT)
Received: by qw-out-1920.google.com with SMTP id 5so28617qwf.32
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 10:19:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A8D60C1.6000809@redhat.com>
References: <20090816004705.GA7347@infradead.org>
	<20090819203916.GA25296@elte.hu> <4A8CA956.2060406@rtr.ca>
	<4A8D5442.1000302@redhat.com> <4A8D5FDB.7080505@rtr.ca>
	<4A8D60C1.6000809@redhat.com>
Date: Thu, 20 Aug 2009 13:19:20 -0400
Message-ID: <87f94c370908201019i406e74a0s59c67f56ec2c9c16@mail.gmail.com>
Subject: Re: [PATCH, RFC] xfs: batched discard support
From: Greg Freemyer <greg.freemyer@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, Neil Brown <neilb@suse.de>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Paul Mackerras <paulus@samba.org>, Mark Lord <liml@rtr.ca>, linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>

On Thu, Aug 20, 2009 at 10:42 AM, Ric Wheeler<rwheeler@redhat.com> wrote:
> On 08/20/2009 10:38 AM, Mark Lord wrote:
>>
>> Ric Wheeler wrote:
>>>
>>> Note that returning consistent data is critical for devices that are
>>> used in a RAID group since you will need each RAID block that is used
>>> to compute the parity to continue to return the same data until you
>>> overwrite it with new data :-)
>>>
>>> If we have a device that does not support this (or is misconfigured
>>> not to do this), we should not use those devices in an MD group & do
>>> discard against it...
>>
>> ..
>>
>> Well, that's a bit drastic. But the RAID software should at least
>> not issue TRIM commands in ignorance of such.
>
> If the storage can return different data in a sequence of READ requests of
> the same sector (with no writes), there is nothing RAID could do. It would
> see total garbage...
>
>> Would it still be okay to do the TRIMs when the entire parity stripe
>> (across all members) is being discarded? (As opposed to just partial
>> data there being dropped)
>
> This should be safe if the MD bitmaps would prevent us from trying to
> READ/regenerate parity for that stripe...
>
> ric

The harder thing for mdraid is putting a stripe back in service.  If
even a single sector is written to a "discarded" stripe, the entire
stripe has to be written with determinate data that has the right
parity.

ie. Only full stripes can be discarded and only full-stripes can be
put back in service.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Paper -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
