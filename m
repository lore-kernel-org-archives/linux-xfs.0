Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7KGxuia107958 for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 12:00:08 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A8073E6710
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2009 10:00:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D1LXLzVxnLGHaOIW for
	<xfs@oss.sgi.com>; Thu, 20 Aug 2009 10:00:35 -0700 (PDT)
Message-ID: <4A8D8119.9000604@redhat.com>
Date: Thu, 20 Aug 2009 13:00:09 -0400
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: batched discard support
References: <20090816004705.GA7347@infradead.org>
	<4A8D5442.1000302@redhat.com> <4A8D5FDB.7080505@rtr.ca>
	<200908201743.50167.eike-kernel@sf-tec.de>
In-Reply-To: <200908201743.50167.eike-kernel@sf-tec.de>
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
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, Neil Brown <neilb@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Paul Mackerras <paulus@samba.org>, Mark Lord <liml@rtr.ca>, linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Ric Wheeler <rwheeler@redhat.com>

On 08/20/2009 11:43 AM, Rolf Eike Beer wrote:
> Mark Lord wrote:
>    
>> Ric Wheeler wrote:
>>      
>>> Note that returning consistent data is critical for devices that are
>>> used in a RAID group since you will need each RAID block that is used to
>>> compute the parity to continue to return the same data until you
>>> overwrite it with new data :-)
>>>
>>> If we have a device that does not support this (or is misconfigured not
>>> to do this), we should not use those devices in an MD group&  do discard
>>> against it...
>>>        
>> ..
>>
>> Well, that's a bit drastic.  But the RAID software should at least
>> not issue TRIM commands in ignorance of such.
>>
>> Would it still be okay to do the TRIMs when the entire parity stripe
>> (across all members) is being discarded?  (As opposed to just partial
>> data there being dropped)
>>      
> I think there might be a related usecase that could benefit from
> TRIM/UNMAP/whatever support in file systems even if the physical devices do
> not support that. I have a RAID5 at work with LVM over it. This week I deleted
> an old logical volume of some 200GB that has been moved to a different volume
> group, tomorrow I will start to replace all the disks in the raid with bigger
> ones. So if the LVM told the raid "hey, this space is totally garbage from now
> on" the raid would not have to do any calculation when it has to rebuild that
> but could simply write fixed patterns to all disks (e.g. 0 to first data, 0 to
> second data and 0 as "0 xor 0" to parity). With the knowledge that some of the
> underlying devices would support "write all to zero" this operation could be
> speed up even more, with "write all fixed pattern" every unused chunk would go
> down to a single write operation (per disk) on rebuild regardless which parity
> algorithm is used.
>    

In the SCSI world, RAID array vendors use "WRITE_SAME" to do this. For 
the SCSI discard, the write same command has a discard bit set if I 
remember correctly so you basically get what you are describing above.

ric

> And even if things are in use the RAID can benefit from such things. If we
> just define that every unmapped space will always be 0 when read and I write
> to a raid volume and the other part of the checksum calculation is unmapped
> checksumming becomes easy as we already know half of the values before: 0. So
> we can save the reads from the second data stripe and most of the calculation.
> "dd if=/dev/md0" on an unmapped space is more or less the same as "dd
> if=/dev/zero" than.
>
> I only fear that these things are too obviously as I would be the first to
> have this idea ;)
>
> Greetings,
>
> Eike
>    

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
