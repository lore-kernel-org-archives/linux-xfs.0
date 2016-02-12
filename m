Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8004E7CA5
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 13:47:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B7AD6AC007
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:47:53 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Z04C53E2oJMYp2dz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:47:52 -0800 (PST)
Date: Fri, 12 Feb 2016 13:47:49 -0600
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH v4 1/2] libxcmd: generalize topology functions
Message-ID: <20160212194749.GA10069@redhat.com>
References: <1455303811-9874-1-git-send-email-billodo@redhat.com>
	<1455303811-9874-2-git-send-email-billodo@redhat.com>
	<20160212193942.GA4770@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160212193942.GA4770@infradead.org>
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

On Fri, Feb 12, 2016 at 11:39:42AM -0800, Christoph Hellwig wrote:
> On Fri, Feb 12, 2016 at 01:03:30PM -0600, Bill O'Donnell wrote:
> > Move general topology functions from xfs_mkfs to new topology
> > collection in libxcmd.
> 
> Why libxcmd and not libxfs?

We discussed that a bit. Since libxfs has the kernel support code, and
not generally the xfsprogs library, I put it in libxcmd.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
