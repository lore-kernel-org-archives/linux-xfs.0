Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3H8JtI3034038 for <xfs@oss.sgi.com>; Tue, 17 Apr 2012 03:19:56 -0500
Received: from mail.profihost.ag (mail.profihost.ag [85.158.179.208]) by
	cuda.sgi.com with ESMTP id uvMWSqDXdIxVVEEF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Apr 2012 01:19:53 -0700 (PDT)
Message-ID: <4F8D27A1.2090809@profihost.ag>
Date: Tue, 17 Apr 2012 10:19:45 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: XFS blocked task in xlog_cil_force_lsn
References: <4F8BC0B9.90604@profihost.ag> <20120416235647.GA6734@dastard>
In-Reply-To: <20120416235647.GA6734@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Philipp Herz - Profihost AG <p.herz@profihost.ag>, stable@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 17.04.2012 01:56, schrieb Dave Chinner:
> Your first question should be: is this a known problem?
> And the answer to that is: I don't think so.
Sorry absolutely correct.

> So, is the system actually hung?
No. The kernel has ended the stalled request.

> Were there IO errors around this time?
No.

> did the system recover and continue to work normally?
Yes.

> What's your storage hardware, application, workload, etc?
It a Raid 10 of 1TB SATA Drives in front of a 3Ware Controller doing
heavy rsync backups.

Greets
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
