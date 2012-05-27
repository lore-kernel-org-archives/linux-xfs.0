Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4R1o2E1028944 for <xfs@oss.sgi.com>; Sat, 26 May 2012 20:50:02 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	d7xxmctVqPRGFtiO (version=TLSv1 cipher=RC4-MD5 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 26 May 2012 18:50:00 -0700 (PDT)
Received: by obbuo19 with SMTP id uo19so4157923obb.26
	for <xfs@oss.sgi.com>; Sat, 26 May 2012 18:50:00 -0700 (PDT)
Message-ID: <4FC18845.6030301@gmail.com>
Date: Sat, 26 May 2012 21:49:57 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: very slow file deletion on an SSD
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard>
	<4FC16683.9060800@gmail.com> <20120527000701.GS25351@dastard>
In-Reply-To: <20120527000701.GS25351@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

On 05/26/2012 08:07 PM, Dave Chinner wrote:
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

Getting some sort of out of memory error with bmap

[root@siFlash test]# ls -alF
total 50466476
drwxr-xr-x 2 root root       4096 May 26 21:40 ./
drwxr-xr-x 3 root root         17 May 26 19:32 ../
-rw------- 1 root root 1073741824 May 26 19:36 2.r.49.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.50.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.51.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.52.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.53.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.54.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.55.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.56.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.57.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.58.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.59.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.60.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.61.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.62.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.63.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.64.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.65.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.66.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.67.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.68.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.69.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.70.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.71.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.72.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.73.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.74.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.75.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.76.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.77.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.78.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.79.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.80.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.81.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.82.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.83.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.84.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.85.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.86.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.87.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.88.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.89.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.90.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.91.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.92.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.93.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.94.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.95.0
-rw------- 1 root root 1073741824 May 26 19:36 2.r.96.0
-rw-r--r-- 1 root root          0 May 26 21:40 x

[root@siFlash test]# ls -alF > x

[root@siFlash test]# xfs_bmap -vp x
x:
  EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET          TOTAL 
FLAGS
    0: [0..7]:          212681896..212681903  2 (7555752..7555759)     8 
01111

[root@siFlash test]# xfs_bmap -vp 2.r.96.0
xfs_bmap: xfsctl(XFS_IOC_GETBMAPX) iflags=0x4 ["2.r.96.0"]: Cannot 
allocate memory

These are 3.1.8 from git (had same error with earlier version).




>
> if not, can you use perf top to get an ida of the CPU usage profile
> duing the rm by doing:
>
> # perf record rm -f *
> .....
>
> and capturing the profile via:
>
> # perf report>  profile.txt
>
> And attaching te profile.txt file so we can see where all the CPU
> time is being spent? You can find perf in your kernel source tree
> under the tools subdir....
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
