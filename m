Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22GGIwk099179 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 10:16:18 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id 3H6ZIxK4msjxC1tW for
	<xfs@oss.sgi.com>; Fri, 02 Mar 2012 08:16:16 -0800 (PST)
Received: from smtp.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 2A1FC630F
	for <xfs@oss.sgi.com>; Fri,  2 Mar 2012 11:16:15 -0500 (EST)
Received: from b-pb-sasl-quonix.pobox.com (unknown [127.0.0.1])
	by b-sasl-quonix.pobox.com (Postfix) with ESMTP id 21689630D
	for <xfs@oss.sgi.com>; Fri,  2 Mar 2012 11:16:15 -0500 (EST)
Received: from Brians-MacBook-Air.local (unknown [87.114.42.104]) (using
	TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client
	certificate
	requested) by b-sasl-quonix.pobox.com (Postfix) with ESMTPSA id
	7A865630C for
	<xfs@oss.sgi.com>; Fri,  2 Mar 2012 11:16:14 -0500 (EST)
Received: from brian by Brians-MacBook-Air.local with local (Exim 4.77)
	(envelope-from <b.candler@pobox.com>) id M09MJ4-0009K5-HS for
	xfs@oss.sgi.com; Fri, 02 Mar 2012 16:16:16 +0000
Resent-Message-ID: <20120302161616.GC12352@nsrc.org>
Resent-To: xfs@oss.sgi.com
MIME-Version: 1.0
In-Reply-To: <CABF-5Wo1BRGgiy89PO+6sXzZ5ggFJYAXtXu+DA9hbEvfazFNqw@mail.gmail.com>
References: <CABF-5WptGU3vmScFcpHVstd2UZfCAqiY4dGvL=_1+feFvYuS6g@mail.gmail.com>
	<20120302140145.GA11911@nsrc.org>
	<37B5727D-1E3B-4A96-BF7F-4CA6DAF9B63C@gmail.com>
	<4F50E246.4020502@sandeen.net>
	<CABF-5Wo1BRGgiy89PO+6sXzZ5ggFJYAXtXu+DA9hbEvfazFNqw@mail.gmail.com>
Date: Sat, 3 Mar 2012 00:56:23 +0900
Message-ID: <CABF-5Wrb7auQiUjFA2WyqvCEUUZWfRzNbu_jG2inr0P26dARCg@mail.gmail.com>
Subject: Re: [XFS] xfs_repair time how long it takes??
From: Ryan Lee <ryanlee.lahk@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7545130183295888163=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Candler <B.Candler@pobox.com>

--===============7545130183295888163==
Content-Type: multipart/alternative; boundary=20cf307cfcd44a353004ba449e70

--20cf307cfcd44a353004ba449e70
Content-Type: text/plain; charset=ISO-8859-1

Eric,
I have one more qustion for  you.

You told me like this "then I would suspect a misconfiguration (maybe
mounting -o nobarrier with write caches enabled on the drives?) "

How can I check this misconfiguration? such as "-o nobarrier" is I couldn't
find this option with mount in my busybox and what do you mean the sentence
this " write caches enabled on the drives?"

Thanks,



On Sat, Mar 3, 2012 at 12:48 AM, Ryan Lee <ryanlee.lahk@gmail.com> wrote:

>
> Hi, all.
>
> Thanks a lot of your kindness for me.
> I really realy appreciate it.
>
> I am going to tell you what I have done so far porting  XFS in our system.
>
> First of all, the resources of our system.
>
> CPU : MIPS
> KERNEL : 2.6.37-2.6
> XFSPROGS : 3.1.7
>
> Second, I did this step.
>
> 1. mounting an xfs filesystem after an unclean shutdown on a machine.
> As a result i saw this error below.
> ------------------------------------------------------------------------
> XFS: xlog_recover_process_data: bad clientid
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed
> ------------------------------------------------------------------------
>
> 2. I patched for this error 1 from internet.
> http://comments.gmane.org/gmane.comp.file-systems.xfs.general/35446
>
> I did aging test by my self.
> As a result, after one day overnight, the XFS Filesystem crashed.
>
> 3, I look for another solution for 1 problem. eventually I found using
> xfs_repair to remove dirty log and recover.
> But as i mentioned it, it takes time a lot.
>
> You guys told me to use  the "fsck.xfs". but i think it couldn't solve the
> problem 1 above.
>
> Onething more, I already know about the problem with "xfs_repair", but I
> cound't find any other good solution to fix it until now.
>
> How can I fix it?
> Please help me.
>
> Thanks, Ryan.
>
>
>
>
> On Sat, Mar 3, 2012 at 12:07 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
>> On 3/2/12 8:26 AM, Ryan wrote:
>> >
>> > How about the dirty log. I use the xfs_repair because the dirty log
>> must be removed when i mount HDD.
>> >
>> > As you know xfs filesystem doen't repair the dirty log so i couldn't
>> mount the HDD after when i do cold reset during writing the HDD. How i can
>> solve this problem?
>>
>> If mount fails to replay the dirty log after a power loss, then I would
>> suspect a misconfiguration (maybe mounting -o nobarrier with write caches
>> enabled on the drives?) or a bug in your version of xfs, possibly unique to
>> architecture (what architecture is it, what kernel is it, what xfs
>> "porting" did you do?)
>>
>> -Eric
>>
>> > Sent from my iPhone.
>> >
>> >
>> >
>> > On Mar 2, 2012, at 11:01 PM, Brian Candler <B.Candler@pobox.com> wrote:
>> >
>> >> On Fri, Mar 02, 2012 at 10:09:56PM +0900, Ryan Lee wrote:
>> >>>   The problem is the taking time with xfs_repair like this "]#
>> xfs_repair
>> >>>   -P -L /dev/sda2" is to long to wait in our embedded system and for
>> me,
>> >>>   so the booing time is increasing around 2 minutes totally.
>> >>
>> >> Why do you feel you need to run xfs_repair on every boot? Regular Linux
>> >> systems do not attempt this, the same as they don't force a full
>> "e2fsck -f"
>> >> on every boot.
>> >>
>> >> http://linux.die.net/man/8/fsck.xfs
>> >
>> > _______________________________________________
>> > xfs mailing list
>> > xfs@oss.sgi.com
>> > http://oss.sgi.com/mailman/listinfo/xfs
>> >
>>
>>
>

--20cf307cfcd44a353004ba449e70
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Eric, </div><div>I have one more qustion for=A0 you.</div><div>=A0</di=
v><div>You told me like this &quot;then I would suspect a misconfiguration =
(maybe mounting -o nobarrier with write caches enabled on the drives?) &quo=
t; </div>
<div>=A0</div><div>How can I check this misconfiguration? such as &quot;-o =
nobarrier&quot; is I couldn&#39;t find this option with mount in my busybox=
 and what do you mean the sentence this &quot; write caches enabled on the =
drives?&quot;</div>
<div>=A0</div><div>Thanks,</div><div><br><br>=A0</div><div class=3D"gmail_q=
uote">On Sat, Mar 3, 2012 at 12:48 AM, Ryan Lee <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:ryanlee.lahk@gmail.com">ryanlee.lahk@gmail.com</a>&gt;</span> =
wrote:<br>
<blockquote style=3D"margin:0px 0px 0px 0.8ex;padding-left:1ex;border-left-=
color:rgb(204,204,204);border-left-width:1px;border-left-style:solid" class=
=3D"gmail_quote"><div><br>Hi, all.</div><div>=A0</div><div>Thanks a lot of =
your kindness for me.</div>
<div>I really realy appreciate it.</div><div>=A0</div><div>I am going to te=
ll you what I have done so far porting=A0 XFS in our=A0system.</div><div>
=A0</div><div>First of all, the resources of our system.</div><div>=A0</div=
><div>CPU : MIPS</div><div>KERNEL : 2.6.37-2.6</div><div>XFSPROGS : 3.1.7</=
div><div>=A0</div><div>Second, I did this step.</div><div>=A0</div><div>1. =
mounting an xfs filesystem after an unclean shutdown on a machine.</div>

<div>As a result=A0i saw this error below.</div><div>----------------------=
--------------------------------------------------</div><div>XFS: xlog_reco=
ver_process_data: bad clientid<br>XFS: log mount/recovery failed:=20
error 5<br>XFS: log mount failed</div><div>--------------------------------=
----------------------------------------</div><div>=A0</div><div>2. I patch=
ed for this error 1 from internet.</div><div><a href=3D"http://comments.gma=
ne.org/gmane.comp.file-systems.xfs.general/35446" target=3D"_blank">http://=
comments.gmane.org/gmane.comp.file-systems.xfs.general/35446</a></div>

<div>=A0</div><div>I did aging test by my self. </div><div>As a result, aft=
er one day overnight,=A0the=A0XFS Filesystem crashed.</div><div>=A0</div><d=
iv>3, I look for another solution for 1 problem. eventually I found using x=
fs_repair to remove=A0dirty log and recover.</div>

<div>But as i mentioned it, it=A0takes time a lot.</div><div>=A0</div><div>=
You guys told me to use =A0the &quot;fsck.xfs&quot;. but i think it couldn&=
#39;t solve the problem 1 above.</div><div>=A0</div><div>Onething more, I a=
lready know about the problem with &quot;xfs_repair&quot;, but I cound&#39;=
t find any other good solution to fix it until now.</div>

<div>=A0</div><div>How can I fix it?</div><div>Please help me.</div><div>=
=A0</div><div>Thanks, Ryan.</div><div class=3D"HOEnZb"><div class=3D"h5"><d=
iv>=A0</div><div>=A0</div><div><br>=A0</div><div class=3D"gmail_quote">On S=
at, Mar 3, 2012 at 12:07 AM, Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"=
mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</=
span> wrote:<br>

<blockquote style=3D"margin:0px 0px 0px 0.8ex;padding-left:1ex;border-left-=
color:rgb(204,204,204);border-left-width:1px;border-left-style:solid" class=
=3D"gmail_quote"><div>On 3/2/12 8:26 AM, Ryan wrote:<br>
&gt;<br>
&gt; How about the dirty log. I use the xfs_repair because the dirty log mu=
st be removed when i mount HDD.<br>
&gt;<br>
&gt; As you know xfs filesystem doen&#39;t repair the dirty log so i couldn=
&#39;t mount the HDD after when i do cold reset during writing the HDD. How=
 i can solve this problem?<br>
<br>
</div>If mount fails to replay the dirty log after a power loss, then I wou=
ld suspect a misconfiguration (maybe mounting -o nobarrier with write cache=
s enabled on the drives?) or a bug in your version of xfs, possibly unique =
to architecture (what architecture is it, what kernel is it, what xfs &quot=
;porting&quot; did you do?)<br>


<span><font color=3D"#888888"><br>
-Eric<br>
</font></span><div><br>
&gt; Sent from my iPhone.<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On Mar 2, 2012, at 11:01 PM, Brian Candler &lt;<a href=3D"mailto:B.Can=
dler@pobox.com" target=3D"_blank">B.Candler@pobox.com</a>&gt; wrote:<br>
&gt;<br>
&gt;&gt; On Fri, Mar 02, 2012 at 10:09:56PM +0900, Ryan Lee wrote:<br>
&gt;&gt;&gt; =A0 The problem is the taking time with xfs_repair like this &=
quot;]# xfs_repair<br>
&gt;&gt;&gt; =A0 -P -L /dev/sda2&quot; is to long to wait in our embedded s=
ystem and for me,<br>
&gt;&gt;&gt; =A0 so the booing time is increasing around 2 minutes totally.=
<br>
&gt;&gt;<br>
&gt;&gt; Why do you feel you need to run xfs_repair on every boot? Regular =
Linux<br>
&gt;&gt; systems do not attempt this, the same as they don&#39;t force a fu=
ll &quot;e2fsck -f&quot;<br>
&gt;&gt; on every boot.<br>
&gt;&gt;<br>
&gt;&gt; <a href=3D"http://linux.die.net/man/8/fsck.xfs" target=3D"_blank">=
http://linux.die.net/man/8/fsck.xfs</a><br>
&gt;<br>
</div><div><div>&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</=
a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt;<br>
<br>
</div></div></blockquote></div><br>
</div></div></blockquote></div><br>

--20cf307cfcd44a353004ba449e70--


--===============7545130183295888163==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7545130183295888163==--
