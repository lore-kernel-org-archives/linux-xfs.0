Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 298AB29DF8
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 20:11:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5EC930404E
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 18:11:54 -0700 (PDT)
Received: from mail-ve0-f169.google.com (mail-ve0-f169.google.com
	[209.85.128.169]) by cuda.sgi.com with ESMTP id
	CmDdNWGeesjg8h9D (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Apr 2014 18:11:52 -0700 (PDT)
Received: by mail-ve0-f169.google.com with SMTP id jx11so459129veb.0
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 18:11:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140429010121.GE18672@dastard>
References: <CALjwKZDsGBxTDLvy7-W76FRpHRuki_ZjOXLWZ70fut4hmDkTSQ@mail.gmail.com>
	<20140428234558.GD18672@dastard>
	<CALjwKZCZrpHNnqCWyotiYvLNa8yJMRoBgNp4NShSj0j2hLJ9DQ@mail.gmail.com>
	<20140429010121.GE18672@dastard>
Date: Mon, 28 Apr 2014 19:11:52 -0600
Message-ID: <CALjwKZDUREsPYDuCGJF_=sZxxRqKP40qmk5Dun5AGvMLvmdPaA@mail.gmail.com>
Subject: Re: xfs umount hang in xfs_ail_push_all_sync on i/o error
From: Bob Mastors <bob.mastors@solidfire.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7317677662003274580=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============7317677662003274580==
Content-Type: multipart/alternative; boundary=089e013a0d40f94e9a04f8241d1d

--089e013a0d40f94e9a04f8241d1d
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Apr 28, 2014 at 7:01 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Apr 28, 2014 at 05:51:31PM -0600, Bob Mastors wrote:
> > Log output attached.
> > The xfs filesystem being mounted and unmounted is the only xfs filesystem
> > on the system.
> > Bob
> >
> >
> > On Mon, Apr 28, 2014 at 5:45 PM, Dave Chinner <david@fromorbit.com>
> wrote:
> >
> > > On Mon, Apr 28, 2014 at 04:29:02PM -0600, Bob Mastors wrote:
> > > > Greetings,
> > > >
> > > > I have an xfs umount hang caused by forcing the block device to
> return
> > > > i/o errors while copying files to the filesystem.
> > > > Detailed steps to reproduce the problem on virtualbox are below.
> > > >
> > > > The linux version is a recent pull and reports as 3.15.0-rc3.
> > > >
> > > > [ 2040.248096] INFO: task umount:10303 blocked for more than 120
> seconds.
> > > > [ 2040.323947]       Not tainted 3.15.0-rc3 #4
> > > > [ 2040.343423] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > > disables
> > > > this message.
> > > > [ 2040.352665] umount          D ffffffff8180fe40     0 10303   8691
> > > > 0x00000000
> > > > [ 2040.404918]  ffff88001e33dd58 0000000000000086 ffff88001e33dd48
> > > > ffffffff81080f82
> > > > [ 2040.489901]  ffff88001b311900 0000000000013180 ffff88001e33dfd8
> > > > 0000000000013180
> > > > [ 2040.534772]  ffff88003daa3200 ffff88001b311900 ffff88002421aec0
> > > > ffff88002421ae80
> > > > [ 2040.587450] Call Trace:
> > > > [ 2040.592176]  [<ffffffff81080f82>] ? try_to_wake_up+0x232/0x2b0
> > > > [ 2040.620212]  [<ffffffff816c54d9>] schedule+0x29/0x70
> > > > [ 2040.627685]  [<ffffffffa04c4cd6>] xfs_ail_push_all_sync+0x96/0xd0
> > > [xfs]
> > > > [ 2040.632236]  [<ffffffff81092230>] ? __wake_up_sync+0x20/0x20
> > > > [ 2040.659105]  [<ffffffffa04731a3>] xfs_unmountfs+0x63/0x160 [xfs]
> > > > [ 2040.691774]  [<ffffffffa0478f65>] ? kmem_free+0x35/0x40 [xfs]
> > > > [ 2040.698610]  [<ffffffffa0474cf5>] xfs_fs_put_super+0x25/0x60 [xfs]
> > > > [ 2040.706838]  [<ffffffff8119561e>]
> generic_shutdown_super+0x7e/0x100
> > > > [ 2040.723958]  [<ffffffff811956d0>] kill_block_super+0x30/0x80
> > > > [ 2040.734963]  [<ffffffff8119591d>]
> deactivate_locked_super+0x4d/0x80
> > > > [ 2040.745485]  [<ffffffff8119652e>] deactivate_super+0x4e/0x70
> > > > [ 2040.751274]  [<ffffffff811b1d42>] mntput_no_expire+0xd2/0x160
> > > > [ 2040.755894]  [<ffffffff811b2fff>] SyS_umount+0xaf/0x3b0
> > > > [ 2040.761032]  [<ffffffff816d1592>] system_call_fastpath+0x16/0x1b
> > > > [ .060058] XFS (sdb): xfs_log_force: error 5 returned.
> > > > [ 268059] XFS (sdb): xfs_log_force: error 5 returned.
> > > >
> > > > I took a look at xfs_ail_push_all_sync and it is pretty easy to see
> > > > the hang. But it is not obvious to me how to fix it.
> > > > Any ideas would be appreciated.
> > > >
> > > > I am available to run additional tests or capture more logging
> > > > or whatever if that would help.
> > >
> > > What's the entire log output from the first shutdown message?
>
> So what is the AIL stuck on? Can you trace the xfs_ail* trace points
> when it is in shutdown like this and post the output of the report?
>
I will try to get this info.
Might take a couple of days.


>
> > [ 1318.816643] XFS (sdb): metadata I/O error: block 0x19fc80
> ("xfs_buf_iodone_callbacks") error 5 numblks 16
> > [ 1318.818080] XFS (sdb): metadata I/O error: block 0x1025cf
> ("xlog_iodone") error 5 numblks 64
> > [ 1318.819350] XFS (sdb): xfs_do_force_shutdown(0x2) called from line
> 1170 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa04b9859
> > [ 1318.821089] XFS (sdb): Log I/O Error Detected.  Shutting down
> filesystem
> > [ 1318.822301] XFS (sdb): xfs_log_force: error 5 returned.
> > [ 1318.822308] XFS (sdb): xfs_log_force: error 5 returned.
> > [ 1318.822311] XFS (sdb): Detected failing async write on buffer block
> 0x19fca0. Retrying async write.
>
> That's the only thing that is unusual about the hang. Does this
> always appear when a hang occurs?
>
I don't think so but I have not been keeping all of the logs.
I will run the test some more and see if it always appears or not.

Thanks,
Bob


>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--089e013a0d40f94e9a04f8241d1d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On M=
on, Apr 28, 2014 at 7:01 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"=
mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</=
span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On M=
on, Apr 28, 2014 at 05:51:31PM -0600, Bob Mastors wrote:<br>
&gt; Log output attached.<br>
&gt; The xfs filesystem being mounted and unmounted is the only xfs filesys=
tem<br>
&gt; on the system.<br>
&gt; Bob<br>
&gt;<br>
&gt;<br>
&gt; On Mon, Apr 28, 2014 at 5:45 PM, Dave Chinner &lt;<a href=3D"mailto:da=
vid@fromorbit.com">david@fromorbit.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Mon, Apr 28, 2014 at 04:29:02PM -0600, Bob Mastors wrote:<br>
&gt; &gt; &gt; Greetings,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I have an xfs umount hang caused by forcing the block device=
 to return<br>
&gt; &gt; &gt; i/o errors while copying files to the filesystem.<br>
&gt; &gt; &gt; Detailed steps to reproduce the problem on virtualbox are be=
low.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; The linux version is a recent pull and reports as 3.15.0-rc3=
.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; [ 2040.248096] INFO: task umount:10303 blocked for more than=
 120 seconds.<br>
&gt; &gt; &gt; [ 2040.323947] =A0 =A0 =A0 Not tainted 3.15.0-rc3 #4<br>
&gt; &gt; &gt; [ 2040.343423] &quot;echo 0 &gt; /proc/sys/kernel/hung_task_=
timeout_secs&quot;<br>
&gt; &gt; disables<br>
&gt; &gt; &gt; this message.<br>
&gt; &gt; &gt; [ 2040.352665] umount =A0 =A0 =A0 =A0 =A0D ffffffff8180fe40 =
=A0 =A0 0 10303 =A0 8691<br>
&gt; &gt; &gt; 0x00000000<br>
&gt; &gt; &gt; [ 2040.404918] =A0ffff88001e33dd58 0000000000000086 ffff8800=
1e33dd48<br>
&gt; &gt; &gt; ffffffff81080f82<br>
&gt; &gt; &gt; [ 2040.489901] =A0ffff88001b311900 0000000000013180 ffff8800=
1e33dfd8<br>
&gt; &gt; &gt; 0000000000013180<br>
&gt; &gt; &gt; [ 2040.534772] =A0ffff88003daa3200 ffff88001b311900 ffff8800=
2421aec0<br>
&gt; &gt; &gt; ffff88002421ae80<br>
&gt; &gt; &gt; [ 2040.587450] Call Trace:<br>
&gt; &gt; &gt; [ 2040.592176] =A0[&lt;ffffffff81080f82&gt;] ? try_to_wake_u=
p+0x232/0x2b0<br>
&gt; &gt; &gt; [ 2040.620212] =A0[&lt;ffffffff816c54d9&gt;] schedule+0x29/0=
x70<br>
&gt; &gt; &gt; [ 2040.627685] =A0[&lt;ffffffffa04c4cd6&gt;] xfs_ail_push_al=
l_sync+0x96/0xd0<br>
&gt; &gt; [xfs]<br>
&gt; &gt; &gt; [ 2040.632236] =A0[&lt;ffffffff81092230&gt;] ? __wake_up_syn=
c+0x20/0x20<br>
&gt; &gt; &gt; [ 2040.659105] =A0[&lt;ffffffffa04731a3&gt;] xfs_unmountfs+0=
x63/0x160 [xfs]<br>
&gt; &gt; &gt; [ 2040.691774] =A0[&lt;ffffffffa0478f65&gt;] ? kmem_free+0x3=
5/0x40 [xfs]<br>
&gt; &gt; &gt; [ 2040.698610] =A0[&lt;ffffffffa0474cf5&gt;] xfs_fs_put_supe=
r+0x25/0x60 [xfs]<br>
&gt; &gt; &gt; [ 2040.706838] =A0[&lt;ffffffff8119561e&gt;] generic_shutdow=
n_super+0x7e/0x100<br>
&gt; &gt; &gt; [ 2040.723958] =A0[&lt;ffffffff811956d0&gt;] kill_block_supe=
r+0x30/0x80<br>
&gt; &gt; &gt; [ 2040.734963] =A0[&lt;ffffffff8119591d&gt;] deactivate_lock=
ed_super+0x4d/0x80<br>
&gt; &gt; &gt; [ 2040.745485] =A0[&lt;ffffffff8119652e&gt;] deactivate_supe=
r+0x4e/0x70<br>
&gt; &gt; &gt; [ 2040.751274] =A0[&lt;ffffffff811b1d42&gt;] mntput_no_expir=
e+0xd2/0x160<br>
&gt; &gt; &gt; [ 2040.755894] =A0[&lt;ffffffff811b2fff&gt;] SyS_umount+0xaf=
/0x3b0<br>
&gt; &gt; &gt; [ 2040.761032] =A0[&lt;ffffffff816d1592&gt;] system_call_fas=
tpath+0x16/0x1b<br>
&gt; &gt; &gt; [ .060058] XFS (sdb): xfs_log_force: error 5 returned.<br>
&gt; &gt; &gt; [ 268059] XFS (sdb): xfs_log_force: error 5 returned.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I took a look at xfs_ail_push_all_sync and it is pretty easy=
 to see<br>
&gt; &gt; &gt; the hang. But it is not obvious to me how to fix it.<br>
&gt; &gt; &gt; Any ideas would be appreciated.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I am available to run additional tests or capture more loggi=
ng<br>
&gt; &gt; &gt; or whatever if that would help.<br>
&gt; &gt;<br>
&gt; &gt; What&#39;s the entire log output from the first shutdown message?=
<br>
<br>
</div></div>So what is the AIL stuck on? Can you trace the xfs_ail* trace p=
oints<br>
when it is in shutdown like this and post the output of the report?<br></bl=
ockquote><div>I will try to get this info.</div><div>Might take a couple of=
 days.</div><div>=A0</div><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<br>
&gt; [ 1318.816643] XFS (sdb): metadata I/O error: block 0x19fc80 (&quot;xf=
s_buf_iodone_callbacks&quot;) error 5 numblks 16<br>
&gt; [ 1318.818080] XFS (sdb): metadata I/O error: block 0x1025cf (&quot;xl=
og_iodone&quot;) error 5 numblks 64<br>
&gt; [ 1318.819350] XFS (sdb): xfs_do_force_shutdown(0x2) called from line =
1170 of file fs/xfs/xfs_log.c. =A0Return address =3D 0xffffffffa04b9859<br>
&gt; [ 1318.821089] XFS (sdb): Log I/O Error Detected. =A0Shutting down fil=
esystem<br>
&gt; [ 1318.822301] XFS (sdb): xfs_log_force: error 5 returned.<br>
&gt; [ 1318.822308] XFS (sdb): xfs_log_force: error 5 returned.<br>
&gt; [ 1318.822311] XFS (sdb): Detected failing async write on buffer block=
 0x19fca0. Retrying async write.<br>
<br>
That&#39;s the only thing that is unusual about the hang. Does this<br>
always appear when a hang occurs?<br></blockquote><div>I don&#39;t think so=
 but I have not been keeping all of the logs.</div><div>I will run the test=
 some more and see if it always appears or not.</div><div><br></div><div>
Thanks,</div><div>Bob</div><div>=A0</div><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div></div>

--089e013a0d40f94e9a04f8241d1d--


--===============7317677662003274580==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7317677662003274580==--
