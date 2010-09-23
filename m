Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8N8t4NI117354 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 03:55:04 -0500
Received: from opencube.bzctoons.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 732DCE5204D
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 02:08:30 -0700 (PDT)
Received: from opencube.bzctoons.net (opencube-2.bzctoons.net
	[88.191.104.187]) by cuda.sgi.com with ESMTP id
	rsP1LVVs9G9Xtwp5 for <xfs@oss.sgi.com>;
	Thu, 23 Sep 2010 02:08:30 -0700 (PDT)
Received: from localhost (opencube.bzctoons.net.local [127.0.0.1])
	by opencube.bzctoons.net (Postfix) with ESMTP id 2529A90AA4
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 10:55:56 +0200 (CEST)
Received: from opencube.bzctoons.net ([127.0.0.1])
	by localhost (opencube.bzctoons.net [127.0.0.1]) (amavisd-maia,
	port 10024) with ESMTP id 30622-03 for <xfs@oss.sgi.com>;
	Thu, 23 Sep 2010 10:55:55 +0200 (CEST)
Received: from [192.168.16.148] (opencube03.pck.nerim.net [62.212.120.41])
	(Authenticated sender: mathieu.avila@opencubetech.com)
	by opencube.bzctoons.net (Postfix) with ESMTPA id 3162390A92
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 10:55:55 +0200 (CEST)
Message-ID: <4C9B161A.1010301@opencubetech.com>
Date: Thu, 23 Sep 2010 10:55:54 +0200
From: Mathieu AVILA <mathieu.avila@opencubetech.com>
MIME-Version: 1.0
Subject: Re: Question regarding performance on big files.
References: <4C979439.7070906@opencubetech.com>	<4C97BA74.5030304@hardwarefreak.com>	<4C99D9EB.20800@opencubetech.com>
	<4C9A69DC.8020606@hardwarefreak.com>
In-Reply-To: <4C9A69DC.8020606@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8256460560349620395=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============8256460560349620395==
Content-Type: multipart/alternative;
 boundary="------------050200090204020605040100"

This is a multi-part message in MIME format.
--------------050200090204020605040100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

  Things are going to be solved.
I share information here for others that would run into the same troubles.

1/ Changing the BIOS back to an older version (AMI 1.1 instead of AMI 
2.0) masked the issue (I/O management somewhere in the controller ?) . 
But this is not satisfying, as an older BIOS may not handle correctly my 
hardware. An older version may crash the box due to hardware/software 
incompatibility.
However, no warning/error message from the kernel: from its POV, 
everything is fine. So I switched back to the recent version.

2/ I had set very hard values for page cache:
     vm.dirty_ratio = 3
     vm.dirty_background_ratio = 0
In my case, on a 6GB server, this lets 184 MB to the page cache. This is 
really low, but it's done willingly to avoid caching too much and have 
the kernel start flushing too much. The counter-part is that when my 
filesystem needs to flush a lot a meta-data pages, then the page cache 
is filled and the whole application is frozen, waiting for those I/Os to 
be completed.
With those parameters:
     vm.dirty_ratio = 20
     vm.dirty_background_ratio = 5
The small writes are amortized in the stream of data writes from the 
application, and the application is not frozen.
(so you were right: there was a page cache issue)

The question stands: my does XFS generates such a bunch of small I/O 
writes throughout the disk at around 688GB ?

My fstab mount options are classical ones:
"defaults,nobarrier,noatime,nodiratime"

Maybe the software RAID 0 has helped triggering the problem, too: I 
don't know if writes on a RAID can generate more I/O than on direct 
disk. I guess so (I/O fragmentation), but that's only a guess.

--
Mathieu Avila


Le 22/09/2010 22:41, Stan Hoeppner a écrit :
> Mathieu AVILA put forth on 9/22/2010 5:26 AM:
>
>> I have run my test again with default parameters for mkfs.
>> I still have this issue. For 20 seconds, the writes are either stalled,
>> or very slow.
>> I have run "vmstat" at the same time than "dd", and it appears that the
>> block device continues to receive write requests, while "dd" is blocked
>> in the kernel.
>> With blktrace, I can see that during this period of time, the block
>> receives a lot of small write requests throughout the volume ranging
>> from the start till the point where the file has stopped writing. During
>> the other periods of time, the volume is written normally, starting at
>> offset 0 and filling the disk continuously.
> What happens with "dd if=/dev/zero of=/DATA/big oflag=direct"?  You said
> the copy is hanging in the kernel.  Maybe a buffer cache issue?
>
> What fstab mount options are you using for this filesystem?
>
>> Could this be an effect of tree rebalancing for extents management (both
>> inode of big file and free space trees) ? Can it be a hardware problem ?
>> Have you ever seen that issue before ?
> WRT tree rebalancing, that's beyond my knowledge level and someone else
> will need to jump into this thread.  If it's a hardware problem you
> should be seeing something in dmesg or the kernel log, or both.  If
> you're not seeing controller or device errors it's probably not a
> hardware problem.  Have you tried this same test with only one of those
> two 500GB drives, no mdraid stripe?  That would eliminate any possible
> issues with your mdraid implementation.  Speaking of which, could you
> please share your mdraid parameters for this stripe set?  That could be
> a factor as well.
>


-- 
*Mathieu Avila*
IT & Integration Engineer
mathieu.avila@opencubetech.com

OpenCube Technologies http://www.opencubetech.com
Parc Technologique du Canal, 9 avenue de l'Europe
31520 Ramonville St Agne - FRANCE
Tel. : +33 (0) 561 285 606 - Fax : +33 (0) 561 285 635

--------------050200090204020605040100
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#ffffff" text="#000000">
    Things are going to be solved.<br>
    I share information here for others that would run into the same
    troubles.<br>
    <br>
    1/ Changing the BIOS back to an older version (AMI 1.1 instead of
    AMI 2.0) masked the issue (I/O management somewhere in the
    controller ?) . But this is not satisfying, as an older BIOS may not
    handle correctly my hardware. An older version may crash the box due
    to hardware/software incompatibility. <br>
    However, no warning/error message from the kernel: from its POV,
    everything is fine. So I switched back to the recent version.<br>
    <br>
    2/ I had set very hard values for page cache:<br>
    &nbsp;&nbsp;&nbsp; vm.dirty_ratio = 3<br>
    &nbsp;&nbsp;&nbsp; vm.dirty_background_ratio = 0<br>
    In my case, on a 6GB server, this lets 184 MB to the page cache.
    This is really low, but it's done willingly to avoid caching too
    much and have the kernel start flushing too much. The counter-part
    is that when my filesystem needs to flush a lot a meta-data pages,
    then the page cache is filled and the whole application is frozen,
    waiting for those I/Os to be completed. <br>
    With those parameters:<br>
    &nbsp;&nbsp;&nbsp; vm.dirty_ratio = 20<br>
    &nbsp;&nbsp;&nbsp; vm.dirty_background_ratio = 5<br>
    The small writes are amortized in the stream of data writes from the
    application, and the application is not frozen.<br>
    (so you were right: there was a page cache issue)<br>
    <br>
    The question stands: my does XFS generates such a bunch of small I/O
    writes throughout the disk at around 688GB ?<br>
    <br>
    My fstab mount options are classical ones:<br>
    "defaults,nobarrier,noatime,nodiratime"<br>
    <br>
    Maybe the software RAID 0 has helped triggering the problem, too: I
    don't know if writes on a RAID can generate more I/O than on direct
    disk. I guess so (I/O fragmentation), but that's only a guess.<br>
    <br>
    --<br>
    Mathieu Avila<br>
    <br>
    <br>
    Le 22/09/2010 22:41, Stan Hoeppner a &eacute;crit&nbsp;:
    <blockquote cite="mid:4C9A69DC.8020606@hardwarefreak.com"
      type="cite">
      <pre wrap="">Mathieu AVILA put forth on 9/22/2010 5:26 AM:

</pre>
      <blockquote type="cite">
        <pre wrap="">I have run my test again with default parameters for mkfs.
I still have this issue. For 20 seconds, the writes are either stalled,
or very slow.
I have run "vmstat" at the same time than "dd", and it appears that the
block device continues to receive write requests, while "dd" is blocked
in the kernel.
With blktrace, I can see that during this period of time, the block
receives a lot of small write requests throughout the volume ranging
from the start till the point where the file has stopped writing. During
the other periods of time, the volume is written normally, starting at
offset 0 and filling the disk continuously.
</pre>
      </blockquote>
      <pre wrap="">
What happens with "dd if=/dev/zero of=/DATA/big oflag=direct"?  You said
the copy is hanging in the kernel.  Maybe a buffer cache issue?

What fstab mount options are you using for this filesystem?

</pre>
      <blockquote type="cite">
        <pre wrap="">Could this be an effect of tree rebalancing for extents management (both
inode of big file and free space trees) ? Can it be a hardware problem ?
Have you ever seen that issue before ?
</pre>
      </blockquote>
      <pre wrap="">
WRT tree rebalancing, that's beyond my knowledge level and someone else
will need to jump into this thread.  If it's a hardware problem you
should be seeing something in dmesg or the kernel log, or both.  If
you're not seeing controller or device errors it's probably not a
hardware problem.  Have you tried this same test with only one of those
two 500GB drives, no mdraid stripe?  That would eliminate any possible
issues with your mdraid implementation.  Speaking of which, could you
please share your mdraid parameters for this stripe set?  That could be
a factor as well.

</pre>
    </blockquote>
    <br>
    <br>
    <div class="moz-signature">-- <br>
      <font color="blue"><b>Mathieu Avila</b><br>
        IT &amp; Integration Engineer<br>
      </font>
      <a class="moz-txt-link-abbreviated" href="mailto:mathieu.avila@opencubetech.com">mathieu.avila@opencubetech.com</a><br>
      <br>
      OpenCube Technologies <a href="http://www.opencubetech.com">http://www.opencubetech.com</a><br>
      Parc Technologique du Canal, 9 avenue de l'Europe<br>
      31520 Ramonville St Agne - FRANCE<br>
      Tel. : +33 (0) 561 285 606 - Fax : +33 (0) 561 285 635<br>
    </div>
  </body>
</html>

--------------050200090204020605040100--


--===============8256460560349620395==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8256460560349620395==--
