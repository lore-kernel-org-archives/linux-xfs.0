Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC9B029DF8
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 21:42:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 99E6E304051
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 19:42:51 -0700 (PDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
	[209.85.212.171]) by cuda.sgi.com with ESMTP id
	YBlWDVqIvd8OQnRl (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 19:42:49 -0700 (PDT)
Received: by mail-wi0-f171.google.com with SMTP id n15so12359303wiw.16
	for <xfs@oss.sgi.com>; Thu, 03 Jul 2014 19:42:48 -0700 (PDT)
Received: from Telcontar.valinor (90.Red-79-150-228.dynamicIP.rima-tde.net.
	[79.150.228.90]) by mx.google.com with ESMTPSA id
	pq9sm65859103wjc.35.2014.07.03.19.42.46 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Thu, 03 Jul 2014 19:42:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 3AD0460E0E
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 04:42:45 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id hSXoqrRhZp0X for <xfs@oss.sgi.com>;
	Fri,  4 Jul 2014 04:42:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 1367060D9B
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 04:42:44 +0200 (CEST)
Date: Fri, 4 Jul 2014 04:42:44 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
In-Reply-To: <20140704014008.GI9508@dastard>
Message-ID: <alpine.LSU.2.11.1407040415400.9881@Telcontar.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
	<20140703094347.GU4453@dastard>
	<alpine.LSU.2.11.1407040113340.9881@Telcontar.valinor>
	<20140704000426.GX4453@dastard>
	<alpine.LSU.2.11.1407040317120.9881@Telcontar.valinor>
	<20140704014008.GI9508@dastard>
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



On Friday, 2014-07-04 at 11:40 +1000, Dave Chinner wrote:

> On Fri, Jul 04, 2014 at 03:29:31AM +0200, Carlos E. R. wrote:

>> No, it is not. Root is separate and using ext4. The problematic one
>> is /home.
>>
>>
>> What I did, as far I remember, was, when I noticed that home had
>> failed and was read only, to switch to runlevel 1, umount /home
>> (killing the apps that were still using it), then tried to mount it
>> again to replay the log, prior to using xfs-repair on it. Mount
>> hung. ctrl-alt-supr failed, or appeared to fail. So reset button...
>
> That's a completely different issue to having a shutdown filesystem
> hang your system. That's a mount problem, and likely a known issue.
> You need to be specific when describing a problem, otherwise we
> waste time going down the wrong paths.

Sorry for the misunderstanding.

But halt/reboot did hung, even if it was after a failed mount. I was 
trying to recover the system, remember, and I'm trying to remember what 
exactly I did do, from memory, not written records.

>>>> No, the on disk filesystem is not healthy. If I continue using it,
>>>> after reboot and using "xfs_repair" several times, it fails again
>>>> within a day.
>>>
>>> After at least one hibernation and thaw cycle, right?
>>
>> Yes. 3, I think.
>
> Then hibernation has caused the corruption. It may take some time
> for the corruption to be detected, but there isn't any doubt in my
> mind that hibernation is the cause of your problems.

Wait.

The sequence was:

   healthy system
   several hibernation cycles.
   failure on come back from hibernation, with kernel error: XFS_WANT_CORRUPTED_GOTO.

   reboot - kernel error messages: XFS_WANT_CORRUPTED_RETURN, which I probably did not see.
   repair filesytem
   several hibernation cycles during some hours.
   failure on come back from hibernation, with kernel error: XFS_WANT_CORRUPTED_GOTO


See that there were kernel error messages right after rebooting, which I 
think I did not see at the time, because had I seen them I would have 
rebooted again, and I did not.


- From the log, already posted:

   <0.5> 2014-03-15 03:49:42 Telcontar kernel - - - [   19.173599] XFS (sdd5): Mounting Filesystem
   <0.5> 2014-03-15 03:49:42 Telcontar kernel - - - [   19.377918] XFS (sdd5): Starting recovery (logdev: internal)
   <0.5> 2014-03-15 03:49:42 Telcontar kernel - - - [   19.747914] XFS (sdd5): Ending recovery (logdev: internal)

   <3.6> 2014-03-15 03:53:01 Telcontar systemd 4987 - -  Starting Default.
   <3.6> 2014-03-15 03:53:01 Telcontar systemd 4987 - -  Reached target Default.
   <3.6> 2014-03-15 03:53:01 Telcontar systemd 4987 - -  Startup finished in 57ms.
   <3.6> 2014-03-15 03:53:01 Telcontar systemd 1 - -  Started User Manager for 9.
   <0.1> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857523] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 350 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_all



Then I think I run xfs-repair, which did not complain, and I continued 
working. Within the day, after 3 hibernations, it failed again with 
XFS_WANT_CORRUPTED_GOTO, and I decided I had to reboot, backup, reformat, 
restore.




> So, until we have kernel fixes, you'd do best to turn off
> hibernation. If you can't live with leaving your machine powered up
> or switching it off, then use suspend-to-ram rather than
> suspend-to-disk to avoid the problematic snapshot/restore
> situation....

Impossible... this is a desktop, not a laptop. Suspend to ram is high 
risk, even if it works (which I think it doesn't).

If the failure is unavoidable, I'll reformat the partition as ext4 
instead... which I do not like, but such is life.


But before that, I'll try upgrade xfsprogs.


- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlO2FKQACgkQtTMYHG2NR9USxgCeOdJeJORl2JpnsnhqtXDj2ZCL
3IIAniMFd9X+ETWr3gVPHYq7SFwIPKSt
=WPe7
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
