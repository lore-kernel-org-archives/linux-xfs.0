Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Oct 2007 00:51:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9N7pE23005581
	for <xfs@oss.sgi.com>; Tue, 23 Oct 2007 00:51:17 -0700
Date: Tue, 23 Oct 2007 17:53:06 +1000
Subject: [RFC 0/2] Case-insensitive filename lookup for XFS
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.t0m36sn43jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>


Following is the initial test version of case-insensitive support
for XFS in Linux. It implements case-insensitivity utilising a
Unicode case folding table stored on disk generated from
http://www.unicode.org/Public/UNIDATA/CaseFolding.txt

As the filesystem stores names as Unicode (UTF-8), the "nls"
mount option has been added to support systems not utilising
UTF-8 natively. If the nls mount option is not used, it will
use the default NLS defined in the kernel's config.

To allow case-insensitivity to be a mount option rather than
a mkfs option, the hashes stored on disk are always case-folded.
This is indicated by the new "unicode" bit in the superblock.
This bit also associated with the presence of the case-folding
table on disk.

With the case-folding table on disk, it allows us to upgrade
the table in the future while retaining backwards and forwards
compatibility. It also allows special case tables such as
Turkic case which is supported in this patch set.

The case-insensitive support also installs a couple of
dentry_operations for the XFS inodes: hash and compare.

Currently, there is a couple of outstanding issues with the
dentry cache interaction:

   - The first lookup if case-mismatched will continue to
     have the mismatched case in the cache. Not really sure
     if this is an issue or not. If it is an issue, how
     should I resolve it?

   - As above, but with a non-existing lookup, then creating
     the file with a different case, the first failed lookup
     will define the case used. I have partially resolved
     this with a memcpy if the two lengths are the same.
     How do I fix this if the lengths are different?
     (TODO's show the location of this problem.)

Other TODOs:

   - support for case-insensitve extended attributes
     as a separate mount option.

   - Other xfsprogs updates: xfs_repair, xfs_db
