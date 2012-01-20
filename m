Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0KMio96132592 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 16:44:50 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id FuzmTNHm70JZ89nF
	for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 14:44:49 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id DD8076C0B9
	for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 16:44:48 -0600 (CST)
Message-ID: <4F19EE5E.8030508@hardwarefreak.com>
Date: Fri, 20 Jan 2012 16:44:46 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Optimal XFS formatting options?
References: <33140169.post@talk.nabble.com> <201201171019.58714@zmi.at>
	<4F155CC2.3050201@hardwarefreak.com> <201201201652.10193@zmi.at>
In-Reply-To: <201201201652.10193@zmi.at>
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

On 1/20/2012 9:52 AM, Michael Monnerie wrote:
> On Dienstag, 17. Januar 2012 Stan Hoeppner wrote:
>> So to be clear, your issue with the above isn't with my partition
>> alignment math WRT the OP's P2000 array, but is with using XFS stripe
>> alignment in general, correct?
> 
> Yes. I just wanted to document this as people often expand RAIDs and 
> forget to apply the changes to stripe width.
>  
>> There is one really simple way around this issue you describe: don't
>> add drives to an existing array.  Simply create another array with
>> new disks, create a new aligned XFS on the array, and mount the
>> filesystem in an appropriate location.  There is no 11th Commandment
>> stating one must have a single massive XFS atop all of one's disks.
>> ;)
>>
>> There is little to no application software today that can't be
>> configured to store its data files across multiple directories.  So
>> there's no need to box oneself into the corner you describe above.
> 
> It's a management burden to do that. I've learned that systems usually 
> are strictly structured in their configuration, so it's often better to 
> extend a RAID and to keep the config, as this is cheaper in the end. At 
> least for the salaries of good admins here in Europe ;-)

If ease (or cost) of filesystem administration is of that much greater
priority than performance, then why are you using XFS in the first place
instead of EXT?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
