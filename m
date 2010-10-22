Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9M5OVgn135545 for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 00:24:31 -0500
Received: from mail-gw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B26B11A77A
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 22:25:45 -0700 (PDT)
Received: from mail-gw0-f53.google.com (mail-gw0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id 85oIqkfzydivEBuJ
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 22:25:45 -0700 (PDT)
Received: by gwb1 with SMTP id 1so877469gwb.26
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 22:25:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimFuG6cVLkYt+7-Y_8PnapFvmry5RUcmpOHaPco@mail.gmail.com>
References: <AANLkTi=wbBhb=s3z9vyw9gL9Qwy0goj+8UtueFyNq+y2@mail.gmail.com>
	<20101021125219.GA21472@infradead.org>
	<AANLkTimFuG6cVLkYt+7-Y_8PnapFvmry5RUcmpOHaPco@mail.gmail.com>
Date: Fri, 22 Oct 2010 10:55:44 +0530
Message-ID: <AANLkTikYuWMdHRtAKLauZpyWiarioB2ezxW2qVb4s9Sv@mail.gmail.com>
Subject: Re: XFS: bad clientid on recovery on MIPS (VIPT cache)
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6584959465173506114=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6584959465173506114==
Content-Type: multipart/alternative; boundary=20cf3054a075d6414b04932ddf1d

--20cf3054a075d6414b04932ddf1d
Content-Type: text/plain; charset=ISO-8859-1

Hello,
I wish to know, why the problem of bad clientid does not come, if we safely
umount the USB storage device.
Also if anyone can help where XFS uses these
flush_kernel_vmap_range/invalidate_kernel_vmap_range.

With what ever understanding I have developed about log recovery that buffer
"dbp" is updated with new value in xlog_bread(), but the cache hold buffer
lines of last iteration, I think if we can can dpd pages uncachable than it
may solve this problem, pls comment if I am wrong.

dbp = xlog_get_bp(log, BTOBB(h_size)); --------> In function
xlog_do_recovery_pass()

for (blk_no = tail_blk; blk_no < head_blk; ) {
.
    error = xlog_bread(log, blk_no + hblks, bblks, dbp,
                               &offset);
    if (error)
            goto bread_err2;
    xlog_unpack_data(rhead, offset, log);
    if ((error = xlog_recover_process_data(log,
                   rhash, rhead, offset, pass)))
        goto bread_err2;
   blk_no += bblks + hblks;
}



On Thu, Oct 21, 2010 at 6:57 PM, Ajeet Yadav <ajeet.yadav.77@gmail.com>wrote:

> Thanks for response,
>
> Linux kernel I am using is 2.6.30, where as XFS I have ported until 2.6.34
> on given kernel.
> Do you think I need the mentioned API
> flush_kernel_vmap_range/invalidate_kernel_vmap_range in 2.6.30.9 as well.I
> will be grateful if you can provide me sample code for the above API.
>
>
>
> On Thu, Oct 21, 2010 at 6:22 PM, Christoph Hellwig <hch@infradead.org>wrote:
>
>> On Thu, Oct 21, 2010 at 05:41:43PM +0530, Ajeet Yadav wrote:
>> > Dear member,
>> > If I remove USB flash storage from PC/ARM/MIPS target (i.e
>> > without umount) while copying file to XFS partition and connect it to
>> MIPS
>> > target I always get
>> > XFS: xlog_recover_process_data: bad clientid
>> > XFS: log mount/recovery failed: error 5
>> > XFS: log mount failed
>> > This problem does not occur, if I connect the same USB flash to PC/ARM
>> > target.
>> > I have tested this on 2.6.30 - 2.6.34 (It everywhere when concerend with
>> > MIPS)
>>
>> Since Linux 2.6.34 Linux uses the flush_kernel_vmap_range/
>> invalidate_kernel_vmap_range APIs to make I/O to vmapped
>> areas work on systems with virtually indexed caches.
>>
>> Unfortunately only arm, parisc and sh actually implement these so far.
>> You'll need to implement an implementation of these APIs for your cache
>> architecture to make XFS work on MIPS with virtually indexed caches.
>>
>
>

--20cf3054a075d6414b04932ddf1d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hello,</div>
<div>I wish to know, why the problem of bad clientid does not come, if we s=
afely umount the USB storage device.</div>
<div>Also if anyone can help where XFS uses these flush_kernel_vmap_range/i=
nvalidate_kernel_vmap_range.</div>
<div>=A0</div>
<div>With what ever understanding=A0I have developed about log recovery tha=
t buffer &quot;dbp&quot; is updated with new value in xlog_bread(), but the=
 cache hold buffer lines=A0of last iteration, I think if we can can dpd pag=
es uncachable than it may solve this problem, pls comment if I am wrong.=A0=
=A0</div>

<div>=A0=A0=A0=A0=A0</div>
<div>dbp =3D xlog_get_bp(log, BTOBB(h_size)); --------&gt; In function xlog=
_do_recovery_pass()=A0=A0=A0=A0</div>
<div>=A0</div>
<div>for (blk_no =3D tail_blk; blk_no &lt; head_blk; ) {</div>
<div>.</div>
<div>=A0=A0=A0 error =3D xlog_bread(log, blk_no + hblks, bblks, dbp,<br>=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 &amp;offset);<br>=A0=A0=A0 if (error)<br>=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 goto bread_err2;</div>
<div>=A0=A0=A0=A0xlog_unpack_data(rhead, offset, log);<br>=A0=A0=A0=A0if ((=
error =3D xlog_recover_process_data(log,<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 rhash, rhead, offset, pass)))<br>=A0=A0=A0=A0=A0=
=A0=A0 goto bread_err2;<br>=A0=A0=A0blk_no +=3D bblks + hblks;</div>
<div>}=A0=A0</div>
<div><br><br>=A0</div>
<div class=3D"gmail_quote">On Thu, Oct 21, 2010 at 6:57 PM, Ajeet Yadav <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:ajeet.yadav.77@gmail.com">ajeet.yadav.=
77@gmail.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>Thanks for response, </div>
<div>=A0</div>
<div>Linux kernel I am using is 2.6.30, where as XFS I have ported until 2.=
6.34 on given kernel.</div>
<div>Do you think I need the mentioned=A0API flush_kernel_vmap_range/invali=
date_kernel_vmap_range in 2.6.30.9 as well.I will be grateful if you can pr=
ovide me sample code for the above API.=A0=A0</div>
<div>
<div></div>
<div class=3D"h5">
<div><br><br>=A0</div>
<div class=3D"gmail_quote">On Thu, Oct 21, 2010 at 6:22 PM, Christoph Hellw=
ig <span dir=3D"ltr">&lt;<a href=3D"mailto:hch@infradead.org" target=3D"_bl=
ank">hch@infradead.org</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>On Thu, Oct 21, 2010 at 05:41:43PM +0530, Ajeet Yadav wrote:<br>&gt; D=
ear member,<br>&gt; If I remove USB flash storage from PC/ARM/MIPS target (=
i.e<br>&gt; without umount) while copying file to XFS partition and connect=
 it to MIPS<br>
&gt; target I always get<br>&gt; XFS: xlog_recover_process_data: bad client=
id<br>&gt; XFS: log mount/recovery failed: error 5<br>&gt; XFS: log mount f=
ailed<br>&gt; This problem does not occur, if I connect the same USB flash =
to PC/ARM<br>
&gt; target.<br>&gt; I have tested this on 2.6.30 - 2.6.34 (It everywhere w=
hen concerend with<br>&gt; MIPS)<br><br></div>Since Linux 2.6.34 Linux uses=
 the flush_kernel_vmap_range/<br>invalidate_kernel_vmap_range APIs to make =
I/O to vmapped<br>
areas work on systems with virtually indexed caches.<br><br>Unfortunately o=
nly arm, parisc and sh actually implement these so far.<br>You&#39;ll need =
to implement an implementation of these APIs for your cache<br>architecture=
 to make XFS work on MIPS with virtually indexed caches.<br>
</blockquote></div><br></div></div></blockquote></div><br>

--20cf3054a075d6414b04932ddf1d--


--===============6584959465173506114==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6584959465173506114==--
