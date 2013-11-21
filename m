Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1A19E7F3F
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 21:58:31 -0600 (CST)
Message-ID: <528D84E1.3010500@sgi.com>
Date: Wed, 20 Nov 2013 21:58:25 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfsprogs: update version for 3.2.0-alpha2
References: <20131118150313.940966335@sgi.com>
	<20131119171527.125924934@sgi.com> <528D82CC.5060503@sandeen.net>
In-Reply-To: <528D82CC.5060503@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



On 11/20/2013 09:49 PM, Eric Sandeen wrote:
> On 11/19/13, 11:14 AM, rjohnston@sgi.com wrote:
>> Update the VERSION, configure.ac and doc/CHANGES file for alpha
>> release, 3.2.0-alpha2
>>
>> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>>
>> ---
>> V2
>>    - Add alpha1 and alpha2 content details
>> V3
>>    - Shorten content details (sent wrong version in V2)
>>
>> diff --git a/VERSION b/VERSION
>> index f4ab52c..f3b53c1 100644
>> --- a/VERSION
>> +++ b/VERSION
>> @@ -3,5 +3,5 @@
>>   #
>>   PKG_MAJOR=3
>>   PKG_MINOR=2
>> -PKG_REVISION=0-alpha1
>> +PKG_REVISION=0-alpha2
>>   PKG_BUILD=1
>> diff --git a/configure.ac b/configure.ac
>> index 949dd06..ae17c68 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -1,4 +1,4 @@
>> -AC_INIT([xfsprogs], [3.2.0-alpha1])
>> +AC_INIT([xfsprogs], [3.2.0-alpha2])
>>   AC_PREREQ(2.50)
>>   AC_CONFIG_AUX_DIR([.])
>>   AC_CONFIG_MACRO_DIR([m4])
>> diff --git a/doc/CHANGES b/doc/CHANGES
>> index 5a292d7..3006efd 100644
>> --- a/doc/CHANGES
>> +++ b/doc/CHANGES
>> @@ -1,6 +1,96 @@
>> +xfsprogs-3.2.0-alpha2 (19 November 2013)
>> +	- Alpha release for the purpose of testing the CRC feature during the
>> +	  v3.12 kernel -rc series.
>
> 3.12-rcX has come & gone, just say "testing the CRC feature"
> ("in kernels 3.12 and newer" if you like)
>
> Honestly, this changelog is very mechanical & unhelpful.  Up 'til now,
> we've had a fairly easy to read narrative of changes.  This git log format
> is a departure from that.
>
> There's so much here ones eyes kind of glaze over.  And re-specifying
> "xfsprogs:" in the xfsprogs changelog... not so useful.  Especially
> when it's misspelled.
>
> So rather than i.e.
>
> +	- xfsprogs: Note projid32bit default change in mkfs.xfs manpage
>
> say
>
> +	- mkfs.xfs now enables 32-bit project IDs by default for all filesystems
>
> Lots of the stuff below is just internal gyrations no user will
> care about.
>
> Just hit the highlights:
>
> * What new features?
> * What changes in behavior?
> * What bugs were fixed?
>
> you have a lot of leeway, but use your editorial powers to create
> something useful to a user by distilling this noise into a narrative.
> And fix spelling as needed.  ;)
>
> If you'd like me to just write the changelog so we can get it out the
> door, let me know.

Kinda caught up in other things, go for it.  English is not my first 
language. Many thanks Eric.

>
> Otherwise, lots of random suggestions below; not all inclusive.  Understand
> what changed, and use your discretion to communicate something useful
> to the reader.
>
>> +	- xfsprogs: fix Out-of-bounds access in repair/dinode.c
>> +	- xfsprogs: avoid array overflow in pf_batch_read()
>> +	- mkfs: add noalign option to usage()
>> +	- xfsprogs: initialize filetype for xfs_name_dot
>> +	- xfsprogs: fix potential memory leak in repare/sb.c
>> +	- xfsprogs: fix potential memory leak in verify_set_primary_sb()
>> +	- xfsprogs: fix return value of verify_set_primary_sb()
>
> - Fix several Coverity-found memory leaks
>
>> +	- libxfs: fix missing filetype updates to xfs_dir2.c
>> +	- xfs: check magic numbers in dir3 leaf verifier first
>> +	- xfs: ensure we copy buffer type in da btree root splits
>> +	- xfs: don't assert fail on bad inode numbers
>> +	- xfs: dirent dtype presence is dependent on directory magic numbers
>> +	- xfsprogs: handle symlinks etc in fs_table_initialise_mounts()
>
> - Properly handle symlinks to devices on various tool commandlines.
>
>> +	- xfsprogs: fix crc32 build on big endian
>
> - Fix build on big endian machines.
>
>> +	- xfsprogs: remove incorrect l_sectBBsize assignment in xfs_repair
>
> - Fix xfs_repair's dirty log detection for 4k sector logs, broken in Alpha1.
>
>> +	- xfsprogs: restrict platform_test_xfs_fd to regular files
>> +	- Bug#725971: xfsprogs: config.guess/config.sub out of date for arm64
>> +	- xfsprogs: fix a warning in the deb build
>> +	- xfs_repair: avoid segfault if reporting progress early in repair
>
> - Fix a segfault in xfs_repair when issuing progress reports.
>
>> +	- xfsprogs: initialize filetype for lost+found creation
>> +	- xfs_repair: test for bad level in dir2 node
>> +	- xfsprogs: Note projid32bit default change in mkfs.xfs manpage
>> +	- xfs_repair: add d_type when moving files to lost+found
>
> - Ensure all files created during xfs_repair have a proper d_type set.
>
>> +	- xfsprogs: fix resource leak in longform_dir2_rebuild()
>> +	- xfs: unify directory/attribute format definitions
>> +	- xfsprog: add xfs sb v4 support for dirent filetype field
>
> - This release adds directory entry filetype support for version 4 superblocks.
>
>> +	- xfsprog: add dirent filetype information for xfs_info
>> +	- xfs_progs: add dirent filetype to xfs_db version
>> +	- xfsprog: add mkfs.xfs sb v4 support for dirent filetype field
>> +	- xfsprogs: add generated crc files to .gitignore
>
> Since this is a release, to be packaged up in a tarball, nobody cares
> about .gitignore.
>
>> +	- xfsprogs: remove xfs_check references from fsck.xfs script & manpage
>> +	- xfsprogs: fix automatic dependency generation
>> +	- xfs: create a shared header file for format-related information
>> +	- xfs: split dquot buffer operations out
>> +	- xfs: decouple inode and bmap btree header files
>> +	- libxfs: unify xfs_btree.c with kernel code
>
> - Sync up libxfs with kernel code.
>
>> +	- libxfs: bmap btree owner swap support
>> +	- xfs: remove newlines from strings passed to __xfs_printk
>> +	- xfs: fix the wrong new_size/rnew_size at xfs_iext_realloc_direct()
>> +	- xfs: fix node forward in xfs_node_toosmall
>> +	- xfs: don't emit corruption noise on fs probes
>
> . . . this makes no sense in userspace; just an artifact
> of syncing I guess.
>
>> +	- libxfs: fix root inode handling inconsistencies
>> +	- libxfs: stop caching inode structures
>
> 'cause why?  The changelog for this is very detailed, distill it
> into something a user would care about.
>
>> +	- db: introduce verifier support into set_cur
>> +	- db: re-enable write support for v5 filesystems.
>> +	- xfs_db: use inode cluster buffers for inode IO
>> +	- xfs_db: avoid libxfs buffer lookup warnings
>
> etc etc etc. . . .
>
> - Enable version 5 superblock write support in xfs_db.
>
>> +	- libxfs: work around do_div() not handling 32 bit numerators
>> +	- db: enable metadump on CRC filesystems
>
> - Enable xfs_metadump for CRC filesystems.
>
>> +	- xfs: support larger inode clusters on v5 filesystems
>> +	- xfsprogs: kill experimental warnings for v5 filesystems
>
> worth noting
>
>> +	- repair: prefetching is turned off unnecessarily
>> +	- repair: Increase default repair parallelism on large filesystems
>> +	- xfs_fsr: fix SWAPEXT failures under selinux
>
> worth noting
>
>> +	- xfs_repair: correct docs for "-t" units
>> +
>>   xfsprogs-3.2.0-alpha1 (26 September 2013)
>>   	- Alpha release for the purpose of testing the CRC feature during the
>>   	  v3.12 kernel -rc series.
>
> The whuh?  The reader might want to know what this CRC thing is.
>
> "This release adds . . . for the purpose of . . . enabled by . . .
> the current state is . . . still unimplemented are ..."
>
>> +	- xfs_logprint: print all AGI unlinked buckets
>> +	- xfs_fsr: file reads should be O_DIRECT
>> +	- xfsprogs: Die dir1 Die!
>
> - Remove all vestiges of old, unsupported version 1 directory code.
>
>> +	- xfsprogs: add CRC32c infrastructure
>> +	- xfsprogs: updata libxlog to current kernel code
>
> collapse all that sort of thing into
>
> - Sync up libxfs with kernel code.
>
>> +	- xfs_logprint: fix continuation transactions
>> +	- xfsprogs: define umode_t for build if not defined already
>> +	- xfsprogs: fix make deb
>> +	- mkfs: add missing noalign suboption information
>> +	- mkfs: fix realtime device initialisation
>> +	- xfs_metadump: manpage fix regarding frozen fs
>> +	- logprint: fix wrapped log dump issue
>> +	- libxfs: add crc format changes to generic btrees
>> +	- xfsprogs: fixes and updates to current kernel code tarball
>> +		http://oss.sgi.com/archives/xfs/2013-05/msg00013.html
>
> tarball?
>
>> +	- xfsprogs: add recent kernel CRC fixes (12 part patchset)
>> +		http://oss.sgi.com/archives/xfs/2013-06/msg00201.html
>> +	- mkfs.xfs: fix protofile name create block reservation
>> +	- xfsprogs/io: add readdir command
>
> worth noting; feature
>
>> +	- xfsprogs: Various Coverity bug fixes
>
> worth noting probably
>
>> +	- xfsprogs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
>
> nobody cares  ;)
>
>> +	- xfsprogs: Start using pquotaino from on-disk superblock
>> +	- xfsprogs: fix inode crash in xfs_repair
>
> What's an "inode crash?"
>
> - Fix potential segfault in xfs_repair when creating lost+found.
>
>> +	- xfsprogs: fix Out-of-bounds access in repair/dinode.c
>> +	- xfs_repair: add prototype for alloc_ex_data()
>> +	- xfs_repair: zero out unused parts of superblocks
>
> - Zero out unused parts of on-disk superblocks during repair, to avoid
>    metadata verifier failures at runtime.
>
> etc.  You get the idea...
>
>
> Thanks,
> -Eric
>
>> +	- xfs_db: add header to freesp -d output
>> +	- xfs_io: v8 add the lseek() SEEK_DATA/SEEK_HOLE support
>> +	- xfsprogs: bring code up to date with kernel (55 part series)
>> +       		updated version of the patchset posted here:
>> +		http://oss.sgi.com/archives/xfs/2013-07/msg00454.html
>>
>>   xfsprogs-3.1.11 (8 May 2013)
>>   	- Support for relative paths in xfs_quota thanks to Satoru Takeuchi.
>> @@ -35,8 +125,8 @@ xfsprogs-3.1.11 (8 May 2013)
>>   	- Remove unconditional ASSERT(0) in xfs_repair.
>>   	- Reduce bb_numrecs in bno/cnt btrees when log consumes all agf space.
>>   	- Add depraction message for xfs_check.
>> -	- xfs_quota allow user or group names beginning with digits reported by
>> -	  James Carter.
>> +	- xfs_quota allow user or group names beginning with digits reported
>> +	  by James Carter.
>>   	- Fix manpages and usage() spelling, errors and omissions.
>>   	- Validate the extent count is at least within the positive
>>   	  range of a signed 32 bit integer before using it.
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
