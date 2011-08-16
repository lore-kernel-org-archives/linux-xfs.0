Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7GHTpOo224187 for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 12:29:51 -0500
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66C7918D8499
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 10:29:49 -0700 (PDT)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id GvkGsALJQNqIvQjW
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 10:29:49 -0700 (PDT)
Received: by qwb7 with SMTP id 7so86461qwb.26
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 10:29:49 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 16 Aug 2011 10:29:49 -0700
Message-ID: <CAE-kmAw1m8HNn_sHpVx6DtTGCr4XdsiG5KM3FNnMe_fibjyaVw@mail.gmail.com>
Subject: xfs_quota unable to create project id's over 65535
From: brian wince <bswince@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1006802815200961183=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1006802815200961183==
Content-Type: multipart/alternative; boundary=20cf303b3e7f08cbeb04aaa2ba3b

--20cf303b3e7f08cbeb04aaa2ba3b
Content-Type: text/plain; charset=ISO-8859-1

Hello,
We use unix uids for project ids andnow have uids well over 65535.
Is there a way to force xfs_quota to use project id's above the 64k
boundary?
If not how are others getting past this limitation.
I have tried searching and could not find anything that states this is a
xfs_quota issue but not sure where else to start.

When setting project quota using the command xfs_quota -x -c "project -s
projectname" it returns and "Invalid argument".

Setting up project projectname (path /usr/tftpboot/users/projectname)...
xfs_quota: cannot set project on /usr/tftpboot/users/projectname: Invalid
argument
Processed 1 (/etc/projects and cmdline) paths for project projectname with
recursion depth infinite (-1).



Any help would be greatly appreciated.

TIA,

brian

--20cf303b3e7f08cbeb04aaa2ba3b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,<br>We use unix uids for project ids andnow have uids well over 65535=
.<br>Is there a way to force xfs_quota to use project id&#39;s above the 64=
k boundary?<br>If not how are others getting past this limitation.<br>I hav=
e tried searching and could not find anything that states this is a xfs_quo=
ta issue but not sure where else to start.<br>
<br>When setting project quota using the command xfs_quota -x -c &quot;proj=
ect -s projectname&quot; it returns and &quot;Invalid argument&quot;.<br><b=
r>Setting up project projectname (path /usr/tftpboot/users/projectname)...<=
br>
xfs_quota: cannot set project on /usr/tftpboot/users/projectname: Invalid a=
rgument<br>Processed 1 (/etc/projects and cmdline) paths for project projec=
tname with recursion depth infinite (-1).<br><br><br><br>Any help would be =
greatly appreciated.<br>
<br>TIA,<br><br>brian<br>

--20cf303b3e7f08cbeb04aaa2ba3b--


--===============1006802815200961183==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1006802815200961183==--
