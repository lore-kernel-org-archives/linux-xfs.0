Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 78AE529DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 12:23:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 092D7AC00A
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 10:23:19 -0700 (PDT)
Received: from mail-lb0-f180.google.com (mail-lb0-f180.google.com
	[209.85.217.180]) by cuda.sgi.com with ESMTP id
	9a4ea7rf2CicWRuS (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 May 2013 10:23:13 -0700 (PDT)
Received: by mail-lb0-f180.google.com with SMTP id v1so3325119lbd.11
	for <xfs@oss.sgi.com>; Thu, 09 May 2013 10:23:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADNx=KuvQ1u+i+PgaCUqLbeGA0-8yfaCP=pez7ptGdm2pL_oGw@mail.gmail.com>
References: <CADNx=KsT9DC=vveyTZx8EovddFx9mhRS-yzygaORHZ_4VyXfzQ@mail.gmail.com>
	<5187BF8A.2040303@sandeen.net>
	<CADNx=KvZPhbRn9Kc3+KdoAY7jZ3U0uyG6wgUB5vcxX85CkFdQg@mail.gmail.com>
	<CADNx=Kv0bt3fNGW8Y24GziW9MOO-+b7fBGub4AYP70b5gAegxw@mail.gmail.com>
	<5188FF88.6000508@sandeen.net>
	<CADNx=KvmA7jgqBUO0YvKddHvFaqxHNZKfF3eWajOW8GWKwNhbA@mail.gmail.com>
	<CADNx=Kv=7TFkJKom6_JM8B+A6YRckj175TbCcHrTWYL_N-qkYw@mail.gmail.com>
	<CADNx=KvxtCHEk9G07yS88-casVAXBxRTghV5nGKd_0LtcqpYpQ@mail.gmail.com>
	<20130508233910.GL24635@dastard>
	<CADNx=KuvQ1u+i+PgaCUqLbeGA0-8yfaCP=pez7ptGdm2pL_oGw@mail.gmail.com>
From: Filippo Stenico <filippo.stenico@gmail.com>
Date: Thu, 9 May 2013 19:22:32 +0200
Message-ID: <CADNx=KuUBVObX=UuWH+DpmES1kGppptMEMgjVnt_2kTzBDadDw@mail.gmail.com>
Subject: Re: Xfs_repair segfaults.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4690332446398585818=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============4690332446398585818==
Content-Type: multipart/alternative; boundary=089e013d19221127c604dc4c4e96

--089e013d19221127c604dc4c4e96
Content-Type: text/plain; charset=ISO-8859-1

Hello,
ran xfs_repair -vv -L -P -m1750 and segfault at expected point.

I got the core-dump with dbg symbols, along with repair output and strace
output.

What should I do with it? Provide as it is?
Archive is about 70M: for now I can make a public share:
https://apps.memopal.com/e/S656XDVV

Hope this can help.


On Thu, May 9, 2013 at 5:11 PM, Filippo Stenico
<filippo.stenico@gmail.com>wrote:

>
>
> On Thu, May 9, 2013 at 1:39 AM, Dave Chinner <david@fromorbit.com> wrote:
>
>> On Wed, May 08, 2013 at 07:30:05PM +0200, Filippo Stenico wrote:
>> > Hello,
>> > -m option seems not to handle the excessive memory consumption I ran
>> into.
>> > I actually ran xfs_repair -vv -m1750 and  looking into kern.log it
>>  seems
>> > that xfs_repair invoked oom killer, but was killed itself ( !! )
>>
>> That's exactly what the oom killer is supposed to do.
>>
>> Yeah, some sacrifice needed.
>
>
>> > This is last try to reproduce segfault:
>> > xfs_repair -vv -P -m1750
>>
>> I know your filesystem is around 7TB in size, but how much RAM do
>> you have? It's not unusual for xfs_repair to require many GB of
>> memory to run succesfully on filesystems of this size...
>>
>> it is around 11 TB, 7.2 used.
> I have 4 G ram, but xfs_repair -vv -m1 says I need 1558
> root@ws1000:~# xfs_repair -vv -P -m 1 /dev/mapper/vg0-lv0
> Phase 1 - find and verify superblock...
>         - max_mem = 1024, icount = 29711040, imem = 116058, dblock =
> 2927886336, dmem = 1429632
> Required memory for repair is greater that the maximum specified
> with the -m option. Please increase it to at least 1558.
>
> so I figured 1750 megs would be enough
>
> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>
>
>
> --
> F




-- 
F

--089e013d19221127c604dc4c4e96
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,<br>ran xfs_repair -vv -L -P -m1750 and segfault at expected point.<b=
r><br>I got the core-dump with dbg symbols, along with repair output and st=
race output.<br><br>What should I do with it? Provide as it is?<br>Archive =
is about 70M: for now I can make a public share:<br>

<a href=3D"https://apps.memopal.com/e/S656XDVV">https://apps.memopal.com/e/=
S656XDVV</a><br><br>Hope this can help.<br><br><br><div class=3D"gmail_quot=
e">On Thu, May 9, 2013 at 5:11 PM, Filippo Stenico <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:filippo.stenico@gmail.com" target=3D"_blank">filippo.stenic=
o@gmail.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><br><br><div class=3D"gmail_quote"><div clas=
s=3D"im">On Thu, May 9, 2013 at 1:39 AM, Dave Chinner <span dir=3D"ltr">&lt=
;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.c=
om</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">

<div>On Wed, May 08, 2013 at 07:30:05PM +0200, Filippo Stenico wrote:<br>
&gt; Hello,<br>
&gt; -m option seems not to handle the excessive memory consumption I ran i=
nto.<br>
&gt; I actually ran xfs_repair -vv -m1750 and =A0looking into kern.log it =
=A0seems<br>
&gt; that xfs_repair invoked oom killer, but was killed itself ( !! )<br>
<br>
</div>That&#39;s exactly what the oom killer is supposed to do.<br>
<div><br></div></blockquote></div><div>Yeah, some sacrifice needed.<br>=A0<=
br></div><div class=3D"im"><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div>
&gt; This is last try to reproduce segfault:<br>
&gt; xfs_repair -vv -P -m1750<br>
<br>
</div>I know your filesystem is around 7TB in size, but how much RAM do<br>
you have? It&#39;s not unusual for xfs_repair to require many GB of<br>
memory to run succesfully on filesystems of this size...<br>
<br></blockquote></div><div>it is around 11 TB, 7.2 used.<br>I have 4 G ram=
, but xfs_repair -vv -m1 says I need 1558<br>root@ws1000:~# xfs_repair -vv =
-P -m 1 /dev/mapper/vg0-lv0 <br>Phase 1 - find and verify superblock...<br>

=A0=A0=A0=A0=A0=A0=A0 - max_mem =3D 1024, icount =3D 29711040, imem =3D 116=
058, dblock =3D 2927886336, dmem =3D 1429632<br>
Required memory for repair is greater that the maximum specified<br>with th=
e -m option. Please increase it to at least 1558.<br><br>so I figured 1750 =
megs would be enough<br><br></div><div class=3D"im"><blockquote class=3D"gm=
ail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-le=
ft:1ex">



Cheers,<br>
<br>
Dave.<br>
<span><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
</font></span><div><div><br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a><br=
>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div></div><span class=3D"HOEnZb"><font color=3D"=
#888888"><br><br clear=3D"all"><br>-- <br>F
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br>F

--089e013d19221127c604dc4c4e96--


--===============4690332446398585818==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4690332446398585818==--
