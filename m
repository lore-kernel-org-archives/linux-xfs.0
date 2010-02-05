Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o15GwbcF149741 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 10:58:37 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84F381B362F
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2010 08:59:46 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id uMLCSLTs42ANFRsO for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2010 08:59:46 -0800 (PST)
Message-ID: <4B6C4E81.6060201@sandeen.net>
Date: Fri, 05 Feb 2010 10:59:45 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix up fs_perms test used by 126
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Theodore Tso <tytso@mit.edu>

Test 126 was failing intermittently for Ted & I; it seems that
this is because we were passing an unterminated string to
fopen for the mode; I'm not certain why this made it fail,
but it's pretty clearly not a good thing to do, and fixing
it fixes the test.

Rather than passing around characters, do things string-wise,
since that is what is ultimately used in fopen().

Also make it at least possible to pass in the 2-character
modes fopen can take (r+, w+, etc), I suppose testcases
could be added for this later.

Reported-by: Theodore Tso <tytso@mit.edu>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/src/fs_perms.c b/src/fs_perms.c
index 2c5e3fa..f34c4f4 100644
--- a/src/fs_perms.c
+++ b/src/fs_perms.c
@@ -42,7 +42,7 @@ int testsetup(mode_t mode, int cuserId, int cgroupId);
 int testfperm(int userId, int groupId, char* fperm);
 
 int main( int argc, char *argv[]) {
-   char fperm[1];
+   char fperm[3];
    int result, exresult=0,  cuserId=0, cgroupId=0, userId=0, groupId=0;
    mode_t mode;
 
@@ -53,7 +53,8 @@ int main( int argc, char *argv[]) {
               cgroupId = atoi(argv[3]);
               userId = atoi(argv[4]);
               groupId = atoi(argv[5]);
-              fperm[0] = *argv[6];
+              strncpy(fperm, argv[6], 3);
+              fperm[2] = '\0';
               exresult = atoi(argv[7]);
 	      break;
       default:
@@ -64,7 +65,7 @@ int main( int argc, char *argv[]) {
    testsetup(mode,cuserId,cgroupId);
    result=testfperm(userId,groupId,fperm);
    system("rm test.file");
-   printf("%c a %03o file owned by (%d/%d) as user/group(%d/%d)  ",fperm[0],mode,cuserId,cgroupId,userId,groupId);
+   printf("%s a %03o file owned by (%d/%d) as user/group(%d/%d)  ",fperm,mode,cuserId,cgroupId,userId,groupId);
    if (result == exresult) {
       printf("PASS\n");
       exit(0);
@@ -102,8 +103,7 @@ int testfperm(int userId, int groupId, char* fperm) {
            return(-1);
         }
 
-    switch(tolower(fperm[0])) {
-       case 'x': 
+    if (!strcmp("x", fperm)) {
           PID = fork();
 	  if (PID == 0) {
              execlp("./test.file","test.file",NULL); 
@@ -114,8 +114,7 @@ int testfperm(int userId, int groupId, char* fperm) {
           seteuid(0);
           setegid(0);
 	  return(nuthertmpi);
-
-       default: 
+    } else {
           if((testfile=fopen("test.file",fperm))){
             fclose(testfile);
             seteuid(0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
