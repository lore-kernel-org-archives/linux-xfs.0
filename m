Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JJLuR7149350 for <xfs@oss.sgi.com>; Wed, 19 May 2010 14:21:56 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 576E735BFAD
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 12:24:15 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 9wA2eLdDXQk8VyAZ
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 12:24:15 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id A71836C24C
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 14:24:14 -0500 (CDT)
Message-ID: <4BF43B3C.6030403@hardwarefreak.com>
Date: Wed, 19 May 2010 14:25:48 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: noatime,nodiratime?
References: <4BF3F212.5030600@hardwarefreak.com>
	<20100519182336.GA6264@infradead.org>
In-Reply-To: <20100519182336.GA6264@infradead.org>
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

Christoph Hellwig put forth on 5/19/2010 1:23 PM:
> On Wed, May 19, 2010 at 09:13:38AM -0500, Stan Hoeppner wrote:
>> Need a little education here.  I have a general understanding of what the
>> inode access timestamps "are" but I have no idea what, if any, applications
>> make use of these access times.  I see posts all over Google land saying to
>> use "noatime,nodiratime,logbufs=8" for XFS mount options to increase
>> performance.
> 
> Which doesn't make much sense.  First 8 log buffers has been the default
> for XFS for a long time.  Second nodiratime has always been useless as
> it is a strict subset of of noatime.  Now noatime isn't the default yet,
> but instead relatime is, which still updates the atime in memory, but
> only writes it back when the inode has other changes, or on umount.
> It should give you equivalent performance to noatime, but better
> functionality.

Wow.  That'll teach me to trust that man pages are accurate. :)  Maybe you
could add this explanation about relatime vs noatime to the man page as well.

Any chance xfs_info could be updated to output the information we're
discussing, including spitting out the XFS specific mount options that are
currently active at the time of running xfs_info?  There seems to be much
confusion in the community due to lack of accurate information being
available.  Google for "XFS performance" and you'll see
"noatime,nodiratime,logbufs=8" mentioned consistently from early 2000's to
the present as a performance enhancer.

If what you say is true, on my 2.6.32.9 system, I actually decreased logbufs
from 8 to 4 half an hour ago, instead of increasing it from 2 to 4, as man
lead me to believe I was doing.  Do any of the xfs tools output the XFS
specific active mount options allowing an op to confirm changes?  As someone
else stated it would be nice to be able to see these parameter values.  As
is, AFAICT, there's no way to confirm these parameter values.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
