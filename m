Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 914BF29DF8
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 18:35:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0DC4FAC001
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 16:35:02 -0700 (PDT)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id e0GVx4mAIYOhFOqM
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Jul 2014 16:34:58 -0700 (PDT)
Received: by mail-wg0-f50.google.com with SMTP id m15so907714wgh.21
	for <xfs@oss.sgi.com>; Thu, 03 Jul 2014 16:34:56 -0700 (PDT)
Received: from Telcontar.valinor (90.Red-79-150-228.dynamicIP.rima-tde.net.
	[79.150.228.90]) by mx.google.com with ESMTPSA id
	fn1sm72308562wib.18.2014.07.03.16.34.55 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Thu, 03 Jul 2014 16:34:56 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 6556C60E0E
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 01:34:53 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id JnWaJ_mD4-JW for <xfs@oss.sgi.com>;
	Fri,  4 Jul 2014 01:34:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 36E9060D9B
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 01:34:52 +0200 (CEST)
Date: Fri, 4 Jul 2014 01:34:52 +0200 (CEST)
From: "Carlos E. R." <carlos.e.r@opensuse.org>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
In-Reply-To: <20140703094347.GU4453@dastard>
Message-ID: <alpine.LSU.2.11.1407040113340.9881@Telcontar.valinor>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
	<20140703094347.GU4453@dastard>
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



On Thursday, 2014-07-03 at 19:43 +1000, Dave Chinner wrote:
> On Thu, Jul 03, 2014 at 05:00:47AM +0200, Carlos E. R. wrote:
>> On Wednesday, 2014-07-02 at 08:04 -0400, Brian Foster wrote:
>>> On Wed, Jul 02, 2014 at 11:57:25AM +0200, Carlos E. R. wrote:
>>
>> ...

>> hibernated at least once a day, perhaps three times if I have to go
>> out several times. It makes no sense to me to leave the machine
>> powered doing nothing, if hibernating is so easy and reliable - till
>> now. If I have to leave for more than a week, I tend to do a full
>> "halt".
>
> Hibernation has always been suspect w.r.t. flushing filesystem
> metadata. It does not guarantee that the filesystem is quiesced
> and idle, it just does a sync() and hopes that is sufficient to get
> the filesystem into a consistent state. The mess that this leaves is
> then left to filesystem developers to play whack-a-mole with when
> users have problems.


Ah, but my problem would then not happen always on the same partition. It 
would affect others, would not?




>> But soon after, it oopses:
>
> Point of note: there is no oops or crash occurring. XFS dumps the
> stack when a corruption occurs to tell use where it was detected
> and then shuts down the filesystem. Your system is still just fine
> apart from not being able to access that filesystem until you
> unmount it, rpeair it and mount it again.

Ok, true, there is no formal "Oops".

But no, the system does not remains fine, I had to hit the hardware reset 
or power off button to get out.



>> 3 PID: 57 Comm: kworker/3:1 Tainted: P           O 3.11.10-7-desktop
>
> What's tainting your kernel? If you remove that taint, does the
> problem still occur?

Sorry, I can't find that out. It is either the nvidia driver, or the 
vmware kernel module. I can temporarily remove it for some days, but 
hardly for a month. I agree that it might have unknown influence on the 
initial corruption, but not on doing the repair, which I do in text mode, 
or with another boot partition that doesn't have that driver.

That is, it would not have influence on "xfs_repair", when done on a non 
tainted system.


I don't know of a way to provoking the problem at will, in order to remove 
the taint for a brief period :-?


>> <0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.081655] Restarting kernel threads ... done.
>> <0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.086714] Restarting tasks ... done.
> .....
>> <0.1> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.851374] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c54fe9
>
> So the corruption occurred within 2s of the kernel restarting tasks
> after a hibernation. It's really looking like a hibernation issue.

It's got to be related, of course.



>> Question.
>>
>> As this always happens on recovery from hibernation, and seeing the message
>> "Corruption of in-memory data detected", could it be that thawing does a bad
>> memory recovery from the swap?  I thought that the procedure includes some
>> checksum, but I don't know for sure.
>
> It's the fact that the filesystem si still running and modifying
> state when the snapshot is being taken that results in the snapshot
> image containing an inconsistent snapshot. That then gets loaded
> on thaw and it goes boom.

But it only happens on the /home partition, not on the email partition, 
for instance, also in the same hard disk.

Unless... there are probably more things writing on the home partition 
than on the mail partition any time.



>> To me, there are two problems:
>>
>>  1) The corruption itself.
>>  2) That xfs_repair fails to repair the filesystem. In fact, I believe
>>     it does not detect it!
>
> That's because the filesystem is likely to be consistent on disk.
> The issue is in-memory corruption, not on-disk corruption, like
> the messages are telling us:

No, the on disk filesystem is not healthy. If I continue using it, after 
reboot and using "xfs_repair" several times, it fails again within a day.

I got after booting (the first event):

0.1> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857523] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 350 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_all


And some hours later:

<0.1> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298345] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_allo


So, instead of using xfs_repair, I re-formatted and restored backup, which 
worked for a month till next event.



- -- 
Cheers,
        Carlos E. R.
        (from 13.1 x86_64 "Bottle" at Telcontar)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlO16JwACgkQtTMYHG2NR9VmzQCdHaeuKC3UkLWWzHRewx7wTC/N
zKAAn3VKi2bBYLrUA4edokFQ8RWXGm5z
=F5YK
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
