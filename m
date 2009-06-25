Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5PA5uda134786 for <xfs@oss.sgi.com>; Thu, 25 Jun 2009 05:05:57 -0500
MIME-Version: 1.0
In-Reply-To: <4A4228DE.6040104@sandeen.net>
References: <409bd82b0906240456m44d95343vdd62f0c3ad7bcdac@mail.gmail.com>
	<4A4228DE.6040104@sandeen.net>
Date: Thu, 25 Jun 2009 15:36:23 +0530
Message-ID: <409bd82b0906250306o47b4bc54pb7a7d199e17af5e6@mail.gmail.com>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
From: Nitin Arora <nitin.arora.del@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7462616940137355741=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: xfs-masters@oss.sgi.com

--===============7462616940137355741==
Content-Type: multipart/alternative; boundary=00163683222a50cb5c046d296028

--00163683222a50cb5c046d296028
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

I have tried the patch provided in that link but unfortunately it doesn't
solve that problem.
I have run xfs_repair on the corrupted partition and got the following
output.
*
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
data fork in regular inode 159 claims used block 667542
bad data fork in inode 159
cleared inode 159
data fork in regular inode 6228245 claims used block 667569
bad data fork in inode 6228245
cleared inode 6228245
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
entry "Masoom7.avi" at block 0 offset 1824 in directory inode 128 references
free inode 159
        clearing inode number in entry at offset 1824...
entry "Gandhi4.avi" at block 2 offset 664 in directory inode 128 references
free inode 6228245
        clearing inode number in entry at offset 664...
data fork in ino 133 claims dup extent, off - 0, start - 667542, cnt 333765
bad data fork in inode 133
cleared inode 133
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
entry "3.avi" in directory inode 128 points to free inode 133
bad hash table for directory inode 128 (no data entry): rebuilding
rebuilding directory inode 128
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
*

Please let me know in case any other fix is available.

Thanks
:)



On Wed, Jun 24, 2009 at 6:53 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Nitin Arora wrote:
> > Hi,
> >
> > I am using linux kernel 2.6.18 with XFS support.
> > I have formatted USB hard drive with XFS. When I try to copy
> > (i.e. cp 1.avi 2.avi) a big file (size : 1.3 GB) from one
> > location to another on the same hard drive It corrupts the
> > hard drive with the following back trace.
>
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git&a=commitdiff&h=71a8c87fb300b601eacf7a86cc6c6322fe827bfd
>
> fixed a longstanding in-memory extent corruption, but that's my only
> guess at this point.  As Michael said, 2.6.18 is getting very old, and
> unless you have a vendor supporting it (in which case you should
> probably ask them...) you will probably have trouble getting help with
> problems in it, I'm afraid, because it is several years old.
>
> (however, if this is mission critical we could point you to people who
> can do contract work to help)
>
> -Eric
>
> > /XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1588 of file
> > fs/xfs/xfs_alloc.c.  Caller 0xc0131a70
> > [<c0024618>] (dump_stack+0x0/0x14) from [<c0158ae0>]
> > (xfs_error_report+0x54/0x64)
> > [<c0158a8c>] (xfs_error_report+0x0/0x64) from [<c012fcf0>]
> > (xfs_free_ag_extent+0xec/0x768)
> > [<c012fc04>] (xfs_free_ag_extent+0x0/0x768) from [<c0131a70>]
> > (xfs_free_extent+0xa0/0xbc)
> > [<c01319d0>] (xfs_free_extent+0x0/0xbc) from [<c0140dd0>]
> > (xfs_bmap_finish+0xec/0x184)
> > r7 = CBF826F8  r6 = 00000000  r5 = 000357B8  r4 = CB7CF708
> > [<c0140ce4>] (xfs_bmap_finish+0x0/0x184) from [<c01633b8>]
> > (xfs_itruncate_finish+0x1c8/0x2fc)
> > [<c01631f0>] (xfs_itruncate_finish+0x0/0x2fc) from [<c01814b0>]
> > (xfs_inactive+0x278/0x89c)/
> >
> > I have searched on the internet about and found that many people are
> > facing the same problem,
> > But no solution is found.
> >
> > Can you guide me Or answer the following questions.
> > *
> > 1. Is there any patch available which solves this problem.
> > 2. If there is no patch available so far then can you give me
> >   some pointers which will help in solving the problem.*
> >
> > Thanks in advance
> >
> >
> >
> > ------------------------------------------------------------------------
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--00163683222a50cb5c046d296028
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br>
<br>
I have tried the patch provided in that link but unfortunately it doesn&#39=
;t solve that problem.<br>
I have run xfs_repair on the corrupted partition and got the following outp=
ut.<br>
<i><br>
Phase 1 - find and verify superblock...<br>
Phase 2 - using internal log<br>
=A0=A0=A0=A0=A0=A0=A0 - zero log...<br>
=A0=A0=A0=A0=A0=A0=A0 - scan filesystem freespace and inode maps...<br>
=A0=A0=A0=A0=A0=A0=A0 - found root inode chunk<br>
Phase 3 - for each AG...<br>
=A0=A0=A0=A0=A0=A0=A0 - scan and clear agi unlinked lists...<br>
=A0=A0=A0=A0=A0=A0=A0 - process known inodes and perform inode discovery...=
<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 0<br>
data fork in regular inode 159 claims used block 667542<br>
bad data fork in inode 159<br>
cleared inode 159<br>
data fork in regular inode 6228245 claims used block 667569<br>
bad data fork in inode 6228245<br>
cleared inode 6228245<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 1<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 2<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 3<br>
=A0=A0=A0=A0=A0=A0=A0 - process newly discovered inodes...<br>
Phase 4 - check for duplicate blocks...<br>
=A0=A0=A0=A0=A0=A0=A0 - setting up duplicate extent list...<br>
=A0=A0=A0=A0=A0=A0=A0 - check for inodes claiming duplicate blocks...<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 0<br>
entry &quot;Masoom7.avi&quot; at block 0 offset 1824 in directory inode 128=
 references free inode 159<br>
=A0=A0=A0=A0=A0=A0=A0 clearing inode number in entry at offset 1824...<br>
entry &quot;Gandhi4.avi&quot; at block 2 offset 664 in directory inode 128 =
references free inode 6228245<br>
=A0=A0=A0=A0=A0=A0=A0 clearing inode number in entry at offset 664...<br>
data fork in ino 133 claims dup extent, off - 0, start - 667542, cnt 333765=
<br>
bad data fork in inode 133<br>
cleared inode 133<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 1<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 2<br>
=A0=A0=A0=A0=A0=A0=A0 - agno =3D 3<br>
Phase 5 - rebuild AG headers and trees...<br>
=A0=A0=A0=A0=A0=A0=A0 - reset superblock...<br>
Phase 6 - check inode connectivity...<br>
=A0=A0=A0=A0=A0=A0=A0 - resetting contents of realtime bitmap and summary i=
nodes<br>
=A0=A0=A0=A0=A0=A0=A0 - traversing filesystem ...<br>
entry &quot;3.avi&quot; in directory inode 128 points to free inode 133<br>
bad hash table for directory inode 128 (no data entry): rebuilding<br>
rebuilding directory inode 128<br>
=A0=A0=A0=A0=A0=A0=A0 - traversal finished ...<br>
=A0=A0=A0=A0=A0=A0=A0 - moving disconnected inodes to lost+found ...<br>
Phase 7 - verify and correct link counts...<br>
done<br>
</i><br>
<br>
Please let me know in case any other fix is available.<br>
<br>
Thanks <br>
:)<br><br><br><br><div class=3D"gmail_quote">
On Wed, Jun 24, 2009 at 6:53 PM, Eric Sandeen <span dir=3D"ltr">&lt;<a href=
=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"border-left:=
 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex=
;">

<div>Nitin Arora wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I am using linux kernel 2.6.18 with XFS support.<br>
&gt; I have formatted USB hard drive with XFS. When I try to copy<br>
&gt; (i.e. cp 1.avi 2.avi) a big file (size : 1.3 GB) from one<br>
&gt; location to another on the same hard drive It corrupts the<br>
&gt; hard drive with the following back trace.<br>
<br>
</div><a href=3D"http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux=
-2.6.git&amp;a=3Dcommitdiff&amp;h=3D71a8c87fb300b601eacf7a86cc6c6322fe827bf=
d" target=3D"_blank">http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/l=
inux-2.6.git&amp;a=3Dcommitdiff&amp;h=3D71a8c87fb300b601eacf7a86cc6c6322fe8=
27bfd</a><br>


<br>
fixed a longstanding in-memory extent corruption, but that&#39;s my only<br=
>
guess at this point. =A0As Michael said, 2.6.18 is getting very old, and<br=
>
unless you have a vendor supporting it (in which case you should<br>
probably ask them...) you will probably have trouble getting help with<br>
problems in it, I&#39;m afraid, because it is several years old.<br>
<br>
(however, if this is mission critical we could point you to people who<br>
can do contract work to help)<br>
<br>
-Eric<br>
<br>
&gt; /XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1588 of file<br>
<div>&gt; fs/xfs/xfs_alloc.c. =A0Caller 0xc0131a70<br>
&gt; [&lt;c0024618&gt;] (dump_stack+0x0/0x14) from [&lt;c0158ae0&gt;]<br>
&gt; (xfs_error_report+0x54/0x64)<br>
&gt; [&lt;c0158a8c&gt;] (xfs_error_report+0x0/0x64) from [&lt;c012fcf0&gt;]=
<br>
&gt; (xfs_free_ag_extent+0xec/0x768)<br>
&gt; [&lt;c012fc04&gt;] (xfs_free_ag_extent+0x0/0x768) from [&lt;c0131a70&g=
t;]<br>
&gt; (xfs_free_extent+0xa0/0xbc)<br>
&gt; [&lt;c01319d0&gt;] (xfs_free_extent+0x0/0xbc) from [&lt;c0140dd0&gt;]<=
br>
&gt; (xfs_bmap_finish+0xec/0x184)<br>
&gt; r7 =3D CBF826F8 =A0r6 =3D 00000000 =A0r5 =3D 000357B8 =A0r4 =3D CB7CF7=
08<br>
&gt; [&lt;c0140ce4&gt;] (xfs_bmap_finish+0x0/0x184) from [&lt;c01633b8&gt;]=
<br>
&gt; (xfs_itruncate_finish+0x1c8/0x2fc)<br>
&gt; [&lt;c01631f0&gt;] (xfs_itruncate_finish+0x0/0x2fc) from [&lt;c01814b0=
&gt;]<br>
&gt; (xfs_inactive+0x278/0x89c)/<br>
&gt;<br>
&gt; I have searched on the internet about and found that many people are<b=
r>
&gt; facing the same problem,<br>
&gt; But no solution is found.<br>
&gt;<br>
&gt; Can you guide me Or answer the following questions.<br>
&gt; *<br>
&gt; 1. Is there any patch available which solves this problem.<br>
&gt; 2. If there is no patch available so far then can you give me<br>
&gt; =A0 some pointers which will help in solving the problem.*<br>
&gt;<br>
&gt; Thanks in advance<br>
&gt;<br>
&gt;<br>
&gt;<br>
</div>&gt; ----------------------------------------------------------------=
--------<br>
&gt;<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</=
a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</blockquote></div><br>

--00163683222a50cb5c046d296028--


--===============7462616940137355741==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7462616940137355741==--
