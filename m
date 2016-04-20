Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2D6587CA0
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 00:50:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 885A9AC001
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 22:50:14 -0700 (PDT)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	ytu3rXL9AfFv3lF2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Apr 2016 22:50:09 -0700 (PDT)
Received: by mail-io0-f171.google.com with SMTP id 2so42057212ioy.1
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 22:50:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160419193435.GA2667@laptop.bfoster>
References: <CAJBkf_egQ1WdYHm5iRXCt4=CgraN4A=HfLvvsZxJEi7g4sUf5A@mail.gmail.com>
	<20160419113038.GA2649@laptop.bfoster>
	<CAJBkf_dEDTE-2qCObaHPZgmu50nW3HP-DPFNAPyaMfuLJX+7NQ@mail.gmail.com>
	<20160419193435.GA2667@laptop.bfoster>
From: Hugo Kuo <hugo@swiftstack.com>
Date: Wed, 20 Apr 2016 13:49:49 +0800
Message-ID: <CAJBkf_cNm3Xoun+PnzgdKEGz0zQx2JGNhS4KoTuDYjPm=78w+g@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============1569986956295862570=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Darrell Bishop <darrell@swiftstack.com>, xfs@oss.sgi.com

--===============1569986956295862570==
Content-Type: multipart/alternative; boundary=001a1141f3e09b81470530e42a03

--001a1141f3e09b81470530e42a03
Content-Type: text/plain; charset=UTF-8

Hi XFS team,


Here's the lsof output of the grouped result of any openfile happens on
problematic disks. The full log of xfs_repair -n is included in this gist
as well. The xfs_repair recommend to contact xfs mailing list in the end of
the command.

https://gist.github.com/HugoKuo/95613d7864aa0a1343615642b3309451

Perhaps I should go ahead to reboot the machine and run the xfs_repair
again.  Please find my answers inlines.


On Wed, Apr 20, 2016 at 3:34 AM, Brian Foster <bfoster@redhat.com> wrote:

>
> So there's definitely some traces waiting on AGF locks and whatnot, but
> also many traces that appear to be waiting on I/O. For example:
>

Yes, those I/O waiting is the original problem of this thread. It looks
like the disk was locked. All these I/O waiting for same disk (a multipath
entry).


>
> kernel: swift-object- D 0000000000000008     0  2096   1605 0x00000000
> kernel: ffff8877cc2378b8 0000000000000082 ffff8877cc237818 ffff887ff016eb68
> kernel: ffff883fd4ab6b28 0000000000000046 ffff883fd4bd9400 00000001e7ea49d0
> kernel: ffff8877cc237848 ffffffff812735d1 ffff885fa2e4a5f8 ffff8877cc237fd8
> kernel: Call Trace:
> kernel: [<ffffffff812735d1>] ? __blk_run_queue+0x31/0x40
> kernel: [<ffffffff81539455>] schedule_timeout+0x215/0x2e0
> kernel: [<ffffffff812757c9>] ? blk_peek_request+0x189/0x210
> kernel: [<ffffffff8126d9b3>] ? elv_queue_empty+0x33/0x40
> kernel: [<ffffffffa00040a0>] ? dm_request_fn+0x240/0x340 [dm_mod]
> kernel: [<ffffffff815390d3>] wait_for_common+0x123/0x180
> kernel: [<ffffffff810672b0>] ? default_wake_function+0x0/0x20
> kernel: [<ffffffffa0001036>] ? dm_unplug_all+0x36/0x50 [dm_mod]
> kernel: [<ffffffffa0415b56>] ? _xfs_buf_read+0x46/0x60 [xfs]
> kernel: [<ffffffffa040b417>] ? xfs_trans_read_buf+0x197/0x410 [xfs]
> kernel: [<ffffffff815391ed>] wait_for_completion+0x1d/0x20
> kernel: [<ffffffffa041503b>] xfs_buf_iowait+0x9b/0x100 [xfs]
> kernel: [<ffffffffa040b417>] ? xfs_trans_read_buf+0x197/0x410 [xfs]
> kernel: [<ffffffffa0415b56>] _xfs_buf_read+0x46/0x60 [xfs]
> kernel: [<ffffffffa0415c1b>] xfs_buf_read+0xab/0x100 [xfs]
>
>
> Are all of these swift processes running against independent storage, or
> one big array? Also, can you tell (e.g., with iotop) whether progress is
> being made here, albiet very slowly, or if the storage is indeed locked
> up..?
>
> There're 240+ swift processes in running.
All stuck swift processes were attempting to access same disk.  I can
confirm it's indeed locked rather than slowly. By monitoring io via iotop.
There's 0 activity one the problematic mount point.


> In any event, given the I/O hangs, the fact that you're on an old distro
> kernel and you have things like multipath enabled, it might be
> worthwhile to see if you can rule out any multipath issues.
>
>
To upgrade the kernel for CentOS6.5 may not the option for the time being
but it definitely worth to give it try by picking up one of nodes for
testing later. As for the multipath, yes I did suspect some mystery problem
with multipath + XFS under a certain loading. But it's more like a XFS and
inode related hence I start to investigate from XFS. If there's no chance
to move forward in XFS, I might break the multipath and observe the result
for awhile.


>
> 'umount -l' doesn't necessarily force anything. It just lazily unmounts
> the fs from the namespace and cleans up the mount once all references
> are dropped. I suspect the fs is still mounted internally.
>
> Brian
>
>
Thanks // Hugo

--001a1141f3e09b81470530e42a03
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi XFS team,=C2=A0</div><div><br></div><div><br></div=
><div>Here&#39;s the lsof output of the grouped result of any openfile happ=
ens on problematic disks. The full log of xfs_repair -n is included in this=
 gist as well. The xfs_repair recommend to contact xfs mailing list in the =
end of the command.=C2=A0</div><div><br></div><div><a href=3D"https://gist.=
github.com/HugoKuo/95613d7864aa0a1343615642b3309451">https://gist.github.co=
m/HugoKuo/95613d7864aa0a1343615642b3309451</a><br></div><div><br></div><div=
>Perhaps I should go ahead to reboot the machine and run the xfs_repair aga=
in.=C2=A0 Please find my answers inlines.=C2=A0</div><br><div class=3D"gmai=
l_extra"><br><div class=3D"gmail_quote"><font color=3D"#cccccc">On Wed, Apr=
 20, 2016 at 3:34 AM, Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:=
bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</span> wro=
te:<br></font><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px=
 0.8ex;border-left-width:1px;border-left-style:solid;border-left-color:rgb(=
204,204,204);padding-left:1ex"><font color=3D"#cccccc"><span class=3D""><br=
>
</span>So there&#39;s definitely some traces waiting on AGF locks and whatn=
ot, but<br>
also many traces that appear to be waiting on I/O. For example:<br></font><=
/blockquote><div><br></div><div>Yes, those I/O waiting is the original prob=
lem of this thread. It looks like the disk was locked. All these I/O waitin=
g for same disk (a multipath entry).</div><div>=C2=A0</div><blockquote clas=
s=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;b=
order-left-style:solid;border-left-color:rgb(204,204,204);padding-left:1ex"=
><font color=3D"#cccccc">
<br>
kernel: swift-object- D 0000000000000008=C2=A0 =C2=A0 =C2=A00=C2=A0 2096=C2=
=A0 =C2=A01605 0x00000000<br>
kernel: ffff8877cc2378b8 0000000000000082 ffff8877cc237818 ffff887ff016eb68=
<br>
kernel: ffff883fd4ab6b28 0000000000000046 ffff883fd4bd9400 00000001e7ea49d0=
<br>
kernel: ffff8877cc237848 ffffffff812735d1 ffff885fa2e4a5f8 ffff8877cc237fd8=
<br>
kernel: Call Trace:<br>
kernel: [&lt;ffffffff812735d1&gt;] ? __blk_run_queue+0x31/0x40<br>
kernel: [&lt;ffffffff81539455&gt;] schedule_timeout+0x215/0x2e0<br>
kernel: [&lt;ffffffff812757c9&gt;] ? blk_peek_request+0x189/0x210<br>
kernel: [&lt;ffffffff8126d9b3&gt;] ? elv_queue_empty+0x33/0x40<br>
kernel: [&lt;ffffffffa00040a0&gt;] ? dm_request_fn+0x240/0x340 [dm_mod]<br>
kernel: [&lt;ffffffff815390d3&gt;] wait_for_common+0x123/0x180<br>
kernel: [&lt;ffffffff810672b0&gt;] ? default_wake_function+0x0/0x20<br>
kernel: [&lt;ffffffffa0001036&gt;] ? dm_unplug_all+0x36/0x50 [dm_mod]<br>
kernel: [&lt;ffffffffa0415b56&gt;] ? _xfs_buf_read+0x46/0x60 [xfs]<br>
kernel: [&lt;ffffffffa040b417&gt;] ? xfs_trans_read_buf+0x197/0x410 [xfs]<b=
r>
kernel: [&lt;ffffffff815391ed&gt;] wait_for_completion+0x1d/0x20<br>
kernel: [&lt;ffffffffa041503b&gt;] xfs_buf_iowait+0x9b/0x100 [xfs]<br>
kernel: [&lt;ffffffffa040b417&gt;] ? xfs_trans_read_buf+0x197/0x410 [xfs]<b=
r>
kernel: [&lt;ffffffffa0415b56&gt;] _xfs_buf_read+0x46/0x60 [xfs]<br>
kernel: [&lt;ffffffffa0415c1b&gt;] xfs_buf_read+0xab/0x100 [xfs]<br><br>
<br>
Are all of these swift processes running against independent storage, or<br=
>
one big array? Also, can you tell (e.g., with iotop) whether progress is<br=
>
being made here, albiet very slowly, or if the storage is indeed locked<br>
up..?<br>
<br></font></blockquote><div>There&#39;re 240+ swift processes in running.=
=C2=A0</div><div>All stuck swift processes were attempting to access same d=
isk.=C2=A0 I can confirm it&#39;s indeed locked rather than slowly. By moni=
toring io via iotop. There&#39;s 0 activity one the problematic mount point=
.=C2=A0</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;border=
-left-color:rgb(204,204,204);padding-left:1ex"><font color=3D"#cccccc">
In any event, given the I/O hangs, the fact that you&#39;re on an old distr=
o<br>
kernel and you have things like multipath enabled, it might be<br>
worthwhile to see if you can rule out any multipath issues.<br><br></font><=
/blockquote><div><br></div><div>To upgrade the kernel for CentOS6.5 may not=
 the option for the time being but it definitely worth to give it try by pi=
cking up one of nodes for testing later. As for the multipath, yes I did su=
spect some mystery problem with multipath + XFS under a certain loading. Bu=
t it&#39;s more like a XFS and inode related hence I start to investigate f=
rom XFS. If there&#39;s no chance to move forward in XFS, I might break the=
 multipath and observe the result for awhile. =C2=A0</div><div>=C2=A0</div>=
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-style:solid;border-left-color:rgb(204,204,204);p=
adding-left:1ex"><font color=3D"#cccccc"><span class=3D""></span><br>
&#39;umount -l&#39; doesn&#39;t necessarily force anything. It just lazily =
unmounts<br>
the fs from the namespace and cleans up the mount once all references<br>
are dropped. I suspect the fs is still mounted internally.<br>
<span class=3D""><br>
Brian<br>
</span></font><div class=3D""><div class=3D"h5"><font color=3D"#cccccc"><br=
></font></div></div></blockquote><div><br></div><div>Thanks // Hugo=C2=A0</=
div></div></div></div>

--001a1141f3e09b81470530e42a03--


--===============1569986956295862570==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1569986956295862570==--
