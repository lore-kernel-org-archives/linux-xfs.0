Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EBB6529E09
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 12:30:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88215AC005
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 10:30:05 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id KKHQGlLKA3xBfqrZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 May 2013 10:30:04 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2E5609A0687
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 11:30:04 -0600 (MDT)
Date: Fri, 3 May 2013 13:30:01 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
Message-ID: <20130503173001.GC12414@localhost.localdomain>
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
	<5183AD53.7030403@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5183AD53.7030403@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, Josef Bacik <JBacik@fusionio.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, May 03, 2013 at 06:28:03AM -0600, Rich Johnston wrote:
> Josef,
> 
> The patch does not compile on older kernels (i.e. SLES11 SP2).
> 
> fsync-tester.c: In function 'test_three':
> fsync-tester.c:133: warning: implicit declaration of function 'syncfs'
> /tmp/cciHR6Gb.o: In function `test_three':
> /data/lwork/gulag1c/rjohnston/xfstests/src/fsync-tester.c:133: undefined 
> reference to `syncfs'
> collect2: ld returned 1 exit status
> gmake[3]: *** [fsync-tester] Error 1
> gmake[2]: *** [src] Error 2
> make[1]: *** [default] Error 2
> make: *** [default] Error 2
> 
> 
> src/fsync-tester.c
> 133                                 syncfs(test_fd);
> Typo ?????                          ^^^^^^
> Did you mean fsync?
> 

Argh crap I should have noticed this in the manpage

syncfs() first appeared in Linux 2.6.39

You can just replace it with sync(), or do you want me to resend the patch with
that change?  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
