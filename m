Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 16:59:48 -0700 (PDT)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l49NxifB019372
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 16:59:45 -0700
Message-ID: <4642598E.3000607@goop.org>
Date: Wed, 09 May 2007 16:30:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com>
In-Reply-To: <20070509231643.GM85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com

David Chinner wrote:
> On Wed, May 09, 2007 at 02:09:50PM -0700, Jeremy Fitzhardinge wrote:
>   
>> I've had a couple of instances of a linux-2.6 mercurial repo getting
>> corrupted in some odd way this morning.  It looks like files are being
>> truncated; not to size 0, but losing something off the end.
>>
>> This is on an xfs filesystem.  I haven't had any crashes/oops, and I
>> don't think its the normal files getting filled with 0 problem.  I saw
>> this before the most recent set of xfs updates, but it happened again
>> afterwards too.
>>     
>
> It looks like the latest XFS changes haven't been pulled yet, so
> it's not new code that is triggering this....
>   

A bunch of xfs changes appeared in git this morning, I thought.  But all
this first happened from a kernel compiled yesterday.

>> Mercurial uses a strictly append-only model for updating its repo files,
>> but it looks like maybe an append operation didn't stick.
>>
>> I'm repulling a fresh copy of the repo; I'll be able to compare
>> before/after.  Update: yep, definitely truncated:
>>
>> $ ls -l .hg-new/store/data/_documentation/pi-futex.txt.i .hg-broken/store/data/_documentation/pi-futex.txt.i
>> 4 -rw-rw-r-- 1 jeremy jeremy 3309 May  9 09:43 .hg-broken/store/data/_documentation/pi-futex.txt.i
>> 4 -rw-rw-r-- 1 jeremy jeremy 3797 May  9 13:38 .hg-new/store/data/_documentation/pi-futex.txt.i
>>
>> also
>>   3476 -rw-rw-r--  1 jeremy jeremy   3558208 May  9 13:55 00manifest.i
>>   3476 -rw-rw-r--  1 jeremy jeremy   3555200 May  9 09:41 00manifest.i~
>>
>>
>> where 00manifest.i~ is the broken one. The files are identical up to the
>> truncation point.
>>     
>
> Hmmm - that is bizarre. What is the output of xfs_bmap -vvp <filename>
> on each of those files?
>   
00manifest.i~ is linux-2.6-broken/.hg/store/00manifest.i

$ xfs_bmap -vvp linux-2.6/.hg/store/00manifest.i linux-2.6-broken/.hg/store/00manifest.i
linux-2.6/.hg/store/00manifest.i:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL
   0: [0..895]:        8135128..8136023  1 (270808..271703)   896
   1: [896..1407]:     8207424..8207935  1 (343104..343615)   512
   2: [1408..2047]:    8211520..8212159  1 (347200..347839)   640
   3: [2048..3071]:    8212904..8213927  1 (348584..349607)  1024
   4: [3072..4991]:    8215672..8217591  1 (351352..353271)  1920
   5: [4992..6143]:    8344408..8345559  1 (480088..481239)  1152
   6: [6144..6951]:    7930840..7931647  1 (66520..67327)     808
linux-2.6-broken/.hg/store/00manifest.i:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET          TOTAL
   0: [0..383]:        27132064..27132447  3 (3539104..3539487)   384
   1: [384..511]:      27132912..27133039  3 (3539952..3540079)   128
   2: [512..895]:      27136216..27136599  3 (3543256..3543639)   384
   3: [896..1151]:     27147816..27148071  3 (3554856..3555111)   256
   4: [1152..1535]:    27148680..27149063  3 (3555720..3556103)   384
   5: [1536..2175]:    27154152..27154791  3 (3561192..3561831)   640
   6: [2176..3711]:    27158944..27160479  3 (3565984..3567519)  1536
   7: [3712..4607]:    27161016..27161911  3 (3568056..3568951)   896
   8: [4608..5247]:    27162880..27163519  3 (3569920..3570559)   640
   9: [5248..5375]:    27164096..27164223  3 (3571136..3571263)   128
  10: [5376..5759]:    27165080..27165463  3 (3572120..3572503)   384
  11: [5760..5887]:    27166664..27166791  3 (3573704..3573831)   128
  12: [5888..6015]:    27171400..27171527  3 (3578440..3578567)   128
  13: [6016..6399]:    27172904..27173287  3 (3579944..3580327)   384
  14: [6400..6527]:    27173336..27173463  3 (3580376..3580503)   128
  15: [6528..6911]:    27173784..27174167  3 (3580824..3581207)   384
  16: [6912..6943]:    27174568..27174599  3 (3581608..3581639)    32


> what happens to these files after then are downloaded? Does it only
> happen to append-only files or are other files affected as well?
>   

I saw similar damage in another repo, but I was using the "mq" extension
on that, which means the files are no longer append-only. 

I explicitly checked that repo was OK after I downloaded it.  It became
broken again after a while. 

It was as if the dirty inode data was dropped without being written to
disk, so once it had to read back it got a stale file length.  Or
something like that - I'm just guessing.

> BTW, what's the 'xfs_info <mntpt>' output for this filesystem?
>   

meta-data=/dev/vg00/homexfs      isize=256    agcount=19, agsize=983040 blks
         =                       sectsz=512   attr=1
data     =                       bsize=4096   blocks=18350080, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=7680, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0


    J
