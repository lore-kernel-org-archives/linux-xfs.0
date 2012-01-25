Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0PLKEIE072306 for <xfs@oss.sgi.com>; Wed, 25 Jan 2012 15:20:14 -0600
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id CE1egvK3SmSqRas0
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Jan 2012 13:20:12 -0800 (PST)
Received: by yhpp61 with SMTP id p61so338180yhp.26
	for <xfs@oss.sgi.com>; Wed, 25 Jan 2012 13:20:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120124035431.GD6922@dastard>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116232549.GC6922@dastard>
	<CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
	<20120123051155.GI15102@dastard>
	<CAFLer82QxfgXEx7ofzOHOK2YKiA+ab+_Aizd10SWHvnC-mVUHg@mail.gmail.com>
	<CAFLer81GWSCCCMppU=2dE+5KKqD-hYVKAA0hz9n-CBbxAs_xfw@mail.gmail.com>
	<20120124035431.GD6922@dastard>
Date: Wed, 25 Jan 2012 16:20:12 -0500
Message-ID: <CAFLer83=QBG-eCT__sJY5hd7tvKjAX20-kMODqBXuYh1KqjOrw@mail.gmail.com>
Subject: Re: concurrent direct IO write in xfs
From: Zheng Da <zhengda1936@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0797311283439387657=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============0797311283439387657==
Content-Type: multipart/alternative; boundary=20cf300513cc3e730204b760d47d

--20cf300513cc3e730204b760d47d
Content-Type: text/plain; charset=ISO-8859-1

Hello Dave,

On Mon, Jan 23, 2012 at 10:54 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> > >> > So the test case is pretty simple and I think it's easy to
> reproduce it.
> > >> > It'll be great if you can try the test case.
> > >>
> > >> Can you post your test code so I know what I test is exactly what
> > >> you are running?
> > >>
> > > I can do that. My test code gets very complicated now. I need to
> simplify
> > > it.
> > >
> > Here is the code. It's still a bit long. I hope it's OK.
> > You can run the code like "rand-read file option=direct pages=1048576
> > threads=8 access=write/read".
>
> With 262144 pages on a 2Gb ramdisk, the results I get on 3.2.0 are
>
> Threads         Read    Write
>    1           0.92s   1.49s
>    2           0.51s   1.20s
>    4           0.31s   1.34s
>    8           0.22s   1.59s
>   16           0.23s   2.24s
>
> the contention is on the ip->i_ilock, and the newsize update is one
> of the offenders It probably needs this change to
> xfs_aio_write_newsize_update():
>
> -        if (new_size == ip->i_new_size) {
> +        if (new_size && new_size == ip->i_new_size) {
>
> to avoid the lock being taken here.
>
> But all that newsize crap is gone in the current git Linus tree,
> so how much would that gains us:
>
> Threads         Read    Write
>    1           0.88s   0.85s
>    2           0.54s   1.20s
>    4           0.31s   1.23s
>    8           0.27s   1.40s
>   16           0.25s   2.36s
>
> Pretty much nothing. IOWs, it's just like I suspected - you are
> doing so many write IOs that you are serialising on the extent
> lookup and write checks which use exclusive locking..
>
> Given that it is 2 lock traversals per write IO, we're limiting at
> about 4-500,000 exclusive lock grabs per second and decreasing as
> contention goes up.
>
> For reads, we are doing 2 shared (nested) lookups per read IO, we
> appear to be limiting at around 2,000,000 shared lock grabs per
> second. Ahmdals law is kicking in here, but it means if we could
> make the writes to use a shared lock, it would at least scale like
> the reads for this "no metadata modification except for mtime"
> overwrite case.
>
> I don't think that the generic write checks absolutely need
> exclusive locking - we probably could get away with a shared lock
> and only fall back to exclusive when we need to do EOF zeroing.
> Similarly, for the block mapping code if we don't need to do
> allocation, a shared lock is all we need. So maybe in that case for
> direct IO when create == 1, we can do a read lookup first and only
> grab the lock exclusively if that falls in a hole and requires
> allocation.....


Do you think if you will provide a patch for the changes?

Thanks,
Da

--20cf300513cc3e730204b760d47d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Dave,=A0<br><br><div class=3D"gmail_quote">On Mon, Jan 23, 2012 at 10=
:54 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbi=
t.com">david@fromorbit.com</a>&gt;</span> wrote:<blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex">
<div class=3D"im">
&gt; &gt;&gt; &gt; So the test case is pretty simple and I think it&#39;s e=
asy to reproduce it.<br>
&gt; &gt;&gt; &gt; It&#39;ll be great if you can try the test case.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Can you post your test code so I know what I test is exactly =
what<br>
&gt; &gt;&gt; you are running?<br>
&gt; &gt;&gt;<br>
&gt; &gt; I can do that. My test code gets very complicated now. I need to =
simplify<br>
&gt; &gt; it.<br>
&gt; &gt;<br>
&gt; Here is the code. It&#39;s still a bit long. I hope it&#39;s OK.<br>
&gt; You can run the code like &quot;rand-read file option=3Ddirect pages=
=3D1048576<br>
&gt; threads=3D8 access=3Dwrite/read&quot;.<br>
<br>
</div>With 262144 pages on a 2Gb ramdisk, the results I get on 3.2.0 are<br=
>
<br>
Threads =A0 =A0 =A0 =A0 Read =A0 =A0Write<br>
 =A0 =A01 =A0 =A0 =A0 =A0 =A0 0.92s =A0 1.49s<br>
 =A0 =A02 =A0 =A0 =A0 =A0 =A0 0.51s =A0 1.20s<br>
 =A0 =A04 =A0 =A0 =A0 =A0 =A0 0.31s =A0 1.34s<br>
 =A0 =A08 =A0 =A0 =A0 =A0 =A0 0.22s =A0 1.59s<br>
 =A0 16 =A0 =A0 =A0 =A0 =A0 0.23s =A0 2.24s<br>
<br>
the contention is on the ip-&gt;i_ilock, and the newsize update is one<br>
of the offenders It probably needs this change to<br>
xfs_aio_write_newsize_update():<br>
<br>
- =A0 =A0 =A0 =A0if (new_size =3D=3D ip-&gt;i_new_size) {<br>
+ =A0 =A0 =A0 =A0if (new_size &amp;&amp; new_size =3D=3D ip-&gt;i_new_size)=
 {<br>
<br>
to avoid the lock being taken here.<br>
<br>
But all that newsize crap is gone in the current git Linus tree,<br>
so how much would that gains us:<br>
<br>
Threads =A0 =A0 =A0 =A0 Read =A0 =A0Write<br>
 =A0 =A01 =A0 =A0 =A0 =A0 =A0 0.88s =A0 0.85s<br>
 =A0 =A02 =A0 =A0 =A0 =A0 =A0 0.54s =A0 1.20s<br>
 =A0 =A04 =A0 =A0 =A0 =A0 =A0 0.31s =A0 1.23s<br>
 =A0 =A08 =A0 =A0 =A0 =A0 =A0 0.27s =A0 1.40s<br>
 =A0 16 =A0 =A0 =A0 =A0 =A0 0.25s =A0 2.36s<br>
<br>
Pretty much nothing. IOWs, it&#39;s just like I suspected - you are<br>
doing so many write IOs that you are serialising on the extent<br>
lookup and write checks which use exclusive locking..<br>
<br>
Given that it is 2 lock traversals per write IO, we&#39;re limiting at<br>
about 4-500,000 exclusive lock grabs per second and decreasing as<br>
contention goes up.<br>
<br>
For reads, we are doing 2 shared (nested) lookups per read IO, we<br>
appear to be limiting at around 2,000,000 shared lock grabs per<br>
second. Ahmdals law is kicking in here, but it means if we could<br>
make the writes to use a shared lock, it would at least scale like<br>
the reads for this &quot;no metadata modification except for mtime&quot;<br=
>
overwrite case.<br>
<br>
I don&#39;t think that the generic write checks absolutely need<br>
exclusive locking - we probably could get away with a shared lock<br>
and only fall back to exclusive when we need to do EOF zeroing.<br>
Similarly, for the block mapping code if we don&#39;t need to do<br>
allocation, a shared lock is all we need. So maybe in that case for<br>
direct IO when create =3D=3D 1, we can do a read lookup first and only<br>
grab the lock exclusively if that falls in a hole and requires<br>
allocation.....</blockquote><div><br></div><div>Do you think if you will pr=
ovide a patch for the changes?</div><div><br></div><div>Thanks,</div><div>D=
a</div></div>

--20cf300513cc3e730204b760d47d--


--===============0797311283439387657==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0797311283439387657==--
