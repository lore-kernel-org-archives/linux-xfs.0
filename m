Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7EMrXDC164347 for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 17:53:34 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CABCCCAF319
	for <xfs@oss.sgi.com>; Sat, 14 Aug 2010 16:02:58 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id Luz9a9rgac6ar9XN for
	<xfs@oss.sgi.com>; Sat, 14 Aug 2010 16:02:58 -0700 (PDT)
Message-ID: <4C671E83.4060106@nethype.de>
Date: Sun, 15 Aug 2010 00:53:55 +0200
From: Marco Maisenhelder <marco@nethype.de>
MIME-Version: 1.0
Subject: Re: fs corruption not detected by xfs_check or _repair
References: <4C656149.6050604@nethype.de>
	<20100814183537.GA13734@puku.stupidest.org>
In-Reply-To: <20100814183537.GA13734@puku.stupidest.org>
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
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

Chris Wedgwood wrote:
> On Fri, Aug 13, 2010 at 05:14:17PM +0200, Marco Maisenhelder wrote:
> 
>> *marco:/etc# ls -lrt /store/xfs_corruption/x/
>> ls: cannot access /store/xfs_corruption/x/db.backup2: Invalid argument
>> ls: cannot access /store/xfs_corruption/x/db.backup1: Invalid argument
>> total 0
>> ?????????? ? ? ? ?                ? db.backup2
>> ?????????? ? ? ? ?                ? db.backup1
> 
> where these created with inode64 and now mounted w/o that option?  (in
> which case inodes > 32-bit are inaccessible)

I wasn't even aware of the option - I guess I should have spent more 
time reading the FAQ before trying to find a more complex problem :(

inode64 was my problem - mouting the partition with -o inode64 fixes all 
weirdness.

Thanks a lot and sorry to have bothered you with this!

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
