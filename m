Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 46C6929E12
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 12:30:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2D0D30406B
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 10:30:49 -0700 (PDT)
Received: from mail-la0-f48.google.com (mail-la0-f48.google.com
	[209.85.215.48]) by cuda.sgi.com with ESMTP id QDh53RgTuiTpqBzj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 08 May 2013 10:30:47 -0700 (PDT)
Received: by mail-la0-f48.google.com with SMTP id eg20so1969926lab.7
	for <xfs@oss.sgi.com>; Wed, 08 May 2013 10:30:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADNx=Kv=7TFkJKom6_JM8B+A6YRckj175TbCcHrTWYL_N-qkYw@mail.gmail.com>
References: <CADNx=KsT9DC=vveyTZx8EovddFx9mhRS-yzygaORHZ_4VyXfzQ@mail.gmail.com>
	<5187BF8A.2040303@sandeen.net>
	<CADNx=KvZPhbRn9Kc3+KdoAY7jZ3U0uyG6wgUB5vcxX85CkFdQg@mail.gmail.com>
	<CADNx=Kv0bt3fNGW8Y24GziW9MOO-+b7fBGub4AYP70b5gAegxw@mail.gmail.com>
	<5188FF88.6000508@sandeen.net>
	<CADNx=KvmA7jgqBUO0YvKddHvFaqxHNZKfF3eWajOW8GWKwNhbA@mail.gmail.com>
	<CADNx=Kv=7TFkJKom6_JM8B+A6YRckj175TbCcHrTWYL_N-qkYw@mail.gmail.com>
From: Filippo Stenico <filippo.stenico@gmail.com>
Date: Wed, 8 May 2013 19:30:05 +0200
Message-ID: <CADNx=KvxtCHEk9G07yS88-casVAXBxRTghV5nGKd_0LtcqpYpQ@mail.gmail.com>
Subject: Re: Xfs_repair segfaults.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8684111201506062931=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============8684111201506062931==
Content-Type: multipart/alternative; boundary=089e013d14ca46746104dc384bf4

--089e013d14ca46746104dc384bf4
Content-Type: text/plain; charset=ISO-8859-1

Hello,
-m option seems not to handle the excessive memory consumption I ran into.
I actually ran xfs_repair -vv -m1750 and  looking into kern.log it  seems
that xfs_repair invoked oom killer, but was killed itself ( !! )

This is last try to reproduce segfault:
xfs_repair -vv -P -m1750

On Tue, May 7, 2013 at 8:20 PM, Filippo Stenico
<filippo.stenico@gmail.com>wrote:

> xfs_repair -L -vv -P /dev/mapper/vg0-lv0 does the same kernel panic as my
> first report. No use to double info on this.
> I'll try xfs_repair -L -vv -P -m 2000 to keep memory consuption at a limit.
>
>
>
> On Tue, May 7, 2013 at 3:36 PM, Filippo Stenico <filippo.stenico@gmail.com
> > wrote:
>
>>
>>
>> On Tue, May 7, 2013 at 3:20 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>>> On 5/7/13 4:27 AM, Filippo Stenico wrote:
>>> > Hello,
>>> > this is a start-over to try hard to recover some more data out of my
>>> raid5 - lvm - xfs toasted volume.
>>> > My goal is either to try the best to get some more data out of the
>>> volume, and see if I can reproduce the segfault.
>>> > I compiled xfsprogs 3.1.9 from deb-source. I ran a xfs_metarestore to
>>> put original metadata on the cloned raid volume i had zeroed the log on
>>> before via xfs_repair -L (i figured none of the actual data was modified
>>> before as I am just working on metadata.. right?).
>>> > Then I ran a mount, checked a dir that I knew it was corrupted,
>>> unmount and try an xfs_repair (commands.txt attached for details)
>>> > I went home to sleep, but at morning I found out that kernel paniced
>>> due "out of memory and no killable process".
>>> > I ran repair without -P... Should I try now disabling inode prefetch?
>>> > Attached are also output of "free" and "top" at time of panic, as well
>>> as the output of xfs_repair and strace attached to it. Dont think gdb
>>> symbols would help here....
>>> >
>>>
>>> >
>>>
>>> Ho hum, well, no segfault this time, just an out of memory error?
>>>
>> That's right....
>>
>>> No real way to know where it went from the available data I think.
>>>
>>> A few things:
>>>
>>> > root@ws1000:~# mount /dev/mapper/vg0-lv0 /raid0/data/
>>> > mount: Structure needs cleaning
>>>
>>> mount failed?  Now's the time to look at dmesg to see why.
>>>
>>
>> From attached logs it seems to be:
>>>
>>> > XFS internal error xlog_valid_rec_header(1) at line 3466 of file
>>> [...2.6.32...]/fs/xfs/xfs_log_recover.c
>>> > XFS: log mount/recovery failed: error 117
>>>
>>> > root@ws1000:~# mount
>>>
>>> <no raid0 mounted>
>>>
>>> > root@ws1000:~# mount /dev/mapper/vg0-lv0 /raid0/data/
>>> > root@ws1000:~# mount | grep raid0
>>> > /dev/mapper/vg0-lv0 on /raid0/data type xfs (rw,relatime,attr2,noquota)
>>>
>>> Uh, now it worked, with no other steps in between?  That's a little odd.
>>>
>> Looks odd to me too. But i just copied the commands issued as they where
>> on my console... so yes, nothing in between.
>>
>>> It found a clean log this time:
>>>
>>> > XFS mounting filesystem dm-1
>>> > Ending clean XFS mount for filesystem: dm-1
>>>
>>> which is unexpected.
>>>
>>> So the memory consumption might be a bug but there's not enough info to
>>> go on here.
>>>
>>> > PS. Let me know if you wish reports like this one on list.
>>>
>>> worth reporting, but I'm not sure what we can do with it.
>>> Your storage is in pretty bad shape, and xfs_repair can't make something
>>> out
>>> of nothing.
>>>
>>> -Eric
>>>
>>
>> I still got back around 6TB out of 7.2 TB of total data stored, so this
>> tells xfs is reliable even when major faults occur...
>>
>> Thanks anyways, I am trying with a "-L" repair, at this step I expect
>> another fail (due out of memory or something, as it happened last time)
>> then I will try with "xfs_repair -L -vv -P" and I expect to see that
>> segfault again.
>>
>> Will report next steps, maybe something interesting for you will pop
>> up... for me is not a waste of time, since this last try is worth being
>> made.
>>
>> --
>> F
>
>
>
>
> --
> F




-- 
F

--089e013d14ca46746104dc384bf4
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,<br>-m option seems not to handle the excessive memory consumption I =
ran into.<br>I actually ran xfs_repair -vv -m1750 and=A0 looking into kern.=
log it=A0 seems that xfs_repair invoked oom killer, but was killed itself (=
 !! )<br>

<br>This is last try to reproduce segfault: <br>xfs_repair -vv -P -m1750 <b=
r><br><div class=3D"gmail_quote">On Tue, May 7, 2013 at 8:20 PM, Filippo St=
enico <span dir=3D"ltr">&lt;<a href=3D"mailto:filippo.stenico@gmail.com" ta=
rget=3D"_blank">filippo.stenico@gmail.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">xfs_repair -L -vv -P /dev/mapper/vg0-lv0 doe=
s the same kernel panic as my first report. No use to double info on this.<=
br>

I&#39;ll try xfs_repair -L -vv -P -m 2000 to keep memory consuption at a li=
mit.<div class=3D"HOEnZb"><div class=3D"h5"><br><br><br><div class=3D"gmail=
_quote">
On Tue, May 7, 2013 at 3:36 PM, Filippo Stenico <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:filippo.stenico@gmail.com" target=3D"_blank">filippo.stenico@g=
mail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">


<br><br><div class=3D"gmail_quote"><div>On Tue, May 7, 2013 at 3:20 PM, Eri=
c Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" targ=
et=3D"_blank">sandeen@sandeen.net</a>&gt;</span> wrote:<br><blockquote clas=
s=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pad=
ding-left:1ex">



<div>On 5/7/13 4:27 AM, Filippo Stenico wrote:<br>
&gt; Hello,<br>
</div><div>&gt; this is a start-over to try hard to recover some more data =
out of my raid5 - lvm - xfs toasted volume.<br>
&gt; My goal is either to try the best to get some more data out of the vol=
ume, and see if I can reproduce the segfault.<br>
&gt; I compiled xfsprogs 3.1.9 from deb-source. I ran a xfs_metarestore to =
put original metadata on the cloned raid volume i had zeroed the log on bef=
ore via xfs_repair -L (i figured none of the actual data was modified befor=
e as I am just working on metadata.. right?).<br>




&gt; Then I ran a mount, checked a dir that I knew it was corrupted, unmoun=
t and try an xfs_repair (commands.txt attached for details)<br>
&gt; I went home to sleep, but at morning I found out that kernel paniced d=
ue &quot;out of memory and no killable process&quot;.<br>
&gt; I ran repair without -P... Should I try now disabling inode prefetch?<=
br>
&gt; Attached are also output of &quot;free&quot; and &quot;top&quot; at ti=
me of panic, as well as the output of xfs_repair and strace attached to it.=
 Dont think gdb symbols would help here....<br>
&gt;<br>
<br>
&gt;<br>
<br>
</div>Ho hum, well, no segfault this time, just an out of memory error?<br>=
</blockquote></div><div>That&#39;s right....<br></div><div><blockquote clas=
s=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pad=
ding-left:1ex">




No real way to know where it went from the available data I think.<br>
<br>
A few things:<br>
<br>
&gt; root@ws1000:~# mount /dev/mapper/vg0-lv0 /raid0/data/<br>
&gt; mount: Structure needs cleaning<br>
<br>
mount failed? =A0Now&#39;s the time to look at dmesg to see why.<br>
=A0</blockquote><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8e=
x;border-left:1px #ccc solid;padding-left:1ex">
>From attached logs it seems to be:<br>
<br>
&gt; XFS internal error xlog_valid_rec_header(1) at line 3466 of file [...2=
.6.32...]/fs/xfs/xfs_log_recover.c<br>
&gt; XFS: log mount/recovery failed: error 117<br>
<br>
&gt; root@ws1000:~# mount<br>
<br>
&lt;no raid0 mounted&gt;<br>
<br>
&gt; root@ws1000:~# mount /dev/mapper/vg0-lv0 /raid0/data/<br>
&gt; root@ws1000:~# mount | grep raid0<br>
&gt; /dev/mapper/vg0-lv0 on /raid0/data type xfs (rw,relatime,attr2,noquota=
)<br>
<br>
Uh, now it worked, with no other steps in between? =A0That&#39;s a little o=
dd.<br>
</blockquote></div><div>Looks odd to me too. But i just copied the commands=
 issued as they where on my console... so yes, nothing in between.=A0 <br><=
/div><div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex">



It found a clean log this time:<br>
<br>
&gt; XFS mounting filesystem dm-1<br>
&gt; Ending clean XFS mount for filesystem: dm-1<br>
<br>
which is unexpected.<br>
<br>
So the memory consumption might be a bug but there&#39;s not enough info to=
 go on here.<br>
<div><br>
&gt; PS. Let me know if you wish reports like this one on list.<br>
<br>
</div>worth reporting, but I&#39;m not sure what we can do with it.<br>
Your storage is in pretty bad shape, and xfs_repair can&#39;t make somethin=
g out<br>
of nothing.<br>
<span><font color=3D"#888888"><br>
-Eric<br></font></span></blockquote><div>=A0</div></div></div>I still got b=
ack around 6TB out of 7.2 TB of total data stored, so this tells xfs is rel=
iable even when major faults occur...<br><br>Thanks anyways, I am trying wi=
th a &quot;-L&quot; repair, at this step I expect another fail (due out of =
memory or something, as it happened last time) then I will try with &quot;x=
fs_repair -L -vv -P&quot; and I expect to see that segfault again.<br>



<br>Will report next steps, maybe something interesting for you will pop up=
... for me is not a waste of time, since this last try is worth being made.=
 <br><span><font color=3D"#888888"><br>-- <br>F
</font></span></blockquote></div><br><br clear=3D"all"><br></div></div><spa=
n class=3D"HOEnZb"><font color=3D"#888888">-- <br>F
</font></span></blockquote></div><br><br clear=3D"all"><br>-- <br>F

--089e013d14ca46746104dc384bf4--


--===============8684111201506062931==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8684111201506062931==--
