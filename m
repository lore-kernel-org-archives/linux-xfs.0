Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 612427F6F
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 11:21:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4BE84304043
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 09:21:41 -0700 (PDT)
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	by cuda.sgi.com with ESMTP id uCirqO0UVckX3E7a (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 09:21:39 -0700 (PDT)
Received: from g4t3433.houston.hp.com (g4t3433.houston.hp.com [16.210.25.219])
	by g4t3425.houston.hp.com (Postfix) with ESMTP id 262762E4
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 16:21:37 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [16.84.84.24])
	by g4t3433.houston.hp.com (Postfix) with ESMTP id 0FCE175
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 16:21:36 +0000 (UTC)
Date: Tue, 17 Jun 2014 11:20:44 -0500
From: scameron@beardog.cce.hp.com
Subject: xfstests, weird looking code in src/resvtest.c
Message-ID: <20140617162044.GL29459@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: scameron@beardog.cce.hp.com


This code in xfstests src/resvtest.c looks pretty strange:

...
 32         char            *readbuffer, *writebuffer;
...
 70         readbuffer = memalign(psize, bsize);
 71         writebuffer = memalign(psize, bsize);
 72         if (!readbuffer || !writebuffer) {
 73                 perror("open");
 74                 exit(1);
 75         }
 76         memset(writebuffer, 'A', sizeof(writebuffer));

^^^ writebuffer is a pointer, so using sizeof(writebuffer) here is
odd. Is it intentional to put either 4 or 8 A's into writebuffer
depending on sizeof a pointer?  Seems unlikely.

110         while (++n < iterations) {
111                 char *p;
112                 int numerrors;
113 
114                 if (write(writefd, writebuffer, sizeof(writebuffer)) < 0) {
115                         perror("write");
116                         exit(1);
117                 }

So that write will write sizeof a pointer's worth of whatever's in writebuffer.
Intentional?  Again, seems unlikely.

This seems like maybe somebody initially declared writebuffer as an array, but
later went back and changed it to a pointer, but forgot to fixup everywhere that
referred to sizeof(writebuffer).

I would have sent a patch but I'm not sure what this code is trying to do.

gcc 4.4.7 (what comes with RHEL6u5) doesn't warn about this, but 4.8.3 does.

-- steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
