Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2E2Yfa7105550 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 21:34:41 -0500
Received: from cartman.its.monash.edu.au (cartman.its.monash.edu.au
	[130.194.13.166]) by cuda.sgi.com with ESMTP id
	ahJF71deXYfUG6WE for <xfs@oss.sgi.com>;
	Tue, 13 Mar 2012 19:34:39 -0700 (PDT)
Received: from chapman.its.monash.edu.au ([130.194.13.89])
	by cartman.its.monash.edu.au
	(Sun Java System Messaging Server 6.2-4.03 (built Sep 22 2005))
	with ESMTP id <0M0U008W6SHMKH60@cartman.its.monash.edu.au> for
	xfs@oss.sgi.com; Wed, 14 Mar 2012 13:34:34 +1100 (EST)
Received: from chapman.its.monash.edu.au (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id D8A287E611C	for <xfs@oss.sgi.com>;
	Wed, 14 Mar 2012 13:34:33 +1100 (EST)
Received: from mail-pz0-f45.google.com
	(mail-pz0-f45.google.com [209.85.210.45])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)	by chapman.its.monash.edu.au
	(Postfix) with ESMTPS id A71127E6107	for <xfs@oss.sgi.com>; Wed,
	14 Mar 2012 13:34:32 +1100 (EST)
Received: by dadp14 with SMTP id p14so2170065dad.32 for <xfs@oss.sgi.com>; Tue,
	13 Mar 2012 19:34:29 -0700 (PDT)
Date: Wed, 14 Mar 2012 13:34:29 +1100
From: Nathan Scott <nathans@debian.org>
Subject: Re: [PATCH 4/8 v2] xfs: use common code for quota statistics
In-reply-to: <20120313214027.GF5091@dastard>
Message-id: <CAAp5ZgO+jJM5WHzbFLE98FoGmqztWZoQZ6u5-Zp=b6ow10JV=w@mail.gmail.com>
MIME-version: 1.0
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.060961294@bombadil.infradead.org>
	<20120221014809.GA18227@infradead.org> <20120312175519.GE7762@sgi.com>
	<20120313084241.GA359@infradead.org> <20120313152748.GG7762@sgi.com>
	<20120313214027.GF5091@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7819892620021237801=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============7819892620021237801==
Content-type: multipart/alternative; boundary=e89a8ffba955997c7f04bb2ad099

--e89a8ffba955997c7f04bb2ad099
Content-Type: text/plain; charset=ISO-8859-1

Hey guys,

On 14 March 2012 08:40, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Mar 13, 2012 at 10:27:48AM -0500, Ben Myers wrote:
> > On Tue, Mar 13, 2012 at 04:42:42AM -0400, Christoph Hellwig wrote:
> > > On Mon, Mar 12, 2012 at 12:55:19PM -0500, Ben Myers wrote:
> > > > > +static int xqm_proc_show(struct seq_file *m, void *v)
> > > > > +{
> > > > > +       /* maximum; incore; ratio free to inuse; freelist */
> > > > > +       seq_printf(m, "%d\t%d\t%d\t%u\n",
> > > > > +                       0,
> > > > > +                       counter_val(XFSSTAT_END_XQMSTAT),
> > > >
> > > > This patch looks great.  It might break some PCP scripts, I'm not
> sure.
> > >
> > > Why would it break them?  The existing stats are still kept around, and
> > > new additions to the main stats file are expected to happen once in a
> > > while.
> >
> > I'm not sure that it would.  You've added a line to the common stats
> > procfile, and the pmda might expect the xpc line immediately after ibt2.
>

In an amusing twist, it turns out that the quota stats were originally part
of
the main procfs stats file and were later on moved into their own file as
part of making xqm modular.  So, by good fortune PCP already supports
a move back into the original stats file for these stats, provided the same
prefix ("qm") is used.


>
> IIRC the pmda triggers off the descriptor at the start of the line.
>

That's correct.


> It ignores lines that it doesn't understand the descriptor for (like
> all the v2 btree stats). I should probably update the pmda fo all
> those stats....
>

That was done quite awhile back (mid-2010), unless there's some other
stats come along since then that I don't know about yet?  (are these the
ones you mean, Dave?...)

$ egrep '^[a-z]+2 ' /proc/fs/xfs/stat
abtb2 4769967 54332939 635853 643428 507 508 282413 22672 61298 45587 1093
1111 1600 1619 393677507
abtc2 10166604 113971561 4264119 4272402 1213 1214 77487 9464 29584 35760
1551 1571 2764 2785 1438715558
bmbt2 152523 1231148 52950 42558 0 0 1372 1385 5117 1340 85 48 85 48 1545160
ibt2 9475130 102652889 5672 2878 0 0 6549337 15214 801 869 17 0 17 0 1202730
$

( those are the xfs.btree.alloc_blocks.*, xfs.btree.alloc_contig.*,
xfs.btree.block_map.*, and xfs.btree.inode.lookup.* metrics )

cheers.

--
Nathan

--e89a8ffba955997c7f04bb2ad099
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hey guys,<br><br><div class=3D"gmail_quote">On 14 March 2012 08:40, Dave Ch=
inner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fr=
omorbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im">On Tue, Mar 13, 2012 at 10:27:48AM -0500, Ben Myers wrote=
:<br>
&gt; On Tue, Mar 13, 2012 at 04:42:42AM -0400, Christoph Hellwig wrote:<br>
&gt; &gt; On Mon, Mar 12, 2012 at 12:55:19PM -0500, Ben Myers wrote:<br>
&gt; &gt; &gt; &gt; +static int xqm_proc_show(struct seq_file *m, void *v)<=
br>
&gt; &gt; &gt; &gt; +{<br>
&gt; &gt; &gt; &gt; + =A0 =A0 =A0 /* maximum; incore; ratio free to inuse; =
freelist */<br>
&gt; &gt; &gt; &gt; + =A0 =A0 =A0 seq_printf(m, &quot;%d\t%d\t%d\t%u\n&quot=
;,<br>
&gt; &gt; &gt; &gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0,<br>
&gt; &gt; &gt; &gt; + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 counter_v=
al(XFSSTAT_END_XQMSTAT),<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; This patch looks great. =A0It might break some PCP scripts, =
I&#39;m not sure.<br>
&gt; &gt;<br>
&gt; &gt; Why would it break them? =A0The existing stats are still kept aro=
und, and<br>
&gt; &gt; new additions to the main stats file are expected to happen once =
in a<br>
&gt; &gt; while.<br>
&gt;<br>
&gt; I&#39;m not sure that it would. =A0You&#39;ve added a line to the comm=
on stats<br>
&gt; procfile, and the pmda might expect the xpc line immediately after ibt=
2.<br></div></blockquote><div><br>In an amusing twist, it turns out that th=
e quota stats were originally part of<br>the main procfs stats file and wer=
e later on moved into their own file as<br>
part of making xqm modular.=A0 So, by good fortune PCP already supports<br>=
a move back into the original stats file for these stats, provided the same=
<br>prefix (&quot;qm&quot;) is used.<br>=A0</div><blockquote class=3D"gmail=
_quote" style=3D"margin:0pt 0pt 0pt 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">
<div class=3D"im">
<br>
</div>IIRC the pmda triggers off the descriptor at the start of the line.<b=
r></blockquote><div><br>That&#39;s correct.<br>=A0</div><blockquote class=
=3D"gmail_quote" style=3D"margin:0pt 0pt 0pt 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">

It ignores lines that it doesn&#39;t understand the descriptor for (like<br=
>
all the v2 btree stats). I should probably update the pmda fo all<br>
those stats....<br></blockquote><div><br>That was done quite awhile back (m=
id-2010), unless there&#39;s some other<br>stats come along since then that=
 I don&#39;t know about yet?=A0 (are these the<br>ones you mean, Dave?...)<=
br>
<br></div></div>$ egrep &#39;^[a-z]+2 &#39; /proc/fs/xfs/stat <br>abtb2 476=
9967 54332939 635853 643428 507 508 282413 22672 61298 45587 1093 1111 1600=
 1619 393677507<br>abtc2 10166604 113971561 4264119 4272402 1213 1214 77487=
 9464 29584 35760 1551 1571 2764 2785 1438715558<br>
bmbt2 152523 1231148 52950 42558 0 0 1372 1385 5117 1340 85 48 85 48 154516=
0<br>ibt2 9475130 102652889 5672 2878 0 0 6549337 15214 801 869 17 0 17 0 1=
202730<br>$ <br><br>( those are the xfs.btree.alloc_blocks.*, xfs.btree.all=
oc_contig.*,<br>
xfs.btree.block_map.*, and xfs.btree.inode.lookup.* metrics )<br><br>cheers=
.<br><br>--<br>Nathan<br>

--e89a8ffba955997c7f04bb2ad099--


--===============7819892620021237801==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7819892620021237801==--
