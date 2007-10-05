Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 18:53:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l951rN8K022433
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 18:53:25 -0700
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA21900 for <xfs@oss.sgi.com>; Fri, 5 Oct 2007 11:53:23 +1000
Date: Fri, 05 Oct 2007 11:57:54 +1000
Subject: RFC: Case-insensitive support for XFS
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.ty6361ut3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tzpbqspl3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.ty6361ut3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On it's own, linux only provides case conversion for old-style
character sets - 8 bit sequences only. A lot of distos are
now defaulting to UTF-8 and Linux NLS stuff does not support
case conversion for any unicode sets.

Various filesystems do support case-insensitive lookup in Linux:
    - CIFS (Samba)
    - NTFS
    - HFS+ (MacOSX)
    - ISOFS (DVD/Joliet)
    - JFS  (IBM's?)
    - VFAT
    - HPFS
    - AFFS ?

It seems all but HFS+ do case-conversion either on the currently
set charset (CIFS) or only do English ASCII conversion. If the
charset is UTF-8, this fails.

HFS+ does have a full and fixed unicode charset table as defined by:
http://developer.apple.com/technotes/tn/tn1150.html#StringComparisonAlgorithm
This is implemented by fs/hfsplus/unicode.c and fs/hfsplus/tables.c.

Linux's dentry cache allows these filesystems to hook into
the dentry lookup operations by allowing a custom hash and
compare functions defined by the dentry_operations struct.
XFS currently does not define its own dentry_operations.

NTFS in Linux also implements it's own dcache and NTFS also
stores its unicode case table on disk. This allows the filesystem
to migrate to newer forms of Unicode at the time of formatting
the filesystem. Eg. Windows Vista now supports Unicode 5.0
while older version would support an earlier version of
Unicode. Linux's version of NTFS case table is implemented
in fs/ntfs/upcase.c defined as default_upcase.

IRIX case-insensitive XFS only supported ASCII, no code-pages
or anything. With the widespread distribution of Linux in
various countries/languages, this should be a deprecated mode
and supported for backwards compatibility.

It will be proposed that in the future, XFS may default to
UTF-8 on disk and to go for the old format, explicitily
use a mkfs.xfs option. Two superbits will be used: one for
case-insensitive (which generates lowercase hashes on disk)
and that already exists on IRIX filesystems and a new one
for UTF-8 filenames. Any combination of the two bits can be
used and the dentry_operations will be adjusted accordingly.

Another interesting resource is "ICU" - "International Components
for Unicode" a BSD licensed API maintained by IBM:
http://icu-project.org/

It has code in there supporting the latest Unicode sets including
true character folding specifically for case-insensitive searches:
http://icu-project.org/userguide/caseMappings.html#case_folding


So, in regards to the UTF-8 case-conversion/folding table, we
have several options to choose from:
    - Use the HFS+ method as-is.
    - Use an NTFS scheme with an on-disk table.
    - Pick a current table and stick with it (similar to HFS+).
    - How much of Unicode to we support? Just the the "Basic
      Multilingual Plane" (U+0000 - U+FFFF) or the entire set?
      (anything above U+FFFF won't have case-conversion
       requirements). Seems that all the other filesystems
       just support the "BMP".
    - UTF-8, UTF-16 or UCS-2.

With the last point, UTF-8 has several advantages IMO:
    - xfs_repair can easily detect UTF-8 sequences in filenames
      and also validate UTF-8 sequences.
    - char based structures don't change
    - "nulls" in filenames.
    - no endian conversions required.

Internally, the names will probably be converted to "u16"s for
efficient processing. Conversion between UTF-8 and UTF-16/UCS-2
is very straight forward.
