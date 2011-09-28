Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8S2qLVR080670 for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 21:52:21 -0500
Received: from mta31.charter.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4E7EC1C4CE20
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 19:52:19 -0700 (PDT)
Received: from mta31.charter.net (mta31.charter.net [216.33.127.82]) by
	cuda.sgi.com with ESMTP id P1xnuJleTBNvrwdz for
	<xfs@oss.sgi.com>; Tue, 27 Sep 2011 19:52:19 -0700 (PDT)
Received: from imp09 ([10.20.200.9]) by mta31.charter.net
	(InterMail vM.7.09.02.04 201-2219-117-106-20090629) with ESMTP
	id <20110928025219.QPLD3994.mta31.charter.net@imp09>
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 22:52:19 -0400
Received: from [172.17.100.41] (unknown [67.130.187.94])
	by cchtml.com (Postfix) with ESMTPSA id BA9E2C0287BED
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2011 21:52:17 -0500 (CDT)
Message-ID: <4E828BE1.8030003@cchtml.com>
Date: Tue, 27 Sep 2011 21:52:17 -0500
From: Michael Cronenworth <mike@cchtml.com>
MIME-Version: 1.0
Subject: Re: 64-bit inodes and back again
References: <4E825C25.6050804@cchtml.com> <20110928011020.GE3159@dastard>
	<4E8278D8.9060309@cchtml.com>
In-Reply-To: <4E8278D8.9060309@cchtml.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Dave Chinner on 09/27/2011 08:10 PM wrote:
 > I'm pretty sure this was fixed in 2.6.37.

I upgraded to kernel 2.6.38. The files are now visible.

Michael Cronenworth wrote:
>> xfs_reno is a tool designed to move all 64 bit inodes back into the
>> 32 bit inode space again.
>>
>> http://xfs.org/index.php/Unfinished_work#The_xfs_reno_tool
>
> I'll give this a shot first.

I did try this tool first, but it didn't seem to work for me:

# xfs_reno -vv 
/tmp/q.save/7074d797d8cd5965224f21a778924aa44a0871f4-qt-x11-4.7.4-2.fc14-x86_64 

xfs_reno: Cannot stat 
/tmp/q.save/7074d797d8cd5965224f21a778924aa44a0871f4-qt-x11-4.7.4-2.fc14-x86_64: 
Invalid argument
# xfs_reno -fvv /tmp/q.save
Scanning directory tree...
Processing 1 directory...
xfs_reno: directory: 97367 1 /tmp/q.save
xfs_reno: unable to duplicate directory attributes: /tmp/q.save
0 seconds elapsed
Done.
# ls -l /tmp/q.save/
ls: cannot access 
/tmp/q.save/b0afb399c40e9a45061b5cee73770def741d270e-qt-4.7.4-2.fc14-x86_64: 
Invalid argument
ls: cannot access 
/tmp/q.save/7074d797d8cd5965224f21a778924aa44a0871f4-qt-x11-4.7.4-2.fc14-x86_64: 
Invalid argument
total 8
drwxr-xr-x. 2 root root 4096 Sep 27 22:33 
310514e5d8aff198342a469b59311b7fa3af0d28-qt-webkit-4.7.4-2.fc14-x86_64
??????????? ? ?    ?       ?            ? 
7074d797d8cd5965224f21a778924aa44a0871f4-qt-x11-4.7.4-2.fc14-x86_64
??????????? ? ?    ?       ?            ? 
b0afb399c40e9a45061b5cee73770def741d270e-qt-4.7.4-2.fc14-x86_64
-rw-------. 1 root root   83 Sep 27 22:38 xfs_reno.recover

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
