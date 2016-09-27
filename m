Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 16E8D7CA1
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 12:27:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DB8098F8037
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 10:27:36 -0700 (PDT)
Received: from mail-vk0-f66.google.com (mail-vk0-f66.google.com
	[209.85.213.66]) by cuda.sgi.com with ESMTP id 5bTk9Ib485BIulkX
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Sep 2016 10:27:34 -0700 (PDT)
Received: by mail-vk0-f66.google.com with SMTP id z126so757013vkd.0
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 10:27:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160927170443.GR9314@birch.djwong.org>
References: <CAOSFFyjWR4ASud5aSoYTJKweWA244oMwT9_LRSzwnr0Qftg7Eg@mail.gmail.com>
	<20160927170443.GR9314@birch.djwong.org>
From: murali krishna <murali.marimekala@gmail.com>
Date: Tue, 27 Sep 2016 13:27:12 -0400
Message-ID: <CAOSFFyhP251ifYzWtRfcStxX7oy78EDvqWfi0=2h4GhTv4=pJw@mail.gmail.com>
Subject: Re: Clarification required about xfs_metadump and xfs_mdrestore
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1661191528793809526=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

--===============1661191528793809526==
Content-Type: multipart/alternative; boundary=001a113ef4be546342053d808f6a

--001a113ef4be546342053d808f6a
Content-Type: text/plain; charset=UTF-8

Hi Darrick,

Thanks for the response.

Could you please clarify if there is any strong reason behind in stating to
use xfs_metadump and xfs_mdrestore as just debugging tools in their
respective man pages ?

We tried xfsdump, its backing up the rtdev partition (/dev/sda1) as well. I
have around 450GB worth of recordings in my /dev/sda1 (rtdev).
I don't want to use any intermediate storage to backup all these data.

Yes, my aim is to backup the metadata (dont want to touch my rtdev) on
/dev/sda2, reformat "/dev/sda2"  with crypt layer, restore metadata back on
/dev/sda2.
At the end, I am expecting my rtdev untouched and should automatically
appear after encrypting my /dev/sda2.

Note:
/dev/sda2- xfs partition
/dev/sda1 - xfs realtime partition

Thank you,
Murali

On Tue, Sep 27, 2016 at 1:04 PM, Darrick J. Wong <darrick.wong@oracle.com>
wrote:

> On Tue, Sep 27, 2016 at 09:49:11AM -0400, murali krishna wrote:
> > Hi All,
> >
> > Got your email id from Nathan Scott.
> >
> > Could you please clarify the reasons behind stating below statement in
> > xfs_metadump man page.
> >
> >
> >
> > *xfs_metadump should not be used for any purposes other than for
> >  debugging and reporting filesystem problems*
> > Man page: http://man7.org/linux/man-pages/man8/xfs_metadump.8.html
> >
> > I am trying to encrypt my existing xfs drive (/dev/sda2) and would like
> to
> > backup metadata using xfs_metadump and restore it back using
> xfs_mdrestore
> > after encrypting my drive. In order to retain entire contents of my
> > realtime partition (/dev/sda1), I need to perform this step.
> >
> > Can I use xfs_metadump to backup meta-data of xfs  and restore it back
> > successfully ?
> > Why xfs_metadump should be specifically used as debugging tool ? Please
> > clarify ?
>
> Uh.... if your goal is to back up data, reformat the storage with a crypto
> layer, and then restore the data, why not just use xfsdump/xfsrestore?
> Your data will end up all nicely defragmented, too.
>
> --D
>
> >
> > Thanks in Advance,
> > Murali
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--001a113ef4be546342053d808f6a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Darrick,<div><br></div><div>Thanks for the response.</d=
iv><div><br></div><div>Could you please clarify if there is any strong reas=
on behind in stating to use xfs_metadump and xfs_mdrestore as just debuggin=
g tools in their respective man pages ?</div><div><br></div><div>We tried x=
fsdump, its backing up the rtdev partition (/dev/sda1) as well. I have arou=
nd 450GB worth of recordings in my /dev/sda1 (rtdev).</div><div>I don&#39;t=
 want to use any intermediate storage to backup all these data.</div><div><=
br></div><div>Yes, my aim is to backup the metadata (dont want to touch my =
rtdev) on /dev/sda2, reformat &quot;/dev/sda2&quot; =C2=A0with crypt layer,=
 restore metadata back on /dev/sda2.</div><div>At the end, I am expecting m=
y rtdev untouched and should automatically appear after encrypting my /dev/=
sda2.</div><div><br></div><div>Note:</div><div>/dev/sda2- xfs partition</di=
v><div>/dev/sda1 - xfs realtime partition</div><div><br></div><div class=3D=
"gmail_extra"><div><div class=3D"gmail_signature" data-smartmail=3D"gmail_s=
ignature"><div>Thank you,</div><div>Murali<br></div></div></div>
<br><div class=3D"gmail_quote">On Tue, Sep 27, 2016 at 1:04 PM, Darrick J. =
Wong <span dir=3D"ltr">&lt;<a href=3D"mailto:darrick.wong@oracle.com" targe=
t=3D"_blank">darrick.wong@oracle.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex"><span class=3D"">On Tue, Sep 27, 2016 at 09:49:11AM -0400=
, murali krishna wrote:<br>
&gt; Hi All,<br>
&gt;<br>
&gt; Got your email id from Nathan Scott.<br>
&gt;<br>
&gt; Could you please clarify the reasons behind stating below statement in=
<br>
&gt; xfs_metadump man page.<br>
&gt;<br>
&gt;<br>
&gt;<br>
</span>&gt; *xfs_metadump should not be used for any purposes other than fo=
r<br>
&gt;=C2=A0 debugging and reporting filesystem problems*<br>
<span class=3D"">&gt; Man page: <a href=3D"http://man7.org/linux/man-pages/=
man8/xfs_metadump.8.html" rel=3D"noreferrer" target=3D"_blank">http://man7.=
org/linux/man-<wbr>pages/man8/xfs_metadump.8.html</a><br>
&gt;<br>
&gt; I am trying to encrypt my existing xfs drive (/dev/sda2) and would lik=
e to<br>
&gt; backup metadata using xfs_metadump and restore it back using xfs_mdres=
tore<br>
&gt; after encrypting my drive. In order to retain entire contents of my<br=
>
&gt; realtime partition (/dev/sda1), I need to perform this step.<br>
&gt;<br>
&gt; Can I use xfs_metadump to backup meta-data of xfs=C2=A0 and restore it=
 back<br>
&gt; successfully ?<br>
&gt; Why xfs_metadump should be specifically used as debugging tool ? Pleas=
e<br>
&gt; clarify ?<br>
<br>
</span>Uh.... if your goal is to back up data, reformat the storage with a =
crypto<br>
layer, and then restore the data, why not just use xfsdump/xfsrestore?<br>
Your data will end up all nicely defragmented, too.<br>
<br>
--D<br>
<br>
&gt;<br>
&gt; Thanks in Advance,<br>
&gt; Murali<br>
<br>
&gt; ______________________________<wbr>_________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer"=
 target=3D"_blank">http://oss.sgi.com/mailman/<wbr>listinfo/xfs</a><br>
<br>
</blockquote></div><br></div></div>

--001a113ef4be546342053d808f6a--


--===============1661191528793809526==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1661191528793809526==--
