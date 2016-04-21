Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 00D037CA0
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 00:55:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5CF6304051
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 22:55:07 -0700 (PDT)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com
	[209.85.223.182]) by cuda.sgi.com with ESMTP id
	REOlHhmrgc8Es6OR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Apr 2016 22:55:04 -0700 (PDT)
Received: by mail-io0-f182.google.com with SMTP id u185so75720411iod.3
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 22:55:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160420112445.GA2773@laptop.bfoster>
References: <CAJBkf_egQ1WdYHm5iRXCt4=CgraN4A=HfLvvsZxJEi7g4sUf5A@mail.gmail.com>
	<20160419113038.GA2649@laptop.bfoster>
	<CAJBkf_dEDTE-2qCObaHPZgmu50nW3HP-DPFNAPyaMfuLJX+7NQ@mail.gmail.com>
	<20160419193435.GA2667@laptop.bfoster>
	<CAJBkf_cNm3Xoun+PnzgdKEGz0zQx2JGNhS4KoTuDYjPm=78w+g@mail.gmail.com>
	<20160420112445.GA2773@laptop.bfoster>
From: Hugo Kuo <hugo@swiftstack.com>
Date: Thu, 21 Apr 2016 13:54:44 +0800
Message-ID: <CAJBkf_cTG0-iohJ8GjXvT8VDQK62tY-GrOVMHktR1Zo=zbGMMA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============2500999883290516543=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Darrell Bishop <darrell@swiftstack.com>, xfs@oss.sgi.com

--===============2500999883290516543==
Content-Type: multipart/alternative; boundary=001a113edfda0c1e340530f85aef

--001a113edfda0c1e340530f85aef
Content-Type: text/plain; charset=UTF-8

Hi Brian,

Here's the result of xfs_repair on the same disk after rebooting.
https://gist.github.com/HugoKuo/e1d683d9653e66a80dfcfcbee4294fe8
It's looks normal.

We rebooted the server and no hanging process in past 12hrs. I'll keep eyes
on the server.
I know it's helpful to to trace-cmd for xfs. But there's too may xfs
operations are happening in the server. It's crazy like 100MB data per
second. I stopped the trace-cmd. As you said, we need to find out the
source of the problem. trace-cmd would be a nice option. Is there a way to
flush recored data if nothing happens in the past hours ?

trace-cmd record -e xfs\*



Regards // Hugo




On Wed, Apr 20, 2016 at 7:24 PM, Brian Foster <bfoster@redhat.com> wrote:

> On Wed, Apr 20, 2016 at 01:49:49PM +0800, Hugo Kuo wrote:
> > Hi XFS team,
> >
> >
> > Here's the lsof output of the grouped result of any openfile happens on
> > problematic disks. The full log of xfs_repair -n is included in this gist
> > as well. The xfs_repair recommend to contact xfs mailing list in the end
> of
> > the command.
> >
> > https://gist.github.com/HugoKuo/95613d7864aa0a1343615642b3309451
> >
> > Perhaps I should go ahead to reboot the machine and run the xfs_repair
> > again.  Please find my answers inlines.
> >
>
> Yes, repair is crashing in this case. Best to try xfs_repair after
> you've rebooted and mounted/umounted the fs to replay the log. If it's
> still crashing at that point, we'll probably want a metadata image of
> the fs, if possible (though there's a good chance a newer xfsprogs has
> the problem fixed).
>
> >
> > On Wed, Apr 20, 2016 at 3:34 AM, Brian Foster <bfoster@redhat.com>
> wrote:
> >
> > >
> > > So there's definitely some traces waiting on AGF locks and whatnot, but
> > > also many traces that appear to be waiting on I/O. For example:
> > >
> >
> > Yes, those I/O waiting is the original problem of this thread. It looks
> > like the disk was locked. All these I/O waiting for same disk (a
> multipath
> > entry).
> >
> >
> > >
> > > kernel: swift-object- D 0000000000000008     0  2096   1605 0x00000000
> > > kernel: ffff8877cc2378b8 0000000000000082 ffff8877cc237818
> ffff887ff016eb68
> > > kernel: ffff883fd4ab6b28 0000000000000046 ffff883fd4bd9400
> 00000001e7ea49d0
> > > kernel: ffff8877cc237848 ffffffff812735d1 ffff885fa2e4a5f8
> ffff8877cc237fd8
> > > kernel: Call Trace:
> > > kernel: [<ffffffff812735d1>] ? __blk_run_queue+0x31/0x40
> > > kernel: [<ffffffff81539455>] schedule_timeout+0x215/0x2e0
> > > kernel: [<ffffffff812757c9>] ? blk_peek_request+0x189/0x210
> > > kernel: [<ffffffff8126d9b3>] ? elv_queue_empty+0x33/0x40
> > > kernel: [<ffffffffa00040a0>] ? dm_request_fn+0x240/0x340 [dm_mod]
> > > kernel: [<ffffffff815390d3>] wait_for_common+0x123/0x180
> > > kernel: [<ffffffff810672b0>] ? default_wake_function+0x0/0x20
> > > kernel: [<ffffffffa0001036>] ? dm_unplug_all+0x36/0x50 [dm_mod]
> > > kernel: [<ffffffffa0415b56>] ? _xfs_buf_read+0x46/0x60 [xfs]
> > > kernel: [<ffffffffa040b417>] ? xfs_trans_read_buf+0x197/0x410 [xfs]
> > > kernel: [<ffffffff815391ed>] wait_for_completion+0x1d/0x20
> > > kernel: [<ffffffffa041503b>] xfs_buf_iowait+0x9b/0x100 [xfs]
> > > kernel: [<ffffffffa040b417>] ? xfs_trans_read_buf+0x197/0x410 [xfs]
> > > kernel: [<ffffffffa0415b56>] _xfs_buf_read+0x46/0x60 [xfs]
> > > kernel: [<ffffffffa0415c1b>] xfs_buf_read+0xab/0x100 [xfs]
> > >
> > >
> > > Are all of these swift processes running against independent storage,
> or
> > > one big array? Also, can you tell (e.g., with iotop) whether progress
> is
> > > being made here, albiet very slowly, or if the storage is indeed locked
> > > up..?
> > >
> > > There're 240+ swift processes in running.
> > All stuck swift processes were attempting to access same disk.  I can
> > confirm it's indeed locked rather than slowly. By monitoring io via
> iotop.
> > There's 0 activity one the problematic mount point.
> >
> >
> > > In any event, given the I/O hangs, the fact that you're on an old
> distro
> > > kernel and you have things like multipath enabled, it might be
> > > worthwhile to see if you can rule out any multipath issues.
> > >
> > >
> > To upgrade the kernel for CentOS6.5 may not the option for the time being
> > but it definitely worth to give it try by picking up one of nodes for
> > testing later. As for the multipath, yes I did suspect some mystery
> problem
> > with multipath + XFS under a certain loading. But it's more like a XFS
> and
> > inode related hence I start to investigate from XFS. If there's no chance
> > to move forward in XFS, I might break the multipath and observe the
> result
> > for awhile.
> >
>
> It's hard to pinpoint something to the fs when there's a bunch of hung
> I/Os. You probably want to track down the source of those problems
> first.
>
> Brian
>
> >
> > >
> > > 'umount -l' doesn't necessarily force anything. It just lazily unmounts
> > > the fs from the namespace and cleans up the mount once all references
> > > are dropped. I suspect the fs is still mounted internally.
> > >
> > > Brian
> > >
> > >
> > Thanks // Hugo
>

--001a113edfda0c1e340530f85aef
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Brian,<div><br></div><div>Here&#39;s the result of xfs_=
repair on the same disk after rebooting. <a href=3D"https://gist.github.com=
/HugoKuo/e1d683d9653e66a80dfcfcbee4294fe8">https://gist.github.com/HugoKuo/=
e1d683d9653e66a80dfcfcbee4294fe8</a>=C2=A0</div><div>It&#39;s looks normal.=
=C2=A0</div><div><br></div><div>We rebooted the server and no hanging proce=
ss in past 12hrs. I&#39;ll keep eyes on the server.=C2=A0</div><div>I know =
it&#39;s helpful to to trace-cmd for xfs. But there&#39;s too may xfs opera=
tions are happening in the server. It&#39;s crazy like 100MB data per secon=
d. I stopped the trace-cmd. As you said, we need to find out the source of =
the problem. trace-cmd would be a nice option. Is there a way to flush reco=
red data if nothing happens in the past hours ?</div><div><br></div><pre st=
yle=3D"font-family:monospace,Courier;padding:1em;border:1px dashed rgb(47,1=
11,171);color:rgb(0,0,0);line-height:1.1em;font-size:12.7px;background-colo=
r:rgb(249,249,249)">trace-cmd record -e xfs\*<br></pre><div><br></div><div>=
<br></div><div>Regards // Hugo</div><div><br></div><div>=C2=A0<div><br></di=
v></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On =
Wed, Apr 20, 2016 at 7:24 PM, Brian Foster <span dir=3D"ltr">&lt;<a href=3D=
"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</s=
pan> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Wed, Apr =
20, 2016 at 01:49:49PM +0800, Hugo Kuo wrote:<br>
&gt; Hi XFS team,<br>
&gt;<br>
&gt;<br>
&gt; Here&#39;s the lsof output of the grouped result of any openfile happe=
ns on<br>
&gt; problematic disks. The full log of xfs_repair -n is included in this g=
ist<br>
&gt; as well. The xfs_repair recommend to contact xfs mailing list in the e=
nd of<br>
&gt; the command.<br>
&gt;<br>
&gt; <a href=3D"https://gist.github.com/HugoKuo/95613d7864aa0a1343615642b33=
09451" rel=3D"noreferrer" target=3D"_blank">https://gist.github.com/HugoKuo=
/95613d7864aa0a1343615642b3309451</a><br>
&gt;<br>
&gt; Perhaps I should go ahead to reboot the machine and run the xfs_repair=
<br>
&gt; again.=C2=A0 Please find my answers inlines.<br>
&gt;<br>
<br>
</span>Yes, repair is crashing in this case. Best to try xfs_repair after<b=
r>
you&#39;ve rebooted and mounted/umounted the fs to replay the log. If it&#3=
9;s<br>
still crashing at that point, we&#39;ll probably want a metadata image of<b=
r>
the fs, if possible (though there&#39;s a good chance a newer xfsprogs has<=
br>
the problem fixed).<br>
<div><div class=3D"h5"><br>
&gt;<br>
&gt; On Wed, Apr 20, 2016 at 3:34 AM, Brian Foster &lt;<a href=3D"mailto:bf=
oster@redhat.com">bfoster@redhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt;<br>
&gt; &gt; So there&#39;s definitely some traces waiting on AGF locks and wh=
atnot, but<br>
&gt; &gt; also many traces that appear to be waiting on I/O. For example:<b=
r>
&gt; &gt;<br>
&gt;<br>
&gt; Yes, those I/O waiting is the original problem of this thread. It look=
s<br>
&gt; like the disk was locked. All these I/O waiting for same disk (a multi=
path<br>
&gt; entry).<br>
&gt;<br>
&gt;<br>
&gt; &gt;<br>
&gt; &gt; kernel: swift-object- D 0000000000000008=C2=A0 =C2=A0 =C2=A00=C2=
=A0 2096=C2=A0 =C2=A01605 0x00000000<br>
&gt; &gt; kernel: ffff8877cc2378b8 0000000000000082 ffff8877cc237818 ffff88=
7ff016eb68<br>
&gt; &gt; kernel: ffff883fd4ab6b28 0000000000000046 ffff883fd4bd9400 000000=
01e7ea49d0<br>
&gt; &gt; kernel: ffff8877cc237848 ffffffff812735d1 ffff885fa2e4a5f8 ffff88=
77cc237fd8<br>
&gt; &gt; kernel: Call Trace:<br>
&gt; &gt; kernel: [&lt;ffffffff812735d1&gt;] ? __blk_run_queue+0x31/0x40<br=
>
&gt; &gt; kernel: [&lt;ffffffff81539455&gt;] schedule_timeout+0x215/0x2e0<b=
r>
&gt; &gt; kernel: [&lt;ffffffff812757c9&gt;] ? blk_peek_request+0x189/0x210=
<br>
&gt; &gt; kernel: [&lt;ffffffff8126d9b3&gt;] ? elv_queue_empty+0x33/0x40<br=
>
&gt; &gt; kernel: [&lt;ffffffffa00040a0&gt;] ? dm_request_fn+0x240/0x340 [d=
m_mod]<br>
&gt; &gt; kernel: [&lt;ffffffff815390d3&gt;] wait_for_common+0x123/0x180<br=
>
&gt; &gt; kernel: [&lt;ffffffff810672b0&gt;] ? default_wake_function+0x0/0x=
20<br>
&gt; &gt; kernel: [&lt;ffffffffa0001036&gt;] ? dm_unplug_all+0x36/0x50 [dm_=
mod]<br>
&gt; &gt; kernel: [&lt;ffffffffa0415b56&gt;] ? _xfs_buf_read+0x46/0x60 [xfs=
]<br>
&gt; &gt; kernel: [&lt;ffffffffa040b417&gt;] ? xfs_trans_read_buf+0x197/0x4=
10 [xfs]<br>
&gt; &gt; kernel: [&lt;ffffffff815391ed&gt;] wait_for_completion+0x1d/0x20<=
br>
&gt; &gt; kernel: [&lt;ffffffffa041503b&gt;] xfs_buf_iowait+0x9b/0x100 [xfs=
]<br>
&gt; &gt; kernel: [&lt;ffffffffa040b417&gt;] ? xfs_trans_read_buf+0x197/0x4=
10 [xfs]<br>
&gt; &gt; kernel: [&lt;ffffffffa0415b56&gt;] _xfs_buf_read+0x46/0x60 [xfs]<=
br>
&gt; &gt; kernel: [&lt;ffffffffa0415c1b&gt;] xfs_buf_read+0xab/0x100 [xfs]<=
br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; Are all of these swift processes running against independent stor=
age, or<br>
&gt; &gt; one big array? Also, can you tell (e.g., with iotop) whether prog=
ress is<br>
&gt; &gt; being made here, albiet very slowly, or if the storage is indeed =
locked<br>
&gt; &gt; up..?<br>
&gt; &gt;<br>
&gt; &gt; There&#39;re 240+ swift processes in running.<br>
&gt; All stuck swift processes were attempting to access same disk.=C2=A0 I=
 can<br>
&gt; confirm it&#39;s indeed locked rather than slowly. By monitoring io vi=
a iotop.<br>
&gt; There&#39;s 0 activity one the problematic mount point.<br>
&gt;<br>
&gt;<br>
&gt; &gt; In any event, given the I/O hangs, the fact that you&#39;re on an=
 old distro<br>
&gt; &gt; kernel and you have things like multipath enabled, it might be<br=
>
&gt; &gt; worthwhile to see if you can rule out any multipath issues.<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; To upgrade the kernel for CentOS6.5 may not the option for the time be=
ing<br>
&gt; but it definitely worth to give it try by picking up one of nodes for<=
br>
&gt; testing later. As for the multipath, yes I did suspect some mystery pr=
oblem<br>
&gt; with multipath + XFS under a certain loading. But it&#39;s more like a=
 XFS and<br>
&gt; inode related hence I start to investigate from XFS. If there&#39;s no=
 chance<br>
&gt; to move forward in XFS, I might break the multipath and observe the re=
sult<br>
&gt; for awhile.<br>
&gt;<br>
<br>
</div></div>It&#39;s hard to pinpoint something to the fs when there&#39;s =
a bunch of hung<br>
I/Os. You probably want to track down the source of those problems<br>
first.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Brian<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt;<br>
&gt; &gt;<br>
&gt; &gt; &#39;umount -l&#39; doesn&#39;t necessarily force anything. It ju=
st lazily unmounts<br>
&gt; &gt; the fs from the namespace and cleans up the mount once all refere=
nces<br>
&gt; &gt; are dropped. I suspect the fs is still mounted internally.<br>
&gt; &gt;<br>
&gt; &gt; Brian<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; Thanks // Hugo<br>
</div></div></blockquote></div><br></div>

--001a113edfda0c1e340530f85aef--


--===============2500999883290516543==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2500999883290516543==--
