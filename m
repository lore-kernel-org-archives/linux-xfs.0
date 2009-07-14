Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6ECF8EN108643 for <xfs@oss.sgi.com>; Tue, 14 Jul 2009 07:15:08 -0500
Date: Tue, 14 Jul 2009 14:15:42 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 1/2] fs/xfs: Drop unnecessary NULL test
In-Reply-To: <bzy7hybzh6k.fsf@fransum.emea.sgi.com>
Message-ID: <Pine.LNX.4.64.0907141412550.456@ask.diku.dk>
References: <Pine.LNX.4.64.0907131209250.6808@ask.diku.dk>
	<bzy7hybzh6k.fsf@fransum.emea.sgi.com>
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
To: Olaf Weber <olaf@sgi.com>
Cc: xfs-masters@oss.sgi.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, 14 Jul 2009, Olaf Weber wrote:

> Julia Lawall writes:
> 
> > From: Julia Lawall <julia@diku.dk>
> > The result of container_of should not be NULL.  In particular, in this case
> > the argument to the enclosing function has passed though INIT_DELAYED_WORK,
> > which dereferences it, implying that its container cannot be NULL.
> 
> Given the defn of container_of() it seems clear that neither its input
> pointer nor its result should ever be NULL.

container_of just does pointer arithmetic.  The result of that arithmetic 
can be NULL, ie if the argument was obtained from an expression of the 
form &x->f where x was NULL.  But in principle, values should be checked 
for NULL beforehand.

julia

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
