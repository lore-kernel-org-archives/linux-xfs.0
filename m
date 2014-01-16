Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A7BFA29E20
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 11:07:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4BABAAC001
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 09:07:25 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id RM1BmJ7GVWKGf0mV (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 Jan 2014 09:07:24 -0800 (PST)
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 11C5CAC56
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 17:07:23 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 5/5] xfstests: update lsqa.pl for new tests layout
Date: Thu, 16 Jan 2014 18:07:15 +0100
Message-Id: <640bbf9ea0ed48cb817218af8a3311545c4cc1b8.1389891730.git.dsterba@suse.cz>
In-Reply-To: <cover.1389891730.git.dsterba@suse.cz>
References: <cover.1389891730.git.dsterba@suse.cz>
In-Reply-To: <cover.1389891730.git.dsterba@suse.cz>
References: <cover.1389891730.git.dsterba@suse.cz>
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
Cc: David Sterba <dsterba@suse.cz>

Accepted parameter types:
- nothing - list all tests from all subdirectories in tests/*
- tests/DIR - list all tests from DIR
- tests/DIR/123 - show header from single test

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 lsqa.pl | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/lsqa.pl b/lsqa.pl
index 040196f70120..b4fc83f43f99 100755
--- a/lsqa.pl
+++ b/lsqa.pl
@@ -15,13 +15,20 @@
 # along with this program; if not, write the Free Software Foundation,
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
+
+# Print headers of given tests
+# Accepted parameter types:
+# - nothing - list all tests from all subdirectories in tests/*
+# - tests/DIR - list all tests from DIR
+# - tests/DIR/123 - show header from single test
+
 use strict;
 
 use Getopt::Long;
 
 sub help();
 sub get_qa_header($);
-sub get_qa_tests();
+sub get_qa_tests;
 
 my %opt;
 
@@ -43,8 +50,19 @@ if ($opt{'help'}) {
     die help();
 }
 
-my @qatests = map {sprintf("%03d", $_)} @ARGV;
-@qatests = get_qa_tests() unless (@qatests);
+my @qatests;
+
+if (!@ARGV) {
+    my $d="tests";
+    opendir(DIR, $d);
+    map { push @qatests,get_qa_tests("$d/$_") if -d "$d/$_" } readdir(DIR);
+    closedir(DIR);
+}
+
+foreach (@ARGV) {
+    push @qatests,$_ if -f && /\d{3}$/;
+    push @qatests,get_qa_tests($_) if -d;
+}
 
 foreach (@qatests) {
     my @h = get_qa_header($_);
@@ -103,13 +121,11 @@ sub get_qa_header($) {
     return @l;
 }
 
-sub get_qa_tests() {
+sub get_qa_tests {
     my $d = shift || $ENV{'PWD'};
 
     opendir(my $DIR, $d) || die "can't opendir $d: $!";
-    my @qa = grep {m/^\d\d\d$/ && -f "$d/$_" } readdir($DIR);
+    my @qa = sort grep { m/^\d\d\d$/ && -f "$d/$_" } readdir($DIR);
     closedir($DIR);
-
-    return @qa;
+    return map { $_ = "$d/$_" } @qa;
 }
-
-- 
1.8.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
