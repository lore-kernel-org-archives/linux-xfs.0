Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n86CGnt9144907 for <xfs@oss.sgi.com>; Sun, 6 Sep 2009 07:16:59 -0500
Received: from deepsky.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 6CDFE42E111
	for <xfs@oss.sgi.com>; Sun,  6 Sep 2009 05:17:23 -0700 (PDT)
Received: from deepsky.com (outrider.deepsky.com [66.207.216.43]) by
	cuda.sgi.com with SMTP id vbDoWLcj3G40LZXt for
	<xfs@oss.sgi.com>; Sun, 06 Sep 2009 05:17:23 -0700 (PDT)
Date: Sun, 6 Sep 2009 08:17:19 -0400
From: Gavin Peters <gpeters@deepsky.com>
Subject: Re: reservation ran out?
Message-ID: <20090906121719.GV22496@outrider>
References: <20090905161102.GQ22496@outrider> <4AA334AA.9050908@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AA334AA.9050908@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Gavin Peters <gpeters@deepsky.com>, xfs@oss.sgi.com


On Sat, Sep 05, 2009 at 11:03:54PM -0500, Eric Sandeen wrote:
> Gavin Peters wrote:
>> I just created bug 849, about a reservation problem I'm seeing
>> on my x86_64 system on ubuntu jaunty (2.6.28-15-generic).
>>
>> http://oss.sgi.com/bugzilla/show_bug.cgi?id=849
>>
>> Am I doin' something wrong, or is this a real problem?
>
> Sounds like a real problem.
>
> Any reproducible testcase?
>

Alas, no; I was running mythtv, and my disk was somewhat fragmented.

root@mythmaker:~# xfs_db -c frag -r /dev/sda7
actual 17379, ideal 98, fragmentation factor 99.44%
root@mythmaker:~# xfs_db -c frag -r /dev/sdb1
actual 4268, ideal 53, fragmentation factor 98.76%

The disk that was having the trouble was sda7, my sdb1 was fine.  

Mythtv fragments disks so badly by appending to two, or three files,
simultaniously and fsyncing on them a lot.  Perhaps some hacking at
that will give a reproduction, I'll see if I can take the time and do
that.

I've since defragmented both disks though; and I've set a large
allocsize (512m) to prevent future fragmentation.  We'll see if I get
another crash.

- Gavin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
