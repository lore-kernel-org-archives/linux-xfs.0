Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 17BEC7F54
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 00:20:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DE1C1304048
	for <xfs@oss.sgi.com>; Sat,  2 Nov 2013 22:20:35 -0700 (PDT)
Received: from mail-ob0-f170.google.com (mail-ob0-f170.google.com
	[209.85.214.170]) by cuda.sgi.com with ESMTP id
	0lZIY4PgjAauyhA6 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 02 Nov 2013 22:20:33 -0700 (PDT)
Received: by mail-ob0-f170.google.com with SMTP id wp18so6074966obc.29
	for <xfs@oss.sgi.com>; Sat, 02 Nov 2013 22:20:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a3208864-e046-4034-ac3b-1ce6f7ae352b@email.android.com>
References: <CAPU9cc3rV+E79HBE95=nsjgoC5=s85jBBZgcxL+d8KijVa0LyA@mail.gmail.com>
	<a3208864-e046-4034-ac3b-1ce6f7ae352b@email.android.com>
Date: Sun, 3 Nov 2013 06:20:33 +0100
Message-ID: <CAPU9cc3k9Aq8M5C0m99hxi7rEoj-kB_7jqnYot3-s3VLn_6kAw@mail.gmail.com>
Subject: Re: 128 bits extent bmap for file format 2
From: Pradeep Kumar <praks411@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6959082063095439206=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: xfs@oss.sgi.com

--===============6959082063095439206==
Content-Type: multipart/alternative; boundary=089e013d0dc06c9c9c04ea3ef551

--089e013d0dc06c9c9c04ea3ef551
Content-Type: text/plain; charset=ISO-8859-1

Hi Greg,

This could be nice addition. I will try to submit it once done.

Pradeep


On 22 October 2013 15:11, Greg Freemyer <greg.freemyer@gmail.com> wrote:

>
>
> Pradeep Kumar <praks411@gmail.com> wrote:
> >Hi,
> >
> >I'm writing a small utility to parse XFS fs image on windows.
> >I'm able to fetch the files in the first AG (0).
> >However when it comes to the files which are in different AG I'm facing
> >some problem in parsing extent bmap 128bits data of file inode (format
> >==
> >2).
> >
> >Here is the sample 128bits data
> >1. 00 00 00 00 00 00 00 00 00 00 00 04 99 80 00 01 (LSB)
> >
> >After unpacking the bits are per doc and source code
> >In the above case I'm getting following
> >Num Of blocks = 1 (correct) (0 to 20 bits)
> >absolute block number = 9420 (0x24CC) (wrong) (21 to 72)
> >file offset = 0 (72 to 126)
> >
> >I'm always getting wrong absolute block number . Actual data is in
> >block
> >7628 (0x1DCC).
> >No matter what I try I'm always getting the same result. I've even
> >verified
> >this
> >by using the code from xfs_bmbt_get_all function from xfs source which
> >too
> >gives me same result (9420).
> >Please someone help me with this. I'm stuck on this from 3 days.
> >
> >Thanks and Regards,
> >Pradeep
>
> Pradeep,
>
> It would be cool if your utility could be incorporated into sleuthkit.
>  Sleuthkit has fat and NTFS parsers for sure already.  I think ext2 and
> ext3.  Adding a xfs parser would be a cool addition.
>
>  http://www.sleuthkit.org/sleuthkit/docs/api-docs/index.html#users_guide
>
> Fyi: sleuthkit has been around for a long time, but it is still actively
> maintained and heavily used.  It is in several linux distros, but is also
> available for windows.
>
> Greg
> --
> Sent from my Android phone with K-9 Mail. Please excuse my brevity.
>

--089e013d0dc06c9c9c04ea3ef551
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Greg,<div><br></div><div>This could be nice addition. I=
 will try to submit it once done.</div><div><br></div><div>Pradeep</div></d=
iv><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On 22 Octo=
ber 2013 15:11, Greg Freemyer <span dir=3D"ltr">&lt;<a href=3D"mailto:greg.=
freemyer@gmail.com" target=3D"_blank">greg.freemyer@gmail.com</a>&gt;</span=
> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
Pradeep Kumar &lt;<a href=3D"mailto:praks411@gmail.com">praks411@gmail.com<=
/a>&gt; wrote:<br>
&gt;Hi,<br>
&gt;<br>
&gt;I&#39;m writing a small utility to parse XFS fs image on windows.<br>
&gt;I&#39;m able to fetch the files in the first AG (0).<br>
&gt;However when it comes to the files which are in different AG I&#39;m fa=
cing<br>
&gt;some problem in parsing extent bmap 128bits data of file inode (format<=
br>
&gt;=3D=3D<br>
&gt;2).<br>
&gt;<br>
&gt;Here is the sample 128bits data<br>
&gt;1. 00 00 00 00 00 00 00 00 00 00 00 04 99 80 00 01 (LSB)<br>
&gt;<br>
&gt;After unpacking the bits are per doc and source code<br>
&gt;In the above case I&#39;m getting following<br>
&gt;Num Of blocks =3D 1 (correct) (0 to 20 bits)<br>
&gt;absolute block number =3D 9420 (0x24CC) (wrong) (21 to 72)<br>
&gt;file offset =3D 0 (72 to 126)<br>
&gt;<br>
&gt;I&#39;m always getting wrong absolute block number . Actual data is in<=
br>
&gt;block<br>
&gt;7628 (0x1DCC).<br>
&gt;No matter what I try I&#39;m always getting the same result. I&#39;ve e=
ven<br>
&gt;verified<br>
&gt;this<br>
&gt;by using the code from xfs_bmbt_get_all function from xfs source which<=
br>
&gt;too<br>
&gt;gives me same result (9420).<br>
&gt;Please someone help me with this. I&#39;m stuck on this from 3 days.<br=
>
&gt;<br>
&gt;Thanks and Regards,<br>
&gt;Pradeep<br>
<br>
</div></div>Pradeep,<br>
<br>
It would be cool if your utility could be incorporated into sleuthkit. =A0S=
leuthkit has fat and NTFS parsers for sure already. =A0I think ext2 and ext=
3. =A0Adding a xfs parser would be a cool addition.<br>
<br>
=A0<a href=3D"http://www.sleuthkit.org/sleuthkit/docs/api-docs/index.html#u=
sers_guide" target=3D"_blank">http://www.sleuthkit.org/sleuthkit/docs/api-d=
ocs/index.html#users_guide</a><br>
<br>
Fyi: sleuthkit has been around for a long time, but it is still actively ma=
intained and heavily used. =A0It is in several linux distros, but is also a=
vailable for windows.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Greg<br>
--<br>
Sent from my Android phone with K-9 Mail. Please excuse my brevity.<br>
</font></span></blockquote></div><br></div>

--089e013d0dc06c9c9c04ea3ef551--


--===============6959082063095439206==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6959082063095439206==--
