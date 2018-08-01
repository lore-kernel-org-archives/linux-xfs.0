Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f180.google.com ([209.85.208.180]:37284 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731007AbeHAUiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 16:38:00 -0400
Received: by mail-lj1-f180.google.com with SMTP id v9-v6so17774138ljk.4
        for <linux-xfs@vger.kernel.org>; Wed, 01 Aug 2018 11:50:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtQpeQ_z9gMHhnhSvzJed4HfT=pxpORTTNjJQUogvVjLgA@mail.gmail.com>
 <20180801041204.GH2234@dastard> <CAJCQCtQh3KCpG=PNNj1-3Z9cMKoeavgF++3aDTxZdo7YQ=15KA@mail.gmail.com>
 <dce71dca-0b85-387c-a1c9-f62f6c824b1c@sandeen.net> <CAJCQCtS56E32e3NhTR++vwt1qdbnrfu9Hcn46W3Hso7iq1Djfg@mail.gmail.com>
 <20180801114541.5lq5xsccdwahw3vg@odin.usersys.redhat.com>
In-Reply-To: <20180801114541.5lq5xsccdwahw3vg@odin.usersys.redhat.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 1 Aug 2018 12:50:37 -0600
Message-ID: <CAJCQCtT2p+rAAt6wk1jKyxO=FMcRSt_ZznK0eN+=ov69ZXAUwA@mail.gmail.com>
Subject: Re: agcount 33 by default for a single HDD?
Content-Type: multipart/alternative; boundary="00000000000055eb090572642c3c"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>, xfs list <linux-xfs@vger.kernel.org>

--00000000000055eb090572642c3c
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 1, 2018, 5:45 AM Carlos Maiolino <cmaiolino@redhat.com> wrote:

> On Tue, Jul 31, 2018 at 11:04:05PM -0600, Chris Murphy wrote:
> > On Tue, Jul 31, 2018 at 10:41 PM, Eric Sandeen <sandeen@sandeen.net>
> wrote:
> > >
> > >
> > > On 7/31/18 11:38 PM, Chris Murphy wrote:
> > >> On Tue, Jul 31, 2018 at 10:12 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> > >>> On Tue, Jul 31, 2018 at 07:32:50PM -0600, Chris Murphy wrote:
> > >>>> This seems suboptimal.
> > >>>
> > >>> It's actually a very useful optimisation to make on thin devices.
> > >>>
> > >>>> Basically this is a 750G thin volume. I don't
> > >>>> have a plain partition on a device handy to try this out but I'm
> > >>>> pretty certain the default is 4 AG's in that case, so I'm confused
> why
> > >>>> by default 33 AGs are created on a thin volume. The LVM volume group
> > >>>> is on a dmcrypt PV.
> > >>>
> > >>> It's a thin volume, therefore it advertises an optimal IO size and
> > >>> alignment setting (i.e. the thin volume allocation chunk size).
> > >>> Hence mkfs.xfs treats it as a "multi-disk device" and sets up
> > >>> alignment and AG count appropriately.
> > >>>
> > >>> This is actually the right optimisation to make for sparse devices -
> > >>> more AGs increase filesystem concurrency but we normally restrict it
> > >>> on single spindles because each AG adds more seeks into typical
> > >>> workloads and slows them down. However, the thin volume already adds
> > >>> that penalty to the storage stack for us because they don't have a
> > >>> linear LBA-to-physical location characteristic.  Hence we can
> > >>> increase filesystem concurrency without addition performance
> > >>> penalties being incurred.
> > >>
> > >> OK so why 33 AG's with xfsprogs 4.15, but 4 AG's with xfsprogs 4.17,
> > >> when directed to the same thin LV? And also the difference in sunit
> > >> and swidth?
> > >>
> > >
> > > Did you build 4.17 with --disable-blkid?
> >
> > Yep, that's what doc/INSTALL recommends. Removing that and rebuilding,
> > sure enough 33 AGs, sunit 128, swidth 1024, and sectsz 4096. I do get
> > a build time warning.
>
> Where did you see that --disable-blkid is recommended? Are you using MacOS
> to
> build it?
>

In the install instructions under the Mac OS X section. The Linux and Mac
OS X sections are obviously titled, nevertheless I totally missed those
titles.

Sorry for the noise.


Chris Murphy

>

--00000000000055eb090572642c3c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Wed, Aug 1, 2018, 5:=
45 AM Carlos Maiolino &lt;<a href=3D"mailto:cmaiolino@redhat.com">cmaiolino=
@redhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Tue, =
Jul 31, 2018 at 11:04:05PM -0600, Chris Murphy wrote:<br>
&gt; On Tue, Jul 31, 2018 at 10:41 PM, Eric Sandeen &lt;<a href=3D"mailto:s=
andeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&gt; wrote:<br=
>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; On 7/31/18 11:38 PM, Chris Murphy wrote:<br>
&gt; &gt;&gt; On Tue, Jul 31, 2018 at 10:12 PM, Dave Chinner &lt;<a href=3D=
"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt; =
wrote:<br>
&gt; &gt;&gt;&gt; On Tue, Jul 31, 2018 at 07:32:50PM -0600, Chris Murphy wr=
ote:<br>
&gt; &gt;&gt;&gt;&gt; This seems suboptimal.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; It&#39;s actually a very useful optimisation to make on t=
hin devices.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt; Basically this is a 750G thin volume. I don&#39;t<br>
&gt; &gt;&gt;&gt;&gt; have a plain partition on a device handy to try this =
out but I&#39;m<br>
&gt; &gt;&gt;&gt;&gt; pretty certain the default is 4 AG&#39;s in that case=
, so I&#39;m confused why<br>
&gt; &gt;&gt;&gt;&gt; by default 33 AGs are created on a thin volume. The L=
VM volume group<br>
&gt; &gt;&gt;&gt;&gt; is on a dmcrypt PV.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; It&#39;s a thin volume, therefore it advertises an optima=
l IO size and<br>
&gt; &gt;&gt;&gt; alignment setting (i.e. the thin volume allocation chunk =
size).<br>
&gt; &gt;&gt;&gt; Hence mkfs.xfs treats it as a &quot;multi-disk device&quo=
t; and sets up<br>
&gt; &gt;&gt;&gt; alignment and AG count appropriately.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; This is actually the right optimisation to make for spars=
e devices -<br>
&gt; &gt;&gt;&gt; more AGs increase filesystem concurrency but we normally =
restrict it<br>
&gt; &gt;&gt;&gt; on single spindles because each AG adds more seeks into t=
ypical<br>
&gt; &gt;&gt;&gt; workloads and slows them down. However, the thin volume a=
lready adds<br>
&gt; &gt;&gt;&gt; that penalty to the storage stack for us because they don=
&#39;t have a<br>
&gt; &gt;&gt;&gt; linear LBA-to-physical location characteristic.=C2=A0 Hen=
ce we can<br>
&gt; &gt;&gt;&gt; increase filesystem concurrency without addition performa=
nce<br>
&gt; &gt;&gt;&gt; penalties being incurred.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; OK so why 33 AG&#39;s with xfsprogs 4.15, but 4 AG&#39;s with=
 xfsprogs 4.17,<br>
&gt; &gt;&gt; when directed to the same thin LV? And also the difference in=
 sunit<br>
&gt; &gt;&gt; and swidth?<br>
&gt; &gt;&gt;<br>
&gt; &gt;<br>
&gt; &gt; Did you build 4.17 with --disable-blkid?<br>
&gt; <br>
&gt; Yep, that&#39;s what doc/INSTALL recommends. Removing that and rebuild=
ing,<br>
&gt; sure enough 33 AGs, sunit 128, swidth 1024, and sectsz 4096. I do get<=
br>
&gt; a build time warning.<br>
<br>
Where did you see that --disable-blkid is recommended? Are you using MacOS =
to<br>
build it?<br></blockquote></div><div><br></div><div>In the install instruct=
ions under the Mac OS X section. The Linux and Mac OS X sections are obviou=
sly titled, nevertheless I totally missed those titles.</div><div><br></div=
><div>Sorry for the noise.</div><div><br></div><div><br></div><div>Chris Mu=
rphy</div><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
</blockquote></div>

--00000000000055eb090572642c3c--
