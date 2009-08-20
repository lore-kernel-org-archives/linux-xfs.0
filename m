Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7KEwpiM101979 for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 09:59:02 -0500
Received: from elrond.infotech.no (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86FC03E63A3
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 07:59:29 -0700 (PDT)
Received: from elrond.infotech.no (smtp.infotech.no [82.134.31.41]) by
	cuda.sgi.com with ESMTP id B5fIYXYNxfozDNde for
	<xfs@oss.sgi.com>; Thu, 20 Aug 2009 07:59:29 -0700 (PDT)
Message-ID: <4A8D64A5.9060003@interlog.com>
Date: Thu, 20 Aug 2009 10:58:45 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: batched discard support
References: <20090816004705.GA7347@infradead.org>
	<20090819203916.GA25296@elte.hu> <4A8CA956.2060406@rtr.ca>
	<4A8D5442.1000302@redhat.com>
In-Reply-To: <4A8D5442.1000302@redhat.com>
Reply-To: dgilbert@interlog.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, Neil Brown <neilb@suse.de>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Paul Mackerras <paulus@samba.org>, Mark Lord <liml@rtr.ca>, linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>

Ric Wheeler wrote:
> On 08/19/2009 09:39 PM, Mark Lord wrote:
>> [resending, after fixing the Cc: list; somebody trimmed it earlier]
>>
>> Jamie Lokier wrote:
>> ..
>>> I don't remember - does TRIM guarantee the blocks read zeros afterwards?
>> ..
>>
>> No, it doesn't.
>>
>> A drive can optionally support "deterministic TRIM", whereby it will 
>> return
>> consistent data for any given trimmed sector afterwards, but that 
>> doesn't mean zeros.
>>
>> -ml
> 
> Note that returning consistent data is critical for devices that are 
> used in a RAID group since you will need each RAID block that is used to 
> compute the parity to continue to return the same data until you 
> overwrite it with new data :-)
> 
> If we have a device that does not support this (or is misconfigured not 
> to do this), we should not use those devices in an MD group & do discard 
> against it...

A closer reading of d2015r2-ATAATAPI_Command_Set_-_2_ACS-2.pdf
section 7.10.3.2 (latest ACS-2 draft from www.t13.org) shows
that there are 3 possible variants for data read from a logical
block that has been trimmed (or "unmapped"):
    a) indeterminate
    b) determinate
    c) determinate, return all zeroes

In the case of b) the same data is returned for each
subsequent read. And that data must not be something
that has previously be written to some other LBA!

In the case of SCSI (sbc3r19.pdf) case b) is not
supported (very sensibly IMO).


Another difference I noticed between SCSI and ATA
drafts is with the SECURITY ERASE UNIT command which
is somewhat similar to the SCSI FORMAT UNIT command
(which includes a security erase option). The ATA
draft says that all blocks are determinate ("mapped"
in the SCSI state model) after a SECURITY ERASE UNIT.
The SCSI draft says that all logical blocks may be
unmapped after FORMAT UNIT.

Doug Gilbert

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
