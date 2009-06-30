Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5UK8UmQ227092 for <xfs@oss.sgi.com>; Tue, 30 Jun 2009 15:08:31 -0500
Received: from mail201.messagelabs.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 5B014333869
	for <xfs@oss.sgi.com>; Tue, 30 Jun 2009 13:09:00 -0700 (PDT)
Received: from mail201.messagelabs.com (mail201.messagelabs.com
	[216.82.254.211]) by cuda.sgi.com with SMTP id CNaYuQW7JiEFlY8s
	for <xfs@oss.sgi.com>; Tue, 30 Jun 2009 13:09:00 -0700 (PDT)
In-Reply-To: <4A4927B9.7050304@sandeen.net>
References: <OF97A83ACB.604AE440-ON862575E4.00450F9F-862575E4.00475C94@genco.com>
	<4A491887.8050509@sandeen.net>
	<OFBF693EDC.C9829EF7-ON862575E4.006F5BEE-862575E4.00711ED9@genco.com>
	<4A4927B9.7050304@sandeen.net>
MIME-Version: 1.0
Subject: Re: Correct usage of inode64/running out of inodes
Message-ID: <OF99AF02C8.61A3BD6F-ON862575E5.006DE8C2-862575E5.006EA509@genco.com>
From: Adam Donald <Adam.Donald@gencopharma.com>
Date: Tue, 30 Jun 2009 15:08:38 -0500
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6573573895182901804=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

This is a multipart message in MIME format.
--===============6573573895182901804==
Content-Type: multipart/alternative; boundary="=_alternative 006EA504862575E5_="

This is a multipart message in MIME format.
--=_alternative 006EA504862575E5_=
Content-Type: text/plain; charset="US-ASCII"

From:
Eric Sandeen <sandeen@sandeen.net>
To:
Adam Donald <Adam.Donald@gencopharma.com>
Cc:
xfs@oss.sgi.com
Date:
06/29/2009 03:44 PM
Subject:
Re: Correct usage of inode64/running out of inodes



Adam Donald wrote:

> Thank you for your response.  To be honest, I only ran out of "space"
> (inodes) once on this volume a month or so ago, and I recall receiving a
> ENOSPC type error at that time.  At the time I received out of space
> errors I found the xfs_db command and have since started to monitor the
> ifree value, deleting files when I felt that ifree was dipping too low,
> as I was unable to apply the inode64 option without first taking down
> various production systems.  When the time came this past weekend to
> apply the inode64 option, I was expecting the ifree option value to
> shoot up dramatically (several hundred, perhaps), and instead the ifree
> value remained unaffected, the same as mounting the volume without the
> inode64 option. 

I don't -think- that the inode64 option affects the value reported via
statfs (though maybe it should; for dynamically allocated inodes it's
all make-believe anyway)

> Given the fact that I have this volume mounted with the inode64 option,
> have roughly 7.5TB free, and show ifree with a double digit number
> (currently 30 on our system), is there a an inconsistency between the
> total amount of free space available and the number of free inodes
> available?

hand-wavily, no, it seems fine... the way xfs reports free inodes (or
available inodes) is to look at how many blocks are free, and then how
many inodes -could- be created in that number of blocks, which is why
it's often absurdly high numbers.

inode32 behavior, fragmented free space, or lack of stripe-aligned space
(I think...) can sometimes cause spurious ENOSPC when looking for a new
inode...

-Eric

> Thanks again for the input, I appreciate it!
> 
> 
> AD

Again, I appreciated your input, and I am tending to agree with you that 
our setup is now fine since adding inode64.  I noticed that I had an ifree 
value of 9 this morning and I then used dd to create several large files. 
During the dd process the ifree value jumped to 63 without sending a space 
error - it appears that the inode64 setting is indeed working as intended, 
I just had incorrect expectations as to how this option would affect the 
actual display of ifree.  Thank you for helping me get this situation 
straightened out.


AD




______________________________________________________________________
This email has been scanned by the MessageLabs Email Security System.
For more information please visit http://www.messagelabs.com/email 
______________________________________________________________________
--=_alternative 006EA504862575E5_=
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
<td><font size=1 face="sans-serif">06/29/2009 03:44 PM</font>
<tr valign=top>
<td><font size=1 color=#5f5f5f face="sans-serif">Subject:</font>
<td><font size=1 face="sans-serif">Re: Correct usage of inode64/running
out of inodes</font></table>
<br>
<hr noshade>
<br>
<br>
<br><tt><font size=2>Adam Donald wrote:<br>
<br>
&gt; Thank you for your response. &nbsp;To be honest, I only ran out of
&quot;space&quot;<br>
&gt; (inodes) once on this volume a month or so ago, and I recall receiving
a<br>
&gt; ENOSPC type error at that time. &nbsp;At the time I received out of
space<br>
&gt; errors I found the xfs_db command and have since started to monitor
the<br>
&gt; ifree value, deleting files when I felt that ifree was dipping too
low,<br>
&gt; as I was unable to apply the inode64 option without first taking down<br>
&gt; various production systems. &nbsp;When the time came this past weekend
to<br>
&gt; apply the inode64 option, I was expecting the ifree option value to<br>
&gt; shoot up dramatically (several hundred, perhaps), and instead the
ifree<br>
&gt; value remained unaffected, the same as mounting the volume without
the<br>
&gt; inode64 option. &nbsp;<br>
<br>
I don't -think- that the inode64 option affects the value reported via<br>
statfs (though maybe it should; for dynamically allocated inodes it's<br>
all make-believe anyway)<br>
<br>
&gt; Given the fact that I have this volume mounted with the inode64 option,<br>
&gt; have roughly 7.5TB free, and show ifree with a double digit number<br>
&gt; (currently 30 on our system), is there a an inconsistency between
the<br>
&gt; total amount of free space available and the number of free inodes<br>
&gt; available?<br>
<br>
hand-wavily, no, it seems fine... the way xfs reports free inodes (or<br>
available inodes) is to look at how many blocks are free, and then how<br>
many inodes -could- be created in that number of blocks, which is why<br>
it's often absurdly high numbers.<br>
<br>
inode32 behavior, fragmented free space, or lack of stripe-aligned space<br>
(I think...) can sometimes cause spurious ENOSPC when looking for a new<br>
inode...<br>
<br>
-Eric<br>
<br>
&gt; Thanks again for the input, I appreciate it!<br>
&gt; <br>
&gt; <br>
&gt; AD<br>
</font></tt>
<br><tt><font size=2>Again, I appreciated your input, and I am tending
to agree with you that our setup is now fine since adding inode64. &nbsp;I
noticed that I had an ifree value of 9 this morning and I then used dd
to create several large files. &nbsp;During the dd process the ifree value
jumped to 63 without sending a space error - it appears that the inode64
setting is indeed working as intended, I just had incorrect expectations
as to how this option would affect the actual display of ifree. &nbsp;Thank
you for helping me get this situation straightened out.</font></tt>
<br>
<br>
<br><tt><font size=2>AD<br>
</font></tt>
<br>
<br>

<BR>
______________________________________________________________________<BR>
This email has been scanned by the MessageLabs Email Security System.<BR>
For more information please visit http://www.messagelabs.com/email <BR>
______________________________________________________________________<BR>

--=_alternative 006EA504862575E5_=--


--===============6573573895182901804==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6573573895182901804==--
