Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 181657F3F
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 03:39:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EBA948F8035
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 01:39:06 -0700 (PDT)
Received: from mail-ob0-f176.google.com (mail-ob0-f176.google.com
	[209.85.214.176]) by cuda.sgi.com with ESMTP id
	u5BUtDFkAkA2qNL1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Oct 2014 01:39:01 -0700 (PDT)
Received: by mail-ob0-f176.google.com with SMTP id va2so3758844obc.35
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 01:39:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141030050306.GI13323@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<20141029212556.GH13323@dastard>
	<CAGdb-8dbGRu_GWB4qoeNP8Kso2hzkLcuFS9Pwtnm2xOkP2T0rQ@mail.gmail.com>
	<20141030050306.GI13323@dastard>
Date: Thu, 30 Oct 2014 16:39:01 +0800
Message-ID: <CAGdb-8dt23oO7nncZdtri1BeNyWkR-6UF_4QRZx2X-5+tFYSRw@mail.gmail.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
From: Tommy Wu <wu.tommy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5066574093484289618=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

--===============5066574093484289618==
Content-Type: multipart/alternative; boundary=089e01176417eccfab05069fcf5b

--089e01176417eccfab05069fcf5b
Content-Type: text/plain; charset=UTF-8

I'm confusing now...

in the test VM and one of my machine, rebuild xfsdump/xfsprogs will make
the test work.

In one of my machine, still got error.

fw1:/vol/backup/x# ldd /sbin/xfsdump
        linux-vdso.so.1 (0x00007fff3f7fe000)
        libuuid.so.1 => /lib/x86_64-linux-gnu/libuuid.so.1
(0x00007f8c2bf9d000)
        libhandle.so.1 => /lib/libhandle.so.1 (0x00007f8c2bd99000)
        libattr.so.1 => /lib/x86_64-linux-gnu/libattr.so.1
(0x00007f8c2bb93000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0
(0x00007f8c2b976000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f8c2b5cd000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f8c2c1b5000)
fw1:/vol/backup/x# ldd /sbin/xfsrestore
        linux-vdso.so.1 (0x00007fffcee8d000)
        libuuid.so.1 => /lib/x86_64-linux-gnu/libuuid.so.1
(0x00007ff53d507000)
        libhandle.so.1 => /lib/libhandle.so.1 (0x00007ff53d303000)
        libattr.so.1 => /lib/x86_64-linux-gnu/libattr.so.1
(0x00007ff53d0fd000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0
(0x00007ff53cee0000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007ff53cb37000)
        /lib64/ld-linux-x86-64.so.2 (0x00007ff53d71f000)

the xfsdump command I use:
xfsdump -v debug -l 0 -o -p 300 -J -F -M test -L test -f test.xfsdump
/mnt/backup > xfsdump.log
the log:
https://mega.co.nz/#!xIhTjD6Y!Gwp_ilW5UyRiqn2DSxPTHM0TH5qBghMlKXAmHoWk2iQ

the xfsrestore command I use:
xfsrestore -v debug,tree=nitty -p 300 -J -f test.xfsdump /vol/backup/x/ >
xfsrestore.log
the log:
https://mega.co.nz/#!oZIFWQST!VUY90EZ8XvZDYy9GwF5mqtQVtWNW90Sar5MZhNzGbYI



2014-10-30 13:03 GMT+08:00 Dave Chinner <david@fromorbit.com>:

> On Thu, Oct 30, 2014 at 11:07:21AM +0800, Tommy Wu wrote:
> > I just create a x86-64 VM (using VirtualBox 4.3.18, under windows 8).
> > Install Debian jessie on it. Create a test partition in LVM for testing.
> > (so I think it's not hardware issue here)
> >
> > test procedure:
> > 1. mkfs.xfs the 1st partition in LVM
> > 2. mount  the 1st partition
> > 3. extract linux-3.17.tar.xz to the partition
> > 4. xfsdump the 1st partition
> > 5. mkfs.xfs the 2nd partition in LVM
> > 6. mount the 2nd partition
> > 7. xfsrestore the dump file to 2nd partition
> > 8. compare the file/directory in 2 partitions.
>
> Partition sizes are roughly a 5GB source and 10GB destination.
>
> So there's this many files in the fs:
>
> > xfsrestore: 3054 directories and 50556 entries processed
>
> OK, so on 3.18-rc2:
>
> > root@debian:/mnt/xfsdump# mount /dev/debian/xfsrestore /mnt/xfsrestore
> > root@debian:/mnt/xfsdump# cd /mnt/xfsrestore/
> > root@debian:/mnt/xfsrestore# xfsdump -l 0 -o -p 300 -J -F -M test -L
> test -
> > /mnt/xfsdump | gzip -qv > /mnt/xfsrestore/xfsdump.gz
> ....
> > xfsdump: media file size 575648352 bytes
> > xfsdump: dump size (non-dir files) : 560258760 bytes
>
> These are a handful of bytes different.
>
> > xfsdump: dump complete: 21 seconds elapsed
> > xfsdump: Dump Status: SUCCESS
> >  78.5%
> > root@debian:/mnt/xfsrestore# ls -la
> > total 120680
> > drwxr-xr-x 2 root root        23 Oct 30 10:48 .
> > drwxr-xr-x 4 root root      4096 Oct 30 10:37 ..
> > -rw-r--r-- 1 root root 123569739 Oct 30 10:48 xfsdump.gz
> > root@debian:/mnt/xfsrestore# cat /mnt/xfsrestore/xfsdump.gz | gzip -dqv
> |
> > xfsrestore -p 300 -J -t - | grep xfsrestore
>
> and the test shows:
>
> > xfsrestore: reading directories
> > xfsrestore: 2035 directories and 33045 entries processed
>
> A thousand less directories and 20000 less files, which doesn't make
> much sense for a dump that has a few bytes difference in size.
>
> So, I've done almost exactly the same test locally (I used the
> 3.18-rc2 tarball) and on both the upstream 3.18-rc2 kernel and my
> current xfs-fixes-for-3.18-rc3 branch I can't reproduce your
> problem:
>
> $  find /mnt/test -type d |wc -l
> 3080
> $  find /mnt/test  |wc -l
> 51068
> $ zcat dump.gz | sudo xfsrestore -p 300 -J - . |grep xfsrestore
> .....
> xfsrestore: reading directories
> xfsrestore: 3080 directories and 51068 entries processed
> xfsrestore: directory post-processing
> xfsrestore: restoring non-directory files
> xfsrestore: restore complete: 7 seconds elapsed
> xfsrestore: Restore Status: SUCCESS
> $ find /mnt/scratch -type d |wc -l
> 3080
> $ find /mnt/scratch |wc -l
> 51069
> $ ls /mnt/scratch
> dump.gz  linux-3.18-rc2
> $
>
> Which shows that it's working just fine.  I've tried cold cache
> dumps. I've tried crc enabled filesystems, I've tried a bunch of
> random permutations, but I cannot get dump/restore to do what you
> are seeing it do. Whatever problem you are seeing is specific to
> your system.
>
> Hmmm - can you run 'ldd xfsdump' and 'ldd xfsrestore' and paste the
> output for me?
>
> Can you also please run a full test again on a kernel built from the
> current xfs-fixes-for-3.18-rc3 branch, with full dump/restore debug
> enabled and send me the output? i.e.
>
> $ xfsdump -v debug ...
>
> and
>
> $ xfsrestore -v debug,tree=nitty ...
>
> They ar going to produce a lot of output, so please capture it to
> files rather than trying to cut/paste output to an email.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



-- 

Tommy Wu

--089e01176417eccfab05069fcf5b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div>I&#39;m confusing now...<br><br><=
/div><div>in the test VM and one of my machine, rebuild xfsdump/xfsprogs wi=
ll make the test work.<br></div><div><br></div>In one of my machine, still =
got error.<br><br>fw1:/vol/backup/x# ldd /sbin/xfsdump<br>=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 linux-vdso.so.1 (0x00007fff3f7fe000)<br>=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libuuid.so.1 =3D&gt; /lib/x86_64-linux=
-gnu/libuuid.so.1 (0x00007f8c2bf9d000)<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 libhandle.so.1 =3D&gt; /lib/libhandle.so.1 (0x00007f8c2bd99000)<b=
r>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libattr.so.1 =3D&gt; /lib/x86_=
64-linux-gnu/libattr.so.1 (0x00007f8c2bb93000)<br>=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 libpthread.so.0 =3D&gt; /lib/x86_64-linux-gnu/libpthread=
.so.0 (0x00007f8c2b976000)<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li=
bc.so.6 =3D&gt; /lib/x86_64-linux-gnu/libc.so.6 (0x00007f8c2b5cd000)<br>=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /lib64/ld-linux-x86-64.so.2 (0x0000=
7f8c2c1b5000)<br>fw1:/vol/backup/x# ldd /sbin/xfsrestore<br>=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 linux-vdso.so.1 (0x00007fffcee8d000)<br>=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libuuid.so.1 =3D&gt; /lib/x86_64-linux=
-gnu/libuuid.so.1 (0x00007ff53d507000)<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 libhandle.so.1 =3D&gt; /lib/libhandle.so.1 (0x00007ff53d303000)<b=
r>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libattr.so.1 =3D&gt; /lib/x86_=
64-linux-gnu/libattr.so.1 (0x00007ff53d0fd000)<br>=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 libpthread.so.0 =3D&gt; /lib/x86_64-linux-gnu/libpthread=
.so.0 (0x00007ff53cee0000)<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 li=
bc.so.6 =3D&gt; /lib/x86_64-linux-gnu/libc.so.6 (0x00007ff53cb37000)<br>=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /lib64/ld-linux-x86-64.so.2 (0x0000=
7ff53d71f000)<br><br></div>the xfsdump command I use:<br>xfsdump -v debug -=
l 0 -o -p 300 -J -F -M test -L test -f test.xfsdump /mnt/backup &gt; xfsdum=
p.log<br></div>the log: <a href=3D"https://mega.co.nz/#!xIhTjD6Y!Gwp_ilW5Uy=
Riqn2DSxPTHM0TH5qBghMlKXAmHoWk2iQ">https://mega.co.nz/#!xIhTjD6Y!Gwp_ilW5Uy=
Riqn2DSxPTHM0TH5qBghMlKXAmHoWk2iQ</a><br><br></div>the xfsrestore command I=
 use:<br>xfsrestore -v debug,tree=3Dnitty -p 300 -J -f test.xfsdump /vol/ba=
ckup/x/ &gt; xfsrestore.log<br></div>the log: <a href=3D"https://mega.co.nz=
/#!oZIFWQST!VUY90EZ8XvZDYy9GwF5mqtQVtWNW90Sar5MZhNzGbYI">https://mega.co.nz=
/#!oZIFWQST!VUY90EZ8XvZDYy9GwF5mqtQVtWNW90Sar5MZhNzGbYI</a><br><br><div><di=
v><div><div><div><br></div></div></div></div></div></div><div class=3D"gmai=
l_extra"><br><div class=3D"gmail_quote">2014-10-30 13:03 GMT+08:00 Dave Chi=
nner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D=
"_blank">david@fromorbit.com</a>&gt;</span>:<br><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex"><span class=3D"">On Thu, Oct 30, 2014 at 11:07:21AM +0800, Tommy Wu wro=
te:<br>
&gt; I just create a x86-64 VM (using VirtualBox 4.3.18, under windows 8).<=
br>
&gt; Install Debian jessie on it. Create a test partition in LVM for testin=
g.<br>
&gt; (so I think it&#39;s not hardware issue here)<br>
&gt;<br>
&gt; test procedure:<br>
&gt; 1. mkfs.xfs the 1st partition in LVM<br>
&gt; 2. mount=C2=A0 the 1st partition<br>
&gt; 3. extract linux-3.17.tar.xz to the partition<br>
&gt; 4. xfsdump the 1st partition<br>
&gt; 5. mkfs.xfs the 2nd partition in LVM<br>
&gt; 6. mount the 2nd partition<br>
&gt; 7. xfsrestore the dump file to 2nd partition<br>
&gt; 8. compare the file/directory in 2 partitions.<br>
<br>
</span>Partition sizes are roughly a 5GB source and 10GB destination.<br>
<br>
So there&#39;s this many files in the fs:<br>
<span class=3D""><br>
&gt; xfsrestore: 3054 directories and 50556 entries processed<br>
<br>
</span>OK, so on 3.18-rc2:<br>
<span class=3D""><br>
&gt; root@debian:/mnt/xfsdump# mount /dev/debian/xfsrestore /mnt/xfsrestore=
<br>
&gt; root@debian:/mnt/xfsdump# cd /mnt/xfsrestore/<br>
&gt; root@debian:/mnt/xfsrestore# xfsdump -l 0 -o -p 300 -J -F -M test -L t=
est -<br>
&gt; /mnt/xfsdump | gzip -qv &gt; /mnt/xfsrestore/xfsdump.gz<br>
</span>....<br>
<span class=3D"">&gt; xfsdump: media file size 575648352 bytes<br>
&gt; xfsdump: dump size (non-dir files) : 560258760 bytes<br>
<br>
</span>These are a handful of bytes different.<br>
<span class=3D""><br>
&gt; xfsdump: dump complete: 21 seconds elapsed<br>
&gt; xfsdump: Dump Status: SUCCESS<br>
&gt;=C2=A0 78.5%<br>
&gt; root@debian:/mnt/xfsrestore# ls -la<br>
&gt; total 120680<br>
&gt; drwxr-xr-x 2 root root=C2=A0 =C2=A0 =C2=A0 =C2=A0 23 Oct 30 10:48 .<br=
>
&gt; drwxr-xr-x 4 root root=C2=A0 =C2=A0 =C2=A0 4096 Oct 30 10:37 ..<br>
&gt; -rw-r--r-- 1 root root 123569739 Oct 30 10:48 xfsdump.gz<br>
&gt; root@debian:/mnt/xfsrestore# cat /mnt/xfsrestore/xfsdump.gz | gzip -dq=
v |<br>
&gt; xfsrestore -p 300 -J -t - | grep xfsrestore<br>
<br>
</span>and the test shows:<br>
<span class=3D""><br>
&gt; xfsrestore: reading directories<br>
&gt; xfsrestore: 2035 directories and 33045 entries processed<br>
<br>
</span>A thousand less directories and 20000 less files, which doesn&#39;t =
make<br>
much sense for a dump that has a few bytes difference in size.<br>
<br>
So, I&#39;ve done almost exactly the same test locally (I used the<br>
3.18-rc2 tarball) and on both the upstream 3.18-rc2 kernel and my<br>
current xfs-fixes-for-3.18-rc3 branch I can&#39;t reproduce your<br>
problem:<br>
<br>
$=C2=A0 find /mnt/test -type d |wc -l<br>
3080<br>
$=C2=A0 find /mnt/test=C2=A0 |wc -l<br>
51068<br>
$ zcat dump.gz | sudo xfsrestore -p 300 -J - . |grep xfsrestore<br>
.....<br>
xfsrestore: reading directories<br>
xfsrestore: 3080 directories and 51068 entries processed<br>
<span class=3D"">xfsrestore: directory post-processing<br>
xfsrestore: restoring non-directory files<br>
</span>xfsrestore: restore complete: 7 seconds elapsed<br>
xfsrestore: Restore Status: SUCCESS<br>
$ find /mnt/scratch -type d |wc -l<br>
3080<br>
$ find /mnt/scratch |wc -l<br>
51069<br>
$ ls /mnt/scratch<br>
dump.gz=C2=A0 linux-3.18-rc2<br>
$<br>
<br>
Which shows that it&#39;s working just fine.=C2=A0 I&#39;ve tried cold cach=
e<br>
dumps. I&#39;ve tried crc enabled filesystems, I&#39;ve tried a bunch of<br=
>
random permutations, but I cannot get dump/restore to do what you<br>
are seeing it do. Whatever problem you are seeing is specific to<br>
your system.<br>
<br>
Hmmm - can you run &#39;ldd xfsdump&#39; and &#39;ldd xfsrestore&#39; and p=
aste the<br>
output for me?<br>
<br>
Can you also please run a full test again on a kernel built from the<br>
current xfs-fixes-for-3.18-rc3 branch, with full dump/restore debug<br>
enabled and send me the output? i.e.<br>
<br>
$ xfsdump -v debug ...<br>
<br>
and<br>
<br>
$ xfsrestore -v debug,tree=3Dnitty ...<br>
<br>
They ar going to produce a lot of output, so please capture it to<br>
files rather than trying to cut/paste output to an email.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br><div class=
=3D"gmail_signature"><br>Tommy Wu</div>
</div>

--089e01176417eccfab05069fcf5b--


--===============5066574093484289618==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5066574093484289618==--
