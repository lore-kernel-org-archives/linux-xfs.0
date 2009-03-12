Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CGbGqV088240 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 11:37:36 -0500
Message-ID: <49B93A04.4070405@sandeen.net>
Date: Thu, 12 Mar 2009 11:36:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: LWN article: ext4 and data loss
References: <200903121239.35442@zmi.at>	<49B9097C.1070003@sandeen.net>	(sfid-20090312_151043_496061_D19DDB11)	<200903121514.12732.Martin@lichtvoll.de>
	<49B92423.4020708@sandeen.net> <49B9396D.7060809@sgi.com>
In-Reply-To: <49B9396D.7060809@sgi.com>
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
To: Greg Banks <gnb@sgi.com>
Cc: xfs@oss.sgi.com

Greg Banks wrote:
> Eric Sandeen wrote:
>> It's simple.  Want your data safe on disk?  fsync.  There's not a lot
>> more to it than that.  (and if fsync hurts perf too much, re-think how
>> you are storing your data)
>>
>> Filesystems can hack around some heuristics to try to make unsafe apps
>> safer, but in the end, it's the app's job to make sure a buffered write
>> hits permanent storage when it matters.
>>   
> 
> Stewart Smith has a highly entertaining presentation on this very topic.
> 
> http://www.linux.org.au/conf/2007/talk/278.html
> 

and

http://www.flamingspork.com/talks/2007/06/eat_my_data.odp

In hindsight, http://linuxmafia.com/faq/Filesystems/reiserfs.html is
entertaining, too ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
