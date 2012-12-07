Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7L2T9v252994 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 15:02:29 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id b4n8uwAzkq8Kr008
	for <xfs@oss.sgi.com>; Fri, 07 Dec 2012 13:04:55 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 4354A6C0EA
	for <xfs@oss.sgi.com>; Fri,  7 Dec 2012 15:04:55 -0600 (CST)
Message-ID: <50C259F9.2050406@hardwarefreak.com>
Date: Fri, 07 Dec 2012 15:04:57 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfsdump INTERRUPT issue
References: <CCE505AA.B05B7%jellis@dhnet.us>
	<50BFF726.6090006@hardwarefreak.com>
	<68036B67-6AE6-4056-89F5-9549B4E476FD@dhnet.us>
	<50C00583.6000804@hardwarefreak.com>
	<6F909666-9DFE-43F1-973D-170B892F9C5B@gmail.com>
	<50C0657D.5050903@hardwarefreak.com>
	<20121207101620.GK27172@dastard>
In-Reply-To: <20121207101620.GK27172@dastard>
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
To: xfs@oss.sgi.com

On 12/7/2012 4:16 AM, Dave Chinner wrote:
> On Thu, Dec 06, 2012 at 03:29:33AM -0600, Stan Hoeppner wrote:
>> On 12/5/2012 9:01 PM, Jeffrey Ellis wrote:
>> BTW, if your goal in all of this is simply copying all the directories
>> and files from one disk to another disk, you could have used "cp -a" and
>> been done already.  It takes longer to execute than xfsdump/xfsrestore,
>> but given you've been at this for many days now, "cp -a" would have
>> already completed--long ago.
> 
> Unfortunately, using cp or rsync is not possible because the
> filesystem has a real-time device attached to it. It's basically a
> ~10GB data device and a ~500GB real-time device. I'd say it's from a
> DVR or something like that, and that Jeffrey is trying to put
> a bigger disk in the DVR....

Ah, yes.  I didn't catch the RT volume.

Incidentally, since the real-time feature has never been fully supported
under Linux, why are DVR manufacturers even using it?  Without GRIO and
the XBOW ASIC the real-time volume is pretty much useless isn't it?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
