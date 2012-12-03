Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3MPDvc038707 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 16:25:13 -0600
Received: from mail-yh0-f50.google.com (mail-yh0-f50.google.com
	[209.85.213.50]) by cuda.sgi.com with ESMTP id SHxEp0ooIYNiTFvw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 03 Dec 2012 14:27:35 -0800 (PST)
Received: by mail-yh0-f50.google.com with SMTP id k61so375597yhk.37
	for <xfs@oss.sgi.com>; Mon, 03 Dec 2012 14:27:34 -0800 (PST)
References: <50BAB19F.1010808@hardwarefreak.com>
	<CCE2425A.B0475%jellis@dhnet.us> <20121203213457.GA32450@dastard>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20121203213457.GA32450@dastard>
Message-Id: <3AB03753-4C96-432B-BC52-BBC52B0745B6@gmail.com>
From: Jeffrey Ellis <grndlvl@gmail.com>
Subject: Re: xfsdump INTERRUPT issue
Date: Mon, 3 Dec 2012 17:27:33 -0500
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "stan@hardwarefreak.com" <stan@hardwarefreak.com>, "J. Ellis" <jellis@dhnet.us>

Hi, Dave--

> FWIW, this implies that xfsrestore failed. What is the output from
> xfsrestore? Can you just run xfsdump to a file?

Can you tell me how to do that and dmesg?

Best,
J. 

On Dec 3, 2012, at 4:34 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Dec 03, 2012 at 11:49:46AM -0500, J. Ellis wrote:
>> Thank you to Stan and Dave for helping me through this.
>> 
>> Ok, here's the file, printed below.
>> 
>> Basically, I'm running the following commands under Ubuntu 12.10:
>> 
>> Type mkdir /mnt/fp
>> Type mkdir /mnt/hr20
>> Type mount -t xfs -o rtdev=/dev/sda3 /dev/sda2 /mnt/fp
>> Type mount -t xfs -o rtdev=/dev/sdb3 /dev/sdb2 /mnt/hr20
>> Type xfsdump -J - /mnt/hr20 | xfsrestore -J - /mnt/fp
>> 
>> When run, I get this as my output:
>> 
>> xfsdump: WARNING: write to stdio failed: 32 (Broken pipe)
> 
> FWIW, this implies that xfsrestore failed. What is the output from
> xfsrestore? Can you just run xfsdump to a file?
> 
> Also, the dmesg output is missing - can you attach it?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
