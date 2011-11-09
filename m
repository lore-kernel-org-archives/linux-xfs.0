Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA9ESo9p233247
	for <linux-xfs@oss.sgi.com>; Wed, 9 Nov 2011 08:28:50 -0600
Received: from exprod7og115.obsmtp.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0FC5956B01E
	for <linux-xfs@oss.sgi.com>; Wed,  9 Nov 2011 06:28:49 -0800 (PST)
Received: from exprod7og115.obsmtp.com (exprod7og115.obsmtp.com [64.18.2.217])
	by cuda.sgi.com with SMTP id sBrBpBWm30PScthS for
	<linux-xfs@oss.sgi.com>; Wed, 09 Nov 2011 06:28:49 -0800 (PST)
Received: by mail-yw0-f43.google.com with SMTP id 17so2179930ywp.2
	for <linux-xfs@oss.sgi.com>; Wed, 09 Nov 2011 06:28:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADDb1s20M0w+yFGa8G=KbAZ6wL4Hj7WUxR0w+hzRH9BCgFWpLQ@mail.gmail.com>
References: <loom.20111108T180925-222@post.gmane.org>
	<CADDb1s20M0w+yFGa8G=KbAZ6wL4Hj7WUxR0w+hzRH9BCgFWpLQ@mail.gmail.com>
Date: Wed, 9 Nov 2011 08:28:48 -0600
Message-ID: <CAGedfzkL=jHRLBKus6KsM4e8aCi9MYuJQhU5o0q4SGR6WHSRpg@mail.gmail.com>
Subject: Re: XFS realtime O_DIRECT failures
From: Alan Cook <acook@visionpointsystems.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: linux-xfs@oss.sgi.com

On Tue, Nov 8, 2011 at 11:20 PM, Amit Sahrawat
<amit.sahrawat83@gmail.com> wrote:
> In my opinion, this is not the way to allocate memory and use for
> O_DIRECT approach. Instead you can make use of valloc() or
> posix_memalign()/memalign
> Or if you are still using malloc() - then you probably did the right
> thing by allocating for alignment like malloc(size + 4096);
> but, store this is permanent pointer and make use of aligned pointer :
> perm_pointer = malloc(size +4096);
> For aligning you need an expression like this:
> align_pointer = (perm_pointer + 4096) & ~(4095);// If you wish to
> align for 512, do it like (p+512) & ~(511);

Thanks.  I adjusted the test application, but still see the bug with
RT subvolumes and direct writes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
