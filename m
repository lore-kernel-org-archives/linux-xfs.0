Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9FJpAI3227820 for <xfs@oss.sgi.com>; Mon, 15 Oct 2012 14:51:11 -0500
Received: from crcuda.crossroads.com (crcuda.crossroads.com [66.219.50.99]) by
	cuda.sgi.com with ESMTP id m2ocZUYFXtQxRhFm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Oct 2012 12:52:45 -0700 (PDT)
Received: from crds-transport1.COMMSTOR.Crossroads.com
	(crds-transport1.commstor.crossroads.com [192.168.120.151]) by
	crcuda.crossroads.com with ESMTP id 2aIMNpeoliybds5D
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Oct 2012 14:52:44 -0500 (CDT)
Message-ID: <507C698B.1020801@crossroads.com>
Date: Mon, 15 Oct 2012 14:52:43 -0500
From: Wayne Walker <wwalker@crossroads.com>
MIME-Version: 1.0
Subject: Re: Usage bigger after copy?
References: <2368408.eSeMIOhpGu@saturn>
In-Reply-To: <2368408.eSeMIOhpGu@saturn>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8383785796149557182=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8383785796149557182==
Content-Type: multipart/alternative;
	boundary="------------020605070008050805050903"

--------------020605070008050805050903
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Michael,

My guess is that you used rsync but did not use H.

retry your rsync with:

rsync -aHx /usr /1/

H will preseve hard links for you and probably make most of your 
directory size differences go away.

Wayne

On 10/15/2012 01:07 PM, Michael Monnerie wrote:
> I know that the speculative prealloc of xfs can make files bigger on a
> destination, but I thought an "echo 3 >/proc/sys/vm/drop_caches" would
> help. I even umounted both filesystems, but the destination is bigger:
>
> sys1 Blocks 8378368 Used 2631368 Avail 5747000
> sys2 Blocks 8378368 Used 2966566 Avail 5411812
>
> Both are VMs, have a 16G disk, partitioned same size, both on LVM,
> copied with rsync. xfs_info show the same for both:
>
> meta-data=/dev/mapper/dns1--system-root isize=256    agcount=4,
> agsize=524288 blks
>           =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=2097152, imaxpct=25
>           =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=2560, version=2
>           =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>
> So why is there such a huge diff in size? 300M, 2.6G:2.9G, is a big
> number. I found these dirs to be very different:
>
> ( I rebooted here compared to results before, but same strangeness )
> # du -s /1/usr/lib/locale/* /usr/lib/locale/*|sort -n|grep YU
> 20      /usr/lib/locale/sh_YU.utf8
> 1760    /1/usr/lib/locale/sh_YU.utf8
>
> But comparing them directly, they are the same:
>
> # du -s /1/usr/lib/locale/sh_YU.utf8 /usr/lib/locale/sh_YU.utf8
> 1760    /1/usr/lib/locale/sh_YU.utf8
> 1760    /usr/lib/locale/sh_YU.utf8
>
> So what makes "du" show a huge different when the dir above gets
> scanned, versus when you compare dirs directly?
>
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


--------------020605070008050805050903
Content-Type: text/html; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    <div class="moz-cite-prefix">Michael,<br>
      <br>
      My guess is that you used rsync but did not use H.<br>
      <br>
      retry your rsync with:<br>
      <br>
      rsync -aHx /usr /1/<br>
      <br>
      H will preseve hard links for you and probably make most of your
      directory size differences go away.<br>
      <br>
      Wayne<br>
      <br>
      On 10/15/2012 01:07 PM, Michael Monnerie wrote:<br>
    </div>
    <blockquote cite="mid:2368408.eSeMIOhpGu@saturn" type="cite">
      <pre wrap="">I know that the speculative prealloc of xfs can make files bigger on a 
destination, but I thought an "echo 3 &gt;/proc/sys/vm/drop_caches" would 
help. I even umounted both filesystems, but the destination is bigger:

sys1 Blocks 8378368 Used 2631368 Avail 5747000
sys2 Blocks 8378368 Used 2966566 Avail 5411812

Both are VMs, have a 16G disk, partitioned same size, both on LVM, 
copied with rsync. xfs_info show the same for both:

meta-data=/dev/mapper/dns1--system-root isize=256    agcount=4, 
agsize=524288 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

So why is there such a huge diff in size? 300M, 2.6G:2.9G, is a big 
number. I found these dirs to be very different:

( I rebooted here compared to results before, but same strangeness )
# du -s /1/usr/lib/locale/* /usr/lib/locale/*|sort -n|grep YU
20      /usr/lib/locale/sh_YU.utf8
1760    /1/usr/lib/locale/sh_YU.utf8

But comparing them directly, they are the same:

# du -s /1/usr/lib/locale/sh_YU.utf8 /usr/lib/locale/sh_YU.utf8
1760    /1/usr/lib/locale/sh_YU.utf8
1760    /usr/lib/locale/sh_YU.utf8

So what makes "du" show a huge different when the dir above gets 
scanned, versus when you compare dirs directly?

</pre>
      <br>
      <fieldset class="mimeAttachmentHeader"></fieldset>
      <br>
      <pre wrap="">_______________________________________________
xfs mailing list
<a class="moz-txt-link-abbreviated" href="mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>
<a class="moz-txt-link-freetext" href="http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com/mailman/listinfo/xfs</a>
</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------020605070008050805050903--


--===============8383785796149557182==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8383785796149557182==--
