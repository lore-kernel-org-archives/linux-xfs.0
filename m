Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BD6D37F5E
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 13:29:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C2EC8F8040
	for <xfs@oss.sgi.com>; Mon,  1 Jun 2015 11:29:34 -0700 (PDT)
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	dqa6ymCbTpcTbm6g (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jun 2015 11:29:33 -0700 (PDT)
Received: by wibdq8 with SMTP id dq8so37590993wib.1
	for <xfs@oss.sgi.com>; Mon, 01 Jun 2015 11:29:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150601131306.295f5dfb@harpe.intellique.com>
References: <556A3E25.6010706@gmail.com>
	<20150601131306.295f5dfb@harpe.intellique.com>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Mon, 1 Jun 2015 14:28:51 -0400
Message-ID: <CAGpXXZL6y7bX=-O0hnOEMvXTyMm2L3ZKrK7cFTOozdwFLGDaLQ@mail.gmail.com>
Subject: Re: Overwritten partition
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7794409544310046977=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: hallexh@gmail.com, xfs-oss <xfs@oss.sgi.com>

--===============7794409544310046977==
Content-Type: multipart/alternative; boundary=089e010d89e2c6941605177901f4

--089e010d89e2c6941605177901f4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 1, 2015 at 7:13 AM, Emmanuel Florac <eflorac@intellique.com>
wrote:

> Le Sun, 31 May 2015 00:48:05 +0200
> hallexh@gmail.com =C3=A9crivait:
>
> > I accidentally overwritten first 40GB of 36TB XFS partition. I ran
> > xfs_repair then, which resets the superblocks (I'm sorry i didn't
> > copied the output of it) and after I mounted the partition, there was
> > no files. Empty file system, but It should be almost 90% full.
> >
> > Am I really screwed or there's a chance to recover the data somehow?
>
> At this point your best bet is to use a tool like photorec on the
> partition to see what data it can salvage, though on 36 TB sorting the
> results may be overwhelming... You'll need some other large filesystem
> to store the salvaged data, though.


Photorec doesn't recreate any filesystem metadata (filenames, directory
structure, timestamps, etc).

Hopefully you have a recent backup you can use instead of trying to go
through Photorec's results.

Greg

--089e010d89e2c6941605177901f4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On M=
on, Jun 1, 2015 at 7:13 AM, Emmanuel Florac <span dir=3D"ltr">&lt;<a href=
=3D"mailto:eflorac@intellique.com" target=3D"_blank">eflorac@intellique.com=
</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Le Sun, 31 May 201=
5 00:48:05 +0200<br>
<a href=3D"mailto:hallexh@gmail.com">hallexh@gmail.com</a> =C3=A9crivait:<b=
r>
<br>
&gt; I accidentally overwritten first 40GB of 36TB XFS partition. I ran<br>
&gt; xfs_repair then, which resets the superblocks (I&#39;m sorry i didn&#3=
9;t<br>
&gt; copied the output of it) and after I mounted the partition, there was<=
br>
&gt; no files. Empty file system, but It should be almost 90% full.<br>
&gt;<br>
&gt; Am I really screwed or there&#39;s a chance to recover the data someho=
w?<br>
<br>
At this point your best bet is to use a tool like photorec on the<br>
partition to see what data it can salvage, though on 36 TB sorting the<br>
results may be overwhelming... You&#39;ll need some other large filesystem<=
br>
to store the salvaged data, though.</blockquote><div><br></div><div>Photore=
c doesn&#39;t recreate any filesystem metadata (filenames, directory struct=
ure, timestamps, etc).</div><div><br></div><div>Hopefully you have a recent=
 backup you can use instead of trying to go through Photorec&#39;s results.=
</div><div><br></div><div>Greg=C2=A0</div></div></div></div>

--089e010d89e2c6941605177901f4--


--===============7794409544310046977==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7794409544310046977==--
