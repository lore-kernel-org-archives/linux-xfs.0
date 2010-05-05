Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o45M9t5k056550 for <xfs@oss.sgi.com>; Wed, 5 May 2010 17:09:56 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E21C94AFC4
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 15:12:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zqsjKnUs16pol6pf for
	<xfs@oss.sgi.com>; Wed, 05 May 2010 15:12:05 -0700 (PDT)
Message-ID: <4BE1ED32.7010108@sandeen.net>
Date: Wed, 05 May 2010 17:12:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Fwd: xfs - fixing wrong xfs size
References: <dbd747120904130713t7388971axf75ee779b5b1e1f2@mail.gmail.com>	<49E353FD.5060207@sandeen.net>	<dbd747120904130933i6ae66aedt7912a47b7e561f76@mail.gmail.com>
	<28465863.post@talk.nabble.com>
In-Reply-To: <28465863.post@talk.nabble.com>
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
To: Rafal Blaszczyk <blaszczykr+linux@gmail.com>
Cc: xfs@oss.sgi.com

On 05/05/2010 03:09 PM, Rafal Blaszczyk wrote:
> 
> 
> 
> On Mon, Apr 13, 2009 at 5:02 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> 
> 
>>> attempt to access beyond end of device
>>> md0: rw=0, want=123024384, limit=123023488
>>> I/O error in filesystem ("md0") meta-data dev md0 block 0x75533f8
>>
>>       ("xfs_read_buf") error 5 buf count 4096
>>>
>>> XFS: size check 2 failed
> 
> Hi,
> I've had similiar problems with md on top of lvm after converting from
> single LV to mirrored (md device). I've managed to solve it by expanding
> underlying devices by just a few megabytes. I suppose it's not your case
> because you're dealing with bare devices.
> But you could still try to experiment with xfs_growfs or other xfs_* tools.
> 
> From my case - this is not md's fault. XFS wants to have more underlying
> space than it has and it cannot be mounted.

xfs wants only as much space as it has when it was created :)

If that changes such that it is smaller, you'll get this warning at
mount time.  This is almost certainly the result of something that
happened outside xfs's control.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
