Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DGaSJn023356 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 10:36:28 -0600
Message-ID: <4F393C08.6000801@sgi.com>
Date: Mon, 13 Feb 2012 10:36:24 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfsdump: use the full 32-bit generation number
References: <1328813180-29095-1-git-send-email-wkendall@sgi.com>
	<20120212234720.GA3848@infradead.org>
In-Reply-To: <20120212234720.GA3848@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 02/12/2012 05:47 PM, Christoph Hellwig wrote:
> Looks generally good to me, but is there any good reason to not make
> the -K argument extensible by requiring a version argument, even if
> that one currently only supports 2 and 3 as valid values?

I thought about doing that, but given the low frequency of format
changes decided it could wait until there's more than one old format
to support. -K without an argument could be treated as "generate
the previous media format", or with an argument it could generate
a specific format. I'm okay with requiring a version argument though,
being explicit is better.

FWIW, the way things have always worked is that xfsrestore provides
backwards compatibility for all dump formats. xfsdump has, until
now, always generated the current format. It's nice to provide
the ability to generate old formats during a transition period,
but long-term I don't see xfsdump retaining support for generating
all old formats.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
