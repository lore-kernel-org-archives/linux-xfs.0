Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0O0YBQe166498 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 18:34:11 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id MaXtkrvGUB4Oeqqr
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 16:34:10 -0800 (PST)
Message-ID: <4F1DFC80.1040204@hardwarefreak.com>
Date: Mon, 23 Jan 2012 18:34:08 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: concurrent direct IO write in xfs
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
	<20120116232549.GC6922@dastard>
	<CAFLer81XkMTh_gxd95pzxCEs1yGRsTrZijX3c7ewgRzeA7DCSQ@mail.gmail.com>
	<20120123051155.GI15102@dastard>
	<CAFLer82QxfgXEx7ofzOHOK2YKiA+ab+_Aizd10SWHvnC-mVUHg@mail.gmail.com>
	<CAFLer81GWSCCCMppU=2dE+5KKqD-hYVKAA0hz9n-CBbxAs_xfw@mail.gmail.com>
In-Reply-To: <CAFLer81GWSCCCMppU=2dE+5KKqD-hYVKAA0hz9n-CBbxAs_xfw@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Zheng Da <zhengda1936@gmail.com>
Cc: xfs@oss.sgi.com

On 1/23/2012 2:51 PM, Zheng Da wrote:

> tmpfs doesn't support direct IO.

Of course not.  tmpfs resides entirely within the page cache (or some of
it in swap).  The whole point of direct IO is to bypass the page cache,
transferring data directly between user space memory and the storage
device.  As tmpfs is built entirely within the page cache, direct IO is
obviously impossible.  And it's also obviously unnecessary.

Yes, you will need to rewrite your application to use tmpfs as direct IO
calls won't work.  This is something you obviously would rather not do.
 Which brings us back to Dave's question, which you have not answered:

What exactly is the purpose of your program?  What does it aim to
accomplish?  Is it for a database application?  A word processor?  Or
simply a filesystem tester?  What do _you_ aim to accomplish with this
programming effort?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
