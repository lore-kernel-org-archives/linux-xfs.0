Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAU5wWJn193979 for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 23:58:32 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3D521D9EF96
	for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 21:59:00 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id dMDDDk0v1I3Uz6xK for
	<xfs@oss.sgi.com>; Sun, 29 Nov 2009 21:59:00 -0800 (PST)
References: <409bd82b0911292117n5aa11961u86e787d20acbd2b3@mail.gmail.com>
Message-Id: <D82BF068-68F6-46C6-8D08-A2F0A44842EC@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <409bd82b0911292117n5aa11961u86e787d20acbd2b3@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: Writing journal only in Big Endian format
Date: Sun, 29 Nov 2009 23:58:54 -0600
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0407700822313261576=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nitin Arora <nitin.arora.del@gmail.com>
Cc: "sandeen-xfs@sandeen.net" <sandeen-xfs@sandeen.net>, "p.mironchik@velesys.com" <p.mironchik@velesys.com>, "hch@xfs.org" <hch@xfs.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


--===============0407700822313261576==
Content-Type: multipart/alternative;
	boundary=Apple-Mail-1--66822990
Content-Transfer-Encoding: 7bit


--Apple-Mail-1--66822990
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

On Nov 29, 2009, at 11:17 PM, Nitin Arora <nitin.arora.del@gmail.com>  
wrote:

> Hello,
>
> We are using XFS (Kernel 2.6.18) and facing a problem.
> When any XFS partition is plugged out from a little endian machine  
> and plugged in to a big endian machine,
> it cannot be mounted and gives the following error.
>
> FAT: utf8 is not a recommended IO charset for FAT filesystems,  
> filesystem will be case sensitive!
>
> FAT: bogus number of FAT structure
>
> VFS: Can't find a valid FAT filesystem on dev sda1.
>
> VFS: Can't find ext3 filesystem on dev sda1.
>
> XFS mounting filesystem sda1
>
> Starting XFS recovery on filesystem: sda1 (logdev: internal)
>
> XFS: dirty log written in incompatible format - can't recover
>
> XFS: log mount/recovery failed: error 5
>
> XFS: log mount failed
>
>

Yep this Is expected for a dirty log, but I think a cleanly unmounted  
filesystem should migrate without problems; is this not the case?

So really the problem should be limited to migrating -dirty-  
filesystems, and the complexity of endian-swapping the journal at  
runtime seems overly expensive for this odd case.

Just unmount before migration....

-Eric
>
> Mounting problem goes away after doing "xfs_repair -L /dev/sdb2"
>
> The problem is that big endian machine cannot recognize the journal  
> which was written in
> little endian format by the little endian machine and once the  
> journal is zerod out it can be mouted.
>
> Now the solution to above problem seems writing journal always in  
> big endian format.
>
> Please suggest me, Is there any design limitation in XFS for this.
> Is it okay and feasible to implement it if yes then please give some  
> pointers so that it can be implemented, under some
> suitable compile time switch.
>
> Thanks in advance...
>
> Regards
> Nitin Arora

--Apple-Mail-1--66822990
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: 7bit

<html><body bgcolor="#FFFFFF"><div>On Nov 29, 2009, at 11:17 PM, Nitin Arora &lt;<a href="mailto:nitin.arora.del@gmail.com">nitin.arora.del@gmail.com</a>&gt; wrote:<br><br></div><div></div><blockquote type="cite"><div>Hello,<br><br>We are using XFS (Kernel 2.6.18) and facing a problem.<br>When any XFS partition is plugged out from a little endian machine and plugged in to a big endian machine,<br>it cannot be mounted and gives the following error.<br>
<br><p><span lang="EN-US">FAT: utf8 is not a recommended IO charset for FAT 
filesystems, filesystem will be case sensitive!</span></p>
<p><span lang="EN-US">FAT: bogus number of FAT structure</span></p>
<p><span lang="EN-US">VFS: Can't find a valid FAT filesystem on dev 
sda1.</span></p>
<p><span lang="EN-US">VFS: Can't find ext3 filesystem on dev 
sda1.</span></p>
<p><span lang="EN-US">XFS mounting filesystem sda1</span></p>
<p><span lang="EN-US">Starting XFS recovery on filesystem: sda1 (logdev: 
internal)</span></p>
<p><span style="color: red;" lang="EN-US">XFS: dirty log written in incompatible 
format - can't recover</span></p>
<p><span lang="EN-US">XFS: log mount/recovery failed: error 
5</span></p>
<p><span lang="EN-US">XFS: log mount failed</span></p><br></div></blockquote><div><br></div>Yep this Is expected for a dirty log, but I think a cleanly unmounted filesystem should migrate without problems; is this not the case?<div><br></div><div>So really the problem should be limited to migrating -dirty- filesystems, and the complexity of endian-swapping the journal at runtime seems overly expensive for this odd case.</div><div><br></div><div>Just unmount before migration....</div><div><br></div><div>-Eric<br><blockquote type="cite"><div><br>Mounting problem goes away after doing <i>"xfs_repair -L /dev/sdb2"<br><br></i>The problem is that big endian machine cannot recognize the journal which was written in <br>
little endian format by the little endian machine and once the journal is zerod out it can be mouted.<br><br>Now the solution to above problem seems writing journal always in big endian format.<br><br>Please suggest me, Is there any design limitation in XFS for this.<br>
Is it okay and feasible to implement it if yes then please give some pointers so that it can be implemented, under some <br>suitable compile time switch.<br><br>Thanks in advance...<br><br>Regards<br>Nitin Arora<br>
</div></blockquote></div></body></html>
--Apple-Mail-1--66822990--


--===============0407700822313261576==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0407700822313261576==--
