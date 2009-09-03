Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n83FUu4l110900 for <xfs@oss.sgi.com>; Thu, 3 Sep 2009 10:31:12 -0500
Received: from mx1.empa.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC2D44227B5
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2009 08:31:40 -0700 (PDT)
Received: from mx1.empa.ch (mx1.empa.ch [152.88.7.31]) by cuda.sgi.com with
	ESMTP id lszcSeTBK7xhJNh6 for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2009 08:31:40 -0700 (PDT)
Received: from Du-Exc-Hub1.empa.emp-eaw.ch (localhost [127.0.0.1])
	by mx1.empa.ch (Spam & Virus Firewall) with ESMTP id DE782D41D7
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2009 17:31:36 +0200 (CEST)
Received: from Du-Exc-Hub1.empa.emp-eaw.ch ([152.88.6.64]) by mx1.empa.ch with
	ESMTP id dopY9lSjzOCFrisv for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2009 17:31:36 +0200 (CEST)
From: "Passerone, Daniele" <Daniele.Passerone@empa.ch>
Date: Thu, 3 Sep 2009 17:31:36 +0200
Subject: RE: xfs data loss
Message-ID: <B9A7B002C7FAFC469D4229539E909760308DA658CB@DU-EXC-MAIL.empa.emp-eaw.ch>
Content-Language: en-US
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Dear Peter, 

Thank you very much for the time spent in writing this long and 
interesting answer. Now I agree with you, that harsh and useful is better
than emollient and lying :-)


> When you write to a mailing list asking for free help and support,
> it is rather rude to not have done some preliminary work, such as
> figuring out the characterisics of RAID5 in case of failure. It
> is also somewhat rude (but amazingly common) to make confused and
> partial reports, such as not checking and reporting what has
> actually failed.

That is true. Unfortunately I am not the person who assembled the RAID5
and configured the machine, and I had to act mostly alone to figure out
what to do. That is why I eventually preferred to make a partial report.



> But a soft but more open assessment of how outrageous some queries
> are is help too as it makes it easier to assess the gravity of the
> situation. The smooth, emollient sell-side people will let you dig
> your own grave. Just consider your statement below about "assume
> clean" that to me sounds very dangerous (big euphemism), and that
> did not elicit any warning from the sell-side:


At the beginning of this week I was confronted with the following 
situation:

1) /dev/md4 a 19+1 RAID 5, with the corresponding xfs /raidmd4 filesystem
 that had lost half of the directories 
on the 24th of August; for NO PARTICULAR APPARENT REASON (and this still makes me crazy).
No logs, nothing. 

2) /dev/md5, a 19+1 RAID 5, that could not mount anymore...lost superblock.

3) /dev/md6 , a 4+1 RAID5, that was not mounting anymore because 2 devices were lost.
My collegue zapped the filesystem (which was almost empty), and rebuilt the RAID5. 
Unfortunately I cannot say exactly what he did.


For 2) it was clear what happened:
At the distance of a few days, two devices of /dev/md5 died. 
The information about the death of one device is issued in /var/log/warn.
We did not check it during the last days, so when the second device died, it was too late.

BUT: I followed the advice to make a read test on all devices (using dd) and all were ok.
So it seemed to be a raid controller  problem, of the same kind described here

http://maillists.uci.edu/mailman/public/uci-linux/2007-December/002225.html

where a solution is proposed including the reassembling of the raid using mdadm with the option 
"assume-clean". This is where this "assume-clean" comes from: from a read test, followed by 
the study of the above mailing list post.


The resync of the /dev/md5 was performed, the raid was again with 20 working devices, 
but at the end of the day the filesystem still was not able to mount.
So, I was eventually forced to do xfs_repair -L /dev/md5, which was a nightmare:
incredible number of forking, inodes cleared... but eventually... successful.
I was in the meanwhile 10 years older and with all my hair suddenly greyed, but...

RESULT: /dev/md5 is again up and running, with all data.

BUT  at the same time, /dev/md4 was not able to mount anymore: superblock error.

So, at that point we bought another big drive (7 TB), we performed backup of /dev/md5 ,
and then we run the same procedure on /dev/md4. 

RESULT: /dev/md4 is again up and running, but the data disappeared on August 24 were still missing.


Since the structure was including all devices, at this point I run xfs_repair -L /dev/md4. But nothing happens.
No error, and half of the data still missing.

So at this point I don't understand. 

THERE IS ONE IMPORTANT THING THAT I DID NOT MENTION, BECAUSE IT WAS NOT EVIDENT BY LOOKING AT /etc/raidtab, 
/proc/mdstat, etc., and it was done by my collaborator

All structure of the raids, partitioning etc. was done using Yast2 with LVM.
The use of LVM is a mistery to me, even more than the basic of the RAID ( :-) )
The /etc/lvm/backup and archive directories are empty.
In yast2 now the LVM panel is empty, and I have forbidden my collaborator to try to go through LVM now...


Coming to other specific questions:

>Sure you can reassemble the RAID, but what do you mean by "still
>ok"? Have you read-tested those 2 drives? Have you tested the
>*other* 18 drives? How do you know none of the other 18 drives got
>damaged? Have you verified that only the host adapter electronics
>failed or whatever it was that made those 2 drives drop out?

Tested all drives, but not the host adapter electronics.


>Why do you *need* to assume clean? If the 2 "lost" drives are
>really ok, you just resync the array. 

Well, following the post above, after checking that the lost drives are ok, 
first I stop the raid, then I create the raid with 20 drives assuming them clean, 
then I stop it again, then assemble it with resyncing.

>If you *need* to assume
>clean, it is likely that you have lost something like 5% of data
>in (every stripe and thus) most files and directories (and
>internal metadata) and will be replacing it with random
>bytes. That will very likely cause XFS problems (the least of the
>problems of course).


On the /raidmd5 fortunately this was not the case.



>Especially in a place where part of the everyday
>activity is earthquake simulation...

LOL you are right.


> But apart from that, it is not as easy to backup 20 TB,

>Or to 'fsck' several TB as you also discovered. Anyhow my opinion
>is that the best way to backup large storage servers is another
>large storage server (or more than one). When I buy a hard drive I
>buy 3 backup drives for each "live" drive I use -- at *home*.

At least now, we did at least that right.


>Not at all absurd -- if those users *really* accept that. But you
>are trying to recover the arrays instead of scratching them and
>restarting. That suggests to me that the users did not actually
>accept that. If the real agreement with the users is "you have to
>keep backups, but if something happens you will behave as if you
>cannot or don't want to restore them" it is quite different.


Well. You would be surprised to know how stupid can scientist be when 
they ignore the worst case scenario. 
Including myself.
I knew exactly the situation, but if I had not succeeded in recovering 
/raid/md5, it would have been a hard moment for me and my research group.
And we ALL knew that there were no backups.



>That's not so clear. One problem with trying to provide some
>opinions on your issue and whether the filesystems are recoverable
>is that you haven't made clear what failed and how you tested each
>component of each array to make sure that what is still working is
>known (and talk of "assume clean" is very suspicious).

Just to clarify: assume-clean was an option to the mdadm --create command
when I discovered that my 20 devices were there and running: I run a dd command
reading the first megabytes of each device.
Was this wrong?

>That you have tried to run repair tools on a filesystem with an
>incomplete storage layer may have made things rather worse, so
>knowing *exactly* what has failed may help you a lot.

I will contact the Sun service and ask them to check the whole storage-controller part.
In the meanwhile I am almost convinced that that 4-5 TB lost on /dev/md4 are lost for good.
I sent the metadata one week ago to the mailing list. Do you think this could help in examining
the famous 20 drives?

I hope I could catch up. I am trying to learn quickly.

Thanks,

Daniele

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
