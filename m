Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24JZ3Hf184560 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 13:35:03 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103041937.p24Jbpgh004834@stout.americas.sgi.com>
Date: Fri, 04 Mar 2011 13:37:51 -0600
Subject: [PATCH 0/5] xfstests: eliminate build warnings in the "dmapi" subtree
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Now that we're building the "dmapi" subtree the same way as the rest
of the code in "xfstests", a lot of warnings are showing up in the
build.  This series eliminates them all, at least for three build
architectures I have used so far (i386, x86_64, and ia64).

Because of the sheer number of changes, I've broken it into
a small series, each focused on files under a certain portion
of the tree under "dmapi".

Below are the types of warnings, and how they were generally fixed.
In all cases I scanned the affected code to be reasonably sure the
warning was harmless and the fix did not obscure a real problem.
- Variables possibly used before set.  Fixed by initializing such
  variables to 0 or NULL, or some appropriate symbolic value if
  available.
- "Bald" assignments used as conditional values; GCC suggests adding
  an extra set of parentheses.  Fixed by pulling the assignments out
  as a previous line of code, and using the assigned value alone in
  the conditional.
- Variables used in scanf() functions having types that differ from
  what the format string indicates.  Fixed by creating and using new
  variables of the type needed for scanf(), and then assigning the
  result to the original variable with a cast.
- Variables used in printf() functions having types that differ from
  what the format string indicates.  Fixed by casting the variable
  to the type indicated in the format string.  In a few cases I
  changed "%lld" formats to "%llu" to be consistent with other usage
  for printing the same variable.  (But I did not do this
  consistently.)
    - A lot of these cases involved using "%zd" in place of just
      "%d" for printing size_t objects.
- In one case, replaced a call to tmpnam() with an equivalent call
  to mkstmp() using a local variable.

Patch 1 covers files under:
    dmapi/src/common/cmd/
    dmapi/src/common/lib/
    dmapi/src/sample_hsm/
    dmapi/src/simple/

Patch 2 covers:
    dmapi/src/suite1/cmd/ (part 1)

Patch 3 covers:
    dmapi/src/suite1/cmd/ (part 2)

Patch 4 covers:
    dmapi/src/suite1/cmd/ (part 3)

Patch 5 covers:
    dmapi/src/suite2/

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
