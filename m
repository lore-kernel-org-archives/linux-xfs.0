Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 881677CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:42:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A0A4304039
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 08:42:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bHAjLKfCukbRIApS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 08:42:48 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 27CF361E44
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 15:42:47 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [RFC PATCH 0/8] mkfs: centralised conflict detection
Date: Tue,  2 Aug 2016 17:42:11 +0200
Message-Id: <1470152539-18759-1-git-send-email-jtulak@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Tulak <jtulak@redhat.com>

Hi guys

This is set follows the earlier cleaning of mkfs by utilising the new code to
do also inter-option conflicts checks, and is inspired by Dave's idea in
"xfstests: Add mkfs input validation tests" thread.

With these patches, adding -i attr=1 -m crc=1  conflict is as simple as:
                        { .index = I_ATTR,
-                         .conflicts = { {LAST_CONFLICT} },
+                         .conflicts = { {OPT_M, M_CRC, true, 1, 1,
+               "V2 attribute format always enabled on CRC enabled filesytems."},
+                                        {LAST_CONFLICT} },

And a similar change in the corresponding option. You can read it as:
I_ATTR has a conflict with M_CRC depending on input values (the "true"), when
M_CRC is 1 (the first 1) and I_ATTR is 1 (the second 1). Report it with
message... (I should probably rewrite it to use named initialization, instead
of positional.)

This change  should remove some other code from mkfs and make conflicts
consistent.  The patch set, as it is, should be mostly done. I think there are
still some conflicts to be converted, and some new lines added/removed where
they are not needed,  but the main reason why this is RFC is an issue with
defaults.

Detection of conflicts in user input is working like a charm. However, if some
option is conflicting with default settings, I have a problem. For example,
lets look on -m crc=1 -n ftype=0. crc=1 is the default, so if the user inputs
-n ftype=0 alone, it is still a conflict and the old code detects it once it
loads and parses all user input. The new does not.

The conflicts detecting code added in previous mkfs cleaning, which this
patchset is extending, does conflicts detection at the moment it sees an
option/flag, during getopt loop. Which means I can't just raise a red flag
when something is in conflict with default, because it is possible that the
very next option will change that default.

I left the old code here and only added a comment (it is in the last patch),
but there are other options with the same issue...

The solutions I came up are here, but I would like to know some other people's
thoughts before going for any of them. They are sorted by the amount of
necessary changes.

1) Leave the old code there. This brings some duplicity, but not every option
has this issue, so I think that overall it would be still a gain.

2) Do minimal changes to move the conflict checks after the getopt loop. I
think that this should be possible without too many changes - I would remove
all conflict-related things from getnum/getstr and instead would add a loop to
go through the entire table with options after the getopt loop. So - one loop
to fill the table, with user-given values, second loop to check for conflicts.

3) Rewrite conflicts from scratch and check them once everything was parsed and
all options loaded. Similar to 2, but rather than making minimal changes, I
would take the conflicts out of the current opt_params table and made a second
table for conflicts only. This would also allow for merging the two entries
necessary for every conflict (one from each side) into a single one.

My thoughts about these ideas: 1 is clumsy and doesn't look correct, so I think
about 2 and 3. For now, 2 would be easier, but I think also about adding range
conflicts (inode size with and without crc, ...) and possibly other things and
then I'm not sure which implementation would be better.

I hope I described it well enough so you don't have to study every line of the
code... Anyway, look on this patchset and tell me your thoughts.

Thank you :-)
Jan


Jan Tulak (8):
  mkfs: remove intermediate getstr followed by getnum
  mkfs: merge tables for opts parsing into one table
  mkfs: extend opt_params with a value field
  mkfs: change conflicts array into a table capable of cross-option
    addressing
  mkfs: add a check for conflicting values
  mkfs: add cross-section conflict checks
  mkfs: Move opts related #define to one place
  mkfs: move conflicts into the table

 mkfs/xfs_mkfs.c | 1647 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 938 insertions(+), 709 deletions(-)

-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
