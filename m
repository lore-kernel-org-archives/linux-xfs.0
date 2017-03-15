Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35366 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754095AbdCOQAv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Mar 2017 12:00:51 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 00/22] mkfs.xfs: Make stronger conflict checks
Date: Wed, 15 Mar 2017 16:59:55 +0100
Message-Id: <20170315160017.27805-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>

Hi guys,

my RFC didn't got much of attention, so I'm sending it as a merge request.
Hopefully, this will get more eyes on it. ;-) I fixed the few small issues Bill
noticed (Thanks, Bill!) and xfstests runs ok. There is one case where test
xfs/191-input-validation was accepting a behaviour forbidden in man page, so
I'm sending also a xfstests patch:

Specifically, a standalone "-l size=4096b" should fail, because:
              To  specify any options on the command line in units of filesys‐
              tem blocks, this option must be  specified  first  so  that  the
              filesystem block size is applied consistently to all options.

So without the xfstest patch, expect this one test to fail.

The following text is copy&paste from RFC. I only removed/edited one question
I had at the time and was solved in the RFC thread. After that is an addendum
with regards to Luis' config file support.

---

This set is a follow-up of some old discussions and further attempts to untangle
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
still have a question, but it can be answered with "let's keep it as it
is."

The question about this patchset is: As we are saving all the values in
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

---

Config file patches addendum:

(Thread: http://www.spinics.net/lists/linux-xfs/msg04703.html)

I read through the changes, but decided to don't take anything from it.
I think it is time to do something and adding further changes would just
push it down again. Nevertheless, the other patchset contains some changes
(like splitting the main opts loop) that I wanted to add in some later patch
too.

I suggest that we first merge these patches I'm sending, and once it solves
some of the issues Luis hit too, we can look again on the config file thing
and even if the main idea fell out of favor for some reason, there are still
other useful changes.

---

So, I think this is all I wanted to cover in the cover letter. :-)
I will be glad for any comments or bugs you find out.

Thanks for your time,

Jan

PS: I'm traveling at Vault next week, so if you are there too, we can open it
there.

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

 mkfs/xfs_mkfs.c | 2961 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 1873 insertions(+), 1088 deletions(-)

-- 
2.11.0

