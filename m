Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 373EF7F6F
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 20:44:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 171848F8033
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 18:44:03 -0700 (PDT)
Received: from mail-qa0-f49.google.com (mail-qa0-f49.google.com
	[209.85.216.49]) by cuda.sgi.com with ESMTP id tkEDgWxebNuAiMNP
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 23 Oct 2014 18:44:00 -0700 (PDT)
Received: by mail-qa0-f49.google.com with SMTP id f12so322080qad.8
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 18:44:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGdb-8eq6HgYxiVei0j4bPZ4Um9NYJOkh42vZk=cibPX1s_k5A@mail.gmail.com>
References: <CAGdb-8dvNOdBfZ3K_g_o22vN30yBJN+pwr-0sORC+Aubv5=9Cg@mail.gmail.com>
	<543F3C9A.4060603@sandeen.net>
	<CAGdb-8fE+jh0dojaScF=3Oc4Ovea=Tvw1tnRxwb+iroaZd3i9g@mail.gmail.com>
	<F2B1FDA1-8352-4D67-9873-9C069AC66E94@sandeen.net>
	<CAGdb-8eq6HgYxiVei0j4bPZ4Um9NYJOkh42vZk=cibPX1s_k5A@mail.gmail.com>
Date: Fri, 24 Oct 2014 09:43:59 +0800
Message-ID: <CAGdb-8ckCCunYvi9mk1npLUx0SL-9Z1PNASKn_B2gO=R784GPg@mail.gmail.com>
Subject: Re: xfsdump not work in 3.17
From: Tommy Wu <wu.tommy@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5517540091009172022=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs <xfs@oss.sgi.com>

--===============5517540091009172022==
Content-Type: multipart/alternative; boundary=001a113a84d8a04163050621504e

--001a113a84d8a04163050621504e
Content-Type: text/plain; charset=UTF-8

I've some other issue here.

The xfsdump work, but xfsrestore can't restore the dump file correctly.
Got a lot of message like:
/sbin/xfsrestore: NOTE: ino 131 salvaging file, placing in
orphanage/7772637.4193481073/resource98761.ini
and
/sbin/xfsrestore: NOTE: ino 50858443 gen 697595483 not referenced: placing
in orphanage

Compare the file, some files are not restored.

2014-10-16 14:04 GMT+08:00 Tommy Wu <wu.tommy@gmail.com>:

> sorry, miss the 2nd one.
>
> after apply both of them, xfsdump work fine now.
>
> 2014-10-16 13:22 GMT+08:00 Eric Sandeen <sandeen@sandeen.net>:
>
>> On Oct 15, 2014, at 11:14 PM, Tommy Wu <wu.tommy@gmail.com> wrote:
>>
>> after apply above patch,
>>
>>
>> Which one?  I pointed at 2... Did you apply both?
>>
>> Eric
>>
>> the xfsdump will hang after this message:
>>
>> /sbin/xfsdump: dumping non-directory files
>>
>>
>> 2014-10-16 11:33 GMT+08:00 Eric Sandeen <sandeen@sandeen.net>:
>>
>>> On 10/15/14 9:31 PM, Tommy Wu wrote:
>>> > Hi!
>>> >
>>> >    xfsdump 3.1.4
>>> >    xfsprogs 3.2.1
>>> >    linux kerenl 3.17/3.17.1
>>> >
>>>
>>> ...
>>>
>>> >    It just create  a small dump file, and if I run the same xfsdump
>>> again (or umount the filesystem), it will hang, like:
>>> >
>>> > fw1:/vol/backup/fw1# /sbin/xfsdump -v trace,drive=debug,media=debug -l
>>> 0 -o -J -F - /dev/vg/root | gzip > test.gz
>>> > /sbin/xfsdump: using file dump (drive_simple) strategy
>>> > /sbin/xfsdump: version 3.1.4 (dump format 3.0)
>>> > /sbin/xfsdump: level 0 dump of fw1.teatime.com.tw:/
>>> > /sbin/xfsdump: dump date: Thu Oct 16 10:30:09 2014
>>> > /sbin/xfsdump: session id: b8354300-d54c-4131-b39c-7c0b63968208
>>> > /sbin/xfsdump: session label: ""
>>> > /sbin/xfsdump: ino map phase 1: constructing initial dump list
>>> >
>>> >
>>> >    switch back to kernel 3.16, the same command work fine.
>>> >
>>>
>>>
>>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/xfs?id=a8b1ee8bafc765ebf029d03c5479a69aebff9693
>>>
>>> addresses the small backup file, and
>>>
>>> [PATCH] xfs: bulkstat doesn't release AGI buffer on error
>>>
>>> (on the list) most likely addresses the hang, I think.
>>>
>>> -Eric
>>>
>>
>>
>>
>> --
>>
>> Tommy Wu
>>
>>
>
>
> --
>
> Tommy Wu
>



-- 

Tommy Wu

--001a113a84d8a04163050621504e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>I&#39;ve some other issue here.<br><br=
></div>The xfsdump work, but xfsrestore can&#39;t restore the dump file cor=
rectly.<br></div>Got a lot of message like:<br>/sbin/xfsrestore: NOTE: ino =
131 salvaging file, placing in orphanage/7772637.4193481073/resource98761.i=
ni<br></div>and <br>/sbin/xfsrestore: NOTE: ino 50858443 gen 697595483 not =
referenced: placing in orphanage<br><br></div>Compare the file, some files =
are not restored.<br></div><div class=3D"gmail_extra"><br><div class=3D"gma=
il_quote">2014-10-16 14:04 GMT+08:00 Tommy Wu <span dir=3D"ltr">&lt;<a href=
=3D"mailto:wu.tommy@gmail.com" target=3D"_blank">wu.tommy@gmail.com</a>&gt;=
</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div>sorry, mis=
s the 2nd one.<br><br></div>after apply both of them, xfsdump work fine now=
.<br></div><div class=3D"gmail_extra"><div><div class=3D"h5"><br><div class=
=3D"gmail_quote">2014-10-16 13:22 GMT+08:00 Eric Sandeen <span dir=3D"ltr">=
&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandee=
n.net</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"auto"><=
div>On Oct 15, 2014, at 11:14 PM, Tommy Wu &lt;<a href=3D"mailto:wu.tommy@g=
mail.com" target=3D"_blank">wu.tommy@gmail.com</a>&gt; wrote:</div><div><br=
></div><blockquote type=3D"cite"><div><div dir=3D"ltr">after apply above pa=
tch, </div></div></blockquote><div><br></div>Which one?=C2=A0 I pointed at =
2... Did you apply both?<span><font color=3D"#888888"><div><br></div><div>E=
ric</div></font></span><div><div><div><br><blockquote type=3D"cite"><div><d=
iv dir=3D"ltr">the xfsdump will hang after this message:<br><br>/sbin/xfsdu=
mp: dumping non-directory files<br><br></div><div class=3D"gmail_extra"><br=
><div class=3D"gmail_quote">2014-10-16 11:33 GMT+08:00 Eric Sandeen <span d=
ir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">san=
deen@sandeen.net</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span>On=
 10/15/14 9:31 PM, Tommy Wu wrote:<br>
&gt; Hi!<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 xfsdump 3.1.4<br>
&gt;=C2=A0 =C2=A0 xfsprogs 3.2.1<br>
&gt;=C2=A0 =C2=A0 linux kerenl 3.17/3.17.1<br>
&gt;<br>
<br>
</span>...<br>
<span><br>
&gt;=C2=A0 =C2=A0 It just create=C2=A0 a small dump file, and if I run the =
same xfsdump again (or umount the filesystem), it will hang, like:<br>
&gt;<br>
&gt; fw1:/vol/backup/fw1# /sbin/xfsdump -v trace,drive=3Ddebug,media=3Ddebu=
g -l 0 -o -J -F - /dev/vg/root | gzip &gt; test.gz<br>
&gt; /sbin/xfsdump: using file dump (drive_simple) strategy<br>
&gt; /sbin/xfsdump: version 3.1.4 (dump format 3.0)<br>
&gt; /sbin/xfsdump: level 0 dump of <a href=3D"http://fw1.teatime.com.tw" t=
arget=3D"_blank">fw1.teatime.com.tw</a>:/<br>
&gt; /sbin/xfsdump: dump date: Thu Oct 16 10:30:09 2014<br>
&gt; /sbin/xfsdump: session id: b8354300-d54c-4131-b39c-7c0b63968208<br>
&gt; /sbin/xfsdump: session label: &quot;&quot;<br>
&gt; /sbin/xfsdump: ino map phase 1: constructing initial dump list<br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 switch back to kernel 3.16, the same command work fine.<b=
r>
&gt;<br>
<br>
</span><a href=3D"http://git.kernel.org/cgit/linux/kernel/git/torvalds/linu=
x.git/commit/fs/xfs?id=3Da8b1ee8bafc765ebf029d03c5479a69aebff9693" target=
=3D"_blank">http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/=
commit/fs/xfs?id=3Da8b1ee8bafc765ebf029d03c5479a69aebff9693</a><br>
<br>
addresses the small backup file, and<br>
<br>
[PATCH] xfs: bulkstat doesn&#39;t release AGI buffer on error<br>
<br>
(on the list) most likely addresses the hang, I think.<br>
<span><font color=3D"#888888"><br>
-Eric<br>
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br><br>Tommy=
 Wu
</div>
</div></blockquote></div></div></div></div></blockquote></div><br><br clear=
=3D"all"><br></div></div><span class=3D"HOEnZb"><font color=3D"#888888">-- =
<br><br>Tommy Wu
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br><br>Tommy Wu
</div>

--001a113a84d8a04163050621504e--


--===============5517540091009172022==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5517540091009172022==--
