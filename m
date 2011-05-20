Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KKcZoO110465 for <xfs@oss.sgi.com>; Fri, 20 May 2011 15:38:35 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B64646F992
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 13:38:34 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id vE6wg56LMrsTOQct for <xfs@oss.sgi.com>;
	Fri, 20 May 2011 13:38:34 -0700 (PDT)
Message-ID: <4DD6D149.6050602@sandeen.net>
Date: Fri, 20 May 2011 15:38:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS_WANT_CORRUPTED_GOTO on repair of large myisam (mysql) table
References: <4DD097F9.6070205@zmcconsulting.com> <4DD09A09.30807@sandeen.net>
	<4DD6D108.3010203@zmcconsulting.com>
In-Reply-To: <4DD6D108.3010203@zmcconsulting.com>
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
To: "Matthew J. Probst" <mprobst@zmcconsulting.com>
Cc: xfs@oss.sgi.com

On 5/20/11 3:37 PM, Matthew J. Probst wrote:
> On 5/15/2011 9:29 PM, Eric Sandeen wrote:
>>
>> Please try removing kmod-xfs; that is an extremely old xfs codebase.
>>
>> the kernel above comes with xfs.ko already an is much more up to date.
>> When kmod-xfs is installed, it overrides  the one shipped with the kernel.
>>
>> Hopefully you'll have better luck with the newer code.
> 
> Yes...  That worked.. after removing kmod-xfs I was successfully able to
> complete the myisamchk of the 20GB table w/o crash.
> 
> Thanks!!
> 
> -matt
> 

Good deal.  I wish there were a way to eradicate all those kmod-xfs's on Centos systems.  :(

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
