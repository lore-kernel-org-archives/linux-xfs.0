Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E46197FB7
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 02:58:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B6D788F8040
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 00:58:03 -0700 (PDT)
Received: from columba.intomics.com (columba.intomics.com [77.72.50.68]) by
	cuda.sgi.com with ESMTP id KKV5R7xTkQNukXs1 for
	<xfs@oss.sgi.com>; Thu, 02 Jul 2015 00:58:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by columba.intomics.com (Postfix) with ESMTP id 7D4022204A8
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 09:57:59 +0200 (CEST)
Received: from columba ([127.0.0.1])
	by localhost (columba.intomics.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id n8qk7kF8PuSt for <xfs@oss.sgi.com>;
	Thu,  2 Jul 2015 09:57:57 +0200 (CEST)
Received: from dhcp-0-1-94.intomics.com (dhcp-0-1-94.intomics.com [10.0.1.94])
	(Authenticated sender: rbh)
	by columba.intomics.com (Postfix) with ESMTPSA id 24D3222048A
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 09:57:57 +0200 (CEST)
From: Rasmus Borup Hansen <rbh@intomics.com>
Message-Id: <DBDC024E-67E6-4F11-995F-467AD085109F@intomics.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
Date: Thu, 2 Jul 2015 09:58:19 +0200
References: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
	<20150625184132.773a5ecd@harpe.intellique.com>
	<09CE9E14-9E6B-4587-9049-35B6C67016EF@intomics.com>
In-Reply-To: <09CE9E14-9E6B-4587-9049-35B6C67016EF@intomics.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2593345094076702317=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2593345094076702317==
Content-Type: multipart/alternative; boundary="Apple-Mail=_42F8D532-E358-4D39-A906-520B0D8575E6"


--Apple-Mail=_42F8D532-E358-4D39-A906-520B0D8575E6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

When I tried mounting the file system after running xfs_repair, a quota =
check was started. However it did not finish after a few hours like the =
quota check that was started when mounting the file system read only, so =
after a few days of waiting (with next to no disk activity) I restarted =
the server and mounted the file system without quotas. Soon afterwards I =
got the following error (note that it's a different line number in =
xfs_attr_leaf.c than the one I initially saw):

[  327.670974] ffff8802a273d000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 =
00 00 00  ................
[  327.678213] ffff8802a273d010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 =
00 00 00  ..... ..........
[  327.685878] ffff8802a273d020: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
[  327.693950] ffff8802a273d030: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
[  327.701567] XFS (dm-0): Internal error xfs_attr3_leaf_read_verify at =
line 246 of file /build/buildd/linux-3.13.0/fs/xfs/xfs_attr_leaf.c.  =
Caller 0xffffffffa00cb885
[  327.718829] CPU: 1 PID: 2805 Comm: kworker/1:1H Not tainted =
3.13.0-55-generic #94-Ubuntu
[  327.718830] Hardware name: Dell Inc. PowerEdge R310/05XKKK, BIOS =
1.8.2 08/17/2011
[  327.718867] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[  327.718869]  0000000000000001 ffff8800b82bfd68 ffffffff81723294 =
ffff8800368dd800
[  327.718875]  ffff8800b82bfd80 ffffffffa00ce6fb ffffffffa00cb885 =
ffff8800b82bfdb8
[  327.718877]  ffffffffa00ce755 000000f600203100 ffff8802a140ad00 =
ffff8800368dd800
[  327.718879] Call Trace:
[  327.718887]  [<ffffffff81723294>] dump_stack+0x45/0x56
[  327.718901]  [<ffffffffa00ce6fb>] xfs_error_report+0x3b/0x40 [xfs]
[  327.718911]  [<ffffffffa00cb885>] ? xfs_buf_iodone_work+0x85/0xf0 =
[xfs]
[  327.718921]  [<ffffffffa00ce755>] xfs_corruption_error+0x55/0x80 =
[xfs]
[  327.718935]  [<ffffffffa00ebbdd>] =
xfs_attr3_leaf_read_verify+0x6d/0xf0 [xfs]
[  327.718945]  [<ffffffffa00cb885>] ? xfs_buf_iodone_work+0x85/0xf0 =
[xfs]
[  327.718954]  [<ffffffffa00cb885>] xfs_buf_iodone_work+0x85/0xf0 [xfs]
[  327.718958]  [<ffffffff81083b22>] process_one_work+0x182/0x450
[  327.718961]  [<ffffffff81084911>] worker_thread+0x121/0x410
[  327.718963]  [<ffffffff810847f0>] ? rescuer_thread+0x430/0x430
[  327.718965]  [<ffffffff8108b702>] kthread+0xd2/0xf0
[  327.718967]  [<ffffffff8108b630>] ? =
kthread_create_on_node+0x1c0/0x1c0
[  327.718970]  [<ffffffff81733ca8>] ret_from_fork+0x58/0x90
[  327.718972]  [<ffffffff8108b630>] ? =
kthread_create_on_node+0x1c0/0x1c0
[  327.718973] XFS (dm-0): Corruption detected. Unmount and run =
xfs_repair
[  327.729003] XFS (dm-0): metadata I/O error: block 0x157e84da0 =
("xfs_trans_read_buf_map") error 117 numblks 8

I started another xfs_repair which did not report any errors. After =
mounting the file system again (still without quotas) I discovered that =
ls would write "Structure needs cleaning" whenever it listed a certain =
file (and the kernel would output error messages like those above). This =
was a file I didn't need, so I tried deleting it and running yet another =
xfs_repair:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
agi unlinked bucket 11 is 2949684875 in ag 2 (inode=3D11539619467)
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
doubling cache size to 591232
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 11539619467, moving to lost+found
Phase 7 - verify and correct link counts...
done

The file then turns up in lost+found and when I "ls" it I get the same =
errors again. I've tried deleting it from lost+found, but then =
xfs_repair finds it again with exactly the same output as show above and =
puts it back.

Apart from that, everything apparently works fine.

Is there a way to permanently get rid of the file in lost+found? Its =
size is apparently 0 bytes.

Best,

Rasmus


Intomics is a contract research organization specialized in deriving =
core biological insight from large scale data. We help our clients in =
the pharmaceutical industry develop tomorrow's medicines better, faster, =
and cheaper through optimized use of biomedical data.
-----------------------------------------------------------------
Hansen, Rasmus Borup              Intomics - from data to biology
System Administrator              Diplomvej 377
Scientific Programmer             DK-2800 Kgs. Lyngby
                                  Denmark
E: rbh@intomics.com               W: http://www.intomics.com/
P: +45 5167 7972                  P: +45 8880 7979

> On 26 Jun 2015, at 08:14, Rasmus Borup Hansen <rbh@intomics.com> =
wrote:
>=20
> I tried mounting the file system read-only (which triggered a quota =
check =E2=80=93 does this make sense when the file system is read-only?) =
and then I scanned the file system for files with the spurious inodes to =
see if I could find a pattern. This took quite a while, and I didn't =
find any patterns, except that all the files in directories with project =
quotas were affected (but there were also other files). I'm now running =
xfs_repair without -n (and I had to mount and unmount the file system =
before it would start). I'll report back when it has finished.
>=20
> Best,
>=20
> Rasmus
>=20
> Intomics is a contract research organization specialized in deriving =
core biological insight from large scale data. We help our clients in =
the pharmaceutical industry develop tomorrow's medicines better, faster, =
and cheaper through optimized use of biomedical data.
> -----------------------------------------------------------------
> Hansen, Rasmus Borup              Intomics - from data to biology
> System Administrator              Diplomvej 377
> Scientific Programmer             DK-2800 Kgs. Lyngby
>                                   Denmark
> E: rbh@intomics.com <mailto:rbh@intomics.com>               W: =
http://www.intomics.com/ <http://www.intomics.com/>
> P: +45 5167 7972                  P: +45 8880 7979
>=20
>> On 25 Jun 2015, at 18:41, Emmanuel Florac <eflorac@intellique.com =
<mailto:eflorac@intellique.com>> wrote:
>>=20
>> Le Wed, 24 Jun 2015 09:39:45 +0200
>> Rasmus Borup Hansen <rbh@intomics.com <mailto:rbh@intomics.com>> =
=C3=A9crivait:
>>=20
>>> Only the first 20 lines are included. There are currently 250000+
>>> more lines with "directory flags set on non-directory inode" and the
>>> check is still running (the mostly small files take up around 30 TB,
>>> so it'll probably take a while).
>>>=20
>>> I recently enabled user and project quota and updated from =
3.13.0-53.
>>> The file system has been heavily used for the last month or so.
>>>=20
>>> Does anyone have any thoughts on this? I'm tempted to stop using
>>> quotas when the file system (hopefully) works again, as it's my
>>> impression that project quotas are not widely used.
>>=20
>> Did you first try remounting then unmounting the volume to clear the
>> log? That could clear out xfs_repair output.
>>=20
>> --=20
>> =
------------------------------------------------------------------------
>> Emmanuel Florac     |   Direction technique
>>                    |   Intellique
>>                    |	<eflorac@intellique.com =
<mailto:eflorac@intellique.com>>
>>                    |   +33 1 78 94 84 02
>> =
------------------------------------------------------------------------
>>=20
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com <mailto:xfs@oss.sgi.com>
>> http://oss.sgi.com/mailman/listinfo/xfs
>=20
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


--Apple-Mail=_42F8D532-E358-4D39-A906-520B0D8575E6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dutf-8"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div class=3D"">When I tried mounting the file system after =
running xfs_repair, a quota check was started. However it did not finish =
after a few hours like the quota check that was started when mounting =
the file system read only, so after a few days of waiting (with next to =
no disk activity) I restarted the server and mounted the file system =
without quotas. Soon afterwards I got the following error (note that =
it's a different line number in xfs_attr_leaf.c than the one I initially =
saw):</div><div class=3D""><br class=3D""></div><div class=3D""><div =
class=3D""><font face=3D"Courier New" class=3D"">[ &nbsp;327.670974] =
ffff8802a273d000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00 =
&nbsp;................</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[ &nbsp;327.678213] ffff8802a273d010: 10 00 00 00 00 20 =
0f e0 00 00 00 00 00 00 00 00 &nbsp;..... ..........</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[ &nbsp;327.685878] =
ffff8802a273d020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
&nbsp;................</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[ &nbsp;327.693950] ffff8802a273d030: 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 &nbsp;................</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[ &nbsp;327.701567] XFS =
(dm-0): Internal error xfs_attr3_leaf_read_verify at line 246 of file =
/build/buildd/linux-3.13.0/fs/xfs/xfs_attr_leaf.c. &nbsp;Caller =
0xffffffffa00cb885</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[ &nbsp;327.718829] CPU: 1 PID: 2805 Comm: kworker/1:1H =
Not tainted 3.13.0-55-generic #94-Ubuntu</font></div><div class=3D""><font=
 face=3D"Courier New" class=3D"">[ &nbsp;327.718830] Hardware name: Dell =
Inc. PowerEdge R310/05XKKK, BIOS 1.8.2 08/17/2011</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[ &nbsp;327.718867] =
Workqueue: xfslogd xfs_buf_iodone_work [xfs]</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[ &nbsp;327.718869] =
&nbsp;0000000000000001 ffff8800b82bfd68 ffffffff81723294 =
ffff8800368dd800</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[ &nbsp;327.718875] &nbsp;ffff8800b82bfd80 ffffffffa00ce6fb =
ffffffffa00cb885 ffff8800b82bfdb8</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[ &nbsp;327.718877] =
&nbsp;ffffffffa00ce755 000000f600203100 ffff8802a140ad00 =
ffff8800368dd800</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[ &nbsp;327.718879] Call Trace:</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[ &nbsp;327.718887] =
&nbsp;[&lt;ffffffff81723294&gt;] dump_stack+0x45/0x56</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[ &nbsp;327.718901] =
&nbsp;[&lt;ffffffffa00ce6fb&gt;] xfs_error_report+0x3b/0x40 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" class=3D"">[ =
&nbsp;327.718911] &nbsp;[&lt;ffffffffa00cb885&gt;] ? =
xfs_buf_iodone_work+0x85/0xf0 [xfs]</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[ &nbsp;327.718921] =
&nbsp;[&lt;ffffffffa00ce755&gt;] xfs_corruption_error+0x55/0x80 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" class=3D"">[ =
&nbsp;327.718935] &nbsp;[&lt;ffffffffa00ebbdd&gt;] =
xfs_attr3_leaf_read_verify+0x6d/0xf0 [xfs]</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[ &nbsp;327.718945] =
&nbsp;[&lt;ffffffffa00cb885&gt;] ? xfs_buf_iodone_work+0x85/0xf0 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" class=3D"">[ =
&nbsp;327.718954] &nbsp;[&lt;ffffffffa00cb885&gt;] =
xfs_buf_iodone_work+0x85/0xf0 [xfs]</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[ &nbsp;327.718958] =
&nbsp;[&lt;ffffffff81083b22&gt;] =
process_one_work+0x182/0x450</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[ &nbsp;327.718961] =
&nbsp;[&lt;ffffffff81084911&gt;] =
worker_thread+0x121/0x410</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[ &nbsp;327.718963] =
&nbsp;[&lt;ffffffff810847f0&gt;] ? =
rescuer_thread+0x430/0x430</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[ &nbsp;327.718965] =
&nbsp;[&lt;ffffffff8108b702&gt;] kthread+0xd2/0xf0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[ &nbsp;327.718967] =
&nbsp;[&lt;ffffffff8108b630&gt;] ? =
kthread_create_on_node+0x1c0/0x1c0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[ &nbsp;327.718970] =
&nbsp;[&lt;ffffffff81733ca8&gt;] =
ret_from_fork+0x58/0x90</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[ &nbsp;327.718972] &nbsp;[&lt;ffffffff8108b630&gt;] ? =
kthread_create_on_node+0x1c0/0x1c0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[ &nbsp;327.718973] XFS (dm-0): =
Corruption detected. Unmount and run xfs_repair</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[ &nbsp;327.729003] XFS =
(dm-0): metadata I/O error: block 0x157e84da0 ("xfs_trans_read_buf_map") =
error 117 numblks 8</font></div></div><div class=3D""><br =
class=3D""></div><div class=3D"">I started another xfs_repair which did =
not report any errors. After mounting the file system again (still =
without quotas) I discovered that ls would write "Structure needs =
cleaning" whenever it listed a certain file (and the kernel would output =
error messages like those above). This was a file I didn't need, so I =
tried deleting it and running yet another xfs_repair:</div><div =
class=3D""><br class=3D""></div><div class=3D""><div class=3D""><font =
face=3D"Courier New" class=3D"">Phase 1 - find and verify =
superblock...</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Phase 2 - using internal log</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - zero =
log...</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - scan filesystem freespace and =
inode maps...</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">agi unlinked bucket 11 is 2949684875 in ag 2 =
(inode=3D11539619467)</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - found root inode =
chunk</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Phase 3 - for each AG...</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - scan and =
clear agi unlinked lists...</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - process =
known inodes and perform inode discovery...</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">&nbsp; &nbsp; &nbsp; =
&nbsp; - agno =3D 0</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">doubling cache size to 591232</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">&nbsp; &nbsp; &nbsp; =
&nbsp; - agno =3D 1</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - agno =3D =
2</font></div><div class=3D""><font face=3D"Courier New" class=3D"">&nbsp;=
 &nbsp; &nbsp; &nbsp; - agno =3D 3</font></div></div><div class=3D""><font=
 face=3D"Courier New" class=3D"">...</font></div><div class=3D""><div =
class=3D""><font face=3D"Courier New" class=3D"">Phase 6 - check inode =
connectivity...</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - resetting contents of realtime =
bitmap and summary inodes</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - traversing =
filesystem ...</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - traversal finished =
...</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; - moving disconnected inodes to =
lost+found ...</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">disconnected inode 11539619467, moving to =
lost+found</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Phase 7 - verify and correct link counts...</font></div><div =
class=3D""><font face=3D"Courier New" =
class=3D"">done</font></div></div><div class=3D""><br =
class=3D""></div><div class=3D"">The file then turns up in lost+found =
and when I "ls" it I get the same errors again. I've tried deleting it =
from lost+found, but then xfs_repair finds it again with exactly the =
same output as show above and puts it back.</div><div class=3D""><br =
class=3D""></div><div class=3D"">Apart from that, everything apparently =
works fine.</div><div class=3D""><br class=3D""></div><div class=3D"">Is =
there a way to permanently get rid of the file in lost+found? Its size =
is apparently 0 bytes.</div><div class=3D""><br class=3D""></div><div =
class=3D"">Best,</div><div class=3D""><br class=3D""></div><div =
class=3D"">Rasmus</div><div class=3D""><br class=3D""></div><br =
class=3D""><div apple-content-edited=3D"true" class=3D"">
<span class=3D"Apple-style-span" style=3D"border-collapse: separate; =
border-spacing: 0px;"><i class=3D"">Intomics is a contract research =
organization specialized in deriving core biological insight from large =
scale data. We help our clients in the pharmaceutical&nbsp;industry =
develop tomorrow's medicines better, faster, and cheaper through =
optimized use of biomedical data.</i><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-family: =
Helvetica; font-style: normal; font-variant: normal; font-weight: =
normal; letter-spacing: normal; line-height: normal; orphans: 2; =
text-align: -webkit-auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px;  "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; " class=3D""><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier =
New'">-----------------------------------------------------------------</f=
ont></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">Hansen, Rasmus Borup &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;Intomics - from data to biology</font></div><div =
class=3D""><font class=3D"Apple-style-span" face=3D"'Courier =
New'">System Administrator &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;Diplomvej 377</font></div><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier New'">Scientific Programmer =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; DK-2800 Kgs. =
Lyngby</font></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
Denmark</font></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">E: <a href=3D"mailto:rbh@intomics.com" =
class=3D"">rbh@intomics.com</a> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; W: <a href=3D"http://www.intomics.com/" =
class=3D"">http://www.intomics.com/</a></font></div><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier New'">P: +45 5167 7972 =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;P: +45 =
8880 7979</font></div></div></span></span>
</div>
<br class=3D""><div><blockquote type=3D"cite" class=3D""><div =
class=3D"">On 26 Jun 2015, at 08:14, Rasmus Borup Hansen &lt;<a =
href=3D"mailto:rbh@intomics.com" class=3D"">rbh@intomics.com</a>&gt; =
wrote:</div><br class=3D"Apple-interchange-newline"><div class=3D""><meta =
http-equiv=3D"Content-Type" content=3D"text/html charset=3Dutf-8" =
class=3D""><div style=3D"word-wrap: break-word; -webkit-nbsp-mode: =
space; -webkit-line-break: after-white-space;" class=3D""><div =
class=3D"">I tried mounting the file system read-only (which triggered a =
quota check =E2=80=93 does this make sense when the file system is =
read-only?) and then I scanned the file system for files with the =
spurious inodes to see if I could find a pattern. This took quite a =
while, and I didn't find any patterns, except that all the files in =
directories with project quotas were affected (but there were also other =
files). I'm now running xfs_repair without -n (and I had to mount and =
unmount the file system before it would start). I'll report back when it =
has finished.</div><div class=3D""><br class=3D""></div><div =
class=3D"">Best,</div><div class=3D""><br class=3D""></div><div =
class=3D"">Rasmus</div><br class=3D""><div apple-content-edited=3D"true" =
class=3D"">
<span class=3D"Apple-style-span" style=3D"border-collapse: separate; =
font-family: Helvetica; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: -webkit-auto; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; border-spacing: =
0px; -webkit-text-decorations-in-effect: none; =
-webkit-text-stroke-width: 0px;"><i class=3D"">Intomics is a contract =
research organization specialized in deriving core biological insight =
from large scale data. We help our clients in the =
pharmaceutical&nbsp;industry develop tomorrow's medicines better, =
faster, and cheaper through optimized use of biomedical data.</i><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; =
font-family: Helvetica; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: -webkit-auto; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; border-spacing: =
0px; -webkit-text-decorations-in-effect: none; =
-webkit-text-stroke-width: 0px;"><div style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; " =
class=3D""><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier =
New'">-----------------------------------------------------------------</f=
ont></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">Hansen, Rasmus Borup &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;Intomics - from data to biology</font></div><div =
class=3D""><font class=3D"Apple-style-span" face=3D"'Courier =
New'">System Administrator &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;Diplomvej 377</font></div><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier New'">Scientific Programmer =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; DK-2800 Kgs. =
Lyngby</font></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
Denmark</font></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">E: <a href=3D"mailto:rbh@intomics.com" =
class=3D"">rbh@intomics.com</a> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; W: <a href=3D"http://www.intomics.com/" =
class=3D"">http://www.intomics.com/</a></font></div><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier New'">P: +45 5167 7972 =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;P: +45 =
8880 7979</font></div></div></span></span>
</div>
<br class=3D""><div class=3D""><blockquote type=3D"cite" class=3D""><div =
class=3D"">On 25 Jun 2015, at 18:41, Emmanuel Florac &lt;<a =
href=3D"mailto:eflorac@intellique.com" =
class=3D"">eflorac@intellique.com</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div class=3D"">Le Wed, 24 Jun 2015 =
09:39:45 +0200<br class=3D"">Rasmus Borup Hansen &lt;<a =
href=3D"mailto:rbh@intomics.com" class=3D"">rbh@intomics.com</a>&gt; =
=C3=A9crivait:<br class=3D""><br class=3D""><blockquote type=3D"cite" =
class=3D"">Only the first 20 lines are included. There are currently =
250000+<br class=3D"">more lines with "directory flags set on =
non-directory inode" and the<br class=3D"">check is still running (the =
mostly small files take up around 30 TB,<br class=3D"">so it'll probably =
take a while).<br class=3D""><br class=3D"">I recently enabled user and =
project quota and updated from 3.13.0-53.<br class=3D"">The file system =
has been heavily used for the last month or so.<br class=3D""><br =
class=3D"">Does anyone have any thoughts on this? I'm tempted to stop =
using<br class=3D"">quotas when the file system (hopefully) works again, =
as it's my<br class=3D"">impression that project quotas are not widely =
used.<br class=3D""></blockquote><br class=3D"">Did you first try =
remounting then unmounting the volume to clear the<br class=3D"">log? =
That could clear out xfs_repair output.<br class=3D""><br class=3D"">-- =
<br =
class=3D"">---------------------------------------------------------------=
---------<br class=3D"">Emmanuel Florac &nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;&nbsp;Direction technique<br class=3D""> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;Intellique<br =
class=3D""> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>&lt;<a =
href=3D"mailto:eflorac@intellique.com" =
class=3D"">eflorac@intellique.com</a>&gt;<br class=3D""> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;+33 1 78 94 84 =
02<br =
class=3D"">---------------------------------------------------------------=
---------<br class=3D""><br =
class=3D"">_______________________________________________<br =
class=3D"">xfs mailing list<br class=3D""><a =
href=3D"mailto:xfs@oss.sgi.com" class=3D"">xfs@oss.sgi.com</a><br =
class=3D""><a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" =
class=3D"">http://oss.sgi.com/mailman/listinfo/xfs</a><br =
class=3D""></div></blockquote></div><br =
class=3D""></div>_______________________________________________<br =
class=3D"">xfs mailing list<br class=3D""><a =
href=3D"mailto:xfs@oss.sgi.com" class=3D"">xfs@oss.sgi.com</a><br =
class=3D"">http://oss.sgi.com/mailman/listinfo/xfs<br =
class=3D""></div></blockquote></div><br class=3D""></body></html>=

--Apple-Mail=_42F8D532-E358-4D39-A906-520B0D8575E6--


--===============2593345094076702317==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2593345094076702317==--
