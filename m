Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1I2Ht0i126959 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 20:17:55 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AJLrFdVQMNvmOC7C for
	<xfs@oss.sgi.com>; Fri, 17 Feb 2012 18:17:53 -0800 (PST)
Message-ID: <4F3F0A4A.7050708@redhat.com>
Date: Fri, 17 Feb 2012 18:17:46 -0800
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: XFS memory recomendation?
References: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA721CA3@seldmbx01.corpusers.net>
	<20120217024941.GH14132@dastard>
	<4F3F05D4.1020705@hardwarefreak.com>
In-Reply-To: <4F3F05D4.1020705@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: "Assarsson, Emil" <Emil.Assarsson@sonyericsson.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 2/17/12 5:58 PM, Stan Hoeppner wrote:
> On 2/16/2012 8:49 PM, Dave Chinner wrote:
>> On Thu, Feb 16, 2012 at 12:50:57PM +0100, Assarsson, Emil wrote:
>>> Hi,
>>>
>>> Are there any recommendations about how much memory I need based
>>> on the size of the file system and/or amount of files?  For
>>> example: how much memory would be optimal for a 20TB file system
>>> with 3000000 files? 
>>
>> /me shrugs
>>
>>> I guess it depends on the usage pattern?
>>
>> Totally.
> 
> Allow me to drag the OP's question under a different light...
> 
> I have a 20TB XFS filesystem with 3000000 files.  What is the minimum
> amount of system RAM I will need to run an xfs_check or xfs_repair or
> xfs_[tool] on this filesystem, assuming Linux has been put into a low
> overhead state, and said tool[s] has access to the bulk of the system
> memory?
> 
> Is there a formula available so any XFS user can calculate this
> xfs_[tools] RAM requirement, given FS size X and file count Y?
> 

http://xfs.org/index.php/XFS_FAQ#Q:_Which_factors_influence_the_memory_usage_of_xfs_repair.3F

-Eric



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
