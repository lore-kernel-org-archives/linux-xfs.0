Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 404117F37
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 20:31:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B3F01AC002
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 18:31:03 -0700 (PDT)
Received: from mail-ie0-f170.google.com (mail-ie0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	xcaS5H5s4GPKFmvJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 22 Apr 2013 18:31:02 -0700 (PDT)
Received: by mail-ie0-f170.google.com with SMTP id at1so119661iec.29
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 18:31:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5175DB63.6030501@sandeen.net>
References: <516C89DF.4070904@redhat.com> <517596BA.3060408@sandeen.net>
	<20130423000835.GL30622@dastard> <5175DB63.6030501@sandeen.net>
Date: Tue, 23 Apr 2013 09:31:01 +0800
Message-ID: <CADFMGu+aZzCMuJSOFFjDTW+m3OonwxxM=Bbpy4mNfQtMjfp-WQ@mail.gmail.com>
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5152743278686934980=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5152743278686934980==
Content-Type: multipart/alternative; boundary=14dae9340ee75e904b04dafd232c

--14dae9340ee75e904b04dafd232c
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Terrific. Thank you Eric, Brian, and xfs experts. You have helped us a lot.
I'll test the path.


2013/4/23 Eric Sandeen <sandeen@sandeen.net>

> On 4/22/13 7:08 PM, Dave Chinner wrote:
> > On Mon, Apr 22, 2013 at 02:59:54PM -0500, Eric Sandeen wrote:
> >> On 4/15/13 6:14 PM, Brian Foster wrote:
> >>> Hi,
> >>>
> >>> Thanks for the data in the previous thread:
> >>>
> >>> http://oss.sgi.com/archives/xfs/2013-04/msg00327.html
> >>>
> >>> I'm spinning off a new thread specifically for this because the
> original
> >>> thread is already too large and scattered to track. As Eric stated,
> >>> please try to keep data contained in as few messages as possible.
> >>>
> >>
> >> Well, it's always simple in the end.  It just took a lot of debugging
> >> to figure out what was happening - we do appreciate your help with tha=
t!
> >>
> >> We were able to create a local reproducer, and it looks like
> >> this patch fixes things:
> >>
> >> commit aae8a97d3ec30788790d1720b71d76fd8eb44b73
> >> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> >> Date:   Sat Jan 29 18:43:27 2011 +0530
> >>
> >>     fs: Don't allow to create hardlink for deleted file
> >
> > Good find Eric - great work on the reproducer script.
> >
> > FWIW, can you confirm that a debug kernel assert fails
> > with a non-zero link count in xfs_bumplink() with your test case?
> >
> > int
> > xfs_bumplink(
> >         xfs_trans_t *tp,
> >         xfs_inode_t *ip)
> > {
> >         xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
> >
> >>>>>>   ASSERT(ip->i_d.di_nlink > 0);
>
> Yep, it does, I put a printk in there when I was testing
> and it fired.
>
> Guess we should have tested a debug xfs right off the bat ;)
>
> >         ip->i_d.di_nlink++;
> >         inc_nlink(VFS_I(ip));
> >
> > If it does, we should consider this a in-memory corruption case and
> > return and trigger a shutdown here....
>
> I suppose that makes sense, it'd be a much less cryptic failure for
> something that will fail soon anyway.
>
> -Eric
>
> > Cheers,
> >
> > Dave.
> >
>
>


--=20
=B7=FB=D3=C0=CC=CE

--14dae9340ee75e904b04dafd232c
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Terrific. Thank you Eric, Brian, and xfs experts. You=
 have helped us a lot.<br></div>I&#39;ll test the path.<br></div><div class=
=3D"gmail_extra"><br><br><div class=3D"gmail_quote">2013/4/23 Eric Sandeen =
<span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_bla=
nk">sandeen@sandeen.net</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On 4=
/22/13 7:08 PM, Dave Chinner wrote:<br>
&gt; On Mon, Apr 22, 2013 at 02:59:54PM -0500, Eric Sandeen wrote:<br>
&gt;&gt; On 4/15/13 6:14 PM, Brian Foster wrote:<br>
&gt;&gt;&gt; Hi,<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Thanks for the data in the previous thread:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; <a href=3D"http://oss.sgi.com/archives/xfs/2013-04/msg00327.ht=
ml" target=3D"_blank">http://oss.sgi.com/archives/xfs/2013-04/msg00327.html=
</a><br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I&#39;m spinning off a new thread specifically for this becaus=
e the original<br>
&gt;&gt;&gt; thread is already too large and scattered to track. As Eric st=
ated,<br>
&gt;&gt;&gt; please try to keep data contained in as few messages as possib=
le.<br>
&gt;&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; Well, it&#39;s always simple in the end. &nbsp;It just took a lot =
of debugging<br>
&gt;&gt; to figure out what was happening - we do appreciate your help with=
 that!<br>
&gt;&gt;<br>
&gt;&gt; We were able to create a local reproducer, and it looks like<br>
&gt;&gt; this patch fixes things:<br>
&gt;&gt;<br>
&gt;&gt; commit aae8a97d3ec30788790d1720b71d76fd8eb44b73<br>
&gt;&gt; Author: Aneesh Kumar K.V &lt;<a href=3D"mailto:aneesh.kumar@linux.=
vnet.ibm.com">aneesh.kumar@linux.vnet.ibm.com</a>&gt;<br>
&gt;&gt; Date: &nbsp; Sat Jan 29 18:43:27 2011 +0530<br>
&gt;&gt;<br>
&gt;&gt; &nbsp; &nbsp; fs: Don&#39;t allow to create hardlink for deleted f=
ile<br>
&gt;<br>
&gt; Good find Eric - great work on the reproducer script.<br>
&gt;<br>
&gt; FWIW, can you confirm that a debug kernel assert fails<br>
&gt; with a non-zero link count in xfs_bumplink() with your test case?<br>
&gt;<br>
&gt; int<br>
&gt; xfs_bumplink(<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_t *tp,<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_inode_t *ip)<br>
&gt; {<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CH=
G);<br>
&gt;<br>
&gt;&gt;&gt;&gt;&gt;&gt; &nbsp; ASSERT(ip-&gt;i_d.di_nlink &gt; 0);<br>
<br>
</div></div>Yep, it does, I put a printk in there when I was testing<br>
and it fired.<br>
<br>
Guess we should have tested a debug xfs right off the bat ;)<br>
<div class=3D"im"><br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; ip-&gt;i_d.di_nlink++;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; inc_nlink(VFS_I(ip));<br>
&gt;<br>
&gt; If it does, we should consider this a in-memory corruption case and<br=
>
&gt; return and trigger a shutdown here....<br>
<br>
</div>I suppose that makes sense, it&#39;d be a much less cryptic failure f=
or<br>
something that will fail soon anyway.<br>
<br>
-Eric<br>
<br>
&gt; Cheers,<br>
&gt;<br>
&gt; Dave.<br>
&gt;<br>
<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--14dae9340ee75e904b04dafd232c--


--===============5152743278686934980==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5152743278686934980==--
