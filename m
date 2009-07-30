Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6UFV0Uf081723 for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 10:31:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D9EA14286D0
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2009 08:31:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2P9vTanSlIm8fIQZ for
	<xfs@oss.sgi.com>; Thu, 30 Jul 2009 08:31:47 -0700 (PDT)
Date: Thu, 30 Jul 2009 11:31:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs project quota question
Message-ID: <20090730153147.GA31935@infradead.org>
References: <7dc591420907300249w76835ee5v4d5764dcadd71fa6@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <7dc591420907300249w76835ee5v4d5764dcadd71fa6@mail.gmail.com>
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
To: Erik Gulliksson <erik.gulliksson@diino.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Thu, Jul 30, 2009 at 11:49:54AM +0200, Erik Gulliksson wrote:
> Hi,
> 
> We have recently started to use XFS for our production storage servers
> (coming from ZFS and Lustre/ext3) and are now considering activating
> project quota on quite massive scale. For our setup there would be
> between 10k and 100k "project directories" per filesystem, each with
> up to 1T data and up to 1M number of files. Would this even be
> feasible to consider? Have anyone done any tests with a big number of
> project quotas for an xfs file system? How well does it scale?

Project quotas scale exactly the same way as user or group quotas.  10k
different IDs defintively should be fine.  100k different IDs might run
into scaling problems with the in-core quota hash, but that's something
only limited by choice of a hash-table for the in-memory lookup and
could be easily fixed by switching to a smarter data structure which we
could fix short-term given sufficient enough interest.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
