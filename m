Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7D83B7F54
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 17:35:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F263AC007
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 15:35:49 -0700 (PDT)
Received: from mail.zytor.com ([198.137.202.10]) by cuda.sgi.com with ESMTP id
	9sBsRYtO1oyygCS6 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 15:35:48 -0700 (PDT)
Message-ID: <538CFB83.20703@zytor.com>
Date: Mon, 02 Jun 2014 15:32:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
	<8618458.1EVJCoVbkH@wuerfel>
	<alpine.LFD.2.11.1406012121430.17310@knanqh.ubzr>
	<4178301.j9kWdGCRLC@wuerfel>
	<6868F108-F0B2-423F-AE31-90DF86A5B7DD@oracle.com>
	<20140602153124.GH30598@thunk.org> <538CB085.5000502@zytor.com>
	<20140602222954.GA29690@thunk.org>
In-Reply-To: <20140602222954.GA29690@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>, Chuck Lever <chuck.lever@oracle.com>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nicolas.pitre@linaro.org>, Dave Chinner <david@fromorbit.com>, LKML Kernel <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, joseph@codesourcery.com, john.stultz@linaro.org, Christoph Hellwig <hch@infradead.org>, tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, Linux NFS Mailing List <linux-nfs@vger.kernel.org>

On 06/02/2014 03:29 PM, Theodore Ts'o wrote:
> 
> And since we are already returning (time_t) -1 in some cases, we might
> as well try to make things a bit more formal.
> 

Are we?  I am not aware of *Linux* actually using that.

	-hpa


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
