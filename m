Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o814fTJG104443 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 23:41:29 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B56FA134683C
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 21:52:41 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id qozSS6CnngWmzMG3
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 21:52:41 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id AB91F6C370
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 23:42:07 -0500 (CDT)
Message-ID: <4C7DD99F.7000401@hardwarefreak.com>
Date: Tue, 31 Aug 2010 23:42:07 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
References: <201009010130.41500@zmi.at>
	<20100901000631.GO705@dastard>	<201009010222.57350@zmi.at>
	<20100901031954.GP705@dastard>
In-Reply-To: <20100901031954.GP705@dastard>
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

Dave Chinner put forth on 8/31/2010 10:19 PM:
> On Wed, Sep 01, 2010 at 02:22:31AM +0200, Michael Monnerie wrote:
>>
>> This is a hexa-core AMD Phenom(tm) II X6 1090T Processor with up to 
>> 3.2GHz per core, so that shouldn't be
> 
> I'm getting a 8core/16thread server being CPU bound with multithreaded
> unlink workloads using delaylog, so it's entirely possible that all
> CPU cores are fully utilised on your machine.

What's your disk configuration on this 8 core machine?

Are you implying/stating that the performance of the disk subsystem is
irrelevant WRT multithreaded unlink workloads with delaylog enabled?

If so, this CPU hit you describe is specific to this workload scenario
only, not necessarily all your XFS test workloads, correct?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
