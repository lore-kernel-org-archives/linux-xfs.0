Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A8B037F55
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 14:49:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 771198F8065
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 12:49:15 -0700 (PDT)
Received: from mail-qg0-f43.google.com (mail-qg0-f43.google.com
	[209.85.192.43]) by cuda.sgi.com with ESMTP id QGHCxAnycfIDJmEe
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 30 May 2014 12:49:13 -0700 (PDT)
Received: by mail-qg0-f43.google.com with SMTP id 63so6868724qgz.30
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 12:49:13 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 30 May 2014 15:49:13 -0400
Message-ID: <CAA43vkVzWRTqNQh2VSi5yvFLtstmVOKRJUnYw_ZSkYJGsex8Uw@mail.gmail.com>
Subject: What to do when... xfs_repair hangs?
From: Sean Caron <scaron@umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6643844973939390309=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Sean Caron <scaron@umich.edu>

--===============6643844973939390309==
Content-Type: multipart/alternative; boundary=089e01536b7202f05a04faa3574e

--089e01536b7202f05a04faa3574e
Content-Type: text/plain; charset=UTF-8

Hi all,

Long story short, we have a big array formatted as XFS, we had a machine go
down hard maybe a month, month and a half ago... when it came back up, XFS
faulted out when we attempted to mount the filesystem; it complained the
log was bad or something... I did a dry run of xfs_repair (-L) and it
looked pretty bad, so we mounted up the filesystem read-only, ran a
backup... I think we got pretty much everything out OK except maybe files
that were open at the time of the crash.

Now with a backup in hand, we kicked off xfs_repair "for real"... it ran
for a while and did its thing, but now it appears to be stuck at the stage -

- agno = 436
rebuilding directory inode ...
rebuilding directory inode ...
rebuilding directory inode ...
...
- traversal finished ...
- moving disconected inodes to lost+found ...
disconnected inode 1109099673,

and then it just stops. I don't know how long its been sitting like that,
but it hasn't moved in the last hour or two. I assume that's not good...

Interestingly when we ran a dry run of xfs_repair (-L) it got all the way
through; it never hung up at any point. Not sure why it would start to hang
up, once it gets run "for real".

This machine is in single-user-mode, I have exactly 24 lines of console
with no scrollback buffer, no other tty available besides that which I'm
running xfs_repair on, the system console.

Running Linux kernel 3.4.61, Ubuntu 12.04 LTS 64-bit with whatever their
current xfsprogs is.

This is a bit of an exceptional situation for me; I've never seen
xfs_repair just hang outright. I hoped I could maybe get some feedback from
the experts here... what should I do?

Try to Control-C out of the xfs_repair and ... re-run it?

Should I just quit wasting time at this point, wipe out the filesystem,
reformat, then just start the long process of restoring from the backups?

Original plan was just to run xfs_repair, see what happened and pull from
backups as required to fix damage. Perhaps we should just cut to the chase,
rebuild, and restore everything? Probably the file system would be
ultimately healthier starting from scratch, than what xfs_repair leaves
behind?

Any insight would be very much appreciated!

Thanks,

Sean

--089e01536b7202f05a04faa3574e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi all,<div><br></div><div>Long story short, we have a big=
 array formatted as XFS, we had a machine go down hard maybe a month, month=
 and a half ago... when it came back up, XFS faulted out when we attempted =
to mount the filesystem; it complained the log was bad or something... I di=
d a dry run of xfs_repair (-L) and it looked pretty bad, so we mounted up t=
he filesystem read-only, ran a backup... I think we got pretty much everyth=
ing out OK except maybe files that were open at the time of the crash.</div=
>
<div><br></div><div>Now with a backup in hand, we kicked off xfs_repair &qu=
ot;for real&quot;... it ran for a while and did its thing, but now it appea=
rs to be stuck at the stage -</div><div><br></div><div>- agno =3D 436</div>
<div>rebuilding directory inode ...</div><div>rebuilding directory inode ..=
.</div><div>rebuilding directory inode ...</div><div>...</div><div>- traver=
sal finished ...</div><div>- moving disconected inodes to lost+found ...</d=
iv>
<div>disconnected inode 1109099673,</div><div><br></div><div>and then it ju=
st stops. I don&#39;t know how long its been sitting like that, but it hasn=
&#39;t moved in the last hour or two. I assume that&#39;s not good...</div>
<div><br></div><div>Interestingly when we ran a dry run of xfs_repair (-L) =
it got all the way through; it never hung up at any point. Not sure why it =
would start to hang up, once it gets run &quot;for real&quot;.</div><div>
<br></div><div>This machine is in single-user-mode, I have exactly 24 lines=
 of console with no scrollback buffer, no other tty available besides that =
which I&#39;m running xfs_repair on, the system console.</div><div><br>
</div><div>Running Linux kernel 3.4.61, Ubuntu 12.04 LTS 64-bit with whatev=
er their current xfsprogs is.</div><div><br></div><div>This is a bit of an =
exceptional situation for me; I&#39;ve never seen xfs_repair just hang outr=
ight. I hoped I could maybe get some feedback from the experts here... what=
 should I do?</div>
<div><br></div><div>Try to Control-C out of the xfs_repair and ... re-run i=
t?</div><div><br></div><div>Should I just quit wasting time at this point, =
wipe out the filesystem, reformat, then just start the long process of rest=
oring from the backups?</div>
<div><br></div><div>Original plan was just to run xfs_repair, see what happ=
ened and pull from backups as required to fix damage. Perhaps we should jus=
t cut to the chase, rebuild, and restore everything? Probably the file syst=
em would be ultimately healthier starting from scratch, than what xfs_repai=
r leaves behind?</div>
<div><br></div><div>Any insight would be very much appreciated!</div><div><=
br></div><div>Thanks,</div><div><br></div><div>Sean</div></div>

--089e01536b7202f05a04faa3574e--


--===============6643844973939390309==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6643844973939390309==--
