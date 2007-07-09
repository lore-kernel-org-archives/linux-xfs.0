Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Jul 2007 14:45:11 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l69Lj3tL027102
	for <xfs@oss.sgi.com>; Mon, 9 Jul 2007 14:45:06 -0700
Received: from localhost (dslb-084-057-124-069.pools.arcor-ip.net [84.57.124.69])
	by mail.lichtvoll.de (Postfix) with ESMTP id F2FA75AD54
	for <xfs@oss.sgi.com>; Mon,  9 Jul 2007 23:17:28 +0200 (CEST)
Content-Disposition: inline
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Fwd: xfs_fsr and null byte areas in files (REPOST) / file data checksumming
MIME-Version: 1.0
Date: Mon, 9 Jul 2007 23:13:48 +0200
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707092313.48876.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hello!

I am reposting this, cause I think its an very serious issue. What I 
experienced here is quite randomly spread *silent* data corruption. Not 
meta data, but data in files, but that actually doesn't make this less 
severe.

I really like to hear some feedback on it. I will clarify on this by 
asking some questions on how to efficiently try to reproduce it and 
detect that it happened again. But first I summarize what happened and 
add some more information to it.

It started when KMail detected broken index files after I ran xfs_fsr and 
rebuilt them[1]. I suspected it could be an issue with files that were 
open while xfs_fsr ran. Later on I detected a broken hg repository. I 
still suspected that I might had used this while xfs_fsr was running 
tough and did not take the time to look deeper.

But then more than a week later I detected a broken Bazaar repository as 
well and when I checked all my Bazaar and Mercurial repositories via 
script lots more of broken ones. Then I checked for other broken files 
and found hundreds of them. I also analyzed the kind of corruption and 
found null byte areas where there should be data in the files I looked 
at.

Just the in this case intelligent standard behavior of rsync not to 
comparing every byte of files whose date and size didn't change in order 
to decide which files to backup saved my backup from being corrupted as 
well. That made it possible to at least recover corrupted files that were 
unchanged since my last backup. It still is possible that I have some 
corrupted files that have changed since my last backup, but there is no 
way anymore to fix them.

Now it seems that at least some users use xfs_fsr regularily[2][3]. Johan, 
did you ever check your files for consistency? If you have a usual rsync 
backup of them a rsync -acn would do this without altering the backup.

I also thought hard whether I am facing the issue with binary NULLs in 
files that is described in the FAQ[4]. But I halted the machine 
regularily after KMail found those broken index files in order to boot my 
OpenSUSE installation to run xfs_check on affected partitions (except 
OpenSUSE itself). Thus I actually think I got a different issue.

I now also checked such a broken file - I still have those broken 
repositories around for holes, and well these null bytes are for real:

---------------------------------------------------------------------
martin@shambala:~/.crm114> 
head -c9183 .bzr-broken/repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit |
tail -c1000 | od -h
0000000 d46d 2b8b 9b50 5ce8 00f7 0000 0000 0000
0000020 0000 0000 0000 0000 0000 0000 0000 0000
*
0001740 0000 0000 0000 0000
0001750

shambala:/home/martin/.crm114> 
xfs_bmap -v .bzr-broken/repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit
.bzr-broken/repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET          TOTAL
   0: [0..23]:         32065584..32065607  5 (4599184..4599207)    24
---------------------------------------------------------------------

(I did not copy the repository before I rsynced back the good one, I just 
moved it with mv.)

I would like to reproduce it and have some questions on how to do that 
efficiently. I have a spare 1GB on my notebook harddisk and also a spare 
10GB on an external USB drive that I could use for a test partition.

1) Is there an XFS qa test available for xfs_fsr? If so I could use that 
one. Are there some hints on how to get started on XFS qa?

2) If not, what would be the most efficient scriptable way to produce 
fragmented files? I would like to copy some directories to that test 
partition in a way that produces lots of fragmented files, then run 
xfs_fsr just on that partition and then compare the data with the 
original data with rsync -acn. 

For an xfsqa test it might be better to use md5sum (since it saves an 
extra copy of the created data) tough. I strongly recommend to add a xfs 
qa test for xfs_fsr. Is there a test that verifies file data integrity 
after files have been shuffled around?

And least but not least:

Are there any plans to put file data checksumming code into XFS at least 
as an option that one can enable? 

I think modern computers have enough processing power to handle efficient 
checksumming algorithms without too much overhead. It would be nice to 
have an easy way to detect whether the data of a file is still consistent 
or not. I found most of the broken files via rsync, but only those that 
have been unchanged since the last backup. I have no means at all but 
searching for null byte areas in files and judge whether they indicate 
brokenness to find any remaining broken files. Since there may be files 
with legitimate null byte areas I may not be able to tell at all whether 
a file is broken or not.

The percentage of files are affected is quite low and thus I just may have 
luck and will find no more important broken files over time.

[1] http://oss.sgi.com/archives/xfs/2007-06/msg00242.html

[2] http://oss.sgi.com/archives/xfs/2007-06/msg00416.html

[3] http://oss.sgi.com/archives/xfs/2007-06/msg00148.html

[4] http://oss.sgi.com/projects/xfs/faq.html#nulls

----------  Weitergeleitete Nachricht  ----------

Subject: xfs_fsr and null byte areas in files (was: Re: xfs_fsr - problem 
with open files possible?)
Date: Samstag 23 Juni 2007
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-xfs@oss.sgi.com

Am Freitag 15 Juni 2007 schrieb Eric Sandeen:
> Martin Steigerwald wrote:
> > Could data loss happen when running xfs_fsr on files that are opened
> > by an application?
>
> It should not; fsr performs a lot of safety checks and aborts under
> problematic circumstances.  It will skip files if:
>
>  * mandatory locks are present
>  * file is marked immutable, append-only, or nodefrag
>  * filesystem is shut down
>  * change/modify times have been altered since defrag started
>  * original file is mmapped
>
> If you can clearly recreate it with xfs_fsr, it would be interesting to
> compare the good & bad index files to see how they differ, it might
> offer a clue as to what/why/how it changed.
>
> > I did not came across any other corrupted files except a Mercurial
> > repository. I can not pinpoint this problem to XFS at all and have no
> > idea how and when it got corrupted. At least in my backup from some
> > weeks ago the repository has been okay. Unfortunately I do not know
> > anymore whether I made a commit to that repository while xfs_fsr was
> > running or not. But I think I didn't.

Hello Eric!

Well I now found lots of corrupted Bazaar repositories as well. For all 
except one I had a working backup. Those were definately not in use while 
xfs_fsr ran. I can't prove the corruption to xfs_fsr, but except for 
another XFS failure - which I doubt happened - I can't think of much of 
else. Granted I used some beta versions of Bazaar, but not on all of 
those corrupted repositories.

I tried to reproduce this with my good repositories from the backup, but 
couldn't. I bet that they were not fragmented. xfs_fsr **/* (which 
recursively matches all files on Z-Shell) in the directories of them 
returned rather quickly.

It also happened on a second notebook. I have a T42 and a T23 and it 
happened on the T23 too.

I had a closer look about the kind of corruption. Only the file content 
seemed to have changed, not the date of the file or its size. Thus I was 
in luck cause rsync simply didn't copy the corrupted repositories to my 
backup disk. I found out about this as I tried to rsync the corrected 
repositories from my T42 to the T23. rsync would not copy them. But when 
I used rsync -c it copies some files with differing checksum.

One example:

---------------------------------------------------------------------
martin@shambala:~/.crm114> rsync -acnv .bzr/ .bzr-broken/
building file list ... done
./
branch-lock/
branch/
branch/lock/
checkout/
checkout/lock/
repository/
repository/knits/
repository/knits/22/
repository/knits/36/
repository/knits/36/mailtrainer.crm-20070329201046-91b62hipeixaywh9-5.knit
repository/knits/3d/
repository/knits/4a/
repository/knits/4a/mailfilter.cf-20070329201046-91b62hipeixaywh9-1.knit
repository/knits/76/
repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit
repository/knits/8c/
repository/knits/8c/shuffle.crm-20070329201046-91b62hipeixaywh9-6.knit
repository/knits/9c/
repository/knits/a9/
repository/knits/c5/
repository/knits/c5/mailreaver.crm-20070329201046-91b62hipeixaywh9-4.knit
repository/lock/
repository/revision-store/

sent 2335 bytes  received 368 bytes  5406.00 bytes/sec
total size is 86288  speedup is 31.92
martin@shambala:~/.crm114>
---------------------------------------------------------------------


Those files are differing - one example:

---------------------------------------------------------------------
martin@shambala:~/.crm114> LANG=C 
cmp .bzr/repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit .bzr-broken/repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit
.bzr/repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit .bzr-broken/repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit 
differ: char 8193, line 22
---------------------------------------------------------------------

The good one:

---------------------------------------------------------------------
martin@shambala:~/.crm114> 
head -c9183 .bzr/repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit | 
tail -c1000 | od -h
0000000 d46d 2b8b 9b50 5ce8 e3f7 964c 6b3f 728b
0000020 8541 e12e f328 92a5 7061 2981 6232 7463
0000040 6583 0421 b568 481f f5db ce4c 6924 8b55
[... lots of data that looks like the first three lines ...]
0001700 a28d 2b64 d792 6dcc 96cb 15c7 f960 7e26
0001720 dc22 1d2d 6a0e 6ce0 3648 a050 c7ec 371c
0001740 743c 2502 e5e4 e1d1
0001750

---------------------------------------------------------------------


The broken one - this really looks like the null files problem!:
---------------------------------------------------------------------

martin@shambala:~/.crm114> 
head -c9183 .bzr-broken/repository/knits/76/maillib.crm-20070329201046-91b62hipeixaywh9-3.knit | 
tail -c1000 | od -h
0000000 d46d 2b8b 9b50 5ce8 00f7 0000 0000 0000
0000020 0000 0000 0000 0000 0000 0000 0000 0000
*
0001740 0000 0000 0000 0000
0001750
---------------------------------------------------------------------

I checked at least one of those files with xfs_bmap and it was no sparse 
file, these are real zeros.


I am quite a bit confused by that since I cannot remember that I had any 
abnormal write interruption while the xfs_fsr command was running or 
after it has finished. As I found out about corrupted files I just 
rebooted cleanly to my SUSE installation and ran xfs_check on the 
partitions I xfs_fsr'ed which turned out to be okay. Also certainly not 
all of these broken repositories had been in use while any abnormal write 
termination happened.


I am doing checks for other broken files now:

---------------------------------------------------------------------
find -type f -and -iname "*" -print0  | xargs -0 -I{} cmp 
{} /mnt/backup/home/martin/{}
---------------------------------------------------------------------

Better with that one:

---------------------------------------------------------------------
rsync -acnv /mnt/backup/home/martin/ /home/martin/
---------------------------------------------------------------------

Oh well, there are other files differing which should certainly be the 
same - since I didn't touch them in the meanwhile. And they contain zeros 
where there should be data as well as far as I looked. So whatever I 
faced here its a real corruption issue! And I know I will continue to use 
rsync without -c in my backup script, cause that prevented the corrupted 
files from being copied to my backup!

Well thus maybe is a bad interaction between xfs_fsr and the null files 
problem or a problem in xfs_fsr...

I for my part will be very cautious with xfs_fsr in the future. If I 
manage to take the time I likely will create a XFS partition in that one 
GB that is left on my harddisk copy certain directories in it 
simultaneously so that it hopefully creates some fragmentation and then 
run xfs_fsr... I hope I will be able to track this down, cause its really 
bad behavior.

Is there a xfs QA test which tests xfs_fsr? I think there should be one, 
especially as this tool does not seem to be used that often out in the 
wild. Preferably one that copies lots of data to a partition in a way that 
it gets fragmented, md5sums it, runs xfs_fsr and then compares the 
md5sums of the files.

If anyone else has time I suggest tests on that topic. It seems that 
something is going really wrong here even when I cannot prove it right 
now. But maybe it was just a rare race condition. Well see. I hope I will 
be able to reproduce it.

I ran xfs_fsr

---------------------------------------------------------------------
shambala:~> LANG=C apt-cache policy xfsdump
xfsdump:
  Installed: 2.2.38-1
  Candidate: 2.2.38-1
  Version table:
     2.2.45-1 0
        500 http://debian.n-ix.net lenny/main Packages
        500 http://debian.n-ix.net sid/main Packages
 *** 2.2.38-1 0
        990 http://debian.n-ix.net etch/main Packages
        100 /var/lib/dpkg/status
---------------------------------------------------------------------

on Linux Kernel 2.6.21.3 on my XFS /home partition back then.

Since images, music, mail files, movies and stuff are not automatically 
checked for corruption and since not many files seem to be affected I 
think I didn't notice other files to be affected. Will likely take quite 
some time as I changed to many files since my last backup...

OK, now on to recovery:

- xfs_check xfs_fsr involved partitions - they are fine
- xfs_check the backup partitions - they are fine tough

The most automatic way to get things recovered as good as possible is to 
rsync my current data to the backup partition *without* determining 
changed files by its checksum. Then rsync the updated backup back to the 
work place *with* determining changes files by its checksum:

---------------------------------------------------------------------
shambala:~ #
rsync -axv --acls --sparse --delete /mnt/debian/ /mnt/backup/debian/

shambala:~ # 
rsync -axv --acls --sparse --delete /mnt/debian/ /mnt/backup/debian/
building file list ... done

sent 10306228 bytes  received 20 bytes  38818.26 bytes/sec
total size is 8376658632  speedup is 812.77

shambala:~ #
rsync -acxv --acls --sparse --del /mnt/backup/debian/ /mnt/debian/ | 
tee /home/martin/XFS-Probleme/2007-07-23/rsync-acxv-debian.txt
---------------------------------------------------------------------

Now look what is in "rsync-acxv-debian.txt":

---------------------------------------------------------------------
building file list ... done
.kde/share/apps/kconf_update/log/update.log
[ ... above one shouldn't be here at / at all of course, however I managed 
it to be there ;-) ... ]
boot/grub/default
lost+found/8937921
lost+found/8937923
usr/bin/nslookup
usr/games/gnubg
usr/lib/libGLU.a
usr/lib/libclucene.so.0.0.0
usr/lib/libdns.so.22.1.0
usr/lib/libkeximain.so.2.0.0
usr/lib/libkoproperty.so.2.0.0
usr/lib/libkwordprivate.so.4.0.0
usr/lib/libpoppler.so.0.0.0
usr/lib/flashplugin-nonfree/libflashplayer.so
usr/lib/gcc/i486-linux-gnu/4.1.2/cc1
usr/lib/jvm/java-1.5.0-sun-1.5.0.10/jre/lib/charsets.jar
usr/lib/jvm/java-1.5.0-sun-1.5.0.10/jre/lib/i386/client/libjvm.so
usr/lib/jvm/java-1.5.0-sun-1.5.0.10/jre/lib/i386/motif21/libmawt.so
usr/lib/mono/gac/System.Data/1.0.5000.0__b77a5c561934e089/System.Data.dll.mdb
usr/lib/python2.3/site-packages/PyQt4/QtGui.so
usr/lib/python2.4/site-packages/PyQt4/QtGui.so
usr/share/X11/doc/hardcopy/XKB/XKBlib.ps.gz
usr/share/doc/aircrack-ng/injection-patches/linux-wlan-0.2.3.packet.injection.patch.gz
usr/share/doc/dahb-html/html/bilder/allgemein/debian-devel-earth.png
usr/share/doc/dahb-html/html/bilder/allgemein/openlogo-nd.png
usr/share/doc/dahb-html/html/bilder/sarge/sarge1.png
usr/share/doc/dahb-html/html/bilder/sarge/sargebasec17.png
usr/share/doc/dahb-html/html/bilder/sarge/sargebasesecurity.png
usr/share/doc/dahb-html/html/bilder/sarge/sargedomainname.png
usr/share/doc/dahb-html/html/bilder/sarge/sargehostname.png
usr/share/doc/dahb-html/html/bilder/sarge/sargepart1.png
[... it goes on like this ...]
---------------------------------------------------------------------

This is nasty. Some of those would have been very difficult to find. Heck 
that flash player even worked OK yesterday on YouTube.

Luckily not that many files seem to have been affected (aside from those 
broken repositories and KMail index files I alread fixed):

martin@shambala:Shambala/XFS-Probleme/2007-07-23> wc -l 
rsync-acxv-debian.txt
117 rsync-acxv-debian.txt
martin@shambala:Shambala/XFS-Probleme/2007-07-23> wc -l 
rsync-acxv-debian-home.txt
232 rsync-acxv-debian-home.txt

Well at least for me T42 I recovered almost all important data. One Bazaar 
repository got lost, but I can get the version history from someone else.

And there is a slight risk that some of the files that I already changed 
in the meanwhile have zero byte areas as well that didn't come to my 
attention yet.

Well that shows me that a checksumming filesystem would really be good! It 
could have told me that file contents have been corrupted during check.

And I learn quite a lot:

- if there is any slight chance of corruption (that corrupted KMail index 
files) check it out before doing anything else. Just do not assume that 
its only those files that have been affected, but check with rsync -c

- if there are broken files, restore the backup before doing anything 
else. Except that I have spare storage where I could store the 
filesystems with the broken files first for further analysis.

That would have helped me to have next to zero data loss and it would have 
been way quicker to restore everything to normal.

And another one:

- do not try an online defragmentation on valuable data before testing it 
first on test data

I still can't prove it, but I am quite sure that it has been xfs_fsr maybe 
in combination with some XFS problem. It was the only tool that could 
have accessed all those files. I know for sure I didn't do write accesses 
on many of them.

Some more information about my T42... Kernel version and Debian 
installation on my T23 are pretty similar only drivers differ a bit:

martin@shambala:~> cat /proc/version
Linux version 2.6.21.3-tp42-cfs-v15-sws2-2.2.10 (martin@shambala) (gcc 
version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 PREEMPT Sun Jun 
3 21:43:50 CEST 2007

shambala:~> xfs_info /
meta-data=/dev/root              isize=256    agcount=16, agsize=228894 
blks
         =                       sectsz=512   attr=1
data     =                       bsize=4096   blocks=3662304, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=2560, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0

shambala:~> xfs_info /home
meta-data=/dev/sda2              isize=256    agcount=19, agsize=686660 
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=12695508, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=5364, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0


Ok, I am quite exhausted now. And there is still the T23 to do... (in 
progress at the moment).

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7



-------------------------------------------------------

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
