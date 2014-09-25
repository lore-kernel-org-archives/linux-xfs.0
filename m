Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4FC9D7F7E
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 01:08:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 122848F8035
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 23:08:30 -0700 (PDT)
Received: from mail-ie0-f179.google.com (mail-ie0-f179.google.com
	[209.85.223.179]) by cuda.sgi.com with ESMTP id
	6qRMN30kgVAoBb0v (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 23:08:27 -0700 (PDT)
Received: by mail-ie0-f179.google.com with SMTP id tp5so8310372ieb.10
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 23:08:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2VtShVThd0j0-YgGE6fAe28DJ1U-CCRR3Sj9eNjTLKp7FygA@mail.gmail.com>
References: <CAD2VtSjwu3eB+mrs2vX0G4+MJbHyNGVXvVR+P_ssNY6rydvijA@mail.gmail.com>
	<20140716124757.GC36312@bfoster.bfoster>
	<CAD2VtShVThd0j0-YgGE6fAe28DJ1U-CCRR3Sj9eNjTLKp7FygA@mail.gmail.com>
From: Hrishikesh Barua <talonx@gmail.com>
Date: Thu, 25 Sep 2014 11:37:47 +0530
Message-ID: <CAD2VtSgdYt2zxmEeWEXmK2B44BKuB-wRKvX4H=jRA9Rj7pyamA@mail.gmail.com>
Subject: Re: Occassional problems with unfreeze
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1469768198030386226=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

--===============1469768198030386226==
Content-Type: multipart/alternative; boundary=001a11c219e4007a950503dda13a

--001a11c219e4007a950503dda13a
Content-Type: text/plain; charset=UTF-8

This happened again yesterday and I took the "echo w >
/proc/sysrq-trigger".
Output - http://pastebin.com/rpKNSYY7

- Hrish

On 16 July 2014 18:53, Hrishikesh Barua <talonx@gmail.com> wrote:

>
> On 16 July 2014 18:17, Brian Foster <bfoster@redhat.com> wrote:
>
>>
>> That one looks like a freeze hang whereas you see an unfreeze hang.
>>
> You are right. My bad.
>
>
>> Perhaps similar to this:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=1052004
>>
> Looks like I can't access that bug report, even after logging in. The
> error message says  "Most likely the bug has been restricted for internal
> development processes and we cannot grant access."
>
>>
>> >
>> > No resolution seems to have happened there. Is this a known bug, or has
>> it
>> > been fixed since (I'm running xfsprogs 3.1.7) ?
>> >
>>
>> Do you have the hung task output for when this occurs (echo w >
>> /proc/sysrq-trigger)?
>>
> No, but I'll get it the next time it happens. Thanks for the tip.
>
>>
>> Brian
>>
>> > Regards
>> > Hrish
>>
>> > _______________________________________________
>> > xfs mailing list
>> > xfs@oss.sgi.com
>> > http://oss.sgi.com/mailman/listinfo/xfs
>>
>>
>


-- 
You can't be normal and expect abnormal returns - Jeffrey Pfeffer
------------------------------------------
http://code.deepinspace.net
------------------------------------------

--001a11c219e4007a950503dda13a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>This happened again yesterday and I took the &qu=
ot;echo w &gt; /proc/sysrq-trigger&quot;. <br></div>Output - <a href=3D"htt=
p://pastebin.com/rpKNSYY7">http://pastebin.com/rpKNSYY7</a><br><br></div>- =
Hrish<br></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On=
 16 July 2014 18:53, Hrishikesh Barua <span dir=3D"ltr">&lt;<a href=3D"mail=
to:talonx@gmail.com" target=3D"_blank">talonx@gmail.com</a>&gt;</span> wrot=
e:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div class=3D"gmail_e=
xtra"><br><div class=3D"gmail_quote"><span class=3D"">On 16 July 2014 18:17=
, Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redhat.com" =
target=3D"_blank">bfoster@redhat.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px soli=
d rgb(204,204,204);padding-left:1ex">
<div>
<br>
</div>That one looks like a freeze hang whereas you see an unfreeze hang.<b=
r></blockquote></span><div>You are right. My bad.<br>=C2=A0<br></div><span =
class=3D""><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.=
8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">

Perhaps similar to this:<br>
<br>
<a href=3D"https://bugzilla.redhat.com/show_bug.cgi?id=3D1052004" target=3D=
"_blank">https://bugzilla.redhat.com/show_bug.cgi?id=3D1052004</a><br></blo=
ckquote></span><div>Looks like I can&#39;t access that bug report, even aft=
er logging in. The error message says=C2=A0 &quot;Most likely the bug has b=
een restricted for internal development processes and we cannot grant acces=
s.&quot; <br>
</div><span class=3D""><blockquote class=3D"gmail_quote" style=3D"margin:0p=
x 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<div><br>
&gt;<br>
&gt; No resolution seems to have happened there. Is this a known bug, or ha=
s it<br>
&gt; been fixed since (I&#39;m running xfsprogs 3.1.7) ?<br>
&gt;<br>
<br>
</div>Do you have the hung task output for when this occurs (echo w &gt;<br=
>
/proc/sysrq-trigger)?<br></blockquote></span><div>No, but I&#39;ll get it t=
he next time it happens. Thanks for the tip.<br></div><span class=3D""><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left=
:1px solid rgb(204,204,204);padding-left:1ex">

<br>
Brian<br>
<br>
&gt; Regards<br>
&gt; Hrish<br>
<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</=
a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</blockquote></span></div><br></div></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br>You can&#39;t be normal=
 and expect abnormal returns - Jeffrey Pfeffer<br>-------------------------=
-----------------<br><a href=3D"http://code.deepinspace.net" target=3D"_bla=
nk">http://code.deepinspace.net</a><br>------------------------------------=
------
</div>

--001a11c219e4007a950503dda13a--


--===============1469768198030386226==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1469768198030386226==--
