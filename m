Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5TKZE75152608 for <xfs@oss.sgi.com>; Mon, 29 Jun 2009 15:35:14 -0500
Received: from mail37.messagelabs.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 5EFD31313FDB
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2009 13:35:44 -0700 (PDT)
Received: from mail37.messagelabs.com (mail37.messagelabs.com [216.82.241.83])
	by cuda.sgi.com with SMTP id bmE26cHDDtiirH6q for
	<xfs@oss.sgi.com>; Mon, 29 Jun 2009 13:35:44 -0700 (PDT)
In-Reply-To: <4A491887.8050509@sandeen.net>
References: <OF97A83ACB.604AE440-ON862575E4.00450F9F-862575E4.00475C94@genco.com>
	<4A491887.8050509@sandeen.net>
MIME-Version: 1.0
Subject: Re: Correct usage of inode64/running out of inodes
Message-ID: <OFBF693EDC.C9829EF7-ON862575E4.006F5BEE-862575E4.00711ED9@genco.com>
From: Adam Donald <Adam.Donald@gencopharma.com>
Date: Mon, 29 Jun 2009 15:35:41 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2849379571268706498=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

This is a multipart message in MIME format.
--===============2849379571268706498==
Content-Type: multipart/alternative; boundary="=_alternative 00711ED4862575E4_="

This is a multipart message in MIME format.
--=_alternative 00711ED4862575E4_=
Content-Type: text/plain; charset="US-ASCII"

From:
Eric Sandeen <sandeen@sandeen.net>
To:
Adam Donald <Adam.Donald@gencopharma.com>
Cc:
xfs@oss.sgi.com
Date:
06/29/2009 02:39 PM
Subject:
Re: Correct usage of inode64/running out of inodes



Adam Donald wrote:
> 
> Hello
> 
> In short, I believe that I have used the indode64 option correctly in
> mounting my XFS device on my Centos 5.2 system, however, I seem to only
> have 59 free inodes available and 7.5TB of free space.  I would
> appreciate any insight as to what the best approach would be to fix this
> situation.  In case it is helpful, I have included output from various
> commands/files below, the XFS device in question is
> /dev/mapper/VolGroup01-DATA01.  Thank you in advance for your 
assistance!

It all looks sane to me; what are the actual symptoms of the problem
You can create 59 files and then -ENOSPC?  Any kernel messages?

Maybe this is a bug in the old xfs code in the centos module... though I
don't remember such a bug right now.s

-Eric

> uname:
> Linux NAS01 2.6.18-92.1.6.el5 #1 SMP Wed Jun 25 13:45:47 EDT 2008 x86_64
> x86_64 x86_64 GNU/Linux
> 
> df -h:
> Filesystem                            Size  Used Avail Use% Mounted on
> /dev/mapper/VolGroup00-LogVol00        71G   12G   55G  18% /
> /dev/sda1                              99M   25M   70M  26% /boot
> tmpfs                                 3.9G     0  3.9G   0% /dev/shm
> /dev/mapper/VolGroup01-DATA01          18T  9.9T  7.5T  57% /DATA01
> 
> df -ih:
> Filesystem                          Inodes   IUsed   IFree IUse% Mounted 
on
> /dev/mapper/VolGroup00-LogVol00        19M    123K     19M    1% /
> /dev/sda1                              26K      44     26K    1% /boot
> tmpfs                                 999K       1    999K    1% 
/dev/shm
> /dev/mapper/VolGroup01-DATA01          18G    297K     18G    1% /DATA01
> 
> mount:
> ...
> /dev/mapper/VolGroup01-DATA01 on /DATA01 type xfs (rw,inode64)
> ...
> 
> fstab:
> ...
> /dev/VolGroup01/DATA01  /DATA01                 xfs 
> rw,suid,dev,exec,auto,nouser,async,inode64      1 0
> ...

Thank you for your response.  To be honest, I only ran out of "space" 
(inodes) once on this volume a month or so ago, and I recall receiving a 
ENOSPC type error at that time.  At the time I received out of space 
errors I found the xfs_db command and have since started to monitor the 
ifree value, deleting files when I felt that ifree was dipping too low, as 
I was unable to apply the inode64 option without first taking down various 
production systems.  When the time came this past weekend to apply the 
inode64 option, I was expecting the ifree option value to shoot up 
dramatically (several hundred, perhaps), and instead the ifree value 
remained unaffected, the same as mounting the volume without the inode64 
option. 

Given the fact that I have this volume mounted with the inode64 option, 
have roughly 7.5TB free, and show ifree with a double digit number 
(currently 30 on our system), is there a an inconsistency between the 
total amount of free space available and the number of free inodes 
available?

Thanks again for the input, I appreciate it!


AD


______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
--=_alternative 00711ED4862575E4_=
Content-Type: text/html; charset="US-ASCII"


<br>
<br>
<table width=100%>
<tr valign=top>
<td><font size=1 color=#5f5f5f face="sans-serif">From:</font>
<td><font size=1 face="sans-serif">Eric Sandeen &lt;sandeen@sandeen.net&gt;</font>
<tr valign=top>
<td><font size=1 color=#5f5f5f face="sans-serif">To:</font>
<td><font size=1 face="sans-serif">Adam Donald &lt;Adam.Donald@gencopharma.com&gt;</font>
<tr>
<td valign=top><font size=1 color=#5f5f5f face="sans-serif">Cc:</font>
<td><font size=1 face="sans-serif">xfs@oss.sgi.com</font>
<tr valign=top>
<td><font size=1 color=#5f5f5f face="sans-serif">Date:</font>
<td><font size=1 face="sans-serif">06/29/2009 02:39 PM</font>
<tr valign=top>
<td><font size=1 color=#5f5f5f face="sans-serif">Subject:</font>
<td><font size=1 face="sans-serif">Re: Correct usage of inode64/running
out of inodes</font></table>
<br>
<hr noshade>
<br>
<br>
<br><tt><font size=2>Adam Donald wrote:<br>
&gt; <br>
&gt; Hello<br>
&gt; <br>
&gt; In short, I believe that I have used the indode64 option correctly
in<br>
&gt; mounting my XFS device on my Centos 5.2 system, however, I seem to
only<br>
&gt; have 59 free inodes available and 7.5TB of free space. &nbsp;I would<br>
&gt; appreciate any insight as to what the best approach would be to fix
this<br>
&gt; situation. &nbsp;In case it is helpful, I have included output from
various<br>
&gt; commands/files below, the XFS device in question is<br>
&gt; /dev/mapper/VolGroup01-DATA01. &nbsp;Thank you in advance for your
assistance!<br>
<br>
It all looks sane to me; what are the actual symptoms of the problem<br>
You can create 59 files and then -ENOSPC? &nbsp;Any kernel messages?<br>
<br>
Maybe this is a bug in the old xfs code in the centos module... though
I<br>
don't remember such a bug right now.s<br>
<br>
-Eric<br>
<br>
&gt; uname:<br>
&gt; Linux NAS01 2.6.18-92.1.6.el5 #1 SMP Wed Jun 25 13:45:47 EDT 2008
x86_64<br>
&gt; x86_64 x86_64 GNU/Linux<br>
&gt; <br>
&gt; df -h:<br>
&gt; Filesystem &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Size &nbsp;Used Avail Use% Mounted
on<br>
&gt; /dev/mapper/VolGroup00-LogVol00 &nbsp; &nbsp; &nbsp; &nbsp;71G &nbsp;
12G &nbsp; 55G &nbsp;18% /<br>
&gt; /dev/sda1 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;99M &nbsp; 25M &nbsp; 70M
&nbsp;26% /boot<br>
&gt; tmpfs &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3.9G &nbsp; &nbsp; 0 &nbsp;3.9G
&nbsp; 0% /dev/shm<br>
&gt; /dev/mapper/VolGroup01-DATA01 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;18T
&nbsp;9.9T &nbsp;7.5T &nbsp;57% /DATA01<br>
&gt; <br>
&gt; df -ih:<br>
&gt; Filesystem &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Inodes &nbsp; IUsed &nbsp; IFree IUse%
Mounted on<br>
&gt; /dev/mapper/VolGroup00-LogVol00 &nbsp; &nbsp; &nbsp; &nbsp;19M &nbsp;
&nbsp;123K &nbsp; &nbsp; 19M &nbsp; &nbsp;1% /<br>
&gt; /dev/sda1 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;26K &nbsp; &nbsp; &nbsp;44
&nbsp; &nbsp; 26K &nbsp; &nbsp;1% /boot<br>
&gt; tmpfs &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 999K &nbsp; &nbsp; &nbsp;
1 &nbsp; &nbsp;999K &nbsp; &nbsp;1% /dev/shm<br>
&gt; /dev/mapper/VolGroup01-DATA01 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;18G
&nbsp; &nbsp;297K &nbsp; &nbsp; 18G &nbsp; &nbsp;1% /DATA01<br>
&gt; <br>
&gt; mount:<br>
&gt; ...<br>
&gt; /dev/mapper/VolGroup01-DATA01 on /DATA01 type xfs (rw,inode64)<br>
&gt; ...<br>
&gt; <br>
&gt; fstab:<br>
&gt; ...<br>
&gt; /dev/VolGroup01/DATA01 &nbsp;/DATA01 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; xfs &nbsp; &nbsp;<br>
&gt; rw,suid,dev,exec,auto,nouser,async,inode64 &nbsp; &nbsp; &nbsp;1 0<br>
&gt; ...<br>
</font></tt>
<br><tt><font size=2>Thank you for your response. &nbsp;To be honest, I
only ran out of &quot;space&quot; (inodes) once on this volume a month
or so ago, and I recall receiving a ENOSPC type error at that time. &nbsp;At
the time I received out of space errors I found the xfs_db command and
have since started to monitor the ifree value, deleting files when I felt
that ifree was dipping too low, as I was unable to apply the inode64 option
without first taking down various production systems. &nbsp;When the time
came this past weekend to apply the inode64 option, I was expecting the
ifree option value to shoot up dramatically (several hundred, perhaps),
and instead the ifree value remained unaffected, the same as mounting the
volume without the inode64 option. &nbsp;</font></tt>
<br>
<br><tt><font size=2>Given the fact that I have this volume mounted with
the inode64 option, have roughly 7.5TB free, and show ifree with a double
digit number (currently 30 on our system), is there a an inconsistency
between the total amount of free space available and the number of free
inodes available?</font></tt>
<br>
<br><tt><font size=2>Thanks again for the input, I appreciate it!</font></tt>
<br>
<br>
<br><tt><font size=2>AD</font></tt>
<br>

<BR>
______________________________________________________________________<BR>
This email has been scanned by the MessageLabs Email Security System.<BR>
For more information please visit http://www.messagelabs.com/email <BR>
______________________________________________________________________<BR>

--=_alternative 00711ED4862575E4_=--


--===============2849379571268706498==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2849379571268706498==--
