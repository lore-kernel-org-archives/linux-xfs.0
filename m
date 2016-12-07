Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49454 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752892AbcLGNgH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:36:07 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D5737FD56
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:27:40 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [RFC PATCH 00/22] mkfs.xfs: Make stronger conflict checks
Date: Wed,  7 Dec 2016 14:27:07 +0100
Message-Id: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Hi guys,

this set is a follow-up of some old discussions and further attempts to untangle
the spaghetti in options parsing. In short, this patchset allows to define
cross-option conflicts and makes the conflicts detection more robust.

Until now, we had the ability to define conflicts within one option (e.g. -d
sunit/su), but things like -i attr=1 -m crc=1 conflict had to be watched for on
case by case basis somewhere in the code. Now, when even those situations are
handled by the same code, it is enough to just add a new entry into a table of
options. Thus, a reduced chance for an error and easier adding of new cases.

One of the biggest changes in this set is that user input is now stored in
directly in the opts table defining allowed range and the like, and variables
in the main() of mkfs.xfs are now just aliases/pointers. This allows as to do
conditional checks based on actual values, not only on occurence of an option.

(A technical note here is that not every value can be saved in a single place
like this. Some values are already stored in a table or structure and I wanted
to avoid modifying anything outside of xfs_mkfs.c.)

I tested it with full xfstests suit and the only failed tests I saw are because
some ambiguity in arguments parsing was removed. E.g. sometimes it was possible
to specify size in blocks without stating the blocksize first, even if manpage
explicitly requires -b or -s to be used before.

I already submitted part of this patchset as RFC before, but as I got no reply,
I tried to finish it before submitting again. So, this set works as it is. I
still have some questions, but they can be answered with "let's keep it as it
is."

Number one is simple: What values can use block/sector sizes as user input?
There is an inconsistency or ambiguity between manual page and the code. Look
at man page for -d agsize.

	agsize=value
		This is an alternative to using the  agcount  subop‐
		tion.  The  value is the desired size of the alloca‐
		tion group expressed in bytes (usually using  the  m
		                     ^^^^^^^^
		or  g  suffixes).   This value must be a multiple of
		[ ... ]


The option -d agsize explicitly states that it accepts size in bytes, in a
similar tone to the one used for describe allowed values for -s/-b size:

	value in bytes with size=value
	      ^^^^^^^^

However, -d agsize=1234s input was accepted as valid until now. Is the manual
page misleading, or are the options where b/s suffix is forbidden are
block/sector size definitions? I decided to err on the compatibility side and
kept the current behaviour - only blocksize or sectorsize can't be stated in
blocks and sectors, but it can be easily changed.

I will send an update for xfstests once I know what behaviour is correct.


The other question about this patchset is: As we are saving all the values in
the opt_params table, and the values have different types, I thought it
necessary to not use a single data type for everything and created an union
field (could be easily changed to struct, that would not change anything
important). Do you see any non-adressed issue with this approach? Is there
another way how to solve the problem?

If nothing else, numbers and strings can't be easily saved in a single
variable. Also, as we are using shift operations, any type conversions
(like storing everything in long long type) could cause trouble. This is one of
the reasons why I'm changed the variables in main() to pointers. This allows
for simple and easy access to the correct union field, so unless one is adding
a new option, there should be no need to remember the correct date type. If the
pointer assignment is done correctly, then GCC will watch for type mismatch.

I really couldn't find out better solution, but see for yourself, this change
is done in "mkfs: Change all value fields in opt structures into unions"
and "mkfs: use old variables as pointers to the new opts struct values".


So, I think this is all I wanted to cover in the cover letter. :-)
I will be glad for any comments or bugs you find out.

Thanks for your time,

Jan


Jan Tulak (22):
  mkfs: remove intermediate getstr followed by getnum
  mkfs: merge tables for opts parsing into one table
  mkfs: extend opt_params with a value field
  mkfs: change conflicts array into a table capable of cross-option
    addressing
  mkfs: add a check for conflicting values
  mkfs: add cross-section conflict checks
  mkfs: Move opts related #define to one place
  mkfs: move conflicts into the table
  mkfs: change conflict checks to utilize the new conflict structure
  mkfs: change when to mark an option as seen
  mkfs: add test_default_value into conflict struct
  mkfs: expand conflicts declarations to named declaration
  mkfs: remove zeroed items from conflicts declaration
  mkfs: rename defaultval to flagval in opts
  mkfs: replace SUBOPT_NEEDS_VAL for a flag
  mkfs: Change all value fields in opt structures into unions
  mkfs: use old variables as pointers to the new opts struct values
  mkfs: prevent sector/blocksize to be specified as a number of blocks
  mkfs: subopt flags should be saved as bool
  mkfs: move uuid empty string test to getstr()
  mkfs: remove duplicit checks
  mkfs: prevent multiple specifications of a single option

 mkfs/xfs_mkfs.c | 2952 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 1864 insertions(+), 1088 deletions(-)

-- 
2.8.1

