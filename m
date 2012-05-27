Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4R0Ar4e259294 for <xfs@oss.sgi.com>; Sat, 26 May 2012 19:10:53 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	0HxHSeGBSKhe2iXv (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 26 May 2012 17:10:52 -0700 (PDT)
Received: by obbuo19 with SMTP id uo19so4050997obb.26
	for <xfs@oss.sgi.com>; Sat, 26 May 2012 17:10:51 -0700 (PDT)
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard>
	<4FC16683.9060800@gmail.com> <20120527000701.GS25351@dastard>
In-Reply-To: <20120527000701.GS25351@dastard>
Mime-Version: 1.0 (1.0)
Message-Id: <B8054040-C690-463A-8CF2-B13945067683@gmail.com>
From: joe.landman@gmail.com
Subject: Re: very slow file deletion on an SSD
Date: Sat, 26 May 2012 20:10:45 -0400
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
Cc: linux-raid <linux-raid@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Ok.  Will do in a few hours

Sent from my iPad

On May 26, 2012, at 8:07 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Sat, May 26, 2012 at 07:25:55PM -0400, Joe Landman wrote:
>> [root@siFlash test]# ls -alF  | wc -l
>> 59
>> [root@siFlash test]# /usr/bin/time rm -f *
>> ^C0.00user 8.46system 0:09.55elapsed 88%CPU (0avgtext+0avgdata
>> 2384maxresident)k
>> 25352inputs+0outputs (0major+179minor)pagefaults 0swaps
> 
> It's burning an awful lot of CPU time during this remove.
> 
>> [root@siFlash test]# ls -alF  | wc -l
>> 48
> 
> So, 48 files were removed, it was basically CPU bound and one took
> 2.6 seconds.
> 
> So, how big are the files, and does the one that took 2.6s have tens
> of thousands of extents ('xfs_bmap -vp *' will dump the extent maps
> for all the files)?
> 
> if not, can you use perf top to get an ida of the CPU usage profile
> duing the rm by doing:
> 
> # perf record rm -f *
> .....
> 
> and capturing the profile via:
> 
> # perf report > profile.txt
> 
> And attaching te profile.txt file so we can see where all the CPU
> time is being spent? You can find perf in your kernel source tree
> under the tools subdir....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
