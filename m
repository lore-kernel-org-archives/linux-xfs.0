Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1DC037F47
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 19:31:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9D9BBAC001
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 17:31:00 -0700 (PDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
	[209.85.212.178]) by cuda.sgi.com with ESMTP id
	rmEu0IQ5XZw89raD (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 11 Jul 2014 17:30:58 -0700 (PDT)
Received: by mail-wi0-f178.google.com with SMTP id hi2so36019wib.11
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 17:30:57 -0700 (PDT)
Received: from Telcontar.valinor (90.Red-79-150-228.dynamicIP.rima-tde.net.
	[79.150.228.90])
	by mx.google.com with ESMTPSA id jy8sm8342129wjc.7.2014.07.11.17.30.55
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 11 Jul 2014 17:30:56 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 6178460685
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 02:30:55 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id buV_S-MEiHMK for <xfs@oss.sgi.com>;
	Sat, 12 Jul 2014 02:30:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 9EDFC60679
	for <xfs@oss.sgi.com>; Sat, 12 Jul 2014 02:30:53 +0200 (CEST)
Date: Sat, 12 Jul 2014 02:30:45 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
In-Reply-To: <20140705122833.GA3573@bfoster.bfoster>
Message-ID: <alpine.LSU.2.11.1407120150220.15907@Telcontar.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
	<20140703173916.GB3452@laptop.bfoster>
	<alpine.LSU.2.11.1407040135140.9881@Telcontar.valinor>
	<20140705122833.GA3573@bfoster.bfoster>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



On Saturday, 2014-07-05 at 08:28 -0400, Brian Foster wrote:
> On Fri, Jul 04, 2014 at 11:32:26PM +0200, Carlos E. R. wrote:


>> If I don't do that backup-format-restore, I get issues soon, and it crashes
>> within a day - I got after booting (the first event):
>>
>
> I echo Dave's previous question... within a day of doing what? Just
> using the system or doing more hibernation cycles?

It is in the long post with the logs I posted.

The first time it crashed, I rebooted, got some errors I probably did not 
see, managed to mount the device, and I used the machine normally, doing 
several hibernation cycles. On one of these, it crashed, within the day.


As explained in this part of the previous post:

>> 0.1> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857523] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 350 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_all
>>
>> And some hours later:
>>
>> <0.1> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298345] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_allo
>>
>>
>> It was here that I decided to backup-format-restore instead.





>>> That also means it's probably not be necessary to do a full backup,
>>> reformat and restore sequence as part of your routine here. xfs_repair
>>> should scour through all of the allocation metadata and yell if it finds
>>> something like free blocks allocated to a file.
>>
>> No, if I don't backup-format-restore it happens again within a day. There is
>> something lingering. Unless that was just chance... :-?
>>
>> It is true that during that day I hibernated several times more than needed
>> to see if it happened again - and it did.
>>
>
> This depends on what causes this to happen, not how frequent it happens.
> Does it continue to happen along with hibernation, or do you start
> seeing these kind of errors during normal use?


Except the first time that this happened, the sequence is this:

I use the machine for weeks, without event, booting once, then hibernating 
at least once per day. I finally reboot when I have to apply some 
system update, or something special.

Till one day, this "thing" happens. It happens inmediately after coming 
out from hibernation, and puts the affected partition, always /home, in 
read only mode. When it happens, I reboot, repair partition manually if 
needed, then I back up the files, format it, and replace all the files 
from the backup just made, with xfsdump. Well, this last time, I used 
rsync instead.


It has happened "only" four times:

2014-03-15 03:35:17
2014-03-15 22:20:34
2014-04-17 22:47:08
2014-06-29 12:32:18


> If the latter, that could suggest something broken on disk.

That was my first thought, because it started hapening after replacing the 
hard disk, but also after a kernel update. But I have tested that disk 
several times, with smartctl and with the manufacturer test tool, and 
nothing came out.


> If the
> former, that could simply suggest the fs (perhaps on-disk) has made it
> into some kind of state that makes this easier to reproduce, for
> whatever reason. It could be timing, location of metadata,
> fragmentation, or anything really for that matter, but it doesn't
> necessarily mean corruption (even though it doesn't rule it out).
> Perhaps the clean regeneration of everything by a from-scratch recovery
> simply makes this more difficult to reproduce until the fs naturally
> becomes more aged/fragmented, for example.
>
> This probably makes a pristine, pre-repair metadump of the reproducing
> fs more interesting. I could try some of my previous tests against a
> restore of that metadump.


Well, I suggest that, unless you can find something on the metadata (I 
just sent you the link via email from google), we wait till the next 
event. I will at that time take an intact metadata photo. But this can 
take a month or two to happen again, if the pattern keeps.




> I was somewhat thinking out loud originally discussing this topic. I was
> suggesting to run this against a restored metadump, not the primary
> dataset or a backup.
>
> The metadump creates an image of the metadata of the source fs in a file
> (no data is copied). This metadump image can be restored at will via
> 'xfs_mdrestore.' This allows restoring to a file, mounting the file
> loopback, and performing experiments or investigation on the fs
> generally as it existed when the shutdown was reproducible.

Ah... I see.


> So basically:
>
> - xfs_mdrestore <mdimgfile> <tmpfileimg>
> - mount <tmpfileimg> /mnt
> - rm -rf /mnt/*
>
> ... was what I was suggesting. <tmpfileimg> can be recreated from the
> metadump image afterwards to get back to square one.

I see.

Well, I tried this on a copy of the 'dd' image days ago, and nothing 
hapened. I guess the procedure above would be the same.





>> I have an active bugzilla account at <http://oss.sgi.com/bugzilla/>, I'm
>> logged in there now. I haven't checked if I can create a bug, not been sure
>> what parameters to use (product, component, whom to assign to). I think that
>> would be the most appropriate place.
>>
>> Meanwhile, I have uploaded the file to my google drive account, so I can
>> share it with anybody on request - ie, it is not public, I need to add a
>> gmail address to the list of people that can read the file.
>>
>> Alternatively, I could just email the file to people asking for it, offlist,
>> but not in a single email, in chunks limited to 1.5 MB per email.
>>
>
> Either of the bugzilla or google drive options works Ok for me.

It's here:

<https://drive.google.com/file/d/0Bx2OgfTa-XC9UDBnQzZIMTVyN0k/edit?usp=sharing>

Whoever wants to read it, has to tell me the address to add to it, access 
is not public.


- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlPAgb0ACgkQtTMYHG2NR9U/FQCgjtwuDC0HTSG3i7DrEV8+qZeT
6mUAn0FGf42SsU1WeRx/AAk4X2oqV4Bc
=pASJ
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
