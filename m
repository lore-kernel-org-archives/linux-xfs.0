Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6FLkSjP223533 for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 16:46:29 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C3433671A9
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 14:47:05 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id MqUkgRJ6zVqEDKex for <xfs@oss.sgi.com>;
	Wed, 15 Jul 2009 14:47:05 -0700 (PDT)
Message-ID: <4A5E4E57.7000802@sandeen.net>
Date: Wed, 15 Jul 2009 16:47:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: very basic defragmentation testing for xfs
	& ext4
References: <4A5E3A37.5050306@redhat.com>
	<20090715213001.GH14175@webber.adilger.int>
In-Reply-To: <20090715213001.GH14175@webber.adilger.int>
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
To: Andreas Dilger <adilger@sun.com>
Cc: Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Andreas Dilger wrote:
> On Jul 15, 2009  15:21 -0500, Eric Sandeen wrote:
>> This test creates some files, runs defrag on them,
>> and compares the before/after fragmentation as well
>> as file md5sums and timestamps.
>>
>> (md5sums may just be reading buffered data though,
>> suggestions?)
> 
> (umount; mount)?

I suppose that'd work :)

-Eric

> Cheers, Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
