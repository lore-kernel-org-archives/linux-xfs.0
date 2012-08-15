Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7F6VNJB087678 for <xfs@oss.sgi.com>; Wed, 15 Aug 2012 01:31:23 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id 9qGBChsp0ZEhqDN1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 23:31:21 -0700 (PDT)
Message-ID: <502B4232.7090308@profihost.ag>
Date: Wed, 15 Aug 2012 08:31:14 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: aborted SCSI commands while discarding/unmapping via mkfs.xfs
References: <502AB82D.9090408@profihost.ag> <20120814213535.GK2877@dastard>
In-Reply-To: <20120814213535.GK2877@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: dchinner@redhat.com, Christoph Hellwig <hch@lst.de>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 14.08.2012 23:35, schrieb Dave Chinner:
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

Thanks for this excelent explanation.

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
