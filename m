Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q78A8DZO240389 for <xfs@oss.sgi.com>; Wed, 8 Aug 2012 05:08:14 -0500
Received: from ppsw-41.csi.cam.ac.uk (ppsw-41.csi.cam.ac.uk [131.111.8.141])
	by cuda.sgi.com with ESMTP id BoHVJr3dTKFecf03 for
	<xfs@oss.sgi.com>; Wed, 08 Aug 2012 03:08:12 -0700 (PDT)
Received: from mail.mrc-lmb.cam.ac.uk ([131.111.85.9]:48870
	helo=mail.lmb.internal)
	by ppsw-41.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.136]:25)
	with esmtp id 1Sz3BT-0001HD-Rv (Exim 4.72) for xfs@oss.sgi.com
	(return-path <dhoworth@mrc-lmb.cam.ac.uk>);
	Wed, 08 Aug 2012 11:08:11 +0100
Received: from cpepc210-3.lmb.internal ([10.14.0.2])
	by mail.lmb.internal with esmtp (Exim 4.63)
	(envelope-from <dhoworth@mrc-lmb.cam.ac.uk>) id 1Sz3BS-0006Fl-I9
	for xfs@oss.sgi.com; Wed, 08 Aug 2012 11:08:10 +0100
Message-ID: <50223A8A.8090009@mrc-lmb.cam.ac.uk>
Date: Wed, 08 Aug 2012 11:08:10 +0100
From: Dave Howorth <dhoworth@mrc-lmb.cam.ac.uk>
MIME-Version: 1.0
Subject: Re: xfs hang when filesystem filled
References: <CAJ-WH_z+6HhooORtMKeO2=kURyiWMcxk_5eUbeBSz3cAXgRRfQ@mail.gmail.com>	<271150ABBD47B14585A108DF56142AEE70E74536@icexch-m1.ic.ac.uk>
	<CAJ-WH_yJcUYwpXQnUJVNkQSvpGg1+AD4g-As=pAb_3QAoqAWog@mail.gmail.com>
In-Reply-To: <CAJ-WH_yJcUYwpXQnUJVNkQSvpGg1+AD4g-As=pAb_3QAoqAWog@mail.gmail.com>
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

Guk-Bong, Kwon wrote:
> why server hang or reset ?
> 
> I expect some warning/error message like "No space left on device"
> 
> and then I hope server is ok

NFS has always been awkward in limit conditions like this. People just
learn to stay away from such boundary conditions if they want reliable
servers, for this and other good reasons already mentioned.

> 2012/8/7 Burbidge, Simon A <s.burbidge@imperial.ac.uk>:
>> Hi Kwon,
>> I'd suggest that the asynchronous nature of NFS means that you've got all the nfs threads on the client waiting on a response from
>> the NFS server. The server is in trouble because you've no free blocks and nfs has also filled up your buffer cache with data blocks and the
>> nfs server threads have blocked waiting on this.
>> While xfs might still be responsive on the server, it may very slow as it scrabbles around for the last free block.
>>
>> In my experience, in any situation with NFS where the server filesystem fills up completely, you'll get a hang.
>> Sometimes you can free space by removing files, sometimes the server is unresponsive and you have to reset.

What Simon said.

Cheers, Dave

PS  It would be lovely if you could trim your posts :)  Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
