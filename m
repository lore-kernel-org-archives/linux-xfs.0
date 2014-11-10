Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 39D5C7F5A
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 03:14:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 27F408F8037
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 01:14:12 -0800 (PST)
Received: from mail-qa0-f52.google.com (mail-qa0-f52.google.com
	[209.85.216.52]) by cuda.sgi.com with ESMTP id UsxXQh7g0laILqLb
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 10 Nov 2014 01:14:10 -0800 (PST)
Received: by mail-qa0-f52.google.com with SMTP id u7so4939447qaz.39
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 01:14:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141107190959.GB21021@infradead.org>
References: <20141107190959.GB21021@infradead.org>
Date: Mon, 10 Nov 2014 10:14:09 +0100
Message-ID: <CAJfpegsiJfYKv9ySH5fKPjDszy+26XFTM48T_gNTFr7rzp-U5g@mail.gmail.com>
Subject: Re: beginners project: RENAME_WHITEOUT
From: Miklos Szeredi <miklos@szeredi.hu>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Nov 7, 2014 at 8:09 PM, Christoph Hellwig <hch@infradead.org> wrote:
> The overlayfs merge introduces a new rename flag to create to whiteouts.
> Should be a fairly easy to implement.
>
> Miklos, do you have any good documentation and/or test cases for this?

No test case for the RENAME_WHITEOUT flag yet.  I'll work on that.

We do have a man page and an xfstest test case for RENAME_EXCHANGE,
which is also important for overlayfs.

Thanks,
Miklos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
