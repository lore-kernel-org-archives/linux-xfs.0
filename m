Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 84C5B804E
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 10:40:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6BE768F804B
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 08:40:28 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.8])
	by cuda.sgi.com with ESMTP id oXc3Ew1OlxgONvSR (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Mar 2013 08:40:26 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by tyrex.lisa.loc (Postfix) with ESMTP id 7140F1B971B00
	for <xfs@oss.sgi.com>; Mon,  4 Mar 2013 17:40:25 +0100 (CET)
Received: from tyrex.lisa.loc ([127.0.0.1])
	by localhost (tyrex.lisa.loc [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 1hCBpu20T1kh for <xfs@oss.sgi.com>;
	Mon,  4 Mar 2013 17:40:13 +0100 (CET)
From: Hans-Peter Jansen <hpj@urpla.net>
Subject: strange behavior of a larger xfs directory
Date: Mon, 04 Mar 2013 17:40:13 +0100
Message-ID: <4300208.uZ6HVTycB6@xrated>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

after upgrading the kernel on a server from 2.6.34 to 3.8.1 (x86-32), I 
suffer from a strange behavior of a larger directory, that a downgrade 
of the kernel cannot repair.

The best way to reproduce the problem is cd into that directory and 
running "vi .". It should display a full directory listing, but it only 
displays a about dozen entries. Another way is just using bash tab 
completion (e.g. ls <tab><tab> should display a screenful of items, but 
only shows the very same dozen of entries. Userspace is quite old 
(openSUSE 11.1/i586, but I cannot upgrade to a newer userspace for a 
couple of reasons. OTOH, a simple ls displays the full list again, as 
well as does a simple python script:

import os
for i in os.listdir("/video/video"):
	 print i, os.lstat(os.path.join("/video/video", i))

As far as I understand Linux, this kind of kernel upgrade should work 
just fine (minus the usual udev fallout, that isn't an issue for a server 
(this one at least). Everything is working fine so far, bind, dhcpd, 
samba, NFS3 (homes are mounted from it), postfix, cyrus imapd, mysql 
(with many databases), ntp, you name it. It is also serving vdr video 
streams and records, and its record directory is the one, that shows 
the issues, resulting in some displeasure in my family.

stracing the vi call reveals 

27177 open("/video/video/", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|O_CLOEXEC) = 3
27177 fstat64(3, {st_dev=makedev(8, 65), st_ino=357, st_mode=S_IFDIR|0775, st_nlink=350, 
              st_uid=223, st_gid=33, st_blksize=4096, st_blocks=40, st_size=16384, 
              st_atime=2013/03/04-16:12:37, st_mtime=2013/03/04-16:17:52, 
              st_ctime=2013/03/04-16:17:52}) = 0
27177 getdents64(3, {
              {d_ino=357, d_off=4, d_type=DT_UNKNOWN, d_reclen=24, d_name="."} 
              {d_ino=128, d_off=6, d_type=DT_UNKNOWN, d_reclen=24, d_name=".."} 
              {d_ino=367, d_off=12, d_type=DT_UNKNOWN, d_reclen=56, d_name="%Avatar_-_Aufbruch_nach_Pandora"} 
              {d_ino=368, d_off=18, d_type=DT_UNKNOWN, d_reclen=56, d_name="%Der_Deutsche_Comedy_Preis_2009"}
              [...]
              {d_ino=4303329151, d_off=78, d_type=DT_UNKNOWN, d_reclen=32, d_name="Black_Swan"}
              [...]}) = 4072
# note: including items, that are missing later on, probably all

27177 _llseek(3, 74, [74], SEEK_SET)    = 0

# now a couple of stat64 calls of entries that are displayed later

27177 stat64("/video/video/%Avatar_-_Aufbruch_nach_Pandora", {st_dev=makedev(8, 65), 
             st_ino=367, st_mode=S_IFDIR|0755, st_nlink=3, st_uid=223, st_gid=33, 
             st_blksize=4096, st_blocks=0, st_size=39, st_atime=2013/03/04-07:49:20, 
             st_mtime=2011/02/03-23:21:08, st_ctime=2011/09/10-17:55:32}) = 0
27177 stat64("/video/video/%Avatar_-_Aufbruch_nach_Pandora", {st_dev=makedev(8, 65), 
             st_ino=367, st_mode=S_IFDIR|0755, st_nlink=3, st_uid=223, st_gid=33, 
             st_blksize=4096, st_blocks=0, st_size=39, st_atime=2013/03/04-07:49:20, 
             st_mtime=2011/02/03-23:21:08, st_ctime=2011/09/10-17:55:32}) = 0
27177 stat64("/video/video/%Avatar_-_Aufbruch_nach_Pandora", {st_dev=makedev(8, 65), 
             st_ino=367, st_mode=S_IFDIR|0755, st_nlink=3, st_uid=223, st_gid=33, 
             st_blksize=4096, st_blocks=0, st_size=39, st_atime=2013/03/04-07:49:20, 
             st_mtime=2011/02/03-23:21:08, st_ctime=2011/09/10-17:55:32}) = 0
[...]

# then it preceeds with getdents64 and fetches already fetched entries

27177 getdents64(3, {
             {d_ino=4303329151, d_off=78, d_type=DT_UNKNOWN, d_reclen=32, d_name="Black_Swan"} 
				  [...]}) = 4088
            
27177 close(3)                          = 0


This looks silly. Shouldn't getdent64 only return not yet processed 
entries?


Full trace is available here: ftp://urpla.net/video.trc

xfs-info:

meta-data=/dev/sde1              isize=256    agcount=5, agsize=268435455 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=1098632439, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


xfs_repair (3.1.6) doesn't choke on any errors.


Could some kind soul with more insight shed some light on this issue?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
