Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0CJ8Mwg057704 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 13:08:23 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH v3] xfsprogs: bump version and update changelog
Date: Tue, 12 Jan 2010 13:07:44 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6955@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6954@cf--amer001e--3.americas.sgi.com>
From: "Alex Elder" <aelder@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Alex Elder wrote:
> Christoph Hellwig wrote:
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks good.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>

Whoops.  I'm going to also add this to the CHANGES file:

 - Use physical device sector size if available in mkfs.xfs,
   so 4K sector devices are handed more gracefully.

Eric felt this wording was OK.

					-Alex

>> Index: xfsprogs-dev/VERSION
>> ===================================================================
>> --- xfsprogs-dev.orig/VERSION	2010-01-02 12:11:42.871003354 +0100
>> +++ xfsprogs-dev/VERSION	2010-01-06 18:49:38.221274008 +0100 @@ -2,6 +2,6 @@
>>  # This file is used by configure to get version information  #
>>  PKG_MAJOR=3
>> -PKG_MINOR=0
>> -PKG_REVISION=4
>> +PKG_MINOR=1
>> +PKG_REVISION=0
>>  PKG_BUILD=1
>> Index: xfsprogs-dev/doc/CHANGES
>> ===================================================================
>> --- xfsprogs-dev.orig/doc/CHANGES	2010-01-02 12:11:42.873010034 +0100
>> +++ xfsprogs-dev/doc/CHANGES	2010-01-08 13:24:09.150268999 +0100 @@ -1,3 +1,23 @@
>> +xfsprogs-3.1.0
>> +	- Reduce memory usage in xfs_repair by using better data structures.
>> +	- Add additional checks in xfs_repair to detect freespace btree
>> +	  corruption instead of only rebuilding the btrees.  Useful for the +	  no-modify mode.
>> +	- Fix libhandle to use the right path to issue by-handle ioctls for
>> +	  symbolic links and special files.
>> +	- Use lazy superblock counters by default.  At least kernel 2.6.22 is +	  needed for this
>> feature. +	- Add a German translation, thanks to Chris Leick.
>> +	- Enable the madvise and mincor commands in xfs_io.
>> +	- Fix unsafe temporary file creation in xfs_fsr.
>> +	- Add support for discarding unused space on SSDs or thing provionen +	  arrays in mkfs.xfs.
>> +	- Allow linking against libblkid for topology information.
>> +	- Add symbol versioning for libhandle.
>> +	- Remove the included RPM and binary tarball built infrastructure.
>> +	- Various build system improvements.
>> +	- Small fixes to xfs_db and xfs_io.
>> +
>>  xfsprogs-3.0.4 (17 September 2009)
>>  	- Fix a memory leak in xfsprogs.
>>  	- Increase hash chain length in xfsprogs when running out of memory.
>> Index: xfsprogs-dev/debian/changelog
>> ===================================================================
>> --- xfsprogs-dev.orig/debian/changelog	2010-01-02 12:11:42.872012141 +0100
>> +++ xfsprogs-dev/debian/changelog	2010-01-06 18:49:38.224273412 +0100 @@ -1,6 +1,6 @@
>>  xfsprogs (3.1.0) unstable; urgency=low
>> 
>> -  * New bugfix release
>> +  * New upstream release
>>    * Merged German translation (closes: #521389)
>>    * Merged German translation update (closes: #557100)
>>    * Uptodate po file is provided now (closes: #538962)
>> 
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
