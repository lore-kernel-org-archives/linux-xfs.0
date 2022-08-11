Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7B5C19F2A
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Aug 2022 12:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbiHKM6T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Aug 2022 08:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbiHKM6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 08:58:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB7F6E2E8
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 05:58:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B151F61456
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 12:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D2FC433C1;
        Thu, 11 Aug 2022 12:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660222694;
        bh=C45441qWliloCeZP/+sWHvlvsLtuuEuagQ107YNV4us=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sQ+3nstArYEjGZLwdETYnRjOMSwsNcUGBNu1ZlaCrYOIRqZBzNwovBf+eSoNs1gno
         ggYj8wLfRnMVdjxS+NQrFt07zf7DzVlGFXA4GhkGCBaKZbyTSHeDUrZb56SZJksEuL
         ZRAappsB+b0Ra2meSRJ1EeC0d5H927uCGG2dTxwrbOAM7Wt5kySszfCIk+cIXmm5os
         uIGfTjz33darR/owPTfoooVDCdwG39cFDvToJ41xutAeYJbNELIWeLitpN1v+uaA+h
         cxFtaCfAVCQ3/mVctqH0tQVijeq6LUeXtpjqjtpIofKBNaRzp+tSZCu9GR+Qk3afdJ
         Bfo1WRe8mWZCg==
Date:   Thu, 11 Aug 2022 14:58:09 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Remove trailing white spaces from xfsdump.html
Message-ID: <20220811125809.mqxtf2bs54obbrug@orion>
References: <166012867440.10085.15666482309699207253.stgit@orion>
 <166012880601.10085.14032914718801896551.stgit@orion>
 <bNT1og__bmI017M4gKuTye1kVAqYbWxVwEskW-SC65f7bX94cgFaie6fLcqwa-VsC17Y9jMFAOcd9ozpDJpR8w==@protonmail.internalid>
 <YvPKGGu9gcVcpTps@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YvPKGGu9gcVcpTps@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 10, 2022 at 08:09:12AM -0700, Darrick J. Wong wrote:
> On Wed, Aug 10, 2022 at 12:53:26PM +0200, Carlos Maiolino wrote:
> > Cleanup xfsdump.html and remove all trailing white spaces from it.
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  doc/xfsdump.html |  408 +++++++++++++++++++++++++++---------------------------
> >  po/de.po         |    4 -
> >  2 files changed, 206 insertions(+), 206 deletions(-)
> >
> > diff --git a/doc/xfsdump.html b/doc/xfsdump.html
> > index 958bc80..e37e362 100644
> > --- a/doc/xfsdump.html
> > +++ b/doc/xfsdump.html
> > @@ -29,8 +29,8 @@
> >        <ul>
> >  	<li><a href="#main">The main function of xfsdump</a>
> >  	<ul>
> > -	  <li><a href="#drive_init1">drive_init1</a>
> > -	  <li><a href="#content_init_dump">content_init</a>
> > +	  <li><a href="#drive_init1">drive_init1</a>
> > +	  <li><a href="#content_init_dump">content_init</a>
> >  	</ul>
> >  	<li><a href="#dump_tape">Dumping to Tape</a>
> >  	<ul>
> > @@ -86,7 +86,7 @@ These notes are written for xfsdump and xfsrestore in IRIX. Therefore,
> >  it refers to some features that aren't supported in Linux.
> >  For example, the references to multiple streams/threads/drives do not
> >  pertain to xfsdump/xfsrestore in Linux. Also, the DMF support in xfsdump
> > -is not yet useful for Linux.
> > +is not yet useful for Linux.
> >
> >  <hr>
> >  <h3><a name="intro">What's in a dump</a></h3>
> > @@ -95,7 +95,7 @@ or stdout. The dump includes all the filesystem objects of:
> >  <ul>
> >  <li>directories (S_IFDIR)
> >  <li>regular files (S_IFREG)
> > -<li>sockets (S_IFSOCK)
> > +<li>sockets (S_IFSOCK)
> >  <li>symlinks (S_IFLNK)
> >  <li>character special files (S_IFCHR)
> >  <li>block special files (S_IFBLK)
> > @@ -106,7 +106,7 @@ xfsdump inventory is located.
> >  Other data which is stored:
> >  <ul>
> >  <li> file attributes (stored in stat data) of owner, group, permissions,
> > -and date stamps
> > +and date stamps
> >  <li> any extended attributes associated with these file objects
> >  <li> extent information is stored allowing holes to be reconstructed
> >  on restoral
> > @@ -137,7 +137,7 @@ believe that only one media-file is used. Whereas on tape
> >  media, multiple media files are used depending upon the size
> >  of the media file. The size of the media file is set depending
> >  on the drive type (in IRIX): QIC: 50Mb; DAT: 512Mb; Exabyte: 2Gb; DLT: 4Gb;
> > -others: 256Mb. This value (media file size) is now able to be changed
> > +others: 256Mb. This value (media file size) is now able to be changed
> >  by the "-d" option.
> >  . Also, on tape, the dump is finished by an inventory
> >  media file followed by a terminating null media file.
> > @@ -188,16 +188,16 @@ pad to 1K bytes
> >  	strategy id = on-file, on-tape, on-rmt-tape
> >  	strategy specific data:
> >  	  field to denote if media file is a terminator (old fmt)
> > -	upper: (to 2K)
> > +	upper: (to 2K)
> >  </pre>
> >
> >  <p>
> >  Note that the <i>strategy id</i> is checked on restore so that
> > -the dump strategy and the strategy used by restore
> > -are the same with the exception that drive_scsitape matches with
> > -drive_minrmt. This strategy check has caused problems with customers
> > +the dump strategy and the strategy used by restore
> > +are the same with the exception that drive_scsitape matches with
> > +drive_minrmt. This strategy check has caused problems with customers
> >  in the past.
> > -In particular, if one sends xfsdump's stdout to a tape
> > +In particular, if one sends xfsdump's stdout to a tape
> >  (i.e. xfsdump -L test -M test - / >/dev/tape) then one can not
> >  restore this tape using xfsrestore by specifying the tape with the -f option.
> >  There was also a problem for a time where if one used a drive with
> > @@ -205,7 +205,7 @@ the TS tape driver, xfsdump wouldn't recognise this driver and
> >  would select the drive_simple strategy.
> >
> >  <hr>
> > -
> > +
> >
> >  <h4><a name="inode_map">Inode Map</a></h4>
> >  <img src="inode_map.gif">
> > @@ -227,8 +227,8 @@ then the file can be dumped in multiple records or extent groups.
> >  <h3><a name="tape_format">Format on Tape</a></h3>
> >  At the beginning of each tape record is a header. However, for
> >  the first record of a media file, the record header is buried
> > -inside the global header at byte offset 1536 (1K + 512), as is shown in
> > -the global header diagram.
> > +inside the global header at byte offset 1536 (1K + 512), as is shown in
> > +the global header diagram.
> >  Reproduced again:
> >  <pre>
> >  <b>rec_hdr</b>
> > @@ -246,28 +246,28 @@ dump uuid
> >  pad to 512 bytes
> >  </pre>
> >  <p>
> > -I can not see where the block-size ("tape_blksz") is ever used !
> > +I can not see where the block-size ("tape_blksz") is ever used !
> >  The record-size ("tape_recsz") is used as the byte count to do
> >  the actual write and read system calls.
> >  <p>
> >  There is another layer of s/ware for the actual data on the tape.
> >  Although, one may write out an inode-map or directory entries,
> > -one doesn't just give these record buffers straight to the
> > +one doesn't just give these record buffers straight to the
> >  write system call to write out. Instead, these data objects are
> >  written to buffers (akin to &lt;stdio&gt). Another thread reads
> >  from these buffers (unless its running single-threaded) and writes
> >  them to tape.
> >  Specifically, inside a loop,
> >  one calls <b>do_get_write_buf</b>,
> > -copies over the data one wants stored and then
> > +copies over the data one wants stored and then
> >  calls <b>do_write_buf</b>, until the entire data buffer
> >  has been copied over.
> >
> > -<hr>
> > +<hr>
> >
> >  <h3><a name="run_time_structure">Run Time Structure</a></h3>
> >
> > -This section reviews the run time structure and failure handling in
> > +This section reviews the run time structure and failure handling in
> >  dump/restore (see IRIX PV 784355).
> >
> >  The diagram below gives a schematic of the runtime structure
> > @@ -346,7 +346,7 @@ point they drop out of the message processing loop and always signal success.
> >  <p>
> >  Thus the only child processes that can affect the return status of
> >  dump or restore are the stream managers, and these processes take
> > -their exit status from the values returned by
> > +their exit status from the values returned by
> >  <b>content_stream_dump</b> and <b>content_stream_restore</b>.
> >
> >  <hr>
> > @@ -374,14 +374,14 @@ create inode-ranges for multi-stream dumps if pertinent.
> >    The inode map stores the type of the inode: directory or non-directory,
> >    and a state value to say whether it has changed or not.
> >    The inode map is built by processing each inode (using bulkstat) and
> > -  in order to work out if it should be marked as changed,
> > +  in order to work out if it should be marked as changed,
> >    by comparing its date stamp with the date of the base or interrupted
> > -  dump.
> > +  dump.
> >    We also update the size for non-dir regular files (bs_blocks * bs_blksize)
> >  <li><b>phase 3</b>: prune the unneeded subtrees due to the set of
> >    unchanged directories or the subtrees specified in -s (phase 1).
> > -  This works by marking higher level directories as unchanged
> > -  (MAP_DIR_NOCHNG) in the inode map.
> > +  This works by marking higher level directories as unchanged
> > +  (MAP_DIR_NOCHNG) in the inode map.
> >  <li><b>phase 4</b>: estimate non-dir (file) size if pruning was done
> >    since phase 2.
> >    It calculates this by processing each inode (using bulkstat)
> > @@ -389,7 +389,7 @@ create inode-ranges for multi-stream dumps if pertinent.
> >    If it is then it uses (bs_blocks * bs_blksize) as in phase 2.
> >  <li><b>phase 5</b>: if we have multiple streams, then
> >    it splits up the dump to try to give each stream a set of inodes
> > -  which has an equal amount of file data.
> > +  which has an equal amount of file data.
> >    See the section on "Splitting a dump over multiple streams" below.
> >  </ul>
> >
> > @@ -428,13 +428,13 @@ create inode-ranges for multi-stream dumps if pertinent.
> >      <li> end the media file
> >      <li> update online inventory
> >      </ul>
> > -<li> if multiple-media dump (i.e. tape dump and not file dump) then
> > +<li> if multiple-media dump (i.e. tape dump and not file dump) then
> >    <ul>
> >    <li> dump the session inventory to a media file
> >    <li> dump the terminator to a media file
> >    </ul>
> >  </ul>
> > -
> > +
> >  <hr>
> >
> >  <h5><a name="main">The main function of xfsdump</a></h5>
> > @@ -442,7 +442,7 @@ create inode-ranges for multi-stream dumps if pertinent.
> >  <pre>
> >  * <b><a name="drive_init1">drive_init1</a></b> - initialize drive manager for each stream
> >    - go thru cmd options looking for -f device
> > -  - each device requires a drive-manager and hence an sproc
> > +  - each device requires a drive-manager and hence an sproc
> >      (sproc = IRIX lightweight process)
> >    - if supposed to run single threaded then can only
> >      support one device
> > @@ -452,7 +452,7 @@ create inode-ranges for multi-stream dumps if pertinent.
> >    - if "-" specified for std out then only one drive allowed
> >
> >    - for each drive it tries to pick best strategy manager
> > -    - there are 3 strategies
> > +    - there are 3 strategies
> >        1) simple - for dump on file
> >        2) scsitape - for dump on tape
> >        3) minrmt - minimal protocol for remote tape (non-SGI)
> > @@ -470,7 +470,7 @@ create inode-ranges for multi-stream dumps if pertinent.
> >        - note if remote tape (has ":" in name)
> >        - set capabilities of BSF, FSF, etc.
> >
> > -* <b>create global header</b>
> > +* <b>create global header</b>
> >    - store magic#, version, date, hostid, uuid, hostname
> >    - process args for session-id, dump-label, ...
> >
> > @@ -481,13 +481,13 @@ create inode-ranges for multi-stream dumps if pertinent.
> >
> >    * inomap_build() - stores stream start-points and builds inode map
> >
> > -  - <b>phase1</b>: parsing subtree selections (specified by -s options)
> > -    <b>INPUT</b>:
> > +  - <b>phase1</b>: parsing subtree selections (specified by -s options)
> > +    <b>INPUT</b>:
> >  	- sub directory entries (from -s)
> >      <b>FLOW</b>:
> > -	- go thru each subtree and
> > +	- go thru each subtree and
> >  	  call diriter(callback=subtreelist_parse_cb)
> > -	  - diriter on subtreelist_parse_cb
> > +	  - diriter on subtreelist_parse_cb
> >  	    - open_by_handle() on dir handle
> >  	    - getdents()
> >  	    - go thru each entry
> > @@ -503,9 +503,9 @@ create inode-ranges for multi-stream dumps if pertinent.
> >  	- list of inodes corresponding to subtree path names
> >
> >    - premptchk: progress report, return if got a signal
> > -
> > +
> >    - <b>phase2</b>: creating inode map (initial dump list)
> > -    <b>INPUT</b>:
> > +    <b>INPUT</b>:
> >        - bulkstat records on all the inodes in the file system
> >      <b>FLOW</b>:
> >        - bigstat_init on cb_add()
> > @@ -516,16 +516,16 @@ create inode-ranges for multi-stream dumps if pertinent.
> >  	  - loop thru each struct xfs_bstat record for an inode
> >  	    calling cb_add()
> >  	  * cb_add
> > -	    - looks at latest mtime|ctime and
> > +	    - looks at latest mtime|ctime and
> >  	      if inode is resumed:
> > -		 compares with cb_resumetime for change
> > +		 compares with cb_resumetime for change
> >  	      if have cb_last:
> >  		 compares with cb_lasttime for change
> >  	    - add inode to map (map_add) and note if has changed or not
> > -	    - call with state of either
> > +	    - call with state of either
> >  		changed - MAP_DIR_CHANGE, MAP_NDR_CHANGE
> >  		not changed - MAP_DIR_SUPPRT or MAP_NDR_NOCHNG
> > -	    - for changed non-dir REG inode,
> > +	    - for changed non-dir REG inode,
> >  	      data size for its dump is added by bs_blocks * bs_blksize
> >  	    - for non-changed dir, it sets flag for &lt;pruneneeded&gt;
> >  	      => we don't want to process this later !
> > @@ -533,31 +533,31 @@ create inode-ranges for multi-stream dumps if pertinent.
> >  	    - segment = &lt;base, 64-low, 64-mid, 64-high&gt;
> >  		      = like 64 * 3-bit values (use 0-5)
> >  		      i.e. for 64 inodes, given start inode number
> > -		#define MAP_INO_UNUSED  0 /* ino not in use by fs -
> > +		#define MAP_INO_UNUSED  0 /* ino not in use by fs -
> >                                               Used for lookup failure */
> > -		#define MAP_DIR_NOCHNG  1 /* dir, ino in use by fs,
> > +		#define MAP_DIR_NOCHNG  1 /* dir, ino in use by fs,
> >                                               but not dumped */
> > -		#define MAP_NDR_NOCHNG  2 /* non-dir, ino in use by fs,
> > +		#define MAP_NDR_NOCHNG  2 /* non-dir, ino in use by fs,
> >                                               but not dumped */
> >  		#define MAP_DIR_CHANGE  3 /* dir, changed since last dump */
> >
> >  		#define MAP_NDR_CHANGE  4 /* non-dir, changed since last dump */
> >
> > -		#define MAP_DIR_SUPPRT  5 /* dir, unchanged
> > +		#define MAP_DIR_SUPPRT  5 /* dir, unchanged
> >                                               but needed for hierarchy */
> >  		- hunk = 4 pages worth of segments, max inode#, next ptr in list
> >  	    - i.e. map = linked list of 4 pages of segments of 64 inode states
> >      <b>OUTPUT</b>:
> > -	- inode map = list of all inodes of file system and
> > +	- inode map = list of all inodes of file system and
> >  	  for each one there is an associated state variable
> >  	  describing type of inode and whether it has changed
> > -	- the inode numbers are stored in chunks of 64
> > +	- the inode numbers are stored in chunks of 64
> >  	  (with only the base inode number explicitly stored)
> >
> >    - premptchk: progress report, return if got a signal
> >
> >    - if &lt;pruneneeded&gt; (i.e. non-changed dirs) OR subtrees specified (-s)
> > -    - <b>phase3</b>:  pruning inode map (pruning unneeded subtrees)
> > +    - <b>phase3</b>:  pruning inode map (pruning unneeded subtrees)
> >  	<b>INPUT</b>:
> >  	    - subtree list
> >  	    - inode map
> > @@ -565,13 +565,13 @@ create inode-ranges for multi-stream dumps if pertinent.
> >  	- bigstat_iter on cb_prune() per inode
> >  	* cb_prune
> >  	  - if have subtrees and subtree list contains inode
> > -	    -> need to traverse every group (inogrp_t) and
> > +	    -> need to traverse every group (inogrp_t) and
> >                 every page of inode#s
> >  	    - diriter on cb_count_in_subtreelist
> >  	      * cb_count_in_subtreelist:
> >  	      - looks up each inode# (in directory iteration) in subtreelist
> >  	      - if exists then increment counter
> > -	    - if at least one inode in list
> > +	    - if at least one inode in list
> >  	      - diriter on cb_cond_del
> >  	      * cb_cond_del:
> >              - TODO
> > @@ -629,20 +629,20 @@ create inode-ranges for multi-stream dumps if pertinent.
> >            - header = &lt;offset, flags, checksum, 128-byte bulk stat structure &gt;
> >            - bulkstat struct derived from struct xfs_bstat
> >              - stnd. stat stuff + extent size, #of extents, DMI stuff
> > -          - if HSM context then
> > +          - if HSM context then
> >              - modify bstat struct to make it offline
> >          - loops calling getdents()
> > -          - does a bulkstat or bulkstat-single of dir inode
> > +          - does a bulkstat or bulkstat-single of dir inode
> >            * dump_dirent()
> >              - fill in direnthdr_t record
> > -            - &lt;ino, gen & DENTGENMASK, record size,
> > +            - &lt;ino, gen & DENTGENMASK, record size,
> >                    checksum, variable length name (8-char padded)&gt;
> >                - gen is from statbuf.bs_gen
> > -            - write out record
> > +            - write out record
> >          - dump null direnthdr_t record
> > -        - if dumpextattr flag on and it
> > +        - if dumpextattr flag on and it
> >            has extended attributes (check bs_xflags)
> > -          * dump_extattrs
> > +          * dump_extattrs
> >              * dump_filehdr() with flags of FILEHDR_FLAGS_EXTATTR
> >                - for root and non-root attributes
> >                  - get attribute list (attr_list_by_handle())
> > @@ -650,7 +650,7 @@ create inode-ranges for multi-stream dumps if pertinent.
> >                - TODO
> >
> >      - bigstat iter on dump_file()
> > -      - go thru each inode in file system and apply dump_file
> > +      - go thru each inode in file system and apply dump_file
> >        * dump_file()
> >  	- if file's inode# is less than the start-point then skip it
> >  	  -> presume other sproc handling dumping of that inode
> > @@ -658,7 +658,7 @@ create inode-ranges for multi-stream dumps if pertinent.
> >  	- look-up inode# in inode map
> >  	- if not in inode-map OR hasn't changed then skip it
> >  	- elsif stat is NOT a non-dir then we have an error
> > -	- if have an hsm context then initialize context
> > +	- if have an hsm context then initialize context
> >  	- call dump function depending on file type (S_IFREG, S_IFCHR, etc.)
> >
> >  	  * <b>dump_file_reg</b> (for S_IFREG):
> > @@ -671,7 +671,7 @@ create inode-ranges for multi-stream dumps if pertinent.
> >  	      - dump extent header of type, EXTENTHDR_TYPE_DATA
> >  	      - write out link buffer (i.e. symlink string)
> >
> > -	  - if dumpextattr flag on and it
> > +	  - if dumpextattr flag on and it
> >  	    has extended attributes (check bs_xflags)
> >  	    * dump_extattrs (see the same call in the dir case above)
> >
> > @@ -686,7 +686,7 @@ create inode-ranges for multi-stream dumps if pertinent.
> >      - if got an inventory stream then
> >        * inv_put_mediafile
> >  	- create an inventory-media-file struct (invt_mediafile_t)
> > -	  - &lt; media-obj-id, label, index, start-ino#, start-offset,
> > +	  - &lt; media-obj-id, label, index, start-ino#, start-offset,
> >  		 end-ino#, end-offset, size = #recs in media file, flag &gt;
> >  	* stobj_put_mediafile
> >
> > @@ -694,7 +694,7 @@ create inode-ranges for multi-stream dumps if pertinent.
> >    - lock and increment the thread done count
> >
> >    - if dump supports multiple media files (tapes do but dump-files don't) then
> > -    - if multi-threaded then
> > +    - if multi-threaded then
> >        - wait for all threads to have finished dumping
> >          (loops sleeping for 1 second each iter)
> >      * dump_session_inv
> > @@ -716,9 +716,9 @@ create inode-ranges for multi-stream dumps if pertinent.
> >  * <b><a name="dump_file_reg">dump_file_reg</a></b> (for S_IFREG):
> >    - if this is the start inode, then set the start offset
> >    - fixup offset for resumed dump
> > -  * init_extent_group_context
> > +  * init_extent_group_context
> >      - init context - reset getbmapx struct fields with offset=0, len=-1
> > -    - open file by handle
> > +    - open file by handle
> >      - ensure Mandatory lock not set
> >    - loop dumping extent group
> >      - dump file header
> > @@ -739,11 +739,11 @@ create inode-ranges for multi-stream dumps if pertinent.
> >
> >  	  - if bmap entry is a hole (bmv_block == -1) then
> >  	    - if dumping ext.attributes then
> > -	      - dump extent header with bmap's offset,
> > +	      - dump extent header with bmap's offset,
> >  		extent-size and type EXTENTHDR_TYPE_HOLE
> >
> >  	    - move onto next bmap
> > -	      - if bmap's (offset + len)*512 > next-offset then
> > +	      - if bmap's (offset + len)*512 > next-offset then
> >  		update next-offset to this
> >  	      - inc ptr
> >
> > @@ -767,7 +767,7 @@ create inode-ranges for multi-stream dumps if pertinent.
> >  	    - read data of actualsz from file into buffer
> >  	    - write out buffer
> >  	    - if at end of file and have left over space in the extent then
> > -	      - pad out the rest of the extent
> > +	      - pad out the rest of the extent
> >  	    - if next offset is at or past next-bmap's offset+len then
> >  	      - move onto next bmap
> >      - dump null extent header of type, EXTENTHDR_TYPE_LAST
> > @@ -779,10 +779,10 @@ create inode-ranges for multi-stream dumps if pertinent.
> >  <hr>
> >
> >  <h4><a name="reg_split">Splitting a Regular File</a></h4>
> > -If a regular file is greater than 16Mb
> > -(maxextentcnt = drivep->d_recmarksep
> > -              = recommended max. separation between marks),
> > -then it is broken up into multiple extent groups each with their
> > +If a regular file is greater than 16Mb
> > +(maxextentcnt = drivep->d_recmarksep
> > +              = recommended max. separation between marks),
> > +then it is broken up into multiple extent groups each with their
> >  own filehdr_t's.
> >  A regular file can also be split, if we are dumping to multiple
> >  streams and the file would span the stream boundary.
> > @@ -790,15 +790,15 @@ streams and the file would span the stream boundary.
> >  <h4><a name="split_mstream">Splitting a dump over multiple streams (Phase 5)</a></h4>
> >  If one is dumping to multiple streams, then xfsdump calculates an
> >  estimate of the dump size and divides by the number of streams to
> > -determine how much data we should allocate for a stream.
> > -The inodes are processed in order from <i>bulkstat</i> in the function
> > +determine how much data we should allocate for a stream.
> > +The inodes are processed in order from <i>bulkstat</i> in the function
> >  <i>cb_startpt</i>. Thus we start allocating inodes to the first stream
> >  until we reach the allocated amount and then need to decide how to
> >  proceed on to the next stream. At this point we have 3 actions:
> >  <dl>
> >  <dt>Hold
> >  <dd>Include this file in the current stream.
> > -<dt>Bump
> > +<dt>Bump
> >  <dd>Start a new stream beginning with this file.
> >  <dt>Split
> >  <dd>Split this file across 2 streams in different extent groups.
> > @@ -850,8 +850,8 @@ Initialize the mmap files of:
> >    <li> search for directory dump
> >    <li> calls <b>dirattr_init</b> if necessary
> >    <li> calls <b>namreg_init</b> if necessary
> > -  <li> initialize the directory tree (<b>tree_init</b>)
> > -  <li> read the dirents into the tree
> > +  <li> initialize the directory tree (<b>tree_init</b>)
> > +  <li> read the dirents into the tree
> >         (<a href="#applydirdump"><b>applydirdump</b></a>)
> >    </ul>
> >
> > @@ -866,17 +866,17 @@ Initialize the mmap files of:
> >
> >  <li> all threads can process each media file of their dumps for
> >    restoring the non-directory files
> > -  <ul>
> > -  <li>loop over each media file
> > +  <ul>
> > +  <li>loop over each media file
> >       <ul>
> >       <li> read in file header
> > -     <li> call <b>applynondirdump</b> for file hdr
> > -	 <ul>
> > -	 <li> restore extended attributes for file
> > -	      (if it is last extent group of file)
> > +     <li> call <b>applynondirdump</b> for file hdr
> > +	 <ul>
> > +	 <li> restore extended attributes for file
> > +	      (if it is last extent group of file)
> >  	 <li> restore file
> >  	    <ul>
> > -	    <li>loop thru all hardlink paths from tree for inode
> > +	    <li>loop thru all hardlink paths from tree for inode
> >                  (<b>tree_cb_links</b>) and call <b>restore_file_cb</b>
> >                  <ul>
> >                  <li> if a hard link then link(path1, path2)
> > @@ -890,11 +890,11 @@ Initialize the mmap files of:
> >                        <li>set DMAPI fields if necessary
> >                        <li>loop processing the extent headers
> >                           <ul>
> > -                         <li>if type LAST then exit loop
> > +                         <li>if type LAST then exit loop
> >                           <li>if type ALIGN then eat up the padding
> >                           <li>if type HOLE then ignore
> > -                         <li>if type DATA then copy the data into
> > -                             the file for the extent;
> > +                         <li>if type DATA then copy the data into
> > +                             the file for the extent;
> >                               seeking to extent start if necessary
> >                           </ul>
> >                        <li>register the extent group in the partial registry
> > @@ -917,9 +917,9 @@ Initialize the mmap files of:
> >  	   <li> if corrupt then go to next mark
> >  	   <li> else exit loop
> >  	   </ul>
> > -	 </ul>
> > +	 </ul>
> >       </ul>
> > -  </ul>
> > +  </ul>
> >
> >  <li> one stream does while others wait:
> >    <ul>
> > @@ -937,7 +937,7 @@ Initialize the mmap files of:
> >  <b>content_init</b> in a bit more detail(xfsrestore version)
> >  <ul>
> >  <li> create house-keeping-directory for persistent mmap file data
> > -  structures. For cumulative and interrupted restores,
> > +  structures. For cumulative and interrupted restores,
> >    we need to keep restore session data between invocations of xfsrestore.
> >  <li> mmap the "state" file and create if not already existing.
> >    Initially just mmap the header.  (More details below)
> > @@ -969,14 +969,14 @@ Initialize the mmap files of:
> >  <h4><a name="pers_inv">Persistent Inventory and State File</a></h4>
> >
> >  The persistent inventory is found inside the "state" file.
> > -The state file is an mmap'ed file called
> > +The state file is an mmap'ed file called
> >  <b>$dstdir/xfsrestorehousekeepingdir/state</b>.
> > -The state file (<i>struct pers</i> from content.c) contains
> > +The state file (<i>struct pers</i> from content.c) contains
> >  a header of:
> >  <ul>
> >  <li>command line arguments from 1st session,
> >  <li>partial registry data structure for use with multiple streams
> > -    and extended attributes,
> > +    and extended attributes,
> >  <li>various session state such as
> >      dumpid, dump label, number of inodes restored so far, etc.
> >  </ul>
> > @@ -1054,7 +1054,7 @@ tree of directory nodes. This tree can then be used to associate
> >  the file with it's directory and so restored to the correct location
> >  in the directory structure.
> >  <p>
> > -The tree is an mmap'ed file called
> > +The tree is an mmap'ed file called
> >  <b>$dstdir/xfsrestorehousekeepingdir/tree</b>.
> >  Different sections of it will be mmap'ed separately.
> >  It is of the following format:
> > @@ -1098,7 +1098,7 @@ chained hash table with the "next" link stored in the tree node
> >  in the <i>n_hashh</i> field of struct node in restore/tree.c.
> >  The size of the hash table is based on the number of directories
> >  and non-directories (which will approximate the number of directory
> > -entries - won't include extra hard links). The size of the table
> > +entries - won't include extra hard links). The size of the table
> >  is capped below at 1 page and capped above at virtual-memory-limit/4/8
> >  (i.e. vmsz/32) or the range of 2^32 whichever is the smaller.
> >  <p>
> > @@ -1157,15 +1157,15 @@ each node using the first 8 bytes (ignoring node fields).
> >  | |      | |
> >  | | 8192 | |
> >  | | nodes| |   nodes already used in tree
> > -| | used | |
> > -| |      | |
> > +| | used | |
> > +| |      | |
> >  | |------| |
> >  |          |
> > -| |------| |
> > +| |------| |
> >  | |   --------| <-----nh_freenix (ptr to node-freelist)
> >  | |node1 | |  |
> > -| |------| |  | node-freelist (linked list of free nodes)
> > -| |   ----<---|
> > +| |------| |  | node-freelist (linked list of free nodes)
> > +| |   ----<---|
> >  | |node2 | |
> >  | |------| |
> >  ............
> > @@ -1176,7 +1176,7 @@ each node using the first 8 bytes (ignoring node fields).
> >
> >
> >  <h5><a name="win_abs">Window Abstraction</a></h5>
> > -The window abstraction manages the mapping and unmapping of the
> > +The window abstraction manages the mapping and unmapping of the
> >  segments (of nodes) of the dirent tree.
> >  In the node allocation, mentioned above, if our node-freelist is
> >  empty we call <i><b>win_map()</b></i> to map in a chunk of 8192 nodes
> > @@ -1185,8 +1185,8 @@ for the node-freelist.
> >  Consider the <i><b>win_map</b>(offset, return_memptr)</i> function:
> >  <pre>
> >  One is asking for an offset within a segment.
> > -It looks up its <i>bag</i> for the segment (given the offset), and
> > -if it's already mapped then
> > +It looks up its <i>bag</i> for the segment (given the offset), and
> > +if it's already mapped then
> >      if the window has a refcnt of zero, then remove it from the win-freelist
> >      it uses that address within the mmap region and
> >      increments refcnt.
> > @@ -1194,7 +1194,7 @@ else if it's not in the bag then
> >      if win-freelist is not empty then
> >          munmap the oldest mapped segment
> >  	remove head of win-freelist
> > -        remove the old window from the bag
> > +        remove the old window from the bag
> >      else /* empty free-list */
> >          allocate a new window
> >      endif
> > @@ -1214,9 +1214,9 @@ in the node allocation.
> >  Note that the windows are stored in 2 lists. They are doubly
> >  linked in the LRU win-freelist and are also stored in a <i>bag</i>.
> >  A bag is just a doubly linked searchable list where
> > -the elements are allocated using <i>calloc()</i>.
> > +the elements are allocated using <i>calloc()</i>.
> >  It uses the bag as a container of mmaped windows which can be
> > -searched using the bag key of window-offset.
> > +searched using the bag key of window-offset.
> >  <pre>
> >
> >  BAG:  |--------|     |--------|     |--------|     |--------|     |-------|
> > @@ -1239,7 +1239,7 @@ win-freelist:   | oldest |               | 2nd    |
> >  <p>
> >  <b>Call Chain</b><br>
> >
> > -Below are some call chain scenarios of how the allocation of
> > +Below are some call chain scenarios of how the allocation of
> >  dirent tree nodes are done at different stages.
> >  <p>
> >  <pre>
> > @@ -1269,7 +1269,7 @@ applydirdump()
> >             node_alloc()
> >               get node off node-freelist (8190 nodes left now)
> >               return node
> > -
> > +
> >  8193th time when we have used up 8192 nodes and node-freelist is emtpy:
> >
> >        if new entry then
> > @@ -1282,13 +1282,13 @@ applydirdump()
> >                   refcnt++
> >                   return addr
> >               make a node-freelist of 8192 nodes from where left off last time
> > -             win_unmap
> > +             win_unmap
> >                 refcnt--
> >                 put on LRU win-freelist as refcnt==0
> >               get node off node-freelist (8191 nodes left now)
> >               return node
> > -
> > -When whole segment used up and thus all remaining node-freelist
> > +
> > +When whole segment used up and thus all remaining node-freelist
> >  nodes are gone then
> >  (i.e. in old scheme would have used up all 1 million nodes
> >   from first segment):
> > @@ -1332,7 +1332,7 @@ and adding to the tree and other auxiliary structures:
> >
> >  <a name="applydirdump"><b>applydirdump</b>()</a>
> >    ...
> > -  inomap_restore_pers() - read ino map
> > +  inomap_restore_pers() - read ino map
> >    read directories and their entries
> >      loop 'til null hdr
> >         dirh = <b>tree_begindir</b>(fhdr, dah) - process dir filehdr
> > @@ -1352,7 +1352,7 @@ and adding to the tree and other auxiliary structures:
> >      new directory - 1st time seen
> >      dah = dirattr_add(fhdrp) - add dir header to dirattr structure
> >      hardh = Node_alloc(ino, gen,....,NF_ISDIR|NF_NEWORPH)
> > -    link_in(hardh) - link into tree
> > +    link_in(hardh) - link into tree
> >      adopt(p_orphh, hardh, NRH_NULL) - put dir in orphanage directory
> >    else
> >      ...
> > @@ -1379,12 +1379,12 @@ and adding to the tree and other auxiliary structures:
> >  A cumulative restore seems a bit different than one might expect.
> >  It tries to restore the state of the filesystem at the time of
> >  the incremental dump. As the man page states:
> > -"This can involve adding, deleting, renaming, linking,
> > +"This can involve adding, deleting, renaming, linking,
> >   and unlinking files and directories." From a coding point of view,
> >  this means we need to know what the dirent tree was like previously
> >  compared with what the dirent tree is like now. We need this so
> > -we can see what was added and deleted. So this means that the
> > -dirent tree, which is stored as an mmap'ed file in
> > +we can see what was added and deleted. So this means that the
> > +dirent tree, which is stored as an mmap'ed file in
> >  <i>restoredir/xfsrestorehousekeepingdir/tree</i> should not be deleted
> >  between cumulative restores (as we need to keep using it).
> >  <p>
> > @@ -1396,8 +1396,8 @@ dirents, it looks them up in the tree (created on previous restore).
> >  If the entry alreadys exists then it marks it as <i>NF_REFED</i>.
> >  <p>
> >  In case a dirent has gone away between times of incremental dumps,
> > -xfsrestore does an extra pass in the tree preprocessing
> > -which traverses the tree looking for non-referenced (not <i>NF_REFED</i>)
> > +xfsrestore does an extra pass in the tree preprocessing
> > +which traverses the tree looking for non-referenced (not <i>NF_REFED</i>)
> >  nodes so that if they exist in the FS (i.e. are <i>NF_REAL</i>) then
> >  they can be deleted (so that the FS resembles what it was at the time
> >  of the incremental dump).
> > @@ -1418,7 +1418,7 @@ cumulative restoral, it does a 4 step postprocessing (<b>treepost</b>):
> >     <td><b>1. noref_elim_recurse</b></td>
> >     <td><ul>
> >     <li>remove deleted dirs
> > -   <li>rename moved dirs to orphanage
> > +   <li>rename moved dirs to orphanage
> >     <li>remove extra deleted hard links
> >     <li>rename moved non-dirs to orphanage
> >     </ul></td>
> > @@ -1443,7 +1443,7 @@ cumulative restoral, it does a 4 step postprocessing (<b>treepost</b>):
> >     <li>create a link on rename error (don't understand this one)
> >     </ul></td>
> >  </tr>
> > -</table>
> > +</table>
> >
> >  <p>
> >  Step 1 was changed so that files which are deleted and not moved
> > @@ -1459,13 +1459,13 @@ The new step is:
> >     <td><b>1. noref_elim_recurse</b></td>
> >     <td><ul>
> >     <li>remove deleted dirs
> > -   <li>rename moved dirs to orphanage
> > +   <li>rename moved dirs to orphanage
> >     <li>remove extra deleted hard links
> >     <li>rename moved non-dirs to orphanage
> >     <li>remove deleted non-dirs which aren't part of a rename
> >     </ul></td>
> >  </tr>
> > -</table>
> > +</table>
> >  <p>
> >  One will notice that renames are not performed directly.
> >  Instead entries are renamed to the orphanage, directories are
> > @@ -1481,12 +1481,12 @@ should not happen now since it is done earlier.
> >  <hr>
> >  <h4><a name="partial_reg">Partial Registry</a></h4>
> >
> > -The partial registry is a data structure used in <i>xfsrestore</i>
> > -for ensuring that files which have been split into multiple extent groups,
> > +The partial registry is a data structure used in <i>xfsrestore</i>
> > +for ensuring that files which have been split into multiple extent groups,
> >  do not restore the extended attributes until the entire file has been
> >  restored. The reason for this is apparently so that DMAPI attributes
> >  aren't restored until we have the complete file. Each extent group dumped
> > -has the identical copy of the extended attributes (EAs) for that file,
> > +has the identical copy of the extended attributes (EAs) for that file,
> >  thus without this data-structure we could apply the first EAs we come across.
> >  <p>
> >  The data structure is of the form:
> > @@ -1535,8 +1535,8 @@ then the extent range for this file is updated with the partial
> >  registry. If the file doesn't exist in the array then a new entry is
> >  added. If the file does exist in the array then the extent group for
> >  the given drive is updated. It is worth remembering that one drive
> > -(stream) can have multiple extent groups (if it is >16Mb) in which
> > -case the extent group is just extended (they are split up in order).
> > +(stream) can have multiple extent groups (if it is >16Mb) in which
> > +case the extent group is just extended (they are split up in order).
> >  <p>
> >  A bug was discovered in this area of code, for <i>DMF offline</i> files
> >  which have an associated file size but no data blocks allocated and
> > @@ -1550,7 +1550,7 @@ restore data are now special cased.
> >
> >  <h3><a name="drive_strategy">Drive Strategies</a></h3>
> >  The I/O which happens when reading and writing the dump
> > -can be to a tape, file, stdout or
> > +can be to a tape, file, stdout or
> >  to a tape remotely via rsh(1) (or $RSH)  and rmt(1) (or $RMT).
> >  There are 3 pieces of code called strategies which
> >  handle the dump I/O:
> > @@ -1600,8 +1600,8 @@ The scoring function is called ds_match.
> >     with path (not available on Linux), score -10 if the following:
> >  	<ul>
> >  	<li>stat fails
> > -	<li>it is not a character device
> > -	<li>its real path does not contain "/nst", "/st" nor "/mt".
> > +	<li>it is not a character device
> > +	<li>its real path does not contain "/nst", "/st" nor "/mt".
> >  	</ul>
> >     </td>
> >  </tr>
> > @@ -1644,29 +1644,29 @@ The scoring function is called ds_match.
> >  Each strategy is organised like a "class" with functions/methods
> >  in the data structure:
> >  <pre>
> > -        do_init,
> > -        do_sync,
> > -        do_begin_read,
> > -        do_read,
> > -        do_return_read_buf,
> > -        do_get_mark,
> > -        do_seek_mark,
> > -        do_next_mark,
> > -        do_end_read,
> > -        do_begin_write,
> > -        do_set_mark,
> > -        do_get_write_buf,
> > -        do_write,
> > -        do_get_align_cnt,
> > -        do_end_write,
> > -        do_fsf,
> > -        do_bsf,
> > -        do_rewind,
> > -        do_erase,
> > -        do_eject_media,
> > -        do_get_device_class,
> > -        do_display_metrics,
> > -        do_quit,
> > +        do_init,
> > +        do_sync,
> > +        do_begin_read,
> > +        do_read,
> > +        do_return_read_buf,
> > +        do_get_mark,
> > +        do_seek_mark,
> > +        do_next_mark,
> > +        do_end_read,
> > +        do_begin_write,
> > +        do_set_mark,
> > +        do_get_write_buf,
> > +        do_write,
> > +        do_get_align_cnt,
> > +        do_end_write,
> > +        do_fsf,
> > +        do_bsf,
> > +        do_rewind,
> > +        do_erase,
> > +        do_eject_media,
> > +        do_get_device_class,
> > +        do_display_metrics,
> > +        do_quit,
> >  </pre>
> >
> >  <h4><a name="drive_scsitape">Drive Scsitape</a></h4>
> > @@ -1680,10 +1680,10 @@ If xfsdump/xfsrestore is running single-threaded (-Z option)
> >  or is running on Linux (which is not multi-threaded) then
> >  records are read/written straight to the tape. If it is running
> >  multi-threaded then a circular buffer is used as an intermediary
> > -between the client and slave threads.
> > +between the client and slave threads.
> >  <p>
> > -Initially <i>drive_init1()</i> calls <i>ds_instantiate()</i> which
> > -if dump/restore is running multi-threaded,
> > +Initially <i>drive_init1()</i> calls <i>ds_instantiate()</i> which
> > +if dump/restore is running multi-threaded,
> >  creates the ring buffer with <i>ring_create</i> which initialises
> >  the state to RING_STAT_INIT and sets up the slave thread with
> >  ring_slave_entry.
> > @@ -1720,7 +1720,7 @@ Prior to reading, one needs to call <i>do_begin_read()</i>,
> >  which calls <i>prepare_drive()</i>. <i>prepare_drive()</i> opens
> >  the tape drive if necessary and gets its status.
> >  It then works out the tape record size to use
> > -(<i>set_best_blk_and_rec_sz</i>) using
> > +(<i>set_best_blk_and_rec_sz</i>) using
> >  current max blksize (mtinfo.maxblksz from ioctl(fd,MTIOCGETBLKINFO,minfo))
> >  on the scsi tape device in IRIX.
> >
> > @@ -1737,7 +1737,7 @@ remote tape -> tape_recsz = STAPE_MIN_MAX_BLKSZ = 240 Kb
> >  On Linux:
> >  <ul>
> >  <li>
> > -local tape ->
> > +local tape ->
> >      <ul>
> >      <li>
> >      tape_recsz = STAPE_MAX_LINUX_RECSZ = 1 Mb<br>
> > @@ -1750,7 +1750,7 @@ remote tape -> tape_recsz = STAPE_MIN_MAX_BLKSZ = 240 Kb
> >  </ul>
> >  <p>
> >  If we have a fixed size device, then it tries to read
> > -initially at minimum(2Mb, current max blksize)
> > +initially at minimum(2Mb, current max blksize)
> >  but if it reads in a smaller number of bytes than this,
> >  then it will try again for STAPE_MIN_MAX_BLKSZ = 240 Kb data.
> >
> > @@ -1766,7 +1766,7 @@ prepare_drive()
> >        else fixed blksize then
> >  	 ok = nread==tape_recsz & !EOD & !EOT & !FileMark
> >        endif
> > -      if ok then
> > +      if ok then
> >  	validate_media_file_hdr()
> >        else
> >          could be an error or try again with newsize
> > @@ -1802,14 +1802,14 @@ client
> >  do_read()
> >    getrec()
> >      singlethreaded -> read_record() -> Read()
> > -    else ->
> > +    else ->
> >        loop 'til contextp->dc_recp is set to a buffer
> >  	Ring_get() -> ring.c/ring_get()
> >  	  remove msg from ready queue
> >  	      block on ready queue - qsemP( ringp->r_ready_qsemh )
> >  	      msgp = &ringp->r_msgp[ ringp->r_ready_out_ix ];
> >  	      cyclic_inc(ringp->r_ready_out_ix)
> > -        case rm_stat:
> > +        case rm_stat:
> >  	  RING_STAT_INIT, RING_STAT_NOPACK, RING_STAT_IGNORE
> >              put read msg on active queue
> >  		contextp->dc_msgp->rm_op = RING_OP_READ
> > @@ -1818,7 +1818,7 @@ do_read()
> >              contextp->dc_recp = contextp->dc_msgp->rm_bufp
> >            ...
> >          endcase
> > -      endloop
> > +      endloop
> >  </pre>
> >
> >  <h4><a name="librmt">Librmt</a></h4>
> > @@ -1835,21 +1835,21 @@ On linux, a librmt library is provided as part of the
> >  xfsdump distribution.
> >  The remote functions are used to dump/restore to remote
> >  tape drives on remote machines. It does this by using
> > -rsh or ssh to run rmt(1) on the remote machine.
> > +rsh or ssh to run rmt(1) on the remote machine.
> >  The main caveat, however, comes into play for the <i>rmtioctl</i>
> >  function.  Unfortunately, the values for mt operations and status
> > -codes are different on different machines.
> > +codes are different on different machines.
> >  For example, the offline command op
> >  on IRIX is 6 and on Linux it is 7. On Linux, 6 is rewind and
> > -on IRIX 7 is a no-op.
> > +on IRIX 7 is a no-op.
> >  So for the Linux xfsdump, the <i>rmtiocl</i> function has been rewritten
> > -to check what the remote OS is (e.g. <i>rsh host uname</i>)
> > -and do appropriate mappings of codes.
> > +to check what the remote OS is (e.g. <i>rsh host uname</i>)
> > +and do appropriate mappings of codes.
> >  As well as the different mt op codes, the mtget structures
> >  differ for IRIX and Linux and for Linux 32 bit and Linux 64 bit.
> > -The size of the mtget structure is used to determine which
> > +The size of the mtget structure is used to determine which
> >  structure it is and the value of <i>mt_type</i> is used to
> > -determine if endian conversion needs to be done.
> > +determine if endian conversion needs to be done.
> >  <p>
> >
> >  <h4><a name="drive_minrmt">Drive Minrmt</a></h4>
> > @@ -1863,13 +1863,13 @@ as a parameter. It was designed for talking
> >  to remote NON-IRIX hosts where the status codes can vary.
> >  However, as was mentioned in the discussion of librmt on Linux,
> >  the mt operations vary on foreign hosts as well as the status
> > -codes. So this is only a limited solution.
> > +codes. So this is only a limited solution.
> >
> >  <h4><a name="drive_simple">Drive Simple</a></h4>
> >  The simple strategy was designed for dumping to files
> >  or stdout. It is simpler in that it does <b>NOT</b> have to worry
> >  about:
> > -<ul>
> > +<ul>
> >  <li>the ring buffer
> >  <li>talking to the scsitape driver with various operations and status
> >  <li>multiple media files
> > @@ -1879,7 +1879,7 @@ about:
> >  <hr>
> >  <h3><a name="inventory">Online Inventory</a></h3>
> >  xfsdump keeps a record of previous xfsdump executions in the online inventory
> > -stored in /var/xfsdump/inventory or for Linux, /var/lib/xfsdump/inventory.
> > +stored in /var/xfsdump/inventory or for Linux, /var/lib/xfsdump/inventory.
> >  This inventory is used to determine which previous dump a incremental dump
> >  should be based on.  That is, when doing a level > 0 dump for a filesystem,
> >  xfsdump will refer to the online inventory to work out when the last dump for
> > @@ -1928,7 +1928,7 @@ The files are constructed like so:
> >    <th>Data structure</th>
> >  </tr>
> >  	<tr>
> > -  	<td>1</td>
> > +	<td>1</td>
> >      <td>
> >  <pre>
> >  typedef struct invt_counter {
> > @@ -1943,10 +1943,10 @@ typedef struct invt_counter {
> >  } invt_counter_t;
> >  </pre>
> >  		</td>
> > - 	</tr>
> > +	</tr>
> >  	<tr>
> > -  	<td>1 per filesystem</td>
> > -  	<td>
> > +	<td>1 per filesystem</td>
> > +	<td>
> >  <pre>
> >  typedef struct invt_fstab {
> >      uuid_t  ft_uuid;
> > @@ -1956,7 +1956,7 @@ typedef struct invt_fstab {
> >  } invt_fstab_t;
> >  </pre>
> >  		</td>
> > - 	</tr>
> > +	</tr>
> >  </table>
> >
> >
> > @@ -1968,7 +1968,7 @@ typedef struct invt_fstab {
> >    <th>Data structure</th>
> >  </tr>
> >  	<tr>
> > -  	<td>1</td>
> > +	<td>1</td>
> >      <td>
> >  <pre>
> >  typedef struct invt_counter {
> > @@ -1982,10 +1982,10 @@ typedef struct invt_counter {
> >  } invt_counter_t;
> >  </pre>
> >  		</td>
> > - 	</tr>
> > +	</tr>
> >  	<tr>
> > -  	<td>1 per StObj file</td>
> > -  	<td>
> > +	<td>1 per StObj file</td>
> > +	<td>
> >  <pre>
> >  typedef struct invt_entry {
> >      invt_timeperiod_t ie_timeperiod;
> > @@ -1994,7 +1994,7 @@ typedef struct invt_entry {
> >  } invt_entry_t;
> >  </pre>
> >  		</td>
> > - 	</tr>
> > +	</tr>
> >  </table>
> >
> >  <h4>StObj</h4>
> > @@ -2005,7 +2005,7 @@ typedef struct invt_entry {
> >    <th>Data structure</th>
> >  </tr>
> >  	<tr>
> > -  	<td>1</td>
> > +	<td>1</td>
> >      <td>
> >  <pre>
> >  typedef struct invt_sescounter {
> > @@ -2021,11 +2021,11 @@ typedef struct invt_sescounter {
> >  } invt_sescounter_t;
> >  </pre>
> >  		</td>
> > - 	</tr>
> > +	</tr>
> >  	<tr>
> > -  	<td>fixed space for<br>
> > +	<td>fixed space for<br>
> >          INVT_STOBJ_MAXSESSIONS (ie. 5)</td>
> > -  	<td>
> > +	<td>
> >  <pre>
> >  typedef struct invt_seshdr {
> >      off64_t    sh_sess_off;    /* offset to rest of the sessioninfo */
> > @@ -2039,11 +2039,11 @@ typedef struct invt_seshdr {
> >  } invt_seshdr_t;
> >  </pre>
> >  		</td>
> > - 	</tr>
> > +	</tr>
> >  	<tr>
> > -  	<td>fixed space for<br>
> > +	<td>fixed space for<br>
> >          INVT_STOBJ_MAXSESSIONS (ie. 5)</td>
> > -  	<td>
> > +	<td>
> >  <pre>
> >  typedef struct invt_session {
> >      uuid_t   s_sesid;	/* this session's id: 16 bytes*/
> > @@ -2053,14 +2053,14 @@ typedef struct invt_session {
> >      char     s_devpath[INV_STRLEN];/* path to the device */
> >      u_int    s_cur_nstreams;/* number of streams created under
> >                                 this session so far */
> > -    u_int    s_max_nstreams;/* number of media streams in
> > +    u_int    s_max_nstreams;/* number of media streams in
> >                                 the session */
> >      char     s_padding[16];
> >  } invt_session_t;</pre>
> >  		</td>
> > - 	</tr>
> > +	</tr>
> >    <tr>
> > -  	<td rowspan=2>any number</td>
> > +	<td rowspan=2>any number</td>
> >  	  <td>
> >  <pre>
> >  typedef struct invt_stream {
> > @@ -2078,7 +2078,7 @@ typedef struct invt_stream {
> >  } invt_stream_t;
> >  </pre>
> >  		</td>
> > -	</tr>
> > +	</tr>
> >  	<tr>
> >  		<td>
> >  <pre>
> > @@ -2086,7 +2086,7 @@ typedef struct invt_mediafile {
> >      uuid_t           mf_moid;	    /* media object id */
> >      char             mf_label[INV_STRLEN];	/* media file label */
> >      invt_breakpt_t   mf_startino; /* file that we started out with */
> > -    invt_breakpt_t   mf_endino;	  /* the dump file we ended this
> > +    invt_breakpt_t   mf_endino;	  /* the dump file we ended this
> >                                       media file with */
> >      off64_t          mf_nextmf;   /* links to other mfiles */
> >      off64_t          mf_prevmf;
> > @@ -2096,7 +2096,7 @@ typedef struct invt_mediafile {
> >      char             mf_padding[15];
> >  } invt_mediafile_t;
> >  </pre>
> > -  	</td>
> > +	</td>
> >    </tr>
> >  </table>
> >
> > @@ -2123,12 +2123,12 @@ and modify the inventory.
> >  If -a is NOT used then it looks like nothing special happens
> >  for files which have dmf state attached to them.
> >  So if the file uses too many blocks compared to our maxsize param (-z)
> > -then it will not get dumped. No inode nor data.
> > +then it will not get dumped. No inode nor data.
> >  The only evidence will be its entry in the inode
> >  map (which is dumped) which says its the state of a no-change-non-dir and
> >  the directory entry in the directories dump. The latter will mean
> >  that an <i>ls</i> in xfsrestore will show the file but it can
> > -not be restored.
> > +not be restored.
> >  <p>
> >  If -a <b>is</b> used and the file has some DMF state then we do some magic.
> >  However, the magic really only seems to occur for dual-state files
> > @@ -2138,7 +2138,7 @@ A file is marked as dual-state/unmigrating by looking at the DMF attribute,
> >  dmfattrp->state[1]. i.e = DMF_ST_DUALSTATE or DMF_ST_UNMIGRATING
> >  If this is the case, then we set, dmf_f_ctxtp->candidate = 1.
> >  If we have such a changed dual-state file then we
> > -mark it as changed in the inode-map so it can be dumped.
> > +mark it as changed in the inode-map so it can be dumped.
> >  If it is a dual state file, then its apparent size will be zero, so it
> >  will go onto the dumping stage.
> >  <p>
> > @@ -2162,7 +2162,7 @@ and add a new DMF attribute for it:
> >  <br>
> >  <b>Summary:</b>
> >  <ul>
> > -<li>dual state files (and unmigrating files) dumped with -a,
> > +<li>dual state files (and unmigrating files) dumped with -a,
> >      cause magic to happen:
> >      <ul>
> >      <li>if file has changed then it will _always_ be marked
> > @@ -2175,7 +2175,7 @@ and add a new DMF attribute for it:
> >  <li>for all other cases,
> >       if the file has changed and its blocks cause it to exceed the
> >       maxsize param (-z) then the file will be marked as NOT-CHANGED
> > -     in the inode map and so will NOT be dumped at all
> > +     in the inode map and so will NOT be dumped at all
> >  </ul>
> >  <p>
> >
> > @@ -2196,7 +2196,7 @@ its entries <inode#,gen#,entry-sz,csum,entry-name>
> >  and extended-attribute header and attributes.
> >  <p>
> >  A non-directory file consists of a file header, extent-headers
> > -(for each extent), file data and extended-attribute header
> > +(for each extent), file data and extended-attribute header
> >  and attributes. Some types of files don't have extent headers or data.
> >  <p>
> >  The xfsdump code says:
> > @@ -2217,7 +2217,7 @@ So this accounts for the:
> >    <li>global header
> >    <li>inode map
> >    <li>all the files
> > -  <li>all the direntory entries
> > +  <li>all the direntory entries
> >       ( "+8" presumably to account for average file name length range,
> >         where 8 chars already included in header; as this structure
> >         is padded to the next 8 byte boundary, it accounts for names
> > @@ -2253,7 +2253,7 @@ It includes for each file:
> >  <ul>
> >    <li>any hole hdrs
> >    <li>alignment hdrs
> > -  <li>alignment padding
> > +  <li>alignment padding
> >    <li>extent headers for data
> >    <li>actual _data_ of extents
> >  </ul>
> > @@ -2267,7 +2267,7 @@ From code:
> >  	bytecnt += sizeof( extenthdr_t );  /* ext. alignment header */
> >  	bytecnt += ( off64_t )cnt_to_align /* alignment padding */
> >  	bytecnt += sizeof( extenthdr_t );  /* extent header for data */
> > -	bytecnt += ( off64_t )actualsz;    /* actual extent data in file */
> > +	bytecnt += ( off64_t )actualsz;    /* actual extent data in file */
> >  	bytecnt += ( off64_t )reqsz; /* write padding to make up extent size */
> >      sc_stat_datadone += ( size64_t )bc;
> >  </pre>
> > @@ -2285,7 +2285,7 @@ nor the extent hdr terminator:
> >      contextp->cc_mfilesz += bytecnt;
> >  </pre>
> >  It only adds this data size into the media file size.
> > -
> > +
> >  </dl>
> >  <p>
> >  <hr>
> > @@ -2297,7 +2297,7 @@ It only adds this data size into the media file size.
> >  <li>What is the difference between a record and a block ?
> >      <ul><li>I don't think there is a difference.</ul>
> >  <li>Where are tape_recsz and tape_blksz used ?
> > -    <ul><li>Tape_recsz is used for the read/write byte cnt but
> > +    <ul><li>Tape_recsz is used for the read/write byte cnt but
> >      I don't think tape_blksz is used.</ul>
> >  <li>What is the persistent inventory used for ?
> >  </ul>
> > diff --git a/po/de.po b/po/de.po
> > index 62face8..142f68f 100644
> > --- a/po/de.po
> > +++ b/po/de.po
> > @@ -446,8 +446,8 @@ msgstr ""
> >  "zurück, Fehlernummer %d (%s)\n"
> >
> >  #: .././common/drive_minrmt.c:3823
> > -msgid "slave"
> > -msgstr "Slave"
> > +msgid "worker"
> > +msgstr "Worker"
> 
> I think this ^^ hunk belongs in the next patch.

Yeah, stg refresh going wrong, I'll fix that and resubmit, thanks for the
review.

> 
> The rest LGTM,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> >
> >  #: .././common/drive_minrmt.c:3891 .././common/drive_minrmt.c:3899
> >  msgid "KB"
> >
> >

-- 
Carlos Maiolino
