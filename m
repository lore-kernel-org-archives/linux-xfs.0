Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p51BmHpl117635 for <xfs@oss.sgi.com>; Wed, 1 Jun 2011 06:48:18 -0500
Received: from mail-iw0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFA181ED0B92
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2011 04:48:16 -0700 (PDT)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	UOSpeZ05OKWuAhx9 for <xfs@oss.sgi.com>;
	Wed, 01 Jun 2011 04:48:16 -0700 (PDT)
Received: by iwn38 with SMTP id 38so4987454iwn.26
	for <xfs@oss.sgi.com>; Wed, 01 Jun 2011 04:48:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimoRUrY7xVnamBT=yFPzafhADA=tA@mail.gmail.com>
References: <BANLkTimBnAgiXZnvS56eAzEdJ=kw1zVGsg@mail.gmail.com>
	<4DE5C1FE.8080006@redhat.com>
	<BANLkTikfjitncM=zLpfTrfQkd8VfQAxbUA@mail.gmail.com>
	<4DE5CC8E.1090208@redhat.com> <4DE5CF6C.4080707@redhat.com>
	<BANLkTimoRUrY7xVnamBT=yFPzafhADA=tA@mail.gmail.com>
Date: Wed, 1 Jun 2011 07:48:16 -0400
Message-ID: <BANLkTikQ=V8MJyuAQsZboCorZwnBSzX=Bg@mail.gmail.com>
Subject: Re: [PATCH] xfstests: add support for ext4dev FSTYP
From: sergey ivanov <sergey57@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2854684317638907324=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, XFS <xfs@oss.sgi.com>

--===============2854684317638907324==
Content-Type: multipart/alternative; boundary=90e6ba6e822a99cba104a4a51871

--90e6ba6e822a99cba104a4a51871
Content-Type: text/plain; charset=UTF-8

On Wed, Jun 1, 2011 at 2:37 AM, Amir Goldstein <amir73il@gmail.com> wrote:

> On Wed, Jun 1, 2011 at 8:34 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> > On 6/1/11 12:22 AM, Eric Sandeen wrote:
> >> On 5/31/11 11:56 PM, Amir Goldstein wrote:
> >>> On Wed, Jun 1, 2011 at 7:37 AM, Eric Sandeen <sandeen@redhat.com>
> wrote:
> >>>> On 5/31/11 10:13 PM, Amir Goldstein wrote:
> >>>>> From: Amir Goldstein <amir73il@users.sf.net>
> >>>>>
> >>>>> blkid knows to identify the ext4dev FSTYP of a partition that was
> >>>>> formatted with mkfs.ext4dev.
> >>>>> quota tools and various util-linux utils are also aware of ext4dev,
> >>>>> so ext4dev shares the same capabilities as ext4.
> >>>>>
> >>>>> While testing on Fedora 15, we encoutered a buggy fsck utility, which
> >>>>> invokes fsck.ext4, even though it was called with -t ext4dev
> argument.
> >>>>> In our setup fsck.ext4dev knows about new fs features that fsck.ext4
> >>>>> doesn't know, so the generic_fs_check fails.
> >>>>> Since we have no real use of the extra capabilities provided by fsck
> util,
> >>>>> we decided to invoke fsck.$FSTYP directly to avoid this issue.
> >>>>
> >>>> Adding ext4dev to every case seems harmless enough.  TBH I thought I
> had
> >>>> it there already but I guess not.
> >>>>
> >>>> I'm less certain of the change from fsck -t $FSTYP to fsck.$FSTYP
> >>>>
> >>>> What issue are you avoiding?  wouldn't fsck -t ext4dev invoke
> fsck.ext4dev anyway?
> >>>>
> >>>> It seems like it should be harmless, but I don't understand how it
> helps you.
> >>>>
> >>>
> >>> As I wrote in the patch description, the fsck utility in Fedora 15
> invokes
> >>> fsck.ext4 for some reason when calling fsck -t ext4dev.
> >>
> >> Oh, right.
> >>
> >>> this fails because fsck.ext4 doesn't know the snapshot feature.
> >>> I didn't debug fsck utility for that. it seemed pointless.
> >>
> >> Did you file a bug with Fedora?  I'd rather fix the root cause than work
> around it...
> >> Feel free to cc: me on the bug.
>
> No, I didn't file a bug.
> In any case, it was Sergey, who tested and reported the problem on F15.
>
> Would you agree to fix the problem in xfstests now, so that F15 users can
> test ext4dev and fix the bug in fsck regardless?
>
> >
> > RHEL6 does the same; mkfs.ext4dev then fsck -t ext4dev invokes fsck.ext4;
> but this
> > is because blkid identifies it as ext4, not ext4dev, despite the test_fs
> flag being set.
> >
> > ISTR this is due to some tortured logic about when ext4dev isn't ext4dev,
> but
> > I don't remember the details... I don't know if this is the same
> situation
> > you're seeing; just to double check - does blkid correctly identify it as
> ext4dev
> > on F15?
>
>
> For me (on Ubuntu) blkid identifies ext4dev, but maybe the tortured logic
> finds unknown features a justification for declaring ext4dev?
> Segrey, can you answer the question for F15?
> Did you set FSTYP to ext4dev manually or did blkid identified it for you?
>

Amir, Fedora's fsck behaves differently on ext4dev and next4. When I made
next4 partition on Fedora-15 by
{{{
mkfs  -t next4 /dev/sdd9
}}}
it requires "export FSTYP=next4" to be defined and exported in local.conf.
It mounts partition with
{{{
mount -t next4 /dev/sdd9 /mnt/sdd9
}}}
But on attempt to fsck it calls wrong fsck, as you reported:
{{{
[seriv@pimbra xfstests]$ sudo fsck -t next4 /dev/sdd9
fsck from util-linux 2.19.1
e2fsck 1.41.14 (22-Dec-2010)
/dev/sdd9 has unsupported feature(s): FEATURE_C7 FEATURE_C8 FEATURE_R7
e2fsck: Get a newer version of e2fsck!
}}}

And the problem can be easily traced to this wrong call:
{{{
[seriv@pimbra xfstests]$ sudo strace -o /var/log/fsck.strace fsck -t next4
/dev/sdd9
fsck from util-linux 2.19.1
e2fsck 1.41.14 (22-Dec-2010)
/dev/sdd9 has unsupported feature(s): FEATURE_C7 FEATURE_C8 FEATURE_R7
e2fsck: Get a newer version of e2fsck!
[seriv@pimbra xfstests]$ grep sbin /var/log/fsck.strace
execve("/sbin/fsck", ["fsck", "-t", "next4", "/dev/sdd9"], [/* 17 vars */])
= 0
stat("/sbin/fsck.ext4", {st_mode=S_IFREG|0755, st_size=194280, ...}) = 0
}}}

But it's not the case for ext4dev, with it I even don't need "-t ext4dev",
it is recognized by blkid:
{{{
[seriv@pimbra xfstests]$ sudo mkfs -t ext4dev /dev/sdd9
mke2fs 1.41.14-next3-1.0.13-7 (24-May-2011)
[skip]
This filesystem will be automatically checked every 27 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
[seriv@pimbra xfstests]$ sudo mount /dev/sdd9 /mnt/sdd9
[seriv@pimbra xfstests]$ mount | grep sdd9
/dev/sdd9 on /mnt/sdd9 type ext4dev (rw)
[seriv@pimbra xfstests]$ sudo umount /dev/sdd9
[seriv@pimbra xfstests]$ sudo fsck /dev/sdd9
fsck from util-linux 2.19.1
e2fsck 1.41.14-next3-1.0.13-7 (24-May-2011)
The test_fs flag is set (and ext4 is available).  Clear<y>?
}}}
and at this point in another session
{{{
[seriv@pimbra xfstests]$ pgrep -f -l fsck
4365 sudo fsck /dev/sdd9
4366 fsck /dev/sdd9
4367 fsck.ext4dev /dev/sdd9
}}}

So I'd like this patch to be applied to xfstests to be able to use it on the
different filesystems, - if not, then why have this FSTYP and not rely upon
blkid
-- 
  Regards,
   Sergey Ivanov.

--90e6ba6e822a99cba104a4a51871
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 1, 2011 at 2:37 AM, Amir Goldstein <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:amir73il@gmail.com">amir73il@gmail.com</a>&gt;</span> wrote:<br=
><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"marg=
in:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<div><div></div><div class=3D"h5">On Wed, Jun 1, 2011 at 8:34 AM, Eric Sand=
een &lt;<a href=3D"mailto:sandeen@redhat.com">sandeen@redhat.com</a>&gt; wr=
ote:<br>
&gt; On 6/1/11 12:22 AM, Eric Sandeen wrote:<br>
&gt;&gt; On 5/31/11 11:56 PM, Amir Goldstein wrote:<br>
&gt;&gt;&gt; On Wed, Jun 1, 2011 at 7:37 AM, Eric Sandeen &lt;<a href=3D"ma=
ilto:sandeen@redhat.com">sandeen@redhat.com</a>&gt; wrote:<br>
&gt;&gt;&gt;&gt; On 5/31/11 10:13 PM, Amir Goldstein wrote:<br>
&gt;&gt;&gt;&gt;&gt; From: Amir Goldstein &lt;<a href=3D"mailto:amir73il@us=
ers.sf.net">amir73il@users.sf.net</a>&gt;<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; blkid knows to identify the ext4dev FSTYP of a partiti=
on that was<br>
&gt;&gt;&gt;&gt;&gt; formatted with mkfs.ext4dev.<br>
&gt;&gt;&gt;&gt;&gt; quota tools and various util-linux utils are also awar=
e of ext4dev,<br>
&gt;&gt;&gt;&gt;&gt; so ext4dev shares the same capabilities as ext4.<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; While testing on Fedora 15, we encoutered a buggy fsck=
 utility, which<br>
&gt;&gt;&gt;&gt;&gt; invokes fsck.ext4, even though it was called with -t e=
xt4dev argument.<br>
&gt;&gt;&gt;&gt;&gt; In our setup fsck.ext4dev knows about new fs features =
that fsck.ext4<br>
&gt;&gt;&gt;&gt;&gt; doesn&#39;t know, so the generic_fs_check fails.<br>
&gt;&gt;&gt;&gt;&gt; Since we have no real use of the extra capabilities pr=
ovided by fsck util,<br>
&gt;&gt;&gt;&gt;&gt; we decided to invoke fsck.$FSTYP directly to avoid thi=
s issue.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Adding ext4dev to every case seems harmless enough. =C2=A0=
TBH I thought I had<br>
&gt;&gt;&gt;&gt; it there already but I guess not.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; I&#39;m less certain of the change from fsck -t $FSTYP to =
fsck.$FSTYP<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; What issue are you avoiding? =C2=A0wouldn&#39;t fsck -t ex=
t4dev invoke fsck.ext4dev anyway?<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; It seems like it should be harmless, but I don&#39;t under=
stand how it helps you.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; As I wrote in the patch description, the fsck utility in Fedor=
a 15 invokes<br>
&gt;&gt;&gt; fsck.ext4 for some reason when calling fsck -t ext4dev.<br>
&gt;&gt;<br>
&gt;&gt; Oh, right.<br>
&gt;&gt;<br>
&gt;&gt;&gt; this fails because fsck.ext4 doesn&#39;t know the snapshot fea=
ture.<br>
&gt;&gt;&gt; I didn&#39;t debug fsck utility for that. it seemed pointless.=
<br>
&gt;&gt;<br>
&gt;&gt; Did you file a bug with Fedora? =C2=A0I&#39;d rather fix the root =
cause than work around it...<br>
&gt;&gt; Feel free to cc: me on the bug.<br>
<br>
</div></div>No, I didn&#39;t file a bug.<br>
In any case, it was Sergey, who tested and reported the problem on F15.<br>
<br>
Would you agree to fix the problem in xfstests now, so that F15 users can<b=
r>
test ext4dev and fix the bug in fsck regardless?<br>
<div class=3D"im"><br>
&gt;<br>
&gt; RHEL6 does the same; mkfs.ext4dev then fsck -t ext4dev invokes fsck.ex=
t4; but this<br>
&gt; is because blkid identifies it as ext4, not ext4dev, despite the test_=
fs flag being set.<br>
&gt;<br>
&gt; ISTR this is due to some tortured logic about when ext4dev isn&#39;t e=
xt4dev, but<br>
&gt; I don&#39;t remember the details... I don&#39;t know if this is the sa=
me situation<br>
&gt; you&#39;re seeing; just to double check - does blkid correctly identif=
y it as ext4dev<br>
&gt; on F15?<br>
<br>
<br>
</div>For me (on Ubuntu) blkid identifies ext4dev, but maybe the tortured l=
ogic<br>
finds unknown features a justification for declaring ext4dev?<br>
Segrey, can you answer the question for F15?<br>
Did you set FSTYP to ext4dev manually or did blkid identified it for you?<b=
r></blockquote><div><br></div><div>Amir, Fedora&#39;s fsck behaves differen=
tly on ext4dev and next4. When I made next4 partition on Fedora-15 by=C2=A0=
</div>
<div>{{{</div><div>mkfs =C2=A0-t next4 /dev/sdd9</div><div>}}}</div><div>it=
 requires &quot;export FSTYP=3Dnext4&quot; to be defined and exported in lo=
cal.conf. It mounts partition with</div><div>{{{</div><div>mount -t next4 /=
dev/sdd9 /mnt/sdd9</div>
<div>}}}</div><div>But on attempt to fsck it calls wrong fsck, as you repor=
ted:</div><div>{{{</div><div><div>[seriv@pimbra xfstests]$ sudo fsck -t nex=
t4 /dev/sdd9</div><div>fsck from util-linux 2.19.1</div><div>e2fsck 1.41.14=
 (22-Dec-2010)</div>
<div>/dev/sdd9 has unsupported feature(s): FEATURE_C7 FEATURE_C8 FEATURE_R7=
</div><div>e2fsck: Get a newer version of e2fsck!</div></div><div>}}}</div>=
<div><br></div><div>And the problem can be easily traced to this wrong call=
:</div>
<div>{{{</div><div><div>[seriv@pimbra xfstests]$ sudo strace -o /var/log/fs=
ck.strace fsck -t next4 /dev/sdd9 =C2=A0</div><div>fsck from util-linux 2.1=
9.1</div><div>e2fsck 1.41.14 (22-Dec-2010)</div><div>/dev/sdd9 has unsuppor=
ted feature(s): FEATURE_C7 FEATURE_C8 FEATURE_R7</div>
<div>e2fsck: Get a newer version of e2fsck!</div><div>[seriv@pimbra xfstest=
s]$ grep sbin /var/log/fsck.strace=C2=A0</div><div>execve(&quot;/sbin/fsck&=
quot;, [&quot;fsck&quot;, &quot;-t&quot;, &quot;next4&quot;, &quot;/dev/sdd=
9&quot;], [/* 17 vars */]) =3D 0</div>
<div>stat(&quot;/sbin/fsck.ext4&quot;, {st_mode=3DS_IFREG|0755, st_size=3D1=
94280, ...}) =3D 0</div></div><div>}}}</div><div><br></div><div>But it&#39;=
s not the case for ext4dev, with it I even don&#39;t need &quot;-t ext4dev&=
quot;, it is recognized by blkid:</div>
<div>{{{</div><div><div>[seriv@pimbra xfstests]$ sudo mkfs -t ext4dev /dev/=
sdd9</div><div>mke2fs 1.41.14-next3-1.0.13-7 (24-May-2011)</div><div>[skip]=
</div><div>This filesystem will be automatically checked every 27 mounts or=
</div>
<div>180 days, whichever comes first. =C2=A0Use tune2fs -c or -i to overrid=
e.</div><div>[seriv@pimbra xfstests]$ sudo mount /dev/sdd9 /mnt/sdd9</div><=
div>[seriv@pimbra xfstests]$ mount | grep sdd9</div><div>/dev/sdd9 on /mnt/=
sdd9 type ext4dev (rw)</div>
<div>[seriv@pimbra xfstests]$ sudo umount /dev/sdd9</div><div>[seriv@pimbra=
 xfstests]$ sudo fsck /dev/sdd9</div><div>fsck from util-linux 2.19.1</div>=
<div>e2fsck 1.41.14-next3-1.0.13-7 (24-May-2011)</div><div>The test_fs flag=
 is set (and ext4 is available). =C2=A0Clear&lt;y&gt;?=C2=A0</div>
</div><div>}}}</div><div>and at this point in another session</div><div>{{{=
</div><div><div>[seriv@pimbra xfstests]$ pgrep -f -l fsck</div><div>4365 su=
do fsck /dev/sdd9</div><div>4366 fsck /dev/sdd9</div><div>4367 fsck.ext4dev=
 /dev/sdd9</div>
</div><div>}}}</div><div><br></div><div>So I&#39;d like this patch to be ap=
plied to xfstests to be able to use it on the different filesystems, - if n=
ot, then why have this FSTYP and not rely upon blkid</div><div>--=C2=A0</di=
v>
<div>=C2=A0 Regards,</div><div>=C2=A0 =C2=A0Sergey Ivanov.</div></div><br>

--90e6ba6e822a99cba104a4a51871--


--===============2854684317638907324==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2854684317638907324==--
