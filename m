Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6CF547F55
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 06:14:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3F68D304032
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 04:14:50 -0700 (PDT)
Received: from mail-ig0-f171.google.com (mail-ig0-f171.google.com
	[209.85.213.171]) by cuda.sgi.com with ESMTP id
	myiqjemvWXCidO5E (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2015 04:14:45 -0700 (PDT)
Received: by igfj19 with SMTP id j19so33488303igf.1
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2015 04:14:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55C4E007.90709@sandeen.net>
References: <55C43FBA.1080408@sandeen.net>
	<20150807113742.GB8322@bfoster.bfoster>
	<55C4E007.90709@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 13 Aug 2015 13:14:25 +0200
Message-ID: <CACj3i72_w6fKaJyDhaHb-vEA056kSSQnucWkWfO2LsVxci+yfA@mail.gmail.com>
Subject: Re: [PATCH] mkfs.xfs: fix ftype-vs-crc option combination testing
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3133938371900600877=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, xfs-oss <xfs@oss.sgi.com>

--===============3133938371900600877==
Content-Type: multipart/alternative; boundary=089e013a01c843ea15051d2f711b

--089e013a01c843ea15051d2f711b
Content-Type: text/plain; charset=UTF-8

On Fri, Aug 7, 2015 at 6:42 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> >
> > IIRC, I think this is one of the core problems the big mkfs option
> > parsing rework that Jan is working on is supposed to fix.
>
> Yeah, I think so - Jan, if this gets in your way, let us know -
> I didn't mean to make your life difficult by fixing little
> things while you work.  :)

Well, I would not mind if the entire codebase froze... :-D
But realistically, every time I do git fetch I get so many collisions that
one
more or less changes nothing. :-)

And yes, in my tests I'm trying to cover the arguments order issue too.

Cheers,
Jan

--
Jan Tulak
jtulak@redhat.com

--089e013a01c843ea15051d2f711b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br>On Fri, Aug 7, 2015 at 6:42 PM, Eric Sandeen &lt;<a hr=
ef=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt; wrote:<br>&gt=
;<br>&gt; &gt;<br>&gt; &gt; IIRC, I think this is one of the core problems =
the big mkfs option<br>&gt; &gt; parsing rework that Jan is working on is s=
upposed to fix.<br>&gt;<br>&gt; Yeah, I think so - Jan, if this gets in you=
r way, let us know -<br>&gt; I didn&#39;t mean to make your life difficult =
by fixing little<br>&gt; things while you work. =C2=A0:)<br><br>Well, I wou=
ld not mind if the entire codebase froze... :-D<br>But realistically, every=
 time I do git fetch I get so many collisions that one=C2=A0<div>more or le=
ss=C2=A0changes nothing. :-)</div><div><br></div><div>And yes, in my tests =
I&#39;m trying to cover the arguments order issue too.</div><div><br></div>=
<div>Cheers,</div><div>Jan<br><br>--<br>Jan Tulak<br><a href=3D"mailto:jtul=
ak@redhat.com">jtulak@redhat.com</a></div></div>

--089e013a01c843ea15051d2f711b--


--===============3133938371900600877==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3133938371900600877==--
