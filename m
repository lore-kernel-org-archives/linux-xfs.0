Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Oct 2007 10:47:25 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9SHlJfP013643
	for <linux-xfs@oss.sgi.com>; Sun, 28 Oct 2007 10:47:20 -0700
From: Andreas Gruenbacher <agruen@suse.de>
Subject: attr: Remove eaconv script
Date: Sun, 28 Oct 2007 18:32:23 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_oeMJHI3uWU01Ia8"
Message-Id: <200710281832.24153.agruen@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, Tim Shimmin <tes@sgi.com>

--Boundary-00=_oeMJHI3uWU01Ia8
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

while updating our attr package I noticed that we still have eaconv, a script 
for converting between an xattr user-space representation which long since 
disappeared. Here is patch for removing this now-useless script. Any 
objections?

Thanks,
Andreas

--Boundary-00=_oeMJHI3uWU01Ia8
Content-Type: text/x-diff;
  charset="us-ascii";
  name="remove-ea-conv.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="remove-ea-conv.diff"

Index: attr-2.4.39/doc/Makefile
===================================================================
--- attr-2.4.39.orig/doc/Makefile
+++ attr-2.4.39/doc/Makefile
@@ -5,8 +5,6 @@
 TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
-SUBDIRS = ea-conv
-
 LSRCFILES = INSTALL PORTING CHANGES COPYING
 LDIRT = *.gz
 
Index: attr-2.4.39/doc/ea-conv/Makefile
===================================================================
--- attr-2.4.39.orig/doc/ea-conv/Makefile
+++ /dev/null
@@ -1,17 +0,0 @@
-#
-# Copyright (c) 2000, 2002 Silicon Graphics, Inc.  All Rights Reserved.
-#
-
-TOPDIR = ../..
-include $(TOPDIR)/include/builddefs
-
-LSRCFILES = README ea-conv
-
-include $(BUILDRULES)
-
-install: default
-	$(INSTALL) -m 755 -d $(PKG_DOC_DIR)/ea-conv
-	$(INSTALL) -m 644 README $(PKG_DOC_DIR)/ea-conv
-	$(INSTALL) -m 755 ea-conv $(PKG_DOC_DIR)/ea-conv
-
-default install-dev install-lib:
Index: attr-2.4.39/doc/ea-conv/README
===================================================================
--- attr-2.4.39.orig/doc/ea-conv/README
+++ /dev/null
@@ -1,13 +0,0 @@
-ea-conv -- convert between aget and getfattr format
-
-This script converts between the extended attribute text formats of
-getfattr and its predecessor, aget. To get all attributes with aget
-and convert the result to getfattr format, use the following command:
-
-	aget -Rds -e hex . | ea-conv -
-
-To get all attributes with getfattr and convert the result to aget
-format, use the following command:
-
-	getfattr -Rd -m - -e hex . | ea-conv -
-
Index: attr-2.4.39/doc/ea-conv/ea-conv
===================================================================
--- attr-2.4.39.orig/doc/ea-conv/ea-conv
+++ /dev/null
@@ -1,119 +0,0 @@
-#!/usr/bin/perl -w
-
-use strict;
-use FileHandle;
-
-sub convert_acl($)
-{
-	my ($value) = @_;
-
-	local $_ = $value;
-
-	die "ACL value must be hex encoded\n" unless (s/^0x//);
-	s/\s//g;
-
-	my ($x4, $x8) = ('([0-9A-Fa-f]{4})', '([0-9A-Fa-f]{8})');
-
-	if (s/^01000000//) {
-		my $new_value = '0x02000000 ';
-		while ($_ ne '') {
-			if (s/^(0100|0400|1000|2000)$x4//) {
-				$new_value .= "$1$2ffffffff ";
-			} elsif (s/^(0200|0800)$x4$x8//) {
-				$new_value .= "$1$2$3 ";
-			} else {
-				die "ACL format not recognized\n"
-			}
-		}
-		return $new_value;
-	} elsif (s/^02000000//) {
-		my $new_value = '0x01000000 ';
-		while ($_ ne '') {
-			if (s/^(0100|0400|1000|2000)$x4$x8//) {
-				$new_value .= "$1$2 ";
-			} elsif (s/^(0200|0800)$x4$x8//) {
-				$new_value .= "$1$2$3 ";
-			} else {
-				die "ACL format not recognized\n"
-			}
-		}
-		return $new_value;
-	} else {
-		die "ACL format not recognized\n"
-	}
-}
-
-sub check_name($) {
-	my ($name) = @_;
-	if ($name =~ m[^[^A-Za-z]]) {
-		print STDERR "Renaming attribute `user.$name' to `X$name'.\n";
-		return "X$name";
-	}
-	return $name;
-}
-
-sub convert($) {
-	my ($file) = @_;
-
-	eval {
-		while (<$file>) {
-			m[^(#.*)?$] ||
-			s[^system\.posix_acl_access=(0x02.*)]
-				['$acl=' . convert_acl($1)]e ||
-			s[^system\.posix_acl_default=(0x02.*)]
-				['$defacl=' . convert_acl($1)]e ||
-			s[^user\.([^=]*)][check_name($1)]e ||
-			
-			s[^\$acl=(0x01.*)]
-				['system.posix_acl_access=' .
-				 convert_acl($1)]e ||
-			s[^\$defacl=(0x01.*)]
-				['system.posix_acl_default=' .
-				 convert_acl($1)]e ||
-			s[^([A-Za-z][^=]*)][user.$1] ||
-			
-			die "Input format error\n";
-
-			print;
-		}
-	};
-	if ($@) {
-		chomp $@;
-		print STDERR "$@ in line $..\n";
-	}
-	return (not $@);
-}
-
-unless (@ARGV) {
-	printf STDERR <<EOF;
-$0 -- convert between aget and getfattr format
-
-This script converts between the extended attribute text formats of
-getfattr and its predecessor, aget. To get all attributes with aget
-and convert the result to getfattr format, use the following command:
-
-	aget -Rds -e hex . | $0 -
-
-To get all attributes with getfattr and convert the result to aget
-format, use the following command:
-
-	getfattr -Rd -m - -e hex . | $0 -
-
-EOF
-	exit 1;
-}
-
-my $good = 1;
-foreach my $arg (@ARGV) {
-	my $fh = ($arg eq '-') ?  *STDIN : new FileHandle($arg);
-
-	unless ($fh) {
-		print STDERR "$0: $arg: $!\n";
-		next;
-	}
-
-	$good = 0 unless convert $fh;
-
-	$fh->close unless ($arg eq '-');
-}
-exit (not $good);

--Boundary-00=_oeMJHI3uWU01Ia8--
