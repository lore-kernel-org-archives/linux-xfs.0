Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9E9E67CBE
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 11:41:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 21EAAAC003
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 09:41:00 -0700 (PDT)
Received: from mail-io0-f177.google.com (mail-io0-f177.google.com
	[209.85.223.177]) by cuda.sgi.com with ESMTP id
	kZfBpL2sRroJCGXr (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 09:40:58 -0700 (PDT)
Received: by iods203 with SMTP id s203so11171030iod.0
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 09:40:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1490980415.3591793.1438866795648.JavaMail.zimbra@redhat.com>
References: <1156743222.24471614.1436281858017.JavaMail.zimbra@redhat.com>
	<1436346893-11831-1-git-send-email-jtulak@redhat.com>
	<1508777144.956841.1437482376774.JavaMail.zimbra@redhat.com>
	<20150726162530.GE29329@infradead.org>
	<1326157887.2004059.1438598404429.JavaMail.zimbra@redhat.com>
	<55BFA2C5.20408@redhat.com>
	<1050814645.2742881.1438702230663.JavaMail.zimbra@redhat.com>
	<55C0E73B.1000904@sandeen.net>
	<1490980415.3591793.1438866795648.JavaMail.zimbra@redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 11 Aug 2015 18:40:39 +0200
Message-ID: <CACj3i71jiiFxZ=M-a+y9vpTsBiLo5Xxqr4Huqf+sc8D9cQNdZQ@mail.gmail.com>
Subject: Re: [PATCH v3] xfsprogs: blkid is now mandatory
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1962887444876541359=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

--===============1962887444876541359==
Content-Type: multipart/alternative; boundary=001a11406ee64aa27b051d0bc4ab

--001a11406ee64aa27b051d0bc4ab
Content-Type: text/plain; charset=UTF-8

On Thu, Aug 6, 2015 at 3:13 PM, Jan Tulak <jtulak@redhat.com> wrote:
>
> It looks like it works. Though I need to do some testing before I send
the patch.
> Unfortunately, making FS tests without the ability to mount it on the
machine
> requires USB drive shuffling and it is hard to automate it... :-)
>
(Sorry for spam, Eric, resubmitting it with mailing list in cc)

My hope was premature. After long searching for "why there is not created
any FS,"
I found that using mkfs on OS X on block devices probably wasn't ever
enabled.
Some platform_ functions in libxfs/darwin.h used for block device work are
empty
(so it just silently fails).

I edited the doc/INSTALL respectively and once I check and clean the
patches,
I submit the updates in the compatibility patchset with block devices
disabled.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

--001a11406ee64aa27b051d0bc4ab
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span class=3D"im">On Thu, Aug 6, 2015 at 3:13 PM, Jan Tul=
ak &lt;<a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat=
.com</a>&gt; wrote:<br>&gt;<br>&gt; It looks like it works. Though I need t=
o do some testing before I send the patch.<br>&gt; Unfortunately, making FS=
 tests without the ability to mount it on the machine<br>&gt; requires USB =
drive shuffling and it is hard to automate it... :-)<br>&gt;</span><div><sp=
an class=3D"im">(Sorry for spam, Eric, resubmitting it with mailing list in=
 cc)<div><br></div></span><div>My hope was premature. After long searching =
for &quot;why there is not created any FS,&quot;</div><div>I found that usi=
ng mkfs on OS X on block devices probably wasn&#39;t ever enabled.</div><di=
v>Some platform_ functions in libxfs/darwin.h used for block device work ar=
e empty</div><div>(so it just silently fails).</div><div><br></div><div>I e=
dited the doc/INSTALL respectively and once I check and clean the patches,<=
/div><div>I submit the updates in the compatibility patchset with block dev=
ices disabled.</div></div><div class=3D"gmail_extra"><div><br></div><div>Ch=
eers,</div><div>Jan</div><div><br></div>-- <br><div class=3D"gmail_signatur=
e"><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat=
.com" target=3D"_blank">jtulak@redhat.com</a><br></div></div>
</div></div>

--001a11406ee64aa27b051d0bc4ab--


--===============1962887444876541359==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1962887444876541359==--
