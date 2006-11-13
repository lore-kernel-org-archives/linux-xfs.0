Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Nov 2006 20:52:19 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAD4q8aG032719
	for <xfs@oss.sgi.com>; Sun, 12 Nov 2006 20:52:10 -0800
Received: from [134.14.55.100] (cxfsmac10.melbourne.sgi.com [134.14.55.100])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id kAD4pE7Y32517879;
	Mon, 13 Nov 2006 15:51:15 +1100 (AEDT)
In-Reply-To: <1163390942.14517.12.camel@localhost.localdomain>
References: <1163381602.11914.10.camel@localhost.localdomain> <965ECEF2-971D-46A1-B3F2-C6C1860C9ED8@sgi.com> <1163390942.14517.12.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <12275452-56ED-4921-899F-EFF1C05B251A@sgi.com>
Content-Transfer-Encoding: 7bit
From: Sam Vaughan <sjv@sgi.com>
Subject: Re: XFS_IOC_RESVSP64 versus XFS_IOC_ALLOCSP64 with multiple threads
Date: Mon, 13 Nov 2006 15:53:54 +1100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stewart Smith <stewart@mysql.com>
Cc: xfs@oss.sgi.com

On 13/11/2006, at 3:09 PM, Stewart Smith wrote:

> On Mon, 2006-11-13 at 13:58 +1100, Sam Vaughan wrote:
>> Are the two processes in your test writing files to the same
>> directory as each other?  If so then their allocations will go into
>> the same AG as the directory by default, hence the fragmentation.  If
>> you can limit yourself to an AG's worth of data per directory then
>> you should be able to avoid fragmentation using the default
>> allocator.  If you need to reserve more than that per AG, then the
>> files will most likely start interleaving again once they spill out
>> of their original AGs.  If that's the case then the upcoming
>> filestreams allocator may be your best bet.
>
> I do predict that the filestreams allocator will be useful for us (and
> also on my MythTV box...).
>
> The two processes write to their own directories.
>
> The structure of the "filesystem" for the process (ndbd) is:
>
> ndb_1_fs/ (the 1 refers to node id, so there is a ndb_2_fs for a 2  
> node
> setup)
> 	D8/, D9/, D10/, D11/
> 		all have a DBLQH subdirectory. In here there are several
> 		S0.FragLog files (the number changes). These are 16MB
> 		files used for logging.
> 		We (currently) don't do any xfsctl allocation on these.
> 		We should though. In fact, we're writing them in a way
> 		to get holes (which probably affects performance).
> 		These files are write only (except during a full cluster
> 		restart - a very rare event).
>
> 	LCP/0/T0F0.Data
> 		(there is at least 0,1,2 for that first number,
> 		T0 is table 0 - can be thousands of tables.
> 		f0 is fragment 0, can be a few of them too, typically
> 		2-4 though)
> 		These are an on-disk copy of in-memory tables, variably
> 		sized files (as big or as small as tables in a DB)
> 		The above log files are for changes occuring during the
> 		writing of these files.
>
> 	datafile01.dat, undofile01.dat etc
> 	whatever files the user creates for disk based tables
> 		the datafiles and undofiles that i've done the special
> 		allocation for.
> 		Typical deployments will have anything from a few
> 		hundred MB per file to few GB to many many GB.
>
> "typical" installations are probably now evenly split between 1  
> process
> per physical machine and several (usually 2).

Just to be clear, are we talking about intra-file fragmentation, i.e.  
file data laid out discontiguously on disk, or inter-file  
fragmentation where each file is continguous on disk but the files  
from different processes are getting interleaved?  Also, are there  
just a couple of user data files, each of them potentially much  
larger than the size of an AG, or do you split the data up into many  
files, e.g. datafile01.dat ... datafile99.dat ...?

If you have the flexibility to break the data up at arbitrary points  
into separate files, you could get optimal allocation behaviour by  
starting a new directory as soon as the files in the current one are  
large enough to fill an AG.  The problem with the filestreams  
allocator is that it will only dedicate an AG to a directory for a  
fixed and short period of time after the last file was written to  
it.  This works well to limit the resource drain on AGs when running  
file-per-frame video captures, but not so well with a database that  
writes its data in a far less regimented and timely way.

The following two tests illustrate the standard allocation policy I'm  
referring to here.  I've simplified it to take advantage of the fact  
that it's producing just one extent per file, but you can run  
`xfs_bmap -v` over all the files to verify that's the case.

Standard SLES 10 kernel, standard mount options:

$ uname -r
2.6.16.21-0.8-smp
$ xfs_info .
meta-data=/dev/sdb8              isize=256    agcount=16,  
agsize=3267720 blks
          =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=52283520,  
imaxpct=25
          =                       sunit=0      swidth=0 blks,  
unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=25529, version=1
          =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0
$ mount | grep sdb8
/dev/sdb8 on /spare200 type xfs (rw)
$

Create two directories and start two processes off, one per  
directory.  The processes preallocate ten 100MB files each.  The  
result is that their data goes into separate AGs on disk, all nicely  
contiguous:

$ mkdir a b
$ for dir in a b; do
 > for file in `seq 0 9`; do
 > touch $dir/$file
 > xfs_io -c 'allocsp 100m 0' $dir/$file
 > done &
 > done; wait
[1] 5649
[2] 5650
$ for file in `seq 0 9`; do
 > bmap_a=`xfs_bmap -v a/$file | tail -1`
 > bmap_b=`xfs_bmap -v b/$file | tail -1`
 > ag_a=`echo $bmap_a | awk '{print $4}'`
 > ag_b=`echo $bmap_b | awk '{print $4}'`
 > br_a=`echo $bmap_a | awk 'printf "%-18s", $3}'`
 > br_b=`echo $bmap_b | awk 'printf "%-18s", $3}'`
 > echo a/$file: $ag_a "$br_a" b/$file: $ag_b "$br_b"
 > done
a/0: 8 209338416..209543215 b/0: 9 235275936..235480735
a/1: 8 209543216..209748015 b/1: 9 235480736..235685535
a/2: 8 209748016..209952815 b/2: 9 235685536..235890335
a/3: 8 209952816..210157615 b/3: 9 235890336..236095135
a/4: 8 210157616..210362415 b/4: 9 236095136..236299935
a/5: 8 210362416..210567215 b/5: 9 236299936..236504735
a/6: 8 210567216..210772015 b/6: 9 236504736..236709535
a/7: 8 210772016..210976815 b/7: 9 236709536..236914335
a/8: 8 210976816..211181615 b/8: 9 236914336..237119135
a/9: 8 211181616..211386415 b/9: 9 237119136..237323935
$

Now do the same thing, except have the processes write their files  
into the same directory using different file names.  This time the  
files are allocated on top of each other.

$ dir=c
$ mkdir $dir
$ for process in 1 2; do
 > for file in `seq 0 9`; do
 > touch $dir/$process.$file
 > xfs_io -c 'allocsp 100m 0' $dir/$process.$file
 > done &
 > done; wait
[1] 5985
[2] 5986
$ for file in c/*; do
 > bmap=`xfs_bmap -v $file | tail -1`
 > ag=`echo $bmap | awk '{print $4}'`
 > br=`echo $bmap | awk '{printf "%-18s", $3}'`
 > echo $file: $ag "$br"
 > done
c/1.0: 11 287559456..287764255
c/1.1: 11 287969056..288173855
c/1.2: 11 288378656..288583455
c/1.3: 11 288788256..288993055
c/1.4: 11 289197856..289402655
c/1.5: 11 289607456..289812255
c/1.6: 11 290017056..290221855
c/1.7: 11 290426656..290631455
c/1.8: 11 290836264..291041063
c/1.9: 11 291450664..291655463
c/2.0: 11 287764256..287969055
c/2.1: 11 288173856..288378655
c/2.2: 11 288583456..288788255
c/2.3: 11 288993056..289197855
c/2.4: 11 289402656..289607455
c/2.5: 11 289812256..290017055
c/2.6: 11 290221856..290426655
c/2.7: 11 290631464..290836263
c/2.8: 11 291041064..291245863
c/2.9: 11 291245864..291450663
$

Now in your case you're using different directories, so your files  
are probably OK at the start of day.  Once the AGs they start in fill  
up though, the files for both processes will start getting allocated  
from the next available AG.  At that point, allocations that started  
out looking like the first test above will end up looking like the  
second.

The filestreams allocator will stop this from happening for  
applications that write data regularly like video ingest servers, but  
I wouldn't expect it to be a cure-all for your database app because  
your writes could have large delays between them.  Instead, I'd look  
into ways to break up your data into AG-sized chunks, starting a new  
directory every time you go over that magic size.

Sam
