Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6242C7F3F
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 05:39:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C3D8AC004
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 03:39:57 -0700 (PDT)
Received: from mail-oi0-f44.google.com (mail-oi0-f44.google.com
	[209.85.218.44]) by cuda.sgi.com with ESMTP id raU8q9GTnv3zWSiv
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 30 Oct 2014 03:39:56 -0700 (PDT)
Received: by mail-oi0-f44.google.com with SMTP id h136so3777087oig.31
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2014 03:39:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGdb-8dt23oO7nncZdtri1BeNyWkR-6UF_4QRZx2X-5+tFYSRw@mail.gmail.com>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
	<20141029212556.GH13323@dastard>
	<CAGdb-8dbGRu_GWB4qoeNP8Kso2hzkLcuFS9Pwtnm2xOkP2T0rQ@mail.gmail.com>
	<20141030050306.GI13323@dastard>
	<CAGdb-8dt23oO7nncZdtri1BeNyWkR-6UF_4QRZx2X-5+tFYSRw@mail.gmail.com>
Date: Thu, 30 Oct 2014 18:39:55 +0800
Message-ID: <CAGdb-8eNo0ZaxBXehRcnHdS1c_fP5su_cdu=wdOZ5w0kbAjahA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============3772763090156488383=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

--===============3772763090156488383==
Content-Type: multipart/alternative; boundary=001a113cd0a04e6a440506a18008

--001a113cd0a04e6a440506a18008
Content-Type: text/plain; charset=UTF-8

It' look like no help after rebuild xfsdump/xfsprogs, it still got the same
error for some case.

2014-10-30 16:39 GMT+08:00 Tommy Wu <wu.tommy@gmail.com>:

> I'm confusing now...
>
> in the test VM and one of my machine, rebuild xfsdump/xfsprogs will make
> the test work.
>
> In one of my machine, still got error.
>
> fw1:/vol/backup/x# ldd /sbin/xfsdump
>         linux-vdso.so.1 (0x00007fff3f7fe000)
>         libuuid.so.1 => /lib/x86_64-linux-gnu/libuuid.so.1
> (0x00007f8c2bf9d000)
>         libhandle.so.1 => /lib/libhandle.so.1 (0x00007f8c2bd99000)
>         libattr.so.1 => /lib/x86_64-linux-gnu/libattr.so.1
> (0x00007f8c2bb93000)
>         libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0
> (0x00007f8c2b976000)
>         libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f8c2b5cd000)
>         /lib64/ld-linux-x86-64.so.2 (0x00007f8c2c1b5000)
> fw1:/vol/backup/x# ldd /sbin/xfsrestore
>         linux-vdso.so.1 (0x00007fffcee8d000)
>         libuuid.so.1 => /lib/x86_64-linux-gnu/libuuid.so.1
> (0x00007ff53d507000)
>         libhandle.so.1 => /lib/libhandle.so.1 (0x00007ff53d303000)
>         libattr.so.1 => /lib/x86_64-linux-gnu/libattr.so.1
> (0x00007ff53d0fd000)
>         libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0
> (0x00007ff53cee0000)
>         libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007ff53cb37000)
>         /lib64/ld-linux-x86-64.so.2 (0x00007ff53d71f000)
>
> the xfsdump command I use:
> xfsdump -v debug -l 0 -o -p 300 -J -F -M test -L test -f test.xfsdump
> /mnt/backup > xfsdump.log
> the log:
> https://mega.co.nz/#!xIhTjD6Y!Gwp_ilW5UyRiqn2DSxPTHM0TH5qBghMlKXAmHoWk2iQ
>
> the xfsrestore command I use:
> xfsrestore -v debug,tree=nitty -p 300 -J -f test.xfsdump /vol/backup/x/ >
> xfsrestore.log
> the log:
> https://mega.co.nz/#!oZIFWQST!VUY90EZ8XvZDYy9GwF5mqtQVtWNW90Sar5MZhNzGbYI
>
>
>
> 2014-10-30 13:03 GMT+08:00 Dave Chinner <david@fromorbit.com>:
>
>> On Thu, Oct 30, 2014 at 11:07:21AM +0800, Tommy Wu wrote:
>> > I just create a x86-64 VM (using VirtualBox 4.3.18, under windows 8).
>> > Install Debian jessie on it. Create a test partition in LVM for testing.
>> > (so I think it's not hardware issue here)
>> >
>> > test procedure:
>> > 1. mkfs.xfs the 1st partition in LVM
>> > 2. mount  the 1st partition
>> > 3. extract linux-3.17.tar.xz to the partition
>> > 4. xfsdump the 1st partition
>> > 5. mkfs.xfs the 2nd partition in LVM
>> > 6. mount the 2nd partition
>> > 7. xfsrestore the dump file to 2nd partition
>> > 8. compare the file/directory in 2 partitions.
>>
>> Partition sizes are roughly a 5GB source and 10GB destination.
>>
>> So there's this many files in the fs:
>>
>> > xfsrestore: 3054 directories and 50556 entries processed
>>
>> OK, so on 3.18-rc2:
>>
>> > root@debian:/mnt/xfsdump# mount /dev/debian/xfsrestore /mnt/xfsrestore
>> > root@debian:/mnt/xfsdump# cd /mnt/xfsrestore/
>> > root@debian:/mnt/xfsrestore# xfsdump -l 0 -o -p 300 -J -F -M test -L
>> test -
>> > /mnt/xfsdump | gzip -qv > /mnt/xfsrestore/xfsdump.gz
>> ....
>> > xfsdump: media file size 575648352 bytes
>> > xfsdump: dump size (non-dir files) : 560258760 bytes
>>
>> These are a handful of bytes different.
>>
>> > xfsdump: dump complete: 21 seconds elapsed
>> > xfsdump: Dump Status: SUCCESS
>> >  78.5%
>> > root@debian:/mnt/xfsrestore# ls -la
>> > total 120680
>> > drwxr-xr-x 2 root root        23 Oct 30 10:48 .
>> > drwxr-xr-x 4 root root      4096 Oct 30 10:37 ..
>> > -rw-r--r-- 1 root root 123569739 Oct 30 10:48 xfsdump.gz
>> > root@debian:/mnt/xfsrestore# cat /mnt/xfsrestore/xfsdump.gz | gzip
>> -dqv |
>> > xfsrestore -p 300 -J -t - | grep xfsrestore
>>
>> and the test shows:
>>
>> > xfsrestore: reading directories
>> > xfsrestore: 2035 directories and 33045 entries processed
>>
>> A thousand less directories and 20000 less files, which doesn't make
>> much sense for a dump that has a few bytes difference in size.
>>
>> So, I've done almost exactly the same test locally (I used the
>> 3.18-rc2 tarball) and on both the upstream 3.18-rc2 kernel and my
>> current xfs-fixes-for-3.18-rc3 branch I can't reproduce your
>> problem:
>>
>> $  find /mnt/test -type d |wc -l
>> 3080
>> $  find /mnt/test  |wc -l
>> 51068
>> $ zcat dump.gz | sudo xfsrestore -p 300 -J - . |grep xfsrestore
>> .....
>> xfsrestore: reading directories
>> xfsrestore: 3080 directories and 51068 entries processed
>> xfsrestore: directory post-processing
>> xfsrestore: restoring non-directory files
>> xfsrestore: restore complete: 7 seconds elapsed
>> xfsrestore: Restore Status: SUCCESS
>> $ find /mnt/scratch -type d |wc -l
>> 3080
>> $ find /mnt/scratch |wc -l
>> 51069
>> $ ls /mnt/scratch
>> dump.gz  linux-3.18-rc2
>> $
>>
>> Which shows that it's working just fine.  I've tried cold cache
>> dumps. I've tried crc enabled filesystems, I've tried a bunch of
>> random permutations, but I cannot get dump/restore to do what you
>> are seeing it do. Whatever problem you are seeing is specific to
>> your system.
>>
>> Hmmm - can you run 'ldd xfsdump' and 'ldd xfsrestore' and paste the
>> output for me?
>>
>> Can you also please run a full test again on a kernel built from the
>> current xfs-fixes-for-3.18-rc3 branch, with full dump/restore debug
>> enabled and send me the output? i.e.
>>
>> $ xfsdump -v debug ...
>>
>> and
>>
>> $ xfsrestore -v debug,tree=nitty ...
>>
>> They ar going to produce a lot of output, so please capture it to
>> files rather than trying to cut/paste output to an email.
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>
>
>
> --
>
> Tommy Wu
>



-- 

Tommy Wu

--001a113cd0a04e6a440506a18008
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">It&#39; look like no help after rebuild xfsdump/xfsprogs, =
it still got the same error for some case.<br></div><div class=3D"gmail_ext=
ra"><br><div class=3D"gmail_quote">2014-10-30 16:39 GMT+08:00 Tommy Wu <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:wu.tommy@gmail.com" target=3D"_blank">w=
u.tommy@gmail.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div di=
r=3D"ltr"><div><div><div><div><div>I&#39;m confusing now...<br><br></div><d=
iv>in the test VM and one of my machine, rebuild xfsdump/xfsprogs will make=
 the test work.<br></div><div><br></div>In one of my machine, still got err=
or.<br><br>fw1:/vol/backup/x# ldd /sbin/xfsdump<br>=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 linux-vdso.so.1 (0x00007fff3f7fe000)<br>=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 libuuid.so.1 =3D&gt; /lib/x86_64-linux-gnu/libu=
uid.so.1 (0x00007f8c2bf9d000)<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 libhandle.so.1 =3D&gt; /lib/libhandle.so.1 (0x00007f8c2bd99000)<br>=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libattr.so.1 =3D&gt; /lib/x86_64-linux=
-gnu/libattr.so.1 (0x00007f8c2bb93000)<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 libpthread.so.0 =3D&gt; /lib/x86_64-linux-gnu/libpthread.so.0 (0x=
00007f8c2b976000)<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libc.so.6 =
=3D&gt; /lib/x86_64-linux-gnu/libc.so.6 (0x00007f8c2b5cd000)<br>=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /lib64/ld-linux-x86-64.so.2 (0x00007f8c2c=
1b5000)<br>fw1:/vol/backup/x# ldd /sbin/xfsrestore<br>=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 linux-vdso.so.1 (0x00007fffcee8d000)<br>=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libuuid.so.1 =3D&gt; /lib/x86_64-linux-gnu/l=
ibuuid.so.1 (0x00007ff53d507000)<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 libhandle.so.1 =3D&gt; /lib/libhandle.so.1 (0x00007ff53d303000)<br>=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libattr.so.1 =3D&gt; /lib/x86_64-li=
nux-gnu/libattr.so.1 (0x00007ff53d0fd000)<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 libpthread.so.0 =3D&gt; /lib/x86_64-linux-gnu/libpthread.so.0 =
(0x00007ff53cee0000)<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libc.so.=
6 =3D&gt; /lib/x86_64-linux-gnu/libc.so.6 (0x00007ff53cb37000)<br>=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /lib64/ld-linux-x86-64.so.2 (0x00007ff53d=
71f000)<br><br></div>the xfsdump command I use:<br>xfsdump -v debug -l 0 -o=
 -p 300 -J -F -M test -L test -f test.xfsdump /mnt/backup &gt; xfsdump.log<=
br></div>the log: <a href=3D"https://mega.co.nz/#!xIhTjD6Y!Gwp_ilW5UyRiqn2D=
SxPTHM0TH5qBghMlKXAmHoWk2iQ" target=3D"_blank">https://mega.co.nz/#!xIhTjD6=
Y!Gwp_ilW5UyRiqn2DSxPTHM0TH5qBghMlKXAmHoWk2iQ</a><br><br></div>the xfsresto=
re command I use:<br>xfsrestore -v debug,tree=3Dnitty -p 300 -J -f test.xfs=
dump /vol/backup/x/ &gt; xfsrestore.log<br></div>the log: <a href=3D"https:=
//mega.co.nz/#!oZIFWQST!VUY90EZ8XvZDYy9GwF5mqtQVtWNW90Sar5MZhNzGbYI" target=
=3D"_blank">https://mega.co.nz/#!oZIFWQST!VUY90EZ8XvZDYy9GwF5mqtQVtWNW90Sar=
5MZhNzGbYI</a><br><br><div><div><div><div><div><br></div></div></div></div>=
</div></div><div class=3D"gmail_extra"><div><div class=3D"h5"><br><div clas=
s=3D"gmail_quote">2014-10-30 13:03 GMT+08:00 Dave Chinner <span dir=3D"ltr"=
>&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorb=
it.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span>On Thu, Oct =
30, 2014 at 11:07:21AM +0800, Tommy Wu wrote:<br>
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
<span><br>
&gt; xfsrestore: 3054 directories and 50556 entries processed<br>
<br>
</span>OK, so on 3.18-rc2:<br>
<span><br>
&gt; root@debian:/mnt/xfsdump# mount /dev/debian/xfsrestore /mnt/xfsrestore=
<br>
&gt; root@debian:/mnt/xfsdump# cd /mnt/xfsrestore/<br>
&gt; root@debian:/mnt/xfsrestore# xfsdump -l 0 -o -p 300 -J -F -M test -L t=
est -<br>
&gt; /mnt/xfsdump | gzip -qv &gt; /mnt/xfsrestore/xfsdump.gz<br>
</span>....<br>
<span>&gt; xfsdump: media file size 575648352 bytes<br>
&gt; xfsdump: dump size (non-dir files) : 560258760 bytes<br>
<br>
</span>These are a handful of bytes different.<br>
<span><br>
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
<span><br>
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
<span>xfsrestore: directory post-processing<br>
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
<div><div><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br></div></div><span =
class=3D"HOEnZb"><font color=3D"#888888">-- <br><div><br>Tommy Wu</div>
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br><div class=3D"gmail_sig=
nature"><br>Tommy Wu</div>
</div>

--001a113cd0a04e6a440506a18008--


--===============3772763090156488383==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3772763090156488383==--
