Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C98AB7F57
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 17:57:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7585EAC003
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 15:57:09 -0700 (PDT)
Received: from mail-qc0-f182.google.com (mail-qc0-f182.google.com
	[209.85.216.182]) by cuda.sgi.com with ESMTP id
	IbT8KSxm9sOCjWX1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 15:57:07 -0700 (PDT)
Received: by mail-qc0-f182.google.com with SMTP id x13so5209900qcv.13
	for <xfs@oss.sgi.com>; Tue, 09 Sep 2014 15:57:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <540F7E37.7020500@sandeen.net>
References: <540F1B01.3020700@mygrande.net>
	<CAA43vkXwHF9RHW-cbTZ91_vF6wiQ6o_+TQDL3=7kD9P4tErCNQ@mail.gmail.com>
	<CAA43vkWgh8-EjDXjkySUn+y18W1O+v_W5j+fQankRTgDCmc8tw@mail.gmail.com>
	<540F7E37.7020500@sandeen.net>
Date: Tue, 9 Sep 2014 18:57:06 -0400
Message-ID: <CAA43vkX8Ve3g7=w16742b4vT3=yRdCMR7m66g2M7fYPmEMmctA@mail.gmail.com>
Subject: Re: Corrupted files
From: Sean Caron <scaron@umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3465787572739724577=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, Sean Caron <scaron@umich.edu>
Cc: Leslie Rhorer <lrhorer@mygrande.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============3465787572739724577==
Content-Type: multipart/alternative; boundary=089e0149c46ec9caa80502a9da0e

--089e0149c46ec9caa80502a9da0e
Content-Type: text/plain; charset=UTF-8

Hey, just sharing some hard-won (believe me) professional experience. I
have seen xfs_repair take a bad situation and make it worse many times. I
don't know that a filesystem fuzzer or any other simulation can ever
provide true simulation of users absolutely pounding the tar out of a
system. There seems to be a real disconnect between what developers are
able to test and observe directly, and what happens in the production
environment in a very high-throughput environment.

Best,

Sean


On Tue, Sep 9, 2014 at 6:24 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 9/9/14 11:03 AM, Sean Caron wrote:
>
>  Barring rare cases, xfs_repair is bad juju.
>>
>
> No, it's not.  It is the appropriate tool to use for filesystem repair.
>
> But it is not the appropriate tool for recovery from mangled storage.
>
> I've actually been running a filesystem fuzzer over xfs images, randomly
> corrupting data and testing repair, 1000s of times over.  It does
> remarkably well.
>
> If you scramble your raid, which means your block device is no longer
> an xfs filesystem, but is instead a random tangle of bits and pieces of
> other things, of course xfs_repair won't do well, but it's not the right
> tool for the job at that stage.
>
> -Eric
>

--089e0149c46ec9caa80502a9da0e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hey, just sharing some hard-won (believe me) professional =
experience. I have seen xfs_repair take a bad situation and make it worse m=
any times. I don&#39;t know that a filesystem fuzzer or any other simulatio=
n can ever provide true simulation of users absolutely pounding the tar out=
 of a system. There seems to be a real disconnect between what developers a=
re able to test and observe directly, and what happens in the production en=
vironment in a very high-throughput environment.<div><br></div><div><div>Be=
st,</div><div><br></div><div>Sean</div><div><br></div></div></div><div clas=
s=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Sep 9, 2014 at 6:2=
4 PM, Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.=
net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span> wrote:<br><blockq=
uote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc =
solid;padding-left:1ex"><span class=3D"">On 9/9/14 11:03 AM, Sean Caron wro=
te:<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Barring rare cases, xfs_repair is bad juju.<br>
</blockquote>
<br></span>
No, it&#39;s not.=C2=A0 It is the appropriate tool to use for filesystem re=
pair.<br>
<br>
But it is not the appropriate tool for recovery from mangled storage.<br>
<br>
I&#39;ve actually been running a filesystem fuzzer over xfs images, randoml=
y<br>
corrupting data and testing repair, 1000s of times over.=C2=A0 It does<br>
remarkably well.<br>
<br>
If you scramble your raid, which means your block device is no longer<br>
an xfs filesystem, but is instead a random tangle of bits and pieces of<br>
other things, of course xfs_repair won&#39;t do well, but it&#39;s not the =
right<br>
tool for the job at that stage.<span class=3D"HOEnZb"><font color=3D"#88888=
8"><br>
<br>
-Eric<br>
</font></span></blockquote></div><br></div>

--089e0149c46ec9caa80502a9da0e--


--===============3465787572739724577==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3465787572739724577==--
