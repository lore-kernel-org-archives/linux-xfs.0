Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9L3wfu5175799 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 22:58:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BFD311325F
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 20:59:55 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gIcmLrcMmehpb9nL for
	<xfs@oss.sgi.com>; Wed, 20 Oct 2010 20:59:55 -0700 (PDT)
Date: Wed, 20 Oct 2010 23:59:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdocs-xml: fix various formatting errors
Message-ID: <20101021035954.GA28924@infradead.org>
References: <20101008094412.GA7118@infradead.org>
MIME-Version: 1.0
In-Reply-To: <20101008094412.GA7118@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0666440869082322286=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Turbo Fredriksson <turbo@bayour.com>

--===============0666440869082322286==
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

ping?

On Fri, Oct 08, 2010 at 05:44:12AM -0400, Christoph Hellwig wrote:
> 
> Fix up a few formatting errors pointed out by Turbo Fredriksson, and while
> at it also remove various non-ASCII characters that sneaked in during the
> initial conversion
> 
> Reported-by: Turbo Fredriksson <turbo@bayour.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfsdocs-xml-dev/XFS_User_Guide/en-US/XFS-allocators.xml
> ===================================================================
> --- xfsdocs-xml-dev.orig/XFS_User_Guide/en-US/XFS-allocators.xml	2010-10-08 11:34:40.466254229 +0200
> +++ xfsdocs-xml-dev/XFS_User_Guide/en-US/XFS-allocators.xml	2010-10-08 11:35:13.097254021 +0200
> @@ -21,7 +21,8 @@
>  		<para>Watch the inode numbers as directory inodes are created:</para>
>  		<para><programlisting>
>  > mkdir a b
> -> ls -li total 0
> +> ls -li
> +total 0
>       131 drwxr-xr-x 2 sjv users 6 2006-10-20 12:12 a
>  33554624 drwxr-xr-x 2 sjv users 6 2006-10-20 12:12 b</programlisting></para>
>  	</section>
> Index: xfsdocs-xml-dev/XFS_User_Guide/en-US/XFS-monitoring.xml
> ===================================================================
> --- xfsdocs-xml-dev.orig/XFS_User_Guide/en-US/XFS-monitoring.xml	2010-10-08 11:34:40.489262122 +0200
> +++ xfsdocs-xml-dev/XFS_User_Guide/en-US/XFS-monitoring.xml	2010-10-08 11:37:24.712028291 +0200
> @@ -41,7 +41,7 @@ ig_found		# of times inode found in memo
>  ig_frecycle		# of fails because inode was busy 
>  ig_misses		# of times had to go to disk for inode 
>  ig_dup			# times missed but found from another
> -ig_reclaims		# of times recyled the inode’s memory 
> +ig_reclaims		# of times recyled the inode's memory
>  ig_attrchngx		# of times changed inode attributes 
>  iflush_count		# of times inodes are being flushed 
>  icluster_flushcnt	# of times inodes clustered
> @@ -54,16 +54,16 @@ icluster_flushinode	# of times not able
>  lookup			# of file name directory lookups 
>  create			# of directory entry creations 
>  remove			# of directory entry removes 
> -getdents		# of “getdent” operations</programlisting></para>
> +getdents		# of "getdents" operations</programlisting></para>
>  	</section>
>  
>  	<section>
>  		<title>PCP File Attribute Metrics</title>
>  		<para><programlisting>
> -attr.get		# of “get” operations		
> -attr.set		# of “set” operations
> -attr.remove		# of “remove” operations
> -attr.list		# of “list” operations</programlisting></para>
> +attr.get		# of "get" operations
> +attr.set		# of "set" operations
> +attr.remove		# of "remove" operations
> +attr.list		# of "list" operations</programlisting></para>
>  	</section>
>  
>  	<section>
> @@ -84,7 +84,7 @@ alloc_btree.delrec	# of extent record de
>  		<para><programlisting>
>  block_map.read_ops	# of block map reads
>  block_map.write_ops	# of block map writes
> -block_map.unmap	# of block delete operations
> +block_map.unmap		# of block delete operations
>  block_map.add_exlist 	# of extent list insertions for files
>  block_map.del_exlist	# of extent list deletions
>  block_map.look_exlist	# of extent list lookups
> @@ -98,7 +98,7 @@ bmap_btree.delrec	# of block map deletio
>  	<section>
>  		<title>PCP Journaling Metrics</title>
>  		<para><programlisting>
> -transaction.sync		# of transactions waiting to be committed
> +transaction.sync	# of transactions waiting to be committed
>  transaction.async	# of async transactions waiting
>  transaction.empty	# of transactions that did not do anything
>  log.writes		# of log buffer writes
> @@ -113,7 +113,7 @@ log.force_sleep		# of calls to xs_log_fo
>  		<para><programlisting>
>  push_ail.pushes		# of times the AIL is moved forward
>  push_ail.success	# of times sucessful
> -push_ail.pushbuf	# of times inode locked – pushbuf called
> +push_ail.pushbuf	# of times locked "pushbuf" called
>  push_ail.pinned		# of times pinned
>  push_ail.locked		# of times locked
>  push_ail.flushing	# of times ail was flushing
> @@ -125,7 +125,7 @@ push_ail.flush		# of times a log was for
>  		<title>PCP Quota Metrics</title>
>  		<para><programlisting>
>  reclaims		# of disk quota reclaims
> -reclaims_misses	# of disk quota reclaim misses
> +reclaims_misses		# of disk quota reclaim misses
>  dquot_dups		# of duplicates
>  cachemisses		# of times disk quota misses cache
>  cachehits		# of times disk quota in cache
> Index: xfsdocs-xml-dev/XFS_User_Guide/en-US/XFS-repair.xml
> ===================================================================
> --- xfsdocs-xml-dev.orig/XFS_User_Guide/en-US/XFS-repair.xml	2010-10-08 11:34:40.474254229 +0200
> +++ xfsdocs-xml-dev/XFS_User_Guide/en-US/XFS-repair.xml	2010-10-08 11:37:12.929255837 +0200
> @@ -5,7 +5,7 @@
>  	<title>XFS Repair</title>
>  	<section>
>  		<title>Filesystems can be corrupted by</title>
> -		<para>• Filesystems can be corrupted by</para>
> +		<para>Filesystems can be corrupted by</para>
>  		<itemizedlist>
>  		<listitem><para>Hardware Errors
>  			<itemizedlist>
> @@ -15,7 +15,7 @@
>  		</para></listitem>
>  		<listitem><para>To a much lesser degree, bugs in the filesystem</para></listitem>
>  		</itemizedlist>
> -		<para>Filesystems are able to “repair” themselves since they consist of lists, links 
> +		<para>Filesystems are able to repair themselves since they consist of lists, links
>  		      and reference counts that can be validated</para>
>  		<itemizedlist>
>  		<listitem><para>But not all information is always recovered, inodes that do not have a 
> @@ -43,17 +43,17 @@
>  		<para>xfs_repair uses libxfs which is a partial port of the XFS kernel code to user-space.</para>
>  	</section>
>  	<section>
> -		<title>xfs_repair – Phase 1</title>
> +		<title>xfs_repair - Phase 1</title>
>  		<para>Find, verify and fix superblocks.</para>
>  		<para>If a superblock is not found, xfs_repair will stop.</para>
>  		<para>Sets up a virtual mount structure for the common XFS code base (libxfs) to work from.</para>
>  	</section>
>  	<section>
> -		<title>xfs_repair – Phase 2</title>
> +		<title>xfs_repair - Phase 2</title>
>  		<para>Checks the AG header structures (AGI, AGF and AGFL) and scans the AGF and AGI btrees.</para>
>  	</section>
>  	<section>
> -		<title>xfs_repair – Phase 3</title>
> +		<title>xfs_repair - Phase 3</title>
>  		<para>Using the AGI btree from phase2, scan the inode tree, processing the unlinked list for 
>  		      deleted inodes and finding possible missing inode clusters.</para>
>  		<para>Walk all the found inodes, recording used filesytem blocks (extents).</para>
> @@ -61,17 +61,17 @@
>  		<para>Any bad inodes are trashed including unrecoverable corrupted directories.</para>
>  	</section>
>  	<section>
> -		<title>xfs_repair – Phase 4</title>
> +		<title>xfs_repair - Phase 4</title>
>  		<para>Scan inode extents again. Any inode with an extent covering used data is trashed.</para>
>  	</section>
>  	<section>
> -		<title>xfs_repair – Phase 5</title>
> +		<title>xfs_repair - Phase 5</title>
>  		<para>Rebuild AG headers and structures including the AGI btree, AGF btrees and AGFL 
>  		      regardless whether any errors have been found or not.</para>
>  		<para>Realtime inodes are also reconstructed.</para>
>  	</section>
>  	<section>
> -		<title>xfs_repair – Phase 6</title>
> +		<title>xfs_repair - Phase 6</title>
>  		<para>At this stage, the filesytem is in a mountable state.</para>
>  		<para>Scan the directories analysing all data.</para>
>  		<itemizedlist>
> @@ -82,12 +82,12 @@
>  		<para>At the end, any unreached inodes are put into lost+found.</para>
>  	</section>
>  	<section>
> -		<title>xfs_repair – Phase 7</title>
> +		<title>xfs_repair - Phase 7</title>
>  		<para>nlinks for inodes are corrected based on the data collected in phase 6.</para>
>  	</section>
>  	<section>
>  		<title>Triaging xfs_check and xfs_repair problems</title>
> -		<para>Mostofthetime,inodeinformationisrequired:</para>
> +		<para>Most of the time, inode information is required:</para>
>  		<para><programlisting>
>  > inode &lt;inode number&gt;
>  > print
> @@ -97,7 +97,7 @@
>  > sb 0
>  > print rootino
>  </programlisting></para>
> -		<para>Fordirectories,wecanalsodumpthecontentsfromtheextentlistshownintheinode:</para>
> +		<para>For directories, we can also dump the contents from the extent lists hown in the inode:</para>
>  		<para><programlisting>
>  > dblock &lt;file offset in blocks&gt;
>  > print
> @@ -181,13 +181,13 @@ u.sfdir2.hdr.i8count = 0
>  u.sfdir2.hdr.parent.i4 = 135</programlisting></para>
>  	</section>
>  	<section>
> -		<title>Mount and Repair Fails – Corrupted Log</title>
> +		<title>Mount and Repair Fails - Corrupted Log</title>
>  		<para>If the log is corrupted you will see an error like:</para>
>  		<para><programlisting>
>  # mount &lt;filesystem&gt;
>  mount: Unknown error 990
>  # dmesg | tail -20
> -Filesystem “&lt;filesystem&gt;": xfs_inode_recover: Bad inode magic number . . .
> +Filesystem "&lt;filesystem&gt;": xfs_inode_recover: Bad inode magic number . . .
>  Filesystem "dm-0": XFS internal error xlog_recover_do_inode_trans(1) at line 2352 Caller 0xffffffff88307729
>  XFS: log mount/recovery failed: error 990 XFS: log mount failed
>  # xfs_repair &lt;device&gt;
> @@ -200,9 +200,9 @@ re-running xfs_repair. If you are unable
>  the -L option to destroy the log and attempt a repair.
>  Note that destroying the log may cause corruption -- please attempt a mount
>  of the filesystem before doing this.</programlisting></para>
> -		<para>Usefulinformationcanbecollectedfortriage:</para>
> +		<para>Useful information can becollected for triage:</para>
>  		<para><programlisting>
> -# /usr/sbin/xfs_logprint –C &lt;filename&gt; &lt;device&gt;
> +# /usr/sbin/xfs_logprint -C &lt;filename&gt; &lt;device&gt;
>  # /usr/sbin/xfs_logprint -t &lt;device&gt;</programlisting></para>
>  		<para>But in this case, the only option may be to throw the log away:</para>
>  		<para><programlisting>
> 

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

---end quoted text---


--===============0666440869082322286==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0666440869082322286==--
