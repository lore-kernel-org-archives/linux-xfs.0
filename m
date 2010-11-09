Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9BBdZv150603 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 05:11:39 -0600
Received: from mail-iw0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39CA7160299A
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 03:13:05 -0800 (PST)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	AdJ4BOYSR0O6sbDr for <xfs@oss.sgi.com>;
	Tue, 09 Nov 2010 03:13:05 -0800 (PST)
Received: by iwn3 with SMTP id 3so8739563iwn.26
	for <xfs@oss.sgi.com>; Tue, 09 Nov 2010 03:13:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101104125052.GA22429@infradead.org>
References: <AANLkTi=mLwQ0N_cErHzES1ZWvOa8jQspeYwKgn9sU4Jm@mail.gmail.com>
	<20101104125052.GA22429@infradead.org>
Date: Tue, 9 Nov 2010 16:43:04 +0530
Message-ID: <AANLkTinqK-HvuHPeaTgxJOJuWMfomP2C12G=uVcqhWdn@mail.gmail.com>
Subject: Re: XFS mounting fails on MIPS
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2686012277258433501=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2686012277258433501==
Content-Type: multipart/alternative; boundary=001636d352371bff2c04949cd3ec

--001636d352371bff2c04949cd3ec
Content-Type: text/plain; charset=ISO-8859-1

True, its the same system and you were right it was cache VIPT cache problem
the cache hold the stale value even after xlog_bread() update the buffer.
I do not know whether its correct ways to resolve the problem, but the
problem no longer occur.


diff -Naur -X fs/xfs/linux-2.6/xfs_buf.c fs-dirty/xfs/linux-2.6/xfs_buf.c

--- fs/xfs/linux-2.6/xfs_buf.c 2010-07-18 12:27:11.000000000 +0530

+++ fs-dirty/xfs/linux-2.6/xfs_buf.c 2010-10-25 11:01:28.252762355 +0530

@@ -1166,6 +1166,13 @@

xfs_buf_ioerror(bp, -error);

+ if (!error &&

+ (bp->b_flags & XBF_MAPPED) &&

+ (bp->b_page_count > 1) &&

+ (bp->b_flags & XBF_READ)) {

+ dma_cache_inv((unsigned long)bp->b_addr,

+ (bp->b_page_count * PAGE_SIZE) - bp->b_offset);

+ }

do {

struct page *page = bvec->bv_page;

@@ -1275,6 +1282,10 @@

submit_io:

if (likely(bio->bi_size)) {

+ if ((bp->b_flags & XBF_MAPPED) && (bp->b_page_count > 1)) {

+ dma_cache_wback_inv((unsigned long)bp->b_addr,

+ (bp->b_page_count * PAGE_SIZE) - bp->b_offset);

+ }

submit_bio(rw, bio);

if (size)

goto next_chunk;


On Thu, Nov 4, 2010 at 6:20 PM, Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Nov 04, 2010 at 11:27:24AM +0530, Ajeet Yadav wrote:
> > Linux XFS version : 2.6.34
> > Architecure: MIPS
> > I am getting the following error during mount.
>
> Is this the same mips system that you have the vmap aliasing problems
> during log recovery with?
>
> As long as that is not fixed I would deeply distrust any callchain
> from the recovery code like this one.
>

--001636d352371bff2c04949cd3ec
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>True, its the same system and you were right it was cache VIPT=A0cache=
 problem</div>
<div>the cache hold the stale value even after xlog_bread() update the buff=
er.</div>
<div>I do not know whether its correct ways to=A0resolve the problem, but t=
he problem no longer occur.</div>
<div>=A0</div>
<div><span lang=3D"EN">
<p>diff -Naur -X=A0fs/xfs/linux-2.6/xfs_buf.c fs-dirty/xfs/linux-2.6/xfs_bu=
f.c</p>
<p>--- fs/xfs/linux-2.6/xfs_buf.c 2010-07-18 12:27:11.000000000 +0530</p>
<p>+++ fs-dirty/xfs/linux-2.6/xfs_buf.c 2010-10-25 11:01:28.252762355 +0530=
</p>
<p>@@ -1166,6 +1166,13 @@</p>
<p></p>
<p>xfs_buf_ioerror(bp, -error);</p>
<p></p>
<p>+ if (!error &amp;&amp; </p>
<p>+ (bp-&gt;b_flags &amp; XBF_MAPPED) &amp;&amp; </p>
<p>+ (bp-&gt;b_page_count &gt; 1) &amp;&amp; </p>
<p>+ (bp-&gt;b_flags &amp; XBF_READ)) {</p>
<p>+ dma_cache_inv((unsigned long)bp-&gt;b_addr, </p>
<p>+ (bp-&gt;b_page_count * PAGE_SIZE) - bp-&gt;b_offset);</p>
<p>+ } </p>
<p>do {</p>
<p>struct page *page =3D bvec-&gt;bv_page;</p>
<p></p>
<p>@@ -1275,6 +1282,10 @@</p>
<p></p>
<p>submit_io:</p>
<p>if (likely(bio-&gt;bi_size)) {</p>
<p>+ if ((bp-&gt;b_flags &amp; XBF_MAPPED) &amp;&amp; (bp-&gt;b_page_count =
&gt; 1)) { </p>
<p>+ dma_cache_wback_inv((unsigned long)bp-&gt;b_addr, </p>
<p>+ (bp-&gt;b_page_count * PAGE_SIZE) - bp-&gt;b_offset);</p>
<p>+ }</p>
<p>submit_bio(rw, bio);</p>
<p>if (size)</p>
<p>goto next_chunk;</p>
<p>=A0</p></span></div>
<div class=3D"gmail_quote">On Thu, Nov 4, 2010 at 6:20 PM, Christoph Hellwi=
g <span dir=3D"ltr">&lt;<a href=3D"mailto:hch@infradead.org">hch@infradead.=
org</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Thu, Nov 04, 2010 at 11:27:24AM +0530, Ajeet Yadav wro=
te:<br></div>
<div class=3D"im">&gt; Linux XFS version : 2.6.34<br>&gt; Architecure: MIPS=
<br>&gt; I am getting the following error during mount.<br><br></div>Is thi=
s the same mips system that you have the vmap aliasing problems<br>during l=
og recovery with?<br>
<br>As long as that is not fixed I would deeply distrust any callchain<br>f=
rom the recovery code like this one.<br></blockquote></div><br>

--001636d352371bff2c04949cd3ec--


--===============2686012277258433501==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2686012277258433501==--
