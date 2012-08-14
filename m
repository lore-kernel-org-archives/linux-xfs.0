Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7EKgJ4P001626 for <xfs@oss.sgi.com>; Tue, 14 Aug 2012 15:42:20 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id Em1TLX3n7wKkUnrn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Aug 2012 13:42:17 -0700 (PDT)
Message-ID: <502AB82D.9090408@profihost.ag>
Date: Tue, 14 Aug 2012 22:42:21 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: aborted SCSI commands while discarding/unmapping via mkfs.xfs
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, dchinner@redhat.com

Hello list,

i'm testing KVM with qemu, libiscsi, virtio-scsi-pci and scsi-general on 
top of a nexenta storage solution. While doing mkfs.xfs on an already 
used LUN / block device i discovered that the unmapping / discard 
commands mkfs.xfs sends take a long time which results in a lot of 
aborted scsi commands.

Would it make sense to let mkfs.xfs send these unmapping commands in 
small portations (f.e. 100MB) or is there another problem in the patch 
to the block device? Any suggestions or ideas?

Thanks!

Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
