Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0AKQfIS095405 for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 14:26:41 -0600
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	XbKFMkbP6vTX8KbE for <xfs@oss.sgi.com>;
	Tue, 10 Jan 2012 12:26:39 -0800 (PST)
Received: by wibhq2 with SMTP id hq2so4291389wib.26
	for <xfs@oss.sgi.com>; Tue, 10 Jan 2012 12:26:38 -0800 (PST)
From: Rafa =?utf-8?q?Grim=C3=A1n?= <rafagriman@gmail.com>
Subject: Empty dir can't be removed ... because it's not empty?
Date: Tue, 10 Jan 2012 21:26:35 +0100
MIME-Version: 1.0
Message-Id: <201201102126.35268.rafagriman@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Hi all :)

My /home is on an XFS partition all to it's own. The other day the lights went 
out and when I rebooted, there's an empty directory that can't be erased. This 
directory is a subdirectory in ~/.kde4/

The funny thing about this is that I can rename the directory, but I can't 
delete it:

[root@mine albumcovers]# ls
.  ..  cache

[root@mine albumcovers]# ls -lah cache/
total 0
drwx------ 1 rafa users  6 Jan 10 02:23 .
drwx------ 3 rafa users 18 Jan 10 02:23 ..

[root@mine albumcovers]# du -sh cache/
0       cache/

[root@mine albumcovers]# mount | grep -i home
/dev/sda3 on /home type xfs (rw,relatime,attr2,delaylog,noquota)

[root@mine albumcovers]# file cache/
cache/: directory

[root@mine albumcovers]# rm -Rf cache/
rm: cannot remove `cache': Directory not empty

[root@mine albumcovers]# mv cache other_dir_name

[root@mine albumcovers]# ls
.  ..  other_dir_name

[root@mine albumcovers]# rm -Rf other_dir_name/
rm: cannot remove `other_dir_name': Directory not empty

[root@mine albumcovers]# ls -lah other_dir_name/
total 0
drwx------ 1 rafa users  6 Jan 10 02:23 .
drwx------ 3 rafa users 27 Jan 10 21:14 ..

[root@mine albumcovers]# du -sh other_dir_name/
0       other_dir_name/

[root@mine albumcovers]#



Kernel version: 3.1.8-1-ARCH (Arch Linux)

XFS: xfsprogs 3.1.7-1



Any idea of what's going on?
Any tool I can use to understand what's happening?

TIA

   Rafa

-- 
"We cannot treat computers as Humans. Computers need love."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
