Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o45K7KgN052556 for <xfs@oss.sgi.com>; Wed, 5 May 2010 15:07:20 -0500
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EA271BD4CE3
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 13:09:28 -0700 (PDT)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by
	cuda.sgi.com with ESMTP id EN57YOvciPBrVMRK for
	<xfs@oss.sgi.com>; Wed, 05 May 2010 13:09:28 -0700 (PDT)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>) id 1O9kuO-0002wM-0U
	for xfs@oss.sgi.com; Wed, 05 May 2010 13:09:28 -0700
Message-ID: <28465863.post@talk.nabble.com>
Date: Wed, 5 May 2010 13:09:27 -0700 (PDT)
From: Rafal Blaszczyk <blaszczykr+linux@gmail.com>
Subject: Re: Fwd: xfs - fixing wrong xfs size
In-Reply-To: <dbd747120904130933i6ae66aedt7912a47b7e561f76@mail.gmail.com>
MIME-Version: 1.0
References: <dbd747120904130713t7388971axf75ee779b5b1e1f2@mail.gmail.com>
	<49E353FD.5060207@sandeen.net>
	<dbd747120904130933i6ae66aedt7912a47b7e561f76@mail.gmail.com>
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
To: xfs@oss.sgi.com




On Mon, Apr 13, 2009 at 5:02 PM, Eric Sandeen <sandeen@sandeen.net> wrote:


> > attempt to access beyond end of device
> > md0: rw=0, want=123024384, limit=123023488
> > I/O error in filesystem ("md0") meta-data dev md0 block 0x75533f8
>
>       ("xfs_read_buf") error 5 buf count 4096
> >
> > XFS: size check 2 failed

Hi,
I've had similiar problems with md on top of lvm after converting from
single LV to mirrored (md device). I've managed to solve it by expanding
underlying devices by just a few megabytes. I suppose it's not your case
because you're dealing with bare devices.
But you could still try to experiment with xfs_growfs or other xfs_* tools.

>From my case - this is not md's fault. XFS wants to have more underlying
space than it has and it cannot be mounted.
-- 
View this message in context: http://old.nabble.com/xfs---fixing-wrong-xfs-size-tp23023562p28465863.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
