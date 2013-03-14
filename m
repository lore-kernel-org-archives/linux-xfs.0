Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4D2327F86
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:31:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3508330407A
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:31:32 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id RhBZZRWbPkzN0XHK
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:31:31 -0700 (PDT)
Message-ID: <5141D137.9080509@hardwarefreak.com>
Date: Thu, 14 Mar 2013 08:31:35 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem on EC2 instance corrupts and shuts down
References: <CAOdS1h=7X4O1O7X8YOwxtLm7G=fc+J+6hJxJ1RKbDmfTZXTpeg@mail.gmail.com>
	<51373DB8.2020707@redhat.com>
	<CAOdS1hnXGj9puaHxeToqmpK40A-3WvJnM7=5HckpyyZYqZTvEQ@mail.gmail.com>
	<51373FC1.6010101@redhat.com>
	<CAOurMUeasru6ekDYcvVR1QnaWVJFV+-coZsUG5SgG6LnENBvXg@mail.gmail.com>
	<513751F2.2060109@redhat.com>
	<CAOdS1hngSuHn_HiremLyUS7Qd9eZ68=8arfBuHnEpwXQaBw9Wg@mail.gmail.com>
	<5140CBE3.80705@sandeen.net> <20130313234213.GW21651@dastard>
	<CAOdS1hnVoMtXnOrECrU8xUyRn82UUJ=jMzX0_odnAs0GH8V-yA@mail.gmail.com>
In-Reply-To: <CAOdS1hnVoMtXnOrECrU8xUyRn82UUJ=jMzX0_odnAs0GH8V-yA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: Shrinath M <shrinath.m@webyog.com>
Cc: Sabyasachi Ruj <sabyasachi.ruj@webyog.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, Vivek Goel <vivek.goel@webyog.com>, Supratik Goswami <supratik.goswami@webyog.com>, Ric Wheeler <rwheeler@redhat.com>

On 3/13/2013 8:28 PM, Shrinath M wrote:
> Thanks Ben, Dave and Eric.
> 
> Eric,
>>> but I am wondering if there might be more information before this which
> is not in your trimmed logs.
> No, this was the first entry every time we have it in /var/log/messages.
> dmesg also holds the same. After reboot, it simply fixes without anyone
> doing anything.
...
>  - dmesg shows something like this after repairing/rebooting -
> 
> [    8.414176] SGI XFS with ACLs, security attributes, realtime, large
> block/inode numbers, no debug enabled
> [    8.415342] SGI XFS Quota Management subsystem
> [    8.417664] XFS (md0): Mounting Filesystem
> [    8.771553] XFS (md0): Starting recovery (logdev: internal)
> [    9.977325] XFS (md0): Ending recovery (logdev: internal)

The active log displayed by the dmesg command is cleared and started
fresh at each reboot, which maybe is why you don't see the IO errors.
You should find them in the previous dmesg log files.

$ ls -la /var/log/dmesg*
-rw-r--r-- 1 root adm  12K Feb 29  2012 /var/log/dmesg
-rw-r--r-- 1 root adm  12K Feb 20  2012 /var/log/dmesg.0
-rw-r--r-- 1 root adm 4.7K Aug 18  2011 /var/log/dmesg.1.gz
-rw-r--r-- 1 root adm 4.7K Aug 18  2011 /var/log/dmesg.2.gz
-rw-r--r-- 1 root adm 4.7K Jun 27  2011 /var/log/dmesg.3.gz
-rw-r--r-- 1 root adm 4.7K May 18  2011 /var/log/dmesg.4.gz

Don't let the file dates in this example throw you, here's why:

 08:14:42 up 378 days, 19:44,  1 user,  load average: 0.06, 0.31, 0.22
          ^^^^^^^^^^^

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
