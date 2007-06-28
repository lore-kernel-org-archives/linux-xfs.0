Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 22:01:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5S50utL000949
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 22:00:57 -0700
Message-ID: <4683407E.9080707@sgi.com>
Date: Thu, 28 Jun 2007 15:00:46 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: After reboot fs with barrier faster deletes then fs with nobarrier
References: <op.tuldjrzef7nho5@sunset.cpc.wmin.ac.uk> <20070627222040.GR989688@sgi.com>
In-Reply-To: <20070627222040.GR989688@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Szabolcs Illes <S.Illes@westminster.ac.uk>, xfs@oss.sgi.com

David Chinner wrote:
> On Wed, Jun 27, 2007 at 06:58:29PM +0100, Szabolcs Illes wrote:
>> Hi,
>>
>> I am using XFS on my laptop, I have realized that nobarrier mount options  
>> sometimes slows down deleting large number of small files, like the kernel  
>> source tree. I made four tests, deleting the kernel source right after  
>> unpack and after reboot, with both barrier and nobarrier options:
>>
 >> mount opts: rw,noatime,nodiratime,logbsize=256k,logbufs=2
 >> illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync && reboot
 >> After reboot:
 >> illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/
 >> real    0m28.127s
 >> user    0m0.044s
 >> sys     0m2.924s
 >> mount opts: rw,noatime,nodiratime,logbsize=256k,logbufs=2,nobarrier
 >> illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync && reboot
 >> After reboot:
 >> illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/
 >> real    1m12.738s
 >> user    0m0.032s
 >> sys     0m2.548s
 >> It looks like with barrier it's faster deleting files after reboot.
 >> ( 28 sec vs 72 sec !!! ).
> 
> Of course the second run will be faster here - the inodes are already in
> cache and so there's no reading from disk needed to find the files
> to delete....
> 
> That's because run time after reboot is determined by how fast you
> can traverse the directory structure (i.e. how many seeks are
> involved). 
> Barriers will have little impact on the uncached rm -rf
> results, 

But it looks like barriers _are_ having impact on the uncached rm -rf
results.

--Tim
