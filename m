Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 07:22:27 -0700 (PDT)
Received: from isls-mx10.wmin.ac.uk (isls-mx10.wmin.ac.uk [161.74.14.112])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SEMHtL014467
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 07:22:19 -0700
Date: Thu, 28 Jun 2007 15:22:17 +0100
Subject: Re: After reboot fs with barrier faster deletes then fs with nobarrier
From: "Szabolcs Illes" <S.Illes@westminster.ac.uk>
Content-Type: text/plain; format=flowed; delsp=yes; charset=us-ascii
MIME-Version: 1.0
References: <op.tuldjrzef7nho5@sunset.cpc.wmin.ac.uk> <20070627222040.GR989688@sgi.com> <4683407E.9080707@sgi.com>
Message-ID: <op.tumx7fj2f7nho5@project1.cpc.wmin.ac.uk>
In-Reply-To: <4683407E.9080707@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>, David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, 28 Jun 2007 06:00:46 +0100, Timothy Shimmin <tes@sgi.com> wrote:

> David Chinner wrote:
>> On Wed, Jun 27, 2007 at 06:58:29PM +0100, Szabolcs Illes wrote:
>>> Hi,
>>>
>>> I am using XFS on my laptop, I have realized that nobarrier mount  
>>> options  sometimes slows down deleting large number of small files,  
>>> like the kernel  source tree. I made four tests, deleting the kernel  
>>> source right after  unpack and after reboot, with both barrier and  
>>> nobarrier options:
>>>
>  >> mount opts: rw,noatime,nodiratime,logbsize=256k,logbufs=2
>  >> illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 &&  
> sync && reboot
>  >> After reboot:
>  >> illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/
>  >> real    0m28.127s
>  >> user    0m0.044s
>  >> sys     0m2.924s
>  >> mount opts: rw,noatime,nodiratime,logbsize=256k,logbufs=2,nobarrier
>  >> illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 &&  
> sync && reboot
>  >> After reboot:
>  >> illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/
>  >> real    1m12.738s
>  >> user    0m0.032s
>  >> sys     0m2.548s
>  >> It looks like with barrier it's faster deleting files after reboot.
>  >> ( 28 sec vs 72 sec !!! ).
>>  Of course the second run will be faster here - the inodes are already  
>> in
>> cache and so there's no reading from disk needed to find the files
>> to delete....
>>  That's because run time after reboot is determined by how fast you
>> can traverse the directory structure (i.e. how many seeks are
>> involved). Barriers will have little impact on the uncached rm -rf
>> results,
>
> But it looks like barriers _are_ having impact on the uncached rm -rf
> results.
and the same happens on my desktop pc which is much more faster, 64 bit  
dual core P4, sata drive, etc.

nobarrier:

+ echo 3 > /proc/sys/vm/drop_caches
+ rm -rf /root/fs/linux-2.6.21.5 /root/fs/x.tar

real    0m12.526s
user    0m0.016s
sys     0m1.244s

barrier:

+ echo 3 > /proc/sys/vm/drop_caches
+ rm -rf /root/fs/linux-2.6.21.5 /root/fs/x.tar

real    0m6.784s
user    0m0.032s
sys     0m1.244s

Szabolcs

>
> --Tim
