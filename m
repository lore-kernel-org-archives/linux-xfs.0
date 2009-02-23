Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NGCMOI099999 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 10:12:23 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8FBF73040EA
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 08:11:52 -0800 (PST)
Message-Id: <7532BCEA-EC58-4479-91FD-F519A99B3C08@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090223132931.GA15948@infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfsprogs: generate complete source tarball from Makepkgs
Date: Mon, 23 Feb 2009 10:11:51 -0600
References: <20090217214940.GA30787@infradead.org>
	<20090223132931.GA15948@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Feb 23, 2009, at 7:29 AM, Christoph Hellwig wrote:

> ping?
>
> On Tue, Feb 17, 2009 at 04:49:40PM -0500, Christoph Hellwig wrote:
>> The source file lists in the Makefiles were missing a couple of  
>> files.
>> Because those missing files include the new headers that are only
>> installed on make install-qa that resulting tarball would not even be
>> buildable.
>>
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>>
>>
>> Index: xfsprogs-dev/include/buildmacros
>> ===================================================================
>> --- xfsprogs-dev.orig/include/buildmacros	2009-02-17  
>> 19:55:23.674944499 +0100
>> +++ xfsprogs-dev/include/buildmacros	2009-02-17 19:55:52.654069638  
>> +0100
>> @@ -15,6 +15,7 @@ LDLIBS = $(LLDLIBS) $(PLDLIBS) $(MALLOCL
>>
>> MAKEOPTS = --no-print-directory
>> SRCFILES = Makefile $(HFILES) $(CFILES) $(LSRCFILES) $(LFILES) $ 
>> (YFILES)
>> +SRCFILES += $(QAHFILES)
>>
>> DEPDIRT = dep dep.bak
>> MANDIRT = *.[1-9].gz
>> Index: xfsprogs-dev/db/Makefile
>> ===================================================================
>> --- xfsprogs-dev.orig/db/Makefile	2009-02-17 20:03:49.554944958 +0100
>> +++ xfsprogs-dev/db/Makefile	2009-02-17 20:04:16.189070177 +0100
>> @@ -15,6 +15,8 @@ HFILES = addr.h agf.h agfl.h agi.h attr.
>> 	text.h type.h write.h attrset.h
>> CFILES = $(HFILES:.h=.c)
>> LSRCFILES = xfs_admin.sh xfs_check.sh xfs_ncheck.sh xfs_metadump.sh
>> +LSRCFILES += xfs_check64.sh xfs_ncheck64.sh
>> +
>> LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
>> LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
>> LLDFLAGS += -static
>> Index: xfsprogs-dev/doc/Makefile
>> ===================================================================
>> --- xfsprogs-dev.orig/doc/Makefile	2009-02-17 20:02:23.434944233  
>> +0100
>> +++ xfsprogs-dev/doc/Makefile	2009-02-17 20:02:40.158944629 +0100
>> @@ -5,7 +5,7 @@
>> TOPDIR = ..
>> include $(TOPDIR)/include/builddefs
>>
>> -LSRCFILES = INSTALL PORTING CHANGES COPYING CREDITS
>> +LSRCFILES = INSTALL PORTING CHANGES COPYING CREDITS sparse.txt
>> LDIRT = *.gz
>>
>> default: CHANGES.gz
>> Index: xfsprogs-dev/include/Makefile
>> ===================================================================
>> --- xfsprogs-dev.orig/include/Makefile	2009-02-17  
>> 19:51:43.273069121 +0100
>> +++ xfsprogs-dev/include/Makefile	2009-02-17 22:44:41.831973534 +0100
>> @@ -37,7 +37,7 @@ PHFILES = darwin.h freebsd.h irix.h linu
>> DKHFILES = volume.h fstyp.h dvh.h
>> LSRCFILES = $(shell echo $(PHFILES) | sed -e "s/$(PKG_PLATFORM).h// 
>> g")
>> LSRCFILES += platform_defs.h.in builddefs.in buildmacros buildrules  
>> $(DKHFILES)
>> -LSRCFILES += command.h input.h path.h project.h
>> +LSRCFILES += command.h input.h path.h project.h unaligned.h
>> LDIRT = xfs disk
>>
>> default install: xfs disk
>> Index: xfsprogs-dev/repair/Makefile
>> ===================================================================
>> --- xfsprogs-dev.orig/repair/Makefile	2009-02-17 20:03:01.254069430  
>> +0100
>> +++ xfsprogs-dev/repair/Makefile	2009-02-17 20:03:10.846069320 +0100
>> @@ -5,6 +5,8 @@
>> TOPDIR = ..
>> include $(TOPDIR)/include/builddefs
>>
>> +LSRCFILES = README
>> +
>> LTCOMMAND = xfs_repair
>>
>> HFILES = agheader.h attr_repair.h avl.h avl64.h bmap.h dinode.h  
>> dir.h \
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> ---end quoted text---
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
