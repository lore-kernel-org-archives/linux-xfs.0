Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p563lmGA200129
	for <linux-xfs@oss.sgi.com>; Sun, 5 Jun 2011 22:47:48 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FF041662030
	for <linux-xfs@oss.sgi.com>; Sun,  5 Jun 2011 20:47:45 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ZSVzicCGTgALii07 for <linux-xfs@oss.sgi.com>;
	Sun, 05 Jun 2011 20:47:45 -0700 (PDT)
Message-ID: <4DEC4DE0.5090503@sandeen.net>
Date: Sun, 05 Jun 2011 22:47:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: altering defaults
References: <8762onaq19.fsf@psinom.home>
In-Reply-To: <8762onaq19.fsf@psinom.home>
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
To: prad <prad@towardsfreedom.com>
Cc: linux-xfs@oss.sgi.com

On 6/3/11 10:33 AM, prad wrote:
> i'm new to xfs (courtesy of most helpful and encouraging commentary by
> stan hoeppner!) and i've seen some advice which says to make the 
> block size     -> 512
> directory size -> 4096
> 
> on the other hand, i've also come across webpages which say don't mess
> around! keep the defaults as they are unless you are absolutely sure
> that changing it suits your purpose and know why.

Yup.  See "Q: I want to tune my XFS filesystems for <something> "
http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

> my question is for the data storage area on a web/email server. we're
> mainly going to have small files there and the email part will have only
> temporary files for the most part since people will download (ie pop).
> 
> it makes sense to make the block size = 512, but i wonder if it really
> matters noticeably. the server is not a heavily visited one and only on
> very rare occasions will we get around 50000 hits/day - most of the time
> we're looking at under 10000 and that is with all the domains combined.

If space efficiency is a consideration then smaller blocksizes might
be useful.  Not so much for hits per day, but for how many files you expect
to store at any one time; you'll waste ((blocksize / 2) * nr files) on average.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
