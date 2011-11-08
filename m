Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA8IV7MN141672 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 12:31:07 -0600
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8222E1CF50BD
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 10:31:06 -0800 (PST)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id K81e1KB2sFrcFHqB
	for <xfs@oss.sgi.com>; Tue, 08 Nov 2011 10:31:06 -0800 (PST)
Received: by vws19 with SMTP id 19so817422vws.26
	for <xfs@oss.sgi.com>; Tue, 08 Nov 2011 10:31:05 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 8 Nov 2011 09:31:05 -0900
Message-ID: <CACXvBApxwWUyYNfRL9rS32t7f04XCDwafbR7fSFjmXg8fJRpTg@mail.gmail.com>
Subject: quota mismatch for NFS mount of XFS filesystem
From: Liam Forbes <loforbes@alaska.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I searched the archives, but didn't find anything about incorrect
quota information for an NFS mounted XFS filesystem.  I hope somebody
might have an idea.

We have a RHEL 5.7 server mounting a 15T XFS filesystem and exporting
it to RHEL 5.6 and 5.7 clients.  quota and xfs_quota on the server
show a user using ~5.8T, but quota on a client only shows ~1.8T.

Server:
nfs2:~$ cat /etc/redhat-release
Red Hat Enterprise Linux Server release 5.7 (Tikanga)
nfs2:~$ uname -a
Linux nfs2 2.6.18-274.3.1.el5 #1 SMP Fri Aug 26 18:49:02 EDT 2011 x86_64 x8=
6_64
nfs2:~$ rpm -qa | grep xfsprogs
xfsprogs-2.9.4-1.el5.centos
nfs2:~$ sudo quota -s -v -u krieger
Disk quotas for user krieger (uid 3105):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   g=
race
/dev/mapper/primaryfs_vg-primaryfs
                  5901G       0       0            310k       0       0
nfs2:~$ sudo /usr/sbin/xfs_quota
xfs_quota> quota -u -h krieger
Disk quotas for User krieger (3105)
Filesystem   Blocks  Quota  Limit Warn/Time    Mounted on
/dev/primaryfs_vg/primaryfs
               5.8T      0      0  00 [------] /export/wrkdir20
xfs_quota> quit

Client:
pacman1:~$ cat /etc/redhat-release
Red Hat Enterprise Linux Server release 5.6 (Tikanga)
pacman1:~$ uname -a
Linux pacman1 2.6.18-238.19.1.563g0000.el5 #1 SMP Fri Jul 15 20:26:36
EDT 2011 x86_64 x86_64 x86_64 GNU/Linux
pacman1:~$ sudo quota -s -v -u krieger
Disk quotas for user krieger (uid 3105):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   g=
race
nfs2:/export/wrkdir20
                  1806G       0       0            310k       0       0

Could there be a miscalculation due to differing block sizes?  Other
suggestions of what to look at?  I'm not seeing any errors in logs
(which doesn't surprise me).

-- =

Regards,
-liam

-There are uncountably more irrational fears than rational ones. -P. Dolan
Liam Forbes=A0 =A0 =A0=A0 HPC Systems Analyst,=A0 =A0 =A0 HPC&S Group Leade=
r,=A0 =A0 =A0 CISSP
ARSC, U of AK, Fairbanks=A0=A0 lforbes@arsc.edu 907-450-8618 fax: 907-450-8=
605

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
