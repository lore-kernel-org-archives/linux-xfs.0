Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF5D37F37
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 09:58:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0971BAC003
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 07:58:24 -0700 (PDT)
Received: from mail-qe0-f47.google.com (mail-qe0-f47.google.com
	[209.85.128.47]) by cuda.sgi.com with ESMTP id 5aPQ8tWQYexmRvs9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 17 Jun 2013 07:58:23 -0700 (PDT)
Received: by mail-qe0-f47.google.com with SMTP id 1so1710098qec.6
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 07:57:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130617111347.GL29338@dastard>
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<419435719.1662203.1371431489790.JavaMail.root@redhat.com>
	<20130617024603.GJ29338@dastard>
	<1597962722.1767244.1371447710942.JavaMail.root@redhat.com>
	<CAC2B=ZENLd7hoP=U08hyb6xFw6ye0nL5MMW+iDnTXTcoKCYEvA@mail.gmail.com>
	<20130617111347.GL29338@dastard>
Date: Mon, 17 Jun 2013 10:57:58 -0400
Message-ID: <CAC2B=ZGm4W=oFY+8sWAefhH79qK5N7yma4qQh_AQaOGiQDUWhw@mail.gmail.com>
Subject: Re: definitions for /proc/fs/xfs/stat
From: Mark Seger <mjseger@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8415301145236029324=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Nathan Scott <nathans@redhat.com>, xfs@oss.sgi.com

--===============8415301145236029324==
Content-Type: multipart/alternative; boundary=047d7b33d89285188304df5ad272

--047d7b33d89285188304df5ad272
Content-Type: text/plain; charset=ISO-8859-1

> How big is the write cache in your RAID array? If the log is the
> only thing being written to, and it fits within the cache, then it
> can easily push several hundred MB/s of write IO....


I asked around and people believe the cache is on the order of a few GB and
the test ran I was intentionally large enough to overshadow any cache
effects, running for about a minute and doing 100K 1K file creates.  The
disk write data was close to a sustained 475MB/sec and would have easily
filled the cache in the first handful of seconds which would have produced
enough backpressure to slow down the write rate which it never did.

On a totally different topic, and if you like we can start a different
thread on it, I'd be interested in adding some monitoring stats to collectl
for xfs and could use some suggestions of what are the most important.

-mark

--047d7b33d89285188304df5ad272
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><div class=3D"gmail_quote">=
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">How big is the write cache in your RAID arra=
y? If the log is the<br>

only thing being written to, and it fits within the cache, then it<br>
can easily push several hundred MB/s of write IO....</blockquote><div><br><=
/div><div style>I asked around and people believe the cache is on the order=
 of a few GB and the test ran I was intentionally large enough to overshado=
w any cache effects, running for about a minute and doing 100K 1K file crea=
tes. =A0The disk write data was close to a sustained 475MB/sec and would ha=
ve easily filled the cache in the first handful of seconds which would have=
 produced enough backpressure to slow down the write rate which it never di=
d.</div>
<div style><br></div><div style>On a totally different topic, and if you li=
ke we can start a different thread on it, I&#39;d be interested in adding s=
ome monitoring stats to collectl for xfs and could use some suggestions of =
what are the most important.</div>
<div style><br></div><div style>-mark</div><div style><br></div></div></div=
></div>

--047d7b33d89285188304df5ad272--


--===============8415301145236029324==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8415301145236029324==--
