Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 03:18:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4KAIUhQ029109
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 03:18:32 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BE53BA0929
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 03:19:19 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 66dyOcifpQMGXoze for <xfs@oss.sgi.com>; Tue, 20 May 2008 03:19:19 -0700 (PDT)
Date: Tue, 20 May 2008 06:19:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS filesystem reports as full though it isn't
Message-ID: <20080520101918.GA24579@infradead.org>
References: <20080516222755.3e557c00@galadriel.home> <20080518131855.GA1383@infradead.org> <20080518132127.GA19006@infradead.org> <20080518154208.77b6be3e@galadriel.home> <20080519221057.75e0a775@galadriel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519221057.75e0a775@galadriel.home>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, May 19, 2008 at 10:10:57PM +0200, Emmanuel Florac wrote:
> Le Sun, 18 May 2008 15:42:08 +0200 vous ?criviez:
> 
> > IIRC I tried both, however I'll double check monday...
> 
> Well obviously I didn't try both, because it worked as expected when
> using "inode64".

I've submitted a patch that should give back an error when remounting
with an option not supported in remount, that should fix this little
oversight in the future.  Thanks for the report!
