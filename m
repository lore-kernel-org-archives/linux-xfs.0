Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 724FD7F3F
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 15:24:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1ABFAC006
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 13:24:01 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id JqMs4vfMSbmWKMql
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 13:24:01 -0700 (PDT)
Message-ID: <51DF1463.1070603@hardwarefreak.com>
Date: Thu, 11 Jul 2013 15:24:03 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Corruption of root fs during git bisect of drm system hang
References: <20130710090634.GA356@x4> <20130711003122.GR3438@dastard>
	<20130711033621.GB362@x4> <20130711035827.GA3438@dastard>
	<51DE30BC.1050905@hardwarefreak.com> <20130711090755.GA363@x4>
	<20130711112826.GA363@x4>
In-Reply-To: <20130711112826.GA363@x4>
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
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: xfs@oss.sgi.com

On 7/11/2013 6:28 AM, Markus Trippelsdorf wrote:
...
>> Looking at the source:
>> http://api.kde.org/4.10-api/kdelibs-apidocs/kdecore/html/ksavefile_8cpp_source.html#l00219
>> it appears that one can set an environment variable KDE_EXTRA_FSYNC to
>> address this issue.
>>
>> However in my case it doesn't help. Even with KDE_EXTRA_FSYNC=1 I still
>> loose my KDE settings in case of a crash. So the whole fsync thing might
>> be a red herring.
> 
> It turned out that the KDE_EXTRA_FSYNC variable doesn't affect KDE
> config file handling at all.
> So I've added an fsync in kconfigini.cpp (KConfigIniBackend::writeConfig)
> and now I don't loose my settings anymore during kernel crash testing.
> 
> That is until xfs eats my KDE config files (kwinrulesr in this case):

Adding fsync in kconfigini.cpp apparently doesn't force fsync for all
KDE file operations.  You also have some Open Office files getting hosed
due to lack of fsync.  XFS is not the cause of these problems.

The problem is that all of this desktop code was developed atop EXT3
which flushed to disk every 5 seconds.  This made programmers sloppy as
they didn't have to fsync to make sure data hit disk.  This problem has
been covered extensively by many, including Eric in other posts on his
blog.  There's a really simple way to test this:  mount with sync.
Report results after the next crash.  If no files are corrupted then
you've verified the problem lay squarely on the shoulders of these
desktop developers who have abdicated their responsibility to make sure
their file changes hit the disk, instead of relying on a broken
filesystem do it for them.

Worth noting, using EXT4 without the EXT3 flush emulation enabled will
yield similar file corruption upon a crash.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
