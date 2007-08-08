Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 21:16:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l784Gbbm020786
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 21:16:38 -0700
Message-ID: <46B943AB.10807@sandeen.net>
Date: Tue, 07 Aug 2007 23:16:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: qa 166 failure on f8 kernel
References: <46B91EBA.10407@sandeen.net> <20070808025615.GH52011508@sgi.com> <46B9316A.40508@sandeen.net> <20070808040804.GJ52011508@sgi.com> <46B94259.6060309@sandeen.net>
In-Reply-To: <46B94259.6060309@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:

> David Chinner wrote:
>
>   
>> On Tue, Aug 07, 2007 at 09:58:50PM -0500, Eric Sandeen wrote:
>>   
>>     
>>> yeah, figured it had something to do w/ the ia64 weenies when I saw the
>>> 32 vs. 8, factor of 4 ... fine, fine, my bad.  :)
>>>     
>>>       
>> No, not your bad. Mine if anyones because I wrote the test.
>>
>> Cheers,
>>
>> Dave.
>>   
>>     
> Well, I was going to look at it more closely before I sent it off :)
>
> What do you think of a patch like this, to munmap 16k chunks regardless
> of page size:
>   
Er, bad patch-ninja-boy, don't hand-edit  :)



--- src/unwritten_mmap.c.orig	2007-08-07 22:53:08.962031839 -0500
+++ src/unwritten_mmap.c	2007-08-07 23:04:14.230540957 -0500
@@ -12,6 +12,7 @@
  */
 int main(int argc, char **argv) {
 	unsigned long long o;
+	int minsize;
 	int fd, i;
 	struct xfs_flock64 space;
 	unsigned char *buf;
@@ -23,6 +24,13 @@
 
 	errno = 0;
 	o = strtoull(argv[1], NULL, 0);
+
+	minsize = 3*16384; /* 3 ia64 pages */
+	if (o < minsize) {
+		fprintf(stderr, "count must be at least %d\n", minsize);
+		exit(1);
+	}
+
 	if (errno) {
 		perror("strtoull");
 		exit(errno);
@@ -55,9 +63,9 @@
 			perror("mmap()");
 			exit(5);
 		} else {
-			buf[o-1] = 0;
-			buf[o/2] = 0;
-			buf[0] = 0;
+			memset(buf, 0, 16384);
+			memset(buf+o/2, 0, 16384);
+			memset(buf+o-16384, 0, 16384);
 			munmap(buf, o);
 		}

 
