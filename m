Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAE3OQKU258295 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 21:24:26 -0600
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	BmOioBA2pjvLtofg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Nov 2012 19:26:29 -0800 (PST)
Received: by mail-vc0-f181.google.com with SMTP id n11so8808334vch.26
	for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 19:26:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121111223944.GN24575@dastard>
References: <CABJyUz+h=pZ6+2rro1PjoB1ggTAoRw+bTzc_bU7Eaec0_AUKLA@mail.gmail.com>
	<20121101225938.GS29378@dastard>
	<CABJyUz+VhUY=tVKpEeKXfQRoaL4s+gwNmRr4wNAnRX6zTt5xXg@mail.gmail.com>
	<CABJyUz+r7yQSswqyBng_W=fAXxTz9heb88NeiKSeFU7j4ZD=Hw@mail.gmail.com>
	<20121108210210.GP6434@dastard>
	<CABJyUzKy4YXVZAj=awVNfPD69eWo2mKhM7a-xWF1Vy-PD989sg@mail.gmail.com>
	<20121109104839.GE6434@dastard>
	<CABJyUzJVj-rpGW=i5QG=AZPvhuD-qdbujuwOdu_EdGbYGZ++Rg@mail.gmail.com>
	<CABJyUzJ7maOcj+aPkpCvBc1-P+Z-XPsft8rbsVnqgpfyVCs9xQ@mail.gmail.com>
	<20121111223944.GN24575@dastard>
Date: Tue, 13 Nov 2012 19:26:28 -0800
Message-ID: <CABJyUzKe91==jXcqO6oV3a+ZeR83juhLUkqcmaVoaMib5LZkBQ@mail.gmail.com>
Subject: Re: XFS filesystem recovery from secondary superblocks
From: Aaron Goulding <aarongldng@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6770794780490663689=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6770794780490663689==
Content-Type: multipart/alternative; boundary=20cf307d0078a0076404ce6c1960

--20cf307d0078a0076404ce6c1960
Content-Type: text/plain; charset=ISO-8859-1

Hmm.. Okay new plan. Running XFSB  and XAGF scans on /dev/md0 instead of
/dev/md1, and I'll use that to find the alignment the superblocks are
expecting, and see if I have an offset wrong somewhere when I ran the
multi-part DD onto /dev/md1. Barring this, I'll resort to xfs_irecover. I
think you've given me a lot of information to go on though, so thank you
greatly.

-Aaron


On Sun, Nov 11, 2012 at 2:39 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Sat, Nov 10, 2012 at 11:08:23PM -0800, Aaron Goulding wrote:
> > As I guessed, xfs_repair didn't work. xfs_db does now load with warnings,
> > but I fear I don't know enough about that to properly use that tool. I've
> > done a search for xfs_irepair but I'm finding very little from that.
> Where
> > is that tool located? I'm understanding a full restore is very unlikely
> at
> > this point, but if I can get anything, I'll consider this project a
> success
> > and a learning experience. :)
>
> xfs_irecover:
>
> http://oss.sgi.com/archives/xfs/2008-12/msg01782.html
>
> current location:
>
> http://inai.de/projects/hxtools/
>
> You might need to hack it to recovery full files (ISTR is ignore
> files larger than a certain size), but tools lke this are your best
> bet now.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--20cf307d0078a0076404ce6c1960
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hmm.. Okay new plan. Running XFSB=A0 and XAGF scans on /dev/md0 instead of =
/dev/md1, and I&#39;ll use that to find the alignment the superblocks are e=
xpecting, and see if I have an offset wrong somewhere when I ran the multi-=
part DD onto /dev/md1. Barring this, I&#39;ll resort to xfs_irecover. I thi=
nk you&#39;ve given me a lot of information to go on though, so thank you g=
reatly.<br>
<br>-Aaron<br><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote"=
>On Sun, Nov 11, 2012 at 2:39 PM, Dave Chinner <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&=
gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On S=
at, Nov 10, 2012 at 11:08:23PM -0800, Aaron Goulding wrote:<br>
&gt; As I guessed, xfs_repair didn&#39;t work. xfs_db does now load with wa=
rnings,<br>
&gt; but I fear I don&#39;t know enough about that to properly use that too=
l. I&#39;ve<br>
&gt; done a search for xfs_irepair but I&#39;m finding very little from tha=
t. Where<br>
&gt; is that tool located? I&#39;m understanding a full restore is very unl=
ikely at<br>
&gt; this point, but if I can get anything, I&#39;ll consider this project =
a success<br>
&gt; and a learning experience. :)<br>
<br>
</div></div>xfs_irecover:<br>
<br>
<a href=3D"http://oss.sgi.com/archives/xfs/2008-12/msg01782.html" target=3D=
"_blank">http://oss.sgi.com/archives/xfs/2008-12/msg01782.html</a><br>
<br>
current location:<br>
<br>
<a href=3D"http://inai.de/projects/hxtools/" target=3D"_blank">http://inai.=
de/projects/hxtools/</a><br>
<br>
You might need to hack it to recovery full files (ISTR is ignore<br>
files larger than a certain size), but tools lke this are your best<br>
bet now.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div>

--20cf307d0078a0076404ce6c1960--


--===============6770794780490663689==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6770794780490663689==--
