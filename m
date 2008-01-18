Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 20:42:32 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0I4gHte021080
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 20:42:24 -0800
Date: Fri, 18 Jan 2008 15:43:47 +1100
Subject: [REVIEW 0/2] Case insensitive support for XFS
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.t43ze9ot3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>


In the following two emails is contains patches for
case-insensitive and Unicode support for XFS in Linux.
It implements case-insensitivity utilising a Unicode
case folding table stored on disk generated from
http://www.unicode.org/Public/UNIDATA/CaseFolding.txt

As the filesystem stores names as Unicode (UTF-8), the "nls"
mount option has been added to support systems not utilising
UTF-8 natively. If the nls mount option is not used, it will
use the default NLS defined in the kernel's config.

To allow case-insensitivity to be a mount option rather than
a mkfs option, the hashes stored on disk are always case-folded.
This is indicated by the new "unicode" bit in the superblock.
This bit also associated with the presence of the case-folding
table on disk. This affects both directory and extended
attribute names.

With the case-folding table on disk, it allows us to upgrade
the table in the future while retaining backwards and forwards
compatibility. It also allows special case tables such as
Turkic case which is supported in this patch set.

There are two mount options for enabling case-insensitivity
on a Unicode XFS filesystem:
   - "ci" - enables case-insensitivity for file names
   - "ciattr" - enables case-insensitivity for extended
                attributes.

xfs_repair and xfs_db are fully aware of the case-folding
table. xfs_db has a basic "cft" command which can show
the table's header.
