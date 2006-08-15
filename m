Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Aug 2006 18:46:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7F1jmDW007048
	for <xfs@oss.sgi.com>; Mon, 14 Aug 2006 18:46:00 -0700
Message-Id: <200608150145.LAA07105@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: cache_purge: shake on cache 0x5880a0 left 8 nodes!?
Date: Tue, 15 Aug 2006 11:49:13 +1000
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20060812091451.GA16661@wurtel.net>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Paul Slootman' <paul@wurtel.net>, xfs@oss.sgi.com

Paul,

Do you still have the filesystem with the undeletable directory?

If so, can you run xfs_db and email me the contents of that directory?

The commands would be:

xfs_db> blockget -n
xfs_db> ncheck lost+found.x
        <inum> lost+found.x/.
xfs_db> inode <inum>
xfs_db> p

# if not a shortform directory, ie. the above does not output 
  "u.sfdir2.etc", do the following sequence for all the blocks
  in the extent map, or at least offset 0 and 8388608 if they
  exist:

xfs_db> dblock <n>
xfs_db> p


With this output, I should be able to recreate a similar 
directory and test xfs_repair for problems.

Thanks,
Barry.

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Paul Slootman
> Sent: Saturday, 12 August 2006 7:15 PM
> To: xfs@oss.sgi.com
> Subject: Re: cache_purge: shake on cache 0x5880a0 left 8 nodes!?
> 
> On Fri 11 Aug 2006, Paul Slootman wrote:
> > 
> > Unfortunately, the filesystem panicked again last night.
> > This was after the double repair, and rebooting into 2.6.17.7, which
> > shouldn't have the bug, right?
> > I'll run another repair now :-(
> 
> And again.
> Curious fact appeared: the lost+found directory from the first time
> (which I had moved to lost+found.x) could not be removed 
> "Directory not
> empty". This would indicate that the CVS repair version (of 2 
> days ago)
> does not properly build the lost+found directory.
> 
> I've now zapped that directory with xfs_db, and am running 
> the (daily?!)
> xfs_repair at this moment. As the filesystem is 1.1TB, it 
> takes a couple
> of hours :(
> 
> 
> Paul Slootman
> 
> 
