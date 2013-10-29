Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4A35A7F3F
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 15:52:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9BE72AC073
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 13:52:13 -0700 (PDT)
Received: from mail-ve0-f172.google.com (mail-ve0-f172.google.com
	[209.85.128.172]) by cuda.sgi.com with ESMTP id
	w3O8NjjZLzZZfXiA (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 13:52:12 -0700 (PDT)
Received: by mail-ve0-f172.google.com with SMTP id cz12so346220veb.3
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 13:52:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGa409_dbHBK=MVuQf8Z2YSmgTTqBGkG07XvD4bPhn=pHF9Seg@mail.gmail.com>
References: <CAGa4099etDS8eBGCQ_Se2oQxObO8ZSqHpGeXzeUCpCz3S7XnBw@mail.gmail.com>
	<20131017040654.GQ4446@dastard>
	<CAGa409_dbHBK=MVuQf8Z2YSmgTTqBGkG07XvD4bPhn=pHF9Seg@mail.gmail.com>
Date: Tue, 29 Oct 2013 13:52:11 -0700
Message-ID: <CAGa409-=HQF5fj2Z=LOLN8kvsPUDaOKnGC5zOSHArAXxuaBUKQ@mail.gmail.com>
Subject: Re: xfs_repair fatal error -- name create failed in lost+found,
	filesystem may be out of space
From: Viet Nguyen <vietnguyen@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7751774612430704499=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============7751774612430704499==
Content-Type: multipart/alternative; boundary=047d7b343eca05d2d504e9e764cd

--047d7b343eca05d2d504e9e764cd
Content-Type: text/plain; charset=ISO-8859-1

Sorry to be a pain, but is there anything I can do?


On Thu, Oct 17, 2013 at 10:01 AM, Viet Nguyen <vietnguyen@gmail.com> wrote:

> The corruption was detected after a power outage. The underlying system is
> an LSI RAID 6, according to the controller, the RAID integrity checks out,
> though I don't know if I could trust that. This is the second time this
> server has suffered xfs corruption after a power outage. The strange thing
> is that there hasn't been any writes made to the filesystem for weeks. The
> server passed a memtest, and xfs_repair fails consistently at the same
> point. So I'm not sure what's going on there.
>
> Is there any other particular details I could provide?
>
>
> On Wed, Oct 16, 2013 at 9:06 PM, Dave Chinner <david@fromorbit.com> wrote:
>
>> On Wed, Oct 16, 2013 at 08:57:20PM -0700, Viet Nguyen wrote:
>> > Hi,
>> > Me again. I've got get another corrupted drive and I'm getting a
>> different
>> > error for xfs_repair:
>> >
>> > fatal error -- name create failed in lost+found (117), filesystem may be
>> > out of space
>>
>> Error 117 is telling you that the filesystem is corrupted. i.e.
>> attempting to make a new name for a lost inode has resulted in
>> detection of a new corruption or previously undetected or
>> uncorrected corruption in the filesystem.
>>
>> Given the amount of damage your filesystem sustained, that's not
>> totally unexpected, especially if you are running 3.2.0-alpha.
>> Can you provide more details about the failure?
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

--047d7b343eca05d2d504e9e764cd
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sorry to be a pain, but is there anything I can do?</div><=
div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Thu, Oct 17=
, 2013 at 10:01 AM, Viet Nguyen <span dir=3D"ltr">&lt;<a href=3D"mailto:vie=
tnguyen@gmail.com" target=3D"_blank">vietnguyen@gmail.com</a>&gt;</span> wr=
ote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">The corruption was detected=
 after a power outage. The underlying system is an LSI RAID 6, according to=
 the controller, the RAID integrity checks out, though I don&#39;t know if =
I could trust that. This is the second time this server has suffered xfs co=
rruption after a power outage. The strange thing is that there hasn&#39;t b=
een any writes made to the filesystem for weeks. The server passed a memtes=
t, and xfs_repair fails consistently at the same point. So I&#39;m not sure=
 what&#39;s going on there.<div>

<br></div><div>Is there any other particular details I could provide?</div>=
</div><div class=3D"HOEnZb"><div class=3D"h5"><div class=3D"gmail_extra"><b=
r><br><div class=3D"gmail_quote">On Wed, Oct 16, 2013 at 9:06 PM, Dave Chin=
ner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"=
_blank">david@fromorbit.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div>On Wed, Oct 16, 2013 at 08:57:20PM -070=
0, Viet Nguyen wrote:<br>
&gt; Hi,<br>
&gt; Me again. I&#39;ve got get another corrupted drive and I&#39;m getting=
 a different<br>
&gt; error for xfs_repair:<br>
&gt;<br>
&gt; fatal error -- name create failed in lost+found (117), filesystem may =
be<br>
&gt; out of space<br>
<br>
</div>Error 117 is telling you that the filesystem is corrupted. i.e.<br>
attempting to make a new name for a lost inode has resulted in<br>
detection of a new corruption or previously undetected or<br>
uncorrected corruption in the filesystem.<br>
<br>
Given the amount of damage your filesystem sustained, that&#39;s not<br>
totally unexpected, especially if you are running 3.2.0-alpha.<br>
Can you provide more details about the failure?<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
</font></span></blockquote></div><br></div>
</div></div></blockquote></div><br></div>

--047d7b343eca05d2d504e9e764cd--


--===============7751774612430704499==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7751774612430704499==--
