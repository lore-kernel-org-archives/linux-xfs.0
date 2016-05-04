Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BCE167CA3
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 10:48:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 86821304067
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 08:48:19 -0700 (PDT)
Received: from mail-qg0-f46.google.com (mail-qg0-f46.google.com
	[209.85.192.46]) by cuda.sgi.com with ESMTP id lP5TpuKHYHsbDDy4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 May 2016 08:48:14 -0700 (PDT)
Received: by mail-qg0-f46.google.com with SMTP id w36so25360852qge.3
	for <xfs@oss.sgi.com>; Wed, 04 May 2016 08:48:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160418185429.GA6730@redhat.com>
References: <CACo5E_6fz+BV7prpyo35jzH2_dwgswZ4ZkZ26XP9czbdT3g6vw@mail.gmail.com>
	<20160418185429.GA6730@redhat.com>
Date: Wed, 4 May 2016 10:48:13 -0500
Message-ID: <CACo5E_7rcRdsQW00jO7FTfdHY7eyJDoFDTftA_YNh_nZ0rjsQg@mail.gmail.com>
Subject: Re: "xfs_log_force: error 5 returned." for drive that was removed.
From: Joe Wendt <joe@wendtwerks.com>
Reply-To: joe@wendtwerks.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6226364484403351819=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6226364484403351819==
Content-Type: multipart/alternative; boundary=001a11c117704929bf0532062711

--001a11c117704929bf0532062711
Content-Type: text/plain; charset=UTF-8

Thanks for the reply, and I'm sorry for the delay. Another admin rebooted
the server before I had a chance to collect more info. I'll take a look at
the other thread in case it comes up again. I think we'll avoid the
lazy-unmount in the future though.

Thanks again!
-Joe

On Mon, Apr 18, 2016 at 1:54 PM, Carlos Maiolino <cmaiolino@redhat.com>
wrote:

> On Sun, Apr 17, 2016 at 09:33:27AM -0500, Joe Wendt wrote:
> >    Hello! This may be a silly question or an interesting one...
> >    We had a drive fail in a production server, which spawned this error
> in
> >    the logs:
> >    XFS (sde1): xfs_log_force: error 5 returned.
> >    The dead array was lazy-unmounted, and the drive was hot-swapped, but
> >    when the RAID array was rebuilt, it came online as /dev/sdk instead of
> >    /dev/sde.
> >    Now /dev/sde1 doesn't exist in the system, but we still see this
> >    message every 30 seconds. I'm assuming a reboot will clear out
> whatever
> >    is still trying to access sde1, but I'm trying to avoid that if
> >    possible. Could someone point me in the direction of what XFS might
> >    still be trying to do with that device?
> >    lsof hasn't given me any clues. I can't run xfs_repair on a volume
> that
> >    isn't there. I haven't been able to find anything similar yet online.
> >    Any help would be greatly appreciated!
> >    Thanks,
> >    Joe
>
> I believe this is the same problem being discussed in this thread:
>
> XFS hung task in xfs_ail_push_all_sync() when unmounting FS after disk
> failure/recovery.
>
> Can you get a stack dump of the system (sysrq-t) and post it in some
> pastebin?
>
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>
> --
> Carlos
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

--001a11c117704929bf0532062711
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Thanks for the reply, and I&#39;m sorry for the =
delay. Another admin rebooted the server before I had a chance to collect m=
ore info. I&#39;ll take a look at the other thread in case it comes up agai=
n. I think we&#39;ll avoid the lazy-unmount in the future though.<br><br></=
div>Thanks again!<br></div>-Joe<br></div><div class=3D"gmail_extra"><br><di=
v class=3D"gmail_quote">On Mon, Apr 18, 2016 at 1:54 PM, Carlos Maiolino <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:cmaiolino@redhat.com" target=3D"_blan=
k">cmaiolino@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex"><div class=3D"HOEnZb"><div class=3D"h5">On Sun, Apr 17, 2016 at 09:33:=
27AM -0500, Joe Wendt wrote:<br>
&gt;=C2=A0 =C2=A0 Hello! This may be a silly question or an interesting one=
...<br>
&gt;=C2=A0 =C2=A0 We had a drive fail in a production server, which spawned=
 this error in<br>
&gt;=C2=A0 =C2=A0 the logs:<br>
&gt;=C2=A0 =C2=A0 XFS (sde1): xfs_log_force: error 5 returned.<br>
&gt;=C2=A0 =C2=A0 The dead array was lazy-unmounted, and the drive was hot-=
swapped, but<br>
&gt;=C2=A0 =C2=A0 when the RAID array was rebuilt, it came online as /dev/s=
dk instead of<br>
&gt;=C2=A0 =C2=A0 /dev/sde.<br>
&gt;=C2=A0 =C2=A0 Now /dev/sde1 doesn&#39;t exist in the system, but we sti=
ll see this<br>
&gt;=C2=A0 =C2=A0 message every 30 seconds. I&#39;m assuming a reboot will =
clear out whatever<br>
&gt;=C2=A0 =C2=A0 is still trying to access sde1, but I&#39;m trying to avo=
id that if<br>
&gt;=C2=A0 =C2=A0 possible. Could someone point me in the direction of what=
 XFS might<br>
&gt;=C2=A0 =C2=A0 still be trying to do with that device?<br>
&gt;=C2=A0 =C2=A0 lsof hasn&#39;t given me any clues. I can&#39;t run xfs_r=
epair on a volume that<br>
&gt;=C2=A0 =C2=A0 isn&#39;t there. I haven&#39;t been able to find anything=
 similar yet online.<br>
&gt;=C2=A0 =C2=A0 Any help would be greatly appreciated!<br>
&gt;=C2=A0 =C2=A0 Thanks,<br>
&gt;=C2=A0 =C2=A0 Joe<br>
<br>
</div></div>I believe this is the same problem being discussed in this thre=
ad:<br>
<br>
XFS hung task in xfs_ail_push_all_sync() when unmounting FS after disk<br>
failure/recovery.<br>
<br>
Can you get a stack dump of the system (sysrq-t) and post it in some pasteb=
in?<br>
<br>
<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer"=
 target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
--<br>
Carlos<br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer" targ=
et=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
</font></span></blockquote></div><br></div>

--001a11c117704929bf0532062711--


--===============6226364484403351819==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6226364484403351819==--
