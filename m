Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4Q2whrb056166 for <xfs@oss.sgi.com>; Tue, 25 May 2010 21:58:43 -0500
Received: from kaylee.flamingspork.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8D31129E5A9
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 20:02:48 -0700 (PDT)
Received: from kaylee.flamingspork.com (kaylee.flamingspork.com
	[74.207.245.61]) by cuda.sgi.com with ESMTP id BpwtkzfBTSx1CvjG
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 20:02:48 -0700 (PDT)
From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: xfsdump -- not enough memory to dump attributes? w/>20G free --
	how much does it need?
In-Reply-To: <20100525164244.GB18666@infradead.org>
References: <4BF7D787.4020903@tlinx.org> <20100525164244.GB18666@infradead.org>
Date: Wed, 26 May 2010 13:01:03 +1000
Message-ID: <87zkznicy8.fsf@willster.local.flamingspork.com>
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
To: Christoph Hellwig <hch@infradead.org>, "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, 25 May 2010 12:42:44 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, May 22, 2010 at 06:09:27AM -0700, Linda A. Walsh wrote:
> > I've seen the problem in the dump below and was wondering what could  
> > possibly cause this -- because
> > shows loads of free memory (>20G)...  how much memory do non-root  
> > attributes take to dump?
> 
> The error comes directly from the libhandle listing routine, which
> is a straight forward wrapper around the kernel syscall in current
> xfsprogs.
> 
> What xfsprogs version are you using?  I noticed your xfsdump is
> rather old, so making sure you have recent XFS userspace and
> possibly also the kernel would help debugging this.

I just saw this last night. All from ubuntu lucid:
xfsdump 3.0.4
Linux willster 2.6.32-22-generic #33-Ubuntu SMP Wed Apr 28 13:28:05 UTC 2010 x86_64 GNU/Linux

> Also can you check using strace if the ENOMEM comes directly from
> the attr_list_by_handle ioctl?

Will try another dump tonight with strace on and see if i get it.

-- 
Stewart Smith

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
