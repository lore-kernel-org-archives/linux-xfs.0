Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD3547F50
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 20:35:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4EDB8AC005
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 18:35:37 -0800 (PST)
Received: from mail-yh0-f46.google.com (mail-yh0-f46.google.com
	[209.85.213.46]) by cuda.sgi.com with ESMTP id zaYW3LdaoGMB65pt
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Jan 2015 18:35:34 -0800 (PST)
Received: by mail-yh0-f46.google.com with SMTP id t59so233459yho.19
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 18:35:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOFq7B5HnEZFtVvoRORRwOxPhx5Txf9xJW=BG6GFbLMNk+_CEw@mail.gmail.com>
References: <CAOFq7B5PaPCJdAxyYa6feCXgGbkz+1Qs+Gfb2WG=5af=A+WOQg@mail.gmail.com>
	<44b127de199c445fa12c3b832a05f108@000s-ex-hub-qs1.unimelb.edu.au>
	<CAOFq7B5HnEZFtVvoRORRwOxPhx5Txf9xJW=BG6GFbLMNk+_CEw@mail.gmail.com>
Date: Tue, 6 Jan 2015 19:35:34 -0700
Message-ID: <CAJCQCtS1p080M9dvuAJWBoafCcoOo2SaVLEhdVQV6QA8RC54cA@mail.gmail.com>
Subject: Re: XFS corrupt after RAID failure and resync
From: Chris Murphy <lists@colorremedies.com>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jan 6, 2015 at 1:34 PM, David Raffelt
<david.raffelt@florey.edu.au> wrote:
> Hi Brian and Stefan,
> Thanks for your reply.  I checked the status of the array after the rebuild
> (and before the reset).
>
> md0 : active raid6 sdd1[8] sdc1[4] sda1[3] sdb1[7] sdi1[5] sde1[1]
>       14650667520 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6]
> [UUUUUU_]
>
> However given that I've never had any problems before with mdadm rebuilds I
> did not think to check the data before rebooting.  Note that the array is
> still in this state. Before the reboot I tried to run a smartctl check on
> the failed drives and it could not read them. When I rebooted I did not
> actually replace any drives, I just power cycled to see if I could re-access
> the drives that were thrown out of the array. According to smartctl they are
> completely fine.
>
> I guess there is no way I can re-add the old drives and remove the newly
> synced drive?  Even though I immediately kicked all users off the system
> when I got the mdadm alert, it's possible a small amount of data was written
> to the array during the resync.

Well it sounds like there's more than one possibility here. If I
follow correctly, you definitely had a working degraded 5/7 drive
array, correct? In which case at least it should be possible to get
that back, but I don't know what was happening at the time the system
hung up on poweroff.

It's not rare for smart to not test for certain failure vectors so it
might say the drive is fine when it isn't. But what you should do next
is

mdadm -Evv /dev/sd[abcdefg]1   ##use actual drive letters

Are you able to get information on all seven drives? Or do you
definitely have at least one drive failed?

If the event counter from the above examine is the same for at least 5
drives, you should be able to assemble the array with this command:

mdadm --assemble --verbose /dev/mdX /dev/sd[bcdef]1

You have to feed the drive letter designation with the right letters
for drives with the same event counter. If that's 5 drives, use that.
If it's 6 drives, use that. If the event counters are all off, then
it's a matter of what they are so you may just post the event counters
so we can see this. This isn't going to write anything to the array,
the fs isn't mounted. So if it fails, nothing is worse off. If it
works, then you can run xfs_repair -n and see if you get a sane
result. If that works you can mount it in this degraded state and
maybe extract some of the more important data before proceeding to the
next step.

In the meantime I'm also curious about:

smarctl -l scterc /dev/sdX

This has to be issued per drive, no shortcut available by specifying
all letters at once in brackets. And then lastly this one:

cat /sys/block/sd[abcdefg]/device/timeout

Again plug in the correct letters.



> Unfortunately this 15TB RAID was part of a 45TB GlusterFS distributed
> volume. It was only ever meant to be a scratch drive for intermediate
> scientific results, however inevitably most users used it to store lots of
> data. Oh well.

Right well it's not fore sure toast yet. Also, one of the things
gluster is intended to mitigate is the loss of an entire brick, which
is what happened, but you need another 15TB of space to do
distributed-replicated on your scratch space. If you can tolerate
upwards of 48 hour single disk rebuild times, there are now 8TB HGST
Helium drives :-P


-- 
Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
