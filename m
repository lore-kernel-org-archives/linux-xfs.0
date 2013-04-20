Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 430F129DFA
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 08:12:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 203DC304051
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 06:12:38 -0700 (PDT)
Received: from mail-ie0-f182.google.com (mail-ie0-f182.google.com
	[209.85.223.182]) by cuda.sgi.com with ESMTP id
	q1EzENYRxpk4DoRJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 20 Apr 2013 06:12:36 -0700 (PDT)
Received: by mail-ie0-f182.google.com with SMTP id bn7so3501138ieb.41
	for <xfs@oss.sgi.com>; Sat, 20 Apr 2013 06:12:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <517290F8.4010407@redhat.com>
References: <516C89DF.4070904@redhat.com> <51716DCB.4060407@sandeen.net>
	<CADFMGuJH106wg7zVQrt604DxvDWB_bnor==NEGpJ1Xcr9b+C8A@mail.gmail.com>
	<CADFMGuLcve0a5uiOzZYoVze8tm1UXTPxhEqForMWYsvCyuh0sg@mail.gmail.com>
	<5171790C.70400@sandeen.net>
	<CADFMGuKfyw-mCsRn1Y5H5ek+z_nRMHDmW4bG-Ez9ANJm7_ec5A@mail.gmail.com>
	<CADFMGuL4+vSH9ZpWODXWbHVz9ndMcg2aZY9b0ccq74SJp3XzEw@mail.gmail.com>
	<CADFMGuK7FEbWibRrctK7B=XXAfAKtpjRej3NVB2k7JXhhYFLLg@mail.gmail.com>
	<CADFMGuJozkBQdp5o_BK7HbrPdv6iKUie=jHyz5LrtBBvHY1b4w@mail.gmail.com>
	<CADFMGuL05J+b=bv5jAneLT451eQFNNz2RNHQHccBOjqWsE68Kw@mail.gmail.com>
	<51720E49.9020001@sandeen.net>
	<CADFMGu+9SGHJEPtUzuR3eObNwfs6VE0TmJNhJh_vxQ3+KBwocA@mail.gmail.com>
	<51721798.1060501@sandeen.net>
	<CADFMGuJAXcA0CTYEoaRNvsTv7DhHeOBgk+j_HiMceT1neoEzRQ@mail.gmail.com>
	<CADFMGuLBat2fWbtpRd=Sb0bQpZiTOdF2p8NA97rak8A=+GhN1A@mail.gmail.com>
	<51727E32.8080306@redhat.com>
	<CADFMGuKE=1RCAfXW9iLMRW9MdjMk936F4jZw12adHpQ+wkNyWw@mail.gmail.com>
	<517290F8.4010407@redhat.com>
Date: Sat, 20 Apr 2013 21:12:35 +0800
Message-ID: <CADFMGu+OvtLG1f5xNmeVR-dV_W_afy2Cv4LsdvvmGL-Vwpz0vg@mail.gmail.com>
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5899760926032705825=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5899760926032705825==
Content-Type: multipart/alternative; boundary=14dae9340865d8a4a404daca966e

--14dae9340865d8a4a404daca966e
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Hi Brian,
Yes, this directory (./crashtest/.glusterfs/indices) is glusterfs
index-base directory for glusterfs features/index xlator.The
./crashtest/.glusterfs/indices/xattrop directory is XATTROP_SUBDIR
directory for glusterfs. This path can be set in glusterfs server-side
volume file so before there're any progresses I'll try to isolate this
issue by try to set it to a ext4 path or somewhere else.
Thank you.


2013/4/20 Brian Foster <bfoster@redhat.com>

> On 04/20/2013 07:52 AM, =B7=FB=D3=C0=CC=CE wrote:
> > Hi Brain,
> > Here is the file:
> > find . -inum 539274
> > ./crashtest/.glusterfs/indices/xattrop
> > [root@10.23.72.94 <mailto:root@10.23.72.94> xfsd]# ls -lih
> > ./crashtest/.glusterfs/indices/xattrop
> > total 0
> > 539275 ---------- 2 root root 0 Apr 20 17:17
> > 132ef294-71d1-4435-8daa-aa002e67cb6e
> > 539275 ---------- 2 root root 0 Apr 20 17:17
> > xattrop-f3ad589a-b8dc-4416-ab84-fc9ad4033540
> > find . -inum 539275
> >
> ./crashtest/.glusterfs/indices/xattrop/xattrop-f3ad589a-b8dc-4416-ab84-fc=
9ad4033540
> >
> ./crashtest/.glusterfs/indices/xattrop/132ef294-71d1-4435-8daa-aa002e67cb=
6e
> > I'm not sure if it is normal or glusterfs fall in infinite loop. Is
> > there a change that the kernel fall into dead loop?
> > I'll study it.
> >
>
> Very interesting, thank you. I don't have the full context here yet, but
> the short of it is that this particular indices/xattrop directory is
> managed by a backend translator and driven by replication. It appears to
> be doing some kind of transaction level tracking based on links. E.g.,
> some quick behavioral observations:
>
> - This directory is created and an xattrop-#### file created (no size).
> - On starting a large sequential write from a client, I start observing
> a continuous sequence of xfs_link/xfs_remove operations via tracing.
> - The backend appears to create a link to the xattr-#### file for every
> replication transaction (handwave) with the name of the link referring
> to the gfid name of the file under write (but note again the link is not
> to the inode under write, but this special xattr-#### file). It then
> apparently removes this link on transaction completion and the process
> repeats. I suspect this has to do with identifying what files were under
> modification in the event of a crash before transaction completion, but
> the underlying pattern/workload is what's more important to us here for
> the time being...
>
> So we're seeing a heavy link related workload on a directory inode
> (0x83a8a) where the entries are all links to the same inode (0x83a8b).
> These inodes happen to be close in proximity, which may or may not be a
> factor. The translator that generates these link/unlink ops sits right
> above a generic thread pool translator, so this is multi-threaded.
>
> What isn't clear to me yet is where the xfs_iunlink() for this heavily
> linked inode is induced. The primary dentry remains after my file copy
> test, but then taking another look after a few minutes I see it removed.
> The same thing occurs if I gracefully restart the volume. I'm going to
> have to dig into that some more and also see if we can use this to
> narrow in on a reproducer. I'm thinking something along the lines of:
>
> - Create a directory/file. Ideally the directory and file inodes are in
> the same cluster.
> - Start a highly-threaded link-unlink workload against that file in the
> same directory.
> - Somewhere in the background unlink the main file.
> - Check for multiple xfs_iunlink() ops, repeat.
>
> ... the assumption being that the xfs_iunlink() race could have lead to
> a possible unlinked list corruption on the associated list, such that a
> later inactivation/xfs_iunlink_remove of some other inode in that bucket
> could fail.
>
> Brian
>
> >
> > 2013/4/20 Brian Foster <bfoster@redhat.com <mailto:bfoster@redhat.com>>
> >
> >     On 04/20/2013 06:10 AM, =B7=FB=D3=C0=CC=CE wrote:
> >     > Dear Eric,
> >     > I have applied your latest patch and collected the following log:
> >     >
> >     > /var/log/message
> >     > Apr 20 17:28:23 10 kernel: XFS (sdb): xfs_iunlink_remove:
> >     xfs_inotobp()
> >     > returned error 22 for inode 0x1b20b ag 0 agino 1b20b
> >     > Apr 20 17:28:23 10 kernel:
> >     > Apr 20 17:28:23 10 kernel: XFS (sdb): xfs_inactive: xfs_ifree
> returned
> >     > error 22
> >     > Apr 20 17:28:23 10 kernel: XFS (sdb): xfs_do_force_shutdown(0x1)
> >     called
> >     > from line 1184 of file fs/xfs/xfs_vnodeops.c.  Return address =3D
> >     > 0xffffffffa02d4d0a
> >     > Apr 20 17:28:23 10 kernel: XFS (sdb): I/O Error Detected. Shuttin=
g
> >     down
> >     > filesystem
> >     > Apr 20 17:28:23 10 kernel: XFS (sdb): Please umount the filesyste=
m
> and
> >     > rectify the problem(s)
> >     > Apr 20 17:28:37 10 kernel: XFS (sdb): xfs_log_force: error 5
> returned.
> >     > Apr 20 17:29:07 10 kernel: XFS (sdb): xfs_log_force: error 5
> returned.
> >     > Apr 20 17:29:37 10 kernel: XFS (sdb): xfs_log_force: error 5
> returned.
> >     > Apr 20 17:30:07 10 kernel: XFS (sdb): xfs_log_force: error 5
> returned.
> >     >
> >     > debugfs trace:
> >     >
> >
> https://docs.google.com/file/d/0B7n2C4T5tfNCTlZGUVpnZENrZ3M/edit?usp=3Dsh=
aring
> >     >
> >
> >     FWIW...
> >
> >     <...>-6908  [001]  8739.967623: xfs_iunlink: dev 8:16 ino 0x83a8b
> mode
> >     0100000, flags 0x0
> >     <...>-6909  [001]  8739.970252: xfs_iunlink: dev 8:16 ino 0x83a8b
> mode
> >     0100000, flags 0x0
> >
> >     0x83a8b and 0x1b20b both hash to unlinked list bucket 11.
> >
> >     As to the rest of the trace, there appears to be a significant
> amount of
> >     link activity on (directory) inode 0x83a8a (the immediately prior
> inode
> >     to the inode involved in the race). The name data in the trace
> suggests
> >     activity somewhere under .glusterfs. A couple questions:
> >
> >     1.) Any idea what entries point to this inode right now (e.g., how
> many
> >     links on this inode) and where it resides in the fs (path)?
> >
> >     2.) Can you associate this kind of heavy remove/link pattern on a
> single
> >     inode to a higher level activity? For example, if you were to watch
> the
> >     trace data live, is this a normal pattern you observe? Does it only
> >     occur when a rebalance is in progress? Or when a rebalance finishes=
?
> Any
> >     detailed observations you can make in that regard could be helpful.
> >
> >     Brian
> >
> >     > Thank you.
> >     >
> >     >
> >     > 2013/4/20 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtao=
fu@gmail.com>
> >     <mailto:yongtaofu@gmail.com <mailto:yongtaofu@gmail.com>>>
> >     >
> >     >     Hi Eric,
> >     >     The xfs module is loaded from system kernel, it happens on ou=
r
> >     >     production server too (I did not touch that till now) and if
> >     the xfs
> >     >     module is mess up the systemstap may also not working but now
> it
> >     >     works. As you have mentioned, strange thing is xfs shutdown
> always
> >     >     happens when glusterfs rebalance completes.
> >     >
> >     >
> >     >     2013/4/20 Eric Sandeen <sandeen@sandeen.net
> >     <mailto:sandeen@sandeen.net>
> >     >     <mailto:sandeen@sandeen.net <mailto:sandeen@sandeen.net>>>
> >     >
> >     >         On 4/19/13 9:03 PM, =B7=FB=D3=C0=CC=CE wrote:
> >     >         > Hi Eric,
> >     >         > I will enable them and run test again. I can only
> >     reproduce it
> >     >         with
> >     >         > glusterfs rebalance. Glusterfs uses a mechanism it call=
ed
> >     >         syncop to
> >     >         > unlink file. For rebalance it uses
> >     >         > syncop_unlink(glusterfs/libglusterfs/src/syncop.c). In
> the
> >     >         glusterfs
> >     >         > sync_task framework(glusterfs/libglusterfs/src/syncop.c=
)
> >     it uses
> >     >         > "makecontext/swapcontext"
> >     >         >
> >     >
> >     <
> http://www.opengroup.org/onlinepubs/009695399/functions/makecontext.html>=
.
> >     >         > Does it leads to racing unlink from different CPU core?
> >     >
> >     >         Yep, I understand that it's rebalance.  It dies when
> rebalance
> >     >         finishes because an
> >     >         open but unlinked file trips over the corrupted list from
> >     >         earlier, it seems.
> >     >
> >     >         I don't know why makecontext would matter...
> >     >
> >     >         Just to be sure, you are definitely loading the xfs modul=
e
> >     from
> >     >         the kernel you built, right, and you don't have a
> "priority"
> >     >         module getting loaded from elsewhere?  Seems unlikely, bu=
t
> >     just
> >     >         to be sure.
> >     >
> >     >         > Thank you.
> >     >
> >     >         You could also add this patch to the xfs tracepoints to
> print
> >     >         more information about the inodes - the mode & flags.
> >     >
> >     >         -Eric
> >     >
> >     >
> >     >         diff --git a/fs/xfs/linux-2.6/xfs_trace.h
> >     >         b/fs/xfs/linux-2.6/xfs_trace.h
> >     >         index e8ce644..c314b87 100644
> >     >         --- a/fs/xfs/linux-2.6/xfs_trace.h
> >     >         +++ b/fs/xfs/linux-2.6/xfs_trace.h
> >     >         @@ -544,14 +544,18 @@ DECLARE_EVENT_CLASS(xfs_inode_class=
,
> >     >                 TP_STRUCT__entry(
> >     >                         __field(dev_t, dev)
> >     >                         __field(xfs_ino_t, ino)
> >     >         +               __field(__u16, mode)
> >     >         +               __field(unsigned long, flags)
> >     >                 ),
> >     >                 TP_fast_assign(
> >     >                         __entry->dev =3D VFS_I(ip)->i_sb->s_dev;
> >     >                         __entry->ino =3D ip->i_ino;
> >     >         +               __entry->mode =3D VFS_I(ip)->i_mode;
> >     >         +               __entry->flags =3D ip->i_flags;
> >     >                 ),
> >     >         -       TP_printk("dev %d:%d ino 0x%llx",
> >     >         +       TP_printk("dev %d:%d ino 0x%llx mode 0%o, flags
> >     0x%lx",
> >     >                           MAJOR(__entry->dev), MINOR(__entry->dev=
),
> >     >         -                 __entry->ino)
> >     >         +                 __entry->ino, __entry->mode,
> __entry->flags)
> >     >          )
> >     >
> >     >          #define DEFINE_INODE_EVENT(name) \
> >     >
> >     >
> >     >
> >     >
> >     >
> >     >
> >     >     --
> >     >     =B7=FB=D3=C0=CC=CE
> >     >
> >     >
> >     >
> >     >
> >     > --
> >     > =B7=FB=D3=C0=CC=CE
> >
> >
> >
> >
> > --
> > =B7=FB=D3=C0=CC=CE
>
>


--=20
=B7=FB=D3=C0=CC=CE

--14dae9340865d8a4a404daca966e
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Brian,<br></div><div>Yes, this directory (./crasht=
est/.glusterfs/indices) is glusterfs index-base directory for glusterfs fea=
tures/index xlator.The ./crashtest/.glusterfs/indices/xattrop directory is =
XATTROP_SUBDIR directory for glusterfs. This path can be set in glusterfs s=
erver-side volume file so before there&#39;re any progresses I&#39;ll try t=
o isolate this issue by try to set it to a ext4 path or somewhere else.<br>
</div><div>Thank you.<br></div></div><div class=3D"gmail_extra"><br><br><di=
v class=3D"gmail_quote">2013/4/20 Brian Foster <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt=
;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 04/20/2013 07:52 AM, =
=B7=FB=D3=C0=CC=CE wrote:<br>
&gt; Hi Brain,<br>
&gt; Here is the file:<br>
&gt; find . -inum 539274<br>
&gt; ./crashtest/.glusterfs/indices/xattrop<br>
</div>&gt; [<a href=3D"mailto:root@10.23.72.94">root@10.23.72.94</a> &lt;ma=
ilto:<a href=3D"mailto:root@10.23.72.94">root@10.23.72.94</a>&gt; xfsd]# ls=
 -lih<br>
<div class=3D"im">&gt; ./crashtest/.glusterfs/indices/xattrop<br>
&gt; total 0<br>
&gt; 539275 ---------- 2 root root 0 Apr 20 17:17<br>
&gt; 132ef294-71d1-4435-8daa-aa002e67cb6e<br>
&gt; 539275 ---------- 2 root root 0 Apr 20 17:17<br>
&gt; xattrop-f3ad589a-b8dc-4416-ab84-fc9ad4033540<br>
&gt; find . -inum 539275<br>
&gt; ./crashtest/.glusterfs/indices/xattrop/xattrop-f3ad589a-b8dc-4416-ab84=
-fc9ad4033540<br>
&gt; ./crashtest/.glusterfs/indices/xattrop/132ef294-71d1-4435-8daa-aa002e6=
7cb6e<br>
&gt; I&#39;m not sure if it is normal or glusterfs fall in infinite loop. I=
s<br>
&gt; there a change that the kernel fall into dead loop?<br>
&gt; I&#39;ll study it.<br>
&gt;<br>
<br>
</div>Very interesting, thank you. I don&#39;t have the full context here y=
et, but<br>
the short of it is that this particular indices/xattrop directory is<br>
managed by a backend translator and driven by replication. It appears to<br=
>
be doing some kind of transaction level tracking based on links. E.g.,<br>
some quick behavioral observations:<br>
<br>
- This directory is created and an xattrop-#### file created (no size).<br>
- On starting a large sequential write from a client, I start observing<br>
a continuous sequence of xfs_link/xfs_remove operations via tracing.<br>
- The backend appears to create a link to the xattr-#### file for every<br>
replication transaction (handwave) with the name of the link referring<br>
to the gfid name of the file under write (but note again the link is not<br=
>
to the inode under write, but this special xattr-#### file). It then<br>
apparently removes this link on transaction completion and the process<br>
repeats. I suspect this has to do with identifying what files were under<br=
>
modification in the event of a crash before transaction completion, but<br>
the underlying pattern/workload is what&#39;s more important to us here for=
<br>
the time being...<br>
<br>
So we&#39;re seeing a heavy link related workload on a directory inode<br>
(0x83a8a) where the entries are all links to the same inode (0x83a8b).<br>
These inodes happen to be close in proximity, which may or may not be a<br>
factor. The translator that generates these link/unlink ops sits right<br>
above a generic thread pool translator, so this is multi-threaded.<br>
<br>
What isn&#39;t clear to me yet is where the xfs_iunlink() for this heavily<=
br>
linked inode is induced. The primary dentry remains after my file copy<br>
test, but then taking another look after a few minutes I see it removed.<br=
>
The same thing occurs if I gracefully restart the volume. I&#39;m going to<=
br>
have to dig into that some more and also see if we can use this to<br>
narrow in on a reproducer. I&#39;m thinking something along the lines of:<b=
r>
<br>
- Create a directory/file. Ideally the directory and file inodes are in<br>
the same cluster.<br>
- Start a highly-threaded link-unlink workload against that file in the<br>
same directory.<br>
- Somewhere in the background unlink the main file.<br>
- Check for multiple xfs_iunlink() ops, repeat.<br>
<br>
... the assumption being that the xfs_iunlink() race could have lead to<br>
a possible unlinked list corruption on the associated list, such that a<br>
later inactivation/xfs_iunlink_remove of some other inode in that bucket<br=
>
could fail.<br>
<br>
Brian<br>
<br>
&gt;<br>
&gt; 2013/4/20 Brian Foster &lt;<a href=3D"mailto:bfoster@redhat.com">bfost=
er@redhat.com</a> &lt;mailto:<a href=3D"mailto:bfoster@redhat.com">bfoster@=
redhat.com</a>&gt;&gt;<br>
<div><div class=3D"h5">&gt;<br>
&gt; &nbsp; &nbsp; On 04/20/2013 06:10 AM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; &nbsp; &nbsp; &gt; Dear Eric,<br>
&gt; &nbsp; &nbsp; &gt; I have applied your latest patch and collected the =
following log:<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; /var/log/message<br>
&gt; &nbsp; &nbsp; &gt; Apr 20 17:28:23 10 kernel: XFS (sdb): xfs_iunlink_r=
emove:<br>
&gt; &nbsp; &nbsp; xfs_inotobp()<br>
&gt; &nbsp; &nbsp; &gt; returned error 22 for inode 0x1b20b ag 0 agino 1b20=
b<br>
&gt; &nbsp; &nbsp; &gt; Apr 20 17:28:23 10 kernel:<br>
&gt; &nbsp; &nbsp; &gt; Apr 20 17:28:23 10 kernel: XFS (sdb): xfs_inactive:=
 xfs_ifree returned<br>
&gt; &nbsp; &nbsp; &gt; error 22<br>
&gt; &nbsp; &nbsp; &gt; Apr 20 17:28:23 10 kernel: XFS (sdb): xfs_do_force_=
shutdown(0x1)<br>
&gt; &nbsp; &nbsp; called<br>
&gt; &nbsp; &nbsp; &gt; from line 1184 of file fs/xfs/xfs_vnodeops.c. &nbsp=
;Return address =3D<br>
&gt; &nbsp; &nbsp; &gt; 0xffffffffa02d4d0a<br>
&gt; &nbsp; &nbsp; &gt; Apr 20 17:28:23 10 kernel: XFS (sdb): I/O Error Det=
ected. Shutting<br>
&gt; &nbsp; &nbsp; down<br>
&gt; &nbsp; &nbsp; &gt; filesystem<br>
&gt; &nbsp; &nbsp; &gt; Apr 20 17:28:23 10 kernel: XFS (sdb): Please umount=
 the filesystem and<br>
&gt; &nbsp; &nbsp; &gt; rectify the problem(s)<br>
&gt; &nbsp; &nbsp; &gt; Apr 20 17:28:37 10 kernel: XFS (sdb): xfs_log_force=
: error 5 returned.<br>
&gt; &nbsp; &nbsp; &gt; Apr 20 17:29:07 10 kernel: XFS (sdb): xfs_log_force=
: error 5 returned.<br>
&gt; &nbsp; &nbsp; &gt; Apr 20 17:29:37 10 kernel: XFS (sdb): xfs_log_force=
: error 5 returned.<br>
&gt; &nbsp; &nbsp; &gt; Apr 20 17:30:07 10 kernel: XFS (sdb): xfs_log_force=
: error 5 returned.<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; debugfs trace:<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; <a href=3D"https://docs.google.com/file/d/0B7n2C4T5tfNCT=
lZGUVpnZENrZ3M/edit?usp=3Dsharing" target=3D"_blank">https://docs.google.co=
m/file/d/0B7n2C4T5tfNCTlZGUVpnZENrZ3M/edit?usp=3Dsharing</a><br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; FWIW...<br>
&gt;<br>
&gt; &nbsp; &nbsp; &lt;...&gt;-6908 &nbsp;[001] &nbsp;8739.967623: xfs_iunl=
ink: dev 8:16 ino 0x83a8b mode<br>
&gt; &nbsp; &nbsp; 0100000, flags 0x0<br>
&gt; &nbsp; &nbsp; &lt;...&gt;-6909 &nbsp;[001] &nbsp;8739.970252: xfs_iunl=
ink: dev 8:16 ino 0x83a8b mode<br>
&gt; &nbsp; &nbsp; 0100000, flags 0x0<br>
&gt;<br>
&gt; &nbsp; &nbsp; 0x83a8b and 0x1b20b both hash to unlinked list bucket 11=
.<br>
&gt;<br>
&gt; &nbsp; &nbsp; As to the rest of the trace, there appears to be a signi=
ficant amount of<br>
&gt; &nbsp; &nbsp; link activity on (directory) inode 0x83a8a (the immediat=
ely prior inode<br>
&gt; &nbsp; &nbsp; to the inode involved in the race). The name data in the=
 trace suggests<br>
&gt; &nbsp; &nbsp; activity somewhere under .glusterfs. A couple questions:=
<br>
&gt;<br>
&gt; &nbsp; &nbsp; 1.) Any idea what entries point to this inode right now =
(e.g., how many<br>
&gt; &nbsp; &nbsp; links on this inode) and where it resides in the fs (pat=
h)?<br>
&gt;<br>
&gt; &nbsp; &nbsp; 2.) Can you associate this kind of heavy remove/link pat=
tern on a single<br>
&gt; &nbsp; &nbsp; inode to a higher level activity? For example, if you we=
re to watch the<br>
&gt; &nbsp; &nbsp; trace data live, is this a normal pattern you observe? D=
oes it only<br>
&gt; &nbsp; &nbsp; occur when a rebalance is in progress? Or when a rebalan=
ce finishes? Any<br>
&gt; &nbsp; &nbsp; detailed observations you can make in that regard could =
be helpful.<br>
&gt;<br>
&gt; &nbsp; &nbsp; Brian<br>
&gt;<br>
&gt; &nbsp; &nbsp; &gt; Thank you.<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; 2013/4/20 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:=
yongtaofu@gmail.com">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailto:y=
ongtaofu@gmail.com">yongtaofu@gmail.com</a>&gt;<br>
</div></div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:yongtaofu@gmail=
.com">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailto:yongtaofu@gmail.=
com">yongtaofu@gmail.com</a>&gt;&gt;&gt;<br>
<div class=3D"im">&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; Hi Eric,<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; The xfs module is loaded from system =
kernel, it happens on our<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; production server too (I did not touc=
h that till now) and if<br>
&gt; &nbsp; &nbsp; the xfs<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; module is mess up the systemstap may =
also not working but now it<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; works. As you have mentioned, strange=
 thing is xfs shutdown always<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; happens when glusterfs rebalance comp=
letes.<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; 2013/4/20 Eric Sandeen &lt;<a href=3D=
"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a><br>
&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:sandeen@sandeen.net">sandee=
n@sandeen.net</a>&gt;<br>
</div>&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:sa=
ndeen@sandeen.net">sandeen@sandeen.net</a> &lt;mailto:<a href=3D"mailto:san=
deen@sandeen.net">sandeen@sandeen.net</a>&gt;&gt;&gt;<br>
<div class=3D"HOEnZb"><div class=3D"h5">&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; On 4/19/13 9:03 PM, =B7=
=FB=D3=C0=CC=CE wrote:<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Hi Eric,<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; I will enable them=
 and run test again. I can only<br>
&gt; &nbsp; &nbsp; reproduce it<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; with<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; glusterfs rebalanc=
e. Glusterfs uses a mechanism it called<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; syncop to<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; unlink file. For r=
ebalance it uses<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; syncop_unlink(glus=
terfs/libglusterfs/src/syncop.c). In the<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; glusterfs<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; sync_task framewor=
k(glusterfs/libglusterfs/src/syncop.c)<br>
&gt; &nbsp; &nbsp; it uses<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &quot;makecontext/=
swapcontext&quot;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &lt;<a href=3D"http://www.opengroup.org/onlinepubs/00969=
5399/functions/makecontext.html" target=3D"_blank">http://www.opengroup.org=
/onlinepubs/009695399/functions/makecontext.html</a>&gt;.<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Does it leads to r=
acing unlink from different CPU core?<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Yep, I understand that =
it&#39;s rebalance. &nbsp;It dies when rebalance<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; finishes because an<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; open but unlinked file =
trips over the corrupted list from<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; earlier, it seems.<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; I don&#39;t know why ma=
kecontext would matter...<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; Just to be sure, you ar=
e definitely loading the xfs module<br>
&gt; &nbsp; &nbsp; from<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; the kernel you built, r=
ight, and you don&#39;t have a &quot;priority&quot;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; module getting loaded f=
rom elsewhere? &nbsp;Seems unlikely, but<br>
&gt; &nbsp; &nbsp; just<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; to be sure.<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; Thank you.<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; You could also add this=
 patch to the xfs tracepoints to print<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; more information about =
the inodes - the mode &amp; flags.<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; -Eric<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; diff --git a/fs/xfs/lin=
ux-2.6/xfs_trace.h<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; b/fs/xfs/linux-2.6/xfs_=
trace.h<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; index e8ce644..c314b87 =
100644<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; --- a/fs/xfs/linux-2.6/=
xfs_trace.h<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; +++ b/fs/xfs/linux-2.6/=
xfs_trace.h<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; @@ -544,14 +544,18 @@ D=
ECLARE_EVENT_CLASS(xfs_inode_class,<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; TP_STRUCT__entry(<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; __field(dev_t, dev)<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; __field(xfs_ino_t, ino)<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; __field(__u16, mode)<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; __field(unsigned long, flags)<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; ),<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; TP_fast_assign(<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; __entry-&gt;dev =3D VFS_I(ip)-&gt;i_sb-&gt=
;s_dev;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; __entry-&gt;ino =3D ip-&gt;i_ino;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; __entry-&gt;mode =3D VFS_I(ip)-&gt;i_mode;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; __entry-&gt;flags =3D ip-&gt;i_flags;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; ),<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; - &nbsp; &nbsp; &nbsp; =
TP_printk(&quot;dev %d:%d ino 0x%llx&quot;,<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; =
TP_printk(&quot;dev %d:%d ino 0x%llx mode 0%o, flags<br>
&gt; &nbsp; &nbsp; 0x%lx&quot;,<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; MAJOR(__entry-&gt;dev), MINOR(__ent=
ry-&gt;dev),<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; - &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __entry-&gt;ino)<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; + &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; __entry-&gt;ino, __entry-&gt;mode, __ent=
ry-&gt;flags)<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;)<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;#define DEFINE_IN=
ODE_EVENT(name) \<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; &gt; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt;<br>
&gt; &nbsp; &nbsp; &gt; --<br>
&gt; &nbsp; &nbsp; &gt; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; =B7=FB=D3=C0=CC=CE<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=
=C0=CC=CE
</div>

--14dae9340865d8a4a404daca966e--


--===============5899760926032705825==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5899760926032705825==--
