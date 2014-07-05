Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C2F8B7F56
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2014 07:28:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9A3958F8040
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2014 05:28:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id G8WaPFzhZCsZdctL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 05 Jul 2014 05:28:38 -0700 (PDT)
Date: Sat, 5 Jul 2014 08:28:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
Message-ID: <20140705122833.GA3573@bfoster.bfoster>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
	<20140703173916.GB3452@laptop.bfoster>
	<alpine.LSU.2.11.1407040135140.9881@Telcontar.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1407040135140.9881@Telcontar.valinor>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Fri, Jul 04, 2014 at 11:32:26PM +0200, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
> 
> [This email has been delayed, while I thought about where to upload metadata
> file - see near the end]
> 
> 
> On Thursday, 2014-07-03 at 13:39 -0400, Brian Foster wrote:
> >On Thu, Jul 03, 2014 at 05:00:47AM +0200, Carlos E. R. wrote:
> 
> 
> >Ok, so there's a lot going on. I was mainly curious to see what was
> >causing lingering preallocations, but it could be anything extending a
> >file multiple times.
> 
> Right.
> 
> 
> >>AFAIK, xfsdump can not carry over a filesystem corruption, right?
> >
> >I think that's accurate, though it might complain/fail in the act of
> >dumping an fs that is corrupted. The behavior here suggests there might
> >not be on disk corruption, however.
> 
> At least, not a detectable one.
> 
> If I don't do that backup-format-restore, I get issues soon, and it crashes
> within a day - I got after booting (the first event):
> 

I echo Dave's previous question... within a day of doing what? Just
using the system or doing more hibernation cycles?

> 0.1> 2014-03-15 03:53:47 Telcontar kernel - - - [  301.857523] XFS: Internal error XFS_WANT_CORRUPTED_RETURN at line 350 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_all
> 
> And some hours later:
> 
> <0.1> 2014-03-15 22:20:34 Telcontar kernel - - - [20151.298345] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_allo
> 
> 
> It was here that I decided to backup-format-restore instead.
> 
> 
> >>Maybe next time I can take the photo with dd before doing anything else (it
> >>takes about 80 minutes), or simply do an "xfs_metadump", which should be
> >>faster.  And I might not have then 500 GiB of free space to make a dd copy,
> >>anyway.
> >>
> >
> >xfs_metadump should be faster. It will grab the metadata only and
> >obfuscate filenames so as to hide sensitive information.
> 
> 
> Ok, I have a post-it label on the monitor so that I remember - my notes are
> typically stored in the home partition :-)
> 
> 
> But the obfuscation is not complete, I can recognize file names:
> 
> 
> 00008DC0   .leeme.kfPTgt . ....... .2aujzfJ.%;u. .   .0...
> 00008DF0    .pepe_after_gnome.tar.bz2.vcTJ8c.@.. . .......
> 00008E20   .amyN3xYjaldFXYpeUry. 3;&.K.. ..  .0... !.pepe_j
> 00008E50   ust_created.tar.bz2.JlyD0W .. .@....... .NGb0URO
> 00008E80   C0Bh9cHwp-hBh.6wMS .. .p  . ... ..registro.0DPzS
> 00008EB0   G  .. . ....... .8n-.w$.9. .. .   .8... +.suse_u
> 00008EE0   pgrade_to_102_pkglist-bis.txt.tcFUKq. . .......
> 00008F10   #B-XqcrWP4cqsw77yv8UsYbcCa-D76q..(#.. ..  .8...
> 00008F40   '.suse_upgrade_to_102_pkglist.txt.0KTuDa  7.. .8
> 
> 
> I just had a quick look with 'mc', the dump is to large too inspect it all.
> 
> 
> >>Question.
> >>
> >>As this always happens on recovery from hibernation, and seeing the message
> >>"Corruption of in-memory data detected", could it be that thawing does a bad
> >>memory recovery from the swap?  I thought that the procedure includes some
> >>checksum, but I don't know for sure.
> >>
> >
> >Not sure, though if so I would think that might be a more common source
> >of problems.
> 
> And it only affects my /home partition - although it may be the busiest one.
> 
> 
> >>To me, there are two problems:
> >>
> >> 1) The corruption itself.
> >> 2) That xfs_repair fails to repair the filesystem. In fact, I believe
> >>    it does not detect it!
> >>
> >>To me, #2 is the worst, and it is what makes me do the backup, format,
> >>restore cycle for recovery. An occassional kernel crash is somewhat
> >>acceptable :-}
> >>
> >
> >Well it could be that the "corruption" is gone at the point of a
> >remount. E.g., something becomes inconsistent in memory, the fs detects
> >it and shuts down before going any further. That's actually a positive.
> >;)
> >
> >That also means it's probably not be necessary to do a full backup,
> >reformat and restore sequence as part of your routine here. xfs_repair
> >should scour through all of the allocation metadata and yell if it finds
> >something like free blocks allocated to a file.
> 
> No, if I don't backup-format-restore it happens again within a day. There is
> something lingering. Unless that was just chance... :-?
> 
> It is true that during that day I hibernated several times more than needed
> to see if it happened again - and it did.
> 

This depends on what causes this to happen, not how frequent it happens.
Does it continue to happen along with hibernation, or do you start
seeing these kind of errors during normal use?

If the latter, that could suggest something broken on disk. If the
former, that could simply suggest the fs (perhaps on-disk) has made it
into some kind of state that makes this easier to reproduce, for
whatever reason. It could be timing, location of metadata,
fragmentation, or anything really for that matter, but it doesn't
necessarily mean corruption (even though it doesn't rule it out).
Perhaps the clean regeneration of everything by a from-scratch recovery
simply makes this more difficult to reproduce until the fs naturally
becomes more aged/fragmented, for example.

This probably makes a pristine, pre-repair metadump of the reproducing
fs more interesting. I could try some of my previous tests against a
restore of that metadump.

> 
> 
> >>>I'm curious if something like an 'rm -rf *' on the metadump
> >>>would catch any other corruptions or if this is indeed limited to
> >>>something associated with recent (pre)allocations.
> >>
> >>Sorry, run 'rm -rf *' where???
> >>
> >
> >On the metadump... mainly just to see whether freeing all of the used
> >blocks in the fs triggered any other errors (i.e., a brute force way to
> >check for further corruptions).
> 
> Sorry, but I fail to see how to do it. I maybe thick, or I lack the context.
> 
> If I run:
> 
> Telcontar:/data/storage_d/old_backup # ls -lh
> total 604G
> drwxr-xr-x 22 root root  4.0K Mar  8 20:30 home
> drwxr-xr-x  3 root root    16 Sep 25  2010 home1
> drwxr-xr-x  2 root root     6 Jul  3 02:36 mount
> - -rw-r--r--  1 root root    45 Jul  3 04:25 procedure
> - -rw-r--r--  1 root root  388M Jul  3 02:42 tgtfile
> - -rw-r--r--  1 root root   11M Jul  3 02:50 tgtfile2.xz
> - -rw-r--r--  1 root users 489G Mar 16 05:42 xfs_copy_home
> - -rw-r--r--  1 root root  489G Jul  3 04:40 xfs_copy_home_workonit
> - -rw-r--r--  1 root users  39G Mar 16 05:49 xfsdump__home
> - -rw-r--r--  1 root users  39G Mar 16 05:57 xfsdump__home1
> Telcontar:/data/storage_d/old_backup # rm -rf *
> 
> 
> that would destroy my entire backup!
> 

I was somewhat thinking out loud originally discussing this topic. I was
suggesting to run this against a restored metadump, not the primary
dataset or a backup.

The metadump creates an image of the metadata of the source fs in a file
(no data is copied). This metadump image can be restored at will via
'xfs_mdrestore.' This allows restoring to a file, mounting the file
loopback, and performing experiments or investigation on the fs
generally as it existed when the shutdown was reproducible.

So basically:

- xfs_mdrestore <mdimgfile> <tmpfileimg>
- mount <tmpfileimg> /mnt
- rm -rf /mnt/*

... was what I was suggesting. <tmpfileimg> can be recreated from the
metadump image afterwards to get back to square one.

> 
> If you mean:
> 
>  rm -rf tgtfile
> 
> I fail to see what that would accomplish, except to remove a file that is actually on a different partition, not home.
> 
> However, I can do:
> 
> Telcontar:/data/storage_d/old_backup # mount -v xfs_copy_home_workonit mount/
> mount: /dev/loop0 mounted on /data/storage_d/old_backup/mount.
> Telcontar:/data/storage_d/old_backup # cd mount
> Telcontar:/data/storage_d/old_backup/mount # time rm -r /data/storage_d/old_backup/mount/*
> Telcontar:/data/storage_d/old_backup/mount # time rm -r /data/storage_d/old_backup/mount/*
> 
> real    2m45.380s
> user    0m0.265s
> sys     0m6.878s
> Telcontar:/data/storage_d/old_backup/mount #
> Telcontar:/data/storage_d/old_backup/mount # ls -la
> total 4
> drwxr-xr-x 2 root root    6 Jul  4 01:56 .
> drwxr-xr-x 5 root root 4096 Jul  3 04:25 ..
> Telcontar:/data/storage_d/old_backup/mount #
> Telcontar:/data/storage_d/old_backup/mount # df -h .
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop0      489G   33M  489G   1% /data/storage_d/old_backup/mount
> Telcontar:/data/storage_d/old_backup/mount #
> 
> 
> And I do not see anything on the log, only that it mounted cleanly.
> 
> 
> 
> >>Meanwhile, I have done a xfs_metadump of the image, and compressed it with
> >>xz. It has 10834536 bytes. What do I do with it? I'm not sure I can email
> >>that, and even less to a mail list.
> >>
> >>Do you still have a bugzilla system where I can upload it? I had an account
> >>at <http://oss.sgi.com/bugzilla/>, made on 2010. I don't know if it still
> >>runs :-?
> 
> 
> I have an active bugzilla account at <http://oss.sgi.com/bugzilla/>, I'm
> logged in there now. I haven't checked if I can create a bug, not been sure
> what parameters to use (product, component, whom to assign to). I think that
> would be the most appropriate place.
> 
> Meanwhile, I have uploaded the file to my google drive account, so I can
> share it with anybody on request - ie, it is not public, I need to add a
> gmail address to the list of people that can read the file.
> 
> Alternatively, I could just email the file to people asking for it, offlist,
> but not in a single email, in chunks limited to 1.5 MB per email.
> 

Either of the bugzilla or google drive options works Ok for me.

Brian

> 
> >I think http://bugzilla.redhat.com should allow you to file a bug and
> >attach the file.
> 
> Sorry, I don't have an account there...
> 
> I do have one at openSUSE, though, and it does allow me to attach files, up
> to a limit. If the file is to big, it can be fragmented in pieces. But I
> will not use it unless you people say that you have an account there.
> 
> For using a bugzilla, the most appropriate one would be at SGI, IMHO, if
> they are still supporting this project.
> 
> - -- Cheers,
>        Carlos E. R.
>        (from 13.1 x86_64 "Bottle" at Telcontar)
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.22 (GNU/Linux)
> 
> iEYEARECAAYFAlO3HXUACgkQtTMYHG2NR9VndgCgillZYmQCvUynytO/7YALlUyv
> c9gAnj8GmFfnMHGd+P9GaWm9ScVVTH81
> =GEXl
> -----END PGP SIGNATURE-----
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
