Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B0377F52
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 08:27:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 26B42304059
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 06:27:10 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QtpzI21on6u2WoKN for
	<xfs@oss.sgi.com>; Fri, 22 Nov 2013 06:27:09 -0800 (PST)
Message-ID: <528F69A3.7060608@redhat.com>
Date: Fri, 22 Nov 2013 09:26:43 -0500
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfs: set block device logical sector size on
	xfs_buftarg
References: <5283C41D.7070503@redhat.com>
	<20131113185645.GA20869@infradead.org>
	<5283CE2E.2070702@sandeen.net> <20131113212658.GJ6188@dastard>
	<20131114133749.GA26268@infradead.org>
	<5284E484.6090001@sandeen.net> <20131114210156.GP6188@dastard>
	<528F66A4.7060200@redhat.com>
	<20131122142022.GC14680@infradead.org>
In-Reply-To: <20131122142022.GC14680@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, Eric Sandeen <sandeen@redhat.com>

On 11/22/2013 09:20 AM, Christoph Hellwig wrote:
> On Fri, Nov 22, 2013 at 09:13:56AM -0500, Ric Wheeler wrote:
>> I think you do that by using SCSI debug to get a 4K sector drive -
>> that is how we tested for RHEL6 for example.  Layering on
>> restrictions to hardware in the file system seems a bit harsh.
>>
>> The QEMU crowd will be working to get better support for 4K drives
>> in the future, but I think that we are effectively going to cause a
>> huge field issue here since these 512/4K drives are extremely
>> common..
>>
>> Given the SCSI debug method for this, does that mean you retract
>> your objections and will support Eric's patch :) ?
> We actually have a test for 4k drives using scsi_debug in xfstests: xfs/279.
>

Just to add on here. we are going to work more closely with the kvm/qemu people 
to make sure that they properly take care of the hints about alignment and so on 
(thanks to you for putting that in!).

Ric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
