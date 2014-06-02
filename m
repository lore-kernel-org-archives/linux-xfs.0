Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E80C37F54
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 18:32:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66EC1AC002
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 16:32:38 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id bhZhf2v9pgVbC85S (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 16:32:36 -0700 (PDT)
Date: Mon, 2 Jun 2014 19:32:12 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Message-ID: <20140602233212.GA2060@thunk.org>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
	<4178301.j9kWdGCRLC@wuerfel>
	<6868F108-F0B2-423F-AE31-90DF86A5B7DD@oracle.com>
	<20140602153124.GH30598@thunk.org> <538CB085.5000502@zytor.com>
	<20140602222954.GA29690@thunk.org> <538CFB83.20703@zytor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <538CFB83.20703@zytor.com>
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
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, LKML Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Chuck Lever <chuck.lever@oracle.com>, john.stultz@linaro.org, lftan@altera.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, geert@linux-m68k.org, tglx@linutronix.de, joseph@codesourcery.com

On Mon, Jun 02, 2014 at 03:32:35PM -0700, H. Peter Anvin wrote:
> On 06/02/2014 03:29 PM, Theodore Ts'o wrote:
> > 
> > And since we are already returning (time_t) -1 in some cases, we might
> > as well try to make things a bit more formal.
> > 
> 
> Are we?  I am not aware of *Linux* actually using that.

Linux's time(2) can return (time_t) -1 and set errno to EFAULT, per
the Posix specification:

SYSCALL_DEFINE1(time, time_t __user *, tloc)
{
	time_t i = get_seconds();

	if (tloc) {
		if (put_user(i,tloc))
			return -EFAULT;
	}
	force_successful_syscall_return();
	return i;
}

Cheers,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
