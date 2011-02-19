Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1JKVHOi038478 for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 14:31:17 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C770A1DD57C2
	for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 12:33:58 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id lwyuuEiU1bWKCbNb
	for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 12:33:58 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 1F7916C130
	for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 14:33:58 -0600 (CST)
Message-ID: <4D602936.10400@hardwarefreak.com>
Date: Sat, 19 Feb 2011 14:33:58 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: External log size limitations
References: <4D5C1D77.1060000@spinpro.com>
	<20110217003233.GH13052@dastard>	<4D5E8FAD.9080802@spinpro.com>
	<4D5ECEC5.2020701@hardwarefreak.com>	<4D5ED70B.7030504@spinpro.com>
	<4D5F3EBF.3030309@hardwarefreak.com>
	<20110219100207.GA24537@citd.de>
In-Reply-To: <20110219100207.GA24537@citd.de>
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

Matthias Schniedermeyer put forth on 2/19/2011 4:02 AM:
> On 18.02.2011 21:53, Stan Hoeppner wrote:
>> Fist, sorry for the length.  I can tend to get windy talking shop. :)
>>
>> Andrew Klaassen put forth on 2/18/2011 2:31 PM:
>>
>>> It's IBM and LSI gear, so I'm crossing my fingers that a Linux install
>>> will be relatively painless.
>>
>> Ahh, good.  At least, so far it seems so. ;)
>>
>>> I thought that the filesystem block size was still limited to the kernel
>>> page size, which is 4K on x86 systems.
>>>
>>> http://oss.sgi.com/projects/xfs/
>>>
>>> "The maximum filesystem block size is the page size of the kernel, which
>>> is 4K on x86 architecture."
>>>
>>> Is this no longer true?  It would be awesome news if it wasn't.
>>
>> My mistake.  It would appear you are limited to the page size, which, as
>> I mentioned, is still 8 KiB for most distros.
> 
> You confuse that with STACK-size.

Yes, I did.  However...

> The page-size is, and has always been, 4 KiB (on X86).

To bring this back around to the OP's original question, do you agree or
disagree with my assertion that a 64 KiB XFS block size will yield
little if any advantage over a 4 KiB block size, and may in fact have
some disadvantages, specifically with small file random IO?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
