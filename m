Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9143529DF8
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 17:19:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F342AC005
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 15:19:11 -0700 (PDT)
Received: from mail-qc0-f182.google.com (mail-qc0-f182.google.com
	[209.85.216.182]) by cuda.sgi.com with ESMTP id
	rGvqGdBKmJd4f7lG (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <linux-xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 15:18:41 -0700 (PDT)
Received: by mail-qc0-f182.google.com with SMTP id e10so2423643qcy.27
	for <linux-xfs@oss.sgi.com>; Tue, 11 Jun 2013 15:18:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130611215716.GA6935@citd.de>
References: <loom.20130611T112155-970@post.gmane.org>
	<20130611193525.GT20932@sgi.com>
	<CAO9HMNEt4XKdV6+jfKwHVPrDaVNytx65MQDK52Uckcy-O6YikQ@mail.gmail.com>
	<20130611215716.GA6935@citd.de>
Date: Tue, 11 Jun 2013 17:18:40 -0500
Message-ID: <CAO9HMNFQy8fTqp3k39NuiSSF6AfivLpo=h3GXnt=VQQ1zg2CTQ@mail.gmail.com>
Subject: Re: Questions about XFS
From: Steve Bergman <sbergman27@gmail.com>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: linux-xfs@oss.sgi.com

That's a very interesting idea, using inotify. But I'd prefer to keep
it a little simpler. Using ext3 for the main data tree and XFS for the
work file directory really seems perfect. Although it gives me an
option that was never feasible before. And that would be to mount ext3
data=journal. Without XFS to do the heavy listing in the work dir,
that would make certain operations (very) unreasonably slow. But with
the hybrid fs configuration, it would only slow down EOD posting a
bit. I mounted data=journal at one site, for one day the other day,
and nobody complained. That would be the "correct" solution from a
data integrity standpoint. But I've always found ext3 & data=ordered
to be quite adequate for this application.

-Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
