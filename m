Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CDBB37F4E
	for <xfs@oss.sgi.com>; Sun,  7 Dec 2014 05:57:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72794AC003
	for <xfs@oss.sgi.com>; Sun,  7 Dec 2014 03:57:19 -0800 (PST)
Received: from mail-ie0-f171.google.com (mail-ie0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	ZtgevkCDXORsOIup (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 07 Dec 2014 03:57:17 -0800 (PST)
Received: by mail-ie0-f171.google.com with SMTP id rl12so3134027iec.2
	for <xfs@oss.sgi.com>; Sun, 07 Dec 2014 03:57:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141201043155.GH16151@dastard>
References: <BLU402-EAS63BA21BE641D092688C4CAE1700@phx.gbl>
	<CAJAKVEFdkSEMW84=TvRNqOQdNMz6nS_WRVGN-2MX5se9NUaV1A@mail.gmail.com>
	<CAFhuFEd3eVhKy1Jg7qL-ycw4XHnAd16kkstpOhOUpwVsAPN5mw@mail.gmail.com>
	<CAJAKVEHs=FczXUnAYfhbdav1o6JONmD7y0Kgc1xUo1t9g3=63Q@mail.gmail.com>
	<CAJAKVEFk5oc98gqF8CnGzz7Vsat-i=0da+aYwJh-EGX8eX9sgw@mail.gmail.com>
	<CAFhuFEc+mbGqZtDVY_wT99dd=FPUKDKZkHN3FYaBgzaVEb=q_A@mail.gmail.com>
	<CAJAKVEFD0PuFW0eF_Csk1oQJnzZ2eYW=pywHFKJb-ArroRq_cA@mail.gmail.com>
	<CAJAKVEE2Lu=MReV9fdg0L4OvWAymJJv9qteNDm_1oHyNNcdKVw@mail.gmail.com>
	<CAF3jHnqRp9HCuXcgv7SBE=kNJ036GysLAx+dgL6v2V_jN2Nrng@mail.gmail.com>
	<CAJAKVEEAAaf-sA+jbTr8A_HAUMcToo6Esd8ithPvE4tY4TW2NA@mail.gmail.com>
	<20141201043155.GH16151@dastard>
Date: Sun, 7 Dec 2014 17:27:16 +0530
Message-ID: <CAJAKVEETXGiaNKwG=kfDWPoBRqJ0MyjhJLyyPTsMA53oGhQiBQ@mail.gmail.com>
Subject: Re: Meeting
From: Somdeep Dey <somdeepdey10@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6685637378071984664=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

--===============6685637378071984664==
Content-Type: multipart/alternative; boundary=20cf303f6486e709ad05099f02f1

--20cf303f6486e709ad05099f02f1
Content-Type: text/plain; charset=UTF-8

Hi,

Good to hear about the progress related to rmap. We'll continue
working here on our side.

As we mentioned previously, we've familiarized ourselves
with the fiemap interface and developed an understanding
of how the ioctl works.

We also went through different discussions on the mailing
list related to fiemap, as well as obtained the latest patches.

While working on the rmap, would it be possible for you to
give us some essential details about the required fiemap
interface, so that we can obtain a clearer understanding of
 what we are required to do.


Regards,
A-DRS.

On Mon, Dec 1, 2014 at 10:01 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Dec 01, 2014 at 01:29:47AM +0530, Somdeep Dey wrote:
> > Hi,
> >
> > We've now resumed working on the xfs_fsr utility as discussed before,
> after
> > our exams.
> >
> > The first task that we undertook was to use fiemap to get file extent
> > mappings and tried to correlate the output with the information obtained
> > from xfs_bmap. For this we used the two underlying structures fiemap
> > and fiemap_extent. We're now trying to use the available free space
> mapping
> > patches to get free spaces in the file system.
> >
> > We also wanted to ask about the current status of the rmap, as we'll
> > be required to define the interfaces that query it, as a key component of
> > our
> > work.
>
> The rmap design is slowly being thrashed out. Brian and I had a
> discussion about it on IRC a couple of weeks ago (below).
>
> I'm relatively close to having a proof of concept for single-owner
> rmap btrees that works...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
> From #xfs on freenode.net
>
> [13/11/14 10:07] <dchinner_> foster: still around?
> [13/11/14 10:10] <foster> dchinner_: yep
> [13/11/14 10:27] <dchinner_> foster: been prototyping reverse mapping
> btree code over the past couple of days
> [13/11/14 10:28] <dchinner_> couple of interesting issues have come up
> that need discussion
> [13/11/14 10:28] <dchinner_> I think I have solutions to them, but I'm
> sure there are other ways of solving the problems
> [13/11/14 10:28] <dchinner_> basically I want the rmap btree for two
> purposes
> [13/11/14 10:29] <dchinner_> 1) to keep owner information so we can do
> block-to-owner lookups efficiently
> [13/11/14 10:29] <dchinner_> e.g. to identify the files corrupted by bad
> sectors
> [13/11/14 10:29] <dchinner_> found during a media scan
> [13/11/14 10:31] <dchinner_> or to provide sufficient redundant
> information for an online rebuild of a corrupted free space btree
> [13/11/14 10:32] <foster> so a btree that maps extents to inodes or
> something of that nature?
> [13/11/14 10:32] <dchinner_> exactly
> [13/11/14 10:32] <dchinner_> per-ag btree
> [13/11/14 10:32] <dchinner_> that contains { start block, length, owner }
> [13/11/14 10:32] <dchinner_> records
> [13/11/14 10:32] <foster> ok
> [13/11/14 10:33] <dchinner_> that's relatively easy to do
> [13/11/14 10:33] <dchinner_> The patches I've written do that.
> [13/11/14 10:33] <dchinner_> (not that it does anything other than compile
> yet)
> [13/11/14 10:33] <dchinner_> however, there is a second reason for having
> a reverse mapping tree
> [13/11/14 10:34] <dchinner_> it's for reference counting extents shared
> between inodes
> [13/11/14 10:34] <foster> ah, reflink?
> [13/11/14 10:34] <dchinner_> i.e. to implement reflink semantics
> [13/11/14 10:34] <dchinner_> *nod*
> [13/11/14 10:35] <dchinner_> this doesn't affect how the ramp btree
> interacts with the rest of the allocation/freeing code
> [13/11/14 10:35] <dchinner_> but it does affect the "extent owner" tracking
> [13/11/14 10:35] <dchinner_> i.e. we can now have multiple owners of an
> extent
> [13/11/14 10:36] <dchinner_> so that btree record now becomes {stat, len,
> refcount, owner, owner, .... owner }
> [13/11/14 10:36] <foster> yeah
> [13/11/14 10:36] <dchinner_> and we can't do that with the generic btree
> infrastructure because it's all based around fixed length records
> [13/11/14 10:38] <dchinner_> I've come up with a way of using fixed length
> records to implement this variable length shared rmap record
> [13/11/14 10:38] <dchinner_> which uses the high bit of the start block
> number to distinguish between the types of records
> [13/11/14 10:39] <dchinner_> and, in some cases, also uses the high bit of
> the extent length field to hold more information again.
> [13/11/14 10:40] <dchinner_> but the issue is that it's quite complicated
> [13/11/14 10:40] <dchinner_> and there's some interesting warts around
> records that span multiple btree blocks
> [13/11/14 10:41] <dchinner_> because they've been shared across hundreds
> of owners
> [13/11/14 10:43] <dchinner_> I can't see any obvious way of tracking owner
> information another way when we have shared extents
> [13/11/14 10:44] <dchinner_> it's an 1:N mapping
> [13/11/14 10:44] <foster> this information that's encoded in the record
> indicates the length of the record, or some kind of record chaining
> method..?
> [13/11/14 10:44] <dchinner_> both ;)
> [13/11/14 10:45] <foster> heh, ok
> [13/11/14 10:45] <dchinner_> the first record becomes { start block,
> length, refcount, owner records}
> [13/11/14 10:45] <dchinner_> and so a shared extent record looks like:
> [13/11/14 10:46] <dchinner_> {{ master extent record}, {owner record },
> {owner record }, .... {owner record}}
> [13/11/14 10:46] <dchinner_> when an owner record is simply {owner #1,
> owner #2}
> [13/11/14 10:47] <dchinner_> so both the master record and the owner
> record are teh same size (16 bytes)
> [13/11/14 10:48] <dchinner_> so you can see how it can be problematic when
> a btree block only contains owner records
> [13/11/14 10:48] <dchinner_> there's no start/len information, and so it's
> problematic for indexing that block in the higher levels of the btree
> [13/11/14 10:49] <dchinner_> as the higher levels need to point to the
> master records....
> [13/11/14 10:49] <foster> I'm missing how the master record refers to the
> owner record
> [13/11/14 10:50] <foster> does it, or it's simply followed by the owner
> records?
> [13/11/14 10:50] <dchinner_> owner records always follow the master record
> [13/11/14 10:50] <foster> ok
> [13/11/14 10:50] <dchinner_> right
> [13/11/14 10:51] <dchinner_> So what I'm wondering is whether you think
> this is way too complex
> [13/11/14 10:51] <dchinner_> or whether we might do better to have some
> other representation
> [13/11/14 10:52] <dchinner_> such as keeping owner records in a different
> tree
> [13/11/14 10:53] <dchinner_> or even not keeping them at all for shared
> extents
> [13/11/14 10:53] <foster> sounds somewhat hairy at first, my first
> reaction is to think about whether there's some kind of level of indirection
> [13/11/14 10:53] <foster> but i obviously haven't thought about this much
> at all
> [13/11/14 10:54] <dchinner_> right, and I'm trying not to expose you to
> allthe gruesome details of what I've come up with ;)
> [13/11/14 10:54] <dchinner_> just enough to describe the problem
> [13/11/14 10:54] <foster> understood, i think i get the gist of it
> [13/11/14 10:54] <foster> effectively creating first order/second order
> records within the tree
> [13/11/14 10:55] <dchinner_> right
> [13/11/14 10:55] <foster> or chaining or whatever the best terminology is
> ;)
> [13/11/14 10:56] <dchinner_> hmmm, which triggers me immediately to think
> of an interesting btree extension
> [13/11/14 10:57] <foster> hmm, a second tree is an interesting thought
> [13/11/14 10:57] <foster> or some kind of magic/hidden owner inode that
> handles shared records
> [13/11/14 10:57] <dchinner_> which, at first glance, makes it very similar
> to the directory btree structure....
> [13/11/14 10:59] <dchinner_> need to think about that more....
> [13/11/14 11:02] <dchinner_> (basically adding another level below the
> current leaf level of the btree that only holds owner records)
> [13/11/14 11:06] <foster> interesting, though i'm not familiar enough with
> the on-disk dir structure to reason about off hand
>

--20cf303f6486e709ad05099f02f1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span class=3D"im" style=3D"font-size:13px"><div>Hi,</div>=
<div><br></div><div>Good to hear about the progress related to rmap. We&#39=
;ll continue</div><div>working here on our side.</div><div><br></div></span=
><div style=3D"font-size:13px">As we mentioned previously, we&#39;ve famili=
arized ourselves</div><div style=3D"font-size:13px">with the fiemap interfa=
ce and developed an understanding</div><div style=3D"font-size:13px">of how=
 the ioctl works.</div><div style=3D"font-size:13px"><br></div><div style=
=3D"font-size:13px">We also went through different discussions on the maili=
ng=C2=A0</div><div style=3D"font-size:13px">list related to fiemap, as well=
 as obtained the latest patches.</div><div style=3D"font-size:13px"><br></d=
iv><div style=3D"font-size:13px">While working on the rmap, would it be pos=
sible for you to=C2=A0</div><div style=3D"font-size:13px">give us some esse=
ntial details about the required fiemap=C2=A0</div><div style=3D"font-size:=
13px">interface, so that we can obtain a clearer understanding of</div><div=
 style=3D"font-size:13px">=C2=A0what we are required to do.</div><div class=
=3D"" style=3D"font-size:13px"><div id=3D":16y" class=3D"" tabindex=3D"0"><=
img class=3D"" src=3D"https://ssl.gstatic.com/ui/v1/icons/mail/images/clear=
dot.gif"></div></div><div class=3D"" style=3D"font-size:13px"><span class=
=3D"im"><div><br></div><div><br></div><div>Regards,</div><div>A-DRS.</div><=
/span></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote"=
>On Mon, Dec 1, 2014 at 10:01 AM, Dave Chinner <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&=
gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Mon=
, Dec 01, 2014 at 01:29:47AM +0530, Somdeep Dey wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; We&#39;ve now resumed working on the xfs_fsr utility as discussed befo=
re, after<br>
&gt; our exams.<br>
&gt;<br>
&gt; The first task that we undertook was to use fiemap to get file extent<=
br>
&gt; mappings and tried to correlate the output with the information obtain=
ed<br>
&gt; from xfs_bmap. For this we used the two underlying structures fiemap<b=
r>
&gt; and fiemap_extent. We&#39;re now trying to use the available free spac=
e mapping<br>
&gt; patches to get free spaces in the file system.<br>
&gt;<br>
&gt; We also wanted to ask about the current status of the rmap, as we&#39;=
ll<br>
&gt; be required to define the interfaces that query it, as a key component=
 of<br>
&gt; our<br>
&gt; work.<br>
<br>
</span>The rmap design is slowly being thrashed out. Brian and I had a<br>
discussion about it on IRC a couple of weeks ago (below).<br>
<br>
I&#39;m relatively close to having a proof of concept for single-owner<br>
rmap btrees that works...<br>
<br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
<br>
>From #xfs on <a href=3D"http://freenode.net" target=3D"_blank">freenode.net=
</a><br>
<br>
[13/11/14 10:07] &lt;dchinner_&gt; foster: still around?<br>
[13/11/14 10:10] &lt;foster&gt; dchinner_: yep<br>
[13/11/14 10:27] &lt;dchinner_&gt; foster: been prototyping reverse mapping=
 btree code over the past couple of days<br>
[13/11/14 10:28] &lt;dchinner_&gt; couple of interesting issues have come u=
p that need discussion<br>
[13/11/14 10:28] &lt;dchinner_&gt; I think I have solutions to them, but I&=
#39;m sure there are other ways of solving the problems<br>
[13/11/14 10:28] &lt;dchinner_&gt; basically I want the rmap btree for two =
purposes<br>
[13/11/14 10:29] &lt;dchinner_&gt; 1) to keep owner information so we can d=
o block-to-owner lookups efficiently<br>
[13/11/14 10:29] &lt;dchinner_&gt; e.g. to identify the files corrupted by =
bad sectors<br>
[13/11/14 10:29] &lt;dchinner_&gt; found during a media scan<br>
[13/11/14 10:31] &lt;dchinner_&gt; or to provide sufficient redundant infor=
mation for an online rebuild of a corrupted free space btree<br>
[13/11/14 10:32] &lt;foster&gt; so a btree that maps extents to inodes or s=
omething of that nature?<br>
[13/11/14 10:32] &lt;dchinner_&gt; exactly<br>
[13/11/14 10:32] &lt;dchinner_&gt; per-ag btree<br>
[13/11/14 10:32] &lt;dchinner_&gt; that contains { start block, length, own=
er }<br>
[13/11/14 10:32] &lt;dchinner_&gt; records<br>
[13/11/14 10:32] &lt;foster&gt; ok<br>
[13/11/14 10:33] &lt;dchinner_&gt; that&#39;s relatively easy to do<br>
[13/11/14 10:33] &lt;dchinner_&gt; The patches I&#39;ve written do that.<br=
>
[13/11/14 10:33] &lt;dchinner_&gt; (not that it does anything other than co=
mpile yet)<br>
[13/11/14 10:33] &lt;dchinner_&gt; however, there is a second reason for ha=
ving a reverse mapping tree<br>
[13/11/14 10:34] &lt;dchinner_&gt; it&#39;s for reference counting extents =
shared between inodes<br>
[13/11/14 10:34] &lt;foster&gt; ah, reflink?<br>
[13/11/14 10:34] &lt;dchinner_&gt; i.e. to implement reflink semantics<br>
[13/11/14 10:34] &lt;dchinner_&gt; *nod*<br>
[13/11/14 10:35] &lt;dchinner_&gt; this doesn&#39;t affect how the ramp btr=
ee interacts with the rest of the allocation/freeing code<br>
[13/11/14 10:35] &lt;dchinner_&gt; but it does affect the &quot;extent owne=
r&quot; tracking<br>
[13/11/14 10:35] &lt;dchinner_&gt; i.e. we can now have multiple owners of =
an extent<br>
[13/11/14 10:36] &lt;dchinner_&gt; so that btree record now becomes {stat, =
len, refcount, owner, owner, .... owner }<br>
[13/11/14 10:36] &lt;foster&gt; yeah<br>
[13/11/14 10:36] &lt;dchinner_&gt; and we can&#39;t do that with the generi=
c btree infrastructure because it&#39;s all based around fixed length recor=
ds<br>
[13/11/14 10:38] &lt;dchinner_&gt; I&#39;ve come up with a way of using fix=
ed length records to implement this variable length shared rmap record<br>
[13/11/14 10:38] &lt;dchinner_&gt; which uses the high bit of the start blo=
ck number to distinguish between the types of records<br>
[13/11/14 10:39] &lt;dchinner_&gt; and, in some cases, also uses the high b=
it of the extent length field to hold more information again.<br>
[13/11/14 10:40] &lt;dchinner_&gt; but the issue is that it&#39;s quite com=
plicated<br>
[13/11/14 10:40] &lt;dchinner_&gt; and there&#39;s some interesting warts a=
round records that span multiple btree blocks<br>
[13/11/14 10:41] &lt;dchinner_&gt; because they&#39;ve been shared across h=
undreds of owners<br>
[13/11/14 10:43] &lt;dchinner_&gt; I can&#39;t see any obvious way of track=
ing owner information another way when we have shared extents<br>
[13/11/14 10:44] &lt;dchinner_&gt; it&#39;s an 1:N mapping<br>
[13/11/14 10:44] &lt;foster&gt; this information that&#39;s encoded in the =
record indicates the length of the record, or some kind of record chaining =
method..?<br>
[13/11/14 10:44] &lt;dchinner_&gt; both ;)<br>
[13/11/14 10:45] &lt;foster&gt; heh, ok<br>
[13/11/14 10:45] &lt;dchinner_&gt; the first record becomes { start block, =
length, refcount, owner records}<br>
[13/11/14 10:45] &lt;dchinner_&gt; and so a shared extent record looks like=
:<br>
[13/11/14 10:46] &lt;dchinner_&gt; {{ master extent record}, {owner record =
}, {owner record }, .... {owner record}}<br>
[13/11/14 10:46] &lt;dchinner_&gt; when an owner record is simply {owner #1=
, owner #2}<br>
[13/11/14 10:47] &lt;dchinner_&gt; so both the master record and the owner =
record are teh same size (16 bytes)<br>
[13/11/14 10:48] &lt;dchinner_&gt; so you can see how it can be problematic=
 when a btree block only contains owner records<br>
[13/11/14 10:48] &lt;dchinner_&gt; there&#39;s no start/len information, an=
d so it&#39;s problematic for indexing that block in the higher levels of t=
he btree<br>
[13/11/14 10:49] &lt;dchinner_&gt; as the higher levels need to point to th=
e master records....<br>
[13/11/14 10:49] &lt;foster&gt; I&#39;m missing how the master record refer=
s to the owner record<br>
[13/11/14 10:50] &lt;foster&gt; does it, or it&#39;s simply followed by the=
 owner records?<br>
[13/11/14 10:50] &lt;dchinner_&gt; owner records always follow the master r=
ecord<br>
[13/11/14 10:50] &lt;foster&gt; ok<br>
[13/11/14 10:50] &lt;dchinner_&gt; right<br>
[13/11/14 10:51] &lt;dchinner_&gt; So what I&#39;m wondering is whether you=
 think this is way too complex<br>
[13/11/14 10:51] &lt;dchinner_&gt; or whether we might do better to have so=
me other representation<br>
[13/11/14 10:52] &lt;dchinner_&gt; such as keeping owner records in a diffe=
rent tree<br>
[13/11/14 10:53] &lt;dchinner_&gt; or even not keeping them at all for shar=
ed extents<br>
[13/11/14 10:53] &lt;foster&gt; sounds somewhat hairy at first, my first re=
action is to think about whether there&#39;s some kind of level of indirect=
ion<br>
[13/11/14 10:53] &lt;foster&gt; but i obviously haven&#39;t thought about t=
his much at all<br>
[13/11/14 10:54] &lt;dchinner_&gt; right, and I&#39;m trying not to expose =
you to allthe gruesome details of what I&#39;ve come up with ;)<br>
[13/11/14 10:54] &lt;dchinner_&gt; just enough to describe the problem<br>
[13/11/14 10:54] &lt;foster&gt; understood, i think i get the gist of it<br=
>
[13/11/14 10:54] &lt;foster&gt; effectively creating first order/second ord=
er records within the tree<br>
[13/11/14 10:55] &lt;dchinner_&gt; right<br>
[13/11/14 10:55] &lt;foster&gt; or chaining or whatever the best terminolog=
y is ;)<br>
[13/11/14 10:56] &lt;dchinner_&gt; hmmm, which triggers me immediately to t=
hink of an interesting btree extension<br>
[13/11/14 10:57] &lt;foster&gt; hmm, a second tree is an interesting though=
t<br>
[13/11/14 10:57] &lt;foster&gt; or some kind of magic/hidden owner inode th=
at handles shared records<br>
[13/11/14 10:57] &lt;dchinner_&gt; which, at first glance, makes it very si=
milar to the directory btree structure....<br>
[13/11/14 10:59] &lt;dchinner_&gt; need to think about that more....<br>
[13/11/14 11:02] &lt;dchinner_&gt; (basically adding another level below th=
e current leaf level of the btree that only holds owner records)<br>
[13/11/14 11:06] &lt;foster&gt; interesting, though i&#39;m not familiar en=
ough with the on-disk dir structure to reason about off hand<br>
</blockquote></div><br></div>

--20cf303f6486e709ad05099f02f1--


--===============6685637378071984664==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6685637378071984664==--
