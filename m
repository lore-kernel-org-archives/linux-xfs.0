Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7AFNjb0092452 for <xfs@oss.sgi.com>; Fri, 10 Aug 2012 10:23:45 -0500
Received: from mail-vc0-f181.google.com (mail-vc0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	XOHacTrIv2NTnj29 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Aug 2012 08:23:42 -0700 (PDT)
Received: by vcbfl17 with SMTP id fl17so1780313vcb.26
	for <xfs@oss.sgi.com>; Fri, 10 Aug 2012 08:23:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120731011457.GO2877@dastard>
References: <201207301514247032532@gmail.com> <20120730214213.GF2877@dastard>
	<201207310855556258267@gmail.com> <20120731011457.GO2877@dastard>
Date: Fri, 10 Aug 2012 08:23:41 -0700
Message-ID: <CAFR8uef=7BxCv3obxq8vHFKXGYMJe3F3Qw2C8JAp4_qENmC0xg@mail.gmail.com>
Subject: Re: Re: [PATCH 0/8] Set bi_rw when alloc bio before call bio_add_page.
From: Muthu Kumar <muthu.lkml@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3925919617393211457=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: axboe <axboe@kernel.dk>, shaggy <shaggy@kernel.org>, "chris.mason" <chris.mason@fusionio.com>, elder <elder@kernel.org>, tytso <tytso@mit.edu>, "konrad.wilk" <konrad.wilk@oracle.com>, Neil Brown <neilb@suse.de>, mfasheh <mfasheh@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, jfs-discussion <jfs-discussion@lists.sourceforge.net>, majianpeng <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, bpm <bpm@sgi.com>, "adilger.kernel" <adilger.kernel@dilger.ca>, viro <viro@zeniv.linux.org.uk>, linux-ext4 <linux-ext4@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <xfs@oss.sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>, jlbec <jlbec@evilplan.org>

--===============3925919617393211457==
Content-Type: multipart/alternative; boundary=047d7b676c88d771e404c6eaed7a

--047d7b676c88d771e404c6eaed7a
Content-Type: text/plain; charset=ISO-8859-1

Hi,

On Mon, Jul 30, 2012 at 6:14 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Jul 31, 2012 at 08:55:59AM +0800, majianpeng wrote:
>> On 2012-07-31 05:42 Dave Chinner <david@fromorbit.com> Wrote:
>> >On Mon, Jul 30, 2012 at 03:14:28PM +0800, majianpeng wrote:
>> >> When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,
>> >> it will use bi_rw.
>> >> Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().
>> >> The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
>> >> >> if ((bvm->bi_rw & 1) == WRITE)
>> >> >> return biovec->bv_len; /* always allow writes to be mergeable */
>> >
>> >So if bio_add_page() requires bi_rw to be set, then shouldn't it be
>> >set up for every caller? I noticed there are about 50 call sites for
>> >bio_add_page(), and you've only touched about 10 of them. Indeed, I
>> >notice that the RAID0/1 code uses bio_add_page, and as that can be
>> >stacked on top of RAID456, it also needs to set bi_rw correctly.
>> >As a result, your patch set is nowhere near complete, not does it
>> >document that bio_add_page requires that bi_rw be set before calling
>> >(which is the new API requirement, AFAICT).
>> There are many place call bio_add_page and I send some of those. Because
my abilty, so I only send
>> some patchs which i understand clearly.
>
> Sure, but my point is that there is no point changing only a few and
> ignoring the great majority of callers. Either fix them all, fix it
> some other way (e.g. API change), or remove the code from the RAID5
> function that requires it.
>


A while back, we tried to address this by changing the alloc functions to
take rw argument and set it (as per Jens suggestion). I guess the patch did
not make it in. Please check:

https://lkml.org/lkml/2011/7/11/275

And the follow ups. If needed, I can dust up that patch and resend it.


>> In __bio_add_page:
>> >>if (q->merge_bvec_fn) {
>> >>                            struct bvec_merge_data bvm = {
>> >>                                    /* prev_bvec is already charged in
>> >>                                       bi_size, discharge it in order
to
>> >>                                       simulate merging updated
prev_bvec
>> >>                                       as new bvec. */
>> >>                                    .bi_bdev = bio->bi_bdev,
>> >>                                    .bi_sector = bio->bi_sector,
>> >>                                    .bi_size = bio->bi_size -
prev_bv_len,
>> >>                                    .bi_rw = bio->bi_rw,
>> >>                            };
>> it used bio->bi_rw.
>> Before raid5_mergeable_bvec appearing, in kernel 'merge_bvec_fn' did not
use bio->bi_rw.
>

<snip>


> It's entirely possible that when bi_rw was added to struct
> bvec_merge_data, the person who added it was mistaken that bi_rw was
> set at this point in time when in fact it never has been. Hence it's
> presence and reliance on it would be a bug.
>
> That's what I'm asking - is this actually beneificial, or should it
> simply be removed from struct bvec_merge_data? Data is needed to
> answer that question....


There are cases where we found it really beneficial to know the rw field to
decide if the can be really merged or not.

Regards,
Muthu


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--047d7b676c88d771e404c6eaed7a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>On Mon, Jul 30, 2012 at 6:14 PM, Dave Chinner &lt;<a href=3D"mai=
lto:david@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>&gt; On Tue,=
 Jul 31, 2012 at 08:55:59AM +0800, majianpeng wrote:<br>&gt;&gt; On 2012-07=
-31 05:42 Dave Chinner &lt;<a href=3D"mailto:david@fromorbit.com">david@fro=
morbit.com</a>&gt; Wrote:<br>
&gt;&gt; &gt;On Mon, Jul 30, 2012 at 03:14:28PM +0800, majianpeng wrote:<br=
>&gt;&gt; &gt;&gt; When exec bio_alloc, the bi_rw is zero.But after calling=
 bio_add_page,<br>&gt;&gt; &gt;&gt; it will use bi_rw.<br>&gt;&gt; &gt;&gt;=
 Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().<br>
&gt;&gt; &gt;&gt; The merge_bvec_fn of raid456 will use the bi_rw to judge =
the merge.<br>&gt;&gt; &gt;&gt; &gt;&gt; if ((bvm-&gt;bi_rw &amp; 1) =3D=3D=
 WRITE)<br>&gt;&gt; &gt;&gt; &gt;&gt; return biovec-&gt;bv_len; /* always a=
llow writes to be mergeable */<br>
&gt;&gt; &gt;<br>&gt;&gt; &gt;So if bio_add_page() requires bi_rw to be set=
, then shouldn&#39;t it be<br>&gt;&gt; &gt;set up for every caller? I notic=
ed there are about 50 call sites for<br>&gt;&gt; &gt;bio_add_page(), and yo=
u&#39;ve only touched about 10 of them. Indeed, I<br>
&gt;&gt; &gt;notice that the RAID0/1 code uses bio_add_page, and as that ca=
n be<br>&gt;&gt; &gt;stacked on top of RAID456, it also needs to set bi_rw =
correctly.<br>&gt;&gt; &gt;As a result, your patch set is nowhere near comp=
lete, not does it<br>
&gt;&gt; &gt;document that bio_add_page requires that bi_rw be set before c=
alling<br>&gt;&gt; &gt;(which is the new API requirement, AFAICT).<br>&gt;&=
gt; There are many place call bio_add_page and I send some of those. Becaus=
e my abilty, so I only send<br>
&gt;&gt; some patchs which i understand clearly.<br>&gt;<br>&gt; Sure, but =
my point is that there is no point changing only a few and<br>&gt; ignoring=
 the great majority of callers. Either fix them all, fix it<br>&gt; some ot=
her way (e.g. API change), or remove the code from the RAID5<br>
&gt; function that requires it.<br>&gt;<br><br><br>A while back, we tried t=
o address this by changing the alloc functions to take rw argument and set =
it (as per Jens suggestion). I guess the patch did not make it in. Please c=
heck:<br>
<br><a href=3D"https://lkml.org/lkml/2011/7/11/275">https://lkml.org/lkml/2=
011/7/11/275</a><br><br>And the follow ups. If needed, I can dust up that p=
atch and resend it.<br><br><br>&gt;&gt; In __bio_add_page:<br>&gt;&gt; &gt;=
&gt;if (q-&gt;merge_bvec_fn) {<br>
&gt;&gt; &gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0st=
ruct bvec_merge_data bvm =3D {<br>&gt;&gt; &gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* prev_bvec is already cha=
rged in<br>&gt;&gt; &gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bi_size, discharge it in order to<br>
&gt;&gt; &gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 simulate merging updated prev_bvec<br>&gt;&gt; &gt;&gt;=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 as new bvec. */<br>&gt;&gt; &gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.bi_bdev =3D bio-&gt;bi_bdev,<br>
&gt;&gt; &gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0.bi_sector =3D bio-&gt;bi_sector,<br>&gt;&gt; &gt;&gt; =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.bi_size=
 =3D bio-&gt;bi_size - prev_bv_len,<br>&gt;&gt; &gt;&gt; =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.bi_rw =3D bio-&gt;b=
i_rw,<br>
&gt;&gt; &gt;&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0};=
<br>&gt;&gt; it used bio-&gt;bi_rw.<br>&gt;&gt; Before raid5_mergeable_bvec=
 appearing, in kernel &#39;merge_bvec_fn&#39; did not use bio-&gt;bi_rw.<br=
>&gt;<br><br>&lt;snip&gt;<br>
<br><br>&gt; It&#39;s entirely possible that when bi_rw was added to struct=
<br>&gt; bvec_merge_data, the person who added it was mistaken that bi_rw w=
as<br>&gt; set at this point in time when in fact it never has been. Hence =
it&#39;s<br>
&gt; presence and reliance on it would be a bug.<br>&gt;<br>&gt; That&#39;s=
 what I&#39;m asking - is this actually beneificial, or should it<br>&gt; s=
imply be removed from struct bvec_merge_data? Data is needed to<br>&gt; ans=
wer that question....<br>
<br><br>There are cases where we found it really beneficial to know the rw =
field to decide if the can be really merged or not.<br><br>Regards,<br>Muth=
u<br><br><br>&gt;<br>&gt; Cheers,<br>&gt;<br>&gt; Dave.<br>&gt; --<br>&gt; =
Dave Chinner<br>
&gt; <a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>&gt;=
 --<br>&gt; To unsubscribe from this list: send the line &quot;unsubscribe =
linux-kernel&quot; in<br>&gt; the body of a message to <a href=3D"mailto:ma=
jordomo@vger.kernel.org">majordomo@vger.kernel.org</a><br>
&gt; More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordomo-=
info.html">http://vger.kernel.org/majordomo-info.html</a><br>&gt; Please re=
ad the FAQ at =A0<a href=3D"http://www.tux.org/lkml/">http://www.tux.org/lk=
ml/</a><br>
<br>

--047d7b676c88d771e404c6eaed7a--


--===============3925919617393211457==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3925919617393211457==--
