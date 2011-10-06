Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96JlvUA198238 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 14:47:57 -0500
Subject: Re: [PATCH 4/6] xfsprogs: libxcmd: isolate strdup() calls to
	fs_table_insert()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111006194514.GB13434@infradead.org>
References: <4a7a9e630aa7c62357a606f762abc19fc1d7073b.1317646036.git.aelder@sgi.com>
	<0f871eebf39384818415253082320f860739f113.1317646036.git.aelder@sgi.com>
	<20111006194514.GB13434@infradead.org>
Date: Thu, 6 Oct 2011 14:47:52 -0500
Message-ID: <1317930472.2870.21.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 2011-10-06 at 15:45 -0400, Christoph Hellwig wrote:
...

> If you touch these anyway please move assignments outside the
> conditionals, e.g.

OK.  No problem.  I was opting for less indent depth
but *almost* did what you say in the first place...

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
