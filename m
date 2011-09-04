Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8469qOL168748 for <xfs@oss.sgi.com>; Sun, 4 Sep 2011 01:09:52 -0500
Received: from mail-yw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFDFA13BF939
	for <xfs@oss.sgi.com>; Sat,  3 Sep 2011 23:13:36 -0700 (PDT)
Received: from mail-yw0-f53.google.com (mail-yw0-f53.google.com
	[209.85.213.53]) by cuda.sgi.com with ESMTP id XVlyxscjoyxD3rsD
	for <xfs@oss.sgi.com>; Sat, 03 Sep 2011 23:13:36 -0700 (PDT)
Received: by ywb5 with SMTP id 5so753101ywb.26
	for <xfs@oss.sgi.com>; Sat, 03 Sep 2011 23:09:49 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 4 Sep 2011 14:09:49 +0800
Message-ID: <CAKxAxjFgBd0Vt02m7FJKq_ZWNBBJ5B=N4u7kS69FKtOKT4UowA@mail.gmail.com>
Subject: ENOSPC and filesystem shutdowns
From: Bernard Chan <bernard@goanimate.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5744438163654219211=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5744438163654219211==
Content-Type: multipart/alternative; boundary=20cf305b0c8a244de004ac1771e2

--20cf305b0c8a244de004ac1771e2
Content-Type: text/plain; charset=ISO-8859-1

Hello,

My apologies if this sounds too amateurish for this mailing list, yet I
would like to get some insights on a recent issue we have on our XFS
installation.

We have an XFS filesystem (on LVM, probably doesn't matter anyway) that is
4TB running on CentOS kernel 2.6.21.7, with about 65% FS utilization and 5%
reported inode utilization (df -i). This filesystem contains a lot of small
files about 5 levels deep with each level fanning out with several hundred
to several thousand nodes on average. While having rolled out to production
for a couple weeks, the XFS suddenly shuts down on a certain mkdir.

Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: Filesystem "dm-1": XFS internal
error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c.  Caller
0xee27bcac
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee2732fe>]
xfs_trans_cancel+0x59/0xe3 [xfs]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee27bcac>] xfs_mkdir+0x5bc/0x60b
[xfs]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee27bcac>] xfs_mkdir+0x5bc/0x60b
[xfs]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee284ee6>]
xfs_vn_mknod+0x1a5/0x28f [xfs]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee284fe2>]
xfs_vn_mkdir+0x12/0x14 [xfs]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<c10786d0>] vfs_mkdir+0xbd/0x125
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee2dc1bc>]
nfsd_create+0x297/0x38c [nfsd]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee2e5597>]
nfsd4_create+0x1ab/0x34c [nfsd]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee2e53ec>]
nfsd4_create+0x0/0x34c [nfsd]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee2e4948>]
nfsd4_proc_compound+0x178/0x263 [nfsd]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<c102ebfd>]
groups_alloc+0x42/0xae
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee2d720f>]
nfsd_dispatch+0xd4/0x18f [nfsd]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee180805>]
svcauth_unix_set_client+0x16d/0x1a0 [sunrpc]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee17d63f>]
svc_process+0x391/0x656 [sunrpc]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee2d7756>] nfsd+0x171/0x277
[nfsd]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<ee2d75e5>] nfsd+0x0/0x277 [nfsd]
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: [<c100598f>]
kernel_thread_helper+0x7/0x10
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: =======================
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: xfs_force_shutdown(dm-1,0x8)
called from line 1139 of file fs/xfs/xfs_trans.c.  Return address =
0xee287778
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: Filesystem "dm-1": Corruption of
in-memory data detected.  Shutting down filesystem: dm-1
Sep  3 04:45:39 ip-10-204-xxx-xxx kernel: Please umount the filesystem, and
rectify the problem(s)


We searched and found this list, and a few patches around kernel
2.6.26-2.6.27 that seem to match our scenario. We were able to log the
specific mkdir command that failed and confirmed it consistently fails that
way that gives "no space left on device", while we did not reproduce the
same issue mkdir in other directories with large inode numbers. We haven't
tried patching or upgrading the kernel yet, but we will do that later.

As the root cause of that patch points to a bug triggered by ENOSPC, we
checked the inode numbers created for some directories and files with "ls
-li" and some of them are pretty close to 2^32.

So, we would like to ascertain if that is the cause for ENOSPC in our case,
and does that mean 32-bit inodes are no longer adequate for us and we should
switch to 64-bit inodes? Will switching it avoid this kind of shutdowns with
successful writes in the future?

And is it true that we don't need a 64-bit OS for 64-bit inodes? How can we
tell if our system supports 64-bit inodes?

Finally, although we all know that "df -i" is sort of nonsense on XFS, how
can we get the output of 5% inode while having inode numbers that are close
to 2^32? So what does that 5% exactly mean, or were I looking at inodes the
wrong way?

Thanks in advance for any insights anyone may shed on this one.

-- 

Regards,
Bernard Chan.
GoAnimate.

--20cf305b0c8a244de004ac1771e2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div><br></div><div>Hello,</div><div><br></div><div>My apologies if this so=
unds too amateurish for this mailing list, yet I would like to get some ins=
ights on a recent issue we have on our XFS installation.</div><div><br></di=
v>
We have an XFS filesystem (on LVM, probably doesn&#39;t matter anyway) that=
 is 4TB running on CentOS kernel 2.6.21.7, with about 65% FS utilization an=
d 5% reported inode utilization (df -i). This filesystem contains a lot of =
small files about 5 levels deep with each level fanning out with several hu=
ndred to several thousand nodes on average. While having rolled out to prod=
uction for a couple weeks, the XFS suddenly shuts down on a certain mkdir.<=
div>
<br></div><div><div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel: Filesystem =
&quot;dm-1&quot;: XFS internal error xfs_trans_cancel at line 1138 of file =
fs/xfs/xfs_trans.c. =A0Caller 0xee27bcac</div><div>Sep =A03 04:45:39 ip-10-=
204-xxx-xxx kernel: [&lt;ee2732fe&gt;] xfs_trans_cancel+0x59/0xe3 [xfs]</di=
v>
<div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel: [&lt;ee27bcac&gt;] xfs_mkd=
ir+0x5bc/0x60b [xfs]</div><div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel: =
[&lt;ee27bcac&gt;] xfs_mkdir+0x5bc/0x60b [xfs]</div><div>Sep =A03 04:45:39 =
ip-10-204-xxx-xxx kernel: [&lt;ee284ee6&gt;] xfs_vn_mknod+0x1a5/0x28f [xfs]=
</div>
<div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel: [&lt;ee284fe2&gt;] xfs_vn_=
mkdir+0x12/0x14 [xfs]</div><div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel:=
 [&lt;c10786d0&gt;] vfs_mkdir+0xbd/0x125</div><div>Sep =A03 04:45:39 ip-10-=
204-xxx-xxx kernel: [&lt;ee2dc1bc&gt;] nfsd_create+0x297/0x38c [nfsd]</div>
<div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel: [&lt;ee2e5597&gt;] nfsd4_c=
reate+0x1ab/0x34c [nfsd]</div><div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kern=
el: [&lt;ee2e53ec&gt;] nfsd4_create+0x0/0x34c [nfsd]</div><div>Sep =A03 04:=
45:39 ip-10-204-xxx-xxx kernel: [&lt;ee2e4948&gt;] nfsd4_proc_compound+0x17=
8/0x263 [nfsd]</div>
<div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel: [&lt;c102ebfd&gt;] groups_=
alloc+0x42/0xae</div><div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel: [&lt;=
ee2d720f&gt;] nfsd_dispatch+0xd4/0x18f [nfsd]</div><div>Sep =A03 04:45:39 i=
p-10-204-xxx-xxx kernel: [&lt;ee180805&gt;] svcauth_unix_set_client+0x16d/0=
x1a0 [sunrpc]</div>
<div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel: [&lt;ee17d63f&gt;] svc_pro=
cess+0x391/0x656 [sunrpc]</div><div>Sep =A03 04:45:39 ip-10-204-xxx-xxx ker=
nel: [&lt;ee2d7756&gt;] nfsd+0x171/0x277 [nfsd]</div><div>Sep =A03 04:45:39=
 ip-10-204-xxx-xxx kernel: [&lt;ee2d75e5&gt;] nfsd+0x0/0x277 [nfsd]</div>
<div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel: [&lt;c100598f&gt;] kernel_=
thread_helper+0x7/0x10</div><div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel=
: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</di=
v><div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel: xfs_force_shutdown(dm-1,=
0x8) called from line 1139 of file fs/xfs/xfs_trans.c. =A0Return address =
=3D 0xee287778</div>
<div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel: Filesystem &quot;dm-1&quot=
;: Corruption of in-memory data detected. =A0Shutting down filesystem: dm-1=
</div><div>Sep =A03 04:45:39 ip-10-204-xxx-xxx kernel: Please umount the fi=
lesystem, and rectify the problem(s)</div>
</div><div><br></div><div><br></div><div><div>We searched and found this li=
st, and a few patches around kernel 2.6.26-2.6.27 that seem to match our sc=
enario. We were able to log the specific mkdir command that failed and conf=
irmed it consistently fails that way that gives &quot;no space left on devi=
ce&quot;, while we did not reproduce the same issue mkdir in other director=
ies with large inode numbers. We haven&#39;t tried patching or upgrading th=
e kernel yet, but we will do that later.</div>
<div><br></div><div>As the root cause of that patch points to a bug trigger=
ed by ENOSPC, we checked the inode numbers created for some directories and=
 files with &quot;ls -li&quot; and some of them are pretty close to 2^32.=
=A0</div>
<div><br></div><div>So,=A0we would like to ascertain if that is the cause f=
or ENOSPC in our case, and does that mean 32-bit inodes are no longer adequ=
ate for us and we should switch to 64-bit inodes? Will switching it avoid t=
his kind of shutdowns with successful writes in the future?</div>
<div><br></div><div>And is it true that we don&#39;t need a 64-bit OS for 6=
4-bit inodes? How can we tell if our system supports 64-bit inodes?</div><d=
iv><br></div><div>Finally, although we all know that &quot;df -i&quot; is s=
ort of nonsense on XFS, how can we get the output of 5% inode while having =
inode numbers that are close to 2^32? So what does that 5% exactly mean, or=
 were I looking at inodes the wrong way?</div>
<div><br></div><div>Thanks in advance for any insights anyone may shed on t=
his one.</div><div><br></div>-- <br><br><div>Regards,</div><div>Bernard Cha=
n.</div><div>GoAnimate.</div><br>
</div>

--20cf305b0c8a244de004ac1771e2--


--===============5744438163654219211==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5744438163654219211==--
