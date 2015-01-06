Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 98C177F50
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 06:41:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 843D88F8033
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 04:41:12 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WTbt2XVDrcC1sDXo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 04:41:11 -0800 (PST)
Date: Tue, 6 Jan 2015 07:41:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS corrupt after RAID failure and resync
Message-ID: <20150106124100.GB5874@bfoster.bfoster>
References: <CAOFq7B6eqEpGN2gcON-D63ZRf7AEabe2V_4q7jECZHk0t4etJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOFq7B6eqEpGN2gcON-D63ZRf7AEabe2V_4q7jECZHk0t4etJQ@mail.gmail.com>
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
To: David Raffelt <david.raffelt@florey.edu.au>
Cc: xfs@oss.sgi.com

On Tue, Jan 06, 2015 at 04:39:19PM +1100, David Raffelt wrote:
> Hi All,
> 
> I have 7 drives in a RAID6 configuration with a XFS partition (running Arch
> linux). Recently two drives dropped out simultaneously, and a hot spare
> immediately synced successfully so that I now have 6/7 drives up in the
> array.
> 

So at this point the fs was verified to be coherent/accessible?

> After a reboot (to replace the faulty drives) the XFS file system would not
> mount. Note that I had to perform a hard reboot since the server hung on
> shutdown. When I try to mount I get the following error:
> mount: mount /dev/md0 on /export/data failed: Structure needs cleaning

Hmm, seems like something associated with the array went wrong here. Do
you recall any errors before you hard reset? What happened when the
array was put back together after the reset?

Do you have anything more descriptive in the log or dmesg on the failed
mount attempt after the box rebooted?

> 
> I have tried to perform: xfs_repair /dev/md0
> And I get the following output:
> 
> Phase 1 - find and verify superblock...
> couldn't verify primary superblock - bad magic number !!!
> attempting to find secondary superblock...
> ..............................................................................
> ..............................................................................
>                           [many lines like this]
> ..............................................................................
> ..............................................................................
> found candidate secondary superblock...unable to verify superblock,
> continuing
> ...
> ...........................................................................
> 
> Note that it has been scanning for many hours and has located several
> secondary superblocks with the same error. It is till scanning however
> based on other posts I'm guessing it will not be successful.
> 

This is behavior I would expect if the array was borked (e.g., drives
misordered or something of that nature). Is the array in a sane state
when you attempted this (e.g., what does mdadm show for the state of the
various drives)? It is strange that it complains about the magic number
given the output below.

> To investigate the superblock info I used xfs_db and the magic number looks
> ok:
> sudo xfs_db /dev/md0
> xfs_db> sb
> xfs_db> p
> 
> magicnum = 0x58465342
> blocksize = 4096
> dblocks = 3662666880
> rblocks = 0
> rextents = 0
> uuid = e74e5814-3e0f-4cd1-9a68-65d9df8a373f
> logstart = 2147483655
> rootino = 1024
> rbmino = 1025
> rsumino = 1026
> rextsize = 1
> agblocks = 114458368
> agcount = 32
> rbmblocks = 0
> logblocks = 521728
> versionnum = 0xbdb4
> sectsize = 4096
> inodesize = 512
> inopblock = 8
> fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
> blocklog = 12
> sectlog = 12
> inodelog = 9
> inopblog = 3
> agblklog = 27
> rextslog = 0
> inprogress = 0
> imax_pct = 5
> icount = 4629568
> ifree = 34177
> fdblocks = 362013500
> frextents = 0
> uquotino = 0
> gquotino = null
> qflags = 0
> flags = 0
> shared_vn = 0
> inoalignmt = 2
> unit = 128
> width = 640
> dirblklog = 0
> logsectlog = 12
> logsectsize = 4096
> logsunit = 4096
> features2 = 0xa
> bad_features2 = 0xa
> features_compat = 0
> features_ro_compat = 0
> features_incompat = 0
> features_log_incompat = 0
> crc = 0 (unchecked)
> pquotino = 0
> lsn = 0
> 
> 
> Any help or suggestions at this point would be much appreciated!  Is my
> only option to try a repair -L?
> 

Repair probably would have complained about a dirty log above if -L was
necessary. Did you run with '-n?' Are you aware of whether the fs was
cleanly unmounted before you performed the hard reset?

Brian

> Thanks in advance,
> Dave

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
