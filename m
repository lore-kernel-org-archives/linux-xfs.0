Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7ELpS11014180 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 16:51:28 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	GhuIgXwNF6zrZHz3 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 14:51:27 -0700 (PDT)
Received: by obbup19 with SMTP id up19so1216532obb.26
	for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 14:51:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120814213535.GK2877@dastard>
References: <502AB82D.9090408@profihost.ag>
	<20120814213535.GK2877@dastard>
Date: Wed, 15 Aug 2012 07:51:26 +1000
Message-ID: <CAN05THQA8m=diOVodSyq48FVkmeOqz4KbApEP2D=wznWvD-7NQ@mail.gmail.com>
Subject: Re: aborted SCSI commands while discarding/unmapping via mkfs.xfs
From: ronnie sahlberg <ronniesahlberg@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Christoph Hellwig <hch@lst.de>, dchinner@redhat.com, Stefan Priebe <s.priebe@profihost.ag>

On Wed, Aug 15, 2012 at 7:35 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Aug 14, 2012 at 10:42:21PM +0200, Stefan Priebe wrote:
>> Hello list,
>>
>> i'm testing KVM with qemu, libiscsi, virtio-scsi-pci and
>> scsi-general on top of a nexenta storage solution. While doing
>> mkfs.xfs on an already used LUN / block device i discovered that the
>> unmapping / discard commands mkfs.xfs sends take a long time which
>> results in a lot of aborted scsi commands.
>
> Sounds like a problem with your storage being really slow at
> discards.
>
>> Would it make sense to let mkfs.xfs send these unmapping commands in
>> small portations (f.e. 100MB)
>
> No, because the underlying implementation (blkdev_issue_discard())
> already breaks the discard request up into the granularity that is
> supported by the underlying storage.....
>
>> or is there another problem in the
>> patch to the block device? Any suggestions or ideas?
>
> .... which, of course, had bugs in it so is a muchmore likely cause
> of your problems.
>
> That said,the discard granularity is derived from information the
> storage supplies the kernel in it's SCSI mode page, so if the
> discard granularity is too large, that's a storage problem, not a
> linux problem at all, let alone a mkfs.xfs problem.

Hi Dave,
That is true.

But this particular issue seen in the network traces show that on this
particular storage array,
when a huge train of discards are sent, to basically discard the entire LUN,
the storage array may take many minutes to perform these discards,
during which time the array is unresponsive to any other I/O, on the
same LUN or on other LUNs.

This is definitely an issue with the i/o scheduler in the storage
array and not strictly in the linux kernel or mkfs.xfs.

And this basically means that for these kind of arrays with this
discard behaviour, running a command that performs
a huge number of discards to discard the entire device will basically
act as a full denial-of-service attack,
since every lun and every host that is attached to the array will
experience a full outage for minutes.


This is definitely an issue with the array, BUT linux kernel and/or
userspace utilities can, and very often are,
implement tweaks to be more firendly towards and avoid triggering
unfortunate hw behaviour.

For example, linux kernel contains a "fix" for the pentium FDIV bug,
eventhoug there was never any issue in linux that needed fixing.


The only other realistic alternative is to provide warnings such as :
"Some storage arrays may have major performance problems if you run
mkfs.xfs that can cause a full outage for every single lun on that
array that lasts for many minutes.  Unless you KNOW that your storage
arrray does not have such issue for a fact, you should never run
mkfs.xfs on a production system outside of a full scheduled outage
window. The full set of storage arrays where this is a potential issue
is not known".


I think it would be more storage array friendly to implement tweaks to
avoid triggering such issue son this, and possibly other arrays.



regards
ronnie sahlberg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
