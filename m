Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22Etn3x085954 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 08:55:49 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id pAnoCSe0n0XHv8z4 for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 06:55:48 -0800 (PST)
Message-ID: <4F50DF73.7050006@sandeen.net>
Date: Fri, 02 Mar 2012 08:55:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [XFS] xfs_repair time how long it takes??
References: <CABF-5WptGU3vmScFcpHVstd2UZfCAqiY4dGvL=_1+feFvYuS6g@mail.gmail.com>
In-Reply-To: <CABF-5WptGU3vmScFcpHVstd2UZfCAqiY4dGvL=_1+feFvYuS6g@mail.gmail.com>
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
To: Ryan Lee <ryanlee.lahk@gmail.com>
Cc: xfs@oss.sgi.com

On 3/2/12 7:09 AM, Ryan Lee wrote:
> Hi, My name is Ryan.
>  
> I am a computer programmer who are making  embedded linux products.
>  
> Nowadays one of  my job is porting the XFS Filesystem in our embedded linux products.
>  
> Everything is going well until the day before Yesterday.
>  
> The problem is the taking time with xfs_repair like this "]# xfs_repair -P -L /dev/sda2" is to long to wait in our embedded system and for me, so the booing time is increasing around 2 minutes totally.

Why are you running it with -L?
And why are you running it with -P?

As others mentioned, there is no reason to run xfs_repair on every boot.
And if you run it with -L on every boot, you've ruined the whole reason for using a journaling filesystem in the first place.

-Eric

> If the HDD has a big size of data what  I wrote,  the xfs_repair takes time more and more next booting time as I mention it.
>  
> So, it makes a big problem with my company products.
>  
> Would you mind helping me to solve this problem.
>  
> I think many company who use XFS Filesystem without  this kind problem.
>  
> Please sharing any information with XFS Filesystem.
>  
> I attached the console message what i saw.
>  
> I really appreciate you read my e-mail.
>  
> Have a good day.
>  
> Thanks, Ryan.
>  
>  
>  
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
