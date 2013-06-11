Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8D60729DF8
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 16:57:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CD23304043
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 14:57:26 -0700 (PDT)
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [195.71.86.230]) by
	cuda.sgi.com with ESMTP id F4KBRwZJugIi4eXP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 14:57:21 -0700 (PDT)
Date: Tue, 11 Jun 2013 23:57:16 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Questions about XFS
Message-ID: <20130611215716.GA6935@citd.de>
References: <loom.20130611T112155-970@post.gmane.org>
	<20130611193525.GT20932@sgi.com>
	<CAO9HMNEt4XKdV6+jfKwHVPrDaVNytx65MQDK52Uckcy-O6YikQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAO9HMNEt4XKdV6+jfKwHVPrDaVNytx65MQDK52Uckcy-O6YikQ@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Steve Bergman <sbergman27@gmail.com>
Cc: linux-xfs@oss.sgi.com

On 11.06.2013 14:55, Steve Bergman wrote:
> Hi Ben,
> 
> /usr/local/data - Ext3 (Cobol doesn't know about fsync. I need
> pony-magic in this LV.)

You COULD do a little magic external of the program to expedite writing 
to stable storage.

- fsync_test.pl -
#!/usr/bin/perl

use File::Sync qw(fsync);

open my $fh, '<', 'testfile' or die ("Can't open: $!");
fsync($fh) or die ("Can't fsync: $!");
close $fh;
- fsync_test.pl -

- fsync_test.sh -
rm -f testfile
echo -n sync: ; time sync
echo ; echo -n dd: ; time dd if=/dev/zero of=testfile bs=1M count=1k
echo ; echo -n fsync_test.pl: ; time ./fsync_test.pl
echo ; echo -n sync: ; time sync
- fsync_test.sh -

The result on my machine against a HDD:

- result -
sync:
real    0m0.048s
user    0m0.000s
sys     0m0.046s

dd:
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 0.317354 s, 3.4 GB/s
real    0m0.318s
user    0m0.001s
sys     0m0.316s

fsync_test.pl:
real    0m10.237s
user    0m0.012s
sys     0m0.133s

sync:
real    0m0.047s
user    0m0.000s
sys     0m0.045s
- result -

This tells me that a program can fsync a file i didn't write itself.

I choose 1GB because it can be created fast enough to not trigger any 
automatic writebacks (And with 32GB of RAM it is well within default 
limits) and still long enough to be easily visible with simple 
'time'ing.

With secret ingredient number 2, inotify, you COULD write a program that 
does 'fsync'(s) after the program that can't do it itself. Of course 
that can only expedite matters, it doesn't give you the same consistency 
guarantees as the original program isn't the one waiting for the 
fsync(s) to complete and happily continues dirtying more data in the 
mean time. 


And there also is syncfs which is relativly new (man-page says it was 
introduced with kernel 2.6.39). 'syncfs' is a lighter version of 'sync' 
that only syncs a single filesystem. So you could make a program that 
does a syncfs every second or so (with the help of inotify you could do 
it after something "interesting" was written), without impacting other 
filesystems like 'sync' does.




-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
