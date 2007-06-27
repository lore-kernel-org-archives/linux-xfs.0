Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 15:18:57 -0700 (PDT)
Received: from isls-mx10.wmin.ac.uk (isls-mx10.wmin.ac.uk [161.74.14.112])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5RMIotL019638
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 15:18:52 -0700
Date: Wed, 27 Jun 2007 23:18:50 +0100
Subject: Re: After reboot fs with barrier faster deletes then fs with nobarrier
From: "Szabolcs Illes" <S.Illes@westminster.ac.uk>
Content-Type: text/plain; format=flowed; delsp=yes; charset=us-ascii
MIME-Version: 1.0
References: <op.tuldjrzef7nho5@sunset.cpc.wmin.ac.uk> <20070627214506.GA1352@tuatara.stupidest.org>
Message-ID: <op.tulplobmf7nho5@sunset.cpc.wmin.ac.uk>
In-Reply-To: <20070627214506.GA1352@tuatara.stupidest.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

On Wed, 27 Jun 2007 22:45:06 +0100, Chris Wedgwood <cw@f00f.org> wrote:

> On Wed, Jun 27, 2007 at 06:58:29PM +0100, Szabolcs Illes wrote:
>
>> I repeated this test several times, same results. I made sure
>> nothing was running while I was doing the tests, cpu was idle, hdd
>> led was not on, etc.
>
> instead of doing a reboot can you try something like:
>
>     echo 1 > /proc/sys/vm/drop_caches
>
> or
>     echo 3 > /proc/sys/vm/drop_caches
>
> (the value is a bit mask, bit 0 will drop the page cache, bit 1 will
> drop the slab)
>
> does that give you more or less the same results as rebooting?
yes it does.
>
>
>
>
> another thing to try, before the delete, also try:
>
>     find path/to/whatever -noleaf >/dev/null
>
> and see if that helps (i expect it should greatly)
It doesn't help to much, see the updated tests:

mount opts: rw,noatime,nodiratime,logbsize=256k,logbufs=2

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync &&  
reboot

After reboot:
illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    0m28.127s
user    0m0.044s
sys     0m2.924s

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync
illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/
real    0m14.872s
user    0m0.044s
sys     0m2.872s


illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync
sunset:~ # echo 1 > /proc/sys/vm/drop_caches
illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    0m28.257s
user    0m0.036s
sys     0m2.732s

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync
sunset:~ # echo 3 > /proc/sys/vm/drop_caches
illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    0m28.155s
user    0m0.048s
sys     0m2.772s

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync
sunset:~ # echo 3 > /proc/sys/vm/drop_caches
illes@sunset:~/tmp> find  linux-2.6.21.5/ -noleaf >/dev/null
illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    0m25.702s
user    0m0.064s
sys     0m2.664s

-------------------------------------------------------------------
mount opts: rw,noatime,nodiratime,logbsize=256k,logbufs=2,nobarrier

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync &&  
reboot
After reboot:

illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    1m12.738s
user    0m0.032s
sys     0m2.548s

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync
illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    0m7.884s
user    0m0.028s
sys     0m2.008s

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync
sunset:~ # echo 1 > /proc/sys/vm/drop_caches
illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    1m15.367s
user    0m0.048s
sys     0m2.264s

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync
sunset:~ # echo 3 > /proc/sys/vm/drop_caches
illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    1m16.043s
user    0m0.060s
sys     0m2.448s

illes@sunset:~/tmp> tar xjf ~/Download/linux-2.6.21.5.tar.bz2 && sync
sunset:~ # echo 3 > /proc/sys/vm/drop_caches
illes@sunset:~/tmp> find  linux-2.6.21.5/ -noleaf >/dev/null
illes@sunset:~/tmp> time rm -rf linux-2.6.21.5/

real    1m7.856s
user    0m0.044s
sys     0m2.020s


Cheers,
Szabolcs
