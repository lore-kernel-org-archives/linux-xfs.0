Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7EB6A7F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 17:42:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D897AC008
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 15:42:37 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22]) by cuda.sgi.com
	with ESMTP id nFi0XpL61L6uhWyv (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Oct 2014 15:42:35 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-71b11a39-d57a-4c02-beb5-b14725062d6b-1412894554032@3capp-gmx-bs27>
From: Dragon <Sunghost@gmx.de>
Subject: Re: XFS Filesystem is broken and cant repair and mount!
Date: Fri, 10 Oct 2014 00:42:34 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4497400261158967980=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4497400261158967980==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>Hi Dave,</div>

<div>i do and have to use Option -L but it was with success. I reboot the system and tried to copy the files again and after a view hundreds of MB the failure occures again. A actually do xfs_repair -L again, but i think the problem still exists. Any idea where the problem cames from and what i could do? I will now check the smart values.</div>

<div>
<pre>-------------------
On Thu, Oct 09, 2014 at 11:37:32PM +0200, Dragon wrote:
</pre>

<blockquote>Hello Dave, and thx for reply. I have no backup and no disk todo this ;(. Here the result from xfs_repair -n:<a href="http://pastebin.com/jC5S0KSH" target="_blank">http://pastebin.com/jC5S0KSH</a></blockquote>
Looks like a handful of corrupted inode blocks, with the main problem being that the inodes 3469995058-3469995060 (i.e. 3 inodes) do not have the corect magic numbers in them. the rest of the inodes in that chunk are corrupt in some way, too, so it would seem that there&#39;s been some kind of write error to these inodes. xfs_repair should fix this problems without issues. Cheers, Dave. <span class="sig">-- Dave Chinner <a href="mailto:david@fromorbit.com">david@fromorbit.com</a> </span></div></div></body></html>


--===============4497400261158967980==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4497400261158967980==--
