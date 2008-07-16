Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jul 2008 01:54:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6G8s74A017765
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 01:54:09 -0700
Message-ID: <487DB76E.3070300@sgi.com>
Date: Wed, 16 Jul 2008 18:55:10 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Is it possible the check an frozen XFS filesytem to avoid downtime
References: <200807141542.51613.ms@teamix.de> <487C1BAF.2030404@sgi.com> <200807150944.13277.ms@teamix.de>
In-Reply-To: <200807150944.13277.ms@teamix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <ms@teamix.de>
Cc: xfs@oss.sgi.com

Martin Steigerwald wrote:
> Am Dienstag, 15. Juli 2008 05:38:23 schrieb Timothy Shimmin:
>> Hi Martin,
> 
> Hi Tim,
> 
>> Martin Steigerwald wrote:
>>> Hi!
>>>
>>> We seen in-memory corruption on two XFS filesystem on a server heartbeat
>>> cluster of one of our customers:
>>>
>>>
>>> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 1563 of file
>>> fs/xfs/xfs_alloc.c.  Caller 0xffffffff8824eb5d
>>>
>>> Call Trace:
>>>  [<ffffffff8824cff3>] :xfs:xfs_free_ag_extent+0x1a6/0x6b5
>>>  [<ffffffff8824eb5d>] :xfs:xfs_free_extent+0xa9/0xc9
>>>  [<ffffffff88258636>] :xfs:xfs_bmap_finish+0xf0/0x169
>>>  [<ffffffff88278b4c>] :xfs:xfs_itruncate_finish+0x180/0x2c1
>>>  [<ffffffff8829071a>] :xfs:xfs_setattr+0x841/0xe59
>>>  [<ffffffff8022e868>] sock_common_recvmsg+0x30/0x45
>>>  [<ffffffff8829adc8>] :xfs:xfs_vn_setattr+0x121/0x144
>>>  [<ffffffff8022a06d>] notify_change+0x156/0x2ef
>>>  [<ffffffff883bf9c6>] :nfsd:nfsd_setattr+0x334/0x4b1
>>>  [<ffffffff883c61d6>] :nfsd:nfsd3_proc_setattr+0xa2/0xae
>>>  [<ffffffff883bb24d>] :nfsd:nfsd_dispatch+0xdd/0x19e
>>>  [<ffffffff8833a10e>] :sunrpc:svc_process+0x3cb/0x6d9
>>>  [<ffffffff8025b20b>] __down_read+0x12/0x9a
>>>  [<ffffffff883bb816>] :nfsd:nfsd+0x192/0x2b0
>>>  [<ffffffff80255f38>] child_rip+0xa/0x12
>>>  [<ffffffff883bb684>] :nfsd:nfsd+0x0/0x2b0
>>>  [<ffffffff80255f2e>] child_rip+0x0/0x12
>>>
>>> xfs_force_shutdown(dm-1,0x8) called from line 4261 of file
>>> fs/xfs/xfs_bmap.c. Return address = 0xffffffff88258673
>>> Filesystem "dm-1": Corruption of in-memory data detected.  Shutting down
>>> filesystem: dm-1
>>> Please umount the filesystem, and rectify the problem(s)
>>>
>>> on
>>>
>>> Linux version 2.6.21-1-amd64 (Debian 2.6.21-4~bpo.1)
>>> (nobse@backports.org) (gcc version 4.1.2 20061115 (prerelease) (Debian
>>> 4.1.1-21)) #1 SMP Tue Jun 5 07:43:32 UTC 2007
>>>
>>>
>>> We plan to do a takeover so that the server which appears to have memory
>>> errors can be memtested.
>>>
>>> After the takeover we would like to make sure that the XFS filesystems
>>> are intact. Is it possible to do so without taking the filesystem
>>> completely offline?
>>>
>>> I thought about mounting read only and it might be the best choice
>>> available, but then it will *fail* write accesses. I would prefer if
>>> these are just stalled.
>>>
>>> I tried xfs_freeze -f on my laptop home directory, but then did not
>>> machine to get it check via xfs_check or xfs_repair -nd... is it possible
>>> at all?
>>>
>>> Ciao,
>> When I last tried (and I don't think Barry has done anything to it to
>> change things) it wouldn't work.
>> However, I think it could/should be changed to make it work.
> 
> Okay... we recommended the customer to do it the safe way unmounting the 
> filesystem completely. He did and the filesystem appear to be intact *phew*. 
> XFS appeared to detect the in memory corruption early enough.
> 
> Its a bit strange however, cause we now know that the server sports ECC RAM. 
> Well we will see what memtest86+ has to say about it.
> 
>> My notes from the SGI bug:
>>
>> 958642: running xfs_check and "xfs_repair -n" on a frozen xfs filesystem
>>
>>> We've been asked a few times about the possibility of running xfs_check
>>> or xfs_repair -n on a frozen filesystem.
>>> And a while back I looked into what some of the hinderances were.
>>> And now I've forgotten ;-))
>>>
>>> I think there are hinderances for libxfs_init (check_open()) and
>>> for having a dirty log.
>>>
>>> For libxfs_init, I found that I couldn't run the tools without error'ing
>>> out. I think I found out that I needed the INACTIVE flag,
>>> without READONLY/DANGEROUSLY, like xfs_logprint does.
>>>
>>> ----------------------------------------
>>> Date: Thu, 19 Oct 2006 11:24:06 +1000
>>> From: Timothy Shimmin <tes@sgi.com>
>>> To: lachlan@sgi.com
>>> cc: xfs-dev@sgi.com
>>>   It means if I do _not_ want to be fatal then I need to set INACTIVE but
>>> not set READONLY or DANGEROUSLY - which is what logprint does.
>>>
> 
> I think that there should be different options for readonly / frozen fs 
> checking and dangerous repair... since I think readonly checks are a 
> different thing than repairing a mounted filesystem and hoping that the 
> running XFS will not choke upon the filesystem that xfs_repair changes under 
> its hood.
> 
> I expected a "-r" for read only in xfs_check and xfs_repair, well but for 
> xfs_repair this option is already taken for specifying the realtime volume.
> 
> Ciao,


My comments mentioned above were for the c flags used in
libxfs and the commands.
I was curious to know why logprint was able to continue printing and doing
its stuff but repair and check couldn't and would exit.
What actual _command_ options/flags we use is a different matter and I probably
confused the issue by using the term flags.

Looking at the code:

#define LIBXFS_ISREADONLY       0x0002  /* disallow all mounted filesystems */
#define LIBXFS_ISINACTIVE       0x0004  /* allow mounted only if mounted ro */
#define LIBXFS_DANGEROUSLY      0x0008  /* repairing a device mounted ro    */


       -n     No modify mode.  Specifies that xfs_repair should not modify the
              filesystem but should only scan the filesystem and indicate what
              repairs would have been made.

       -d     Repair dangerously. Allow xfs_repair to repair an XFS filesystem
              mounted read only. This is typically done on  a  root  fileystem
              from single user mode, immediately followed by a reboot.

        if (no_modify) /* -n */
                args->isreadonly = (LIBXFS_ISREADONLY  | LIBXFS_ISINACTIVE);
        else if (dangerously) /* -d */
                args->isreadonly = (LIBXFS_DANGEROUSLY | LIBXFS_ISINACTIVE);

The comment for LIBXFS_ISINACTIVE seems a bit misleading as I believe
it will allow things to continue on a filesystem which is not marked
as readonly as xfs_logprint does.

Looking at:

init.c:	
        if (!readonly && !inactive && platform_check_ismounted(path, *blockfile, NULL, 1))
                return 0;
        
        if (inactive && check_isactive(path, *blockfile, ((readonly|dangerously)?1:0)))
                return 0; 

static int
check_isactive(char *name, char *block, int fatal)
{      
....
        return platform_check_iswritable(name, block, &st, fatal);
}

Okay, so this is why it worked fine for just ISINACTIVE but not when
either ISREADONLY or DANGEROUSLY are set.

Yes, it would be nice for the commands to detect that the filesystem is
frozen and then allow things to proceed in a non modifying mode.

--Tim
