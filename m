Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A1FC7F6C
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 13:39:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 074EB8F8033
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 11:39:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kyHThbhYm2EMsKVz for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 11:39:18 -0700 (PDT)
Message-ID: <5363E65C.6010006@sandeen.net>
Date: Fri, 02 May 2014 13:39:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363A1D8.2020402@gmail.com>
	<5363B4C9.4000900@sandeen.net>	<5363CB5E.3090008@gmail.com>
	<5363CD70.3000006@sandeen.net> <5363DBD7.4060002@gmail.com>
In-Reply-To: <5363DBD7.4060002@gmail.com>
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
To: Martin Papik <mp6058@gmail.com>, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/2/14, 12:54 PM, Martin Papik wrote:
> 
>> In the USB case when it comes back with a new name, as far as I
>> know there is no mechanism to handle that anywhere in the kernel.
> 
> Is there a mechanism for other devices?

to be honest, I'm not certain; if it came back under the same device
name, things may have continued.  I'm not sure.

In general, filesystems are not very happy with storage being yanked
out from under them.

>>> Is XFS is not stable enough to function without a need to reboot
>>> in case of a relatively minor HW failure? Minor meaning affecting
>>> only some disks.
> 
>> It's not a question of XFS stability, IMHO.  XFS was talking to
>> device A; device A went away and never came back.
> 
> Well, it kinda did come back, but that's different story.
> 
>> The issue of being unable to repair it seems to have been a result
>> of files still open on the (disappeared) device?  Once you resolved
>> that, all was well, and no reboot was needed, correct?
> 
> Yup, but xfs was still active without a trace in /proc/mounts, which
> what confused me.

I agree, it's confusing.

>> I suggested the reboot as a big-hammer fix to clear the mysterious
>> stale mount; turns out that was not required, apparently.
> 
> I don't like that particular hammer. Personal opinion, sure, but it
> seems to me that reboot is what you do when you don't know what went
> wrong or you know it's totally fubar. In this case, IMHO, not fubar.

Well, I did say that it was the simplest thing.  Not the best or
most informative thing.  :)

>> If ustat(device) was reporting that it's mounted, but
>> /proc/partitions didn't show it, then the device was in some kind
>> of limbo state, I guess, and that sort of umount handling is below
>> XFS (or any other filesystem), as far as I know.
> 
> I'm confused here. /dev/old was not in /proc/partitions or
> /proc/mounts, /dev/new was in /proc/partitions but not in
> /proc/mounts, even after disconnect and reconnect of the drive the
> /dev/new refused to be acted on by xfs_check or xfs_repair. How did
> that happen? All right, apparently there was a slate xfs instance in
> the kernel, not visible anywhere, but that was attached to /dev/old,
> why did xfs_repair fail to work on /dev/new until the stale xfs
> instance in the kernel finished shutting down.

Somewhere in the vfs, the filesystem was still present in a way that
the ustat syscall reported that it was mounted. xfs_repair uses this
syscall to determine mounted state.  It called sys_ustat, got an
answer of "it's mounted" and refused to continue. 

It refused to continue because running xfs_repair on a mounted filesystem
would lead to severe damage.

>> What initiated the unmount, was it you (after the USB disconnect)
>> or some udev magic?
> 
> The disconnect of the USB drive, specifically the internal HUB in the
> notebook failed (don't know how), I reset it from ssh (keyboard is
> also on the hub), see below, I didn't find any messages from any user
> space system, but they might not log everything, but there were
> messages about the XFS driver detecting the error, the USB hub being
> fubar-ed, the device being off-line, so I'm guessing it was the panic
> action, or maybe userspace. I'm not sure, I wasn't able to find out
> how XFS handles errors, there's nothing in the manual pages and google
> didn't help. Do you know? I.e. the equivalent of errors=remount_ro, or
> whatever. One page claimed xfs doesn't recognize this option. My
> system has the defaults and it's ubuntu/precise, if that helps.

If xfs encounters an insurmountable error, it will shut down, and all
operations will return EIO or EUCLEAN.  You are right that there is no
errors=* mount option; the behavior is not configurable on xfs.

You're right that this doesn't seem to be well described in documentation,
that's probably something we should address.

As for the root cause event; XFS on a yanked and re-plugged USB device
is not something that is heavily tested, to be honest, and it's something
that no filesystem handles particularly well, as far as I know.
(I know that ext4 has had some patches to at least make it a bit less
noisy...)

- -Eric

> Martin
> 
> 
> 
> 
> May  2 15:49:06 lennie kernel: [344344.325232] sd 11:0:0:0: rejecting
> I/O to offline device
> May  2 15:49:39 lennie kernel: [344377.367220] hub 2-1:1.0:
> hub_port_status failed (err = -110)
> May  2 15:49:44 lennie kernel: [344382.459545] hub 2-1:1.0:
> hub_port_status failed (err = -110)
> May  2 15:49:50 lennie kernel: [344387.551918] hub 2-1:1.0:
> hub_port_status failed (err = -110)
> May  2 15:49:50 lennie kernel: [344388.413611] sd 6:0:0:0: rejecting
> I/O to offline device
> May  2 15:49:50 lennie kernel: [344388.413650] sd 6:0:0:0: rejecting
> I/O to offline device
> May  2 15:49:50 lennie kernel: [344388.413668] sd 6:0:0:0: rejecting
> I/O to offline device
> May  2 15:49:52 lennie kernel: [344390.062780] sd 6:0:0:0: rejecting
> I/O to offline device
> May  2 15:49:52 lennie kernel: [344390.062837] ffff8801034da000: 80 ab
> 4d 03 01 88 ff ff 00 00 70 b4 f0 7f 00 00  ..M.......p.....
> May  2 15:49:52 lennie kernel: [344390.062844] XFS (sdb104): Internal
> error xfs_dir2_data_reada_verify at line 226 of file
> /build/buildd/linux-lts-raring-3.8.0/fs/xfs/xfs_dir2_data.c.
>  Caller 0xffffffffa079e33f
> May  2 15:49:52 lennie kernel: [344390.062844]
> May  2 15:49:52 lennie kernel: [344390.062852] Pid: 642, comm:
> kworker/0:1H Tainted: G         C   3.8.0-39-generic #57~precise1-Ubuntu
> May  2 15:49:52 lennie kernel: [344390.062854] Call Trace:
> May  2 15:49:52 lennie kernel: [344390.062902]  [<ffffffffa07a018f>]
> xfs_error_report+0x3f/0x50 [xfs]
> May  2 15:49:52 lennie kernel: [344390.062921]  [<ffffffffa079e33f>] ?
> xfs_buf_iodone_work+0x3f/0xa0 [xfs]
> May  2 15:49:52 lennie kernel: [344390.062939]  [<ffffffffa07a01fe>]
> xfs_corruption_error+0x5e/0x90 [xfs]
> May  2 15:49:52 lennie kernel: [344390.062966]  [<ffffffffa07da159>]
> xfs_dir2_data_reada_verify+0x59/0xa0 [xfs]
> May  2 15:49:52 lennie kernel: [344390.062986]  [<ffffffffa079e33f>] ?
> xfs_buf_iodone_work+0x3f/0xa0 [xfs]
> May  2 15:49:52 lennie kernel: [344390.062994]  [<ffffffff8108e54a>] ?
> finish_task_switch+0x4a/0xf0
> May  2 15:49:52 lennie kernel: [344390.063013]  [<ffffffffa079e33f>]
> xfs_buf_iodone_work+0x3f/0xa0 [xfs]
> May  2 15:49:52 lennie kernel: [344390.063019]  [<ffffffff81078de1>]
> process_one_work+0x141/0x4a0
> May  2 15:49:52 lennie kernel: [344390.063024]  [<ffffffff81079dd8>]
> worker_thread+0x168/0x410
> May  2 15:49:52 lennie kernel: [344390.063029]  [<ffffffff81079c70>] ?
> manage_workers+0x120/0x120
> May  2 15:49:52 lennie kernel: [344390.063034]  [<ffffffff8107f300>]
> kthread+0xc0/0xd0
> May  2 15:49:52 lennie kernel: [344390.063039]  [<ffffffff8107f240>] ?
> flush_kthread_worker+0xb0/0xb0
> May  2 15:49:52 lennie kernel: [344390.063046]  [<ffffffff816ff56c>]
> ret_from_fork+0x7c/0xb0
> May  2 15:49:52 lennie kernel: [344390.063050]  [<ffffffff8107f240>] ?
> flush_kthread_worker+0xb0/0xb0
> May  2 15:49:52 lennie kernel: [344390.063054] XFS (sdb104):
> Corruption detected. Unmount and run xfs_repair
> May  2 15:49:52 lennie kernel: [344390.067128] sd 6:0:0:0: rejecting
> I/O to offline device
> May  2 15:49:52 lennie kernel: [344390.067158] XFS (sdb104): metadata
> I/O error: block 0x8a6ec930 ("xfs_trans_read_buf_map") error 117 numblks 8
> May  2 15:49:52 lennie kernel: [344390.067179] ffff8801034da000: 80 ab
> 4d 03 01 88 ff ff 00 00 70 b4 f0 7f 00 00  ..M.......p.....
> May  2 15:49:52 lennie kernel: [344390.067184] XFS (sdb104): Internal
> error xfs_dir2_block_verify at line 71 of file
> /build/buildd/linux-lts-raring-3.8.0/fs/xfs/xfs_dir2_block.c.  Call
> er 0xffffffffa07d7f3e
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTY+ZbAAoJECCuFpLhPd7gtk8QAJ65zHJXtYtC/zGndfeok8en
5gbG5Ctgz3uZlMVL0/JGAlHGJDxGBS9YcHBNr/WJmC9VtRinQno/o4L0Z1nycWb/
kAMfDPRJyV4qfMSo8UQOXLovoA6p+neuF5pkVX9m2nmjM4CgQTmmCEEnmUkE78Yj
8lcy4xtWM6tlYVDS5LiNRplaATXJXuBZGL9glxqnxUwGy34/2z+YtcrBNUM0rRtN
VH1ws/ci9RwMWDWy7gfEzbJIQMRVUpHmNeC2PIlRVK130YpbwjqIoEpYOeyfBeVE
f8uSrGZVSEj4qEm5K72Ulx+GjbLCqhhIQcBDFmqwyhTxph+ARJd1ium3cUN9r6Ki
nbWHA0f2PG04E8a5O3pr0Kn61B6Y2a0fuzrMaGNG6dftJa7UPcknEQzRTk8+8dwE
uD1veinxP/w9vJjDL0pSbSz1T8sJGF5nCD4cszhN/iplYjf3R3EQXf4p6pDbGeSh
NUT97ysxjqbIBeZaM+pUkzPNfY9vjjCqbxUrimIGiOq3QzovILszvb1U7taIP7EI
5FF0a/NbYHvp+Ks8r6zst0HAxPQ6UMx5+1Yxi5zo23ROq3PKGz/t3zWi6zgYkfzO
08IIDiEBtD7M5CIv/mVsK9CX+5nFG6g2khYB6xlsLGYjxUZHw/TTRB+xpflI/qJi
Yg0LgqPOXkH36W08nJLG
=srIM
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
