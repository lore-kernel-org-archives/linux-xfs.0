Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 11B7B7F4E
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 04:48:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E2B3F8F8035
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 02:48:04 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 0vWgB409D9yT6ZWa (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Oct 2014 02:48:02 -0700 (PDT)
Date: Mon, 27 Oct 2014 02:48:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: enable sparse checking
Message-ID: <20141027094800.GB31604@infradead.org>
References: <54498F4A.9030207@redhat.com>
	<20141024061718.GA15341@infradead.org>
	<544A59F7.4070601@sandeen.net>
	<20141024154058.GA10788@infradead.org>
	<544A74E7.1060502@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <544A74E7.1060502@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 24, 2014 at 10:48:55AM -0500, Eric Sandeen wrote:
> On 10/24/14 10:40 AM, Christoph Hellwig wrote:
> > strong opinion.  It's not like your patch prevents me from using CC=cgcc
> 
> To get endian checking with your method, you'd need to edit
> the Makefile to add the -D define, right?

That's a kernel special, I just did a test run using CC=cgcc and I get
endianess warnings:

rdwr.c:190:21: warning: incorrect type in assignment (different base types)
rdwr.c:190:21:    expected restricted __le32 [usertype] h_crc
rdwr.c:190:21:    got restricted __be32 [usertype] <noident>

log_misc.c:621:59: warning: cast to restricted __be64
log_misc.c:621:59: warning: cast to restricted __be64
log_misc.c:621:59: warning: cast to restricted __be64
log_misc.c:621:59: warning: cast to restricted __be64
log_misc.c:621:59: warning: cast to restricted __be64
log_misc.c:621:59: warning: cast to restricted __be64
log_misc.c:621:59: warning: cast to restricted __be64
log_misc.c:621:59: warning: cast to restricted __be64
log_misc.c:621:59: warning: cast to restricted __be64
log_misc.c:621:59: warning: cast to restricted __be64

There's also tons of noise that should be easily upgradeable, but let me
check latests xfsprogs first..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
