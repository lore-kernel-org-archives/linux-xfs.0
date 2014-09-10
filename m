Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D79067F50
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:49:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B5A148F8049
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 07:49:34 -0700 (PDT)
Received: from mail-qg0-f47.google.com (mail-qg0-f47.google.com
	[209.85.192.47]) by cuda.sgi.com with ESMTP id f65i81D7aJFsUkwn
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Sep 2014 07:49:32 -0700 (PDT)
Received: by mail-qg0-f47.google.com with SMTP id i50so4734392qgf.20
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 07:49:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140910162411.07ef02a5@harpe.intellique.com>
References: <540F1B01.3020700@mygrande.net>
	<CAA43vkXwHF9RHW-cbTZ91_vF6wiQ6o_+TQDL3=7kD9P4tErCNQ@mail.gmail.com>
	<CAA43vkWgh8-EjDXjkySUn+y18W1O+v_W5j+fQankRTgDCmc8tw@mail.gmail.com>
	<540F7E37.7020500@sandeen.net> <540F9FE9.7070500@mygrande.net>
	<3E40936B-A1F2-424D-B0B3-54B6C7B50B13@filmlight.ltd.uk>
	<540FA9DB.20000@mygrande.net>
	<20140910162411.07ef02a5@harpe.intellique.com>
Date: Wed, 10 Sep 2014 10:49:32 -0400
Message-ID: <CAA43vkW1_RPQb+NC=nxWf0Fj4JF=8dB73deNEtx9O8AFzas6Fg@mail.gmail.com>
Subject: Re: Corrupted files
From: Sean Caron <scaron@umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1324239019054410406=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>, Sean Caron <scaron@umich.edu>
Cc: Roger Willcocks <roger@filmlight.ltd.uk>, Eric Sandeen <sandeen@sandeen.net>, Leslie Rhorer <lrhorer@mygrande.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============1324239019054410406==
Content-Type: multipart/alternative; boundary=001a11c2a30eea9ed20502b728d1

--001a11c2a30eea9ed20502b728d1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I don't want to bloviate too much and drag this completely off topic esp.
since the OPs query is resolved but please allow me just one anecdote :)

Earlier this year, I had one of our project file servers (450 TB) go down.
It didn't go down because the array spuriously just lost a bunch of disks;
it was simply your usual sort of Linux kernel panic... you go to the
console and it's just black screen and unresponsive, or maybe you can see
the tail end of a backtrace and it's unresponsive. So, OK, issue a quick
remote IPMI reboot of the machine, it comes up...

I'm in single user mode, bringing up each sub-RAID6 in our RAID60 by hand,
no problem. Bring up the top level RAID0. OK. Then I go to mount the XFS...
no go. Apparently the log somehow got corrupted in the crash?

So I try to mount ro, no dice, but I _can_ mount ro,noreplaylog and I see
good files here! Thank goodness. I start scavenging to a spare host...

A few weeks later, after the scavenge is done, I did a few xfs_repair runs
just for the sake of experimentation. Using both in dry run mode, I tried
the version that shipped with Ubuntu 12.04, as well as the latest
xfs_repair I could pull from the source tree. I redirected the output of
both runs to file and watched them with 'tail -f'.

Diffing the output when they were done, it didn't look like they were
behaving much differently. Both files had thousands or tens of thousands of
lines worth of output in them, bad this, bad that... (I always run in
verbose mode) Since the filesystem was hosed anyway and I was going to
rebuild it, I decided to let the new xfs_repair run "for real" just to see
what would happen, for kicks. And who knows? Maybe I could recover even
more than I already had ...? (I wasn't just totally wasting time)

I think it took maybe a week for it to run on a 450 TB volume? At least a
week. Maybe I was being a teensy bit hyperbolic in my previous descriptions
of runtime, LOL. After it was done?

... almost everything was obliterated. I had tens of millions of
zero-length files, and tens of millions of bits of anonymous scrambled junk
in lost+found.

So, I chuckled a bit (thankful for my hard-won previous experience) before
reformatting the array and then copied back the results of my scavenging.
Just by ro-mounting and copying what I could, I was able to save around 90%
of the data by volume on the array (it was a little more than half full
when it failed... ~290 TB? There was only ~30 TB that I couldn't salvage);
good clean files that passed validation from their respective users. I
think 80-90% recovery rates are very commonly achievable just mounting
ro,noreplaylog and getting what you can with cp -R or rsync, given that
there wasn't grievous failure of the underlying storage system.

If I had depended on xfs_repair, or blithely run it as a first line of
response as the documentation might intimate (hey, it's called xfs_repair,
right?) like you would casually think to do; run it like people run fsck or
CHKDSK... I would have been hosed, big time.

Best,

Sean







On Wed, Sep 10, 2014 at 10:24 AM, Emmanuel Florac <eflorac@intellique.com>
wrote:

> Le Tue, 09 Sep 2014 20:31:07 -0500
> Leslie Rhorer <lrhorer@mygrande.net> =C3=A9crivait:
>
> > More
> > importantly, is there some reason 3.1.7 would make things worse while
> > 3.2.1 would not?  If not, then I can always try 3.1.7 and then try
> > 3.2.1 if that does not help.
>
> I don't know for these particular versions, however in the past
> I've confirmed that a later version of xfs_repair performed way better
> (salvaged more files from lost+found, in particular).
>
> At some point in the distant past, some versions of xfs_repair were
> buggy and would happily throw away TB of perfectly sane data... Ih ad
> this very problem once on Christmas eve in 2005 IIRC :/
>
> --
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |   <eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
>

--001a11c2a30eea9ed20502b728d1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I don&#39;t want to bloviate too much and drag this c=
ompletely off topic esp. since the OPs query is resolved but please allow m=
e just one anecdote :)</div><div><br></div>Earlier this year, I had one of =
our project file servers (450 TB) go down. It didn&#39;t go down because th=
e array spuriously just lost a bunch of disks; it was simply your usual sor=
t of Linux kernel panic... you go to the console and it&#39;s just black sc=
reen and unresponsive, or maybe you can see the tail end of a backtrace and=
 it&#39;s unresponsive. So, OK, issue a quick remote IPMI reboot of the mac=
hine, it comes up...<div><br></div><div>I&#39;m in single user mode, bringi=
ng up each sub-RAID6 in our RAID60 by hand, no problem. Bring up the top le=
vel RAID0. OK. Then I go to mount the XFS... no go. Apparently the log some=
how got corrupted in the crash?</div><div><br></div><div>So I try to mount =
ro, no dice, but I _can_ mount ro,noreplaylog and I see good files here! Th=
ank goodness. I start scavenging to a spare host...</div><div><br></div><di=
v>A few weeks later, after the scavenge is done, I did a few xfs_repair run=
s just for the sake of experimentation. Using both in dry run mode, I tried=
 the version that shipped with Ubuntu 12.04, as well as the latest xfs_repa=
ir I could pull from the source tree. I redirected the output of both runs =
to file and watched them with &#39;tail -f&#39;.</div><div><br></div><div>D=
iffing the output when they were done, it didn&#39;t look like they were be=
having much differently. Both files had thousands or tens of thousands of l=
ines worth of output in them, bad this, bad that... (I always run in verbos=
e mode) Since the filesystem was hosed anyway and I was going to rebuild it=
, I decided to let the new xfs_repair run &quot;for real&quot; just to see =
what would happen, for kicks. And who knows? Maybe I could recover even mor=
e than I already had ...? (I wasn&#39;t just totally wasting time)</div><di=
v><br></div><div>I think it took maybe a week for it to run on a 450 TB vol=
ume? At least a week. Maybe I was being a teensy bit hyperbolic in my previ=
ous descriptions of runtime, LOL. After it was done?</div><div><br></div><d=
iv>... almost everything was obliterated. I had tens of millions of zero-le=
ngth files, and tens of millions of bits of anonymous scrambled junk in los=
t+found.</div><div><br></div><div>So, I chuckled a bit (thankful for my har=
d-won previous experience) before reformatting the array and then copied ba=
ck the results of my scavenging. Just by ro-mounting and copying what I cou=
ld, I was able to save around 90% of the data by volume on the array (it wa=
s a little more than half full when it failed... ~290 TB? There was only ~3=
0 TB that I couldn&#39;t salvage); good clean files that passed validation =
from their respective users. I think 80-90% recovery rates are very commonl=
y achievable just mounting ro,noreplaylog and getting what you can with cp =
-R or rsync, given that there wasn&#39;t grievous failure of the underlying=
 storage system.</div><div><br></div><div>If I had depended on xfs_repair, =
or blithely run it as a first line of response as the documentation might i=
ntimate (hey, it&#39;s called xfs_repair, right?) like you would casually t=
hink to do; run it like people run fsck or CHKDSK... I would have been hose=
d, big time.=C2=A0</div><div><br></div><div>Best,</div><div><br></div><div>=
Sean</div><div><br></div><div><br></div><div><br></div><div><br></div><div>=
<br></div><div><br></div></div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Wed, Sep 10, 2014 at 10:24 AM, Emmanuel Florac <span dir=
=3D"ltr">&lt;<a href=3D"mailto:eflorac@intellique.com" target=3D"_blank">ef=
lorac@intellique.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">Le Tue, 09 Sep 2014 20:31:07 -0500<br>
Leslie Rhorer &lt;<a href=3D"mailto:lrhorer@mygrande.net">lrhorer@mygrande.=
net</a>&gt; =C3=A9crivait:<br>
<span class=3D""><br>
&gt; More<br>
&gt; importantly, is there some reason 3.1.7 would make things worse while<=
br>
&gt; 3.2.1 would not?=C2=A0 If not, then I can always try 3.1.7 and then tr=
y<br>
&gt; 3.2.1 if that does not help.<br>
<br>
</span>I don&#39;t know for these particular versions, however in the past<=
br>
I&#39;ve confirmed that a later version of xfs_repair performed way better<=
br>
(salvaged more files from lost+found, in particular).<br>
<br>
At some point in the distant past, some versions of xfs_repair were<br>
buggy and would happily throw away TB of perfectly sane data... Ih ad<br>
this very problem once on Christmas eve in 2005 IIRC :/<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
--<br>
------------------------------------------------------------------------<br=
>
Emmanuel Florac=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A0Direction technique<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A0Intellique<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A0&lt;<a href=3D"mailto:eflorac@intellique.com">eflorac@intellique.=
com</a>&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A0<a href=3D"tel:%2B33%201%2078%2094%2084%2002" value=3D"+331789484=
02">+33 1 78 94 84 02</a><br>
------------------------------------------------------------------------<br=
>
</div></div></blockquote></div><br></div>

--001a11c2a30eea9ed20502b728d1--


--===============1324239019054410406==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1324239019054410406==--
