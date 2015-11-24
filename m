Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A2597F37
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2015 10:55:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 177148F8054
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2015 08:55:43 -0800 (PST)
Received: from mail-vk0-f51.google.com (mail-vk0-f51.google.com
	[209.85.213.51]) by cuda.sgi.com with ESMTP id O2Q7EJkSr7Aa2wZ4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Nov 2015 08:55:42 -0800 (PST)
Received: by vkha189 with SMTP id a189so15828434vkh.2
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2015 08:55:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151124132421.GG25232@quack.suse.cz>
References: <1448294568-20892-1-git-send-email-dmonakhov@openvz.org>
	<20151124132421.GG25232@quack.suse.cz>
Date: Tue, 24 Nov 2015 20:55:40 +0400
Message-ID: <CAF5pi0HpbN=kKQQUA5V1QaBzZMGQDcwuDs4bvuRYifnOHiJ8Bw@mail.gmail.com>
Subject: Re: [PATCH] ext4: fix race aio-dio vs freeze_fs
From: Dmitry Monakhov <dmonakhovopenvz@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2813359735081620562=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Dmitriy Monakhov <dmonakhov@openvz.org>, tytso@mit.edu, xfs@oss.sgi.com

--===============2813359735081620562==
Content-Type: multipart/alternative; boundary=001a1140f5563c548005254c36a4

--001a1140f5563c548005254c36a4
Content-Type: text/plain; charset=UTF-8

On Nov 24, 2015 16:25, "Jan Kara" <jack@suse.cz> wrote:
>
> On Mon 23-11-15 20:02:48, Dmitry Monakhov wrote:
> > After freeze_fs was revoked (from Jan Kara) pages's write-back
completion
> > is deffered before unwritten conversion, so explicit
flush_unwritten_io()
> > was removed here: c724585b62411
> > But we still may face deferred conversion for aio-dio case
> > # Trivial testcase
> > for ((i=0;i<60;i++));do fsfreeze -f /mnt ;sleep 1;fsfreeze -u /mnt;done
&
> > fio --bs=4k --ioengine=libaio --iodepth=128 --size=1g --direct=1 \
> >     --runtime=60 --filename=/mnt/file --name=rand-write --rw=randwrite
> > NOTE: Sane testcase should be integrated to xfstests, but it requires
> > changes in common/* code, so let's use this this test at the moment.
> >
> > In order to fix this race we have to guard journal transaction with
explicit
> > sb_{start,end}_intwrite()  as we do with ext4_evict_inode here:8e8ad8a5
>
> Well, this problem seems to suggest that we have the freeze protection for
> AIO writes wrong. We should call file_end_write() from aio_complete() and
> not from aio_run_iocb()...
Yep. It was my first attempt to fix that issue, but  unfortunately this
trick will break lockdep. Caller will do file_start_write and exit to
userspace. Lockdep treats such behaviour as bug (return to userspace with a
lock held)

There are two way to fix that
1) add specific 'long' lock primitive to lockdep
2) let sync_filesystems to wait pended aio-dio

> I believe XFS and other filesystems may have
> problems with this as well (CCed). Attached patch (so far only compile
> tested since my test machine is pondering on something else) should fix
> this.
>
>                                                                 Honza
>
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

--001a1140f5563c548005254c36a4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
On Nov 24, 2015 16:25, &quot;Jan Kara&quot; &lt;<a href=3D"mailto:jack@suse=
.cz">jack@suse.cz</a>&gt; wrote:<br>
&gt;<br>
&gt; On Mon 23-11-15 20:02:48, Dmitry Monakhov wrote:<br>
&gt; &gt; After freeze_fs was revoked (from Jan Kara) pages&#39;s write-bac=
k completion<br>
&gt; &gt; is deffered before unwritten conversion, so explicit flush_unwrit=
ten_io()<br>
&gt; &gt; was removed here: c724585b62411<br>
&gt; &gt; But we still may face deferred conversion for aio-dio case<br>
&gt; &gt; # Trivial testcase<br>
&gt; &gt; for ((i=3D0;i&lt;60;i++));do fsfreeze -f /mnt ;sleep 1;fsfreeze -=
u /mnt;done &amp;<br>
&gt; &gt; fio --bs=3D4k --ioengine=3Dlibaio --iodepth=3D128 --size=3D1g --d=
irect=3D1 \<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0--runtime=3D60 --filename=3D/mnt/file --name=
=3Drand-write --rw=3Drandwrite<br>
&gt; &gt; NOTE: Sane testcase should be integrated to xfstests, but it requ=
ires<br>
&gt; &gt; changes in common/* code, so let&#39;s use this this test at the =
moment.<br>
&gt; &gt;<br>
&gt; &gt; In order to fix this race we have to guard journal transaction wi=
th explicit<br>
&gt; &gt; sb_{start,end}_intwrite()=C2=A0 as we do with ext4_evict_inode he=
re:8e8ad8a5<br>
&gt;<br>
&gt; Well, this problem seems to suggest that we have the freeze protection=
 for<br>
&gt; AIO writes wrong. We should call file_end_write() from aio_complete() =
and<br>
&gt; not from aio_run_iocb()... <br>
Yep. It was my first attempt to fix that issue, but=C2=A0 unfortunately thi=
s trick will break lockdep. Caller will do file_start_write and exit to use=
rspace. Lockdep treats such behaviour as bug (return to userspace with a lo=
ck held)</p>
<p dir=3D"ltr">There are two way to fix that<br>
1) add specific &#39;long&#39; lock primitive to lockdep<br>
2) let sync_filesystems to wait pended aio-dio <br></p>
<p dir=3D"ltr">&gt; I believe XFS and other filesystems may have<br>
&gt; problems with this as well (CCed). Attached patch (so far only compile=
<br>
&gt; tested since my test machine is pondering on something else) should fi=
x<br>
&gt; this.<br>
&gt;<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 Honza<br>
&gt;<br>
&gt; --<br>
&gt; Jan Kara &lt;<a href=3D"mailto:jack@suse.com">jack@suse.com</a>&gt;<br=
>
&gt; SUSE Labs, CR<br>
</p>

--001a1140f5563c548005254c36a4--


--===============2813359735081620562==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2813359735081620562==--
