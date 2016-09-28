Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E28727CA0
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 20:30:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9AD2F8F8033
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 18:29:57 -0700 (PDT)
Received: from mail-ua0-f174.google.com (mail-ua0-f174.google.com
	[209.85.217.174]) by cuda.sgi.com with ESMTP id
	H0SF3JlDx9Q6wAFm (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 27 Sep 2016 18:29:55 -0700 (PDT)
Received: by mail-ua0-f174.google.com with SMTP id n13so25877964uaa.3
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 18:29:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160927214129.GC27872@dastard>
References: <CAOSFFyjWR4ASud5aSoYTJKweWA244oMwT9_LRSzwnr0Qftg7Eg@mail.gmail.com>
	<20160927170443.GR9314@birch.djwong.org>
	<CAOSFFyhP251ifYzWtRfcStxX7oy78EDvqWfi0=2h4GhTv4=pJw@mail.gmail.com>
	<20160927214129.GC27872@dastard>
From: murali krishna <murali.marimekala@gmail.com>
Date: Tue, 27 Sep 2016 21:29:33 -0400
Message-ID: <CAOSFFygazt7umH314ZKXgbe0RrRCDL_0gvojHKnuGHxy_XZV+g@mail.gmail.com>
Subject: Re: Clarification required about xfs_metadump and xfs_mdrestore
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5638728505435402675=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

--===============5638728505435402675==
Content-Type: multipart/alternative; boundary=001a1145c86654ef6a053d874c93

--001a1145c86654ef6a053d874c93
Content-Type: text/plain; charset=UTF-8

Hi Dave,

Thanks for the clarification and inputs. Your support is much appreciated.

Murali

On Tue, Sep 27, 2016 at 5:41 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Sep 27, 2016 at 01:27:12PM -0400, murali krishna wrote:
> > Hi Darrick,
> >
> > Thanks for the response.
> >
> > Could you please clarify if there is any strong reason behind in stating
> to
> > use xfs_metadump and xfs_mdrestore as just debugging tools in their
> > respective man pages ?
>
> The man page is simply stating the truth - metadump/restore are
> debugging tools used by XFS developers for obtaining information
> required for forensic analysis of filesystem failures.
>
> What you are wanting to do will not work, is not supported, and you
> get to keep all the broken bits to yourself if you try it.
> Every XFS developer you ask will say the same thing:
> xfsdump/encrypt/mkfs/xfs_restore is the only way to do what you want
> to do.
>
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a1145c86654ef6a053d874c93
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Dave,<div><br></div><div>Thanks for the clarification a=
nd inputs. Your support is much appreciated.</div><div><div class=3D"gmail_=
extra"><div><div class=3D"gmail_signature" data-smartmail=3D"gmail_signatur=
e"><br>
<div>Murali</div></div></div>
<br><div class=3D"gmail_quote">On Tue, Sep 27, 2016 at 5:41 PM, Dave Chinne=
r <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_b=
lank">david@fromorbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gma=
il_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-lef=
t:1ex"><span class=3D"">On Tue, Sep 27, 2016 at 01:27:12PM -0400, murali kr=
ishna wrote:<br>
&gt; Hi Darrick,<br>
&gt;<br>
&gt; Thanks for the response.<br>
&gt;<br>
&gt; Could you please clarify if there is any strong reason behind in stati=
ng to<br>
&gt; use xfs_metadump and xfs_mdrestore as just debugging tools in their<br=
>
&gt; respective man pages ?<br>
<br>
</span>The man page is simply stating the truth - metadump/restore are<br>
debugging tools used by XFS developers for obtaining information<br>
required for forensic analysis of filesystem failures.<br>
<br>
What you are wanting to do will not work, is not supported, and you<br>
get to keep all the broken bits to yourself if you try it.<br>
Every XFS developer you ask will say the same thing:<br>
xfsdump/encrypt/mkfs/xfs_<wbr>restore is the only way to do what you want<b=
r>
to do.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div></div></div>

--001a1145c86654ef6a053d874c93--


--===============5638728505435402675==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5638728505435402675==--
