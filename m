Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DEFF37F85
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 14:17:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8D8B304039
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2014 12:17:31 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19]) by cuda.sgi.com
	with ESMTP id mQHpqYHaGEE6ARoS (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Jun 2014 12:17:29 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-20fa04a2-b771-42eb-afb3-a915026306bd-1403810247665@3capp-gmx-bs14>
From: Dragon <Sunghost@gmx.de>
Subject: Re: XFS Repair hangs at inode repair in phase3
Date: Thu, 26 Jun 2014 21:17:27 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8750575605612129867=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8750575605612129867==
Content-Type: text/html; charset=UTF-8

<html><head></head><body><div style="font-family: Verdana;font-size: 12.0px;"><div>
<pre>Hello,
i upgraded to debian jessie with xfsprogs 3.2. if i run xfs_repair /dev/md2 the system hangs too. If i use -P it ends up with:
corrupt block 0 in directory inode 2147702899: junking block
Segmentation fault

if i use -n -P it ends up with:

No modify flag set, skipping phase 5
Inode allocation btrees are too corrupted, skipping phases 6 and 7
No modify flag set, skipping filesystem flush and exiting.

Files are still not accessible - i think i lost some TB ;( - not a good experience for first use of xfs...
On 6/24/2014 5:15 PM, Dragon wrote:
</pre>

<blockquote>Hi, yes read this, but i am new and dont know what this command will do and i dont want to lost my data. I read in the net, that some people couldnt start or boot from that disk, after running xfs_repair. I looked for a upgrade to latest xfsprogs version, but it seems difficult for amd64 systems. Do you have a changelog to latest version, could my installed version be ok, or better not to use? Thx Stan and Eric</blockquote>
# xfs_repair -n -P /dev/device Post the output in your next reply, assuming it doesn&#39;t hang again. Cheers, Stan</div></div></body></html>


--===============8750575605612129867==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8750575605612129867==--
