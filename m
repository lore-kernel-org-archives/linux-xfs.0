Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 494D97F37
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 10:55:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3547C304032
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 08:55:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id e4F7V6ezk3huVNPH for <xfs@oss.sgi.com>;
	Wed, 11 Feb 2015 08:55:27 -0800 (PST)
Message-ID: <54DB897E.7060703@sandeen.net>
Date: Wed, 11 Feb 2015 10:55:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: shared/032 is broken on Fedora
References: <54DB35F0.1010203@plexistor.com> <54DB886D.9060201@sandeen.net>
In-Reply-To: <54DB886D.9060201@sandeen.net>
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
To: Boaz Harrosh <boaz@plexistor.com>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, fstests@vger.kernel.org

On 2/11/15 10:50 AM, Eric Sandeen wrote:
> (cc: fstests list) 
> 
> On 2/11/15 4:58 AM, Boaz Harrosh wrote:
>>
>> This is not the proper patch just to show a working version for Fedora. But I think
>> it now breaks the other ARCHs.
>>
>> What happens is that the output of ${MKFS_PROG}.* is:
>> 	/usr/sbin/mkfs.bfs /usr/sbin/mkfs.btrfs /usr/sbin/mkfs.cramfs /usr/sbin/mkfs.ext2 /usr/sbin/mkfs.ext3 /usr/sbin/mkfs.ext4 ...
>>
>> So in Fedora sbin has moved to /usr/... and therefor the sed below fails.
>> My sed foo is not good enough. How to support both places for sbin?
> 
> All we really want is the mkfs filesystem type, i.e. the ${FS} in mkfs.${FS}
> 
> So 
> 
> sed -e 's/.*mkfs.//g'

Wait, no, I misunderstood what it was working on ;)  Hang on ...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
