Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n082LPRF025724 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 20:21:25 -0600
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F1EB6E2C6
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 18:21:25 -0800 (PST)
Received: from wf-out-1314.google.com (wf-out-1314.google.com
	[209.85.200.174]) by cuda.sgi.com with ESMTP id
	ps93M6sBYfRGTzop for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 18:21:25 -0800 (PST)
Received: by wf-out-1314.google.com with SMTP id 26so10958280wfd.32
	for <xfs@oss.sgi.com>; Wed, 07 Jan 2009 18:21:24 -0800 (PST)
Message-Id: <20090108022108.928859181@ifup.org>
Date: Wed, 07 Jan 2009 18:19:49 -0800
From: brandon@ifup.org
Subject: [patch 2/4] [PATCH] attr: various improvements for test/run
References: <20090108021947.404730068@ifup.org>
Content-Disposition: inline;
	filename=attr-various-improvements-for-test-run.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Brandon Philips <bphilips@suse.de>

First move process_test to avoid a warning:

main::process_test() called too early to check prototype at ./run line 47.
main::process_test() called too early to check prototype at ./run line 60.

Create two ENV variables TUSER and TGROUP to get the user/group
running the test.

Add a | test line that is similar to > but is interpreted as a regular
expression.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 test/run |   99 ++++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 51 insertions(+), 48 deletions(-)

Index: acl-2.2.47/test/run
===================================================================
--- acl-2.2.47.orig/test/run
+++ acl-2.2.47/test/run
@@ -25,26 +25,69 @@ if (isatty(fileno(STDOUT))) {
 	$FAILED = "\033[31m\033[1m" . $FAILED . "\033[m";
 }
 
+$ENV{"TUSER"} = getpwuid($>);
+$ENV{"TGROUP"} = getgrgid($));
+
 sub exec_test($$);
 
-my ($prog, $in, $out) = ([], [], []);
+my ($prog, $in, $out, $outmatch) = ([], [], [], []);
 my $line_number = 0;
 my $prog_line;
 my ($tests, $failed) = (0,0);
 
+sub process_test($$$$$) {
+  my ($prog, $prog_line, $in, $out, $outmatch) = @_;
+
+  return unless @$prog;
+
+       my $p = [ @$prog ];
+       print "[$prog_line] \$ ", join(' ',
+             map { s/\s/\\$&/g; $_ } @$p), " -- ";
+       my $result = exec_test($prog, $in);
+       my $good = 1;
+       my $nmax = (@$outmatch > @$result) ? @$outmatch : @$result;
+       for (my $n=0; $n < $nmax; $n++) {
+	 if (!defined($outmatch->[$n]) || !defined($result->[$n]) ||
+	      $result->[$n] !~ /($outmatch->[$n])/) {
+		 $good = 0;
+	 }
+       }
+       $tests++;
+       $failed++ unless $good;
+       print $good ? $OK : $FAILED, "\n";
+       if (!$good) {
+         for (my $n=0; $n < $nmax; $n++) {
+	   my $l = defined($out->[$n]) ? $out->[$n] : "~";
+	   chomp $l;
+	   my $r = defined($result->[$n]) ? $result->[$n] : "~";
+	   chomp $r;
+	   print sprintf("%-37s %s %-39s\n", $l, $l eq $r ? "|" : "?", $r);
+         }
+       } elsif ($opt_v) {
+	 print join('', @$result);
+       }
+}
+
+
+
 for (;;) {
   my $line = <>; $line_number++;
   if (defined $line) {
     # Substitute %VAR and %{VAR} with environment variables.
-    $line =~ s[%(?:(\w+)|\{(\w+)\})][$ENV{"$1$2"}]eg;
+    $line =~ s[%\{(\w+)\}][$ENV{"$1"}]eg;
+    $line =~ s[%(\w+)][$ENV{"$1"}]eg;
   }
   if (defined $line) {
     if ($line =~ s/^\s*< ?//) {
       push @$in, $line;
-    } elsif ($line =~ s/^\s*> ?//) {
+    } elsif ($line =~ s/^\s*> ?//) { # explicit matching
+      push @$outmatch, "^(\Q$line\E)\$";
+      push @$out, $line;
+    } elsif ($line =~ s/^\s*\| ?//) { # regex case
+      push @$outmatch, $line;
       push @$out, $line;
     } else {
-      process_test($prog, $prog_line, $in, $out);
+      process_test($prog, $prog_line, $in, $out, $outmatch);
 
       $prog = [];
       $prog_line = 0;
@@ -55,9 +98,10 @@ for (;;) {
       $prog_line = $line_number;
       $in = [];
       $out = [];
+      $outmatch = [];
     }
   } else {
-    process_test($prog, $prog_line, $in, $out);
+    process_test($prog, $prog_line, $in, $out, $outmatch);
     last;
   }
 }
@@ -75,39 +119,6 @@ print $status, "\n";
 exit $failed ? 1 : 0;
 
 
-sub process_test($$$$) {
-  my ($prog, $prog_line, $in, $out) = @_;
-
-  return unless @$prog;
-
-       my $p = [ @$prog ];
-       print "[$prog_line] \$ ", join(' ',
-             map { s/\s/\\$&/g; $_ } @$p), " -- ";
-       my $result = exec_test($prog, $in);
-       my $good = 1;
-       my $nmax = (@$out > @$result) ? @$out : @$result;
-       for (my $n=0; $n < $nmax; $n++) {
-	 if (!defined($out->[$n]) || !defined($result->[$n]) ||
-	     $out->[$n] ne $result->[$n]) {
-		 $good = 0;
-	 }
-       }
-       $tests++;
-       $failed++ unless $good;
-       print $good ? $OK : $FAILED, "\n";
-       if (!$good) {
-         for (my $n=0; $n < $nmax; $n++) {
-	   my $l = defined($out->[$n]) ? $out->[$n] : "~";
-	   chomp $l;
-	   my $r = defined($result->[$n]) ? $result->[$n] : "~";
-	   chomp $r;
-	   print sprintf("%-37s %s %-39s\n", $l, $l eq $r ? "|" : "?", $r);
-         }
-       } elsif ($opt_v) {
-	 print join('', @$result);
-       }
-}
-
 
 sub su($) {
   my ($user) = @_;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
