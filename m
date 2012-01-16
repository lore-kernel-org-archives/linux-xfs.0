Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0GJiWb1110034 for <xfs@oss.sgi.com>; Mon, 16 Jan 2012 13:44:32 -0600
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	a6zWk0NyRg1UHKnZ for <xfs@oss.sgi.com>;
	Mon, 16 Jan 2012 11:44:30 -0800 (PST)
Received: by ghbf15 with SMTP id f15so1839988ghb.26
	for <xfs@oss.sgi.com>; Mon, 16 Jan 2012 11:44:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120116174819.GA19417@infradead.org>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116174819.GA19417@infradead.org>
Date: Mon, 16 Jan 2012 14:44:30 -0500
Message-ID: <CAFLer81ZGuE-C-ypmFk=cKgwExhx-u809uK-f4=ZyixObi-LJg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1415822306336103386=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

--===============1415822306336103386==
Content-Type: multipart/alternative; boundary=001636cd75126d3cea04b6aa71c8

--001636cd75126d3cea04b6aa71c8
Content-Type: text/plain; charset=ISO-8859-1

Hello Christoph,

Right now I'm using kernel 3.2.
My test program writes 4G of data to a file that has been preallocated and
each time it writes a page of data randomly to the file. It's always
overwriting, and no appending. The offset of each write is always aligned
to the page size. There is no overlapping between writes as I said before.
I also tried mixing reads and writes and got the similar result.
Can you write data to a file with multiple threads and the performance can
scale up with more threads?

Thanks,
Da

On Mon, Jan 16, 2012 at 12:48 PM, Christoph Hellwig <hch@infradead.org>wrote:

> On Sun, Jan 15, 2012 at 07:01:42PM -0500, Zheng Da wrote:
> > Hello,
> >
> > I surprisedly found that writing data to a file (no appending) with
> direct
> > IO and with multiple threads has the same performance as a single thread.
> > Actually, it seems there is only one core is working at a time. In my
> case,
> > each time I write a page to a file and the offset is always aligned to
> the
> > page size, so there is no overlapping between writes.
>
> What kernel version are you using?  Also, what is the exact I/O
> pattern?
>
>

--001636cd75126d3cea04b6aa71c8
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Christoph,<div><br></div><div>Right now I&#39;m using kernel 3.2.=A0<=
/div><div>My test program writes 4G of data to a file that has been preallo=
cated and each time it writes a page of data randomly to the file. It&#39;s=
 always overwriting, and no appending. The offset of each write is always a=
ligned to the page size. There is no overlapping between writes as I said b=
efore.=A0</div>
<div>I also tried mixing reads and writes and got the similar result.</div>=
<div>Can you write data to a file with multiple threads and the performance=
 can scale up with more threads?</div><div><br></div><div>Thanks,</div>
<div>Da<br><br><div class=3D"gmail_quote">On Mon, Jan 16, 2012 at 12:48 PM,=
 Christoph Hellwig <span dir=3D"ltr">&lt;<a href=3D"mailto:hch@infradead.or=
g">hch@infradead.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">
<div class=3D"im">On Sun, Jan 15, 2012 at 07:01:42PM -0500, Zheng Da wrote:=
<br>
&gt; Hello,<br>
&gt;<br>
&gt; I surprisedly found that writing data to a file (no appending) with di=
rect<br>
&gt; IO and with multiple threads has the same performance as a single thre=
ad.<br>
&gt; Actually, it seems there is only one core is working at a time. In my =
case,<br>
&gt; each time I write a page to a file and the offset is always aligned to=
 the<br>
&gt; page size, so there is no overlapping between writes.<br>
<br>
</div>What kernel version are you using? =A0Also, what is the exact I/O<br>
pattern?<br>
<br>
</blockquote></div><br></div>

--001636cd75126d3cea04b6aa71c8--


--===============1415822306336103386==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1415822306336103386==--
