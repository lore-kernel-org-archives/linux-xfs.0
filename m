Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 45EEB7F37
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2015 01:43:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7BF0AC004
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 23:43:09 -0700 (PDT)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com
	[209.85.223.182]) by cuda.sgi.com with ESMTP id
	MebdvaJwOGrO2EoH (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 23 Aug 2015 23:43:07 -0700 (PDT)
Received: by iodt126 with SMTP id t126so138458895iod.2
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 23:43:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150821112118.GB46372@bfoster.bfoster>
References: <CANX=BtYB4yoGwxz72sUN+6aSVL0fQ1JnS3PEw0zRqTbtO4_KDg@mail.gmail.com>
	<20150821112118.GB46372@bfoster.bfoster>
Date: Mon, 24 Aug 2015 14:43:07 +0800
Message-ID: <CANX=BtY-Q0w5q4WZx869u0q=up+yE9f6u-gJ_O28L9TYzze_Dw@mail.gmail.com>
Subject: Re: xfs directory quota doesn't work
From: Simon Xia <simonxiaomg@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2480416075001409188=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

--===============2480416075001409188==
Content-Type: multipart/alternative; boundary=001a1140a9c21dc137051e08eeca

--001a1140a9c21dc137051e08eeca
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I do create two subdirectory for project

and the error maybe caused by this step:
xfs_quota -x -c 'project =E2=80=93c task1' /home/xiameng.xm/xfs_dir

=E2=80=93c - no such project in /etc/projects
Checking project task1 (path /home/xiameng.xm/xfs_dir/task1)...
/home/xiameng.xm/xfs_dir/task1 - project identifier is not set (inode=3D0,
tree=3D11)
/home/xiameng.xm/xfs_dir/task1 - project inheritance flag is not set
Processed 1 /etc/projects paths for project task1

I'm a little confused about the output message, cause everything is ok in
config file

2015-08-21 19:21 GMT+08:00 Brian Foster <bfoster@redhat.com>:

> On Fri, Aug 21, 2015 at 05:05:00PM +0800, Simon Xia wrote:
> > hi, everyone, I encounter a problem when using xfs
> >
> > now I have two tasks and I wanna run them in different directory and
> limit
> > the directory=E2=80=99s size. I use xfs=E2=80=99s project quota to achi=
eve this.
> >
> > I follow the steps from here:
> > https://solidlinux.wordpress.com/2012/12/09/xfs-quota-managament/
> >
> > here is detail of my two config files
> >
> > /etc/projects:
> >
> > 11:/home/xiameng.xm/xfs_dir/task1
> > 12:/home/xiameng.xm/xfs_dir/task2
> >
> > /etc/projid:
> >
> > task1:11
> > task2:12
> >
> > and here is my step:
> >
> > touch test_xfs
> > dd if=3D/dev/zero of=3Dtest_xfs bs=3D1000000 count=3D1
> > mkfs.xfs test_xfs
> >
>
> That looks small, I can't even mkfs a file that small. I ran through
> this using 'bs=3D1M count=3D100.'
>
> > mkdir xfs_dir
> > mount test_xfs ./xfs_dir -o pquota,loop
> >
> > xfs_quota -xc 'project =E2=80=93s task1' /home/xiameng.xm/xfs_dir
> > xfs_quota -xc 'project =E2=80=93s task2' /home/xiameng.xm/xfs_dir
> >
>
> I don't see where you've created the directories yet..? I get the
> following:
>
> # xfs_quota -xc 'project -s task1' /mnt/
> xfs_quota: cannot find mount point for path `/mnt/task1': No such file or
> directory
>
> ... until I create the task1/task2 directories. This is required because
> the project quota command has to set the project id on the directory
> inode. It won't work if the directory is created after this point,
> regardless of whether the quota limit is specified.
>
> Once I create those directories and run the project command, everything
> seems to work. I can write up to 2MB to task1 and 10MB to task2.
>
> Brian
>
> > xfs_quota -x -c 'limit -p bhard=3D2m task1' /home/xiameng.xm/xfs_dir
> > xfs_quota -x -c 'limit -p bhard=3D10m task2' /home/xiameng.xm/xfs_dir
> >
> > here is the output of xfs_quota -x -c 'report /home/xiameng.xm/xfs_dir'
> >
> > Project quota on /home/xiameng.xm/xfs_dir (/dev/loop1)
> >                                Blocks
> > Project ID       Used       Soft       Hard    Warn/Grace
> > ---------- --------------------------------------------------
> > task1               0          0       2048     00 [--------]
> > task2               0          0      10240     00 [--------]
> >
> > the question is no mater how large I create a file in ./xfs_dir/task1 o=
r
> > ./xfs_dir/task2, it success!
> >
> > the quota limit doesn=E2=80=99t work!
> >
> > Any help will be appreciated :)
> >
> >
> > ps: I also post my question here:
> >
> http://unix.stackexchange.com/questions/224606/xfs-directory-quota-doesnt=
-work
> >
> > ----
> >
> > Best Regards
> > Simon Xia
> > =E2=80=8B
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>


--=20
Best Regards

Simon Xia

--001a1140a9c21dc137051e08eeca
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I do create two subdirectory for project<div><br></div><di=
v>and the error maybe caused by this step:</div><div><div>xfs_quota -x -c &=
#39;project =E2=80=93c task1&#39; /home/xiameng.xm/xfs_dir</div><div><br></=
div><div>=E2=80=93c - no such project in /etc/projects</div><div>Checking p=
roject task1 (path /home/xiameng.xm/xfs_dir/task1)...</div><div>/home/xiame=
ng.xm/xfs_dir/task1 - project identifier is not set (inode=3D0, tree=3D11)<=
/div><div>/home/xiameng.xm/xfs_dir/task1 - project inheritance flag is not =
set</div><div>Processed 1 /etc/projects paths for project task1</div></div>=
<div><br></div><div>I&#39;m a little confused about the output message, cau=
se everything is ok in config file</div><div class=3D"gmail_extra"><br><div=
 class=3D"gmail_quote">2015-08-21 19:21 GMT+08:00 Brian Foster <span dir=3D=
"ltr">&lt;<a href=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@r=
edhat.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"=
">On Fri, Aug 21, 2015 at 05:05:00PM +0800, Simon Xia wrote:<br>
&gt; hi, everyone, I encounter a problem when using xfs<br>
&gt;<br>
&gt; now I have two tasks and I wanna run them in different directory and l=
imit<br>
&gt; the directory=E2=80=99s size. I use xfs=E2=80=99s project quota to ach=
ieve this.<br>
&gt;<br>
&gt; I follow the steps from here:<br>
&gt; <a href=3D"https://solidlinux.wordpress.com/2012/12/09/xfs-quota-manag=
ament/" rel=3D"noreferrer" target=3D"_blank">https://solidlinux.wordpress.c=
om/2012/12/09/xfs-quota-managament/</a><br>
&gt;<br>
&gt; here is detail of my two config files<br>
&gt;<br>
&gt; /etc/projects:<br>
&gt;<br>
&gt; 11:/home/xiameng.xm/xfs_dir/task1<br>
&gt; 12:/home/xiameng.xm/xfs_dir/task2<br>
&gt;<br>
&gt; /etc/projid:<br>
&gt;<br>
&gt; task1:11<br>
&gt; task2:12<br>
&gt;<br>
&gt; and here is my step:<br>
&gt;<br>
&gt; touch test_xfs<br>
&gt; dd if=3D/dev/zero of=3Dtest_xfs bs=3D1000000 count=3D1<br>
&gt; mkfs.xfs test_xfs<br>
&gt;<br>
<br>
</span>That looks small, I can&#39;t even mkfs a file that small. I ran thr=
ough<br>
this using &#39;bs=3D1M count=3D100.&#39;<br>
<span class=3D""><br>
&gt; mkdir xfs_dir<br>
&gt; mount test_xfs ./xfs_dir -o pquota,loop<br>
&gt;<br>
&gt; xfs_quota -xc &#39;project =E2=80=93s task1&#39; /home/xiameng.xm/xfs_=
dir<br>
&gt; xfs_quota -xc &#39;project =E2=80=93s task2&#39; /home/xiameng.xm/xfs_=
dir<br>
&gt;<br>
<br>
</span>I don&#39;t see where you&#39;ve created the directories yet..? I ge=
t the<br>
following:<br>
<br>
# xfs_quota -xc &#39;project -s task1&#39; /mnt/<br>
xfs_quota: cannot find mount point for path `/mnt/task1&#39;: No such file =
or directory<br>
<br>
... until I create the task1/task2 directories. This is required because<br=
>
the project quota command has to set the project id on the directory<br>
inode. It won&#39;t work if the directory is created after this point,<br>
regardless of whether the quota limit is specified.<br>
<br>
Once I create those directories and run the project command, everything<br>
seems to work. I can write up to 2MB to task1 and 10MB to task2.<br>
<br>
Brian<br>
<span class=3D""><br>
&gt; xfs_quota -x -c &#39;limit -p bhard=3D2m task1&#39; /home/xiameng.xm/x=
fs_dir<br>
&gt; xfs_quota -x -c &#39;limit -p bhard=3D10m task2&#39; /home/xiameng.xm/=
xfs_dir<br>
&gt;<br>
&gt; here is the output of xfs_quota -x -c &#39;report /home/xiameng.xm/xfs=
_dir&#39;<br>
&gt;<br>
&gt; Project quota on /home/xiameng.xm/xfs_dir (/dev/loop1)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Blocks<br>
&gt; Project ID=C2=A0 =C2=A0 =C2=A0 =C2=A0Used=C2=A0 =C2=A0 =C2=A0 =C2=A0So=
ft=C2=A0 =C2=A0 =C2=A0 =C2=A0Hard=C2=A0 =C2=A0 Warn/Grace<br>
&gt; ---------- --------------------------------------------------<br>
&gt; task1=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=A0 =C2=A02048=C2=A0 =C2=A0 =
=C2=A000 [--------]<br>
&gt; task2=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=A0 10240=C2=A0 =C2=A0 =C2=A0=
00 [--------]<br>
&gt;<br>
&gt; the question is no mater how large I create a file in ./xfs_dir/task1 =
or<br>
&gt; ./xfs_dir/task2, it success!<br>
&gt;<br>
&gt; the quota limit doesn=E2=80=99t work!<br>
&gt;<br>
&gt; Any help will be appreciated :)<br>
&gt;<br>
&gt;<br>
&gt; ps: I also post my question here:<br>
&gt; <a href=3D"http://unix.stackexchange.com/questions/224606/xfs-director=
y-quota-doesnt-work" rel=3D"noreferrer" target=3D"_blank">http://unix.stack=
exchange.com/questions/224606/xfs-directory-quota-doesnt-work</a><br>
&gt;<br>
&gt; ----<br>
&gt;<br>
&gt; Best Regards<br>
&gt; Simon Xia<br>
&gt; =E2=80=8B<br>
<br>
</span>&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer"=
 target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><div class=
=3D"gmail_signature"><div dir=3D"ltr">Best Regards<div><br></div><div>Simon=
 Xia</div></div></div>
</div></div>

--001a1140a9c21dc137051e08eeca--


--===============2480416075001409188==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2480416075001409188==--
