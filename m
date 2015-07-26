Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC6F27F88
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 11:25:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 476BFAC003
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 09:25:31 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id xJQySlszNqn9hbPa (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 09:25:30 -0700 (PDT)
Date: Sun, 26 Jul 2015 09:25:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] xfsprogs: blkid is now mandatory
Message-ID: <20150726162530.GE29329@infradead.org>
References: <1156743222.24471614.1436281858017.JavaMail.zimbra@redhat.com>
	<1436346893-11831-1-git-send-email-jtulak@redhat.com>
	<1508777144.956841.1437482376774.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1508777144.956841.1437482376774.JavaMail.zimbra@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, sandeen@redhat.com, xfs@oss.sgi.com

On Tue, Jul 21, 2015 at 08:39:36AM -0400, Jan Tulak wrote:
> I just found that while it is possible to get blkid on OS X, it is
> in 1.0.0 version which doesn't have blkid_probe_get function.
> I'm examining whether it is possible to get an updated version there,
> but right now, this patch breaks OS X support. Unfortunately I didn't
> noticed of this before, as the OS X port was terribly out of date.
> 
> So this patch shouldn't be included until I find how to get around.

I don't think this is a lbocker given that OSX support doesn't
even work.

To the contrary I'd really prefer to go in ASAP to avoid anyone
relying on it longer than nessecary.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
