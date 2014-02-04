Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C27D7F52
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 11:35:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EBFADAC003
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 09:35:09 -0800 (PST)
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	KrPu6iEFBi4Eid5g (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 09:35:08 -0800 (PST)
Received: by mail-ob0-f181.google.com with SMTP id va2so9611793obc.26
	for <xfs@oss.sgi.com>; Tue, 04 Feb 2014 09:35:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140204172723.GA11325@lenny.home.zabbo.net>
References: <CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<52EFC271.3090205@oracle.com>
	<20140204124409.GG10323@ZenIV.linux.org.uk>
	<20140204125220.GB12440@kmo-pixel>
	<20140204151728.GH10323@ZenIV.linux.org.uk>
	<20140204172723.GA11325@lenny.home.zabbo.net>
Date: Tue, 4 Feb 2014 09:35:06 -0800
Message-ID: <CALJ65z=HhYnc1eD-Kpk0s=Eod6sHJq1jnJirUNc7-9s1rFV1HQ@mail.gmail.com>
Subject: Re: [RFC] unifying write variants for filesystems
From: Kent Overstreet <kmo@daterainc.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7456271113385872533=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Zach Brown <zab@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Steve French <sfrench@samba.org>, Dave Kleikamp <dave.kleikamp@oracle.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>, Joel Becker <jlbec@evilplan.org>

--===============7456271113385872533==
Content-Type: multipart/alternative; boundary=001a11c306f0a8882804f1980fde

--001a11c306f0a8882804f1980fde
Content-Type: text/plain; charset=ISO-8859-1

On Feb 4, 2014 6:27 PM, "Zach Brown" <zab@redhat.com> wrote:
>
> > I definitely don't buy "bio is a natural object for carrying an array
> > of pieces of pages"; not sure if that's what you implied in earlier
> > thread, but it has too much baggage from block subsystem *and* it lacks
> > the things we may want to associate with individual elements of such
> > array (starting with "how can I steal that page?" method).
>
> I think Kent is talking about what happens after the user addresses are
> consumed.  Turning dio into more of a bio mapping and redirection engine
> would use more of the bio machinery instead of the bits that dio has
> implemented itself with state in struct dio that hangs off the bios.  I
> imagine it'd still make sense to clean up the addresses/pages arguments
> that feed that engine.  (And give another entry point that already has
> bios for callers like loop, etc.)

Yeah, precisely. I think we can push the point at which pages are pinned at
least a fair but higher than it is now, and if we can do that we definitely
should be working with a generic "bag of pinned pages" struct - and much
better to use struct bio than add another one. Bios may not be perfect but
at least some of the block layer specific cruft can be gotten rid of (and
is on my todo list)

>
> > BTW, folks, any suggestions about the name of that "memory stream"
thing?
> > struct iov_iter really implies iterator for iovec and more generic name
> > would probably be better...  struct mem_stream would probably do if
nobody
> > comes up with better variant, but it's long and somewhat clumsy...
>
> I don't like 'stream'.  To me that sounds more strictly advancing than I
> think this'd be capable of.  Maybe something dirt simple like 'mem_vec'?
> With 'mvec_' call prefixes?
>
> Or kiobuf!  *runs*

*cuts you*

--001a11c306f0a8882804f1980fde
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
On Feb 4, 2014 6:27 PM, &quot;Zach Brown&quot; &lt;<a href=3D"mailto:zab@re=
dhat.com">zab@redhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; I definitely don&#39;t buy &quot;bio is a natural object for carr=
ying an array<br>
&gt; &gt; of pieces of pages&quot;; not sure if that&#39;s what you implied=
 in earlier<br>
&gt; &gt; thread, but it has too much baggage from block subsystem *and* it=
 lacks<br>
&gt; &gt; the things we may want to associate with individual elements of s=
uch<br>
&gt; &gt; array (starting with &quot;how can I steal that page?&quot; metho=
d).<br>
&gt;<br>
&gt; I think Kent is talking about what happens after the user addresses ar=
e<br>
&gt; consumed. =A0Turning dio into more of a bio mapping and redirection en=
gine<br>
&gt; would use more of the bio machinery instead of the bits that dio has<b=
r>
&gt; implemented itself with state in struct dio that hangs off the bios. =
=A0I<br>
&gt; imagine it&#39;d still make sense to clean up the addresses/pages argu=
ments<br>
&gt; that feed that engine. =A0(And give another entry point that already h=
as<br>
&gt; bios for callers like loop, etc.)</p>
<p dir=3D"ltr">Yeah, precisely. I think we can push the point at which page=
s are pinned at least a fair but higher than it is now, and if we can do th=
at we definitely should be working with a generic &quot;bag of pinned pages=
&quot; struct - and much better to use struct bio than add another one. Bio=
s may not be perfect but at least some of the block layer specific cruft ca=
n be gotten rid of (and is on my todo list)</p>

<p dir=3D"ltr">&gt;<br>
&gt; &gt; BTW, folks, any suggestions about the name of that &quot;memory s=
tream&quot; thing?<br>
&gt; &gt; struct iov_iter really implies iterator for iovec and more generi=
c name<br>
&gt; &gt; would probably be better... =A0struct mem_stream would probably d=
o if nobody<br>
&gt; &gt; comes up with better variant, but it&#39;s long and somewhat clum=
sy...<br>
&gt;<br>
&gt; I don&#39;t like &#39;stream&#39;. =A0To me that sounds more strictly =
advancing than I<br>
&gt; think this&#39;d be capable of. =A0Maybe something dirt simple like &#=
39;mem_vec&#39;?<br>
&gt; With &#39;mvec_&#39; call prefixes?<br>
&gt;<br>
&gt; Or kiobuf! =A0*runs*</p>
<p dir=3D"ltr">*cuts you*</p>

--001a11c306f0a8882804f1980fde--


--===============7456271113385872533==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7456271113385872533==--
