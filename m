Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p88BA0mx221410 for <xfs@oss.sgi.com>; Thu, 8 Sep 2011 06:10:01 -0500
Received: from mail-gx0-f182.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCF2E15239D6
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2011 04:14:08 -0700 (PDT)
Received: from mail-gx0-f182.google.com (mail-gx0-f182.google.com
	[209.85.161.182]) by cuda.sgi.com with ESMTP id
	v8UItjeqTx8e53BZ for <xfs@oss.sgi.com>;
	Thu, 08 Sep 2011 04:14:08 -0700 (PDT)
Received: by gxk28 with SMTP id 28so1186977gxk.41
	for <xfs@oss.sgi.com>; Thu, 08 Sep 2011 04:09:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110905074734.GA18504@infradead.org>
References: <CAKxAxjFgBd0Vt02m7FJKq_ZWNBBJ5B=N4u7kS69FKtOKT4UowA@mail.gmail.com>
	<20110905074734.GA18504@infradead.org>
Date: Thu, 8 Sep 2011 19:09:55 +0800
Message-ID: <CAKxAxjFUMrQpb5kQUdpRdt2wx83oKxaLZPTVTR_j43dkhcOyyw@mail.gmail.com>
Subject: Re: ENOSPC and filesystem shutdowns
From: Bernard Chan <bernard@goanimate.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1812489156926831849=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

--===============1812489156926831849==
Content-Type: multipart/alternative; boundary=001517510e3aee925304ac6c1932

--001517510e3aee925304ac6c1932
Content-Type: text/plain; charset=ISO-8859-1

Hi Christoph and everybody else,

Thanks so much for your response.

We are running this on a customized CentOS image on AWS and thus had a
different kernel version. We learned from the image vendors that these are
based on CentOS and indeed they seem to be, although we do not know the
exact CentOS versions on which those images were based.

We switched to another image that offers a newer kernel version (2.6.35.11),
and re-mounted the LVM with XFS volumes. Earlier on we performed xfs_repair
and did not find any problems, and fragmentation was found to be low.
We retried those mkdir operations that previously resulted in ENOSPC which
in turn shut down the XFS. There is no longer any XFS shutdown now and the
same operations are successful. We feel curious and do not quite understand
why, and we haven't enabled inode64 either with the new setup and remain on
a 32-bit architecture. Essentially we only changed the kernel and a slightly
different 32-bit image.

So should we bother with inode64 and 64-bit servers with NFS4, and should we
anticipate any other issues running on this setup with a 4TB volume without
enabling inode64?

Thanks so much for any possible insights.


On Mon, Sep 5, 2011 at 3:47 PM, Christoph Hellwig <hch@infradead.org> wrote:

> On Sun, Sep 04, 2011 at 02:09:49PM +0800, Bernard Chan wrote:
> > We have an XFS filesystem (on LVM, probably doesn't matter anyway) that
> is
> > 4TB running on CentOS kernel 2.6.21.7,
>
> Isn't Centos based on RHEL and thus running either 2.6.9, 2.6.18 or
> 2.6.32-ish kernels?
>
> > We searched and found this list, and a few patches around kernel
> > 2.6.26-2.6.27 that seem to match our scenario. We were able to log the
> > specific mkdir command that failed and confirmed it consistently fails
> that
> > way that gives "no space left on device", while we did not reproduce the
> > same issue mkdir in other directories with large inode numbers. We
> haven't
> > tried patching or upgrading the kernel yet, but we will do that later.
> >
> > As the root cause of that patch points to a bug triggered by ENOSPC, we
> > checked the inode numbers created for some directories and files with "ls
> > -li" and some of them are pretty close to 2^32.
> >
> > So, we would like to ascertain if that is the cause for ENOSPC in our
> case,
> > and does that mean 32-bit inodes are no longer adequate for us and we
> should
> > switch to 64-bit inodes? Will switching it avoid this kind of shutdowns
> with
> > successful writes in the future?
> >
> > And is it true that we don't need a 64-bit OS for 64-bit inodes? How can
> we
> > tell if our system supports 64-bit inodes?
>
> It doesn't.  On Linux XFS only supports inode64 on 32-bit systems since
> Linux 3.0.
>
> > Finally, although we all know that "df -i" is sort of nonsense on XFS,
> how
> > can we get the output of 5% inode while having inode numbers that are
> close
> > to 2^32? So what does that 5% exactly mean, or were I looking at inodes
> the
> > wrong way?
>
> It's based on the available space given that XFS can theoretically use
> any inode block for data.
>
> > Thanks in advance for any insights anyone may shed on this one.
>
> I'd move off a 4.5-year old unsupposed kernel.  The real RHEL/Centos
> kernel have fairly good xfs support these days if you want a backporting
> option.  Even RHEL5 might have inode64 on 32-bit systems as it has a lot
> of XFS updates backport, but in doubt I would recommend to move to
> a RHEL6/Centos6 kernel at least.
>
>


-- 

Regards,
Bernard Chan.
GoAnimate.

--001517510e3aee925304ac6c1932
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div><br></div><div>Hi Christoph and everybody else,</div><div><br></div><d=
iv>Thanks so much for your response.</div><div><br></div>We are running thi=
s on a customized CentOS image on AWS and thus had a different kernel versi=
on. We learned from the image vendors that these are based on CentOS and in=
deed they seem to be, although we do not know the exact CentOS versions on =
which those images were based.<div>
<br></div><div>We switched to another image that offers a newer kernel vers=
ion (2.6.35.11), and re-mounted the LVM with XFS volumes. Earlier on we per=
formed xfs_repair and did not find any problems, and fragmentation was foun=
d to be low. We=A0retried those mkdir operations that previously resulted i=
n ENOSPC which in turn shut down the XFS. There is no longer any XFS shutdo=
wn now and the same operations are successful. We feel curious and do not q=
uite understand why, and we haven&#39;t enabled inode64 either with the new=
 setup and remain on a 32-bit architecture. Essentially we only changed the=
 kernel and a slightly different 32-bit image.</div>
<div><br></div><div>So should we bother with inode64 and 64-bit servers wit=
h NFS4, and should we anticipate any other issues running on this setup wit=
h a 4TB volume without enabling inode64?</div><div><br></div><div>Thanks so=
 much for any possible insights.</div>
<div><br></div><div><br><div class=3D"gmail_quote">On Mon, Sep 5, 2011 at 3=
:47 PM, Christoph Hellwig <span dir=3D"ltr">&lt;<a href=3D"mailto:hch@infra=
dead.org">hch@infradead.org</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex;">
<div class=3D"im">On Sun, Sep 04, 2011 at 02:09:49PM +0800, Bernard Chan wr=
ote:<br>
&gt; We have an XFS filesystem (on LVM, probably doesn&#39;t matter anyway)=
 that is<br>
&gt; 4TB running on CentOS kernel 2.6.21.7,<br>
<br>
</div>Isn&#39;t Centos based on RHEL and thus running either 2.6.9, 2.6.18 =
or<br>
2.6.32-ish kernels?<br>
<div class=3D"im"><br>
&gt; We searched and found this list, and a few patches around kernel<br>
&gt; 2.6.26-2.6.27 that seem to match our scenario. We were able to log the=
<br>
&gt; specific mkdir command that failed and confirmed it consistently fails=
 that<br>
&gt; way that gives &quot;no space left on device&quot;, while we did not r=
eproduce the<br>
&gt; same issue mkdir in other directories with large inode numbers. We hav=
en&#39;t<br>
&gt; tried patching or upgrading the kernel yet, but we will do that later.=
<br>
&gt;<br>
&gt; As the root cause of that patch points to a bug triggered by ENOSPC, w=
e<br>
&gt; checked the inode numbers created for some directories and files with =
&quot;ls<br>
&gt; -li&quot; and some of them are pretty close to 2^32.<br>
&gt;<br>
&gt; So, we would like to ascertain if that is the cause for ENOSPC in our =
case,<br>
&gt; and does that mean 32-bit inodes are no longer adequate for us and we =
should<br>
&gt; switch to 64-bit inodes? Will switching it avoid this kind of shutdown=
s with<br>
&gt; successful writes in the future?<br>
&gt;<br>
&gt; And is it true that we don&#39;t need a 64-bit OS for 64-bit inodes? H=
ow can we<br>
&gt; tell if our system supports 64-bit inodes?<br>
<br>
</div>It doesn&#39;t. =A0On Linux XFS only supports inode64 on 32-bit syste=
ms since<br>
Linux 3.0.<br>
<div class=3D"im"><br>
&gt; Finally, although we all know that &quot;df -i&quot; is sort of nonsen=
se on XFS, how<br>
&gt; can we get the output of 5% inode while having inode numbers that are =
close<br>
&gt; to 2^32? So what does that 5% exactly mean, or were I looking at inode=
s the<br>
&gt; wrong way?<br>
<br>
</div>It&#39;s based on the available space given that XFS can theoreticall=
y use<br>
any inode block for data.<br>
<div class=3D"im"><br>
&gt; Thanks in advance for any insights anyone may shed on this one.<br>
<br>
</div>I&#39;d move off a 4.5-year old unsupposed kernel. =A0The real RHEL/C=
entos<br>
kernel have fairly good xfs support these days if you want a backporting<br=
>
option. =A0Even RHEL5 might have inode64 on 32-bit systems as it has a lot<=
br>
of XFS updates backport, but in doubt I would recommend to move to<br>
a RHEL6/Centos6 kernel at least.<br>
<br>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><br><div>Reg=
ards,</div><div>Bernard Chan.</div><div>GoAnimate.</div><br>
</div>

--001517510e3aee925304ac6c1932--


--===============1812489156926831849==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1812489156926831849==--
