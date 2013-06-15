Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 91ADD7F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 20:55:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7961C30405F
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 18:55:19 -0700 (PDT)
Received: from mail-qe0-f41.google.com (mail-qe0-f41.google.com
	[209.85.128.41]) by cuda.sgi.com with ESMTP id u17L1fDW0siIarCb
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 14 Jun 2013 18:55:18 -0700 (PDT)
Received: by mail-qe0-f41.google.com with SMTP id b4so728294qen.14
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 18:55:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <504625587.1365681.1371255450937.JavaMail.root@redhat.com>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<91017249.1356192.1371248207334.JavaMail.root@redhat.com>
	<CAC2B=ZHYV6d-1PO_=-jXsQidZnYPHVwcVAaQh2mxJt=5K03AEA@mail.gmail.com>
	<504625587.1365681.1371255450937.JavaMail.root@redhat.com>
Date: Fri, 14 Jun 2013 21:55:17 -0400
Message-ID: <CAC2B=ZF+eMyNLPQmhA_onDPEUqgNfcgCdZVvobNH9pofvioN7Q@mail.gmail.com>
Subject: Re: definitions for /proc/fs/xfs/stat
From: Mark Seger <mjseger@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1301238790181422800=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Nathan Scott <nathans@redhat.com>
Cc: xfs@oss.sgi.com

--===============1301238790181422800==
Content-Type: multipart/alternative; boundary=047d7bdc0668bc950604df27a7bb

--047d7bdc0668bc950604df27a7bb
Content-Type: text/plain; charset=ISO-8859-1

I'm doing 1 second samples and the rates are very steady.  The reason I
ended up at this level of testing was I had done a sustained test for 2
minutes at about 5MB/sec and was seeing over 500MB/sec going to the disk,
again sampling at 1-second intervals.  I'd be happy to provide detailed
output and can even sample more frequently if you like.

from my shorter test I was experimenting looking at some of the XFS data
with collectl and recorded this, it if help at all:

segerm@az1-sw-object-0006:~$ collectl --import xfs
waiting for 1 second sample...
#<--XFS Ops--><-----------XFS
Logging----------><------Extents------><------DirOps-------><----Trans---><-
# Write Reads  Writes WrtKBs NoRoom Force Sleep  ExtA BlkA ExtF ExtF  Look
Cre8 Remv Gdnt  Sync Asyn Empt
      0     0       0      0      0     0     0     0    0    0    0     0
   0    0    0     0    0    0
      0     0       3    768      0     3     3     0    0    0    0     0
   0    0    0     3    0    0
      0     0       0      0      0     0     0     0    0    0    0     0
   0    0    0     0    0    0
      0     0       0      0      0     0     0     0    0    0    0     0
   0    0    0     0    0    0
      0     0       0      0      0     0     0     0    0    0    0     0
   0    0    0     0    0    0
      0     0       1    256      0     1     1     0    0    0    0     0
   0    0    0     1    0    0
     38    88      95  24320      0    95    96    54   54   54   54   115
  76   76  154    95  473    0
    339   776     968 247816      0   968   978   484  484  479  479  1011
 675  671 1351   967 4087    0
    321   748     929 237806      0   929   935   450  450  453  453   967
 645  647 1287   930 3847    0
    279   637     810 207360      0   810   811   391  391  390  390   838
 559  558 1118   810 3324    0
    209   482     610 156160      0   610   610   286  286  289  289   627
 417  420  834   610 2451    0
      0     0       3    768      0     3     3     0    0    0    0     0
   0    0    0     3    0    0

I can say for a fact I was doing about 300 wtrites/sec whcih the write
numbers seem to support, though I don't know what the read numbers are
measuring.  you can also see from the logging data that was 250MB/sec going
to disk.

Are there other numbers that are meaningful that you'd like to see?  All it
takes is adding a couple of print statement as what you're seeing above
only took a hour or so to throw to together.

I can collect as much (or little as you like) and actually can save the
complete contents of /proc/fs/xfs/stat every second in a file for later
playback.

-mark



On Fri, Jun 14, 2013 at 8:17 PM, Nathan Scott <nathans@redhat.com> wrote:

>
>
> ----- Original Message -----
> > actually I have since found a decoder ring here -
> > http://xfs.org/index.php/Runtime_Stats and have been incorporating a
> lot of
> > the data so I can look at things in real time.  I'd still love to know
> why
>
> Ah, good stuff.
>
> > writing 1000 1K files results in 200MB/sec of disk I/O though.  clearly
>
> For how many seconds?  (or fractions thereof?)  You may need the level of
> detail that only tracing will provide to explore further, although off the
> top of my head I'm not sure exactly which events you should focus on (log,
> inode creation, or space allocation at a guess).
>
> cheers.
>
> --
> Nathan
>

--047d7bdc0668bc950604df27a7bb
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I&#39;m doing 1 second samples and the rates are very stea=
dy. =A0The reason I ended up at this level of testing was I had done a sust=
ained test for 2 minutes at about 5MB/sec and was seeing over 500MB/sec goi=
ng to the disk, again sampling at 1-second intervals. =A0I&#39;d be happy t=
o provide detailed output and can even sample more frequently if you like.<=
div>
<br></div><div style>from my shorter test I was experimenting looking at so=
me of the XFS data with collectl and recorded this, it if help at all:</div=
><div style><br></div><div style><div><font face=3D"courier new, monospace"=
>segerm@az1-sw-object-0006:~$ collectl --import xfs</font></div>
<div><font face=3D"courier new, monospace">waiting for 1 second sample...</=
font></div><div><font face=3D"courier new, monospace">#&lt;--XFS Ops--&gt;&=
lt;-----------XFS Logging----------&gt;&lt;------Extents------&gt;&lt;-----=
-DirOps-------&gt;&lt;----Trans---&gt;&lt;-</font></div>
<div><font face=3D"courier new, monospace"># Write Reads =A0Writes WrtKBs N=
oRoom Force Sleep =A0ExtA BlkA ExtF ExtF =A0Look Cre8 Remv Gdnt =A0Sync Asy=
n Empt</font></div><div><font face=3D"courier new, monospace">=A0 =A0 =A0 0=
 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A00 =A0 =A0 =A00 =A0 =A0 0 =A0 =A0 0 =A0 =
=A0 0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 =A0 0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 =
=A0 0 =A0 =A00 =A0 =A00</font></div>
<div><font face=3D"courier new, monospace">=A0 =A0 =A0 0 =A0 =A0 0 =A0 =A0 =
=A0 3 =A0 =A0768 =A0 =A0 =A00 =A0 =A0 3 =A0 =A0 3 =A0 =A0 0 =A0 =A00 =A0 =
=A00 =A0 =A00 =A0 =A0 0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 =A0 3 =A0 =A00 =A0 =
=A00</font></div><div><font face=3D"courier new, monospace">=A0 =A0 =A0 0 =
=A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A00 =A0 =A0 =A00 =A0 =A0 0 =A0 =A0 0 =A0 =
=A0 0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 =A0 0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 =
=A0 0 =A0 =A00 =A0 =A00</font></div>
<div><font face=3D"courier new, monospace">=A0 =A0 =A0 0 =A0 =A0 0 =A0 =A0 =
=A0 0 =A0 =A0 =A00 =A0 =A0 =A00 =A0 =A0 0 =A0 =A0 0 =A0 =A0 0 =A0 =A00 =A0 =
=A00 =A0 =A00 =A0 =A0 0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 =A0 0 =A0 =A00 =A0 =
=A00</font></div><div><font face=3D"courier new, monospace">=A0 =A0 =A0 0 =
=A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A00 =A0 =A0 =A00 =A0 =A0 0 =A0 =A0 0 =A0 =
=A0 0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 =A0 0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 =
=A0 0 =A0 =A00 =A0 =A00</font></div>
<div><font face=3D"courier new, monospace">=A0 =A0 =A0 0 =A0 =A0 0 =A0 =A0 =
=A0 1 =A0 =A0256 =A0 =A0 =A00 =A0 =A0 1 =A0 =A0 1 =A0 =A0 0 =A0 =A00 =A0 =
=A00 =A0 =A00 =A0 =A0 0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 =A0 1 =A0 =A00 =A0 =
=A00</font></div><div><font face=3D"courier new, monospace">=A0 =A0 =A038 =
=A0 =A088 =A0 =A0 =A095 =A024320 =A0 =A0 =A00 =A0 =A095 =A0 =A096 =A0 =A054=
 =A0 54 =A0 54 =A0 54 =A0 115 =A0 76 =A0 76 =A0154 =A0 =A095 =A0473 =A0 =A0=
0</font></div>
<div><font face=3D"courier new, monospace">=A0 =A0 339 =A0 776 =A0 =A0 968 =
247816 =A0 =A0 =A00 =A0 968 =A0 978 =A0 484 =A0484 =A0479 =A0479 =A01011 =
=A0675 =A0671 1351 =A0 967 4087 =A0 =A00</font></div><div><font face=3D"cou=
rier new, monospace">=A0 =A0 321 =A0 748 =A0 =A0 929 237806 =A0 =A0 =A00 =
=A0 929 =A0 935 =A0 450 =A0450 =A0453 =A0453 =A0 967 =A0645 =A0647 1287 =A0=
 930 3847 =A0 =A00</font></div>
<div><font face=3D"courier new, monospace">=A0 =A0 279 =A0 637 =A0 =A0 810 =
207360 =A0 =A0 =A00 =A0 810 =A0 811 =A0 391 =A0391 =A0390 =A0390 =A0 838 =
=A0559 =A0558 1118 =A0 810 3324 =A0 =A00</font></div><div><font face=3D"cou=
rier new, monospace">=A0 =A0 209 =A0 482 =A0 =A0 610 156160 =A0 =A0 =A00 =
=A0 610 =A0 610 =A0 286 =A0286 =A0289 =A0289 =A0 627 =A0417 =A0420 =A0834 =
=A0 610 2451 =A0 =A00</font></div>
<div><font face=3D"courier new, monospace">=A0 =A0 =A0 0 =A0 =A0 0 =A0 =A0 =
=A0 3 =A0 =A0768 =A0 =A0 =A00 =A0 =A0 3 =A0 =A0 3 =A0 =A0 0 =A0 =A00 =A0 =
=A00 =A0 =A00 =A0 =A0 0 =A0 =A00 =A0 =A00 =A0 =A00 =A0 =A0 3 =A0 =A00 =A0 =
=A00</font></div><div><br></div><div style>I can say for a fact I was doing=
 about 300 wtrites/sec whcih the write numbers seem to support, though I do=
n&#39;t know what the read numbers are measuring. =A0you can also see from =
the logging data that was 250MB/sec going to disk.</div>
<div style><br></div><div style>Are there other numbers that are meaningful=
 that you&#39;d like to see? =A0All it takes is adding a couple of print st=
atement as what you&#39;re seeing above only took a hour or so to throw to =
together.</div>
<div style><br></div><div style>I can collect as much (or little as you lik=
e) and actually can save the complete contents of /proc/fs/xfs/stat every s=
econd in a file for later playback.</div><div style><br></div><div style>
-mark</div></div><div style><br></div></div><div class=3D"gmail_extra"><br>=
<br><div class=3D"gmail_quote">On Fri, Jun 14, 2013 at 8:17 PM, Nathan Scot=
t <span dir=3D"ltr">&lt;<a href=3D"mailto:nathans@redhat.com" target=3D"_bl=
ank">nathans@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im"><br>
<br>
----- Original Message -----<br>
&gt; actually I have since found a decoder ring here -<br>
&gt; <a href=3D"http://xfs.org/index.php/Runtime_Stats" target=3D"_blank">h=
ttp://xfs.org/index.php/Runtime_Stats</a> and have been incorporating a lot=
 of<br>
&gt; the data so I can look at things in real time. =A0I&#39;d still love t=
o know why<br>
<br>
</div>Ah, good stuff.<br>
<div class=3D"im"><br>
&gt; writing 1000 1K files results in 200MB/sec of disk I/O though. =A0clea=
rly<br>
<br>
</div>For how many seconds? =A0(or fractions thereof?) =A0You may need the =
level of<br>
detail that only tracing will provide to explore further, although off the<=
br>
top of my head I&#39;m not sure exactly which events you should focus on (l=
og,<br>
inode creation, or space allocation at a guess).<br>
<br>
cheers.<br>
<br>
--<br>
Nathan<br>
</blockquote></div><br></div>

--047d7bdc0668bc950604df27a7bb--


--===============1301238790181422800==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1301238790181422800==--
