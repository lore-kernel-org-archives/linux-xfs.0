Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D8DEE7F54
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 09:45:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A13F2304077
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 07:45:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dT8Y8FEViIyQp9Pe for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 07:45:30 -0700 (PDT)
Message-ID: <51827C09.2080805@sandeen.net>
Date: Thu, 02 May 2013 09:45:29 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs-3.1.11 pre-release   please test!
References: <51817712.6000807@sgi.com> <51817C88.4060208@sgi.com>
	<51826B72.4030707@gmail.com>
In-Reply-To: <51826B72.4030707@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

On 5/2/13 8:34 AM, Michael L. Semon wrote:
> On 05/01/2013 04:35 PM, Mark Tinguely wrote:
>> On 05/01/13 15:12, Rich Johnston wrote:
>>> Hi Folks,
>>> 
>>> Here are the changes for this release:
>>> 
>>> xfsprogs-3.1.11 (30 April 2013)
>>> 
>>> - Support for relative paths in xfs_quota thanks to Satoru
>>> Takeuchi. - mkfs.xfs will always go into multidisk mode when
>>> filesystem geometry is specified on the command line. - Document
>>> all commands in xfs_io. - Remove setfl command from xfs_io. -
>>> xfs_metadump will obfuscate symlinks by path component. -
>>> mkfs.xfs no longer accepts geometry settings smaller than the 
>>> physical sector size. - xfs_logprint now supports multiply-logged
>>> inode fields and handles continued inode transactions correctly. 
>>> - kill XLOG_SET - Update release scripts to use git archive to
>>> address a missing source file reported by Arkadiusz Mi?kiewicz -
>>> Fix a build error with -Werror=format-security, reported by
>>> Arkadiusz Mi?kiewicz - mkfs.xfs no longer attempts to discard
>>> when -N option is used. - Update 'make deb' to use tarball - Sync
>>> up with log reservation changes in the kernel. - Fix possible
>>> unallocated memory access in fiemap. - Guard against string
>>> overflow in path_to_fspath. - Fix setup_cursor array allocation. 
>>> - Fix free of unintialized pointer in xfs_acl_valid error path. -
>>> Guard against path string overflows. - Check strdup results
>>> properly in initallfs(). - Fix attribute no_change_count logic. -
>>> Remove extraneous close() in fsrallfs(). - xfs_repair now skips
>>> the freelist scan of a corrupt agf when in no-modify mode. -
>>> xfs_db now skips freelist scans of corrupt agfs. - Remove
>>> unconditional ASSERT(0) in xfs_repair. - Reduce bb_numrecs in
>>> bno/cnt btrees when log consumes all agf space. - Add depraction
>>> message for xfs_check. - xfs_quota allow user or group names
>>> beginning with digits reported by James Carter. - Fix manpages
>>> and usage() spelling, errors and omissions.
>>> 
>>> I have placed a pre-release tarball here:
>>> 
>>> ftp://oss.sgi.com/projects/xfs/cmd_tars/pre-release/xfsprogs-pre-3.1.11-3.tar.gz
>>>
>>>
>>>
>>>
>>> 
Please take a look and report any issues before next Wednesday (08 May
>>> 2013). If there are other patches which you feel are essential,
>>> now is the time to say so.
>>> 
>>> Regards --Rich
>> 
>> The new lines (below) in xfs_check.sh breaks older xfstests:
>> 
>> xfs_check is deprecated and scheduled for removal in June 2014. 
>> Please use xfs_repair -n <dev> instead.
>> 
>> xfstests' ./check thinks the TEST directory is inconsistent and
>> stops. I simply commented the lines out of the installed
>> /usr/sbin/xfs_check for my tests.
>> 
>> FSTYP         -- xfs (debug) PLATFORM      -- Linux/x86_64 host
>> 3.9.0-rc1+ MKFS_OPTIONS  -- -f -bsize=4096 {SCRATCH_DEV} 
>> MOUNT_OPTIONS -- {SCRATCH_DEV} {SCRATCH_MNT}
>> 
>> _check_xfs_filesystem: filesystem on {TEST_DEV} is inconsistent (c)
>> (see check.full) Passed all 0 tests
>> 
>> --Mark.
> 
> I'm battling this as well, coming to hazy conclusions late at night.
> In the _xfs_check() function in common/rc of xfstests, there was
> something like this:
> 
> ${XFS_DB_PROG}${DBOPTS} -F -i -p xfs_check -c "check$OPTS" $1
> 
> When doing XFS tests with an external logdev (at least), things
> failed that way, so I threw an "echo command_about_to_run" line just
> above that.  I got the impression that the flags "-l $TEST_LOGDEV"
> were being passed to xfs_db twice (not fatal), but I didn't see where
> the $TEST_DEV was being passed to xfs_db.  It looks like xfs_db is
> giving back the standard usage line.  Again, it was late last night,
> so might someone verify that the xfs_db is always called with the
> correct data dev or mountpoint?

I'll send a patch.

> Anyway, something indeed is up between the latest git xfsprogs and
> the latest xfstests, but my blame list hasn't been set yet.  I did
> see the deprecation message either in the ".full" file or one of the
> /tmp files left behind, so you are indeed correct about that.
> Whether that's the only error is another matter.
> 
> BTW, it looked like xfs_check is scheduled for removal in June 2014,
> yet the xfstests folks are planning like it will be gone in June
> 2013.  Is the year in the deprecation message correct?

xfstests is planning ahead.  ;)  Nothing stops the end-user from dropping
a tool before the ultimate deprecation date...

-Eric

 
> Thanks!
> 
> Michael
> 
> _______________________________________________ xfs mailing list 
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
