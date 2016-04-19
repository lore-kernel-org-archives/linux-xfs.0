Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C046A7CA0
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 08:25:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 923C78F8040
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 06:25:20 -0700 (PDT)
Received: from mail-ig0-f171.google.com (mail-ig0-f171.google.com
	[209.85.213.171]) by cuda.sgi.com with ESMTP id
	87jQaRnmAtRRlVu0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Apr 2016 06:25:15 -0700 (PDT)
Received: by mail-ig0-f171.google.com with SMTP id gy3so99163226igb.0
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 06:25:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160419113038.GA2649@laptop.bfoster>
References: <CAJBkf_egQ1WdYHm5iRXCt4=CgraN4A=HfLvvsZxJEi7g4sUf5A@mail.gmail.com>
	<20160419113038.GA2649@laptop.bfoster>
From: Hugo Kuo <hugo@swiftstack.com>
Date: Tue, 19 Apr 2016 21:24:55 +0800
Message-ID: <CAJBkf_dEDTE-2qCObaHPZgmu50nW3HP-DPFNAPyaMfuLJX+7NQ@mail.gmail.com>
Subject: Re: [XFS] Any process to a particular XFS device hung in D state
	forever.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6924148221279368166=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Darrell Bishop <darrell@swiftstack.com>, xfs@oss.sgi.com

--===============6924148221279368166==
Content-Type: multipart/alternative; boundary=001a1135fa684efb050530d668f5

--001a1135fa684efb050530d668f5
Content-Type: text/plain; charset=UTF-8

Hi Brain,

Here's the a gist include sysrq-trigger and strace of one of the hanging
$ls result. This is from another problematic disk (d817) on the same server.

https://gist.github.com/HugoKuo/8eb8208bbb7a7f562a6c9a3eafa8f37f

It looks like the hanging $ls is stuck on getting extend attribute of a
file on this disk. The full output can be found in the link above.

lstat("/srv/node/d864/tmp/tmpIRYFaW", {st_mode=S_IFREG|0600, st_size=0,
...}) = 0
capget(0x20080522, 0, NULL) = -1 EFAULT (Bad address)
getxattr("/srv/node/d864/tmp/tmpIRYFaW", "security.capability"


As for the xfs_repair output in link
https://gist.github.com/HugoKuo/76f65bdc0b860ca6ed5e786f8c43da0e . Your
question is if the node been force rebooted. The answer is NO.   I* didn't
reboot* this server yet. I force unmounted it via *$umount -l <dev>* . Then
run the xfs_repair.

$ls /srv/node/d864/tmp > test.d864
$ls /srv/node/d864/tmp


Here's the contents of test.d864
https://gist.github.com/HugoKuo/25f93cd6daf5b0666a2ab85defd63a56

Thanks // Hugo

On Tue, Apr 19, 2016 at 7:30 PM, Brian Foster <bfoster@redhat.com> wrote:

> On Tue, Apr 19, 2016 at 05:56:19PM +0800, Hugo Kuo wrote:
> > Hi XFS team,
> >
> > We encountered a problem frequently in past three weeks. Our daemons
> store
> > data to XFS partition associate with xattr.
> >
> > Disk seems not responding since all processes to this disk in D state and
> > can't be killed at all.
> >
> >    - It happens on several disks. I feel it's randomly.
> >    - Reboot seems solve the problem temporarily.
> >    - All disks are multipath devices.
> >
> >
> > I suspected that's an issue from disk corrupted at beginning. But
> smartctl
> > doesn't show any clue about disk bad. And reboot makes the problem gone
> > away.
> >
> >
> >    - Any process to this disk is blocked. Even a simple $ls . Kernel log
> >    <https://gist.github.com/HugoKuo/f87748786b26ea04fd9e1d86d9538293>
>
> Looks like it's waiting on an AGF buffer. The buffer could be held by
> something else, but we don't have enough information from that one
> trace. Could you get all of the blocked tasks when in this state (e.g.,
> "echo w > /proc/sysrq-trigger")?
>




>
> >    - I tested the disk by read bytes on block via $dd . It works fine
> >    without any error in dmesg.
> >    - The `xfs_repair -n` output of a problematic mount point [xfs_repair
> -n]
> >    <https://gist.github.com/HugoKuo/76f65bdc0b860ca6ed5e786f8c43da0e> .
> It
> >    is still processing.
>
> I presume this was run after a forced reboot..? If so, was the
> filesystem remounted first to replay the log (xfs_repair -n doesn't
> detect/warn about a dirty log, iirc). If the log was dirty, then repair
> is a bit less interesting simply because some corruption is to be
> expected in that scenario.
>
> >    - Kernel : Linux node9 2.6.32-573.8.1.el6.x86_64 #1 SMP Tue Nov 10
> >    18:01:38 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> >    - OS : CentOS release 6.5 (Final)
> >    - XFS : xfsprogs.x86_64         3.1.1-14.el6
> >
> >
> > There's an interesting behaviour of $ls command.
> >
> > * This is completed in 1sec. Very quick and give me the result in the
> > test.d864 file $ls /srv/node/d864/tmp > test.d864
> > * This is hanging $ls /srv/node/d864/tmp
> >
>
> I'm not following you here. Are you missing an attachment (test.d864)?
>
> Brian
>
> > [image: Inline image 1]
> >
> > I suspect there's something wrong with imap. Is there a known bug ?
> >
> > Thanks // Hugo
>
>
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--001a1135fa684efb050530d668f5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Brain,=C2=A0<div><br></div><div>Here&#39;s the a gist i=
nclude sysrq-trigger and strace of one of the hanging $ls result. This is f=
rom another problematic disk (d817) on the same server.</div><div><br></div=
><blockquote style=3D"margin:0px 0px 0px 40px;border:none;padding:0px"><div=
><a href=3D"https://gist.github.com/HugoKuo/8eb8208bbb7a7f562a6c9a3eafa8f37=
f">https://gist.github.com/HugoKuo/8eb8208bbb7a7f562a6c9a3eafa8f37f</a></di=
v><div><br></div></blockquote><div>It looks like the hanging $ls is stuck o=
n getting extend attribute of a file on this disk. The full output can be f=
ound in the link above.=C2=A0</div><div><br></div><div><table class=3D"" st=
yle=3D"border-collapse:collapse;border-spacing:0px;color:rgb(51,51,51);font=
-family:Helvetica,arial,nimbussansl,liberationsans,freesans,clean,sans-seri=
f,&#39;Apple Color Emoji&#39;,&#39;Segoe UI Emoji&#39;,&#39;Segoe UI Symbol=
&#39;;font-size:13px;line-height:18.2px"><tbody style=3D""><tr style=3D""><=
td id=3D"file-hanging-L143" class=3D"" style=3D"padding:0px 10px;width:50px=
;min-width:50px;font-family:Consolas,&#39;Liberation Mono&#39;,Menlo,Courie=
r,monospace;font-size:12px;line-height:18px;color:rgba(0,0,0,0.298039);text=
-align:right;white-space:nowrap;vertical-align:top;border-style:solid;borde=
r-color:rgb(238,238,238);border-width:0px 1px 0px 0px"></td><td id=3D"file-=
hanging-LC143" class=3D"" style=3D"padding:0px 10px;vertical-align:top;over=
flow:visible;font-family:Consolas,&#39;Liberation Mono&#39;,Menlo,Courier,m=
onospace;font-size:12px;word-wrap:normal;white-space:pre">lstat(&quot;/srv/=
node/d864/tmp/tmpIRYFaW&quot;, {st_mode=3DS_IFREG|0600, st_size=3D0, ...}) =
=3D 0</td></tr><tr style=3D""><td id=3D"file-hanging-L144" class=3D"" style=
=3D"padding:0px 10px;width:50px;min-width:50px;font-family:Consolas,&#39;Li=
beration Mono&#39;,Menlo,Courier,monospace;font-size:12px;line-height:18px;=
color:rgba(0,0,0,0.298039);text-align:right;white-space:nowrap;vertical-ali=
gn:top;border-style:solid;border-color:rgb(238,238,238);border-width:0px 1p=
x 0px 0px"></td><td id=3D"file-hanging-LC144" class=3D"" style=3D"padding:0=
px 10px;vertical-align:top;overflow:visible;font-family:Consolas,&#39;Liber=
ation Mono&#39;,Menlo,Courier,monospace;font-size:12px;word-wrap:normal;whi=
te-space:pre">capget(0x20080522, 0, NULL)             =3D -1 EFAULT (Bad ad=
dress)</td></tr><tr style=3D""><td id=3D"file-hanging-L145" class=3D"" styl=
e=3D"padding:0px 10px;width:50px;min-width:50px;font-family:Consolas,&#39;L=
iberation Mono&#39;,Menlo,Courier,monospace;font-size:12px;line-height:18px=
;color:rgba(0,0,0,0.298039);text-align:right;white-space:nowrap;vertical-al=
ign:top;border-style:solid;border-color:rgb(238,238,238);border-width:0px 1=
px 0px 0px"></td><td id=3D"file-hanging-LC145" class=3D"" style=3D"padding:=
0px 10px;vertical-align:top;overflow:visible;font-family:Consolas,&#39;Libe=
ration Mono&#39;,Menlo,Courier,monospace;font-size:12px;word-wrap:normal;wh=
ite-space:pre">getxattr(&quot;/srv/node/d864/tmp/tmpIRYFaW&quot;, &quot;sec=
urity.capability&quot;</td></tr></tbody></table></div><div><br></div><div><=
br></div><div>As for the xfs_repair output in link=C2=A0<a href=3D"https://=
gist.github.com/HugoKuo/76f65bdc0b860ca6ed5e786f8c43da0e" rel=3D"noreferrer=
" target=3D"_blank">https://gist.github.com/HugoKuo/76f65bdc0b860ca6ed5e786=
f8c43da0e</a>=C2=A0. Your question is if the node been force rebooted. The =
answer is NO. =C2=A0 I<b> didn&#39;t reboot</b> this server yet. I force un=
mounted it via <i>$umount -l &lt;dev&gt;</i>=C2=A0. Then run the xfs_repair=
.=C2=A0</div><div><br></div><blockquote style=3D"margin:0px 0px 0px 40px;bo=
rder:none;padding:0px"><div><font color=3D"#000000">$ls /srv/node/d864/tmp =
&gt; test.d864</font></div><div><font color=3D"#000000">$ls /srv/node/d864/=
tmp</font></div></blockquote><div><div class=3D"gmail_extra"><br></div><div=
 class=3D"gmail_extra">Here&#39;s the contents of test.d864=C2=A0<a href=3D=
"https://gist.github.com/HugoKuo/25f93cd6daf5b0666a2ab85defd63a56">https://=
gist.github.com/HugoKuo/25f93cd6daf5b0666a2ab85defd63a56</a></div><div clas=
s=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Thanks // Hugo</div>=
<div class=3D"gmail_extra"><br><div class=3D"gmail_quote"><font color=3D"#c=
ccccc">On Tue, Apr 19, 2016 at 7:30 PM, Brian Foster <span dir=3D"ltr">&lt;=
<a href=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com<=
/a>&gt;</span> wrote:<br></font><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;bord=
er-left-color:rgb(204,204,204);padding-left:1ex"><font color=3D"#cccccc"><s=
pan class=3D"">On Tue, Apr 19, 2016 at 05:56:19PM +0800, Hugo Kuo wrote:<br=
>
&gt; Hi XFS team,<br>
&gt;<br>
&gt; We encountered a problem frequently in past three weeks. Our daemons s=
tore<br>
&gt; data to XFS partition associate with xattr.<br>
&gt;<br>
&gt; Disk seems not responding since all processes to this disk in D state =
and<br>
&gt; can&#39;t be killed at all.<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 - It happens on several disks. I feel it&#39;s ran=
domly.<br>
&gt;=C2=A0 =C2=A0 - Reboot seems solve the problem temporarily.<br>
&gt;=C2=A0 =C2=A0 - All disks are multipath devices.<br>
<span class=3D"">&gt;<br>
&gt;<br>
&gt; I suspected that&#39;s an issue from disk corrupted at beginning. But =
smartctl<br>
&gt; doesn&#39;t show any clue about disk bad. And reboot makes the problem=
 gone<br>
&gt; away.<br>
&gt;<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 - Any process to this disk is blocked. Even a simp=
le $ls . Kernel log<br>
&gt;=C2=A0 =C2=A0 &lt;<a href=3D"https://gist.github.com/HugoKuo/f87748786b=
26ea04fd9e1d86d9538293" rel=3D"noreferrer" target=3D"_blank">https://gist.g=
ithub.com/HugoKuo/f87748786b26ea04fd9e1d86d9538293</a>&gt;<br>
<br>
Looks like it&#39;s waiting on an AGF buffer. The buffer could be held by<b=
r>
something else, but we don&#39;t have enough information from that one<br>
trace. Could you get all of the blocked tasks when in this state (e.g.,<br>
&quot;echo w &gt; /proc/sysrq-trigger&quot;)?<br></font></blockquote><div><=
font color=3D"#cccccc"><br></font></div><div><font color=3D"#cccccc"><br></=
font></div><div><font color=3D"#cccccc">=C2=A0</font></div><blockquote clas=
s=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;b=
order-left-style:solid;border-left-color:rgb(204,204,204);padding-left:1ex"=
>
<font color=3D"#cccccc"><br>
&gt;=C2=A0 =C2=A0 - I tested the disk by read bytes on block via $dd . It w=
orks fine<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 without any error in dmesg.<br>
</span>&gt;=C2=A0 =C2=A0 - The `xfs_repair -n` output of a problematic moun=
t point [xfs_repair -n]<br>
&gt;=C2=A0 =C2=A0 &lt;<a href=3D"https://gist.github.com/HugoKuo/76f65bdc0b=
860ca6ed5e786f8c43da0e" rel=3D"noreferrer" target=3D"_blank">https://gist.g=
ithub.com/HugoKuo/76f65bdc0b860ca6ed5e786f8c43da0e</a>&gt; . It<br>
&gt;=C2=A0 =C2=A0 is still processing.<br>
<br>
I presume this was run after a forced reboot..? If so, was the<br>
filesystem remounted first to replay the log (xfs_repair -n doesn&#39;t<br>
detect/warn about a dirty log, iirc). If the log was dirty, then repair<br>
is a bit less interesting simply because some corruption is to be<br>
expected in that scenario.<br>
<br>
&gt;=C2=A0 =C2=A0 - Kernel : Linux node9 2.6.32-573.8.1.el6.x86_64 #1 SMP T=
ue Nov 10<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 18:01:38 UTC 2015 x86_64 x86_64 x86_64 G=
NU/Linux<br>
</span>&gt;=C2=A0 =C2=A0 - OS : CentOS release 6.5 (Final)<br>
&gt;=C2=A0 =C2=A0 - XFS : xfsprogs.x86_64=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
3.1.1-14.el6<br>
<span class=3D"">&gt;<br>
&gt;<br>
&gt; There&#39;s an interesting behaviour of $ls command.<br>
&gt;<br>
&gt; * This is completed in 1sec. Very quick and give me the result in the<=
br>
&gt; test.d864 file $ls /srv/node/d864/tmp &gt; test.d864<br>
&gt; * This is hanging $ls /srv/node/d864/tmp<br>
&gt;<br>
<br>
</span>I&#39;m not following you here. Are you missing an attachment (test.=
d864)?<br>
<br>
Brian<br>
<span class=3D""><br>
&gt; [image: Inline image 1]<br>
&gt;<br>
&gt; I suspect there&#39;s something wrong with imap. Is there a known bug =
?<br>
&gt;<br>
&gt; Thanks // Hugo<br>
<br>
<br>
<br>
</span>&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer"=
 target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</font></blockquote></div><br></div></div></div>

--001a1135fa684efb050530d668f5--


--===============6924148221279368166==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6924148221279368166==--
