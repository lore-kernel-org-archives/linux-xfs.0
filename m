Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Nov 2006 16:02:40 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAE02SaG010567
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 16:02:30 -0800
Received: from [134.14.55.100] (cxfsmac10.melbourne.sgi.com [134.14.55.100])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id kAE01W7Y33835095;
	Tue, 14 Nov 2006 11:01:34 +1100 (AEDT)
In-Reply-To: <1163395250.14517.38.camel@localhost.localdomain>
References: <1163381602.11914.10.camel@localhost.localdomain> <965ECEF2-971D-46A1-B3F2-C6C1860C9ED8@sgi.com> <1163390942.14517.12.camel@localhost.localdomain> <12275452-56ED-4921-899F-EFF1C05B251A@sgi.com> <1163395250.14517.38.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <950D2C3E-11AE-4805-9286-65ECD880272D@sgi.com>
Content-Transfer-Encoding: 7bit
From: Sam Vaughan <sjv@sgi.com>
Subject: Re: XFS_IOC_RESVSP64 versus XFS_IOC_ALLOCSP64 with multiple threads
Date: Tue, 14 Nov 2006 11:04:17 +1100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stewart Smith <stewart@mysql.com>
Cc: xfs@oss.sgi.com

On 13/11/2006, at 4:20 PM, Stewart Smith wrote:

> On Mon, 2006-11-13 at 15:53 +1100, Sam Vaughan wrote:
>> Just to be clear, are we talking about intra-file fragmentation, i.e.
>> file data laid out discontiguously on disk, or inter-file
>> fragmentation where each file is continguous on disk but the files
>> from different processes are getting interleaved?  Also, are there
>> just a couple of user data files, each of them potentially much
>> larger than the size of an AG, or do you split the data up into many
>> files, e.g. datafile01.dat ... datafile99.dat ...?
>
> an example:
>
> /home/mysql/cluster/ndb_1_fs/datafile1.dat:
>  EXT: FILE-OFFSET       BLOCK-RANGE        AG AG-OFFSET          TOTAL
>    0: [0..63]:          32862376..32862439  8 (1405096..1405159)    64
>    1: [64..127]:        32875992..32876055  8 (1418712..1418775)    64
>    2: [128..191]:       33040112..33040175  8 (1582832..1582895)    64
>    3: [192..255]:       33080136..33080199  8 (1622856..1622919)    64
>    4: [256..319]:       33101416..33101479  8 (1644136..1644199)    64
>    5: [320..383]:       33112624..33112687  8 (1655344..1655407)    64
>    6: [384..447]:       32526608..32526671  8 (1069328..1069391)    64
>    7: [448..511]:       31678920..31678983  8 (221640..221703)      64
> /home/mysql/cluster/ndb_2_fs/datafile1.dat:
>  EXT: FILE-OFFSET       BLOCK-RANGE        AG AG-OFFSET          TOTAL
>    0: [0..63]:          32864704..32864767  8 (1407424..1407487)    64
>    1: [64..127]:        32888544..32888607  8 (1431264..1431327)    64
>    2: [128..191]:       33068832..33068895  8 (1611552..1611615)    64
>    3: [192..255]:       33101168..33101231  8 (1643888..1643951)    64
>    4: [256..319]:       33101656..33101719  8 (1644376..1644439)    64
>    5: [320..383]:       33115784..33115847  8 (1658504..1658567)    64
>    6: [384..447]:       33897200..33897263  8 (2439920..2439983)    64
>    7: [448..511]:       33900896..33900959  8 (2443616..2443679)    64

Those extents are curiously uniform, all 32kB in size.  The fact that  
both files' extents are in AG 8 suggests that the two directories  
ndb_1_fs and ndb_2_fs filled their original AGs and spilled out into  
other ones, which is when the interference would have started.   
Looking at the directory hierarchy in your last email, you might be  
better off if you could add another directory for the datafiles and  
undofiles to live in, so they don't end up sharing their AG with  
other stuff in their parent directory.

> on this fs:
>  isize=256    agcount=32, agsize=491520 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=15728640,
> imaxpct=25
>          =                       sunit=0      swidth=0 blks,  
> unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=3840, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=65536  blocks=0, rtextents=0

OK, so you've got 32 2GB AGs, and the filesystem is much too small  
for the inode32 rotor to be involved.

> (somewhere between 5-15Gb free from this create IIRC)
>
> these datafiles are fixed size, allocated by user. a DBA would run  
> from
> the SQL server something like:
> CREATE TABLESPACE ts1
> ADD DATAFILE 'datafile.dat'
> USE LOGFILE GROUP lg1
> INITIAL_SIZE 1G
> ENGINE NDB;
>
> to get a tablespace with 1GB data file (on each node).

So your data file is half the size of an AG.  That shouldn't be a  
problem but it'd be best to keep it to one or two of these files per  
directory if there's going to be much other concurrent allocation  
activity.

> we currently don't do any automatic extending.
>
>> If you have the flexibility to break the data up at arbitrary points
>> into separate files, you could get optimal allocation behaviour by
>> starting a new directory as soon as the files in the current one are
>> large enough to fill an AG.  The problem with the filestreams
>> allocator is that it will only dedicate an AG to a directory for a
>> fixed and short period of time after the last file was written to
>> it.  This works well to limit the resource drain on AGs when running
>> file-per-frame video captures, but not so well with a database that
>> writes its data in a far less regimented and timely way.
>
> for the data and undo files, we're just not changing their size except
> at creation time, so that's okay.

I'd assumed that these files were being continually grown.  If all  
this is happening at creation time then it shouldn't be too hard to  
make sure the files are cleanly allocated with just one extent.  Does  
the following not work on your file system?

$ touch a b
$ for file in a b; do
 > xfs_io -c 'allocsp 1G 0' $file &
 > done; wait
[1] 12312
[2] 12313
[1]-  Done                    xfs_io -c 'allocsp 1G 0' $file
[2]+  Done                    xfs_io -c 'allocsp 1G 0' $file
$ xfs_bmap -v a b
a:
EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET               
TOTAL
    0: [0..2097151]:    231732008..233829159  6 (11968856..14066007)  
2097152
b:
EXT: FILE-OFFSET      BLOCK-RANGE          AG AG-OFFSET               
TOTAL
    0: [0..2097151]:    233829160..235926311  6 (14066008..16163159)  
2097152
$

>> Now in your case you're using different directories, so your files
>> are probably OK at the start of day.  Once the AGs they start in fill
>> up though, the files for both processes will start getting allocated
>> from the next available AG.  At that point, allocations that started
>> out looking like the first test above will end up looking like the
>> second.
>>
>> The filestreams allocator will stop this from happening for
>> applications that write data regularly like video ingest servers, but
>> I wouldn't expect it to be a cure-all for your database app because
>> your writes could have large delays between them.  Instead, I'd look
>> into ways to break up your data into AG-sized chunks, starting a new
>> directory every time you go over that magic size.
>
> I'll have to check our writing behaviour the files that change  
> sizes...
> but they're not too much of an issue (they're hardly ever read  
> back, so
> as long as writing them out is okay and reading isn't totally abismal,
> we don't have to worry).

That's handy.  All in all it sounds like your requirements are very  
file system friendly in terms of getting optimum allocation.  I'm not  
sure what could be causing all those 32kB extents.

Sam
