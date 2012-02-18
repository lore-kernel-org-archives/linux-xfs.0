Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1I1woxs126085 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 19:58:50 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id aGwgEjabOxu6GFOP
	for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 17:58:49 -0800 (PST)
Message-ID: <4F3F05D4.1020705@hardwarefreak.com>
Date: Fri, 17 Feb 2012 19:58:44 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS memory recomendation?
References: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA721CA3@seldmbx01.corpusers.net>
	<20120217024941.GH14132@dastard>
In-Reply-To: <20120217024941.GH14132@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "Assarsson,
	Emil" <Emil.Assarsson@sonyericsson.com>

On 2/16/2012 8:49 PM, Dave Chinner wrote:
> On Thu, Feb 16, 2012 at 12:50:57PM +0100, Assarsson, Emil wrote:
>> Hi,
>>
>> Are there any recommendations about how much memory I need based
>> on the size of the file system and/or amount of files?  For
>> example: how much memory would be optimal for a 20TB file system
>> with 3000000 files? 
> 
> /me shrugs
> 
>> I guess it depends on the usage pattern?
> 
> Totally.

Allow me to drag the OP's question under a different light...

I have a 20TB XFS filesystem with 3000000 files.  What is the minimum
amount of system RAM I will need to run an xfs_check or xfs_repair or
xfs_[tool] on this filesystem, assuming Linux has been put into a low
overhead state, and said tool[s] has access to the bulk of the system
memory?

Is there a formula available so any XFS user can calculate this
xfs_[tools] RAM requirement, given FS size X and file count Y?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
