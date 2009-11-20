Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAK24ofh093999 for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 20:04:50 -0600
Received: from ey-out-1920.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 201FF97E9E
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 18:05:02 -0800 (PST)
Received: from ey-out-1920.google.com (ey-out-1920.google.com [74.125.78.145])
	by cuda.sgi.com with ESMTP id RbHJExlCTbxfhUXr for
	<xfs@oss.sgi.com>; Thu, 19 Nov 2009 18:05:02 -0800 (PST)
Received: by ey-out-1920.google.com with SMTP id 26so732355eyw.22
	for <xfs@oss.sgi.com>; Thu, 19 Nov 2009 18:05:01 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 20 Nov 2009 02:05:01 +0000
Message-ID: <74fd948d0911191805m30c34b51m97c2a998dbe0bac3@mail.gmail.com>
Subject: Improving XFS desktop performance?
From: Pedro Ribeiro <pedrib@gmail.com>
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
To: xfs@oss.sgi.com

Hi all,

I've been using XFS since 2007 and I although I'm quite happy with its
performance, I am always looking at ways to improve it.
My usage is a regular desktop machine, for software development and
web browsing.
The main performance bottleneck I have is LUKS :-) However, I really
like my data encrypted, so dissing it is not an option. Actually, I'm
the xfs improvements discussed below I was able to get the performance
hit to something like 10% - negligible for me.

So what I do is specify a 128m log on filesystem creation:
mkfs.xfs -l size=128m /dev/mapper/target

And on /etc/fstab mount it as;
/dev/mapper/target      noatime,logbufs=8,logbsize=256k

After the above, my delete speed improved drastically.

Searching around the net I was able to find that using "lazy-count=1"
on mkfs would give a performance increase - how much would that be,
enough for me to do a full backup, format with that option + 128m log
and then restore all again?
And anything else you recommend?

Thanks for your time,
Pedro

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
